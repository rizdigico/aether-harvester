# BACKLOG — Aether Harvester Reforge

Hierarchy: Initiative → Epic → Feature → Task → Verification task.
Priority: P0 (data loss/security/startup) → P1 (core loop) → P2 (important feature) → P3 (quality) → P4 (enhancement).
Status: TODO / ACTIVE / DONE / BLOCKED

**Ground truth:** the verified game (24 services, AetherWorld, E2E-proven) exists ONLY in the live Studio place (universe 10612238315, place 97649669204650). The repo currently holds scaffold stubs + the original prototype (deliverables/scripts, HubIsland era). **Migration of the live source into the repo is P0** — blocked on H-001 (enable Studio MCP).

---

## INITIATIVE I-1: SOURCE-OF-TRUTH RESTORATION (P0)

### Epic E1.1 — Migrate live game source into repo
- [ ] T-1.1.1 (P0) Enable Studio MCP (H-001) — BLOCKED on human
- [ ] T-1.1.2 (P0) Dump ServerScriptService/AetherServer tree → src/ServerScriptService/AetherServer
- [ ] T-1.1.3 (P0) Dump ReplicatedStorage/AetherShared tree → src/ReplicatedStorage/AetherShared
- [ ] T-1.1.4 (P0) Dump StarterPlayerScripts + StarterGui/AetherUI → src/
- [ ] T-1.1.5 (P0) Dump Workspace/AetherWorld structure spec (parts/nodes/creatures as builder scripts or .rbxmx) → src/Workspace/AetherWorld
- [ ] T-1.1.6 (P0) Replace prototype scripts with revamp source; delete stale files
- [ ] T-1.1.7 (P0) Rojo build must produce a place that boots (verify via Studio)
- [ ] V-1.1.8 (P0) Verification: boot test in Studio, console clean, spawn at SkySanctum

### Epic E1.2 — Config/IDs
- [ ] T-1.2.1 (P1) Verify games.json registry matches live universe/place (DONE: 10612238315/97649669204650)
- [ ] T-1.2.2 (P1) Environment separation config (development/staging/production IDs) — config/environments.json

---

## INITIATIVE I-2: AUDIT-BACKED CORRECTNESS (P0/P1)

### Epic E2.1 — P0/P1 from audits
- [ ] T-2.1.1 (P1) Remote catalog: enumerate ALL remotes from dumped source → docs/autonomy/SECURITY_MODEL.md
- [ ] T-2.1.2 (P1) Server-authority audit: flag any client-authoritative currency/inventory mutations
- [ ] T-2.1.3 (P1) DataStore schema + versioning + migrations (PlayerDataService v1)
- [ ] T-2.1.4 (P1) Error handling: replace silent failures with structured results
- [ ] T-2.1.5 (P1) Input validation on every remote (type/shape/range/ownership)
- [ ] T-2.1.6 (P1) Rate limits / cooldowns on harvest, tame, trade, purchase

### Epic E2.2 — Unit test foundation
- [ ] T-2.2.1 (P1) TestEZ wiring verified against real modules (not placeholders)
- [ ] T-2.2.2 (P1) Economy math tests: upgrade costs, harvest yields, XP curves
- [ ] T-2.2.3 (P1) Quest progress tests: accept/update/complete/reward
- [ ] T-2.2.4 (P1) Inventory tests: add/remove/stack/equip

---

## INITIATIVE I-3: CORE LOOP POLISH (P1)

### Epic E3.1 — Harvest feel
- [ ] T-3.1.1 (P2) Harvest anticipation/action/recovery feedback (animation + VFX + sound)
- [ ] T-3.1.2 (P2) Combo/critical systems per GDD
- [ ] T-3.1.3 (P2) Node respawn timers by rarity (5–60 min per GDD)
- [ ] T-3.1.4 (P2) Tool tiers: Basic Net → Energy Siphon → Quantum Harvester → Chrono Collector
- [ ] T-3.1.5 (P2) Mobile + gamepad harvest input

### Epic E3.2 — First-session experience
- [ ] T-3.2.1 (P1) Onboarding: tutorial objectives (harvest 5 shards → spend → upgrade)
- [ ] T-3.2.2 (P1) Starter quest chain per GAME_SPEC (QST001-style)
- [ ] T-3.2.3 (P2) Clear currency understanding (HUD shard counter + gain feedback)

---

## INITIATIVE I-4: DATA LAYER (P1)

