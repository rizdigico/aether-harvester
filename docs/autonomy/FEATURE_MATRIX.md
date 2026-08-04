# FEATURE MATRIX

## 1. Product Intent Summary

**Fantasy:** The player is an aether harvester in **Aethros**, a stratified sky-world of floating islands suspended in an endless cerulean void. Height is biome — ascending reveals starlit observatories and astral phenomena; descending plunges into ocean trenches and abyssal depths. The tone is exploration-forward, with a soft neon-aether visual identity (teal, amber, deep indigo).

**Core Loop:** Harvest aether from floating islands → earn Aether Shards → upgrade tools/backpack → access rarer islands → discover legendary creatures → expand sky base → compete on leaderboards.

**Meta Loop:** Daily login → harvest → craft/trade → upgrade → prestige reset → permanent bonuses → repeat with deeper layers. The meta arc is a 100–200 hour journey from novice (Tier 1 Cloud Gardens) to mythic (Tier 5 Abyssal Trench / Astral Observatory), with prestige rebirths extending replayability.

---

## 2. Designed Systems Table

| System | Designed behavior (1–2 lines) | Spec source | Build status (from STATE-REPORT) | Repo presence (file or MISSING) | Priority |
|---|---|---|---|---|---|
| Harvesting | Point at nodes, use tools with range/speed/efficiency; combo multipliers, crits, node respawn timers | GAME_DESIGN_DOC §2, GAME_SPEC §1 | VERIFIED — 29 nodes, harvest→items/XP→HUD live | MISSING (src/ has only placeholder init.luau) | P0 |
| Progression | Level/XP from harvesting/quests; 5-branch skill tree; prestige at Lv100 | GAME_SPEC §4, GAME_SYSTEMS_SPEC §4 | VERIFIED — XP flow, skill points, upgrades wired | MISSING | P0 |
| Inventory & Storage | Backpack slots, 6 rarity tiers, quick-bar, auto-sort/filter | GAME_DESIGN_DOC §4, GAME_SPEC §1 | VERIFIED — ScreenController populates Inventory/Quest/Pet screens | MISSING | P0 |
| Creatures & Pets | 12 creature types; tame → pet inventory → equip → summon follower; 4 pet classes | GAME_SPEC §2, GAME_SYSTEMS_SPEC §1 | VERIFIED — TameCreature remote, follower Model, HUD pet display | MISSING | P0 |
| Quest System | 6 quest types (Fetch/Collect/Deliver/Explore/Boss/Hidden); 20 quests in database | GAME_SPEC §3, GAME_SYSTEMS_SPEC §5 | VERIFIED — quest_first_harvest starter quest, QuestTracker live | MISSING | P0 |
| Economy & Trading | 4 currencies (Shards/Gems/Tokens/Fame); 5% marketplace tax; dynamic pricing | GAME_SYSTEMS_SPEC §3, GAME_SPEC §5 | VERIFIED — currency syncs to HUD after purchase | MISSING | P1 |
| Crafting | Recipes require materials + currency; critical-craft chance; 3 station tiers | GAME_SYSTEMS_SPEC §3.5 | NOT BUILT — no crafting scripts in repo | MISSING | P1 |
| Trading (P2P) | Player-to-player trade with offer validation, scam protection, 7-day expiry | GAME_SYSTEMS_SPEC §3.4 | NOT BUILT — TradeWindow is a stub screen | MISSING | P1 |
| Base Building | Expandable sky base with storage, crafting stations, pens, gardens | GAME_DESIGN_DOC §6, README roadmap | NOT BUILT — listed as roadmap | MISSING | P2 |
| World & Map | 11 zones across 4 vertical layers; procedural node placement; fast-travel beacons | MAP_DESIGN_NEW.md, GAME_DESIGN_DOC §1 | PARTIAL — 10 islands in deliverables workspace; repo has no world geometry | MISSING (repo src/ has no world scripts) | P0 |
| UI Screens (12 total) | StartingScreen, MainMenu, Inventory, QuestLog, Pet, Settings, Rewards, Trade, Guild, SkillTree, Event, Map | UI_UX_SPEC.md, DESIGN-AUDIT.md | PARTIAL — ScreenController populates Inventory/Quest/Pet; others are zero-size stubs | MISSING (src/ has no UI scripts) | P0 |
| HUD | Energy/Health bars, Level, Currency, ToolDisplay, ActiveCreature, QuestTracker, Minimap | UI_UX_SPEC.md, DESIGN-AUDIT.md §3.12 | PARTIAL — DESIGN-AUDIT found all HUD elements at zero size (invisible) | MISSING | P0 |
| Events | Weekly Aether Storm, monthly Rift Convergence, seasonal + holiday events | GAME_SYSTEMS_SPEC §6, GAME_SPEC §6 | NOT BUILT — EventScreen is a stub | MISSING | P3 |
| Social (Guilds/Parties) | Friends (200), parties (4), guilds (30 members), leaderboards, chat | GAME_SYSTEMS_SPEC §7 | NOT BUILT — GuildScreen/TradeWindow are stubs | MISSING | P3 |
| Audio/Visual | Per-biome ambient music, SFX, particle effects, weather, screen effects | GAME_DESIGN_DOC §11 | NOT BUILT | MISSING | P2 |
| DataStore Persistence | Save/load player data via Roblox DataStoreService | GAME_DESIGN_DOC §12, SCRIPTS_AUDIT | NOT BUILT — SCRIPTS_AUDIT flagged missing DataStore integration | MISSING | P0 |
| Security & Validation | Server-authoritative; input validation; anti-exploit; rate limiting | GAME_SYSTEMS_SPEC §10.2 | NOT BUILT — SCRIPTS_AUDIT flagged no RemoteEvents, no validation | MISSING | P0 |

