# Aether Harvester Simulator — Architecture Reference
> Systems Architect deliverable. Research + design only; no game code changed.

---

## 1. Final Service Boundaries (Server)

Every service below is a Luau module returning an interface table. No global state. Dependencies are explicit `require()` paths.

```
src/ServerScriptService/AetherServer/
  ├── init.luau                          # Deterministic startup orchestrator
  ├── GameServices/
  │   ├── Bootstrapper.luau              # Loads config, sets env, wires remotes
  │   ├── ConfigService.luau             # Single source of truth for tunables + flags
  │   ├── DataStoreService.luau          # Roblox DataStore proxy, retry + fallback
  │   ├── PlayerDataService.luau         # Player lifecycle, cache, dirty tracking, batch write
  │   ├── SessionService.luau            # Per-player session (telemetry, cleanup, join/leave)
  │   ├── WorldManager.luau              # Zone topology, streaming, spawn rules
  │   ├── NodeManager.luau               # Resource node lifecycle, respawn timers, state
  │   ├── HarvestingService.luau         # Harvest validation, loot rolls, tool durability
  │   ├── CreatureService.luau           # Wild spawns, tame logic, pet state machine
  │   ├── PetService.luau                # Player pet inventory, XP, fusion, hunger/energy
  │   ├── ProgressionService.luau        # XP, levels, skill points, prestige, unlocks
  │   ├── QuestService.luau              # Quest lifecycle, objective evaluation, reward dispatch
  │   ├── EventService.luau              # Seasonal/global events, schedules, catch-up
  │   ├── TradingService.luau            # Marketplace, trade offers, anti-scam validation
  │   ├── SocialService.luau             # Friends, parties, guilds, chat routing
  │   ├── CombatService.luau             # Damage, aggro, PvP consent, boss phases
  │   ├── EconomyService.luau            # Currency operations, sinks, dynamic pricing
  │   ├── CraftingService.luau           # Recipes, station validation, critical craft rolls
  │   ├── RewardService.luau             # Daily login, achievements, loot-box, overflow mailbox
  │   ├── AntiExploitService.luau        # Speed caps, fly/noclip heuristics, rate limit checks
  │   └── TelemetryService.luau          # Structured logging, metrics, anomaly alerts
  └── Remotes/                           # Generated contract stubs (see §4)
      └── RemoteCatalog.luau
```

### Startup Order (Server)
1. `Bootstrapper` → 2. `ConfigService` → 3. `TelemetryService` → 4. `AntiExploitService` → 5. `DataStoreService` → 6. `PlayerDataService` → 7. `WorldManager` → 8. `NodeManager` → 9. `HarvestingService` → 10. `CreatureService` + `PetService` → 11. `ProgressionService` → 12. `QuestService` + `EventService` → 13. `EconomyService` + `CraftingService` → 14. `TradingService` + `SocialService` + `CombatService` → 15. `RewardService` → 16. `SessionService`.

Owned data per service: see §5 for data-flow; each service mutates only its aggregate root and publishes via events.

---

## 2. Client Architecture

