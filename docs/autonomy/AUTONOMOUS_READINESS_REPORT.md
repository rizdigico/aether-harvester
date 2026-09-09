# Aesther Harvest — Autonomous Development Readiness

**Audit date:** 2026-09-10  
**Repository:** `rizdigico/aether-harvester`  
**Branch inspected:** `reforge/full-autonomous-rebuild`  
**Scope:** local MCP/plugin wiring, Roblox Studio control, Aesther Harvest recovery, CI gates, Godot/Roblox workflow, and safe automation boundaries.

## Executive result

The development harness is operational. The local Roblox and Godot MCP plugins validate, the Roblox Studio MCP bridge is now resolving the installed Studio version dynamically, and a real Aesther Harvest Studio play session was started, inspected, screenshot-captured, and stopped through MCP.

The game itself is not yet “100% ready for unattended production development.” The current checkout’s source gates are green, but connected runtime acceptance, real Studio DataStore validation, final visual/gameplay acceptance, and production publishing remain separate gates. The correct readiness label is:

> **READY FOR AUTONOMOUS DEVELOPMENT IN A CONTROLLED STAGING LOOP — NOT READY FOR AUTOMATIC PRODUCTION PUBLISH.**

## What is verified

### Local control surface

- `roblox-local-mcp` and `godot-local-mcp` exist in the personal marketplace, have valid manifests, and passed plugin validation.
- Both local stdio MCP servers were previously handshaken directly and expose 12 bounded local tools each.
- The Roblox bridge wrapper now discovers the newest installed `StudioMCP.exe` instead of depending on a stale version hash.
- The wrapper now sends MCP initialization in phases, allowing Studio time to reconnect to the bridge.
- Roblox Studio MCP returned one live instance: **Aesther Harvest (placeId: 97649669204650)**.

### Live Studio workflow

The following workflow passed through the live Studio MCP bridge:

1. `list_roblox_studios` — registered the open Aesther Harvest session.
2. `get_studio_state` — Edit mode available.
3. `search_game_tree` — live DataModel contained the generated world, AetherShared, AetherServer, AetherUI, tools, portals, nodes, and service/debugger instances.
4. `start_stop_play(true)` — Play started successfully.
5. `get_studio_state` — Client and Server DataModels available.
6. `get_console_output` — server/client boot completed; 10 playable islands, 29 resource nodes, 17 active creatures, and 5 portals were reported.
7. `screen_capture` — live Studio capture returned successfully.
8. `start_stop_play(false)` — Play stopped cleanly.

The console also reported `StudioAccessToApisNotAllowed` for `PlayerData_v1`. This is an environment gate, not a successful persistence test. Roblox documents that Studio API access is disabled by default and should be enabled on a separate test version, never casually against production data.

## Current Aesther Harvest reality

Aesther Harvest is a Rojo-managed, server-authoritative sky resource-management and creature-collection game. The intended loop is:

`harvest floating islands → earn shards → upgrade tools/pets → unlock islands → collect creatures → expand social/economic systems`

The current build has a strong foundation: dynamic world generation, core harvesting with server-owned energy spend/regeneration, consumable energy-potion use, persisted equipped tools with durability and tool-driven harvest effects, quest/progression flows, pets, upgrades, portals, UI screens, and server/client boot orchestration. The repository’s own recovery documents also identify incomplete or weak areas that must not be hidden by a passing boot:

- trading is server-authoritative with bounded payloads, rollback, and synchronous two-profile saves, but remains session-only without a durable cross-server trade journal;
- marketplace settlement is durable and crash-resumable, but remains same-server by design until a cross-server settlement bus is added;
- anti-cheat checks are wired into the current state-changing service paths, but adversarial multi-client coverage and policy tuning remain;
- leaderboard scores now use isolated OrderedDataStores with cached top-100 reads, but still need multi-server soak and ranking-policy review;
- analytics are in-memory only;
- cosmetic equip is not fully visual;
- rewards overlap between two services;
- roadmap systems such as battle, breeding, base building, and deeper world layers are not finished.

These are development priorities, not reasons to discard the project.

## Gate results from the current branch

| Gate | Result | Meaning |
|---|---:|---|
| StyLua format check | PASS | Formatting is clean under the current CI exclusion. |
| Selene lint | PASS | Exit 0; 0 errors, 0 warnings, 0 parse errors on the current checkout. |
| Lune unit tests | PASS | 75 passed, 0 failed. |
| Rojo production build | PASS | Place file generated. |
| Rojo test build | PASS | Test place generated. |
| Rojo sourcemap | PASS | Sourcemap generated. |
| Luau typecheck | PASS | `luau-lsp analyze` returned 0 errors and 0 warnings on the current source tree. |
| Live Studio boot/playtest | PASS with environmental warning | Boot and play mode work; DataStore API access is disabled. |

