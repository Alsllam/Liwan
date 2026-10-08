# المنقلة والحواليس — Manqala and Ḥawālīs

**Status:** research draft, waiting for the product owner's decisions (see §4.3).
**Scope:** this document covers **two** mancala ("sowing") games from the Arab world:

- **(A) Manqala (منقلة), Levantine two-row game:** the **beginner** game. It has 2 × 7 pits and 7 seeds per pit, and it captures pits that reach 2 or 4. This is the Syrian and Palestinian game recorded by Hyde (1694), Culin (1894) and in Galilee (2007).
- **(B) Ḥawālīs (الحواليس), Omani four-row game:** the **advanced** game. It has 4 × 7 pits and 2 seeds per pit, uses relay sowing, and captures from the front row.

The rule IDs `A-R*` and `B-R*` are meant to be cited directly in the `game_mancala` package and its tests.

> **How this research was done, and its limits.** Direct page fetching was blocked by the network policy of the research environment. All sources were therefore read through search-engine extracts and quotations, not opened in full. Every rule below gives its source. The **Verified?** column in §4 says whether a rule is backed by a quotation from a primary or scholarly source (✔), only by secondary summaries (◐), or by nothing found (✘). Before the rules are frozen, someone should read four texts in full: de Voogt 2003 [1], Culin [6], Lane [5] and Hyde [7]. See §8.

---

## 1. Summary

Mancala games are two-player "count-and-capture" games. A player lifts all the seeds from one pit and **sows** them one by one into the next pits. Captures depend on where the last seed lands. In the Arab world the family has two strong traditions:

- In the **Levant, Iraq and Egypt**, people play a **two-row** game called *manqala* (منقلة, from نَقَلَ "to move, transfer" [6]). It was played in coffee houses [5][6].
- On the **coasts of Oman and the Gulf**, people play the **four-row** *ḥawālīs* (الحواليس) [1][16].

**Recommendation for (A):** the Levantine 2 × 7 Manqala. Among the region's two-row games it is the best attested:

- it has a 17th-century record [7], a 19th-century rules account [6] and a 21st-century field record [15c];
- carved boards with 7 pits per side survive at Palmyra [3], in Dhofar [2] and in Jerusalem [11];
- every element of its rules can be stated precisely.

Its main open questions are (i) single-lap or multi-lap sowing and (ii) whether captures also take the opposite pit.

---

## 2. History

### 2.1 Archaeology

- **Palmyra (Syria).** The Roman-period boards there have **5 pits per side**. Boards with **7 pits per side**, the "Syrian" game, replaced them after the Temple of Bel became a fort (7th century or later). Soldiers of an Arab or Ottoman garrison carved these later boards on the temple steps and precinct wall [3].
- **Dhofar (Oman).** At Ad-Dahariz on the Salalah shore, rock slabs carry cup-hole boards, most of them **2 rows × 7**, some with extra end holes. They are the first such boards reported from South Arabia. The authors discuss them in connection with *ḥawālīs* and the Ottoman period [2].
- **Qatar.** Qatar Museums note that cup-mark rows at **Al Jassasiya** "may" have been mancala boards. They say the game was known in Qatar as **al-Ḥālūsa (الحالوسة)** or **al-Ḥuwayla**. The interpretation is contested (some holes are too small, some sit on slopes), and the carvings may be less than 250 years old [10].
- **Levant.** The Penn Museum holds a wooden 2 × 7 board from Jerusalem (date not given) [11]. Many carved "mancala" boards from Byzantine and early Islamic sites in Israel/Palestine were **labelled mancala by default**. Boards with 3 or 4 rows there are probably *ṭāb* or other games [4]. **The product should not claim a precise ancient origin.**

### 2.2 Texts and ethnography

- **Hyde, *De Ludis Orientalibus* (Oxford 1694)** is the first European description of *mancala* as played by "Arabs" [7][6]. *Not consulted directly.*
- **Lane, *Manners and Customs of the Modern Egyptians* (1836)** gives Cairo's game as *mankalah*:
  - it was played in coffee shops, and the loser paid for the coffee of both players and of the spectators;
  - the board has 12 pits called **buyūt / bayt (بيوت / بيت)** in two rows of six;
  - there are 72 cowries or pebbles called **ḥaṣā (حصى)**, singular **ḥaṣwa (حصوة)**;
  - there are "two modes" of play [5][15d].
