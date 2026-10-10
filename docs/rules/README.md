# Game rules research

| Game | File | Engine package |
|---|---|---|
| Shatranj — الشطرنج | [shatranj.md](shatranj.md) | `packages/game_shatranj` |
| Manqala (beginner) and Ḥawālīs (advanced) — المنقلة والحواليس | [mancala.md](mancala.md) | `packages/game_mancala` |
| Dama — الدامة | [dhama.md](dhama.md) | `packages/game_dhama` |

## Research status — read before freezing any rules package

These documents were written from web research in a cloud environment whose network policy blocked direct page access (Wikipedia, archive.org, Gutenberg, Encyclopaedia Iranica, Britannica, chessvariants.com, ResearchGate, Ludii, Mancala World). Sources were read through search-engine extracts only. Every claim is graded in its file:

- Shatranj: **[V]** = confirmed by two or more independent sources; **[U]** = single or weak source.
- Mancala: ✔ quoted from scholarship · ◐ secondary summary only · ✘ nothing found.
- Dama: "(via [n])" = known only through a secondary or search summary.

Before a rules package is frozen for release, its unverified items must be checked against the printed sources:

- **Shatranj:** Murray 1913, and Hooper & Whyld.
- **Mancala:** de Voogt 2003 on Ḥawālīs, Culin 1894, Lane 1836 and Hyde 1694.
- **Dama:** the full TÜDAF rules and Murray 1952.

A museum or university partner is the ideal reviewer.

## Decisions log

Each file ends with a "Decisions needed from product owner" list. Record each answer here once chosen; the engine implements the chosen option as the default and keeps the documented alternatives as named variants where the file says so.

On 2026-10-10 the product owner accepted all recommended options ("ok continue"). Any of them can be changed later; the engine keeps the alternatives as named variants.

| ID (file) | Question | Chosen (default) | Kept as named variant |
|---|---|---|---|
| Shatranj D1 | Stalemate | Win for the player who stalemates | — |
| Shatranj D2 | Starting placement | Shāh e1/e8, firzān d1/d8, kings facing | "Heritage setup" (mirrored) |
| Shatranj D3 | Bare king | Counter-bare on the next move = draw | "Medina rule" toggle |
| Shatranj D4 | First move | Bottom side, alternating between games | — |
| Shatranj D5 | Draws (house rule) | Threefold repetition + 70 moves with no capture or baidaq move | — |
| Shatranj D6 | Board look | Unchequered default, chequered skin optional | — |
| Shatranj D7 | Ta'biyat mode | Deferred until checked against Murray | — |
| Mancala D-A1 | Manqala sowing | Single lap (beginner) | "Ḥakīmī (Culin)" multi-lap |
| Mancala D-A2 | Capture opposite pit too | Yes (Culin) | — |
| Mancala D-A3 | Leftover seeds when no one can be fed | Go to the last mover | — |
| Mancala D-A4 | Skip origin pit on 14+ seeds | Never (house rule) | — |
| Mancala D-B1 | Ḥawālīs winner | Opponent loses all seeds | — |
| Mancala D-B2 | Seeds left but no legal move | That player loses (house rule) | — |
| Mancala D-G1 | Repetition | Draw on the 3rd repetition; Manqala splits remaining seeds | — |
| Mancala D-G2 | Names | منقلة and الحواليس | — |
| Mancala D-G3 | Full-text verification before release | Yes | — |
| Dama D1 | Base rules | TÜDAF rules presented as Gulf Dama | — |
| Dama D2 | Maximum capture | Count only, kings = men | Free-capture "easy mode" |
| Dama D3 | Promotion mid-capture | Keep capturing as a man, crown after the turn | — |
| Dama D4 | King turning in a capture | 90° allowed, 180° forbidden | — |
| Dama D5 | One piece each | Draw | — |
| Dama D6 | Move limit | "Liwan house rule": 50 moves with no capture or man move | — |
| Dama D7 | Names | Game الدامة ("Dama"); king شيخ | — |
| Dama D8 | Alquerque (القرق) | Add later as a heritage game | — |
