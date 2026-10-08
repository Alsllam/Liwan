# backend/ — Liwan .NET modular backend

Follow `.claude/skills/dotnet-modular-backend/SKILL.md`. Read the root `CLAUDE.md` first.

Product values for the skill's placeholders:

- `{Co}` = `Liwan`, `{Product}` = `Liwan` (namespaces `Liwan.<Module>.*`; final naming confirmed in the architecture step).
- Modules:
  - **Identity & Family** — accounts, family groups, guardian-managed child profiles, invites, friend lists (by invite only, no public search of strangers).
  - **Games & Matchmaking** — game catalog, invites and rooms, real-time play over **SignalR**, server-authoritative move validation, saved games and replays.
  - **Ratings** — per-game ratings (e.g. Glicko-2) for online games between friends and family.
  - **Collections & Achievements** — unlockable games, boards and piece sets; achievement rules driven by game events (MassTransit).

Product-specific rules:

- **Server-authoritative play.** Online moves are validated with the same rules as the Dart packages. How (shared rules engine vs. port vs. Dart rules service) is decided in the architecture proposal — do not pick one alone.
- **No open chat.** The hub only relays moves, preset phrases and emoji. No endpoint stores or relays free text between users.
- Child accounts: minimal data, guardian consent, no ads or purchases without guardian approval.
- Localization keys always in `ar` and `en`.
