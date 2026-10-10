import 'dart:math';

import '../game.dart';
import '../result.dart';

/// Counts leaf nodes of the legal-move tree to [depth] ("perft").
///
/// Comparing perft counts with an independent move generator is the
/// standard way to prove a move generator correct.
int perft<S extends Object, M extends Object>(
    Game<S, M> game, S state, int depth) {
  if (depth == 0) return 1;
  if (game.result(state).isOver) return 0;
  final moves = game.legalMoves(state);
  if (depth == 1) return moves.length;
  var total = 0;
  for (final m in moves) {
    total += perft(game, game.apply(state, m), depth - 1);
  }
  return total;
}

/// One random game from [start], checking [invariant] after every move.
///
/// Returns the final result. Throws [StateError] if the game has not ended
/// after [maxPlies], or if a state with no legal moves is not terminal.
GameResult randomPlayout<S extends Object, M extends Object>(
  Game<S, M> game,
  Random random, {
  S? start,
  int maxPlies = 10000,
  void Function(S state)? invariant,
}) {
  var state = start ?? game.initialState;
  for (var ply = 0; ply <= maxPlies; ply++) {
    invariant?.call(state);
    final result = game.result(state);
    final moves = game.legalMoves(state);
    if (result.isOver) {
      if (moves.isNotEmpty) {
        throw StateError('Game over but moves remain at ply $ply.');
      }
      return result;
    }
    if (moves.isEmpty) {
      throw StateError('No legal moves but game not over at ply $ply.');
    }
    state = game.apply(state, moves[random.nextInt(moves.length)]);
  }
  throw StateError('Game did not end within $maxPlies plies.');
}
