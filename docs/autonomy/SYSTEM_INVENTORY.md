# SYSTEM INVENTORY — Recovered Reality (Second Pass)

**Branch:** `revamp/aether-reforge`
**Audit date:** 2026-08-04T16:50+08:00
**Auditor:** Worker-A (Repository Archaeologist, second pass after full game recovery)
**Scope:** Every file under `src/` + 13 recovery JSONs + 3 design docs. Read-only — no edits.

---

## 1. Service Inventory (24 services)

| # | Service | Purpose | Key Remotes Bound | Owns / Manages | Status | Notes |
|---|---------|---------|-------------------|----------------|--------|-------|
| 1 | PlayerDataService | DataStore persistence, player CRUD, inventory/currency/pet ops | GetPlayerData(F), GetInventory(F), RequestPlayerData, PlayerDataLoaded | `playerData{}` in-memory map, DataStore "PlayerData_v1" | **REAL** | 236 lines. Auto-save every 5min. Full AddItem/RemoveItem/AddPet/AddXP/IncrementStat API. petIdCounter not persisted. |
| 2 | CreatureService | Creature state, combat damage, taming, aggro AI (Heartbeat) | TameCreature, DamageCreature (runtime-created), Error, NodeHarvested, PetSummon | `creatureState{}` — health/aggro per creature instance | **REAL** | 259 lines. DamageCreature remote created at runtime if missing (P2). Heartbeat aggro loop runs per-creature. |
| 3 | CraftingService | Recipe database (5), craft validation, ingredient removal, XP grant | CraftItem, RequestRecipes, ItemCrafted, Error | `CraftingService.Recipes` (hardcoded table) | **REAL** | 192 lines. 5 recipes. Duplicates Recipes.luau data module (P2). |
| 4 | EconomyService | Currency definitions (4), exchange rates, transaction log | (none — API only) | `Currencies{}`, `transactionLog[]`, `ExchangeRates` | **REAL** | 113 lines. No remotes — consumed only by other services. Duplicate of PlayerDataService currency methods (P1). |
| 5 | NodeManager | Harvest node management, cooldowns, yield calc, boost items | HarvestResource, NodeHarvested, UpdateHUD, Error | `activeNodes{}` cooldown map, `NodeTypes{}` (6 types) | **REAL** | 173 lines. 6 node types (AetherNode, CrystalNode, OreNode, HerbNode, Tree, Rock). 1.5x harvest_boost multiplier. |
| 6 | WorldManager | Island definitions (11), teleport, character spawn, player tracking | ChangeIsland, UpdateHUD | `IslandDefs{}` (11 islands), `playerIslands{}` | **REAL** | 160 lines. Default island "SkySanctum" hardcoded in 4+ places (P2). Handles PlayerAdded + CharacterAdded. |
| 7 | QuestService | Quest accept/progress/complete/abandon, objective matching, rewards | AcceptQuest, CompleteQuest, AbandonQuest, GetQuests(F), QuestUpdated, Error | `activeQuests{userId->questId->state}` | **REAL** | 272 lines. 6 objective types (Harvest, Collect, Tame, Defeat, DefeatRarity, Visit). Line 269 has suspicious `and` in string concat. |
| 8 | PetService | Pet equip/unequip, summon/despawn follower, visual Model spawning | GetPets(F), EquipPet, UnequipPet, SummonPet, ReleasePet, PetSummon, PetReleased, Error | `activePets{}`, `petFollowers{}`, summoned Model instances in Workspace | **REAL** | 306 lines. Spawns neon ball followers via RunService loop. Follower task never cleaned on player leave (P1). |
| 9 | ProgressionService | XP accumulation, level-up, skill points (5 per level), XP formula | AddXP, LevelUp, PlayerLeveledUp | XP formula: `floor(100 * 1.5^(level-1))` | **REAL** | 138 lines. Exploit cap: math.clamp(amount, 1, 10000) on AddXP remote. |
| 10 | UpgradeService | 5 upgrade definitions, cost scaling, purchase flow | GetUpgrades(F), PurchaseUpgrade, UpgradePurchased, Error | `UpgradeService.Database` (5 upgrades) | **REAL** | 187 lines. Pickaxe power/speed, inventory, pet capacity, energy regen. Cost multiplier per level. |
| 11 | GuildService | Guild CRUD, invite, join, leave, guild XP/leveling | CreateGuild, JoinGuild, LeaveGuild, InviteToGuild, GetGuildInfo(F), GuildCreated, GuildInvite, GuildMemberJoined, GuildMemberLeft, Error | `Guilds{}`, `GuildIdCounter` (in-memory only) | **REAL** | 275 lines. All data lost on server restart (P0). Max members not enforced. |
| 12 | EventService | Random event spawning (5 types), 1h duration, 30% chance/5min | EventStarted, EventEnded | `ActiveEvents{}`, `EventIdCounter` | **REAL** | 102 lines. GetEventBonus() defined but never consumed by any service (P1). Events are cosmetic-only. |
| 13 | TradingService | Player-to-player trade create/accept/cancel | CreateTrade, AcceptTrade, CancelTrade, TradeCreated, TradeCompleted, TradeCancelled, Error | `ActiveTrades{}` | **WEAK** | 154 lines. AcceptTrade has TODO comments at lines 96-98 — item transfer never executes (P0). |
| 14 | CosmeticService | 5 cosmetic definitions, purchase/equip | PurchaseCosmetic, EquipCosmetic, CosmeticPurchased, CosmeticEquipped, Error | `Cosmetics{}` (5 items), player `data.Cosmetics[]` | **REAL** | 181 lines. No visual application to character model (cosmetic equip is data-only). |
| 15 | ChatService | 5 channels (global/island/guild/party/trade), message history, broadcast | SendChatMessage, ChatMessageReceived | `MessageHistory[]` (1000 cap), `Channels{}` | **REAL** | 115 lines. Broadcasts to ALL clients regardless of channel (P3). 200 char message limit. |
| 16 | MarketplaceService | Auction listings, buy/sell/cancel flow | GetMarketplaceListings(F), CreateListing, CancelListing, PurchaseListing, ListingCreated, ListingPurchased, ListingCancelled, Error | `Listings{}`, `ListingIdCounter` | **REAL** | 200 lines. If seller offline at purchase, currency created from nothing (P0). |
| 17 | BattlePassService | Season 1 (50 levels), free+premium reward tracks, XP calculation | PurchaseBattlePassPremium, BattlePassLevelUp, BattlePassPremiumPurchased, Error | `Seasons{season_1}` with FreeRewards + PremiumRewards | **REAL** | 203 lines. BattlePassService.AddXP() never called from any service (P1). Premium costs 2000 Shards. |
| 18 | MailService | In-game mail with attachments, read/delete | SendMail, ReadMail, DeleteMail, MailReceived, MailUpdated, MailDeleted, Error | `Mailboxes{}` per player (in data) | **REAL** | 184 lines. Recipient must be online or mail is lost (P2). |
| 19 | AntiCheatService | Violation tracking, auto-kick at 5 flags | (none — never integrated) | `Violations{userId->[]}` | **STUB** | 73 lines. CheckPlayer() defined but never called from any service (P0). Only checks level>1000 and currency>10M. |
| 20 | LeaderboardService | 4 categories (Level/Wealth/Pets/Quests), top 100 sorting | GetLeaderboard(F), RequestLeaderboard, LeaderboardUpdated | `Leaderboards{4 categories}` | **WEAK** | 123 lines. UpdateLeaderboard() defined but never called (P1). Leaderboards always empty. |
| 21 | AnalyticsService | Event tracking, player action stats | (none) | `Events[]` (10K cap), `PlayerStats{}` | **STUB** | 84 lines. In-memory only, no persistence, no remotes, no external integration. |
| 22 | AchievementService | 6 achievements, check/unlock/notify | RequestAchievements, AchievementUnlocked | Delegates to Achievements.luau data module | **REAL** | 81 lines. Requires PlayerDataService at module scope (server-only, P2). |
| 23 | RewardService | Daily reward claim, streak calculation | ClaimReward, RewardClaimed | — | **STUB** | 98 lines. Overlaps DailyRewardsService. ClaimReward remote handler does nothing except fire client (P1). |
| 24 | DailyRewardsService | 7-day streak rewards, date-based validation | ClaimDailyReward, DailyRewardClaimed, Error | `Rewards{1-7}`, streak in player data | **REAL** | 127 lines. Canonical daily claim handler. Uses year-month-day string for date comparison. |

