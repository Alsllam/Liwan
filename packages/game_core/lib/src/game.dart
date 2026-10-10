import 'player.dart';
import 'result.dart';

/// Thrown when a move that is not legal in the given state is applied.
class IllegalMoveException implements Exception {
  IllegalMoveException(this.message);

  final String message;

  @override
  String toString() => 'IllegalMoveException: $message';
}

/// The shared interface every Liwan game implements.
///
/// A [Game] is a stateless rules object. Variant choices (see the decisions
/// log in `docs/rules/README.md`) are configuration on the game object, so
/// one state type can be played under several rule sets.
///
/// States ([S]) must be immutable values with `==` and `hashCode`, so they
/// can be stored, compared, sent over the network and used as search keys.
/// Moves ([M]) must also be immutable values with `==` and `hashCode`.
///
/// Rules code must be pure: no I/O, no clock, and no randomness.
abstract interface class Game<S extends Object, M extends Object> {
  /// Stable identifier, e.g. `shatranj`.
  String get id;

  /// The starting position under this game's configuration.
  S get initialState;

  /// The side that moves next in [state].
  Player toMove(S state);

  /// All legal moves in [state]. Empty when the game is over.
  List<M> legalMoves(S state);

  /// The state after [move] is played in [state].
  ///
  /// [move] must be one of [legalMoves]; callers that receive moves from
  /// outside (a user, the network) should use [play], which checks.
  S apply(S state, M move);

  /// The outcome of [state].
  GameResult result(S state);
}

/// Helpers available on every [Game].
extension GamePlay<S extends Object, M extends Object> on Game<S, M> {
  /// Applies [move] after checking that it is legal.
  ///
  /// Throws [IllegalMoveException] if the game is over or the move is not
  /// legal. Use this for every move that comes from a person or the network.
  S play(S state, M move) {
    if (result(state).isOver) {
      throw IllegalMoveException('The game is over.');
    }
    if (!legalMoves(state).contains(move)) {
      throw IllegalMoveException('$move is not a legal move.');
    }
    return apply(state, move);
  }
}

/// Converts states and moves to and from JSON and human notation.
///
/// Used for saved games, replays, online play and the command line.
abstract interface class GameCodec<S extends Object, M extends Object> {
  Map<String, Object?> encodeState(S state);
  S decodeState(Map<String, Object?> json);

  /// A compact, stable text form of a move used on the wire, e.g. `e2e3`.
  String encodeMove(M move);

  /// Parses [encodeMove]'s output. Throws [FormatException] on bad input.
  M decodeMove(String text);
}
