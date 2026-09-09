# BACKLOG — Aether Harvester Full Reforge (master prompt §35)

> **Status note (2026-09-10):** This is the original generated recovery backlog.
> It is not an authoritative live status list; many rows remain `TODO` because
> the list was not rewritten after the reforge. See [`CURRENT_STATUS.md`](CURRENT_STATUS.md)
> for verified current source/build state and genuine remaining release gates.

Generated from the master prompt. Initiative -> Epic -> Task. Every task has: ID, title, description, priority (P0-P4), dependencies, owner, files, acceptance, status.

| ID | Priority | Initiative / Epic | Task | Status |
|---|---|---|---|---|
| T-001 | P0 | I-1 Source Recovery / E1.1 Verify | Verify 45 recovered scripts match live Studio byte-for-byte | TODO |
| T-002 | P0 | I-1 Source Recovery / E1.1 Verify | Verify Remotes.model.json has all 81 remotes the services reference | TODO |
| T-003 | P0 | I-1 Source Recovery / E1.2 World | Verify WorldBuilder reconstructs identical world (island count, node positions) | TODO |
| T-004 | P2 | I-1 Source Recovery / E1.2 World | Add WorldBuilder regeneration script to repo (scripts/assets/rebuild-world.py) | TODO |
| T-005 | P0 | I-1 Source Recovery / E1.3 UI | Verify Screens.luau builds all 12 screens + HUD with correct hierarchy | TODO |
| T-006 | P1 | I-1 Source Recovery / E1.3 UI | Wire UI Bootstrap (LocalScript) that requires Screens.luau into StarterGui on boot | TODO |
| T-007 | P3 | I-1 Source Recovery / E1.4 Docs | Mark recovered design docs with status metadata (Current/Superseded) | TODO |
| T-008 | P1 | I-1 Source Recovery / E1.4 Docs | Rewrite README with truthful recovered state (replace 'verified' claims with evidence links) | TODO |
| T-009 | P1 | I-2 Factory Repair / E2.1 Config | Verify environments.yaml parse + deploy scripts read it | TODO |
| T-010 | P1 | I-2 Factory Repair / E2.2 CI | Verify CI on reforge branch runs (push trigger added) | TODO |
| T-011 | P2 | I-2 Factory Repair / E2.2 CI | Add TestEZ Studio CI job (Windows runner, test place build + run) | TODO |
| T-012 | P3 | I-2 Factory Repair / E2.3 Vendor | Trim vendored TestEZ to runtime + license only | TODO |
| T-013 | P2 | I-2 Factory Repair / E2.4 Branch | Configure GitHub branch protection for master (PR required, status checks) | TODO |
| T-014 | P2 | I-2 Factory Repair / E2.5 Issues | Create GitHub issues for P0/P1 defects + human blockers | TODO |
| T-015 | P1 | I-3 Security / E3.1 Remotes | Rate-limit harvest remote (per-player cooldown map in NodeManager) | TODO |
| T-016 | P1 | I-3 Security / E3.1 Remotes | Validate ChangeIsland target is a registered island | TODO |
| T-017 | P1 | I-3 Security / E3.1 Remotes | Validate PurchaseUpgrade cost/level server-side (no client price) | TODO |
| T-018 | P1 | I-3 Security / E3.1 Remotes | Validate all remote payload types/shapes (type checks on every OnServerEvent) | TODO |
| T-019 | P1 | I-3 Security / E3.2 Persistence | Add per-player save lock (prevent double-save races) | TODO |
| T-020 | P2 | I-3 Security / E3.2 Persistence | Add corruption detection (JSON parse check on load) | TODO |
| T-021 | P1 | I-3 Security / E3.3 AntiCheat | Wire AntiCheat into trade/marketplace/upgrade paths (not just harvest) | TODO |
| T-022 | P3 | I-3 Security / E3.3 AntiCheat | Bound transactionLog + violations tables (memory) | TODO |
| T-023 | P1 | I-3 Security / E3.4 Adversarial | Write adversarial test list + run in Studio test place | TODO |
| T-024 | P2 | I-3 Security / E3.4 Adversarial | Test duplicate guild invite / guild name collision | TODO |
| T-025 | P2 | I-4 Data Layer / E4.1 Schema | Document DATA_SCHEMA.md v1 (already exists — verify accuracy post-fixes) | TODO |
| T-026 | P1 | I-4 Data Layer / E4.2 Migrations | Add migration ledger (MIGRATION_LEDGER.md) + version bump procedure | TODO |
| T-027 | P2 | I-4 Data Layer / E4.3 Receipts | Add receipt journal for purchases (ProcessReceipt-ready structure) | TODO |
| T-028 | P1 | I-4 Data Layer / E4.4 Isolation | Ensure dev Studio never writes production DataStore (env key prefix) | TODO |
| T-029 | P2 | I-5 Core Gameplay / E5.1 Harvest | Add harvest combo system (consecutive same-type nodes -> multiplier) | TODO |
| T-030 | P2 | I-5 Core Gameplay / E5.1 Harvest | Add critical harvest chance (crit = double yield) | TODO |
| T-031 | P3 | I-5 Core Gameplay / E5.1 Harvest | Node respawn animation/feedback (fade in) | TODO |
| T-032 | P2 | I-5 Core Gameplay / E5.2 Tools | Implement tool tiers (Basic Net -> Energy Siphon -> Quantum Harvester -> Chrono Collector) | TODO |
| T-033 | P2 | I-5 Core Gameplay / E5.3 Input | Add mobile touch harvest support (tap node = raycast) | TODO |
| T-034 | P3 | I-5 Core Gameplay / E5.3 Input | Add gamepad support (button harvest near crosshair) | TODO |
| T-035 | P2 | I-6 Progression / E6.1 Economy | Verify economy sims against REAL recovered data (XP curve, upgrade costs) | TODO |
| T-036 | P3 | I-6 Progression / E6.2 Levels | Add level-up celebration (VFX + sound + UI toast) | TODO |
| T-037 | P2 | I-6 Progression / E6.3 Skills | Implement skill tree (Harvesting/Exploration/Trading/Engineering/CreatureCare) | TODO |
| T-038 | P2 | I-6 Progression / E6.4 Achievements | Wire achievement unlock notifications (AchievementUnlocked remote -> toast) | TODO |
| T-039 | P3 | I-6 Progression / E6.5 Prestige | Design + implement prestige (reset for permanent bonus) | TODO |
| T-040 | P1 | I-7 Pets / E7.1 Taming | Add tame cooldown + proximity validation (server) | TODO |
| T-041 | P1 | I-7 Pets / E7.2 Followers | Verify pet follower cleanup on death/teleport | TODO |
| T-042 | P2 | I-7 Pets / E7.3 Bonuses | Apply equipped pet bonuses to harvest (HarvestPower/Luck) | TODO |
| T-043 | P2 | I-7 Pets / E7.4 Feeding | Implement feed pet (consumable) -> hunger/happiness restore | TODO |
| T-044 | P3 | I-7 Pets / E7.5 Breeding | Design breeding (egg, hatch timer, genetics) — evaluate fit | TODO |
| T-045 | P3 | I-7 Pets / E7.6 Evolution | Design evolution tiers per creature | TODO |
| T-046 | P1 | I-8 Quests / E8.1 Starter | Strengthen onboarding: guided first 5 minutes (move, harvest, spend, upgrade) | TODO |
| T-047 | P2 | I-8 Quests / E8.2 Quests | Expand quest database (zone quests per MAP_DESIGN_NEW) | TODO |
| T-048 | P2 | I-8 Quests / E8.3 Daily | Verify DailyRewardsService streak logic (monthly reward claim) | TODO |
| T-049 | P2 | I-8 Quests / E8.4 Tracker | Wire quest tracker UI updates (QuestUpdated remote) | TODO |
| T-050 | P2 | I-9 World / E9.1 Zones | Implement zone registry (11 zones per MAP_DESIGN_NEW) with unlock gating | TODO |
| T-051 | P1 | I-9 World / E9.2 Travel | Verify portal travel works with recovered PortalScript (TargetIsland) | TODO |
| T-052 | P1 | I-9 World / E9.3 FallGuard | Verify FallGuard recovers to SkySanctum | TODO |
| T-053 | P3 | I-9 World / E9.4 Identity | Zone identity pass (per-zone lighting/audio/landmarks) — start with Cloud Gardens | TODO |
| T-054 | P3 | I-9 World / E9.5 Layers | Add Aetherial Sea (reef) layer as first vertical expansion | TODO |
| T-055 | P1 | I-10 UI / E10.1 Wire | Wire ScreenController to rebuilt Screens (population on open) | TODO |
| T-056 | P2 | I-10 UI / E10.2 Components | Migrate legacy screens to Component library (Button/Panel/Modal etc.) | TODO |
| T-057 | P2 | I-10 UI / E10.3 States | Add loading/error/empty states to all screens | TODO |
| T-058 | P2 | I-10 UI / E10.4 Responsive | Mobile/tablet responsive pass (safe areas, touch targets >=44px) | TODO |
| T-059 | P3 | I-10 UI / E10.5 Gamepad | Gamepad focus navigation (UIController) | TODO |
| T-060 | P1 | I-10 UI / E10.6 Vision | Kimi vision review of rebuilt screens (real screenshots) | TODO |
| T-061 | P2 | I-11 Assets / E11.1 ArtBible | Write ART_BIBLE.md (theme, shape language, palette) | TODO |
| T-062 | P2 | I-11 Assets / E11.2 Nodes | Create aether node asset kit in Blender (crystal, ore, herb, tree) | TODO |
| T-063 | P2 | I-11 Assets / E11.3 Tools | Create tool tier models (4 tiers) | TODO |
| T-064 | P2 | I-11 Assets / E11.4 Creatures | Create creature models (start: Cloud Sprite, Sky Fox) | TODO |
| T-065 | P1 | I-11 Assets / E11.5 Manifest | Build ASSET_MANIFEST.json with real entries | TODO |
| T-066 | P2 | I-11 Assets / E11.6 Import | Import verification loop (scale/pivot/materials in Studio) | TODO |
| T-067 | P2 | I-11 Assets / E11.7 Export | Deterministic export recipe script (scripts/assets/export-*.py) | TODO |
| T-068 | P3 | I-12 VFX / E12.1 Matrix | Feedback matrix doc for all actions | TODO |
| T-069 | P2 | I-12 VFX / E12.2 Harvest | Harvest VFX (hit spark, collect trail, crit burst) | TODO |
| T-070 | P3 | I-12 VFX / E12.3 Audio | Audio event map + sourced SFX (UI/harvest/ambience) | TODO |
| T-071 | P3 | I-12 VFX / E12.4 Anim | Harvest animation set (anticipation/strike/recovery) with markers | TODO |
| T-072 | P3 | I-12 VFX / E12.5 Reduced | Reduced-effects mode toggle | TODO |
| T-073 | P3 | I-13 Social / E13.1 Parties | Party system (4 players, co-op bonus) | TODO |
| T-074 | P2 | I-13 Social / E13.2 Guilds | Guild UI wiring (GuildScreen to GuildService) | TODO |
| T-075 | P1 | I-13 Social / E13.3 Trading | Trading UI wiring (TradeWindow) + atomicity tests | TODO |
| T-076 | P2 | I-13 Social / E13.4 Leaderboard | Leaderboard UI wiring (RequestLeaderboard) | TODO |
| T-077 | P3 | I-14 Monetization / E14.1 Plan | MONETIZATION_PLAN.md (passes + dev products, ethical) | TODO |
| T-078 | P2 | I-14 Monetization / E14.2 Receipts | PurchaseService with ProcessReceipt + journal (idempotent) | TODO |
| T-079 | P3 | I-14 Monetization / E14.3 UI | Shop UI (products listing, purchase confirm) | TODO |
| T-080 | P2 | I-15 Analytics / E15.1 Events | Implement AnalyticsService funnel events (join->data->first harvest->first upgrade) | TODO |
| T-081 | P2 | I-15 Analytics / E15.2 Economy | Economy telemetry events (source/sink with balance) | TODO |
| T-082 | P3 | I-15 Analytics / E15.3 Ops | Operational metrics (save failures, suspicious remotes) | TODO |
| T-083 | P1 | I-16 Testing / E16.1 Unit | Unit tests for recovered pure logic (PureMath done; add QuestProgress, UpgradeCost, RewardGrant) | TODO |
| T-084 | P1 | I-16 Testing / E16.2 Integration | Studio integration test bootstrap (boot clean, spawn, harvest E2E) | TODO |
| T-085 | P2 | I-16 Testing / E16.3 Visual | Screenshot regression baselines (first join, HUD, inventory, harvest) | TODO |
| T-086 | P2 | I-16 Testing / E16.4 Multi | Multi-client test (2 players, node sharing, reward isolation) | TODO |
| T-087 | P3 | I-16 Testing / E16.5 Soak | 30-min soak (leaks, memory, remote spam) | TODO |
| T-088 | P2 | I-17 Perf / E17.1 Budgets | PERFORMANCE_BUDGETS.md with measured baselines | TODO |
| T-089 | P2 | I-17 Perf / E17.2 Fixes | Fix per-frame loops / unbounded tasks in recovered services | TODO |
| T-090 | P3 | I-17 Perf / E17.3 Stream | Verify world streaming config (islands stream properly) | TODO |
| T-091 | P1 | I-18 Release / E18.1 Staging | Real staging publish via rbxcloud (separate staging universe/place) | TODO |
| T-092 | P1 | I-18 Release / E18.2 Rollback | ROLLBACK_PLAN.md (previous place, migration record) | TODO |
| T-093 | P1 | I-18 Release / E18.3 Checklist | RELEASE_CHECKLIST.md complete (all gates) | TODO |
| T-094 | P1 | I-18 Release / E18.4 Smoke | Staging smoke test (boot + join + harvest on published place) | TODO |
| T-095 | P2 | I-19 Delivery / E19.1 Docs | Final architecture doc (recovered reality) | TODO |
| T-096 | P1 | I-19 Delivery / E19.2 README | Final truthful README | TODO |
| T-097 | P2 | I-19 Delivery / E19.3 Package | Delivery package assembly (all artifacts) | TODO |
| T-098 | P1 | I-19 Delivery / E19.4 Human | Human playtest request + production approval package | TODO |
| T-099 | P2 | I-20 Content / E20.1 Items | Expand item database (20+ items with rarities) | TODO |
| T-100 | P2 | I-20 Content / E20.2 Quests | Quest database expansion (QST001-QST020) | TODO |
| T-101 | P2 | I-20 Content / E20.3 Crafting | Crafting recipes (5+ recipes, profit margins) | TODO |
| T-102 | P3 | I-20 Content / E20.4 Events | Event definitions (Aether Storm weekly, Rift Convergence monthly) | TODO |
| T-103 | P2 | I-20 Content / E20.5 Daily | Daily rewards calendar (exists in Rewards data — verify UI) | TODO |
| T-104 | P1 | I-21 Vision / E21.1 Review | Kimi review of world (screenshot: SkySanctum overview) | TODO |
| T-105 | P1 | I-21 Vision / E21.2 Review | Kimi review of each screen (12 screens + HUD) | TODO |
| T-106 | P2 | I-21 Vision / E21.3 Review | Kimi review of new Blender assets (nodes/tools/creatures) | TODO |
| T-107 | P2 | I-21 Vision / E21.4 Review | Kimi review of mobile/tablet layout | TODO |
| T-108 | P1 | I-22 Human / E22.1 Staging | Create staging experience (universe/place) — needs human or API | TODO |
| T-109 | P1 | I-22 Human / E22.2 Playtest | Final human playtest | TODO |
| T-110 | P1 | I-22 Human / E22.3 Approval | Production approval | TODO |