### Service Status Summary

| Status | Count | Services |
|--------|-------|----------|
| **REAL** (functional, integrated) | 18 | PlayerData, Creature, Crafting, Economy, NodeManager, WorldManager, Quest, Pet, Progression, Upgrade, Guild, Event, Cosmetic, Chat, Marketplace, BattlePass, Mail, DailyRewards |
| **WEAK** (exists but broken/incomplete) | 4 | Trading (TODO item transfer), Leaderboard (never updated), Reward (overlaps DailyRewards), Achievement (server-only require) |
| **STUB** (minimal/unused) | 2 | AntiCheat (never integrated), Analytics (in-memory only) |

---

## 2. Script Inventory (5 world/bootstrap scripts)

| Script | Path | Lines | Purpose | Status |
|--------|------|-------|---------|--------|
| ServerBootstrap.server.luau | `AetherServer/ServerBootstrap.server.luau` | 9 | Loads ServerMain, 2s wait, calls Initialize() | **REAL** — located in AetherServer/ subdir, NOT at ServerScriptService root as task expected |
| FallGuard.server.luau | `ServerScriptService/FallGuard.server.luau` | 54 | Heartbeat: if player Y < 30, teleport to SkySanctum | **REAL** — complete, handles PlayerAdded + existing players |
| LightingConfig.server.luau | `ServerScriptService/LightingConfig.server.luau` | 31 | Sets Ambient, FogStart/End, Atmosphere density | **REAL** — applies design audit §4.1 teal fantasy atmosphere |
| PortalScript.server.luau | `ServerScriptService/PortalScript.server.luau` | 100 | Touch/ClickDetector on portals → teleport via WorldManager.TargetIsland attribute | **REAL** — 3s cooldown, ChildAdded listener for dynamic portals |
| WorldAnimation.server.luau | `ServerScriptService/WorldAnimation.server.luau` | 107 | Rune rotation, SkyWhale flight circles, FloatingRock bobbing | **REAL** — 3 animation systems on Heartbeat. Island drift intentionally omitted. |