---

## 3. World/Zone Table (from MAP_DESIGN_NEW.md)

| Zone | Layer | Difficulty | Primary Resources | Key Creatures |
|---|---|---|---|---|
| Celestial Nexus | Astral (Sky Realm) | 1 (tutorial) | Aether Shard, Aether Core | Sky Whale (NPC boss) |
| Astral Observatory | Astral | 5 (endgame) | Mythril Dust, Star Fragment | Astral Phoenix, Void Drake |
| Cloud Gardens | Floating | 1 | Aether Shard, Cloud Garden Seeds | Cloud Sprite, Sky Fox |
| Storm Peaks | Floating | 2 | Storm Crystal | Storm Drake, Tempest Hawk |
| Verdant Canopy | Floating | 1 | Verdant Sap, Lush Vines, Moonbell | Forest Nymph, Thornback, Glimmerfox |
| Ashen Maw | Floating | 3 | Ember Core, Obsidian Shard, Sulfur | Magma Salamander, Ash Drake |
| Crystal Canyons | Floating | 2 | Crystal Fragment, Crystal Shard, Prismatic Cluster | Crystal Guardian, Crystal Faerie |
| Ancient Ruins | Floating | 3 | Ancient Relic, Temporal Dust, Sunmetal | Ancient Wyrm, Ancient Stag |
| Void Rifts | Floating | 4 | Void Essence, Void Core, Null Shard | Void Leviathan, Void Wisp, Rift Stalker |
| Luminous Reef | Aetherial Sea | 2 | Prism Coral, Deep Pearl, Coral Bloom | Coral Serpent, Deep Walker, Pearlback |
| Abyssal Trench | Abyssal | 5 | Void Pearl, Abyssal Core, Deep Core | Abyssal Wraith, Deep Terror, Umbral Eel |

---

## 4. Differentiation Analysis