- **Culin, *Mancala, the National Game of Africa* (read in 1894, published in 1896)** gives three variants. He took them from Syrian informants describing play in Damascus cafés:
  - **La'b madjnūnī** "the crazy game";
  - **La'b ḥakīmī** "the rational game", also called *la'b ʿaqila*;
  - **La'b rosëya**, a children's game.

  The details:
  - the board has **2 × 7** pits;
  - there are 98 pieces: cowries (*wada*, ودع) or pebbles;
  - the right-hand end pit is called *el-rās* (الراس), "the head";
  - he explains the name *mancala* as "the game of transferring" [6][13].
- **Galilee, 2007.** The Palestinian **al-manqala** has 2 rows of 7 **byūt (بيوت)** and 7 beads per pit. It was played mostly by men in guest-houses, on oak boards soaked in olive oil and tarred. It was documented by the anthropologist Moslih Kanaaneh (Birzeit University) [15c]. *The original publication was not found; the source is a secondary wiki.*
- **Oman.** de Voogt published the first scholarly account of *ḥawālīs* in Oman. He reports expert players and regular championships at clubs in **Ruwi, Muttrah and Seeb**. He also links the game to Zanzibar's ***bao la kiarabu*** ("Arab bao"), which Ingrams first described in 1921 and which has slightly different rules [1][12][15a].
- **Omani and Gulf press:**
  - The game is mostly played today by older men in coastal villages. It is often played in holes scooped in sand, with shells or pebbles.
  - The board has **28 pits (بيوت/حفر)**, two rows of 7 per player.
  - A shell called *ḥālūs* gives the Bahraini name **al-Ḥālūsa (الحالوسة)**. The Bahraini shell called *ṣubbān* (الصبان) is also used [16].
- **Classical lexicography.** Ibn Sīdah's *al-Mukhaṣṣaṣ* (11th c.) lists **al-ḥawālis (الحوالس)** as "a game of theirs with pebbles". The *Qāmūs* describes a different children's line game under the same word [17].
  - This proves the **word** is old.
  - It does **not** prove that the old game was a mancala. **Do not present it as such.**

### 2.3 Terminology (attested)

| Concept | Arabic | Attestation |
|---|---|---|
| Pit, "house" | بيت، ج. بيوت (bayt, buyūt / byūt) | Lane [5], Galilee [15c], Omani press [16] |
| Pit, hole (generic) | حفرة، ج. حفر | Omani and Gulf press [16] |
| Seeds, pebbles | حصى (sing. حصوة) | Lane [5] |
| Cowrie shells | ودع (*wada*) | Culin [6] |
| Shells used in Gulf play | حواليس / حالوس، صبان | Gulf press [16] |
| Right-end pit | الراس "the head" | Culin [6] |
| Game names | منقلة؛ لعب حكيمي / لعب عقلة؛ لعب مجنوني؛ الحواليس؛ الحالوسة؛ الحويلة | [6][10][13][15][16] |

---

## 3. The games

Some terms are used the same way for both games:

- **Counter-clockwise (CCW)** means counter-clockwise **as seen from above the board**. It is an absolute direction. It does **not** flip in RTL layouts.
- To **sow** means to drop one seed into each successive pit along the circuit.

### 3.A Manqala (منقلة), Levantine 2 × 7: beginner game

#### Board
- The board has 2 rows of 7 pits and **no stores**. Captured seeds are kept beside the board [6][15c].
- Each player owns the row nearest to them [6][15c].
- Index the pits 0–13 in CCW order:
  - South owns 0–6, from left to right as South sees them;
  - North owns 7–13;
  - `opposite(i) = 13 − i`.

#### Starting position
- There are **7 seeds in every pit, 98 in total** [6 (Ḥakīmī, Rosëya)][15c].
- Culin's *madjnūnī* opening is different. One player spreads the 98 pieces unevenly, at least 2 per pit, and the first move must start from the right-end pit [6][13]. **Not recommended**: see §4.

