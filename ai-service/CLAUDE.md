# ai-service/ — Liwan tutorial and coach text

Follow `.claude/skills/python-azure-rag-service/SKILL.md`. Read the root `CLAUDE.md` first.

Product-specific rules:

- **The LLM never chooses or evaluates moves.** Move choice and position evaluation come from `game_core` search (on device or server). The service receives the position, the move played and the engine's analysis, and only writes explanation text.
- Jobs: tutorial step text, coach hints ("why this move is good / risky"), post-game summaries, and Q&A over the heritage stories and `docs/rules/` with citations.
- Knowledge base = `docs/rules/*.md` + the heritage stories managed in the admin frontend. Answers about history or rules must cite those documents; if they are silent, the answer says so rather than inventing history.
- Arabic first (Arabic analyzer, Arabic eval set before English). Child-safe tone; content filters on input and output.
- No free-text conversation between users passes through this service.