---

## 3. Data Modules (7 modules)

| Module | File | Content Count | Key Functions | Notes |
|--------|------|---------------|---------------|-------|
| Items.luau | `Data/Items.luau` | **28 items** (4 Resource, 5 Tool, 12 Material, 4 Consumable, 2 Special, 1 ??) | GetItem, GetAllItems, GetItemsByType, GetItemsByRarity | All icons `rbxassetid://0` (placeholders) |
| Creatures.luau | `Data/Creatures.luau` | **12 creatures** (Spirit×3, Beast×3, Dragon×2, Leviathan×2, Elemental×1, ???) | Get, GetAll, GetByRarity | 6 tameable, 6 aggressive |
| Quests.luau | `Data/Quests.luau` | **8 quests** (Harvesting×2, Collection×2, Taming×1, Exploration×1, Social×1, Combat×1) | Get, GetAll, GetByDifficulty | Level range 1–35 |
| Recipes.luau | `Data/Recipes.luau` | **5 recipes** (crystal_pickaxe, aether_pickaxe, pet_food, energy_potion, harvest_boost) | Get, GetAll, GetAvailable | Exact duplicate of CraftingService.Recipes table |
| Pets.luau | **Data/Pets.luau** | **13 pets** (Harvester×5, Combat×4, Support×1, Mount×1, duplicate IDs from Creatures×2) | GetPet, GetAllPets, GetPetsByRarity, GetPetsByClass, FeedPet, PlayWithPet, RestPet, AddXP | FeedPet/AddXP mutate shared Database table (P2 bug: affects all players) |
| Achievements.luau | `Data/Achievements.luau` | **6 achievements** (Harvesting×2, Collection×1, Progression×1, Social×1, Exploration×1) | GetAllAchievements, GetAchievement, CheckAchievements, GetProgress | Requires PlayerDataService at top scope — server-only module (P2) |
| Rewards.luau | `Data/Rewards.luau` | **30-day daily calendar** + 3 extra rewards (daily_login, weekly_challenge, season_pass) | GetDailyReward, GetMonthlyReward, CalculateStreakBonus, GetExtraReward | Streak bonus: 1.0→1.2→1.3→1.5→2.0 at 7/14/21/28 days |

---

## 4. Client Controllers (6 scripts)

