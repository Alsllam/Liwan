/// The two sides of a two-player game.
///
/// [first] always makes the first move of a game. Which human or AI sits on
/// which side is decided by the app (see `docs/rules/` for each game's
/// first-mover rule).
enum Player {
  first,
  second;

  /// The other side.
  Player get opponent => this == first ? second : first;

  /// +1 for [first], -1 for [second]. Handy for evaluation functions.
  int get sign => this == first ? 1 : -1;
}
