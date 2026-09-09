# Aether Harvester — Current Verification Status

Updated: 2026-09-10
Branch: `reforge/full-autonomous-rebuild`

This file is the current evidence index. `FEATURE_MATRIX.md`, `BACKLOG.md`, and
the original recovery audit remain useful for intent and historical gaps, but
their early “missing” statements are not a description of the current source
tree.

## Source and build gates

| Gate | Result | Evidence |
|---|---|---|
| Luau formatting | PASS | `stylua --check` on touched services/controllers |
| Luau language analysis | PASS | `luau-lsp analyze` returned 0 errors and 0 warnings; only the file-watch capability info line is emitted |
| Static lint | PASS | `selene src tests` returned 0 errors, 0 warnings, 0 parse errors |
| Unit tests | PASS | `lune run scripts/run-unit-tests.luau`: 46 passed, 0 failed |
| Rojo assembly | PASS | `roblox_rojo_build` and local `rojo build` produce `.rbxlx` places |
| Git delivery | PASS | Latest pushed commits include persistence hardening and the pet-care flow |

## Implemented source surfaces

The branch now includes server-authoritative harvesting, progression, quests,
crafting, upgrades, pets, guilds, player trading, marketplace listings, mail,
scoped chat, achievements, cosmetics, leaderboards, daily rewards, events,
analytics, monetization boundaries, battle-pass progression, persistence
sanitization, receipt journaling, save locking, accessibility/safe-area UI,
and the rebuilt screen/controller layer.

The pet flow specifically preserves duplicate pet instances, validates ownership
on the server, consumes `pet_food`, updates only the selected player record, and
exposes working Equip/Unequip/Feed controls.

## Local MCP evidence

### Godot Local MCP

- Godot 4.7.2 is detected.
- The content project at `assets` exists and has `project.godot`.
- Headless import/parse check returned exit code 0.
- The content lab is intentionally custom; it does not use the conventional
  `scenes/`, `scripts/`, `addons/`, or `export_presets.cfg` layout.
- No Godot process is left running after verification.
- The headless command emits Godot’s harmless `Scan thread aborted` shutdown
  warning after the successful scan; the exit code remains 0.

### Roblox Local MCP

- Roblox Studio, Rojo 7.7.0, and Wally 0.3.2 are detected.
- The Aesther Harvest Studio window is visible locally.
- Project inspection passes for `default.project.json` and `src`.
- Current MCP build output: `artifacts/mcp-final-pushed.rbxlx`.
- Studio RSS was approximately 1.88 GB at the last probe; Godot RSS was 0.

## Asset pipeline

The governed imagegen → Godot → Roblox workflow has concept PNGs, deterministic
Godot GLB exports, and a generated asset registry. The registry records the
Godot exports as verified. Roblox import status remains `not_run` until the
assets are imported into Studio and inspected in a connected play-mode/session.

## Remaining release gates

These are genuine external or human gates, not silently marked complete:

1. Connected Studio play-mode verification with real screenshots and runtime
   logs for boot, spawn, harvest, travel, UI, pets, social, and persistence.
2. Import/scale/material/pivot verification for generated assets in Studio.
3. Creator Hub creation and human review of real game-pass/developer-product
   IDs; product IDs intentionally remain zero in source until that happens.
4. Staging publish, multi-client/soak testing, human playtest, and production
   approval.

No claim of live production publishing, live player revenue, or guaranteed
   monetization is made by this repository.
