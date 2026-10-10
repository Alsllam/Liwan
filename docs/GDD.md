# Liwan · ليوان — Game Design Document

Version 0.1 · 2026-10-10 · Status: draft for product-owner review (step 3)

> **ملخص بالعربية.** ليوان مجلس عائلي رقمي لألعاب الطاولة التراثية العربية والإقليمية. نبدأ بثلاث ألعاب، ولكل لعبة: قصة تعريفية، ودرس تفاعلي، ولعب ضد الحاسوب بعدة مستويات، ولعب محلي على جهاز واحد، ولعب عبر الإنترنت مع العائلة والأصدقاء المدعوين فقط. يحصل اللاعب على مجموعات (رقع وقطع مستوحاة من الحِرف والعمارة) وإنجازات، ويقرأ قصصاً تراثية مصوّرة بالعربية والإنجليزية. الذكاء الاصطناعي الذي يلعب هو محرك بحث كلاسيكي، والنموذج اللغوي يكتب نصوص الدروس والمدرب فقط.

---

## 1. Vision and pillars

**Vision.** A digital *liwan*, the shaded open hall of a traditional house where the family sits together, in which grandparents, parents and children play the region's old board games again, learn their stories, and play with each other across distance.

| Pillar | What it means in design |
|---|---|
| **Authentic** | Rules follow `docs/rules/` with sources. Variants are named, never hidden. History is told with citations, not legends presented as fact. |
| **Family** | Built for mixed ages: a grandparent and a 9-year-old must both be able to start a game in under a minute. Online play is with family and invited friends only. |
| **Beautiful and respectful** | Original art drawn from real crafts (sadu weaving, carved wood, brass, palm weaving, architecture). No stereotypes. |
| **Learnable** | Every game teaches itself: story → tutorial → guided first game → AI ladder. |
| **Arabic first** | Arabic is the default language and RTL is designed first, with English as an equal second language. |

**Audience.** (1) Gulf and wider Arab families, ages 8–80; (2) diaspora families who want to pass on heritage; (3) schools and museums (later, see §11).

**Platforms.** iOS and Android at launch (Flutter + Flame). Web player later. Admin web app for content from day one.

---

## 2. Game list and release order

| # | Game | Arabic | Board | Complexity | Role in the catalogue | Release |
|---|---|---|---|---|---|---|
| 1 | **Manqala** (Levantine 2 × 7) | المنقلة | 2 × 7 pits, 7 seeds each | ★☆☆ | The gateway: easiest to learn, short games, good for children | MVP |
| 2 | **Dama** (Gulf / Turkish rules) | الدامة | 8 × 8 plain grid, 16 men each | ★★☆ | The familiar café and majlis game; strong family recognition in the Gulf | MVP |
| 3 | **Shatranj** | الشطرنج | 8 × 8 unchequered | ★★★ | The prestige game: the ancestor of chess, the richest history | MVP |
| 4 | **Ḥawālīs** (Oman 4 × 7) | الحواليس | 4 × 7 pits, 2 seeds each | ★★★ | Advanced mancala, unlocked after Manqala | v1.1 (same package as Manqala) |
| 5 | **al-Qirq / Alquerque** | القرق | 5 × 5 lines | ★★☆ | Heritage game: the ancestor of draughts (decision Dama D8) | v1.2 |
| later | Candidates to research | — | — | — | Seega / Kharbga, Nard (backgammon family), Tab, Mancala variants from other regions | Roadmap |

**Order inside the app.** The home screen shows the three MVP games in order of difficulty: Manqala, then Dama, then Shatranj. All three are free and open from the start (§6.1); the order is a recommendation, not a lock.

**Rules used.** The defaults and variants recorded in `docs/rules/README.md` (decisions log). House rules (draw limits, termination rules) are labelled "قاعدة ليوان / Liwan house rule" in the rules screen.

---

## 3. The game loop and each game's journey

### 3.1 Per-game journey

```
Story intro (60–90 s, skippable)
   └─▶ Tutorial (6–10 short lessons, interactive)
          └─▶ Guided first game vs a gentle AI, with hints on
                 └─▶ Free play: vs AI ladder · local 2-player · online with family
                        └─▶ Collections, achievements, heritage stories unlock along the way
```

### 3.2 Core loop (one session)

Open app → see who in the family is online and any pending invites → pick a game → play (5–20 min) → result screen (summary, coach note, rewards) → collection or heritage reward → play again or share a replay with family.

### 3.3 Game modes (every game)