```
src/StarterPlayer/StarterPlayerScripts/Client/
  ├── Boot.client.luau                   # Client bootstrap, feature flags, remote registration
  ├── Controllers/
  │   ├── HarvestController.client.luau  # Input → remote dispatch, feedback animation
  │   ├── InventoryController.client.luau # Drag-drop, quick-bar, sort, filter
  │   ├── PetController.client.luau       # Equip, feed, ability trigger
  │   ├── QuestController.client.luau     # Tracker, log, auto-navigate
  │   ├── TradeController.client.luau     # Offer UI, confirmation dialogs
  │   ├── SocialController.client.luau    # Friends, party, guild UI
  │   └── SettingsController.client.luau  # Graphics, controls, audio sliders
  ├── UI/
  │   ├── HUD/
  │   │   ├── HUDTop.client.luau         # Level, XP, currency, energy bars
  │   │   ├── Minimap.client.luau        # Zone radar, player/pet icons
  │   │   └── QuickBar.client.luau       # Tool + consumable slots
  │   ├── Inventory/
  │   ├── SkillTree/
  │   ├── QuestLog/
  │   ├── PetBook/
  │   ├── Marketplace/
  │   ├── GuildPanel/
  │   └── Dialogs/                       # Confirmation, alert, reward popup, trade window
  ├── Input/
  │   ├── InputMapper.client.luau        # Keyboard/mouse/touch binding table
  │   └── InputState.client.luau         # Held/pressed/released state machine
  ├── Camera/
  │   ├── CameraController.client.luau   # Follow, orbit, zone transitions
  │   └── CameraEffects.client.luau      # Shake, focus, zoom curves
  ├── Effects/
  │   ├── VFXService.client.luau         # Particle, beam, trail, ripples (reusable)
  │   └── ScreenEffect.client.luau        # Weather, rifts, hit flashes
  ├── Audio/
  │   ├── AudioService.client.luau        # Music playlist, biome ambience, ducking
  │   └── SFXPool.client.luau             # One-shot pool to avoid GC spikes
  └── Navigation/
      ├── FastTravel.client.luau          # Unlocked-island teleport queue
      └── PathingHint.client.luau         # Navmesh waypoint overlay
```

Rule: client is a thin reactive shell. All state lives server-side; client only predicts UI transitions and requests actions via remotes.

---

## 3. Shared Layer

```
src/ReplicatedStorage/AetherShared/
  ├── init.luau                          # Dependency-order require guard
  ├── Types/
  │   ├── Domain.luau                    # All export types (§9 of spec) + new schemas
  │   ├── RemoteTypes.luau               # Remote request/response contracts
  │   └── ConfigTypes.luau               # FeatureFlag, Environment, Tunable types
  ├── Config/
  │   ├── Constants.luau                 # Immutable IDs, colors, rarity tiers, drop tables
  │   ├── Tunables.luau                  # Balance numbers (loaded at runtime from JSON)
  │   ├── FeatureFlags.luau              # FeatureFlag enum + current state
  │   └── Environment.luau               # Dev/Staging/Prod selector + DataStore names
  ├── Content/
  │   ├── Items.luau                     # Item definition catalog (content-driven)
  │   ├── Creatures.luau                 # Creature stats, abilities, spawn weights
  │   ├── Quests.luau                    # Quest definitions, objectives, rewards
  │   ├── Recipes.luau                   # Crafting recipes, station requirements
  │   ├── Zones.luau                     # Zone definitions, biomes, node spawn tables
  │   └── Achievements.luau              # Achievement catalog, conditions, rewards
  ├── Domain/                            # Pure logic — no Roblox services touched
  │   ├── InventoryLogic.luau            # Stack math, sort, filter, merge
  │   ├── HarvestLogic.luau              # Loot tables, crit multipliers, combo curves
  │   ├── ProgressionLogic.luau           # XP curves, prestige math, skill point budget
  │   ├── PetLogic.luau                  # Fusion genetics, hunger/energy decay, XP
  │   ├── QuestLogic.luau                # Objective evaluation, prerequisite checks
  │   ├── EconomyLogic.luau              # Currency math, tax, dynamic price bounds
  │   ├── TradeLogic.luau                # Value validation, duplicate detection
  │   ├── CraftingLogic.luau             # Recipe validation, critical craft chance
  │   └── CombatLogic.luau               # Damage formulas, resistance, aggro table
  ├── Net/
  │   ├── RemoteRegistry.luau            # Central remote catalog (mirrors §4)
  │   ├── Request.luau                   # Client request builder with validation
  │   └── Response.luau                  # Server response envelope + error codes
  └── Utils/
      ├── MathUtil.luau                  # RNG, clamp, lerp, curve evaluation
      ├── TableUtil.luau                 # Deep copy, merge, diff
      ├── StringUtil.luau                # Slug, pretty print
      ├── TimeUtil.luau                  # Format, cooldown, elapsed
      └── Validate.luau                  # Shared schema validators
```

