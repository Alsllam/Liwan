# game_shatranj

Shatranj (شطرنج), the medieval Arabic ancestor of chess, for Liwan: the rules engine, evaluation and AI. Pure Dart, depends only on `game_core`.

Rules follow [`docs/rules/shatranj.md`](../../docs/rules/shatranj.md); rule numbers (R1…R23) in comments and test names refer to it. Defaults follow the decisions log in [`docs/rules/README.md`](../../docs/rules/README.md):

| Option | Default | Alternatives |
|---|---|---|
| `stalemate` (R14, D1) | stalemating player wins | stalemated player wins (Indian), draw (modern) |
| `bareKing` (R15–R17, D3) | counter-bare on the next move = draw | `medina`: first to bare wins |
| `setup` (§3.1, D2) | shāh e1/e8 facing each other | `mirrored` "heritage setup" |
| `repetitionDraw` (R22a, house rule) | on | off |
| `quietPlyLimit` (R22b, house rule) | 140 plies (70 moves each) | any number, or off |

Implementation note on R17: when the bared shāh has no legal way to bare back, the engine ends the game at once instead of waiting for its reply. The result is the same as in the rules doc (TP10, TP12), and the game is shorter.

## Play on the command line

```sh
dart run game_shatranj:shatranj --level 3            # you play first (red)
dart run game_shatranj:shatranj --level 5 --side second --arabic
dart run game_shatranj:shatranj --selfplay 4,2 --games 6
```

Type moves as `e2e3`; `moves`, `hint`, `undo`, `board`, `help`, `quit`.

## AI levels

| Level | Name | Search |
|---|---|---|
| 1 | مبتدئ Beginner | depth 1, noise 250 |
| 2 | متعلّم Learner | depth 2, noise 120 |
| 3 | لاعب المجلس Majlis player | depth 3, noise 40 |
| 4 | خبير Expert | iterative deepening, 1 s |
| 5 | أستاذ Master | iterative deepening, 4 s |

Evaluation (`lib/src/evaluation.dart`): material (rukh 480, faras 310, firzān 170, fīl 130, baidaq 100), centralisation, baidaq advance, shāh safety and activity, and a "bare-king danger" term because losing all men loses the game.

## Tests

`dart test` runs:
- **rules:** every rule and all 17 test positions of the rules doc;
- **perft:** the move generator against an independent reference generator to depth 3 on seven positions, and to depth 2 on 40 random positions;
- **fuzzing:** 300 random games under the default rules plus every variant combination, checking invariants after every move (one shāh each, no unpromoted baidaq on the last rank, the mover never left in check, incremental hash equals recomputed hash);
- **codec:** JSON round-trips including the repetition window, and hash keys pinned to the values produced on both the Dart VM and JavaScript;
- **AI:** mate in one, a winning stalemate, a free capture, every level returns a legal move, and a stronger level beats a weaker one.

## Dependencies

- `game_core` (Liwan): the shared interface and search.
- `test` (dev).
