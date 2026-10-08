# Liwan · ليوان

A home for traditional Arab and regional board games, beautifully revived: story intros, interactive tutorials, a classic-search AI opponent, local play, and online play with family.

| Folder | Contents |
|---|---|
| `packages/game_core` | Shared game interface + AI search (pure Dart) |
| `packages/game_shatranj` · `game_mancala` · `game_dhama` | One rules package per game (pure Dart, fully tested) |
| `mobile/` | Flutter + Flame app |
| `backend/` | .NET 9 modular backend (Identity & Family, Games & Matchmaking, Ratings, Collections & Achievements) |
| `ai-service/` | Python service for tutorial and coach text (RAG over rules and heritage stories) |
| `frontend/` | Angular + Nx admin (content and stories), web player later |
| `docs/` | Rules research, GDD, brand kit, proposals |

Working on the Dart packages (Dart ≥ 3.6):

```sh
dart pub get
dart analyze
dart test packages/game_core   # per package
```

See `CLAUDE.md` for the project rules.
