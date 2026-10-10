# game_core

The shared game interface and classic AI search for Liwan. Pure Dart, no dependencies.

## The interface

Every game implements `Game<S, M>` (`lib/src/game.dart`):

| Member | Meaning |
|---|---|
| `initialState` | Starting position under the game's variant configuration |
| `toMove(state)` | `Player.first` or `Player.second` |
| `legalMoves(state)` | All legal moves; empty when the game is over |
| `apply(state, move)` | Next state (trusted move); `play(state, move)` checks legality first |
| `result(state)` | `GameResult.ongoing`, `Win(player, reason)` or `Draw(reason)` |

States and moves are immutable values with `==` and `hashCode`. Variant choices are fields on the game object. `GameCodec<S, M>` gives JSON and wire forms for saved games and online play.

## AI (classic search, never an LLM)

- `AlphaBetaSearch`: negamax alpha-beta with iterative deepening, a transposition table, move ordering, quiescence search, and node and time limits.
- `MctsSearch`: UCT Monte Carlo tree search with a seeded random source, for games without a strong static evaluation (mancala).
- `AiPlayer` + `AiLevel`: difficulty levels are only search depth, time and evaluation noise. Moves within `noise` of the best are chosen at random; a forced win is never thrown away and a forced loss is never chosen when there is an alternative.

A game plugs in by providing an `Evaluator<S>` and, optionally, a move scorer (ordering), a noisy-move predicate (quiescence) and a state key (hashing).

## Testing helpers

`package:game_core/testing.dart` provides `perft` (move-tree counts for checking move generators) and `randomPlayout` (fuzzing with invariant checks).

## Dependencies

None at runtime. `test` is a dev dependency.
