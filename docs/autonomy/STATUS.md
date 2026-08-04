# STATUS — Aether Harvester Reforge

## Current milestone: Phase One (audit + design) — design docs DONE, migration BLOCKED on H-001

| Item | Status |
|---|---|
| Git branches | ✅ backup/pre-reforge-20260804 + revamp/aether-reforge |
| Agent models | ✅ workers=deepseek-v4-flash:0731, verifier/worker-e=kimi-k2.7-code |
| Tool verification | ✅ Blender MCP live, StudioMCP proxy verified (needs in-Studio toggle H-001), CI green |
| Repo audit | ✅ SYSTEM_INVENTORY.md (3 P0s: empty skeleton, dangling Rojo mappings, misleading README) |
| Feature matrix / design intent | ✅ FEATURE_MATRIX.md |
| Game Design Document v2 | ✅ (thesis + 5 pillars: vertical world 9.2, breeding 8.0, reactive world 7.5, anti-grind 7.0, combos 6.5) |
| UI Design System | ✅ UI_DESIGN_SYSTEM.md (18 components, 13 screens, tokens) |
| Architecture | ✅ ARCHITECTURE.md (service boundaries, remote registry, versioned profiles) |
| Economy model + sims | ✅ ECONOMY_MODEL.md + 3 runnable sims (all pass stylua/selene/lune) |
| Backlog | ✅ BACKLOG.md (19 initiatives, ~120 tasks, P0→P4) |
| Legacy prototype migration | ✅ deliverables/scripts → src/ (baseline only, to be replaced by live dump) |
| Live source migration (P0) | ⏳ BLOCKED on H-001 (enable Studio MCP in Assistant GUI) |
| Studio verification | ⏳ BLOCKED on H-001 |

## Blockers
- **H-001 (human, 30s):** Studio → Assistant → … → Manage MCP Servers → toggle ON "Enable Studio as MCP server". See docs/autonomy/HUMAN_ACTIONS.md.

## Balance finding (from sims)
- sim-progression: Day 3-4 player shard balance hits 0, progression stalls (upgrade sink outpaces income). Needs sink/income rebalance — queued as T-7.4 follow-up.

## Latest verified build
- revamp/aether-reforge @ (pending commit) — static gates green

## Next executable tasks (non-blocked)
1. Adversarial review of the 4 design deliverables (worker-e/kimi)
2. Remote catalog + security model from legacy source (filesystem-only, no Studio needed)
3. Unit test foundation on migrated modules (TestEZ/Lune)
4. UI component library implementation (from UI_DESIGN_SYSTEM, pure Rojo/Studio-free buildable)
