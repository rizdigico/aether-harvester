# DECISIONS — Aether Harvester Reforge

All significant decisions recorded per master prompt §2.1 (context, options, selected, reasoning, risks, reversal).

---

## D001 — Agent model split (2026-08-04)
- **Context:** User directive: deepseek-v4-flash:0731 for code/logic overall, kimi-k2.7-code (ollama cloud) for vision/design, only these two.
- **Options:** (a) per-agent pins in `.config/kilo/agent/*.md`; (b) session-level override only.
- **Selected:** (a) — pinned workers to `ollama-cloud/deepseek-v4-flash:0731`, verifier + worker-e to `ollama-cloud/kimi-k2.7-code`. Verified IDs exist via `kilo models`.
- **Reasoning:** durable across sessions; verifier on different family (kimi) than builders (deepseek) preserves independence.
- **Risks:** kimi quota exhaustion on heavy verification; both are cloud models with rate limits.
- **Reversal:** edit the `model:` line in the agent md files.

## D002 — Branch strategy (2026-08-04)
- **Context:** Master prompt requires backup + working branch, no history rewrite.
- **Selected:** `backup/pre-reforge-20260804` (snapshot) + `revamp/aether-reforge` (working). Default `master` preserved.
- **Reasoning:** rollback path exists; CI runs on master only (push merge at milestones).
- **Reversal:** merge or delete working branch.

## D003 — Studio MCP availability (2026-08-04)
- **Context:** Roblox Studio MCP tools not exposed to orchestrator session (MCP loads at session start; this session predates config state).
- **Selected:** Continue autonomous work; agents that hold Studio tools perform in-Studio verification; document evidence in STATUS/TOOL_CAPABILITIES.
- **Reasoning:** do not block the whole project on one tool binding (autonomy contract §2.2).
- **Risks:** in-Studio evidence may be delayed until a session restart exposes the tools.
- **Reversal:** restart Kilo to load Roblox Studio MCP into the orchestrator.

## D004 — Models verified against `kilo models` (2026-08-04)
- `kilo/deepseek/deepseek-v4-flash-0731` and `ollama-cloud/kimi-k2.7-code` both exist. The orchestrator itself runs `deepseek-v4-flash:0731`.