| # | Idea | Player Value | Originality | Dev Cost | Fit | Avg |
|---|---|---|---|---|---|---|
| 1 | **Vertical 4-layer world** (height = biome) — descending into abyss is mechanically and narratively distinct from generic flat Roblox sims | 9 | 9 | 7 | 10 | 8.8 |
| 2 | **Creature breeding with genetics** (mutation chance, parent stat inheritance, hatching timers) — deeper than typical Roblox pet systems | 8 | 8 | 6 | 9 | 7.8 |
| 3 | **Prestige rebirth with permanent auras** — visual identity that persists across resets, creating a status symbol | 7 | 7 | 4 | 9 | 6.8 |
| 4 | **Dynamic marketplace with supply/demand pricing** — player-driven economy rather than static NPC shops | 8 | 6 | 8 | 8 | 7.5 |
| 5 | **Aether Storm weekly event** (all nodes boosted, rare spawns) — recurring live-event cadence | 7 | 5 | 5 | 9 | 6.5 |
| 6 | **Creature combat as optional PvP** (turn-based 3v3, non-lethal) — adds strategy without forcing PvP | 6 | 6 | 7 | 7 | 6.5 |
| 7 | **Base building with visitable player bases** — social hub and reputation system | 7 | 5 | 8 | 7 | 6.8 |
| 8 | **Anti-grind diminishing returns** after 2h continuous play — respects player time, differentiates from pay-to-grind sims | 8 | 4 | 3 | 8 | 5.8 |
| 9 | **Cosmetic-only monetization** (no pay-to-win) — builds trust and long-term retention | 6 | 3 | 2 | 8 | 4.8 |
| 10 | **Procedural terrain generation** (seed + Perlin/fractals per biome) — infinite variety within hand-crafted zones | 5 | 8 | 9 | 6 | 7.0 |
| 11 | **Skill tree synergy bonuses** (3+ points in a branch unlocks ultimate ability) — meaningful build diversity | 7 | 5 | 5 | 8 | 6.3 |
| 12 | **Loot box pity system** with transparent published rates — ethical gacha differentiation | 5 | 4 | 3 | 6 | 4.5 |

---

## 5. Minimum Vertical Slice Checklist

1. **Player joins and spawns** — World + Spawn system; acceptance: character appears at SkySanctum with no errors on boot.
2. **Harvest aether nodes** — Harvesting system + resource nodes in world; acceptance: point at node, press E, receive Aether Shards + XP, HUD updates.
3. **Earn currency from harvest** — Economy system; acceptance: Shards balance increases in HUD after each harvest.
4. **Spend shards on tool upgrade** — Upgrade system + shop; acceptance: purchase Pickaxe upgrade, tool power increases, currency decreases.
5. **Gain XP and level up** — Progression system; acceptance: XP bar fills, level increments, skill point awarded.
6. **Save progress** — DataStore persistence; acceptance: leave game, rejoin, currency/inventory/level preserved.
7. **Rejoin and resume** — Boot + spawn + state restore; acceptance: player reappears at SkySanctum with all prior progress.

---

## 6. Gap Analysis: Designed-vs-Built

### CORE LOOP
- **Designed:** Full harvest→earn→upgrade→access→discover→expand→compete loop across 11 zones, 4 layers, 60+ tools/creatures/items.
- **Built:** Only a placeholder `init.luau` returning `{}` in the repo. The STATE-REPORT describes a verified build, but that build exists in the `.team/deliverables/` workspace, not in `roblox-dev/aether-harvester/src/`. The repo's `src/` contains 5 files total — 4 are empty placeholders, 1 is a basic utility.

### DATA
- **Designed:** Full item database (20+ items), creature database (12 types), quest database (20 quests), skill trees (5 branches × 5 levels), achievement list (40+), economy with 4 currencies.
- **Built:** No data modules exist in the repo. The `.team/deliverables/` workspace has data modules (Items.luau, Creatures.luau, Quests.luau, Recipes.luau, Pets.luau) but these are not in the repo's `src/` tree.

### UI
- **Designed:** 12 fully specified screens with design system (colors, typography, spacing, responsive, accessible), HUD with 9 elements, animations, transitions.
- **Built:** The repo has no UI scripts. The DESIGN-AUDIT found all HUD elements at zero size and all screens as empty stubs in the deliverables workspace. The ScreenController exists there but only populates 3 of 12 screens.

### WORLD
- **Designed:** 11 explorable zones across 4 vertical layers, procedural terrain, lighting/atmosphere per biome, pathfinding, fast-travel.
- **Built:** The repo has no world scripts or place geometry. The deliverables workspace has 10 islands with nodes/creatures/portals, but these are not in the repo.

### SOCIAL
- **Designed:** Friends, parties (4), guilds (30), leaderboards, chat, cooperative harvesting bonuses.
- **Built:** Nothing in repo. GuildScreen and TradeWindow are stubs in the deliverables workspace.

### META
- **Designed:** Daily login rewards, achievements, prestige, events, loot boxes, anti-grind, cosmetic-only monetization.
- **Built:** Nothing in repo. All meta systems are on the roadmap.

---

*Deliverable written by LIVE GAME AUDITOR + GAME DIRECTOR analyst. All claims trace to design docs in `C:\Users\aariz\kilo_HQ\.team\deliverables\` or repo file inspection. No source code was edited.*
