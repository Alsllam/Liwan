# Liwan (ليوان)

Liwan revives traditional Arab and regional board games. Each game has a story intro, an interactive tutorial, an AI opponent at several levels, local play on one device, online play with family and friends, collections and achievements, and a bilingual heritage section.

Launch games: **Shatranj** (شطرنج), a **regional mancala** (exact variant chosen in `docs/rules/`), and **Dhama / Dama** (Arabian checkers).

## Repository layout

| Path | What it is | Skill to follow |
|---|---|---|
| `mobile/` | Flutter app. Boards and animations are built with Flame | `.claude/skills/flutter-clean-mobile` (+ `flutter-flame-game` once approved, see `docs/proposals/`) |
| `backend/` | .NET 9 modular backend: Identity & Family, Games & Matchmaking (SignalR), Ratings, Collections & Achievements | `.claude/skills/dotnet-modular-backend` |
| `ai-service/` | Python FastAPI service for tutorial and coach text, with RAG over heritage stories and rules docs | `.claude/skills/python-azure-rag-service` |
| `frontend/` | Angular + Nx: admin for content and stories now, web player later | `.claude/skills/angular-nx-frontend` |
| `packages/game_core/` | Pure Dart: the shared game interface + AI search (minimax/alpha-beta, MCTS) | this file + `packages/CLAUDE.md` |
| `packages/game_<name>/` | Pure Dart rules package for one game, with full tests | `packages/CLAUDE.md` |
| `docs/` | `rules/` (researched rules with sources), `GDD.md`, `brand/`, `proposals/`, architecture | — |

Read the matching skill **and** the folder's own `CLAUDE.md` before working in a folder. When a skill and a folder `CLAUDE.md` disagree, the folder `CLAUDE.md` wins for this product.

## Hard rules (product-wide)

1. **Historically accurate rules.** Every rule in a game package traces back to `docs/rules/<game>.md`, which cites reliable sources (books, museum and academic pages). Where sources disagree, the doc lists the variants and the product owner picks one. Do not invent or "modernise" a rule silently; a chosen house variant is named as such.
2. **One shared game interface.** Every game is a pure Dart package that implements the `game_core` interface (state, legal moves, apply move, result). No Flutter, no I/O, no randomness without an injected seed in rules code.
3. **The AI opponent is classic search** (minimax/alpha-beta or MCTS) in `game_core`, working only through the shared interface. **LLMs never choose moves.** The LLM in `ai-service/` writes tutorial and coach text only.
4. **Original, respectful art.** No copied artwork, no stereotypes (no "desert/camel/genie" clichés as shorthand for Arab culture). Inspiration comes from real crafts (sadu weaving, carved wood, brass, palm weaving, architecture) and is credited in `docs/brand/`.
5. **Arabic first, full RTL.** Arabic is the default locale; every user-facing string exists in `ar` and `en`. Board orientation and move notation are handled explicitly for RTL.
6. **Family-friendly and safe.** No open chat with strangers. Online play is with family and invited friends; any in-game communication uses preset phrases or emoji only. Child accounts are managed by a family guardian.
7. Game rules packages must be server-authoritative compatible: the backend validates every online move with the same rules (see the architecture proposal in step 6).

## Workflow

- Work happens in steps; each step lands on its own branch and pull request, and waits for review.
- Pure Dart packages: `dart format`, `dart analyze` (zero warnings), `dart test` must pass before a commit.
- Do not add a dependency to a rules package without a reason written in its README.
