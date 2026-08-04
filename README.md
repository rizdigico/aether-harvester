# Aether Harvester Simulator

A **sky-based resource management and creature-collecting simulator** for Roblox. Harvest floating aether energy, upgrade your tools, befriend magical creatures, complete quests, trade with other players, and climb the leaderboards — all set on a constellation of floating islands in the endless cerulean void of **Aethros**.

> Filesystem-first Roblox project built with **Rojo**. Design specs live in `docs/` (root-level `kilo_HQ/.team/deliverables/` on the dev machine); this README is the living overview.

---

## Table of Contents

1. [Concept & Core Loop](#concept--core-loop)
2. [The World](#the-world)
3. [Game Systems](#game-systems)
4. [Economy & Rarity](#economy--rarity)
5. [What Is Built & Verified](#what-is-built--verified)
6. [Roadmap (Designed, Not Yet Built)](#roadmap-designed-not-yet-built)
7. [Architecture](#architecture)
8. [Development Tooling](#development-tooling)
9. [CI / Deployment](#ci--deployment)
10. [Repository Layout](#repository-layout)

---

## Concept & Core Loop

You play as an **aether harvester** in a stratified sky-world. Each floating island is a biome with its own resources, creatures, and hazards — and the deeper (or higher) you go, the rarer the loot and the fiercer the wildlife.

**Core loop:**

```
Harvest aether from floating islands
        ↓
Earn Aether Shards
        ↓
Upgrade tools / backpack / pets
        ↓
Access rarer islands
        ↓
Discover legendary creatures
        ↓
Grow your base · compete on leaderboards
```

The game is designed for a **100–200 hour playthrough** with anti-grind mechanics (diminishing returns), no pay-to-win (cosmetics only in the Roblox catalog), and new-player protection.

---

## The World

Aethros is a **four-layer vertical archipelago** — height is biome. The current build implements the Floating Archipelago layer; the other three layers are designed and on the roadmap.

```
        Y = 600   ┌────────────────────────────────── ASTRAL HEIGHTS
                  │  Astral Observatory · Celestial Nexus spire
        Y = 349   ├──────────────────────────────────
                  │  ── floating archipelago ceiling
        Y =  39   ├────────────────────────────────── FLOATING ARCHIPELAGO
                  │  Cloud Gardens · Storm Peaks · Verdant Canopy · Ashen Maw
                  │  Crystal Canyons · Ancient Ruins · Void Rifts
        Y =  25   ├────────────────────────────────── AETHERIAL SEA
                  │  Luminous Reef (cloud-sea surface)
        Y =   0   ├────────────────────────────────── WATER LEVEL
        Y = −20   ├────────────────────────────────── ABYSSAL DEPTHS
                  │  Abyssal Trench (sunken city, pressure zones)
        Y = −400  └────────────────────────────────── ABYSSAL FLOOR
```

### Zones (11 explorable + 6 sub-zones)

| ID | Zone | Biome | Layer | Difficulty | Primary Resources | Key Creatures |
|---|---|---|---|---|---|---|
| nexus | Celestial Nexus | Sky Realm | Astral | 1 (tutorial) | Aether Shard, Aether Core | Sky Whale |
| astral | Astral Observatory | Astral | Astral | 5 (endgame) | Mythril Dust, Star Fragment | Astral Phoenix, Void Drake |
| clouds | Cloud Gardens | Aether/Forest | Floating | 1 | Aether Shard, Cloud Garden Seeds | Cloud Sprite, Sky Fox |
| storm | Storm Peaks | Storm/Highland | Floating | 2 | Storm Crystal | Storm Drake, Tempest Hawk |
| forest | Verdant Canopy | Enchanted Forest | Floating | 1 | Verdant Sap, Lush Vines, Moonbell | Forest Nymph, Thornback |
| volcano | Ashen Maw | Volcanic | Floating | 3 | Ember Core, Obsidian Shard, Sulfur | Magma Salamander, Ash Drake |
| crystal | Crystal Canyons | Crystal/Cave | Floating | 2 | Crystal Fragment, Crystal Shard | Crystal Guardian, Crystal Faerie |
| ruins | Ancient Ruins | Ruins/Temporal | Floating | 3 | Ancient Relic, Temporal Dust | Ancient Wyrm, Ancient Stag |
| void | Void Rifts | Void/Rift | Floating | 4 | Void Essence, Void Core, Null Shard | Void Leviathan, Void Wisp |
| reef | Luminous Reef | Ocean/Reef | Aetherial Sea | 2 | Prism Coral, Deep Pearl | Coral Serpent, Pearlback |
| abyss | Abyssal Trench | Abyss/Deep | Abyssal | 5 | Void Pearl, Abyssal Core | Abyssal Wraith, Deep Terror |

**Difficulty** is a 1–5 tier reflecting harvest risk vs. reward (resource rarity, creature aggression, hazards) — **not** a hard gate: free-roam any unlocked island. The skill tree gates deeper islands by level.

**Travel:** portals (ClickDetector + `TargetIsland` attribute) and the island-travel system; falling below the safe line returns you to the hub (FallGuard).

---

## Game Systems

### 1. Harvesting (core action)
- Point at glowing resource nodes (Aether, Crystal, Ore, Herb) and harvest with a tool.
- **Tool tiers:** Basic Net → Energy Siphon → Quantum Harvester → Chrono Collector (each with range/speed/efficiency + special abilities like combos and crits).
- Nodes **respawn on timers** (5–60 min by rarity); rarer drops: Storm Crystal, Void Essence, Crystal Fragment, Ancient Relic, Mythril Dust.
- Combo system: consecutive same-type harvests build multipliers; critical harvests give bonus yield.

### 2. Progression
- **Level/XP** from harvesting, exploring, quests.
- **Skill trees:** Harvesting, Exploration, Trading, Engineering, Creature Care.
- **Achievements** (50+, categories: Harvesting, Combat, Social, Exploration, Collection).
- **Prestige** (endgame reset for permanent bonuses).

### 3. Inventory & storage
- Backpack upgrades expand slots; quick-bar for active tools; auto-sort and filters.
- Item categories: Resource, Tool, Consumable, Decoration, Creature Egg, Component.

### 4. Creatures & pets
- **12+ creature types** with rarity, stats (Health/Attack/Defense/Speed), passive abilities (+harvest speed, +XP) and active abilities (battle skills).
- **Tame** wild creatures → pet inventory → **equip** → **summon a follower** that trails you with class-colored visuals.
- **Pet classes:** Harvester (yield boost), Combat (fights), Support (buffs), Mount (speed/flight).
- Pet stats: Level, XP, Hunger, Happiness, Energy — hunger/energy decay over time.
- **Breeding & fusion** (roadmap): eggs, hatching timers, genetics with mutation chance.

### 5. Quests
- Types: **Fetch, Collect, Deliver, Explore, Boss**.
- Examples: QST001 *First Harvest* (harvest 10 Aether Shards → 50 XP + Basic Net), QST003 *Void Wanderer* (visit Void Rifts → Void Core egg), QST010 *Ancient Wyrm Slayer* (boss → 800 XP + Ancient Relic).
- Rewards: XP, currency, tools, creature eggs, decorations, base blueprints.

### 6. Base building *(roadmap)*
- Personal sky base starts as a small platform; expand with storage, crafting stations, creature pens, garden plots, telescope. Visitable by other players; base rating system.

### 7. Trading & marketplace *(partially roadmap)*
- Player-to-player trades with offer validation; 5% marketplace tax; trade limits; scam protection (value-mismatch warnings); offers expire after 7 days.
- Crafting stations (basic home / advanced guild / master special zone); critical-craft chance for rarity bump.

### 8. Social *(roadmap)*
- Friends & parties (up to 4), cooperative harvesting bonuses, **guilds** (up to 20 players, shared vault, guild island), leaderboards (individual + guild).

### 9. Events *(roadmap)*
- Weekly **Aether Storm** (boosted nodes, rare spawns), monthly **Rift Convergence** (special dimension), seasonal + holiday events with limited creatures/cosmetics.

### 10. Rewards *(roadmap)*
- 30-day daily-login calendar with streak bonuses (+50% on days 7/14/21/28, monthly rare on day 30).
- Loot boxes with transparent published rates, pity system (rare at 50, legendary at 200 pulls), duplicate protection.

---

## Economy & Rarity

### Currencies
| Currency | Source | Sink | Exchange |
|---|---|---|---|
| Aether Shards | Harvesting, quests | Upgrades, shop | soft currency (1:1000) |
| Aether Gems | Daily, achievements | Premium shop, trades | hard currency (1:10000) |
| Event Tokens | Events | Event shop | event-specific |
| Fame Points | Leaderboards, guilds | Prestige, cosmetics | prestige-specific |

### Rarity tiers
| Rarity | Color | Base Value | Drop Rate |
|---|---|---|---|
| Common | White/Gray | 1–10 shards | 60% |
| Uncommon | Green | 10–50 | 25% |
| Rare | Blue | 50–200 | 10% |
| Epic | Purple | 200–1000 | 4% |
| Legendary | Gold | 1000–5000 | 0.9% |
| Mythic | Mythril | 5000+ | 0.1% |

Inflation controls: currency sinks (repairs, upgrades, travel), dynamic pricing, tool durability, luxury taxes on high-value trades.

---

## What Is Built & Verified

Status: **VERIFIED** — boot clean, all core loops proven end-to-end in Studio play mode (see `docs/` and the hardening/revamp evidence reports).

| System | State |
|---|---|
| Boot & spawn | ✅ Player spawns at SkySanctum (0, 147, 0); FallGuard; 24 services init with zero errors |
| World | ✅ 10 floating islands (multi-tier rock, grass caps, tapered skirts), lighting/fog/atmosphere tuned |
| Harvesting | ✅ 29 harvest nodes (NodeId attrs); harvest → items/shards/XP → live HUD updates |
| Questing | ✅ Starter quest *First Harvest*: accept → progress → complete → rewards; quest log UI with live progress |
| Pets | ✅ Tame (TameCreature) → pet records (InstanceId/PetId/Level) → equip → summon visible server-side follower → HUD "Pet: Cloud Sprite" → release despawns |
| Upgrades | ✅ Purchase with escalating costs; currency syncs to HUD instantly |
| Screens | ✅ Inventory / Quest Log / Pet screens populate live from server data (rarity-colored cards, tab filters) |
| Travel | ✅ 5 portals wired; ChangeIsland remote proven across islands |
| Data | ✅ Server-authoritative; AddPet normalized to structured records; Pets database extended with all tameable creature IDs |

---

## Roadmap (Designed, Not Yet Built)

- Astral Heights, Aetherial Sea (reef) and Abyssal Depths layers
- Day/night cycle, weather
- Creature battles (turn-based 3v3), breeding, fusion, pet gear
- Base building + visiting/rating
- Marketplace listings, player-to-player trading, crafting
- Guilds, parties, friends, cooperative bonuses
- Skill trees, prestige, achievements breadth
- Daily rewards, loot boxes, events (Aether Storm, Rift Convergence, seasonal)
- Per-biome audio, mobile touch controls
- Open Cloud staging deployment + smoke tests

---

## Architecture

**Server-authoritative by design.** All currencies, inventory, quests, pets, and upgrades are owned and validated server-side; the client only renders and sends intents. No remote trusts client claims.

```
ServerScriptService/AetherServer/
├── GameServices/          # 24 services (PlayerData, Node, Quest, Pet, Creature,
│                          #   Upgrade, Progression, Achievement, Economy, ...)
└── (ServerMain boot)

ReplicatedStorage/AetherShared/
├── Data/                  # read-only data: Items, Creatures, Pets, Quests, Recipes
├── Modules/GameClient     # client state mirror + remote helpers
└── Remotes                # named remotes (single source of truth)

StarterPlayer/StarterPlayerScripts/
├── ClientBootstrap · InputHandler · HUDController · UIController · ScreenController · Minimap

Workspace/AetherWorld/
├── Islands/               # island models + harvest node Models (NodeId attrs)
├── Creatures/             # creature Models (CreatureId attrs)
├── (Portals, Props)
```

**Data flow example (harvest):** client raycast → find Model with `NodeId` → fire `HarvestResource` → NodeManager validates (exists, cooldown) → grants item+XP → fires `NodeHarvested` + `UpdateHUD` → GameClient credits `State.Currency`/`State.Inventory` → HUD renders.

**Key principles:** one remote per command; data modules read-only at runtime; node/creature discovery via attributes; services return `false, reason` rather than throwing.

---

## Development Tooling

Pinned via **Rokit** (`rokit.toml`) — run commands from this directory so the `.rokit/bin` shims resolve.

| Tool | Version | Purpose |
|---|---|---|
| Rojo | 7.7.0 | Filesystem ↔ Studio sync / build |
| StyLua | 2.5.2 | Luau formatting |
| Selene | 0.31.0 | Luau linting (`std = "roblox+testez"`) |
| Lune | 0.10.5 | Standalone Luau runtime + engine-free unit tests |
| Luau LSP | 1.69.0 | Type checking |
| TestEZ | vendored (`vendor/testez/`) | BDD unit tests inside Studio |
| rbxcloud | 0.17.0 | Open Cloud publish CLI |
| pixelmatch | ^7 | Screenshot visual regression |

**Common commands:**

```bash
stylua --check src tests      # formatting gate
selene src tests              # lint gate
luau-lsp analyze --defs=scripts/types/globalTypes.d.luau \
  --defs=scripts/types/testez.d.luau --sourcemap=sourcemap.json src   # typecheck
rojo build --output aether-harvester.rbxlx              # build main place
rojo build test.project.json --output test-place.rbxlx  # build test place
lune run scripts/run-unit-tests.luau                    # pure-Luau unit tests
node scripts/compare-screenshots.mjs <name>             # visual regression
rojo serve                                              # live-sync to Studio (Rojo plugin)
```

**Workflow:** edit files on disk → `rojo serve` syncs to Studio → play-test → run gates above → commit. All code must pass StyLua + Selene + typecheck + tests before merge (Definition of Done: `docs/definition-of-done.md`).

---

## CI / Deployment

GitHub Actions (`.github/workflows/`):

- **`ci.yml`** — on push/PR to `master`: StyLua check → Selene lint → Rojo main build → Rojo test build → upload artifacts. (Rokit installed from release zip; `GITHUB_TOKEN` passed to avoid API rate limits.)
- **`publish-staging.yml`** — manual push-triggered staging build; wired for `rbxcloud experience publish` once Open Cloud publishing is enabled for the place.

**Deployment config:** `config/games.json` registers the game's universe/place IDs (universe `10612238315`, place `97649669204650`). The Open Cloud API key lives only in CI secrets (`ROBLOX_OPEN_CLOUD_API_KEY`) and the local gitignored `.env.local` — never in the repo.

---

## Repository Layout

```
.
├── AGENTS.md                    # agent instructions for this repo
├── default.project.json         # main game Rojo build
├── test.project.json            # game + TestEZ + TestRunner build
├── rokit.toml                   # pinned toolchain versions
├── selene.toml / stylua.toml    # lint + format config
├── testez.yml                   # TestEZ globals for selene
├── config/games.json            # universe/place ID registry
├── src/                         # game source (Rojo-mapped)
│   ├── ReplicatedStorage/AetherShared/
│   ├── ServerScriptService/AetherServer/
│   ├── StarterPlayer/StarterPlayerScripts/
│   ├── StarterGui/AetherUI/
│   └── Workspace/AetherWorld/
├── tests/                       # TestEZ bootstrap + Lune unit specs
├── scripts/                     # deploy scripts, test runner, visual regression
├── vendor/testez/               # pinned TestEZ
├── .github/workflows/           # CI + staging publish
└── docs/                        # architecture, coding, security, asset style,
                                 # UI design system, testing, performance, DoD
```

---

## Full Design References

The complete design documentation (item/creature/quest databases, systems specs, world/map design, UI wireframes, asset plans) lives in `kilo_HQ/.team/deliverables/` on the development machine:

- `GAME_DESIGN_DOCUMENT.md` — concept, core loop, systems overview
- `GAME_SPEC.md` — item, creature, quest databases + balance
- `GAME_SYSTEMS_SPEC.md` — deep system specs (pets, rewards, economy, crafting)
- `MAP_DESIGN_NEW.md` — world map, vertical layers, zone tables
- `UI_UX_SPEC.md`, `SCRIPTS_AUDIT.md`, `ASSET_PLAN.md`, `RESEARCH_TOP_SIMULATORS.md`
