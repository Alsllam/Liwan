import 'dart:math';

import '../game.dart';
import '../result.dart';
import 'evaluator.dart';

/// Scores a move for move ordering: higher is searched first.
///
/// Good ordering (captures first, most valuable victim first) makes
/// alpha-beta much faster. Pure function, game knowledge.
typedef MoveScorer<S, M> = int Function(S state, M move);

/// True for "noisy" moves (usually captures and promotions) that quiescence
/// search keeps exploring past the depth limit, so the engine does not stop
/// in the middle of an exchange.
typedef NoisyMove<S, M> = bool Function(S state, M move);

/// Limits for one search. The search stops at whichever comes first.
class SearchLimits {
  const SearchLimits({this.maxDepth = 64, this.maxNodes, this.maxTime});

  /// Maximum nominal depth in plies (quiescence may go further).
  final int maxDepth;

  /// Maximum number of visited nodes.
  final int? maxNodes;

  /// Maximum thinking time.
  final Duration? maxTime;
}

/// A root move with its score from the mover's point of view.
class ScoredMove<M> {
  const ScoredMove(this.move, this.score);

  final M move;
  final int score;

  @override
  String toString() => '$move: $score';
}

/// What a search found.
class SearchResult<M> {
  const SearchResult({
    required this.bestMove,
    required this.score,
    required this.depth,
    required this.nodes,
    required this.rootMoves,
  });

  /// The best move found, or null when the position has no legal moves.
  final M? bestMove;

  /// Score of [bestMove] for the side to move.
  final int score;

  /// Deepest fully completed iteration.
  final int depth;

  /// Nodes visited, including quiescence nodes.
  final int nodes;

  /// Every root move with its score from the last completed iteration,
  /// best first. With `exactRootScores: true` every score is exact.
  /// Otherwise the scores of moves tied with the best are exact and every
  /// other move's score is an upper bound strictly below the best.
  final List<ScoredMove<M>> rootMoves;
}

class _Abort implements Exception {
  const _Abort();
}

const _exact = 0, _lower = 1, _upper = 2;

class _TtEntry<M> {
  _TtEntry(this.key, this.depth, this.score, this.flag, this.move);

  final int key;
  final int depth;
  final int score;
  final int flag;
  final M? move;
}

/// Negamax alpha-beta search with iterative deepening, a transposition
/// table, move ordering and optional quiescence search.
///
/// Works with any [Game] through the shared interface only. One instance
/// may be reused for many searches; the transposition table is kept between
/// searches of the same game.
class AlphaBetaSearch<S extends Object, M extends Object> {
  AlphaBetaSearch({
    required this.game,
    required this.evaluate,
    this.moveScorer,
    this.isNoisy,
    this.stateKey,
    this.maxQuiescenceDepth = 8,
    int tableSize = 1 << 18,
  })  : _table = List<_TtEntry<M>?>.filled(tableSize, null),
        _mask = tableSize - 1 {
    if (tableSize & (tableSize - 1) != 0) {
      throw ArgumentError.value(
          tableSize, 'tableSize', 'must be a power of two');
    }
  }

  final Game<S, M> game;
  final Evaluator<S> evaluate;
  final MoveScorer<S, M>? moveScorer;
  final NoisyMove<S, M>? isNoisy;

  /// Hash key of a state; defaults to `state.hashCode`.
  final int Function(S state)? stateKey;
  final int maxQuiescenceDepth;

  final List<_TtEntry<M>?> _table;
  final int _mask;
  int _nodes = 0;
  SearchLimits _limits = const SearchLimits();
  Stopwatch? _clock;

  /// Clears the transposition table (e.g. after a variant change).
  void clear() => _table.fillRange(0, _table.length, null);

  /// Searches [state] within [limits].
  ///
  /// With [exactRootScores], every root move is searched with a full
  /// window, so [SearchResult.rootMoves] holds exact scores for all of them.
  /// AI levels use this to pick among near-best moves.
  SearchResult<M> search(
    S state, {
    SearchLimits limits = const SearchLimits(maxDepth: 4),
    bool exactRootScores = false,
  }) {
    _nodes = 0;
    _limits = limits;
    _clock = limits.maxTime == null ? null : (Stopwatch()..start());

    final moves = game.legalMoves(state);
    if (moves.isEmpty || game.result(state).isOver) {
      return SearchResult(
          bestMove: null,
          score: _terminalScore(state, 0),
          depth: 0,
          nodes: 0,
          rootMoves: const []);
    }

    var completed = <ScoredMove<M>>[
      for (final m in _ordered(state, moves, null)) ScoredMove(m, 0),
    ];
    var depthDone = 0;

    for (var depth = 1; depth <= limits.maxDepth; depth++) {
      try {
        completed = _searchRoot(state, completed.map((s) => s.move).toList(),
            depth, exactRootScores);
        depthDone = depth;
      } on _Abort {
        break;
      }
      // A forced win or loss found: deeper search cannot change the choice.
      if (exactRootScores
          ? completed.every((m) => m.score.abs() >= winScore - 1000)
          : completed.first.score.abs() >= winScore - 1000) {
        break;
      }
      if (_outOfBudget()) break;
    }

    return SearchResult(
      bestMove: completed.first.move,
      score: completed.first.score,
      depth: depthDone,
      nodes: _nodes,
      rootMoves: completed,
    );
  }