| Controller | Lines | Purpose | Key Behavior |
|------------|-------|---------|--------------|
| ClientBootstrap.client.luau | 77 | Entry point: requires GameClient, inits HUD/Minimap, shows StartingScreen, marks GameLoaded attribute | Delegates to _G.HUDController and _G.MinimapController |
| HUDController.client.luau | 161 | Per-frame HUD updates: EnergyBar, HealthBar, LevelDisplay, CurrencyDisplay, ToolDisplay, ActiveCreature, QuestTracker, NotificationArea | Heartbeat loop, UpdateBar fills with color (green→yellow→red). Registered as _G.HUDController. |
| InputHandler.client.luau | 181 | Key bindings: E=Harvest, R=Pet, Tab=Inventory, Q=Quests, M=Map, Esc=Settings, Shift=Sprint(32→16) | Raycast for harvest/tame. Registered as _G.InputHandler. Sprint hardcodes walkSpeed 32/16 (P2). |
| Minimap.client.luau | 134 | Circular minimap: player dot, world→minimap position mapping, marker support | 150px, scale 0.05, updates every 0.1s. Registered as _G.MinimapController. |
| ScreenController.client.luau | 282 | Populates Inventory/Quest/Pets screens from server data on screen Enable | Uses GetInventory(F), GetQuests(F), GetPets(F). Tab filtering for inventory. Rarity colors. |
| UIController.client.luau | 101 | StartingScreen→MainMenu navigation, close buttons on all screens, FetchPlayerData | MainMenu nav map: NavInventory→InventoryScreen, NavQuests→QuestLogScreen, etc. |

---

## 5. World Summary (from Workspace_AetherWorld.json)

### Islands Folder — 39 entries total

| Category | Count | Names |
|----------|-------|-------|
| Named Islands | 10 | SkySanctum, CloudGardens, StormPeaks, CrystalCanyons, AncientRuins, VoidRifts, VerdantIsle, CrystalSpires, EmberPeaks, FloatingMarket |
| AetherNodes | 11 | AetherNode_1 through AetherNode_11 |
| CrystalNodes | 5 | CrystalNode_1 through CrystalNode_5 |
| OreNodes | 4 | OreNode_1 through OreNode_4 |
| HerbNodes | 4 | HerbNode_1 through HerbNode_4 |
| Trees | 3 | Tree_1, Tree_2, Tree_3 |
| Rocks | 2 | Rock_1, Rock_2 |

**Total resource nodes in world: 29** (11 Aether + 5 Crystal + 4 Ore + 4 Herb + 3 Tree + 2 Rock)

### Props Folder — 30 parts

| Prop Type | Count |
|-----------|-------|
| CrystalTree | 5 (1–5) |
| AetherFlower | 5 (1–5) |
| FloatingRock | 5 (1–5) |
| MushroomCluster | 5 (1–5) |
| GlowingOrb | 5 (1–5) |
| AncientPillar | 5 (1–5) |

### Creatures Folder — 17 models

| Creature Type | Count | IDs in Data? |
|---------------|-------|--------------|
| EmberDragon | 3 (1–3) | ember_drake ✓ (via attribute) |
| SkyWhale | 3 (1–3) | sky_whale ✓ |
| AetherWolf | 3 (1–3) | shadow_wolf ✓ (name mismatch) |
| CrystalFox | 3 (1–3) | crystal_fox ✓ |
| CloudSprite | 2 (1–2) | cloud_sprite ✓ |
| VerdantDeer | 3 (1–3) | verdant_deer ✓ |

### Portals Folder — 5 portals

Portal_1 through Portal_5 (BaseParts with TargetIsland attribute)

---

## 6. UI Screen Summary (12 screens + HUD)

All 12 screens recovered in `artifacts/recovery/StarterGui_AetherUI_Screens_*.json`. Each shares: Background (deep navy gradient), TitleBar with Title + CloseButton, UICorner + UIStroke + UIGradient decorations.

