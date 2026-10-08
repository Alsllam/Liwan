# packages/ — pure Dart game packages

Read the root `CLAUDE.md` first. These packages are the heart of Liwan: they hold every rule and the AI.

## Layout

- `game_core/` — the shared interface and everything game-agnostic:
  - the contract every game implements: game state, move, player, legal moves, apply move, result (win / loss / draw / ongoing);
  - AI search on top of that contract only: minimax with alpha-beta (iterative deepening, move ordering, transposition table) and MCTS, with difficulty levels expressed as search budget + evaluation noise;
  - shared helpers: seeded RNG, move notation interface, test harness (perft-style move counts, random-playout fuzzing).
- `game_shatranj/`, `game_mancala/`, `game_dhama/` — one package per game. Each depends on `game_core` only.

## Rules for every game package

1. **Pure Dart.** No Flutter, no `dart:io`, no network, no global state. States are immutable values (`==`/`hashCode`), so they can be used as transposition-table keys and sent over the wire.
2. **Rules come from `docs/rules/<game>.md`.** Each rule in code has a doc comment pointing to the section it implements. Variant options (where sources disagree) are explicit configuration, never hidden branches.
3. **Serialisable.** State and move have a stable JSON form (for online play, replays and saved games) and a human notation for the CLI and tutorials.
4. **Full tests:** every rule has a test named after the doc section; known positions with exact legal-move counts; end-of-game detection for every result type; random playouts that always terminate and never produce an illegal state; JSON round-trips.
5. **Evaluation function** lives in the game package (it is game knowledge) and is plugged into `game_core`'s search.
6. **CLI:** each game package ships `bin/` with a command-line game vs the AI, for testing without UI.
7. `dart format --set-exit-if-changed .`, `dart analyze --fatal-infos`, `dart test` must pass.

## Adding a new game

Research → `docs/rules/<game>.md` (with sources and variant choices) → `packages/game_<game>/` implementing the `game_core` interface → tests → evaluation function → CLI → then UI in `mobile/`.