---

## 4. Remote Catalog Schema

Every remote must document this exact contract. Store as a typed entry in `RemoteRegistry.luau`.

```lua
export type RemoteContract = {
    Name: string,
    Direction: "ClientToServer" | "ServerToClient" | "Bidirectional",
    Payload: {
        In: { [string]: string },   -- arg name -> type string
        Out: { [string]: string },  -- return/event fields -> type string
    },
    Validation: string,             -- reference to Validate.<fn>
    RateLimit: {
        WindowSec: number,
        MaxCalls: number,
        Scope: "PerPlayer" | "PerIP",
    },
    FailureResponse: {
        Code: string,
        ClientMessage: string,
        ServerAction: "Log" | "Kick" | "Rollback" | "Ignore",
    },
    Deprecation: string?,           -- "v2 replaces this at date", or nil
}
```

Example:
```lua
{
    Name = "HarvestResource",
    Direction = "ClientToServer",
    Payload = {
        In = { NodeId = "string", ToolId = "string" },
        Out = { Resources = "ItemStack[]", XP = "number", Crit = "boolean" }
    },
    Validation = "Validate.HarvestRequest",
    RateLimit = { WindowSec = 1, MaxCalls = 5, Scope = "PerPlayer" },
    FailureResponse = {
        Code = "HARVEST_RATE_LIMIT",
        ClientMessage = " harvesting too fast",
        ServerAction = "Log"
    },
}
```

---

## 5. Data Flow Diagrams (Text)

### 5.1 Harvest
```
Client: HarvestController → RemoteRegistry.Request("HarvestResource", {NodeId, ToolId})
  ↓
Server: AntiExploit (rate + speed check) → HarvestingService (validate node state, tool durability)
  ↓
  → HarvestLogic (loot roll, combo multiplier, crit roll)
  ↓
  → InventoryLogic (stack merge)
  → ProgressionService (grant XP)
  → PetService (apply Harvester bonus)
  → EconomyService (record yield for dynamic pricing)
  ↓
  → Response: {Resources, XP, Crit}
  ↓
Client: VFXService (particle burst), SFX (thunk), HUD (+XP pop, currency tick)
```

### 5.2 Purchase (Shop)
```
Client: TradeController → RemoteRegistry.Request("PurchaseItem", {ItemId, Quantity})
  ↓
Server: AntiExploit → EconomyService (deduct currency, cap check)
  ↓
  → InventoryLogic (create ItemStacks)
  → RewardService (overflow mailbox if inventory full)
  ↓
  → Response: {NewBalance, GrantedItems, Overflowed}
  ↓
Client: InventoryUI (refresh), HUD (currency update)
```

### 5.3 Quest
```
Server: WorldManager (on enter zone) / ProgressionService (on level up) / Timer (daily reset)
  ↓
  → QuestService (evaluate eligible quests)
  → RemoteRegistry.FireClient("QuestAvailable", {QuestId, Type})
  ↓
Client: QuestController → AcceptQuest
Server: QuestService (accept, lock, track objectives)
  ↓
  → [On objective complete] → UpdateQuestProgress (server → client)
  ↓
  → [On all complete] → RewardService (grant XP, items, currency)
  → ProgressionService (XP)
  ↓
  → Response: {QuestId, State, Rewards}
```

### 5.4 Pet Tame
```
Client: PetController → RemoteRegistry.Request("TameCreature", {CreatureId})
  ↓
Server: AntiExploit (range + cooldown) → CreatureService (validate wild state, tame rate)
  ↓
  → PetLogic (genetics roll, stats)
  → PetService (insert into pet inventory, slot check)
  ↓
  → Response: {PetId, Name, Stats, Rarity}
  ↓
Client: PetBook (new card animation), VFX (tame glow)
```