| Mode | Description | MVP |
|---|---|---|
| **Story intro** | Animated, narrated intro: where and when the game was played, by whom. Arabic voice-over with English subtitles (and vice versa). | ✔ |
| **Tutorial** | Interactive lessons (§4). | ✔ |
| **vs Computer** | 5 levels (§5). Undo allowed on the two easiest levels. | ✔ |
| **Local pass-and-play** | Two players, one device. The board rotates or mirrors per turn (per game setting); for mancala the board stays fixed and the active row is highlighted. | ✔ |
| **Online with family / friends** | Real-time play with invited people only (§7). Turn timers optional; games can be continued asynchronously. | ✔ |
| **Puzzles** | Shatranj *mansubat* (manṣūba = composed problem), mancala capture puzzles, Dama combination puzzles. Each puzzle verified by the engine before shipping. | v1.1 |
| **Replays** | Watch any finished game move by move; share with family. | ✔ (own games) |
| **Heritage openings** | Shatranj *ta'biyat* (fixed historical opening setups), once verified against Murray (decision Shatranj D7). | Later |

---

## 4. Tutorials

### 4.1 Format

- Each lesson is **one idea, 1–3 minutes**: a short explanation (text + voice, Arabic first), a demonstration on the board, then 1–3 interactive tasks the player must solve ("Capture the stone", "Crown your man").
- Lessons use the real rules engine: the tutorial only sets positions and checks results, so tutorials can never teach a wrong rule.
- A friendly guide character, the **host of the liwan** (الراوي, "the storyteller"), voices the lessons. The guide is an original illustrated character, a warm grandparent figure, designed in step 4 without stereotypes.
- Lesson text is written by people and can be polished by the AI service, then reviewed in the admin app before publishing. Nothing reaches players without human review.
- Progress is saved; any lesson can be replayed; a "quick rules" one-page card is always one tap away during a game.

### 4.2 Lesson plans (from `docs/rules/`)

| Manqala | Dama | Shatranj |
|---|---|---|
| 1. The board, pits and seeds | 1. Board and pieces (حجر) | 1. The board and the story of the pieces |
| 2. Sowing counter-clockwise | 2. Moving: forward and sideways | 2. Rukh (rook) and faras (knight): same as chess |
| 3. Capturing 2s and 4s | 3. Capturing by jumping (أكل) | 3. Shāh (king) |
| 4. Capture chains backwards | 4. Capture is compulsory | 4. Firzān: one step diagonally |
| 5. Taking the opposite pit too | 5. Chains, pieces vanish as you jump | 5. Fīl: the two-square leap |
| 6. Feeding an empty row | 6. Take the most | 6. Baidaq (pawn): one step, promotes to firzān |
| 7. Ending and counting | 7. Becoming a sheikh (شيخ) | 7. Shāh (check) and shāh māt (checkmate) |
| 8. First strategy: keep seeds back | 8. The flying sheikh | 8. Stalemate wins in shatranj! |
| | 9. Winning and draws | 9. The bare king and counter-baring |
| | 10. First tactics | 10. A famous manṣūba: Dilārām's problem |

Ḥawālīs gets its own 6-lesson track when it ships (relay sowing, singleton rule, front-row capture).

### 4.3 Coach

During and after games vs the computer, a **coach** offers:
- **Hint** (levels 1–3 by default, optional elsewhere): highlights a good move chosen by the engine.
- **Why?** button after a mistake: the engine compares the played move with its best move; the AI service turns that comparison into one or two plain sentences ("This move leaves your fīl open to capture by the faras on f5").
- **Game summary**: three key moments of the game, written from the engine's analysis.

The coach text never decides anything: the engine supplies the facts (moves, evaluation, captured material), the language model only phrases them, in Arabic or English, at a child-friendly reading level. If the AI service is unavailable, the coach falls back to template sentences.

---

## 5. AI opponent

### 5.1 Engine

- Built in `packages/game_core` on the shared game interface: **alpha-beta minimax** with iterative deepening, move ordering and a transposition table for Shatranj and Dama; **MCTS** or alpha-beta (benchmarked in step 5) for the mancala games, where sowing chains make static evaluation hard.
- Runs **on device** in a background isolate, so play vs computer works fully offline. The same engine (compiled for the server, see step 6) can analyse online games for the coach.
- Each game package provides its own evaluation function (game knowledge stays with the game).
- **No language model ever chooses or evaluates a move.**

### 5.2 Levels

Five named levels, the same names in every game, with their own small illustrated characters (to be designed in step 4):