- [ ] T-4.1 (P1) Versioned typed profile schema (currencies, inventory, progression, quests, pets, entitlements, migrationVersion)
- [ ] T-4.2 (P1) Load retries + backoff; corruption detection; recovery
- [ ] T-4.3 (P1) Save retries; autosave; player-removing save; shutdown save
- [ ] T-4.4 (P1) Receipt journal + idempotent rewards
- [ ] T-4.5 (P1) Migration framework + tests
- [ ] T-4.6 (P2) Test-environment data isolation (dev datastore keys)

---

## INITIATIVE I-5: UI SYSTEM (P2)

### Epic E5.1 — Design system
- [ ] T-5.1.1 (P2) docs/design/UI_DESIGN_SYSTEM.md (tokens: colors, type, spacing, radius, strokes)
- [ ] T-5.1.2 (P2) Reusable component library (Button, Panel, Tooltip, Modal, Toast, ListItem)
- [ ] T-5.1.3 (P2) Responsive constraints (mobile/tablet/desktop/gamepad)

### Epic E5.2 — Screens
- [ ] T-5.2.1 (P2) HUD (health/energy/level/XP/currency/quickbar/minimap/quest tracker)
- [ ] T-5.2.2 (P2) Inventory (tabs, sort, filter, empty states)
- [ ] T-5.2.3 (P2) Upgrade screen
- [ ] T-5.2.4 (P2) Quest log
- [ ] T-5.2.5 (P2) Pet/companion management
- [ ] T-5.2.6 (P2) Shop + monetization prompts
- [ ] T-5.2.7 (P2) Settings, achievements, leaderboards, events, codes, notifications
- [ ] T-5.2.8 (P3) Loading/failure/retry states everywhere

---

## INITIATIVE I-6: WORLD & ZONES (P2)

- [ ] T-6.1 (P2) 11-zone registry per MAP_DESIGN_NEW (difficulty tiers, unlock gating)
- [ ] T-6.2 (P2) Zone identity: lighting, audio, landmarks, hazards
- [ ] T-6.3 (P2) Fast travel: portals + unlock flow
- [ ] T-6.4 (P2) FallGuard per-zone safe returns
- [ ] T-6.5 (P2) Aetherial Sea (reef) layer — first vertical expansion
- [ ] T-6.6 (P3) Astral Heights + Abyssal Depths layers

---

## INITIATIVE I-7: PROGRESSION & ECONOMY (P2)

- [ ] T-7.1 (P2) Level/XP curves + skill points
- [ ] T-7.2 (P2) Skill trees (Harvesting, Exploration, Trading, Engineering, Creature Care)
- [ ] T-7.3 (P2) Upgrade paths with visual/mechanical consequence per upgrade
- [ ] T-7.4 (P2) Currency model (shards/gems/tokens/fame) sources+sinks simulation
- [ ] T-7.5 (P2) Achievements (50+) with tiers
- [ ] T-7.6 (P3) Prestige system

---

## INITIATIVE I-8: CREATURES & PETS (P2)

- [ ] T-8.1 (P2) Creature data: 12 types per GAME_SPEC (stats, abilities, biomes)
- [ ] T-8.2 (P2) Tame flow polish (proximity, animation, cooldown, server validation)
- [ ] T-8.3 (P2) Pet follower visuals (class-colored, animated)
- [ ] T-8.4 (P2) Pet leveling, hunger/happiness/energy decay + feeding
- [ ] T-8.5 (P2) Pet bonuses applied to harvest (HarvestPower/Luck/Speed)
- [ ] T-8.6 (P3) Breeding with genetics + mutation
- [ ] T-8.7 (P3) Battles (3v3 turn-based) — evaluate fit

---

## INITIATIVE I-9: SOCIAL (P3)

- [ ] T-9.1 (P3) Parties (4) + co-op harvest bonus
- [ ] T-9.2 (P3) Friends list
- [ ] T-9.3 (P3) Guilds (20 players, vault, guild island)
- [ ] T-9.4 (P3) Leaderboards (individual + guild)
- [ ] T-9.5 (P3) Trading (locked behind security review: idempotency, anti-dupe, audit)

---

## INITIATIVE I-10: CONTENT (P3)

- [ ] T-10.1 (P3) Items database per GAME_SPEC (20+ items, rarities, drop rates)
- [ ] T-10.2 (P3) Quests database (QST001–QST020)
- [ ] T-10.3 (P3) Crafting recipes + stations
- [ ] T-10.4 (P3) Daily rewards (30-day calendar + streaks)
- [ ] T-10.5 (P3) Events (Aether Storm weekly, Rift Convergence monthly)