  List<ScoredMove<M>> _searchRoot(
      S state, List<M> moves, int depth, bool exact) {
    var alpha = -winScore - 1;
    const beta = winScore + 1;
    final scored = <ScoredMove<M>>[];
    for (final move in moves) {
      final child = game.apply(state, move);
      final score = exact
          ? -_negamax(child, depth - 1, -beta, winScore + 1, 1)
          // alpha - 1 keeps ties with the best exact, so a fail-low score
          // can never be mistaken for an equally good move.
          : -_negamax(child, depth - 1, -beta, -(alpha - 1), 1);
      scored.add(ScoredMove(move, score));
      if (score > alpha) alpha = score;
    }
    // Stable sort keeps the previous iteration's order among equal scores.
    final indexed = scored.asMap().entries.toList()
      ..sort((a, b) {
        final c = b.value.score.compareTo(a.value.score);
        return c != 0 ? c : a.key.compareTo(b.key);
      });
    final result = [for (final e in indexed) e.value];
    _store(state, depth, result.first.score, _exact, result.first.move);
    return result;
  }

  int _negamax(S state, int depth, int alpha, int beta, int ply) {
    _tick();
    final result = game.result(state);
    if (result.isOver) return _scoreResult(state, result, ply);
    if (depth <= 0) return _quiescence(state, alpha, beta, ply, 0);

    final key = _key(state);
    final entry = _table[key & _mask];
    M? ttMove;
    if (entry != null && entry.key == key) {
      ttMove = entry.move;
      if (entry.depth >= depth) {
        final s = _fromTable(entry.score, ply);
        if (entry.flag == _exact) return s;
        if (entry.flag == _lower && s >= beta) return s;
        if (entry.flag == _upper && s <= alpha) return s;
      }
    }

    final moves = _ordered(state, game.legalMoves(state), ttMove);
    final alpha0 = alpha;
    var best = -winScore - 1;
    M? bestMove;
    for (final move in moves) {
      final score =
          -_negamax(game.apply(state, move), depth - 1, -beta, -alpha, ply + 1);
      if (score > best) {
        best = score;
        bestMove = move;
      }
      if (score > alpha) alpha = score;
      if (alpha >= beta) break;
    }
    final flag = best <= alpha0 ? _upper : (best >= beta ? _lower : _exact);
    _store(state, depth, _toTable(best, ply), flag, bestMove);
    return best;
  }

  int _quiescence(S state, int alpha, int beta, int ply, int qDepth) {
    _tick();
    final result = game.result(state);
    if (result.isOver) return _scoreResult(state, result, ply);
    final standPat = evaluate(state, game.toMove(state));
    final noisy = isNoisy;
    if (noisy == null || qDepth >= maxQuiescenceDepth) return standPat;
    if (standPat >= beta) return standPat;
    if (standPat > alpha) alpha = standPat;
    var best = standPat;
    final moves = game.legalMoves(state).where((m) => noisy(state, m)).toList();
    for (final move in _ordered(state, moves, null)) {
      final score = -_quiescence(
          game.apply(state, move), -beta, -alpha, ply + 1, qDepth + 1);
      if (score > best) best = score;
      if (score > alpha) alpha = score;
      if (alpha >= beta) break;
    }
    return best;
  }

  List<M> _ordered(S state, List<M> moves, M? first) {
    final scorer = moveScorer;
    final list = List<M>.of(moves);
    if (scorer != null) {
      final scores = {for (final m in list) m: scorer(state, m)};
      list.sort((a, b) => scores[b]!.compareTo(scores[a]!));
    }
    if (first != null) {
      final i = list.indexOf(first);
      if (i > 0) list.insert(0, list.removeAt(i));
    }
    return list;
  }

  int _scoreResult(S state, GameResult result, int ply) => switch (result) {
        Win(:final winner) =>
          winner == game.toMove(state) ? winScore - ply : -(winScore - ply),
        Draw() => 0,
        Ongoing() => 0,
      };

  int _terminalScore(S state, int ply) =>
      _scoreResult(state, game.result(state), ply);

  // Mate scores are stored relative to the node, so they stay correct when
  // the same position is reached at another ply.
  int _toTable(int score, int ply) => score >= winScore - 1000
      ? score + ply
      : (score <= -winScore + 1000 ? score - ply : score);

  int _fromTable(int score, int ply) => score >= winScore - 1000
      ? score - ply
      : (score <= -winScore + 1000 ? score + ply : score);

  int _key(S state) => stateKey?.call(state) ?? state.hashCode;

  void _store(S state, int depth, int score, int flag, M? move) {
    final key = _key(state);
    final i = key & _mask;
    final old = _table[i];
    if (old == null || old.key != key || depth >= old.depth) {
      _table[i] = _TtEntry(key, depth, score, flag, move);
    }
  }

  void _tick() {
    _nodes++;
    if ((_nodes & 1023) == 0 && _outOfBudget()) throw const _Abort();
  }

  bool _outOfBudget() {
    final maxNodes = _limits.maxNodes;
    if (maxNodes != null && _nodes >= maxNodes) return true;
    final clock = _clock;
    final maxTime = _limits.maxTime;
    return clock != null && maxTime != null && clock.elapsed >= maxTime;
  }
}

/// Picks a move from scored root moves for a weakened AI level.
///
/// Moves within [noise] of the best score are candidates; one is chosen at
/// random with [random]. With [noise] 0 the choice is among equally best
/// moves only, which keeps the AI varied without making it weaker.
M pickWithNoise<M>(List<ScoredMove<M>> rootMoves, int noise, Random random) {
  if (rootMoves.isEmpty) throw StateError('No moves to pick from.');
  final best = rootMoves.first.score;
  // Never throw away a forced win, and never choose a forced loss when
  // something else exists.
  if (best >= winScore - 1000) return rootMoves.first.move;
  final candidates = rootMoves
      .where((m) => m.score >= best - noise && m.score > -winScore + 1000)
      .toList();
  if (candidates.isEmpty) return rootMoves.first.move;
  return candidates[random.nextInt(candidates.length)].move;
}
