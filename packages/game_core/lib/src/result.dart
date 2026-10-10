import 'player.dart';

/// The outcome of a game state: still being played, won by one side, or drawn.
///
/// [reason] is a short machine-readable code defined by each game (for
/// example `checkmate`, `bare-king`, `threefold-repetition`), so the UI and
/// the tutorials can explain why the game ended.
sealed class GameResult {
  const GameResult();

  /// The game is still being played.
  static const GameResult ongoing = Ongoing._();

  bool get isOver => this is! Ongoing;
}

/// The game is not over.
final class Ongoing extends GameResult {
  const Ongoing._();

  @override
  String toString() => 'ongoing';
}

/// [winner] has won the game.
final class Win extends GameResult {
  const Win(this.winner, this.reason);

  final Player winner;
  final String reason;

  @override
  bool operator ==(Object other) =>
      other is Win && other.winner == winner && other.reason == reason;

  @override
  int get hashCode => Object.hash(winner, reason);

  @override
  String toString() => 'win(${winner.name}, $reason)';
}

/// The game is drawn.
final class Draw extends GameResult {
  const Draw(this.reason);

  final String reason;

  @override
  bool operator ==(Object other) => other is Draw && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => 'draw($reason)';
}