| Screen | Key Components | Populated by Code? | Notes |
|--------|---------------|-------------------|-------|
| StartingScreen | LogoContainer (AETHER HARVESTER), Subtitle (SIMULATOR), PlayButton, SettingsButton | UIController wires Play/Settings buttons | Full-screen overlay, entrance screen |
| MainMenu | TitleBar, NavInventory, NavQuests, NavPets, NavGuild, NavSkillTree, NavMap, NavSettings buttons | UIController wires all nav buttons | Central hub — 7 navigation targets |
| InventoryScreen | TitleBar, TabBar (4 tabs: TabItems/TabEquipment/TabResources/TabCrafting), Content (ScrollingFrame), ItemTemplate, EmptyState | ScreenController:PopulateInventory — full population with rarity colors, icons, counts | Most complete screen — has template cloning + tab filtering |
| QuestLogScreen | TitleBar, QuestList (ScrollingFrame), QuestTemplate, CloseButton | ScreenController:PopulateQuests — populates from GetQuests(F) | Shows title, description, progress ratio, completion check |
| PetScreen | TitleBar, PetScroll (ScrollingFrame), PetTemplate, CloseButton | ScreenController:PopulatePets — populates from GetPets(F) | Shows name, level, rarity, equipped badge |
| SettingsScreen | TitleBar, Graphics/Audio/Controls sections, sliders, toggles, CloseButton | None — screen exists but no population code | Structure present, no wiring |
| RewardsScreen | TitleBar, daily reward grid/calendar, CloseButton | None — screen exists but no population code | 202 lines JSON, minimal components |
| TradeWindow | TitleBar, Offer/Request item slots, TradeButton, CloseButton | None — screen exists but no population code | 364 lines JSON, detailed layout |
| GuildScreen | TitleBar, Guild info panel, member list, invite/create buttons, CloseButton | None — screen exists but no population code | 351 lines JSON |
| SkillTreeScreen | TitleBar, 5 branch columns, node slots, skill point display, CloseButton | None — screen exists but no population code | 369 lines JSON, but no skill tree data module |
| EventScreen | TitleBar, event card list, countdown timer placeholder, CloseButton | None — screen exists but no population code | 366 lines JSON |
| MapScreen | TitleBar, island grid/list, travel buttons, CloseButton | None — screen exists but no population code | 386 lines JSON, but WorldManager not wired to UI |

### HUD Elements (from recovery + code)

HUDController manages 8 elements: EnergyBar, HealthBar, LevelDisplay, CurrencyDisplay, ToolDisplay, ActiveCreature, NotificationArea, QuestTracker. Minimap adds MinimapFrame with PlayerDot.

### UI Design System Component Coverage

The design system specifies **18 components** (Button, Panel, Card, Tooltip, Modal, Toast, ListItem, TabBar, Slider, Toggle, Input, Badge, ProgressBar, CurrencyDisplay, RarityFrame, EmptyState, LoadingSpinner, ScrollContainer). Recovery JSONs show basic implementations of: Button (PlayButton, CloseButton, NavButtons), TabBar (InventoryScreen), ListItem (inventory items via template), ProgressBar (quest progress), Badge (pet equipped), EmptyState (inventory). **Missing from code:** Panel, Card (full), Tooltip, Modal, Toast, RarityFrame (full with corner diamonds), LoadingSpinner, ScrollContainer (with momentum/snap). Token system (colors, typography, spacing, shadows) not implemented — all screens use hardcoded Color3 values.

---

## 7. Design-vs-Recovered Gap List

### Gaps: Design features MISSING from code