| Level | Arabic name | For | How it is weakened |
|---|---|---|---|
| 1 | **مبتدئ** — Beginner | Young children, first games | Depth 1, picks among the top moves at random with large noise; never sets traps |
| 2 | **متعلّم** — Learner | Players who finished the tutorial | Depth 2, moderate noise |
| 3 | **لاعب المجلس** — Majlis player | Casual adults | Depth 3–4, small noise |
| 4 | **خبير** — Expert | Strong club-level play | Full search, 1 s per move |
| 5 | **أستاذ** — Master (named after a historical master per game, e.g. "aṣ-Ṣūlī" for Shatranj) | The best players | Full search, up to 5 s per move, no noise |

Targets (checked in step 5): level 1 must lose to a player who has just finished the tutorial at least 70% of the time; each level must beat the level below it at least 75% of the time in engine-vs-engine matches.

### 5.3 Adaptive suggestion

After three wins in a row at a level, the app suggests the next level; after three losses, it offers the previous one or hints. It never changes level without asking.

---

## 6. Collections and achievements

### 6.1 Monetisation stance (to confirm)

- MVP: **all three games, all modes and all tutorials are free**. Collections are earned by playing, not bought. No ads for child profiles.
- Later options (product-owner decision, see §12): an optional family subscription for extra skins and heritage packs, or institution licences (schools, museums). Any purchase on a child profile needs the guardian.

### 6.2 What can be collected

| Collection | Examples (art direction in step 4) | Earned by |
|---|---|---|
| **Boards** | Sadu-woven cloth board, carved teak board, brass-inlaid board, palm-frond mat, coral-stone (Gulf architecture) board, Andalusian tile board | Game milestones, achievements, heritage chapters |
| **Piece sets** | Abstract Islamic-period Shatranj pieces (after the 12th-c. stonepaste style), turned-wood pieces, brass pieces; Dama stones (sea shells, date stones, ceramic discs); mancala seeds (date pits, cowries, pearls, pebbles) | Same |
| **Liwan rooms** | The player's own liwan background: courtyard, wind-tower house, mountain village, coastal house | Long-term progress |
| **Heritage cards** | One illustrated card per story chapter, with a short fact and source | Reading heritage stories, finishing tutorials |

Every collectable has a short "inspired by" note (craft, region, period) shown in the app and credited in `docs/brand/`.

### 6.3 Achievements

Grouped so every age can earn them; no achievement requires spending money or playing strangers.

| Group | Examples |
|---|---|
| **Learning** | Finish a game's tutorial · Read all heritage chapters of a game · Solve 10 puzzles |
| **Playing** | First win vs each AI level · Win with a bare king in Shatranj · A 4-piece capture chain in Dama · Capture 20 seeds in one Manqala move |
| **Family** | Play your first online game with a family member · Play all three games with the same person · A grandparent–grandchild game (by family role) · Family "season": the family plays 20 games in a month |
| **Mastery** | Beat level 5 · Win without losing a piece (Dama) · Win by stalemate (Shatranj, the old rule!) |
| **Heritage** | Complete a board or piece collection · Visit every region on the heritage map |

Achievements are computed on the server from game events (Collections & Achievements module), and also offline on device for local and AI games, synced when back online.

---

## 7. Family and social features

### 7.1 Family

- A **family** (العائلة) is a private group created by a guardian adult. Members join by invite link or QR code.
- **Child profiles** (under 13, or the local legal age) are created and managed by a guardian: no email needed, no direct invites to or from outside the family, play-time limits optional, purchases need the guardian.
- **Friends** are added only by mutual invite (link, QR, or a short code shared in person). There is **no public player search, no public lobby and no matchmaking with strangers** in the MVP.
- A child profile can play online with family members only, unless the guardian approves a specific friend.

### 7.2 Online play

- Invite a family member or friend → they accept → game starts. Real-time over SignalR; if one player leaves, the game pauses and can continue later (asynchronous "correspondence" mode, with push notifications for "your turn").
- The server validates every move with the same rules as the app.
- **Communication:** preset phrases and emoji only (e.g. «أحسنت!» "Well played!", «دورك» "Your turn", «لعبة ثانية؟» "Another game?", «مبروك» "Congratulations"). No free-text chat, no voice chat in the MVP. The phrase list is managed in the admin app.
- **Ratings:** an optional per-game rating among family and friends (Glicko-2 on the server), shown as a friendly family leaderboard. Ratings are hidden by default for child profiles.
- **Report and block:** any member can block a friend; a guardian can remove members; reports go to the admin moderation queue.

### 7.3 Family moments

- **Family leaderboard** per game, per month.
- **Shareable replays** within the family.
- **Seasonal events** tied to the calendar (Ramadan nights, Eid, national days, school holidays): a heritage story and a collectable, never pressure mechanics (no streak punishments, no loot boxes).

---

## 8. Heritage section (التراث)

