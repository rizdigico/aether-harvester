# REMOTE CATALOG

## Remote Events & Functions

| Remote Name               | Direction | Payload (Server → Client) | Validation (Server) | Rate-Limit | Failure Response | File:Line
|---------------------------|-----------|--------------------------|------------------------|------------|-------------------|---------------
| **HarvestResource**       | Server    | Node rewards               | Node existence, distance | None       | None              | `WorldManager.luau:123`
| **NodeHarvested**         | Client    | Node ID, rewards           | None                     | None       | None              | `WorldManager.luau:145`
| **ChangeIsland**          | Server    | Island ID                  | Island existence, ownership | None       | None              | `WorldManager.luau:201`
| **PlayerDataLoaded**      | Server    | Player data                | Player existence          | None       | None              | `PlayerDataService.luau:36`
| **RequestPlayerData**     | Client    | None                      | Player existence          | None       | None              | `PlayerDataService.luau:34`
| **AddXP**                 | Removed from current model; no server handler | None | Not accepted from clients; XP is granted by server-owned services only | N/A | N/A | `ProgressionService.luau`
| **LevelUp**               | Server    | New level, skill points    | Valid level progression   | None       | None              | `ProgressionService.luau:112`
| **UpgradePurchased**      | Server    | Upgrade ID, level          | Valid upgrade, currency   | None       | None              | `UpgradeService.luau:78`
| **PurchaseUpgrade**       | Client    | Upgrade ID, level          | Valid upgrade, currency   | None       | None              | `UpgradeService.luau:65`
| **EquipPet**              | Server    | Pet ID                     | Pet ownership, valid ID   | None       | None              | `PetService.luau:45`
| **UnequipPet**            | Server    | None                      | Pet ownership, valid ID   | None       | None              | `PetService.luau:60`
| **SummonPet**             | Server    | Pet ID                     | Pet ownership, valid ID   | None       | None              | `PetService.luau:75`
| **ReleasePet**            | Server    | None                      | Pet ownership, valid ID   | None       | None              | `PetService.luau:90`
| **AcceptQuest**           | Client    | Quest ID                   | Quest existence, valid ID | None       | None              | `QuestService.luau:55`
| **CompleteQuest**         | Server    | Quest ID                   | Quest completion, rewards | None       | None              | `QuestService.luau:70`
| **QuestUpdated**          | Server    | Quest data                 | Valid quest state          | None       | None              | `QuestService.luau:85`
| **AbandonQuest**          | Client    | Quest ID                   | Quest existence, valid ID | None       | None              | `QuestService.luau:95`
| **CreateTrade**           | Client    | Offer items, request items  | Valid items, ownership     | None       | None              | `TradingService.luau:17`
| **AcceptTrade**           | Client    | Trade ID                   | Valid trade, ownership     | None       | None              | `TradingService.luau:28`
| **CancelTrade**           | Client    | Trade ID                   | Valid trade, ownership     | None       | None              | `TradingService.luau:45`
| **TradeCompleted**        | Server    | Trade data                 | Valid trade state          | None       | None              | `TradingService.luau:106`
| **CreateGuild**           | Client    | Guild name, description     | Valid name, no duplicates  | None       | None              | `GuildService.luau:18`
| **InviteToGuild**         | Client    | Target user ID             | Valid player, guild owner  | None       | None              | `GuildService.luau:60`
| **JoinGuild**             | Client    | Guild ID                   | Valid guild, no duplicates | None       | None              | `GuildService.luau:35`
| **LeaveGuild**            | Client    | None                      | Guild membership           | None       | None              | `GuildService.luau:52`
| **CreateListing**         | Client    | Item ID, amount, price      | Valid item, ownership, price | None       | None              | `MarketplaceService.luau:26`
| **PurchaseListing**       | Client    | Listing ID                 | Valid listing, currency    | None       | None              | `MarketplaceService.luau:54`
| **CancelListing**         | Client    | Listing ID                 | Valid listing, ownership    | None       | None              | `MarketplaceService.luau:37`
| **GetPlayerData**         | RemoteFunction | Player data              | Player existence           | None       | None              | `PlayerDataService.luau:16`
| **GetInventory**          | RemoteFunction | Inventory data           | Player existence           | None       | None              | `PlayerDataService.luau:22`
| **GetQuests**             | RemoteFunction | Quest data               | Player existence           | None       | None              | `QuestService.luau:30`
| **GetUpgrades**           | RemoteFunction | Upgrade data             | Player existence           | None       | None              | `UpgradeService.luau:25`
| **GetPets**               | RemoteFunction | Pet data                 | Player existence           | None       | None              | `PetService.luau:20`
| **GetGuildInfo**          | RemoteFunction | Guild data               | Player existence           | None       | None              | `GuildService.luau:85`
| **GetMarketplaceListings**| RemoteFunction | Listing data             | None                      | None       | None              | `MarketplaceService.luau:18`
| **GetLeaderboard**        | RemoteFunction | Leaderboard data          | None                      | None       | None              | `LeaderboardService.luau:15`

