import 'dart:math';

import '../game.dart';
import '../player.dart';
import '../result.dart';
import 'evaluator.dart';

/// Limits for one Monte Carlo tree search.
class MctsLimits {
  const MctsLimits(
      {this.iterations = 2000, this.maxTime, this.maxPlayoutPlies = 200});

  final int iterations;
  final Duration? maxTime;

  /// Playouts longer than this are stopped and scored with the evaluator
  /// (or as a draw when there is none).
  final int maxPlayoutPlies;
}

class _Node<S, M> {
  _Node(this.state, this.move, this.parent, this.mover);

  final S state;
  final M? move;
  final _Node<S, M>? parent;

  /// The player who made [move] (whose wins this node counts).
  final Player? mover;
  final List<_Node<S, M>> children = [];
  List<M>? untried;
  int visits = 0;
  double wins = 0;
}

/// Monte Carlo tree search (UCT) over the shared [Game] interface.
///
/// Suited to games where a static evaluation is hard, such as mancala games
/// with long sowing chains. All randomness comes from the injected [random],
/// so searches are reproducible.
class MctsSearch<S extends Object, M extends Object> {
  MctsSearch({
    required this.game,
    required this.random,
    this.evaluate,
    this.exploration = 1.41,
  });

  final Game<S, M> game;
  final Random random;

  /// Optional evaluator used to score playouts cut off by
  /// [MctsLimits.maxPlayoutPlies]. Its score is squashed to a win
  /// probability.
  final Evaluator<S>? evaluate;
  final double exploration;

  /// Returns the most visited root move, or null if there is none.
  M? search(S state, {MctsLimits limits = const MctsLimits()}) {
    final moves = game.legalMoves(state);
    if (moves.isEmpty || game.result(state).isOver) return null;
    if (moves.length == 1) return moves.first;

    final root = _Node<S, M>(state, null, null, null)..untried = List.of(moves);
    final clock = limits.maxTime == null ? null : (Stopwatch()..start());

    for (var i = 0; i < limits.iterations; i++) {
      if (clock != null && clock.elapsed >= limits.maxTime!) break;
      var node = root;
      // Selection.
      while (node.untried!.isEmpty && node.children.isNotEmpty) {
        node = _select(node);
      }
      // Expansion.
      if (node.untried!.isNotEmpty) {
        final move =
            node.untried!.removeAt(random.nextInt(node.untried!.length));
        final child = game.apply(node.state, move);
        final next = _Node<S, M>(child, move, node, game.toMove(node.state))
          ..untried = game.result(child).isOver
              ? <M>[]
              : List.of(game.legalMoves(child));
        node.children.add(next);
        node = next;
      }
      // Simulation.
      final value = _playout(node.state, limits.maxPlayoutPlies);
      // Backpropagation: value is P(first player wins).
      for (_Node<S, M>? n = node; n != null; n = n.parent) {
        n.visits++;
        final mover = n.mover;
        if (mover != null) n.wins += mover == Player.first ? value : 1 - value;
      }
    }

    root.children.sort((a, b) => b.visits.compareTo(a.visits));
    return root.children.first.move;
  }

  _Node<S, M> _select(_Node<S, M> node) {
    final logN = log(node.visits);
    _Node<S, M>? best;
    var bestValue = double.negativeInfinity;
    for (final c in node.children) {
      final v = c.wins / c.visits + exploration * sqrt(logN / c.visits);
      if (v > bestValue) {
        bestValue = v;
        best = c;
      }
    }
    return best!;
  }

  /// Plays random moves to the end; returns P(first player wins).
  double _playout(S state, int maxPlies) {
    var s = state;
    for (var ply = 0; ply < maxPlies; ply++) {
      final r = game.result(s);
      if (r.isOver) return _value(r);
      final moves = game.legalMoves(s);
      s = game.apply(s, moves[random.nextInt(moves.length)]);
    }
    final r = game.result(s);
    if (r.isOver) return _value(r);
    final eval = evaluate;
    if (eval == null) return 0.5;
    final score = eval(s, Player.first);
    return 1 / (1 + exp(-score / 400));
  }

  double _value(GameResult r) => switch (r) {
        Win(:final winner) => winner == Player.first ? 1.0 : 0.0,
        _ => 0.5,
      };
}