### 5.5 Zone Unlock
```
Server: ProgressionService (on level up / quest complete / prestige)
  ↓
  → ProgressionLogic (check unlock prerequisites)
  → WorldManager (grant FastTravel point, update zone state)
  ↓
  → RemoteRegistry.FireClient("ZoneUnlocked", {ZoneId, Name})
  ↓
Client: Minimap (new icon), Navigation (available in fast-travel), HUD (notification)
```

### 5.6 Save
```
Server: PlayerDataService (dirty flag true)
  ↓
  → [Every 5 min OR on critical action] → DataStoreService (batch write)
  ↓
  → Retry (3x exponential backoff, 60s window)
  ↓
  → Success: clear dirty, Telemetry log
  → Failure: queue to Redis/cache fallback, alert TelemetryService
  ↓
Client: SessionService (on leave) → final forced write → cleanup
```

---

## 6. Startup Sequence

### Server
```
1. Bootstrapper reads Environment + FeatureFlags from ConfigService.
2. Telemetry + AntiExploit start first (safety net).
3. DataStoreService validates connection; falls back to CacheOnly mode with alert.
4. PlayerDataService loads profile schema version; if mismatch → run migration (see §8).
5. WorldManager + NodeManager restore world state from last tick (or seed).
6. All domain services subscribe to internal event bus (no Remotes yet).
7. Remotes are registered in RemoteRegistry with contracts (see §4).
8. PlayerAdded → SessionService creates session → PlayerDataService hydrates cache.
9. PlayerRemoving → SessionService triggers save queue → PlayerDataService flushes.
```

Error handling: every service catches its own errors and reports to `TelemetryService`. No `warn()` leaks to client. If `DataStoreService` fails, game continues in CacheOnly with reduced-persistence flag set; client shows "saving disabled" banner.

### Client
```
1. Boot reads Environment + FeatureFlags from Config.
2. InputMapper binds default + saved custom controls.
3. Controllers register in order: Camera → HUD → Inventory → Pet → Quest → Trade → Social → Settings.
4. RemoteRegistry.Request/Response middleware attaches rate-limit + retry decorators.
5. First server message: "SessionReady" → full UI render + zone stream in.
```

---

## 7. Feature Flag + Environment Config Design

### Environments
| Field | Development | Staging | Production |
|---|---|---|---|
| DataStore | `AetherHarvesterDev` | `AetherHarvesterStaging` | `AetherHarvesterProd` |
| Analytics | Verbose + mock | Sample 10% | Sample 1% |
| Max Players | 10 | 25 | 50-100 |
| AntiExploit | Warning-only | Strict | Strict + Kick |
| Content Refresh | Hourly | Daily | Weekly |

### Feature Flags
```lua
export type FeatureFlag = {
    Id: string,
    Name: string,
    Description: string,
    Default: boolean,
    RolloutPercent: number?,          -- 0.0-1.0 for gradual rollout
    Whitelist: { string }?,           -- UserId list for canary
    Dependencies: { string }?,        -- Other flags that must be on
    ExpiryDate: DateTime?,            -- Auto-disable after date
    Owner: string,                    -- Team/service responsible
}

-- Examples
{ Id = "PET_FUSION", Default = true, Owner = "PetService" }
{ Id = "NEW_CRAFTING", Default = false, RolloutPercent = 0.1, Owner = "CraftingService" }
{ Id = "GUILD_WARS", Default = false, Dependencies = {"GUILDS"}, Owner = "SocialService" }
```

Flags are read at runtime from `ConfigService`, cached for 5 min, and re-fetched on change via admin webhook.

---

## 8. Schema Versioning + Migration Strategy