#### Rules
- **A-R1 Turn.** Players alternate. The first player is chosen by the app; no traditional rule was found.
- **A-R2 Choice of pit.** The mover chooses any **non-empty pit in their own row** [6 (Ḥakīmī)][15c].
- **A-R3 Sowing.** The mover lifts all the seeds from that pit and sows them **CCW**, one per pit, starting with the next pit. Sowing passes through both rows [6][13][15c].
- **A-R4 Laps.** This depends on decision D-A1.
  - **Single lap (recommended for beginners):** the move ends when the seeds in hand run out [15c].
  - **Multi-lap (Culin):** if the last seed falls into a pit that was occupied, and that pit now holds a number other than 2 or 4, the mover lifts all its seeds (including the last one) and keeps sowing. The move ends when the last seed falls into an empty pit, or makes a 2 or a 4 [6][13].
- **A-R5 Origin pit.** No source found says whether the origin pit is skipped when a pit holds 14 or more seeds. Recommendation: **do not skip it**, so the origin receives a seed on each full circuit. *House rule, decision D-A4.*
- **A-R6 Capture.** If the **last** seed makes the pit it lands in hold **exactly 2 or 4**, the mover captures that pit. This applies in **either** row [6][13][15c].
- **A-R7 Chain capture.** The mover also captures each **preceding** pit (going backwards, clockwise) that holds exactly 2 or 4, for as long as the run is unbroken. The chain stops at the first pit with any other count, including 0 [6][13][15c].
- **A-R8 Opposite pits.** This depends on decision D-A2.
  - **Culin:** for every pit captured under A-R6 and A-R7, the mover also captures the contents of the opposite pit [6][13].
  - **Galilee (as summarised):** no opposite capture is mentioned [15c].
  - A pit is never counted twice. A chain can include a pit that is also "opposite" another pit in the chain.
- **A-R9 Captured seeds** leave the board and go to the mover's pile [6][15c].
- **A-R10 Feeding.** If the opponent's row is empty, the mover must, if possible, make a move that puts at least one seed into the opponent's row [15c].
- **A-R11 End of game.** The game ends when the player to move has no seeds in their row **and** the previous mover could not feed them [15c]. The seeds left on the board go to one player:
  - in Galilee, to the player who could not be fed, as worded in [15c];
  - in the Iraqi *ḥālūsa*, to the player who moved last [15e].
  - *Decision D-A3.*
- **A-R12 Winner.** The player with **more captured seeds** wins. In Galilee, **50 or more of the 98** wins, so 49–49 is a draw [15c].
- **A-R13 Endless play.** When the remaining seeds circle forever, the players split them equally [15c]. Lane left the same problem unsolved [15d]. Engine rule: see §5.2.
- **A-R14 Rounds.** No source found describes multi-round play or "lost pits" for this game. **Play one round.**

#### Alternatives considered for (A)
| Game | Board / seeds | Why not the default |
|---|---|---|
| **Egyptian *mankalah* (Lane)** | 2 × 6, 72 seeds | Uneven hand-distribution opening; "two modes"; multi-lap; captures 2/4 plus the opposite pit; ends when one seed is left [5][15d]. Lane's full text was not read, so details are ◐. A good future "heritage variant". |
| **Iraqi *ḥālūsa*** | 2 × 6, 6 seeds per pit | Captures any even number, only on the mover's own side [15e]. Only a wiki source, so ◐/✘. |
| **Syrian *la'b madjnūnī*** | 2 × 7, uneven opening | Same family as (A). Its random opening makes it unfit for tutorials or a fair AI [6][13]. |
| **Turkish *mangala*** | 2 × 6 + 2 stores, 4 seeds per pit | Well documented, but Turkish, not Arab; extra-turn and store rules [18]. |
| **Gulf two-row game** | — | **No reliable rules found.** The Gulf names *ḥālūsa* and *ḥawālīs* refer to the 28-pit (4 × 7) game [16]. |

