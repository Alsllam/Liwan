# mobile/ — Liwan Flutter app

Follow `.claude/skills/flutter-clean-mobile/SKILL.md` for architecture, stack, l10n, testing and workflow. Read the root `CLAUDE.md` first.

Product-specific rules that override or extend the skill:

- **Boards and animations use Flame** (`flame` package) embedded in Flutter via `GameWidget`. Menus, profiles, collections and heritage screens are normal Flutter widgets in the feature-first structure. Board rendering rules will live in the `flutter-flame-game` skill once approved (proposal: `docs/proposals/flutter-flame-game-skill.md`).
- **Rules come from `packages/game_*`, never from the app.** The app depends on those packages by path and never re-implements a rule. The Flame layer only renders a state and turns taps/drags into moves chosen from `legalMoves`.
- **The AI runs on device** in a background isolate (`Isolate.run`) through `game_core` search, so offline play works with no network.
- Arabic is the default locale (`app_ar.arb` first). Check every board and screen in RTL.
- No free-text chat. In-game messages are preset phrases and emoji.
- Feature folders expected: `auth`, `family`, `game_lobby`, `play` (local / AI / online), `tutorial`, `heritage`, `collections`, `achievements`, `settings`.
- Brand kit comes from `docs/brand/` (step 4) — do not invent colors or fonts.

The Flutter project itself is created after the architecture is approved (step 6).
