import 'dart:math';

import '../game.dart';
import 'alpha_beta.dart';
import 'evaluator.dart';
import 'mcts.dart';

/// One difficulty level of the AI opponent (see `docs/GDD.md` §5.2).
///
/// A level weakens the engine only through search budget and evaluation
/// noise; the rules are never changed.
class AiLevel {
  const AiLevel({
    required this.id,
    required this.maxDepth,
    required this.noise,
    this.maxTime,
    this.mctsIterations,
  });

  /// 1 (beginner) to 5 (master).
  final int id;

  /// Alpha-beta depth limit in plies.
  final int maxDepth;

  /// Moves scoring within [noise] of the best are picked at random.
  /// Units are the game's evaluation units.
  final int noise;

  /// Thinking time limit.
  final Duration? maxTime;

  /// When set, the level uses MCTS with this many iterations instead of
  /// alpha-beta (for games without a strong static evaluation).
  final int? mctsIterations;
}

/// The AI opponent: classic search over the shared interface. Never an LLM.
class AiPlayer<S extends Object, M extends Object> {
  AiPlayer({
    required this.game,
    required Evaluator<S> evaluate,
    required this.random,
    MoveScorer<S, M>? moveScorer,
    NoisyMove<S, M>? isNoisy,
    int Function(S state)? stateKey,
  })  : _alphaBeta = AlphaBetaSearch<S, M>(
          game: game,
          evaluate: evaluate,
          moveScorer: moveScorer,
          isNoisy: isNoisy,
          stateKey: stateKey,
        ),
        _mcts =
            MctsSearch<S, M>(game: game, random: random, evaluate: evaluate);

  final Game<S, M> game;
  final Random random;
  final AlphaBetaSearch<S, M> _alphaBeta;
  final MctsSearch<S, M> _mcts;

  /// Chooses a move for the side to move in [state] at [level].
  ///
  /// Throws [StateError] when there is no legal move.
  M chooseMove(S state, AiLevel level) {
    final iterations = level.mctsIterations;
    if (iterations != null) {
      final move = _mcts.search(
        state,
        limits: MctsLimits(iterations: iterations, maxTime: level.maxTime),
      );
      if (move == null) throw StateError('No legal move.');
      return move;
    }
    final result = analyse(state, level);
    if (result.bestMove == null) throw StateError('No legal move.');
    return pickWithNoise(result.rootMoves, level.noise, random);
  }

  /// Full search result at [level], for hints and the coach.
  SearchResult<M> analyse(S state, AiLevel level) => _alphaBeta.search(
        state,
        limits: SearchLimits(maxDepth: level.maxDepth, maxTime: level.maxTime),
        exactRootScores: level.noise > 0,
      );
}