| # | Design Feature | Design Source | Code Reality | Priority |
|---|---------------|---------------|--------------|----------|
| 1 | **4-layer vertical world** (Astral Heights, Floating Archipelago, Aetherial Sea, Abyssal Depths) | GAME_DESIGN §4 Pillar 1 | 11 flat islands, no layer system, no vertical stratification | P0 |
| 2 | **Creature breeding with genetics** (parent inheritance, mutation, hatching timers) | GAME_DESIGN §4 Pillar 2 | Taming only. No breeding. Pets are standalone definitions. | P0 |
| 3 | **Skill-based harvesting combos** (consecutive harvests build multiplier, timing, tool-node pairing) | GAME_DESIGN §4 Pillar 5 | Simple harvest with random yield. No combo tracking. | P1 |
| 4 | **Reactive world / aether currents** (nodes deplete, currents shift, events alter spawns) | GAME_DESIGN §4 Pillar 3 | Static nodes, fixed respawn timers, no current system | P1 |
| 5 | **5-branch skill tree** (Harvesting, Exploration, Trading, Engineering, Creature Care × 5 levels) | GAME_SPEC §4 | SkillTreeScreen JSON exists (369 lines) but no skill tree data or logic. ProgressionService grants skill points but nothing consumes them. | P0 |
| 6 | **Tutorial / NPC onboarding** (Sky Whale NPC guides first 5 minutes) | GAME_DESIGN §6 | No tutorial. ClientBootstrap just shows StartingScreen. | P1 |
| 7 | **Energy system** (harvesting costs energy, regen, energy potions) | GAME_SPEC | HUD has EnergyBar. Items include energy_potion. But no energy consumption in harvest loop. | P1 |
| 8 | **Tool equip/use/durability** (4 tool types, durability degradation, tool switching) | GAME_SPEC §1 | Items have pickaxe data (Power, Speed, Durability). HUD has ToolDisplay. But no equip/use/durability logic. | P1 |
| 9 | **Prestige rebirth** (reset with permanent bonuses at Lv100) | GAME_DESIGN §2 | PlayerDataService has `PrestigeLevel = 0` in default data but no prestige system. | P2 |
| 10 | **Anti-grind diminishing returns** (after 2h continuous play) | GAME_DESIGN §4 Pillar 4, §9 | Not implemented anywhere. | P2 |
| 11 | **Cosmetic-only Robux monetization** (catalog, receipts, dark-pattern guardrails) | GAME_DESIGN §9, UI_DESIGN §7 | CosmeticService has 5 items purchasable with Shards (not Robux). No Robux integration. | P2 |
| 12 | **Loot box pity system** (published rates, pity at 50/200 pulls) | GAME_DESIGN §9 | Not implemented. | P3 |
| 13 | **Mobile touch controls** (virtual joystick, swipe, tap-to-harvest) | GAME_DESIGN §7 | Desktop-only InputHandler. No touch support. | P2 |
| 14 | **UI token system** (18 components, design tokens, responsive breakpoints) | UI_DESIGN §2–3 | Screens use hardcoded Color3 values. No CSS-variable-style tokens. No responsive logic. | P1 |
| 15 | **Mythril rarity tier** | UI_DESIGN §2.1 | Code only goes to Legendary. No Mythril. | P3 |
| 16 | **Named zones from design** (Celestial Nexus, Astral Observatory, Luminous Reef, Abyssal Trench, etc.) | FEATURE_MATRIX §3 | Code has 11 islands with different names. No Celestial Nexus, no Astral Observatory, no Luminous Reef, no Abyssal Trench, no Verdant Canopy, no Ashen Maw. | P0 |

### Gaps: Code features NOT in design docs

| # | Code Feature | Notes |
|---|-------------|-------|
| 1 | BattlePassService (Season 1, 50 levels) | Not mentioned in GAME_DESIGNDocument v2 |
| 2 | MailService (in-game mail with attachments) | Not in design docs |
| 3 | MarketplaceService (auction listings) | Design mentions "dynamic marketplace" as rejected for v1; code has a basic auction system |
| 4 | CosmeticService (5 purchasable cosmetics) | Design says cosmetic-only monetization but no specific items defined |

---

## 8. Defect List (P0–P4 with file:line)

### P0 — Critical (data loss / security / broken core)

| # | File:Line | Description |
|---|-----------|-------------|
| P0-1 | `TradingService.luau:96-98` | **AcceptTrade does NOT transfer items.** Lines 96-98 are TODO comments: `-- Remove offer items from trader / -- Add request items to trader / -- Add offer items to accepter / -- Remove request items from accepter`. Trade "completes" without exchanging anything. |
| P0-2 | `AntiCheatService.luau` (entire service) | **Never integrated.** `CheckPlayer()` is defined but never called by any service. Zero exploit protection active. |
| P0-3 | `GuildService.luau:4` | **Guilds not persisted.** `GuildService.Guilds = {}` is in-memory only. Server restart wipes all guild data. |
| P0-4 | `MarketplaceService.luau:137-139` | **Currency created from nothing.** If seller is offline when listing is purchased, `AddCurrency(seller, "AetherShards", price)` writes to an empty data table. Seller loses the item AND the money disappears. |
| P0-5 | `EconomyService.luau` + `PlayerDataService.luau` | **Dual currency management.** Both services independently modify `data.Currency`. EconomyService.AddCurrency and PlayerDataService.AddCurrency do the same thing. Currency operations through one service are invisible to the other's transaction log. |

