# Proposal: `flutter-flame-game` skill

**Status:** waiting for your approval. This skill is **not** in your account, so nothing here is in `.claude/skills/` yet. If you approve it (or change it), I'll write it as `.claude/skills/flutter-flame-game/SKILL.md` and you can also add it to your account so other products can use it.

## Why a separate skill

`flutter-clean-mobile` covers app architecture (features, BLoC, networking, offline, l10n), but nothing about game rendering: the game loop, components, input on a board, animation timing, sound, or performance on low-end phones. Liwan's boards need consistent rules for these across every game, and future games should plug in the same way.

## Proposed scope

1. **Where Flame sits in Clean Architecture.** A `GameWidget` lives in `presentation/`. A `BoardGame` (FlameGame) only renders a `game_core` state and emits move intents. The BLoC owns the session (whose turn, AI thinking, online sync); Flame never holds the rules or the true state.
2. **One generic board layer for all games.** `BoardComponent` (grid, pits or squares from a layout description), `PieceComponent`, `HighlightComponent` (legal targets, last move, check), `MoveAnimator`. A new game supplies a layout, a piece-art mapping and a state-to-component diff, with no new engine code.
3. **Input.** Tap-to-select + tap-to-move and drag-and-drop, both driven by `legalMoves` from the rules package. Large hit areas for children, an undo option in local and AI modes, and accessible alternatives (a semantics overlay describing the board, so screen readers work).
4. **RTL and orientation.** Board coordinates stay logical; the view mirrors when the layout or the player's side calls for it. Notation and labels follow the locale.
5. **Animation and motion.** Durations and curves come from the brand motion tokens (step 4); a reduced-motion setting disables flourishes. Mancala sowing is animated seed by seed with a skip option.
6. **Sound.** `flame_audio` with a small preloaded pool; sound categories (move, capture, win, UI) with separate volume settings; respects the device's silent mode.
7. **Assets.** Vector-first pieces (SVG → cached raster at device scale), sprite atlases for skins, and skins (boards and pieces from Collections) loaded on demand.
8. **AI integration.** Engine search runs in an isolate; the Flame layer shows a "thinking" state and never blocks the frame.
9. **Performance budget.** 60 fps on a mid-range Android device; no allocation in `update()`; stop rendering while the board is idle.
10. **Testing.** `flame_test` for components and input mapping, golden tests of boards in light/dark × ar/en, and an integration test that plays a short scripted game.

## Decision needed

- Approve as written / approve with changes / skip (then I'll put these rules in `mobile/CLAUDE.md` only).