### 3.B Ḥawālīs (الحواليس), Oman 4 × 7: advanced game

#### Board
- The board has **4 rows × 7 pits** and no stores [1][12][14][16].
- Each player owns the **two rows nearest to them**: a back (outer) row and a front (inner) row. Each player therefore has 14 pits [1][14][16].
- A player sows **only around their own 14 pits**, in a closed circuit [15a].
- Index each player's own circuit `s0…s13` CCW from above:
  - `s0–s6` is the back row, from left to right as the owner sees it;
  - `s7–s13` is the front row, from right to left.
  - Seen from the owner's seat, the back row moves **to the right**. This matches the Omani description "always to the right" [16].
- Opposite mapping for the mover's front pit `s_j` (j = 7…13):
  - the opponent's facing front pit is `o(20 − j)`;
  - the pit behind it, in the opponent's back row, is `o(j − 7)`.

#### Starting position
- There are **2 seeds in every pit**: 56 in total, 28 per player [1][12][14][16].
- Variant: one Omani article says **1 per pit** [16 (Shabiba)]. Another says "48 shells, played two at a time" [16 (Wasat)]. Both are isolated reports.
- **No source found describes a special or variable opening setup or an opening phase for Omani ḥawālīs.** That opening procedures exist could not be verified. Keep the uniform 2-per-pit start until de Voogt [1] has been read in full.

#### Rules
- **B-R1 Turn.** Players alternate. The first player is chosen by the app; no rule was found.
- **B-R2 Legal pits.** The mover must play a pit of their own holding **2 or more** seeds, if they have one [1][14][15a].
- **B-R3 Singletons.** A pit with 1 seed may be played only when **none** of the mover's pits holds 2 or more. Even then, the single seed **may not move into an occupied pit**: the next pit must be empty [1][14].
- **B-R4 Sowing.** The mover lifts all the seeds and sows them **CCW** around their own 14 pits, starting with the next pit [1][12][14][15a][16].
- **B-R5 Relay (multi-lap).** If the last seed lands in an **occupied** pit, the mover lifts that pit's entire contents and keeps sowing in the same direction. The move ends when the last seed lands in an **empty** pit [1][14][16].
- **B-R6 Origin pit.** The origin pit is not skipped. Once it has been emptied it is just another pit; no skip rule is attested. *Decision D-B4.*
- **B-R7 Capture.** If the move ends in an empty pit of the mover's **front row**, the mover looks at the opponent's pits in the same column:
  - (a) If the opponent's **front** pit is non-empty, the mover captures it, **plus** the opponent's **back** pit behind it if that pit is non-empty [1][14][16].
  - (b) If the opponent's front pit is **empty**, there is **no capture**, even if the back pit has seeds [1][14].
  - A move that ends in the back row never captures [1][14].
- **B-R8 Captured seeds** leave the board for good. They are never re-sown [1][14].
- **B-R9 Endless move.** A player who makes an **endless move** (a relay that never ends in an empty pit) **loses** [1]. Engine: see §5.2.
- **B-R10 End and winner.** This depends on decision D-B1.
  - **de Voogt / Omani practice:** a player who has **lost all their seeds** has lost; the winner "removes all the opponent's stones" [1][16].
  - **Wikipedia:** the game ends when a player has no seeds left, and the winner is whoever has captured more [12].
  - Recommendation: the traditional annihilation rule (`B-R10a`).
- **B-R11 No legal move.** A player may still have seeds but be unable to move: every pit holds 0 or 1 seeds and every singleton is blocked under B-R3. No source covers this case.
  - Recommendation: that player **loses**. This is consistent with B-R10a.
  - *House rule, decision D-B2.*
- **B-R12 Rounds.** No source found describes multi-round play. **Play one round.**

**Engine note: the opening is a forced capture.** Our simulation of B-R4 and B-R5 from the uniform 2-per-pit start shows the same thing for every opening move: after 5 relays it ends back in the (now empty) origin pit. So an opening from a front-row pit (`s7–s13`) always captures 4 seeds. This is computed from the rules, not taken from a source. It matters for the AI and for tutorials, and it may explain why players have opening conventions. *Verify against [1].*

