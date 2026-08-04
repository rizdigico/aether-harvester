# STATUS — Aether Harvester Reforge

## Current milestone: Phase Zero/One — baseline + forensic audit

| Item | Status |
|---|---|
| Git backup branch | ✅ `backup/pre-reforge-20260804` @ cca86d8 |
| Working branch | ✅ `revamp/aether-reforge` |
| Agent models pinned | ✅ workers=deepseek-v4-flash:0731, verifier=kimi-k2.7-code |
| Blender MCP | ✅ verified (scene info OK) |
| Roblox Studio MCP | ⚠️ server probe OK; tools not in orchestrator session tool list — agents verify via their own sessions |
| Research engine | ✅ healthy |
| CI | ✅ green on master |
| Baseline capture | ⏳ next |
| Repo audit | ⏳ next |
| Studio audit | ⏳ next |

## Blockers
- None hard. Studio MCP tools not exposed to orchestrator session (reload needed) — workaround: agents that get the tools verify in-Studio.

## Latest verified build
- master @ cca86d8 — CI green (StyLua, Selene, Rojo builds)

## Next executable tasks
1. Baseline place build + screenshots
2. Dispatch Repository Archaeologist + Live Game Auditor
3. Build dependency-aware backlog (P0/P1 first)