## Detailed entries (ID -> description, deps, owner, files)

### T-001 — Verify 45 recovered scripts match live Studio byte-for-byte
- **Desc:** Diff a sample of recovered files vs live sources; confirm no truncation
- **Priority:** P0 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-002 — Verify Remotes.model.json has all 81 remotes the services reference
- **Desc:** Script-grep every remote usage in services; cross-check model file
- **Priority:** P0 | **Owner:** worker | **Deps:** - | **Files:** -

### T-003 — Verify WorldBuilder reconstructs identical world (island count, node positions)
- **Desc:** Boot test place; compare with recovery dump inventory
- **Priority:** P0 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-004 — Add WorldBuilder regeneration script to repo (scripts/assets/rebuild-world.py)
- **Desc:** Move generator from temp into repo for reproducibility
- **Priority:** P2 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-005 — Verify Screens.luau builds all 12 screens + HUD with correct hierarchy
- **Desc:** Boot test place; compare tree vs recovery dumps
- **Priority:** P0 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-006 — Wire UI Bootstrap (LocalScript) that requires Screens.luau into StarterGui on boot
- **Desc:** Live place has UI built manually; repo needs runtime builder entry
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** src/StarterGui/AetherUI/

### T-007 — Mark recovered design docs with status metadata (Current/Superseded)
- **Desc:** docs/source-design/*.md status headers
- **Priority:** P3 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-008 — Rewrite README with truthful recovered state (replace 'verified' claims with evidence links)
- **Desc:** README claims matrix from REPO_STUDIO_DIFF.md
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-009 — Verify environments.yaml parse + deploy scripts read it
- **Desc:** Run deploy-staging.ps1 -PlaceId to confirm config resolution
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-010 — Verify CI on reforge branch runs (push trigger added)
- **Desc:** Check GitHub Actions run for latest push
- **Priority:** P1 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-011 — Add TestEZ Studio CI job (Windows runner, test place build + run)
- **Desc:** Windows self-hosted or GitHub windows runner with Studio
- **Priority:** P2 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-012 — Trim vendored TestEZ to runtime + license only
- **Desc:** Remove upstream tests/workflows/docs from vendor/testez
- **Priority:** P3 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-013 — Configure GitHub branch protection for master (PR required, status checks)
- **Desc:** gh api repos/.../branches/master/protection
- **Priority:** P2 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-014 — Create GitHub issues for P0/P1 defects + human blockers
- **Desc:** Sync backlog P0/P1 to gh issues
- **Priority:** P2 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-015 — Rate-limit harvest remote (per-player cooldown map in NodeManager)
- **Desc:** Add per-player lastHarvestTime; reject < 1s
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** NodeManager.luau

### T-016 — Validate ChangeIsland target is a registered island
- **Desc:** WorldManager island registry check
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** WorldManager.luau

### T-017 — Validate PurchaseUpgrade cost/level server-side (no client price)
- **Desc:** UpgradeService already checks; verify all paths
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** UpgradeService.luau

### T-018 — Validate all remote payload types/shapes (type checks on every OnServerEvent)
- **Desc:** Audit REMOTE_CATALOG.md coverage; add missing guards
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** -

### T-019 — Add per-player save lock (prevent double-save races)
- **Desc:** SaveProfile guard with in-flight flag
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** PlayerDataService.luau

### T-020 — Add corruption detection (JSON parse check on load)
- **Desc:** SanitizeProfile already merges; add type asserts on critical fields
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** PlayerDataService.luau

### T-021 — Wire AntiCheat into trade/marketplace/upgrade paths (not just harvest)
- **Desc:** Add CheckPlayer calls
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** -

### T-022 — Bound transactionLog + violations tables (memory)
- **Desc:** Cap sizes
- **Priority:** P3 | **Owner:** worker | **Deps:** - | **Files:** -

### T-023 — Write adversarial test list + run in Studio test place
- **Desc:** spam/NaN/negative/dupe/race tests per master §20.3
- **Priority:** P1 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-024 — Test duplicate guild invite / guild name collision
- **Desc:** GuildService validation
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-025 — Document DATA_SCHEMA.md v1 (already exists — verify accuracy post-fixes)
- **Desc:** Review + update
- **Priority:** P2 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-026 — Add migration ledger (MIGRATION_LEDGER.md) + version bump procedure
- **Desc:** Document v1->v2 path
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-027 — Add receipt journal for purchases (ProcessReceipt-ready structure)
- **Desc:** PurchaseService design doc + stub
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-028 — Ensure dev Studio never writes production DataStore (env key prefix)
- **Desc:** DataStore name switch by environment
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** -

### T-029 — Add harvest combo system (consecutive same-type nodes -> multiplier)
- **Desc:** Design + implement in NodeManager; config flag
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-030 — Add critical harvest chance (crit = double yield)
- **Desc:** RNG-based; server-side
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-031 — Node respawn animation/feedback (fade in)
- **Desc:** Tween node transparency on respawn
- **Priority:** P3 | **Owner:** worker-d | **Deps:** - | **Files:** -

### T-032 — Implement tool tiers (Basic Net -> Energy Siphon -> Quantum Harvester -> Chrono Collector)
- **Desc:** Tool item defs + harvest power application
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-033 — Add mobile touch harvest support (tap node = raycast)
- **Desc:** InputHandler touch path
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-034 — Add gamepad support (button harvest near crosshair)
- **Desc:** InputHandler gamepad path
- **Priority:** P3 | **Owner:** worker | **Deps:** - | **Files:** -

### T-035 — Verify economy sims against REAL recovered data (XP curve, upgrade costs)
- **Desc:** Wire sims to Data/ + ProgressionService constants
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-036 — Add level-up celebration (VFX + sound + UI toast)
- **Desc:** LevelUp remote exists; add presentation
- **Priority:** P3 | **Owner:** worker-d | **Deps:** - | **Files:** -

### T-037 — Implement skill tree (Harvesting/Exploration/Trading/Engineering/CreatureCare)
- **Desc:** SkillTreeScreen exists; wire data + server validation
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-038 — Wire achievement unlock notifications (AchievementUnlocked remote -> toast)
- **Desc:** HUDController listener
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-039 — Design + implement prestige (reset for permanent bonus)
- **Desc:** Per master §18.2; config flag
- **Priority:** P3 | **Owner:** worker | **Deps:** - | **Files:** -

### T-040 — Add tame cooldown + proximity validation (server)
- **Desc:** CreatureService
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** -

### T-041 — Verify pet follower cleanup on death/teleport
- **Desc:** PetService (partially done; verify)
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** -

### T-042 — Apply equipped pet bonuses to harvest (HarvestPower/Luck)
- **Desc:** NodeManager yield calc
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-043 — Implement feed pet (consumable) -> hunger/happiness restore
- **Desc:** PetService + UI
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-044 — Design breeding (egg, hatch timer, genetics) — evaluate fit
- **Desc:** Per master §21; likely P3 post-launch
- **Priority:** P3 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-045 — Design evolution tiers per creature
- **Desc:** Content pass on Data/Pets
- **Priority:** P3 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-046 — Strengthen onboarding: guided first 5 minutes (move, harvest, spend, upgrade)
- **Desc:** Quest chain + UI hints
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** -

### T-047 — Expand quest database (zone quests per MAP_DESIGN_NEW)
- **Desc:** Add 10+ quests to Data/Quests
- **Priority:** P2 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-048 — Verify DailyRewardsService streak logic (monthly reward claim)
- **Desc:** Test + fix date handling
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-049 — Wire quest tracker UI updates (QuestUpdated remote)
- **Desc:** HUDController
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-050 — Implement zone registry (11 zones per MAP_DESIGN_NEW) with unlock gating
- **Desc:** ZoneService or WorldManager extension
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-051 — Verify portal travel works with recovered PortalScript (TargetIsland)
- **Desc:** Studio E2E test
- **Priority:** P1 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-052 — Verify FallGuard recovers to SkySanctum
- **Desc:** Studio E2E test
- **Priority:** P1 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-053 — Zone identity pass (per-zone lighting/audio/landmarks) — start with Cloud Gardens
- **Desc:** Design + minimal implementation
- **Priority:** P3 | **Owner:** worker-d | **Deps:** - | **Files:** -

### T-054 — Add Aetherial Sea (reef) layer as first vertical expansion
- **Desc:** Per GDD; P3 scope
- **Priority:** P3 | **Owner:** worker | **Deps:** - | **Files:** -

### T-055 — Wire ScreenController to rebuilt Screens (population on open)
- **Desc:** Verify ScreenController names match rebuilt screens
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-056 — Migrate legacy screens to Component library (Button/Panel/Modal etc.)
- **Desc:** Replace inline construction with Components where beneficial
- **Priority:** P2 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-057 — Add loading/error/empty states to all screens
- **Desc:** Per UI design system
- **Priority:** P2 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-058 — Mobile/tablet responsive pass (safe areas, touch targets >=44px)
- **Desc:** Per UI_DESIGN_SYSTEM.md
- **Priority:** P2 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-059 — Gamepad focus navigation (UIController)
- **Desc:** Per master §24.2
- **Priority:** P3 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-060 — Kimi vision review of rebuilt screens (real screenshots)
- **Desc:** Dispatch worker-e with captures
- **Priority:** P1 | **Owner:** worker-e | **Deps:** - | **Files:** -

### T-061 — Write ART_BIBLE.md (theme, shape language, palette)
- **Desc:** docs/design/ART_BIBLE.md
- **Priority:** P2 | **Owner:** worker-e | **Deps:** - | **Files:** -

### T-062 — Create aether node asset kit in Blender (crystal, ore, herb, tree)
- **Desc:** Blender MCP; 4-8 modular meshes
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-063 — Create tool tier models (4 tiers)
- **Desc:** Blender MCP
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-064 — Create creature models (start: Cloud Sprite, Sky Fox)
- **Desc:** Blender MCP; 2 low-poly creatures
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-065 — Build ASSET_MANIFEST.json with real entries
- **Desc:** For every asset created
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-066 — Import verification loop (scale/pivot/materials in Studio)
- **Desc:** Per master §25.5
- **Priority:** P2 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-067 — Deterministic export recipe script (scripts/assets/export-*.py)
- **Desc:** Blender python
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-068 — Feedback matrix doc for all actions
- **Desc:** docs/design/feedback matrix
- **Priority:** P3 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-069 — Harvest VFX (hit spark, collect trail, crit burst)
- **Desc:** ParticleEmitters/Beams
- **Priority:** P2 | **Owner:** worker-d | **Deps:** - | **Files:** -

### T-070 — Audio event map + sourced SFX (UI/harvest/ambience)
- **Desc:** License-recorded assets only
- **Priority:** P3 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-071 — Harvest animation set (anticipation/strike/recovery) with markers
- **Desc:** Animation rig + controllers
- **Priority:** P3 | **Owner:** worker-d | **Deps:** - | **Files:** -

### T-072 — Reduced-effects mode toggle
- **Desc:** Settings + effect scaling
- **Priority:** P3 | **Owner:** worker-d | **Deps:** - | **Files:** -

### T-073 — Party system (4 players, co-op bonus)
- **Desc:** Design + implement; P3
- **Priority:** P3 | **Owner:** worker | **Deps:** - | **Files:** -

### T-074 — Guild UI wiring (GuildScreen to GuildService)
- **Desc:** Verify remote names match
- **Priority:** P2 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-075 — Trading UI wiring (TradeWindow) + atomicity tests
- **Desc:** Verify recovered flow works
- **Priority:** P1 | **Owner:** worker | **Deps:** - | **Files:** -

### T-076 — Leaderboard UI wiring (RequestLeaderboard)
- **Desc:** Verify remote flow
- **Priority:** P2 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-077 — MONETIZATION_PLAN.md (passes + dev products, ethical)
- **Desc:** Per master §28; no public activation
- **Priority:** P3 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-078 — PurchaseService with ProcessReceipt + journal (idempotent)
- **Desc:** Design + implement; mock tests
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-079 — Shop UI (products listing, purchase confirm)
- **Desc:** Per design system
- **Priority:** P3 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-080 — Implement AnalyticsService funnel events (join->data->first harvest->first upgrade)
- **Desc:** Server-side; no PII
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-081 — Economy telemetry events (source/sink with balance)
- **Desc:** Add to EconomyService
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-082 — Operational metrics (save failures, suspicious remotes)
- **Desc:** AnalyticsService extension
- **Priority:** P3 | **Owner:** worker | **Deps:** - | **Files:** -

### T-083 — Unit tests for recovered pure logic (PureMath done; add QuestProgress, UpgradeCost, RewardGrant)
- **Desc:** Lune specs
- **Priority:** P1 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-084 — Studio integration test bootstrap (boot clean, spawn, harvest E2E)
- **Desc:** test.project.json + TestRunner
- **Priority:** P1 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-085 — Screenshot regression baselines (first join, HUD, inventory, harvest)
- **Desc:** pixelmatch pipeline
- **Priority:** P2 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-086 — Multi-client test (2 players, node sharing, reward isolation)
- **Desc:** Studio multi-client
- **Priority:** P2 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-087 — 30-min soak (leaks, memory, remote spam)
- **Desc:** Profiler evidence
- **Priority:** P3 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-088 — PERFORMANCE_BUDGETS.md with measured baselines
- **Desc:** MicroProfiler captures
- **Priority:** P2 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-089 — Fix per-frame loops / unbounded tasks in recovered services
- **Desc:** Audit task.spawn/while true patterns
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-090 — Verify world streaming config (islands stream properly)
- **Desc:** Studio streaming test
- **Priority:** P3 | **Owner:** worker | **Deps:** - | **Files:** -

### T-091 — Real staging publish via rbxcloud (separate staging universe/place)
- **Desc:** Requires staging place creation (human or API)
- **Priority:** P1 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-092 — ROLLBACK_PLAN.md (previous place, migration record)
- **Desc:** Doc + verify
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-093 — RELEASE_CHECKLIST.md complete (all gates)
- **Desc:** Per master §37
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-094 — Staging smoke test (boot + join + harvest on published place)
- **Desc:** rbxcloud + logs
- **Priority:** P1 | **Owner:** worker-a | **Deps:** - | **Files:** -

### T-095 — Final architecture doc (recovered reality)
- **Desc:** ARCHITECTURE.md refresh
- **Priority:** P2 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-096 — Final truthful README
- **Desc:** Rewrite README with recovered reality
- **Priority:** P1 | **Owner:** worker-c | **Deps:** - | **Files:** -

### T-097 — Delivery package assembly (all artifacts)
- **Desc:** Per master §39
- **Priority:** P2 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-098 — Human playtest request + production approval package
- **Desc:** Final gate
- **Priority:** P1 | **Owner:** orchestrator | **Deps:** - | **Files:** -

### T-099 — Expand item database (20+ items with rarities)
- **Desc:** Data/Items
- **Priority:** P2 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-100 — Quest database expansion (QST001-QST020)
- **Desc:** Data/Quests
- **Priority:** P2 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-101 — Crafting recipes (5+ recipes, profit margins)
- **Desc:** Data/Recipes + CraftingService verify
- **Priority:** P2 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-102 — Event definitions (Aether Storm weekly, Rift Convergence monthly)
- **Desc:** EventService config
- **Priority:** P3 | **Owner:** worker-b | **Deps:** - | **Files:** -

### T-103 — Daily rewards calendar (exists in Rewards data — verify UI)
- **Desc:** DailyRewardsService + UI
- **Priority:** P2 | **Owner:** worker | **Deps:** - | **Files:** -

### T-104 — Kimi review of world (screenshot: SkySanctum overview)
- **Desc:** worker-e real capture review
- **Priority:** P1 | **Owner:** worker-e | **Deps:** - | **Files:** -

### T-105 — Kimi review of each screen (12 screens + HUD)
- **Desc:** worker-e loop until approve
- **Priority:** P1 | **Owner:** worker-e | **Deps:** - | **Files:** -

### T-106 — Kimi review of new Blender assets (nodes/tools/creatures)
- **Desc:** worker-e loop
- **Priority:** P2 | **Owner:** worker-e | **Deps:** - | **Files:** -

### T-107 — Kimi review of mobile/tablet layout
- **Desc:** device emulation captures
- **Priority:** P2 | **Owner:** worker-e | **Deps:** - | **Files:** -

### T-108 — Create staging experience (universe/place) — needs human or API
- **Desc:** Creator Dashboard or Open Cloud place creation
- **Priority:** P1 | **Owner:** HUMAN | **Deps:** - | **Files:** -

### T-109 — Final human playtest
- **Desc:** Human plays the staging build and reports
- **Priority:** P1 | **Owner:** HUMAN | **Deps:** - | **Files:** -

### T-110 — Production approval
- **Desc:** Human approves production publish
- **Priority:** P1 | **Owner:** HUMAN | **Deps:** - | **Files:** -
