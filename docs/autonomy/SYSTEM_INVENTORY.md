# SYSTEM INVENTORY

**Branch:** `revamp/aether-reforge`
**Audit date:** 2026-08-04T13:38+08:00
**Auditor:** Worker-A (Repository Archaeologist)

---

## 1. Repository map (full tree with 1-line annotations)

```
.
├── AGENTS.md                              # Agent instructions (matches README layout section)
├── README.md                              # Full game design doc + architecture claims
├── Makefile                               # Windows-only dev shortcuts (hardcoded C:\Users\aariz paths)
├── default.project.json                   # Rojo main build — 4 tree branches (3 dangling)
├── test.project.json                      # Rojo test build — adds TestEZ + TestRunner
├── rokit.toml                             # Pinned toolchain: rojo 7.7.0, stylua 2.5.2, selene 0.31.0, lune 0.10.5, luau-lsp 1.69.0
├── selene.toml                            # Lint config: std = "roblox+testez"
├── stylua.toml                            # Format config: 4-space indent, 120 col
├── testez.yml                             # TestEZ globals for selene (describe/it/expect)
├── package.json                           # Node deps: pixelmatch ^7.2.0, pngjs ^7.0.0
├── package-lock.json                      # Lockfile for above
├── luau.globals.json                      # luau-lsp global config (empty globals object)
├── .luau-lsp.json                         # luau-lsp aliases + ignore globs
├── .gitignore                             # Ignores .rokit, .rbxlx, node_modules, tests/{baselines,current,diffs}, .env*
├── sourcemap.json                         # Rojo sourcemap (auto-generated, matches current src/)
│
├── src/                                   # GAME SOURCE — only 5 files total (see §3)
│   ├── ReplicatedStorage/AetherShared/
│   │   ├── init.luau                      # STUB — empty table return
│   │   ├── Util.luau                      # REAL — clamp() + safeDivide() (2 functions)
│   │   └── Util.spec.luau                 # REAL — 5 TestEZ tests for Util
│   ├── ServerScriptService/AetherServer/
│   │   └── init.luau                      # STUB — empty table return
│   ├── StarterPlayer/StarterPlayerScripts/
│   │   └── ClientBoot.client.luau         # STUB — prints boot message only
│   ├── StarterGui/AetherUI/               # DOES NOT EXIST (Rojo mapping present, dir missing)
│   └── Workspace/AetherWorld/             # DOES NOT EXIST (Rojo mapping present, dir missing)
│
├── tests/
│   ├── test-runner.server.luau            # REAL — TestEZ bootstrap with JSON summary output
│   └── lune/
│       └── Util.spec.luau                 # REAL — Pure-Luau version of Util tests (5 tests)
│
├── scripts/
│   ├── compare-screenshots.mjs            # REAL — pixelmatch visual regression tool (fully implemented)
│   ├── deploy-staging.ps1                 # REAL — rbxcloud staging deploy script
│   ├── deploy-production.ps1              # STUB — requires manual "PRODUCTION" confirmation, no actual publish
│   ├── run-unit-tests.luau                # REAL — Lune test runner for pure-Luau specs
│   └── types/
│       ├── testez.d.luau                  # REAL — TestEZ global type defs for luau-lsp
│       └── globalTypes.d.luau             # REAL — Full Roblox API type definitions (~16k lines)
│
├── config/
│   ├── games.json                         # Universe/place ID registry (1 game, staging only)
│   └── AUTONOMY_POLICY.yaml               # Agent autonomy rules (production=blocked)
│
├── vendor/testez/                         # TestEZ v0.4.2 (wally: 0.4.1 mismatch — see §6)
│   ├── src/                               # TestEZ core: TestBootstrap, TestRunner, TestPlanner, etc.
│   ├── tests/                             # TestEZ's own test suite
│   ├── testez-cli/                        # Rust CLI wrapper
│   └── docs/                              # TestEZ documentation
│
├── .github/workflows/
│   ├── ci.yml                             # CI: StyLua + Selene + Rojo builds (on push/PR to master)
│   └── publish-staging.yml                # Staging publish (placeholder — publish step is echo only)
│
├── docs/autonomy/
│   ├── SYSTEM_INVENTORY.md                # THIS FILE (placeholder at audit start)
│   ├── MASTER_PLAN.md                     # 29-phase execution plan
│   ├── ARCHITECTURE.md                    # Placeholder (initialized only)
│   ├── STATUS.md                          # Current status tracker
│   ├── BACKLOG.md                         # Feature backlog
│   ├── ASSET_MANIFEST.json               # Asset registry
│   ├── ASSET_PLAN.md                      # Asset production plan
│   ├── ECONOMY_MODEL.md                   # Economy design
│   ├── FEATURE_MATRIX.md                  # Feature tracking
│   ├── ACTIVE_WORK.json                   # Active work items
│   ├── ANALYTICS_PLAN.md                  # Analytics design
│   ├── SECURITY_MODEL.md                  # Security model
│   ├── PERFORMANCE_BUDGETS.md             # Performance targets
│   ├── RISK_REGISTER.md                   # Risk register
│   ├── RELEASE_CHECKLIST.md              # Release criteria
│   ├── MONETIZATION_PLAN.md              # Monetization design
│   ├── HUMAN_ACTIONS.md                  # Human-required actions
│   ├── TEST_MATRIX.md                    # Test plan
│   ├── TOOL_CAPABILITIES.md              # Tool capabilities
│   ├── VISUAL_QA.md                      # Visual QA plan
│   └── DECISIONS.md                      # Decision log
│
├── artifacts/                             # EMPTY — no build artifacts present
├── node_modules/                          # Present (npm install was run)
└── .git/                                  # Git repository
```