- One **heritage book** per game, made of 4–8 short illustrated chapters (1–2 minutes each), in Arabic and English, e.g. for Shatranj: "From India to Baghdad", "aṣ-Ṣūlī and the caliphs", "The pieces and what they meant", "Dilārām's sacrifice", "How shatranj became chess".
- Content comes from `docs/rules/<game>.md` and its sources; every chapter ends with "Sources" and a "what historians still debate" note where relevant.
- A **heritage map** shows where each game was played (Levant, Egypt, Gulf, Oman, al-Andalus, Persia), with chapters pinned to places.
- Stories are written and reviewed by people in the admin app (draft → review → publish), with an optional expert-review step for museum or university partners.
- Players can ask the **storyteller** questions about a game's history; answers come from the AI service with retrieval over the published stories and rules docs only, with citations, and say "we don't know" when the sources are silent.
- Original illustrations only (step 4 sets the style).

---

## 9. Accessibility, language and safety

- Arabic default; English switchable per profile. All numbers, notation and board coordinates localised. Mirrored layout in RTL; boards keep their logical orientation (see each rules doc).
- Large touch targets, colour-blind-safe piece and highlight colours, adjustable text size, voice-over for lessons, screen-reader descriptions of board state, reduced-motion setting, and sound categories with separate volumes.
- Family-friendly: no gambling imagery (no wagers, coins-for-luck or loot boxes), no open chat, no ads to children, minimal personal data, data deletion on request.

---

## 10. MVP scope

### In the MVP (v1.0)

| Area | Included |
|---|---|
| Games | Manqala, Dama, Shatranj, each with defaults from the decisions log |
| Per game | Story intro, full tutorial, 5 AI levels, local play, online play with family/friends, replays of own games |
| Coach | Hints and "why?" on levels 1–3, post-game summary (template fallback offline) |
| Family | Families, guardian and child profiles, invites (link/QR/code), friends by invite, preset phrases and emoji, block and report |
| Collections | 3 boards and 2 piece sets per game; 25–30 achievements |
| Heritage | 4 chapters per game in Arabic and English, heritage map (basic) |
| Admin web | Stories, tutorial text, preset phrases, collections and achievements definitions, moderation queue |
| Platforms | iOS and Android |

### Not in the MVP

Puzzles, Ḥawālīs, al-Qirq, ta'biyat openings, ratings UI for children, web player, voice chat, seasonal events, institution features, paid content.

### MVP success measures

- 70% of new players finish at least one tutorial; 50% play a second game within a week.
- 30% of active players play at least one online game with a family member each month.
- Crash-free sessions ≥ 99.5%; AI move under 1 s on a mid-range phone at level 4.
- Zero rule bugs reported that contradict `docs/rules/` (every rule has a test).

---

## 11. Roadmap

| Phase | Content |
|---|---|
| **0 — Foundations** (steps 1–6, now) | Monorepo, rules research, GDD, brand kit, `game_core` + first game with CLI AI, architecture approval |
| **1 — Playable core** | All three rules packages + AI; mobile app shell; local and vs-AI play; tutorials for the first game |
| **2 — Family online** | Identity & Family, Games & Matchmaking (SignalR), invites, preset phrases, replays |
| **3 — MVP launch** | Tutorials and heritage chapters for all three games, collections and achievements, coach, admin, store release (closed beta with families first) |
| **4 — v1.1** | Ḥawālīs, puzzles (mansubat), family leaderboard and ratings, seasonal events |
| **5 — v1.2** | al-Qirq (Alquerque), verified ta'biyat, web player, more boards and piece sets |
| **6 — Partners** | School mode (classroom families, teacher dashboard, lesson plans), museum editions (exhibit-linked heritage packs, co-branded collections), cultural-body content partnerships and expert review of rules and stories |
| **Later** | More games from the region after research (e.g. Seega/Kharbga, Tab, Nard family), tournaments within families and schools |

---

## 12. Open questions for the product owner

1. **Monetisation:** free with an optional family subscription, institution licences, or both? (Recommended: free MVP; decide after beta.)
2. **Start order:** is Manqala → Dama → Shatranj the right "suggested order", or should Shatranj be the hero game on the home screen?
3. **Level 5 names:** name the top level after a historical master per game (aṣ-Ṣūlī for Shatranj), or keep a generic «أستاذ»?
4. **Age gate:** under 13 everywhere, or follow each country's law (e.g. GDPR-K / regional equivalents)?
5. **Voice:** professional Arabic voice actors for the storyteller (recommended), or synthetic voice for the MVP?
6. **Dialect:** Modern Standard Arabic for all text (recommended), with Gulf dialect only in preset phrases?