---

## 4. Variants and source disagreements

### 4.1 Manqala (A)

| # | Point | Options (sources) | Verified? | Recommendation |
|---|---|---|---|---|
| A1 | Lap type | Single lap [15c] · Multi-lap relay [6][13] (Wikipedia lists Ḥakīmī as multi-lap) | ◐ / ✔ | **Single lap** for the beginner mode. Offer Culin's multi-lap as the named variant "حكيمي (Culin)". |
| A2 | Opposite pit in captures | Yes [6][13] · Not mentioned [15c] | ✔ / ◐ | **Yes (Culin)**: it is the better-documented rule and makes captures easier to see. |
| A3 | Setup | 7 per pit [6][15c] · Uneven, at least 2 per pit, start from the right end (*madjnūnī*) [6][13] | ✔ | **7 per pit, free choice of pit.** |
| A4 | End and leftover seeds | Feeding rule, leftovers to one player [15c] · leftovers to the last mover [15e] · Culin's "until all pits empty" is impossible [13] | ◐ | Feeding rule plus leftovers to the player **who emptied the board**: the last mover, unambiguous for code. |
| A5 | Endless cycles | Split equally [15c] · Lane silent [15d] | ◐ | Split; an odd seed goes to nobody. Detect by repetition (§5.2). |
| A6 | Origin skip (14 or more seeds) | No source | ✘ | No skip. |
| A7 | Win threshold | 50 or more of 98 [15c] | ◐ | Most seeds; 49–49 is a draw. |

### 4.2 Ḥawālīs (B)

| # | Point | Options (sources) | Verified? | Recommendation |
|---|---|---|---|---|
| B1 | Seeds per pit | 2 [1][12][14][16] · 1 [16 Shabiba] · "48 shells" [16 Wasat] | ✔ (2) | **2.** |
| B2 | Direction | CCW [1][12][14][15a] · "to the right" [16] (consistent with CCW) · clockwise in Zanzibar *bao la kiarabu* [12] | ✔ | **CCW.** |
| B3 | Capture trigger | Last seed in an **empty front-row** pit [1][14][16] · "last seed in an inner-row pit" (no mention of empty) [12] | ✔ | **Empty front-row pit.** |
| B4 | Back pit when front is empty | No capture [1][14] · captured anyway in *bao la kiarabu* [12] | ✔ | **No capture.** |
| B5 | Singletons | Only when no pit holds 2 or more, and never into an occupied pit [1][14] · "singletons not allowed" (MW excerpt) [15a] | ✔ | As B-R3. |
| B6 | Winner | Opponent loses all seeds [1][16] · most seeds captured [12] | ✔ / ◐ | **Annihilation.** |
| B7 | Endless move | Mover loses [1] · draw on repetition (one secondary page) | ✔ / ◐ | **Mover loses** within one move; draw on whole-game repetition (§5.2). |
| B8 | Opening setups or phase | None found | ✘ | Uniform start; re-check [1]. |
| B9 | Citation of [1] | *BGS* 6 (2003): 95–98 (most citations) · *BGS* 2 (1999) (brief) · "4: 53–76" (one citation) | — | Cite as BGS 6 (2003) until checked. |

### 4.3 Decisions needed from product owner