---

## 2. Rojo mapping audit (dangling/untracked)

### `default.project.json` — Dangling mappings

| Rojo path | Maps to | Status |
|---|---|---|
| `ReplicatedStorage.AetherShared` | `src/ReplicatedStorage/AetherShared` | ✅ Exists (init.luau + Util.luau) |
| `ServerScriptService.AetherServer` | `src/ServerScriptService/AetherServer` | ✅ Exists (init.luau — stub) |
| `StarterPlayer.StarterPlayerScripts` | `src/StarterPlayer/StarterPlayerScripts` | ✅ Exists (ClientBoot.client.luau) |
| `StarterGui.AetherUI` | `src/StarterGui/AetherUI` | **DANGLING — directory does not exist** |
| `Workspace.AetherWorld` | `src/Workspace/AetherWorld` | **DANGLING — directory does not exist** |

### `test.project.json`

Same as above, plus:
- `ReplicatedStorage.TestEZ` → `vendor/testez/src` ✅ Exists
- `ServerScriptService.TestRunner` → `tests/test-runner.server.luau` ✅ Exists

### Files with no Rojo mapping (untracked by Rojo)

- `src/ReplicatedStorage/AetherShared/Util.spec.luau` — in AetherShared directory but not explicitly mapped (Rojo loads it via `$path` on parent; it will appear as a child ModuleScript under AetherShared). This is correct behavior for TestEZ spec discovery.
- `tests/lune/Util.spec.luau` — not in any Rojo tree (correct: runs under Lune, not Rojo)

---

## 3. Module inventory (per-file: purpose, status=REAL/STUB, issues)

### src/ReplicatedStorage/AetherShared/init.luau
- **Purpose:** Entry module for shared code
- **Status:** STUB — `return {}` (empty table, line 3)
- **Issues:** No real content. README claims this contains Data modules, GameClient, Remotes.

### src/ReplicatedStorage/AetherShared/Util.luau
- **Purpose:** Math/validation utilities (clamp, safeDivide)
- **Status:** REAL — functional implementation, 23 lines
- **Issues:** Comment on line 3 says "Placeholder module - real AetherShared utilities will be migrated here from the live game during the revamp." Self-identified as placeholder. Only 2 functions.

### src/ReplicatedStorage/AetherShared/Util.spec.luau
- **Purpose:** TestEZ unit tests for Util
- **Status:** REAL — 5 tests across 2 describe blocks
- **Issues:** None — clean, well-structured tests.