### Profile Schema
```lua
export type ProfileSchema = {
    Version: number,                   -- current: 3
    PlayerId: string,
    CreatedAt: DateTime,
    UpdatedAt: DateTime,
    Level: number,
    ...
}
```

### Migration Rules
1. **Forward-only migrations.** Never roll back a schema in production; backfill instead.
2. **Migrations are pure functions** in `Shared/Utils/Migrations/`:
   - `migrate_v1_to_v2(profile) -> profile`
   - `migrate_v2_to_v3(profile) -> profile`
3. **Execution order:** deterministic, numbered files (`001_pets.luau`, `002_prestige.luau`).
4. **Safety:**
   - Migrate to a copy first, validate with `Validate.ProfileSchema(v3)`, then atomically replace.
   - If validation fails → alert + fall back to last-known-good cache + disable new features gated by that schema version.
   - Batch migration on login; never block PlayerAdded. Show "Updating profile..." if >2s.
5. **Telemetry:** emit `ProfileMigrated` event with `fromVersion`, `toVersion`, `durationMs`.

---

## 9. Legacy Assessment: Retain / Rewrite / Remove

| Module | Action | Reasoning |
|---|---|---|
| `ReplicatedStorage/AetherShared/Data/Items.luau` | **RETAIN** | Content-driven definitions are correct pattern; migrate to typed catalog. |
| `ReplicatedStorage/AetherShared/Data/Creatures.luau` | **RETAIN** | Same as Items; extend with pet genetics fields. |
| `ReplicatedStorage/AetherShared/Data/Quests.luau` | **RETAIN** | Quest definitions are data, not logic. |
| `ReplicatedStorage/AetherShared/Modules/Harvesting.luau` | **REWRITE** | Domain logic mixed with Roblox service calls; split into `HarvestLogic` (shared) + `HarvestingService` (server). |
| `ReplicatedStorage/AetherShared/Modules/Inventory.luau` | **REWRITE** | Same coupling issue; move pure math to `InventoryLogic`, keep UI thin. |
| `ReplicatedStorage/AetherShared/Modules/Trading.luau` | **REWRITE** | Needs anti-scam + tax logic moved to server domain. |
| `ReplicatedStorage/AetherShared/Modules/Progression.luau` | **REWRITE** | XP curves and prestige math become `ProgressionLogic`; service handles grants. |
| `ReplicatedStorage/AetherShared/Modules/Utils.luau` | **RETAIN** | General utilities; split into typed `Util` buckets under `Shared/Utils/`. |
| `ReplicatedStorage/AetherShared/Modules/Creatures.luau` | **REWRITE** | Split taming/breeding into `CreatureService` + `PetService`; keep stats in `Content/Creatures.luau`. |
| `ReplicatedStorage/AetherShared/Modules/Events.luau` | **REWRITE** | Event schedules are data; event logic (catch-up, schedules) moves to `EventService`. |
| `ServerScriptService/AetherServer/GameServices/WorldManager.luau` | **REWRITE** | Needs zone streaming, FastTravel, and topology contract; keep core zone table structure. |
| `ServerScriptService/AetherServer/GameServices/NodeManager.luau` | **RETAIN + REFACTOR** | Node lifecycle is sound; extract respawn timer pool, add state machine. |
| `ServerScriptService/AetherServer/GameServices/HarvestingService.luau` | **REWRITE** | Merge validation into server service; remove any client-side trust. |
| `ServerScriptService/AetherServer/GameServices/CreatureService.luau` | **REWRITE** | Split tame vs. combat spawn; add `PetService` for owned pets. |
| `ServerScriptService/AetherServer/GameServices/QuestService.luau` | **REWRITE** | Add objective evaluation in `QuestLogic`; service handles lifecycle only. |
| `ServerScriptService/AetherServer/GameServices/EventService.luau` | **REWRITE** | Needs schedule engine, catch-up logic, and premium pass tracking. |
| `ServerScriptService/AetherServer/GameServices/TradingService.luau` | **REWRITE** | Add marketplace tax, anti-scam, price history in `EconomyService`. |
| `ServerScriptService/AetherServer/GameServices/DataStoreService.luau` | **RETAIN + HARDEN** | Keep as DataStore proxy; add schema versioning, batch queue, retry. |
| `ServerScriptService/AetherServer/GameServices/PlayerDataService.luau` | **REWRITE** | Add dirty tracking, cache layer, migration runner, save queue. |
| `StarterPlayerScripts/HUD.luau` | **REWRITE** | Split into `HUDTop`, `QuickBar`, `Minimap` modules under `Client/UI/HUD/`. |
| `StarterPlayerScripts/InventoryUI.luau` | **REWRITE** | Convert to controller-driven; separate UI render from logic. |
| `StarterPlayerScripts/InputHandler.luau` | **RETAIN + REFACTOR** | Input mapping is correct; extract bindings to `InputMapper`, state to `InputState`. |
| `StarterPlayerScripts/Minimap.luau` | **REWRITE** | Move under `Client/UI/HUD/`; stream zone data from `WorldManager`. |