1. **D-A1: Manqala sowing.** (A) Single lap only. (B) Multi-lap only (Culin). (C) **Single lap as "Beginner", plus multi-lap as a named "Ḥakīmī (Culin)" variant ← recommended.**
2. **D-A2: Opposite-pit capture in Manqala.** (A) **Yes, per Culin ← recommended.** (B) No, per the Galilee summary.
3. **D-A3: Leftover seeds when nobody can be fed.** (A) **To the last mover ← recommended.** (B) To the player who could not be fed. (C) Split equally.
4. **D-A4: Origin pit with 14 or more seeds (Manqala) / relay passing the origin (Ḥawālīs).** (A) **Never skip; label it a house rule ← recommended.** (B) Skip the origin.
5. **D-B1: Ḥawālīs winner.** (A) **Opponent loses all seeds (de Voogt, Omani practice) ← recommended.** (B) Most captured when a side empties (Wikipedia).
6. **D-B2: Ḥawālīs, no legal move while seeds remain.** (A) **That player loses; named house rule ← recommended.** (B) Pass the turn. (C) The game ends and captures are counted.
7. **D-G1: Whole-game repetition.** (A) **Draw after the 3rd repetition of the same position with the same player to move; for Manqala, split the board seeds instead ← recommended.** (B) Move cap only (for example 300 plies), then count.
8. **D-G2: Naming in the app.** (A) **"منقلة" for game A and "الحواليس" for game B ← recommended.** (B) Use "الحالوسة" for B (the Gulf name).
9. **D-G3: Research follow-up.** (A) **Get de Voogt 2003, Culin and Lane in full before release ← recommended.** (B) Ship with the rules as they stand.

---

## 5. Notes for implementation

### 5.1 Engine edge cases
- **Direction is absolute (CCW).** Rendering may mirror for RTL; the rules package must not.
- **A-R7 chain and A-R8 opposites can overlap**, for example a chain that crosses from pit 6 to pit 7, whose opposite is pit 6. Collect the set of captured pit indices first, then empty them once.
- **A-R10 feeding:** the legal-move generator filters the moves. If no feeding move exists, the game ends (A-R11).
- **Multi-lap Manqala (A-R4b):** a capture check (2 or 4) happens **before** relaying, and an empty pit ends the move. A pit holding 3 after the drop (it had 2) relays.
- **Ḥawālīs singletons (B-R3):** a player with only 0- and 1-seed pits may have zero legal singleton moves. Handle this under D-B2.
- **Ḥawālīs capture** needs the mover's front pit to be empty before the last seed lands. A relay can end in a front pit that the move emptied earlier, including the origin. That is legal and captures.
- **Seed conservation invariant:** `onBoard + capturedSouth + capturedNorth == total` (98 for A, 56 for B) after every move.

### 5.2 Termination (can the game loop forever?)
- **Within one move:**
  - Single-lap Manqala always ends.
  - Multi-lap Manqala and Ḥawālīs relays **can, in principle, loop forever**: the board state and the hand are finite, so a relay either ends or repeats.
  - Detect it by hashing `(board, current pit, seeds in hand)` at each relay pick-up. If a state repeats, the move is **endless**.
  - Ḥawālīs: the move is **illegal for the AI and loses for a human** (B-R9).
  - Manqala multi-lap: the move is illegal; if every move is endless, the game ends as under A-R13.
  - Also set a hard safety cap (for example 10,000 sown seeds) as a defensive bound.
- **Across moves:**
  - Few seeds can circle without captures; Lane's "last two seeds" problem is an example [15d].
  - Use D-G1: position repetition counted by a hash in the state history, plus a no-capture ply limit (for example 100) as a backstop. Then apply A-R13 (split) or call a draw in Ḥawālīs.
  - The rules package must take the history explicitly, which keeps it pure: no hidden state.

### 5.3 Suggested test positions
Notation for Manqala: an array of 14 counts with pit 0 = South's leftmost, CCW. These were computed from the rules above.