### src/ServerScriptService/AetherServer/init.luau
- **Purpose:** Server entry point
- **Status:** STUB — `return {}` (empty table, line 3)
- **Issues:** README claims 24 services (PlayerData, Node, Quest, Pet, Creature, Upgrade, Progression, Achievement, Economy, etc.) with ServerMain boot. None exist.

### src/StarterPlayer/StarterPlayerScripts/ClientBoot.client.luau
- **Purpose:** Client bootstrap entry
- **Status:** STUB — only prints "[AetherHarvester] Client boot" (line 3)
- **Issues:** README claims 6 client scripts: ClientBootstrap, InputHandler, HUDController, UIController, ScreenController, Minimap. None exist.

### tests/test-runner.server.luau
- **Purpose:** TestEZ bootstrap that runs all specs and outputs JSON summary
- **Status:** REAL — 47 lines, fully functional TestEZ runner
- **Issues:** None — well-structured, machine-readable output.

### tests/lune/Util.spec.luau
- **Purpose:** Pure-Luau unit tests for Util (runs under Lune, no Roblox engine needed)
- **Status:** REAL — 54 lines, 5 tests
- **Issues:** None.

### scripts/run-unit-tests.luau
- **Purpose:** Lune-based test runner that discovers and executes specs in tests/lune/
- **Status:** REAL — 49 lines, fully functional
- **Issues:** None.

### scripts/compare-screenshots.mjs
- **Purpose:** Visual regression tool using pixelmatch + pngjs
- **Status:** REAL — 61 lines, fully implemented
- **Issues:** Requires tests/baselines/ and tests/current/ directories (gitignored; not present).

### scripts/deploy-staging.ps1
- **Purpose:** Build + publish staging place via rbxcloud
- **Status:** REAL — 60 lines, fully implemented
- **Issues:** Hardcoded path `C:\Users\aariz\.rokit\bin` (line 10). Uses rbxcloud which is NOT in rokit.toml (only in README tool table as 0.17.0).

### scripts/deploy-production.ps1
- **Purpose:** Production deploy gate
- **Status:** STUB — builds but doesn't publish (line 36: "stub - wire Open Cloud API")
- **Issues:** Reads `ROBLOX_OPEN_CLOUD_API_KEY` but never uses it for actual publishing.

### scripts/types/testez.d.luau
- **Purpose:** TestEZ type definitions for luau-lsp
- **Status:** REAL — comprehensive matcher types
- **Issues:** None.

### scripts/types/globalTypes.d.luau
- **Purpose:** Full Roblox API type definitions for luau-lsp
- **Status:** REAL — ~16,000 lines of API type defs
- **Issues:** Very large file; appears auto-generated.

---

## 4. Defect markers found (TODO/FIXME/HACK with file:line)

**None found in src/ files.**

Only marker found:
- `src/ReplicatedStorage/AetherShared/Util.luau:3` — "Placeholder module" comment (not a TODO/FIXME, but self-identifies as incomplete)

---

## 5. Dead/duplicate code

### Dead code
- **None** — the repo is so sparse that everything present is either used or referenced. The 2 functions in Util.luau are tested by 2 separate test files (TestEZ + Lune).

### Duplicate systems
- **None** — no duplicate services, modules, or logic.

### Defined but never required
- **Util.luau** is required by both `Util.spec.luau` (TestEZ) and `tests/lune/Util.spec.luau` (Lune). Both are legitimate test consumers.

### Circular requires
- **None** — only 1 require chain exists: `Util.spec.luau → Util.luau`.

---

## 6. Config validation