The repository’s current local verification is green; CI configuration still needs a hosted-run confirmation before it is treated as an independent release gate.

## Research-backed operating model

Roblox’s official Studio MCP workflow is the right live-control layer: Roblox documents that an MCP-enabled client can inspect the DataModel, create/edit scripts and instances, run playtests, and interact with Studio. Open Cloud is the right cloud-control layer for scoped REST automation, including data stores, memory stores, experience resources, and place publishing.

The recommended pipeline is therefore:

`Git branch → Rojo/Rokit checks → unit tests → Rojo build → Studio MCP playtest/screenshots → staging Open Cloud checks → human acceptance → explicitly approved publish`

Rojo remains the source-of-truth filesystem workflow. Studio MCP is used for live inspection, targeted Studio edits, runtime tests, screenshots, and UI/device checks. Open Cloud is used only with narrowly scoped credentials for staging data and release operations. No credential is copied into source, reports, screenshots, chat, or generated artifacts.

Roblox’s place publishing API can support a GitHub Actions release workflow, but it has documented instance-type limitations. Studio publishing is still required for some content such as certain editable images/meshes and other specialized instances. Production publishing therefore stays policy-gated and approval-gated.

Godot is useful as a separate asset/prototyping/export lane, not as a replacement for Roblox Studio’s runtime. Its official command-line workflow supports headless checks and scripted exports, which is suitable for CI and overnight work. The Godot Asset Library is usable without a paid subscription, but every third-party asset still needs license, engine-version, security, and attribution review before inclusion.

## Plugin failure explanation

The Plugin Management dependency lookup returned `plugin_not_found` for the two personal/local plugin references because that resolver expects a public global plugin release. It does not prove that the local MCP servers are broken; direct validation and MCP handshakes succeeded.

The local marketplace and plugin-enabled entries are now present in the Codex configuration. A Codex restart is required for the desktop app to reload the personal marketplace and expose the new bundles as normal plugin calls. Until that restart, use the registered local MCP names or the project scripts for verification.

## Automation boundary

Safe to automate continuously:

- source edits, formatting, lint, typecheck, unit tests, Rojo builds, test-place builds;
- Studio DataModel inspection, script search/read/edit, play/stop, console capture, screenshots, and bounded input simulation;
- Godot headless validation and export;
- staging Open Cloud reads and narrowly scoped test writes;
- asset discovery and import after license/compatibility checks;
- generated test reports and regression artifacts.

Must remain an explicit gate:

- enabling Studio API access for a published test experience;
- creating paid monetization products or committing purchase prices;
- production publishing, public release, ads, or irreversible cloud changes;
- final human playtesting for feel, accessibility, device coverage, and policy compliance;
- adding third-party assets whose license or provenance is unclear.

Roblox’s monetization documentation also requires correct receipt processing for developer products. Creating a product, wiring its ID, and safely granting the purchase are separate tasks; a UI button alone is not a complete monetization implementation. Earned Robux and DevEx eligibility are platform-controlled and cannot be promised from automation alone.

## Required next engineering wave

1. Split or gate DataStore integration so local Edit-mode tests use deterministic mocks while a published staging experience tests real persistence.
2. Add deterministic MCP smoke tests for harvesting, quest progression, pet equip/summon, travel, UI screens, and save/load in staging.
3. Add multi-client/device-simulator coverage and a screenshot baseline workflow.
4. Finish economy-critical systems before monetization: durable cross-server trade journaling, cross-server marketplace settlement, leaderboard multi-server soak, anti-cheat adversarial coverage, and receipt processing. Marketplace listings and per-profile settlement markers are durable; the current explicit boundary is same-server settlement with seller presence.
5. Verify the sequential autosave path under DataStore throttling and player-removal races in staging.
6. Only after those gates pass, prepare—not automatically execute—the production release checklist.

## Sources

- Roblox AI/MCP workflow: https://create.roblox.com/docs/ai/accelerated-workflows
- Roblox Studio testing modes and scripted testing: https://create.roblox.com/docs/studio/testing-modes
- Roblox Data Stores and Studio API access: https://create.roblox.com/docs/cloud-services/data-stores
- Roblox Open Cloud reference: https://create.roblox.com/docs/cloud
- Roblox place publishing API: https://create.roblox.com/docs/cloud/guides/usage-place-publishing
- Roblox game passes: https://create.roblox.com/docs/cloud/reference/features/game-passes
- Roblox developer products and receipt processing: https://create.roblox.com/docs/production/monetization/developer-products
- Roblox DevEx: https://create.roblox.com/docs/production/monetization/developer-exchange
- Rojo project/sync behavior: https://github.com/rojo-rbx/rojo and https://github.com/rojo-rbx/rojo.space/blob/master/docs/sync-details.md
- Godot command-line/headless/export workflow: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- Godot Asset Library and license metadata: https://docs.godotengine.org/en/stable/community/asset_library/using_assetlib.html
