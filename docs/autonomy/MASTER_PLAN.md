# MASTER PLAN — Aether Harvester Autonomous Reforge

**Branch:** `revamp/aether-reforge`
**Backup:** `backup/pre-reforge-20260804` (commit cca86d8)
**Started:** 2026-08-04

## Mission
Transform the incomplete foundation into a polished, secure, performant, commercially viable Roblox simulator. Release criteria: Definition of Done (docs/autonomy/RELEASE_CHECKLIST.md) with human playtest as final gate.

## Execution order (from master prompt §30)
1. Tool & access verification ✅ (Blender MCP live, StudioMCP proxy live, git branches, CI green)
2. Backup & baseline — IN PROGRESS
3. Repository & Studio audit
4. P0 data/security repairs
5. P1 startup/core-loop repairs
6. Product vision & scope
7. Architecture stabilization
8. Player-data layer
9. Secure network boundary
10. Polished vertical slice
11. UI design system
12. Core progression & economy
13. Full system implementation
14. World & asset production (Blender)
15. Animation & VFX
16. Audio
17. Responsive UI completion
18. Monetization implementation
19. Analytics
20. Full automated testing
21. Security review
22. Performance optimization
23. Visual regression
24. Staging deployment
25. Staging playthrough & fixes
26. Release candidate
27. Human playtest
28. Final fixes
29. Production approval package

## Current milestone
Phase Zero (preserve & baseline) → Phase One (forensic audit) → P0/P1 repairs

## Model assignments
- **Code/logic (all workers):** `ollama-cloud/deepseek-v4-flash:0731`
- **Vision/design (verifier, worker-e):** `ollama-cloud/kimi-k2.7-code`

## Key constraints
- Production publish: **NO** (policy gate). Staging: allowed.
- No Robux spend, no paid assets, no secrets in repo.
- Server-authoritative everywhere.
- All work on `revamp/aether-reforge`, coherent commits.