## Security Defects

### P0 (Critical)
1. **Mitigated in current checkout**: `CreateTrade` rejects empty/oversized maps, unknown item definitions, malformed quantities, and offerings the player does not own; `AcceptTrade` revalidates both sides and saves both profiles before success. Cross-server trade journaling remains future work.
2. **No central save queue** (PlayerDataService.luau): retries/backoff exist, but the periodic auto-save fan-out is not yet centrally rate-limited.
3. **Mitigated in current checkout**: marketplace listings and escrow state are durable with bounded records, UpdateAsync claims, expiry recovery, and per-profile settlement markers. Cross-server settlement remains intentionally disabled.

### P1 (High)
1. **Mitigated in current checkout**: HarvestResource is rate-limited and NodeManager rejects harvests beyond its server-side distance threshold.
2. **No Cooldown in UpgradeService** (UpgradeService.luau:65): `PurchaseUpgrade` lacks cooldown to prevent spam.
3. **No Versioning in DataStore** (PlayerDataService.luau:3): Uses `PlayerData_v1` without versioning or migration support.

### P2 (Medium)
1. **No Session Race Protection** (PlayerDataService.luau:113): `OnPlayerRemoving` lacks transactional save logic.
2. **Mitigated in current checkout**: currency and inventory mutations reject non-positive/non-integer/out-of-range amounts, and deductions require sufficient balance.
3. **Legacy catalog entry**: the former client-callable `AddXP` path has been removed. XP grants now go through server-owned services and the shared progression guard.

### P3 (Low)
1. **No Error Handling in RemoteEvents** (TradingService.luau:34): Error responses are not consistently sent to clients.
2. **No Logging for Critical Events** (GuildService.luau:130): Guild creation lacks detailed logging.
3. **No Input Sanitization** (GameClient.luau:302): `HarvestNode` accepts raw node IDs without validation.

## Persistence Audit

### PlayerDataService
- **Schema**: Uses `PlayerData_v1` DataStore with nested tables for currency, inventory, pets, and stats.
- **Versioning**: No versioning or migration support. Direct overwrites on save.
- **Concurrency**: No transactional saves; race conditions possible during player disconnection.
- **Error Handling**: Uses `pcall` for saves but lacks retry logic or fallback.
- **Verdict**: **No versioning, no migrations, no concurrency control**

## Recommended Hardening Priorities

1. **Add Rate Limiting** to all DataStore operations and critical remotes (P0).
2. **Implement Ownership Checks** for trades, guilds, and marketplace listings (P0).
3. **Add Distance Validation** for node harvesting and island changes (P1).
4. **Introduce DataStore Versioning** with migration support (P1).
5. **Add Cooldowns** to critical actions like upgrades and trades (P1).
6. **Enforce Positive Currency Balances** in all currency operations (P2).
7. **Add Logging** for critical events and errors (P3).
8. **Sanitize Inputs** for all remote events and functions (P3).

---