---

## INITIATIVE I-11: ASSETS (Blender) (P2/P3)

- [ ] T-11.1 (P2) Art bible: docs/design/ART_BIBLE.md
- [ ] T-11.2 (P2) Harvest node assets (aether crystal, ore, herb, tree) — Blender
- [ ] T-11.3 (P2) Tool assets (4 tiers) — Blender
- [ ] T-11.4 (P2) Creature models (12 types) — Blender
- [ ] T-11.5 (P3) Zone architecture kits (islands, ruins, crystals, void)
- [ ] T-11.6 (P3) Props/foliage/portals/machines
- [ ] T-11.7 (P2) ASSET_MANIFEST.json maintained
- [ ] T-11.8 (P2) Import verification loop (scale/pivot/materials/collision)

---

## INITIATIVE I-12: VFX + AUDIO + ANIMATION (P3)

- [ ] T-12.1 (P3) Feedback matrix for all actions
- [ ] T-12.2 (P3) VFX: harvest hit/complete/crit/combo/rare/upgrade/unlock
- [ ] T-12.3 (P3) Effect pooling + reduced-effects mode
- [ ] T-12.4 (P3) Animation set (harvest cycles, tool tiers, pet idles)
- [ ] T-12.5 (P3) Audio: UI/harvest/ambience/music with licensed assets

---

## INITIATIVE I-13: MONETIZATION (P3)

- [ ] T-13.1 (P3) MONETIZATION_PLAN.md (passes + developer products, ethical)
- [ ] T-13.2 (P3) Centralized purchase service (receipt journal, idempotent)
- [ ] T-13.3 (P3) Product catalog config + icons
- [ ] T-13.4 (P3) Dashboard prep docs (exact actions) — NO real activation without human

---

## INITIATIVE I-14: ANALYTICS (P3)

- [ ] T-14.1 (P3) Server-side analytics service (funnels: join→data→first harvest→first upgrade)
- [ ] T-14.2 (P3) Economy telemetry (source/sink events)
- [ ] T-14.3 (P3) Custom events + operational metrics

---

## INITIATIVE I-15: SECURITY (P1/P2)

- [ ] T-15.1 (P1) SECURITY_MODEL.md (threat model, remote inventory, validation matrix)
- [ ] T-15.2 (P1) Adversarial test suite (spam, forged payloads, dupes, races)
- [ ] T-15.3 (P2) Logging of suspicious behavior
- [ ] T-15.4 (P2) Anti-exploit: movement/zone validation

---

## INITIATIVE I-16: PERFORMANCE (P2)

- [ ] T-16.1 (P2) PERFORMANCE_BUDGETS.md (client/server/memory/network)
- [ ] T-16.2 (P2) Baseline profile (Studio MicroProfiler) — needs H-001
- [ ] T-16.3 (P2) Fix per-frame loops/leaks/particle overdraw
- [ ] T-16.4 (P2) Long-session leak tests

---

## INITIATIVE I-17: TESTING INFRA (P1)

- [ ] T-17.1 (P1) Test pyramid wired: static gates (done) + unit (TestEZ) + integration (Studio) + E2E bots
- [ ] T-17.2 (P1) Machine-readable test results JSON
- [ ] T-17.3 (P2) Screenshot regression baselines (desktop/mobile/low-gfx)
- [ ] T-17.4 (P2) Multi-client tests (2 clients, state isolation)
- [ ] T-17.5 (P2) Network-condition tests (latency/jitter)

---

## INITIATIVE I-18: RELEASE (P2)

- [ ] T-18.1 (P2) Staging publish via rbxcloud (saved version) + smoke test
- [ ] T-18.2 (P2) Rollback procedure + previous place preservation
- [ ] T-18.3 (P2) RELEASE_CHECKLIST.md complete
- [ ] T-18.4 (P2) Production approval gate (human) — never auto

---

## INITIATIVE I-19: DOCUMENTATION (ongoing)

- [ ] T-19.1 (P3) GAME_DESIGN_DOCUMENT.md v2 (post-audit product thesis + pillars)
- [ ] T-19.2 (P3) ARCHITECTURE.md (final service boundaries)
- [ ] T-19.3 (P3) SYSTEM_INVENTORY.md refreshed after migration
- [ ] T-19.4 (P3) README refresh at milestones