1. **A, opening, single lap:** start from all 7s; South plays pit 0. Result: pits 1–7 hold 8 each and pit 0 holds 0. There is no capture (the last seed makes 8).
2. **A, chain capture:** set pit 2 = 2, pit 3 = 1, pit 4 = 3, everything else as you like. South plays pit 2. Pits 3 and 4 become 2 and 4, so pit 4 is captured, then pit 3 by the chain. The chain stops at pit 2, which is now 0. With D-A2 = yes, pits 10 and 9 are also captured.
3. **A, multi-lap opening:** start from all 7s; South plays pit 0 under Culin rules. It takes 5 laps and ends at pit 1 with 2 seeds, which are captured. Pit 0 holds 3, so the chain stops. With D-A2, opposite pit 12 (10 seeds) is also captured. Board before capture: `[3,2,10,10,10,0,10,2,10,10,1,10,10,10]`.
4. **A, feeding:** North's row is empty and South has one move that reaches pit 7 and one that does not. Only the first is legal.
5. **A, no feed possible:** the game ends and the leftovers go per D-A3.
6. **B, opening:** start from all 2s; the mover plays `s5`. It takes 5 relays and ends in `s5` (back row), with no capture. Own circuit after the move: `[3,3,0,3,3,1,3,0,3,3,0,3,3,0]`.
7. **B, opening capture:** the mover plays `s7`. It ends in `s7` (front, empty), so the mover captures `o13` and `o0` (2 + 2). Own circuit: `[3,0,3,3,0,3,3,1,3,0,3,3,0,3]`.
8. **B, front empty, back full:** no capture (B-R7b).
9. **B, singleton blocked:** every pit holds 0 or 1 and each singleton's next pit is occupied, so there are no legal moves (D-B2).
10. **B, endless-move detection:** build a small position where a relay cycles. Expected: the move is flagged endless, the AI never picks it, and a human who makes it loses.
11. **Both games:** a seed-conservation property test over random legal playouts with a seeded RNG.

---

## 6. Notes for tutorials

Suggested lesson order, 8 short lessons:

1. **The board and your houses (البيوت):** your row versus the opponent's row; seeds called حصى.
2. **Sowing (التوزيع):** lift a pit, drop one seed per pit, counter-clockwise.
3. **Counting ahead:** predict where the last seed lands.
4. **Capturing 2 and 4:** one capture, then a chain capture, then the opposite pit (if D-A2).
5. **Feeding your opponent** and how the game ends.
6. **Ḥawālīs board:** two rows each, sowing around your own 14 pits.
7. **Relay sowing (الدوران):** continue from an occupied pit; stop on an empty one.
8. **Front-row capture and singletons:** front plus back captures, and why the front pit must be full.
9. *(optional)* **Heritage:** coffee houses in Cairo and Damascus [5][6], and Omani clubs [1].
10. *(optional)* **Strategy:** protecting your front row, and the forced opening capture in Ḥawālīs.

The coach text in `ai-service/` may explain these points. It must never suggest moves chosen by an LLM.

---

## 7. Sources