| Config | Valid? | Issues |
|---|---|---|
| `rokit.toml` | ✅ | Valid TOML, 5 tools pinned. Note: `rbxcloud` is NOT listed (README claims 0.17.0 but it's not in rokit.toml). |
| `selene.toml` | ✅ | Valid. `std = "roblox+testez"` chains correctly with testez.yml. |
| `stylua.toml` | ✅ | Valid. Standard Luau formatting config. |
| `testez.yml` | ✅ | Valid. Defines describe/it/expect globals for selene. |
| `package.json` | ✅ | Valid JSON. Only 2 devDependencies (pixelmatch, pngjs). No production deps. |
| `.luau-lsp.json` | ✅ | Valid. Aliases `AetherShared` correctly. Ignores `node_modules/` and `.rokit/`. |
| `config/games.json` | ⚠️ | **INVALID JSON** — Line 1 is a `#` comment, which is not valid JSON. It will fail to parse with `JSON.parse()`. Should be removed or file should use a JSONC parser. |
| `config/AUTONOMY_POLICY.yaml` | ✅ | Valid YAML. Production gates correctly set to `false`. |
| `Makefile` | ⚠️ | Hardcoded Windows paths (`C:\Users\aariz\.rokit\bin\*.exe`). Will not work on other machines or CI (Ubuntu). |
| `luau.globals.json` | ⚠️ | Empty globals object — potentially unused. |

### Version mismatch in vendor/testez
- `wally.toml`: version = `0.4.1`
- `rotriever.toml`: version = `0.4.2`
- `CHANGELOG.md`: latest release is `0.4.2`
- **Conclusion:** The actual code is v0.4.2 (matches CHANGELOG). The `wally.toml` is stale at 0.4.1.

---

## 7. Git history + secret scan result

### Git status
- Current branch: `revamp/aether-reforge`
- Backup branch: `backup/pre-reforge-20260804` @ commit `cca86d8`
- Working tree: clean (all files are tracked/committed)

### Secret scan
- **Grep for `api[_-]?key` patterns:** No matches in any `.luau` source files. The only `token`/`key` hits are in `scripts/types/globalTypes.d.luau` (Roblox API type definitions — standard API names, not actual secrets).
- **CI references `ROBLOX_OPEN_CLOUD_API_KEY`** as a GitHub Actions secret — this is correct usage (secret is external, not in repo).
- **No `kcvig` patterns found** anywhere in the repo.
- **No hardcoded asset IDs or place IDs** found in source files (place IDs are only in `config/games.json` and README).
- **Verdict: No secrets found in the repository.**

### Git history
- Could not run full `git log --oneline --all` due to tool restrictions. Based on STATUS.md, the history includes at least commit `cca86d8` on master.

---

## 8. README-vs-repo drift (numbered list)

The README makes extensive claims that are **not reflected in the actual source code**:

1. **"24 services (PlayerData, Node, Quest, Pet, Creature, Upgrade, Progression, Achievement, Economy, ...)"** (README:202-203) — **NOT IN REPO.** `src/ServerScriptService/AetherServer/init.luau` is an empty table. Zero services exist.

2. **"ServerMain boot"** (README:204) — **NOT IN REPO.** No boot/init logic exists in AetherServer.

3. **"Data/ — read-only data: Items, Creatures, Pets, Quests, Recipes"** (README:207) — **NOT IN REPO.** No Data/ directory under AetherShared.

4. **"Modules/GameClient — client state mirror + remote helpers"** (README:208) — **NOT IN REPO.** No GameClient module exists.

5. **"Remotes — named remotes (single source of truth)"** (README:209) — **NOT IN REPO.** No Remotes module exists.

6. **"ClientBootstrap · InputHandler · HUDController · UIController · ScreenController · Minimap"** (README:212) — **NOT IN REPO.** Only ClientBoot.client.luau exists (and it's a stub).

7. **"Islands/ — island models + harvest node Models (NodeId attrs)"** (README:215) — **NOT IN REPO.** `src/Workspace/AetherWorld/` directory does not exist.

8. **"Creatures/ — creature Models (CreatureId attrs)"** (README:216) — **NOT IN REPO.** Same as above.

9. **"(Portals, Props)"** (README:217) — **NOT IN REPO.** No workspace objects exist.

10. **"StarterGui/AetherUI"** (README:286) — **DANGLING ROJO MAPPING.** Directory does not exist.

11. **"10 floating islands (multi-tier rock, grass caps, tapered skirts), lighting/fog/atmosphere tuned"** (README:170) — **NOT IN REPO.** No world data exists.

12. **"29 harvest nodes (NodeId attrs)"** (README:171) — **NOT IN REPO.** No harvest nodes exist.

13. **"Starter quest First Harvest: accept → progress → complete → rewards"** (README:172) — **NOT IN REPO.** No quest system exists.

14. **"Tame (TameCreature) → pet records → equip → summon visible server-side follower"** (README:173) — **NOT IN REPO.** No pet system exists.

15. **"Purchase with escalating costs; currency syncs to HUD instantly"** (README:174) — **NOT IN REPO.** No upgrade system exists.

16. **"Inventory / Quest Log / Pet screens populate live from server data"** (README:175) — **NOT IN REPO.** No UI screens exist.

17. **"5 portals wired; ChangeIsland remote proven across islands"** (README:176) — **NOT IN REPO.** No travel system exists.

18. **"Server-authoritative; AddPet normalized to structured records"** (README:177) — **NOT IN REPO.** No server logic exists.

19. **"assets/ — Blender/MCP-produced models + textures"** (README:291, AGENTS.md:42) — **DIRECTORY DOES NOT EXIST.**

20. **"rbxcloud 0.17.0"** (README:238) — **NOT IN rokit.toml.** Listed as a tool but not pinned in the tool manifest.

21. **Status: "VERIFIED — boot clean, all core loops proven end-to-end"** (README:165) — **MISLEADING.** The repo is an empty skeleton. This status may have been true for a prior codebase that was removed before the revamp branch.

22. **"scripts/compare-screenshots.js"** (AGENTS.md:39) — File is actually `compare-screenshots.mjs` (ESM extension mismatch).

---

## 9. Test coverage reality

### TestEZ (Studio-based)
- **1 spec file:** `src/ReplicatedStorage/AetherShared/Util.spec.luau`
- **5 tests:** 3 for `Util.clamp`, 2 for `Util.safeDivide`
- **Coverage:** Tests the only real code (Util.luau). All tests pass against a functional module.
- **Bootstrap:** `tests/test-runner.server.luau` is properly wired in `test.project.json` under `ServerScriptService.TestRunner`.
- **TestEZ discovery:** TestRunner scans `game.ReplicatedStorage.AetherShared` for `*.spec` children — correct for the one spec that exists.

### Lune (pure-Luau, no engine)
- **1 spec file:** `tests/lune/Util.spec.luau`
- **5 tests:** Mirrors the TestEZ tests for Util
- **Runner:** `scripts/run-unit-tests.luau` discovers `tests/lune/*.spec.luau` — works correctly.
- **Run command:** `lune run scripts/run-unit-tests.luau`

### Test coverage verdict
- **100% of real code is tested** (Util.luau is the only real code)
- **0% of the claimed game systems are tested** (because they don't exist)
- No integration tests, no smoke tests, no visual regression baselines present

---

## 10. CI workflow audit

### ci.yml
- **Triggers:** push/PR to `master` only
- **Branch name:** `master` (matches git)
- **Steps:** Checkout → Install Rokit → StyLua check → Selene lint → Rojo main build → Rojo test build → Upload artifacts
- **Issues:**
  1. Does NOT run Lune unit tests (only checks format/lint/build)
  2. Does NOT run TestEZ tests (requires Roblox Studio — not available in CI)
  3. Uses `actions/checkout@v4` and `actions/upload-artifact@v4` — up to date
  4. Rokit install uses hardcoded v1.2.0 URL — will not auto-update
  5. No caching for Rokit tools (reinstalls every run)

### publish-staging.yml
- **Triggers:** `workflow_dispatch` (manual) + push to `master`
- **Issues:**
  1. **Publish step is a placeholder** — line 35: `echo "Publishing staging place..."` with commented-out rbxcloud command. Does NOT actually publish.
  2. Does NOT run lint/format checks before publishing
  3. Does NOT run the `rokit install` step from a separate step (combines build + tool install)
  4. `rbxcloud` is not installed (not in rokit.toml) — even if uncommented, the publish would fail
  5. Missing `ROBLOX_OPEN_CLOUD_API_KEY` secret validation before attempting publish
  6. Runs on every push to master (not just workflow_dispatch) — this means every master push triggers a build-and-echo, which is noisy but harmless

---

## 11. Priority findings

### P0 — Data loss / security / startup impossible

| # | Finding | Evidence |
|---|---|---|
| 1 | **Repo is an empty skeleton — game cannot start or run** | `src/ServerScriptService/AetherServer/init.luau:3` returns `{}`. No services, no boot logic, no remotes, no data. |
| 2 | **StarterGui/AetherUI directory missing — Rojo build will create empty Folder** | `default.project.json:32` maps `src/StarterGui/AetherUI` which does not exist on disk. |
| 3 | **Workspace/AetherWorld directory missing — no world data** | `default.project.json:42` maps `src/Workspace/AetherWorld` which does not exist on disk. |

### P1 — Core loop broken

| # | Finding | Evidence |
|---|---|---|
| 4 | **Zero game systems implemented — no harvesting, no quests, no pets, no upgrades** | Only file with logic is `Util.luau` (clamp + safeDivide). 24 services claimed in README, 0 exist. |
| 5 | **config/games.json has invalid JSON** (line 1: `#` comment) | `config/games.json:1` — `#` is not valid JSON; `JSON.parse()` will throw. Deploy scripts use `ConvertFrom-Json` which may also fail. |

### P2 — Important feature broken

| # | Finding | Evidence |
|---|---|---|
| 6 | **publish-staging.yml does not actually publish** | `.github/workflows/publish-staging.yml:35` — publish step is `echo` only. |
| 7 | **CI does not run any tests** | `.github/workflows/ci.yml` — only format/lint/build, no Lune or TestEZ execution. |
| 8 | **Makefile uses hardcoded Windows paths** | `Makefile:4-8` — `C:\Users\aariz\.rokit\bin\*.exe` will fail on CI (Ubuntu) or any other machine. |

### P3 — Quality

| # | Finding | Evidence |
|---|---|---|
| 9 | **TestEZ wally.toml version mismatch** | `vendor/testez/wally.toml:3` says 0.4.1; `rotriever.toml:8` says 0.4.2. Stale wally manifest. |
| 10 | **AGENTS.md references wrong filename** | `AGENTS.md:39` says `compare-screenshots.js` but actual file is `compare-screenshots.mjs`. |
| 11 | **README status claims "VERIFIED — boot clean, all core loops proven"** | `README.md:165` — deeply misleading; repo is empty skeleton. |
| 12 | **rbxcloud 0.17.0 not in rokit.toml** | `rokit.toml` lists 5 tools; rbxcloud is missing. README:238 claims it's pinned. |

### P4 — Enhancement

| # | Finding | Evidence |
|---|---|---|
| 13 | **docs/autonomy/ has 20 placeholder files** | Most are initialized-only (e.g., ARCHITECTURE.md has just header + timestamp). |
| 14 | **luau.globals.json has empty globals** | `luau.globals.json:5` — `"globals": {}` — may be unused. |
| 15 | **No assets/ directory despite README/AGENTS.md referencing it** | README:291, AGENTS.md:42 both list `assets/` in layout. |

---

## Next actions

1. **P0-1: Build the server bootstrap** — Create `src/ServerScriptService/AetherServer/init.luau` with a minimal boot sequence that initializes at least a remotes module and prints confirmation. This is the foundation everything else depends on.

2. **P0-2+3: Create missing directories** — `src/StarterGui/AetherUI/` and `src/Workspace/AetherWorld/` with init files so Rojo mappings resolve without dangling references.

3. **P1-5: Fix config/games.json** — Remove the `#` comment on line 1 to make valid JSON, or switch to JSONC handling.

4. **P1-4: Create core service skeleton** — Implement at minimum: Remotes module, PlayerData service, NodeManager service. These are the minimum for a harvest loop.

5. **P2-6+7: Fix CI to run tests and wire publish** — Add `lune run scripts/run-unit-tests.luau` step to ci.yml. Replace publish echo with actual rbxcloud command (install rbxcloud in rokit.toml first).