### P1 — High (gameplay broken / major feature gap)

| # | File:Line | Description |
|---|-----------|-------------|
| P1-1 | `LeaderboardService.luau:47` | **Leaderboards never updated.** `UpdateLeaderboard(player, category)` is defined but never called. Leaderboards are permanently empty. |
| P1-2 | `BattlePassService.luau:63` | **Battle pass never advances.** `BattlePassService.AddXP()` is defined but never called from ProgressionService or any other service. |
| P1-3 | `RewardService.luau:16-24` | **Dead code — reward claim does nothing.** The ClaimReward remote handler fires RewardClaimed to client but never calls ClaimDailyReward or grants any reward. |
| P1-4 | `EventService.luau:91` | **Events don't affect gameplay.** `GetEventBonus()` returns multipliers but no service (NodeManager, ProgressionService) checks for active events. |
| P1-5 | `PetService.luau:66-77` | **Follower task never cleaned.** `task.spawn` loop runs forever per summon. If player leaves while pet is summoned, the loop continues until it errors on nil character. No `player.CharacterAdded` or `PlayerRemoving` cleanup. |
| P1-6 | `QuestService.luau:269` | **Suspicious string concat.** `tostring(next(QuestsData.GetAll())) and " quests available"` — the `and` makes this a Lua truthy expression, not a string concatenation. Should use `..` instead of `and`. |
| P1-7 | `WorldManager.luau` | **Hardcoded default island.** "SkySanctum" appears in 4+ locations without a centralized constant. |

### P2 — Medium (quality / maintainability)

| # | File:Line | Description |
|---|-----------|-------------|
| P2-1 | `CraftingService.luau:4-61` | **Duplicate recipe data.** CraftingService.Recipes is a hardcoded table identical to Recipes.luau. Two sources of truth that will drift. |
| P2-2 | `CreatureService.luau:212-215` | **Runtime remote creation.** DamageCreature remote is created via `Instance.new("RemoteEvent")` if missing. Should be declared in Remotes.model.json. |
| P2-3 | `Pets.luau:297-305` | **Shared data mutation.** `Pets.AddXP()` and `Pets.FeedPet()` modify `Pets.Database[petId]` — the shared module table. This means ALL players share the same pet level/hunger. Per-player instances needed. |
| P2-4 | `Utils.luau:14-16` | **FormatNumber is buggy.** `string.format("%03d", num % 1000)` produces wrong results. E.g., 1234 → `string.format("%03d", 234)` → "234", then concatenated with "1234" → "1234234". |
| P2-5 | `Achievements.luau:3` | **Server-only module.** `require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)` at top level. Any client requiring Achievements will error. |
| P2-6 | `Pets.luau:153-156,170-173,187-190` | **Duplicate pet IDs.** cloud_sprite, verdant_deer, storm_hawk, crystal_fox, shadow_wolf, aether_fox exist in BOTH Pets.luau AND Creatures.luau with different data structures. Name collision risk. |
| P2-7 | `MailService.luau:58` | **Offline recipient.** `SendMail` requires recipient to be online (`GetPlayerByUserId`). If offline, mail is silently lost. |
| P2-8 | `InputHandler.client.luau:68` | **Hardcoded magic numbers.** Sprint speed 32, normal speed 16, harvest boost 1.5x — all magic numbers without constants. |
| P2-9 | All 28 items in `Items.luau` | **Placeholder icons.** Every `Icon` field is `"rbxassetid://0"`. |
| P2-10 | All 4 currencies in `EconomyService.luau:9-12` | **Placeholder icons.** Every currency `Icon` is `"rbxassetid://0"`. |

### P3 — Low (polish / minor)

| # | File:Line | Description |
|---|-----------|-------------|
| P3-1 | `ChatService.luau:76` | **Channel filtering missing.** `ChatMessageReceived:FireAllClients(chatMessage)` broadcasts to everyone regardless of channel. Island/guild/party channels don't filter. |
| P3-2 | `AnalyticsService.luau` | **In-memory only.** Events and PlayerStats lost on server restart. |
| P3-3 | All UI screens | **No animation system.** Screen open/close are instant (Visible toggle). Design spec calls for `--ease-slow` (400ms) transitions. |
| P3-4 | `AntiCheatService.luau:69` | **ClearViolations exposed but never called.** Dead API. |
| P3-5 | `LeaderboardService.luau:59` | **Pets count bug.** `data.Pets and #data.Pets or 0` — player data uses `PetInventory` not `Pets`. Will always return 0. |