1. **de Voogt, A.** (2003). "Hawalis in Oman: a first account of expertise and dispersal of four-row mancala in the Middle East." *Board Game Studies* 6: 95–98. Some citations give BGS 2 (1999). Index: https://www.researchgate.net/publication/312491751 — **Primary scholarship.** *Read only through quotations in [12][14][15a].*
2. **Charpentier, V., et al.** (2014). "Games on the seashore of Salalah: the discovery of mancala games in Dhofar, Sultanate of Oman." *Arabian Archaeology and Epigraphy* 25: 115–120. doi:10.1111/aae.12040. Open access: https://hal.science/hal-01828888 — **Primary scholarship.**
3. **de Voogt, A.** (2010). "Mancala players at Palmyra." *Antiquity* 84: 1055–1066. https://www.cambridge.org/core/journals/antiquity/article/abs/mancala-players-at-palmyra/361DC6A6EB4821544A5EA4DD4891DDBE — **Primary scholarship** (abstract read).
4. **Depaulis, T.** (2024). "Early Mancala and Ṭāb Boards Found in Israel (and in Some Other Countries)." *Board Game Studies* 18: 39–60. doi:10.2478/bgs-2024-0002 — **Primary scholarship.**
5. **Lane, E. W.** (1836). *An Account of the Manners and Customs of the Modern Egyptians*, ch. "Games" (1908 ed., pp. 351–353). https://www.gutenberg.org/ebooks/70796 — **Primary historical source.** *Not read in full.*
6. **Culin, S.** (1896). "Mancala, the National Game of Africa." *Report of the U.S. National Museum for 1894*, pp. 595–607 (read before the Oriental Club of Philadelphia, 10 May 1894; pagination varies by citation). https://www.gutenberg.org/ebooks/66220 — **Primary historical source.** *Read through quotations.*
7. **Hyde, T.** (1694). *De Ludis Orientalibus libri duo*. Oxford: Sheldonian Theatre. — **Primary historical source.** *Not consulted.*
8. **Murray, H. J. R.** (1952). *A History of Board-Games other than Chess*. Oxford: Clarendon. — **Primary scholarship.** *Not consulted; listed for follow-up.*
9. **Russ, L.** (2000). *The Complete Mancala Games Book* (1st ed. 1984). New York: Marlowe. — **Secondary book.** *Not consulted* (cited by [12]).
10. **Qatar Museums.** "Al Jassasiya Rock Art Site." https://qm.org.qa/en/visit/heritage-sites/al-jassasiya-rock-art-site ; see also Visit Qatar, https://www.visitqatar.qa/en/things-to-do/art-culture/heritage-sites/al-jassasiya-rock-carvings — **Museum.**
11. **Penn Museum**, object 363302: mancala board, Jerusalem. https://penn.museum/collections/object/363302 — **Museum.**
12. **Wikipedia**, "Hawalis." https://en.wikipedia.org/wiki/Hawalis — **Encyclopedia.**
13. **Wikipedia**, "La'b Hakimi" and "La'b Madjnuni" (summaries of Culin). https://en.wikipedia.org/wiki/La%27b_Hakimi · https://en.wikipedia.org/wiki/La%27b_Madjnuni — **Encyclopedia.**
14. **Ludii Portal** (Digital Ludeme Project, Maastricht), "Hawalis", with rules quoted from de Voogt 2003. https://ludii.games/details.php?keyword=Hawalis — **Secondary web (academic database).**
15. **Mancala World** (fandom wiki): (a) "Hawalis" https://mancala.fandom.com/wiki/Hawalis ; (b) "Alexander Johan de Voogt" ; (c) "Al-manqala" https://mancala.fandom.com/wiki/Al-manqala ; (d) "L'ab al-Akil" https://mancala.fandom.com/wiki/L'ab_al-Akil ; (e) "Halusa" https://mancala.fandom.com/wiki/Halusa — **Secondary web.**
16. **Gulf and Omani press** — **Secondary web (journalism):**
    - *Al-Shabiba* (Oman), "الحواليس.. لعبة الذكاء التي تتناقلها الأجيال" https://shabiba.com/article/86351 , and "لعبة الحواليس تحافظ على مكانتها في القرى الساحلية" https://shabiba.com/a/50750
    - *Al-Watan* (Oman), «الحواليس» إحدى اللعبات التقليدية الشهيرة https://alwatan.om/article/11296
    - *Al-Khaleej* (UAE), "الحواليس لعبة شعبية يجيدها أبناء السواحل" https://www.alkhaleej.ae/
    - *Al-Wasat* (Bahrain), "الصبان والحالوس: الحالوسة في التراث والتاريخ" https://www.alwasatnews.com/news/1010898.html
17. **Ibn Sīdah**, *al-Mukhaṣṣaṣ*, "bāb al-laʿib" (entry الحوالس), quoted in *لعب العرب*, Arabic Wikisource. https://ar.wikisource.org/wiki/صفحة:لعب_العرب_(الطبعة_الأولى).pdf/20 — **Primary lexicographic source, via a secondary transcription.**
18. **Wikipedia**, "Mangala (game)." https://en.wikipedia.org/wiki/Mangala_(game) ; World Ethnosport Confederation, "Mangala." https://worldethnosport.org/mangala — **Encyclopedia / Secondary web.**

## 8. Claims not verified

- Any Hawalis **opening setup or opening phase** other than 2 per pit: not found in any source.
- de Voogt's exact wording on singletons, endless moves and the winner: known only from quotations in [14][15a].
- The citation volume and year of [1] (BGS 2 1999 versus BGS 6 2003).
- Lane's full rules (his second "mode", the opening distribution, the ending), and Hyde's rules.
- The Galilee rules [15c]: Kanaaneh's original publication was not found.
- Iraqi *ḥālūsa* rules and its attribution to Hyde [15e].
- A documented **two-row** Gulf, Yemeni or Saudi game: none found. The Gulf names point to the 4 × 7 game.
- Omani alternative name "أم السبع": seen in one search extract only; omitted from the terminology table.