**New modules required (not in legacy):** `Bootstrapper`, `ConfigService`, `SessionService`, `PetService`, `CombatService`, `CraftingService`, `RewardService`, `AntiExploitService`, `TelemetryService`, `SocialService`, `EconomyService`, `RemoteRegistry`, `VFXService`, `AudioService`, `CameraController`, `PathingHint`, `FastTravel`.

---

## 10. Testing Hooks

### Domain Logic Isolation
All pure functions in `Shared/Domain/` accept and return plain tables. No `game`, `workspace`, `Players`, `DataStoreService`, `RemoteEvent` references. This makes them runnable in:
- **TestEZ** (Roblox plugin / CLI) for integration tests.
- **Lune** (`lune test`) for Luau-only unit tests without Roblox runtime.

### Test Structure
```
tests/
  ├── unit/
  │   ├── HarvestLogic.spec.luau
  │   ├── PetLogic.spec.luau
  │   ├── ProgressionLogic.spec.luau
  │   └── ...
  ├── integration/
  │   ├── QuestService.integration.luau
  │   ├── TradingService.integration.luau
  │   └── ...
  └── fixtures/
      ├── SampleProfile.luau
      ├── MockStore.luau
      └── FakeRemote.luau
```

### Patterns
- **Mock Roblox services** via `FakeStore` and `FakeRemote` that record calls.
- **Deterministic RNG**: inject `Rng: (seed: number) -> ()` into logic functions.
- **Clock control**: `TimeUtil.now()` is a function reference; tests replace it with a fixed clock.
- **Service contracts**: every service exposes `__test__` field with mockable internals.

---

## A. Three Biggest Architectural Decisions

1. **Shared/Domain as the single source of truth for rules.**  
   All balance curves, loot tables, XP formulas, and damage math live in `Shared/Domain/` as pure functions. Server services orchestrate; clients only predict UI. This eliminates client-server desync, makes TestEZ/Lune testing trivial, and lets designers tune numbers without touching Roblox services.

2. **RemoteRegistry with typed contracts as the API boundary.**  
   Every remote is declared once in `RemoteRegistry.luau` with its exact payload, validation, rate limit, and failure response. The registry auto-generates stubs, middleware enforces rate limits, and client/server drift becomes a compile-time type error rather than a runtime mystery.

3. **Schema-versioned profiles with forward-only migrations.**  
   Player data carries a `Version` field. On load, the server applies numbered pure migrations, validates the result, and only then hydrates the cache. This lets us evolve the game live (new prestige tiers, pet genetics, guild features) without breaking existing players or requiring mass resets.

---

## B. Deliverable Path Confirmation

Written to: `C:\Users\aariz\kilo_HQ\roblox-dev\aether-harvester\docs\autonomy\ARCHITECTURE.md`