### P4 — Cosmetic (cleanup)

| # | File:Line | Description |
|---|-----------|-------------|
| P4-1 | `PureMath.luau` | **Never used.** Overlaps Utils.luau functions. Dead module. |
| P4-2 | `PureMath.luau:10`, `Utils.luau:20`, `ProgressionService.luau:68` | **Triplicated XP formula.** All three compute `floor(100 * 1.5^(level-1))`. |
| P4-3 | `GameClient.luau:8` | **Default island mismatch.** `State.CurrentIsland = "CloudGardens"` but WorldManager defaults to "SkySanctum". |

---

## 9. Data Integrity Verdict

### ServerMain requires all 24 services — all exist on disk ✓

ServerMain.luau lines 12–35 require: WorldManager, NodeManager, PlayerDataService, QuestService, CreatureService, EconomyService, PetService, AchievementService, UpgradeService, TradingService, GuildService, EventService, CraftingService, DailyRewardsService, MailService, ChatService, AnalyticsService, AntiCheatService, CosmeticService, BattlePassService, MarketplaceService, LeaderboardService, ProgressionService, RewardService.

**All 24 `.luau` files exist at the expected paths.** ✓

### Remotes.model.json: 81 remotes declared

- 73 RemoteEvents
- 8 RemoteFunctions

**All remotes referenced by services exist in the model.** One exception: `DamageCreature` is NOT in the model but is created at runtime by CreatureService (P2-2).

### Data modules — syntax/load check

| Module | Syntax OK? | Cross-env issue? | Notes |
|--------|-----------|-------------------|-------|
| Items.luau | ✓ | No — pure data + functions | Safe for server + client |
| Creatures.luau | ✓ | No — pure data + functions | Safe for server + client |
| Quests.luau | ✓ | No — pure data + functions | Safe for server + client |
| Recipes.luau | ✓ | No — pure data + functions | Safe for server + client |
| Pets.luau | ✓ | No — but mutates shared state (P2-3) | Data corruption risk at runtime |
| Achievements.luau | ✓ | **YES** — requires PlayerDataService (server-only) | Client require will error |
| Rewards.luau | ✓ | No — pure data + functions | Safe for server + client |

### Cross-reference: Services ↔ Data modules

| Service | Data Module Required | Module Exists? |
|---------|---------------------|----------------|
| CreatureService | Creatures.luau | ✓ |
| NodeManager | Items.luau | ✓ |
| QuestService | Quests.luau, Items.luau | ✓ |
| PetService | Pets.luau | ✓ |
| AchievementService | Achievements.luau | ✓ |
| CraftingService | Items.luau (inline require) | ✓ |
| RewardService | Rewards.luau | ✓ |
| DailyRewardsService | (none — hardcoded rewards) | ✓ |

---

## Return Summary

**(a) Service count:** 18 REAL / 4 WEAK / 2 STUB — out of 24 total. The game has genuine backend logic in most services, not stubs. The 2 stubs (AntiCheat, Analytics) are non-critical. The 4 weak services (Trading, Leaderboard, Reward, Achievement) have bugs that prevent them from functioning.

**(b) Top 5 gaps vs design docs:**
1. No 4-layer vertical world — 11 flat islands instead of 4 stratified zones
2. No creature breeding — taming only, no genetics/mutation/hatching
3. No skill tree implementation — UI shell exists but no data or logic
4. No harvesting combo system — simple random yield, no skill-based mechanics
5. No energy consumption — HUD bar exists but harvests are free

**(c) P0/P1 defects found:** 5 P0 (trading doesn't transfer items, anti-cheat not integrated, guilds not persisted, marketplace creates money from nothing, dual currency management) + 7 P1 (leaderboards always empty, battle pass never advances, reward claim does nothing, events don't affect gameplay, pet follower task leak, suspicious QuestService line, hardcoded default island).

**(d) Deliverable path:** `C:\Users\aariz\kilo_HQ\roblox-dev\aether-harvester\docs\autonomy\SYSTEM_INVENTORY.md` — overwritten with recovered reality (411 lines of prior scaffold replaced).
