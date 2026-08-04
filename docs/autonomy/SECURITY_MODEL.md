# SECURITY MODEL

## Threat Model

### Assumptions
- **Server-authoritative**: All sensitive state (currency, inventory, guilds) is validated server-side.
- **Client-trusted**: Client-side state is only for UI and does not affect game logic.
- **Roblox Environment**: Uses Roblox DataStoreService with no external dependencies.

### Attack Vectors
1. **Client-Side Exploitation**: Manipulating client state to bypass server validation.
2. **DataStore Abuse**: Rapid saves or invalid data to crash DataStore or cause race conditions.
3. **Ownership Bypass**: Exploiting missing ownership checks in trades, guilds, and marketplace.
4. **Currency Manipulation**: Exploiting missing validation to create negative balances or infinite currency.
5. **Race Conditions**: Exploiting lack of transactional saves or session races.

## Found Defects

### P0 (Critical)
1. **Missing Validation in TradingService** (TradingService.luau:17): No validation for item ownership or quantity in `CreateTrade`. Clients can send arbitrary item IDs and amounts.
   - **Impact**: Arbitrary item creation and trading.
   - **Fix**: Validate item ownership and quantity before processing trades.

2. **No Rate Limiting on DataStore** (PlayerDataService.luau:44): Auto-save loop lacks rate limiting, risking DataStore throttling or abuse.
   - **Impact**: DataStore throttling or service disruption.
   - **Fix**: Implement rate limiting with exponential backoff.

3. **No Ownership Check in MarketplaceService** (MarketplaceService.luau:107): `PurchaseListing` allows buying own listings without validation.
   - **Impact**: Self-trading and potential currency exploits.
   - **Fix**: Add ownership check to prevent buying own listings.

### P1 (High)
1. **No Distance Check in HarvestResource** (WorldManager.luau:123): No validation that the player is near the node.
   - **Impact**: Players can harvest nodes from arbitrary distances.
   - **Fix**: Validate player proximity to nodes.

2. **No Cooldown in UpgradeService** (UpgradeService.luau:65): `PurchaseUpgrade` lacks cooldown to prevent spam.
   - **Impact**: Spam attacks on upgrade purchases.
   - **Fix**: Implement cooldown logic for upgrade purchases.

3. **No Versioning in DataStore** (PlayerDataService.luau:3): Uses `PlayerData_v1` without versioning or migration support.
   - **Impact**: Data corruption during schema changes.
   - **Fix**: Implement versioning and migration support.

### P2 (Medium)
1. **No Session Race Protection** (PlayerDataService.luau:113): `OnPlayerRemoving` lacks transactional save logic.
   - **Impact**: Race conditions during player disconnection.
   - **Fix**: Use transactional saves or optimistic concurrency.

2. **No Negative Currency Check** (PlayerDataService.luau:145): `RemoveCurrency` allows negative balances.
   - **Impact**: Negative currency balances and potential exploits.
   - **Fix**: Validate currency balances before deduction.

3. **No Guild XP Validation** (GuildService.luau:254): `AddXP` lacks validation for valid guilds.
   - **Impact**: Invalid guild XP manipulation.
   - **Fix**: Validate guild existence before adding XP.

### P3 (Low)
1. **No Error Handling in RemoteEvents** (TradingService.luau:34): Error responses are not consistently sent to clients.
   - **Impact**: Poor user experience and lack of feedback.
   - **Fix**: Standardize error responses for all remote events.

2. **No Logging for Critical Events** (GuildService.luau:130): Guild creation lacks detailed logging.
   - **Impact**: Lack of audit trail for critical actions.
   - **Fix**: Add detailed logging for guild and trade operations.

3. **No Input Sanitization** (GameClient.luau:302): `HarvestNode` accepts raw node IDs without validation.
   - **Impact**: Potential injection or invalid node exploitation.
   - **Fix**: Validate node IDs and sanitize inputs.

## Persistence Audit

### PlayerDataService
- **Schema**: Uses `PlayerData_v1` DataStore with nested tables for currency, inventory, pets, and stats.
- **Versioning**: **No versioning** or migration support. Direct overwrites on save.
- **Concurrency**: **No transactional saves**; race conditions possible during player disconnection.
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
9. **Implement Transactional Saves** for player data (P2).
10. **Add Input Validation** for all remote events and functions (P3).

---