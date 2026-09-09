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
1. **Mitigated in current checkout**: TradingService bounds item maps, validates item definitions and ownership on both sides, rolls back partial moves, and saves both profiles before success. Durable cross-server trade journaling remains future work.
   - **Impact**: Session-only trades cannot be resumed after a server crash.
   - **Fix**: Add a durable trade journal and idempotent retry path before cross-server trading.

2. **Save scheduling still needs a bounded queue** (PlayerDataService.luau): retries/backoff exist, but the periodic auto-save fan-out is not yet centrally rate-limited.
   - **Impact**: DataStore throttling or service disruption.
   - **Fix**: Implement rate limiting with exponential backoff.

3. **Mitigated in current checkout**: Marketplace listings and escrow state use a dedicated DataStore, UpdateAsync claims, processing expiry, and per-profile settlement markers. Cross-server settlement is intentionally not enabled.
   - **Impact**: A listing cannot be purchased while its seller profile is not loaded in the same server.
   - **Fix**: Add a cross-server settlement bus only after its profile-lock and idempotency design is verified.

### P1 (High)
1. **Mitigated in current checkout**: HarvestResource is rate-limited and NodeManager validates player proximity to the target node.
   - **Remaining work**: add adversarial multi-client coverage for spoofed instances and teleport edge cases.

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

2. **Mitigated in current checkout**: currency and inventory mutations reject non-positive/non-integer/out-of-range amounts, and deductions require sufficient balance.
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
- **Schema**: Uses the versioned `PlayerData_v1` production namespace and isolated `PlayerData_Studio_v1` namespace with schema version 3, including sanitized marketplace transaction markers.
- **Versioning**: Additive schema repair and load-time sanitation are active; a formal numbered migration registry remains future work.
- **Concurrency**: Per-player save locks, cloned snapshots, retries, and synchronous settlement guards are active.
- **Error Handling**: Saves use `pcall` with bounded retry/backoff; callers receive failure instead of acknowledging an unsafe transaction.
- **Verdict**: Hardened for the current same-server model; cross-profile and cross-server transactions still require a dedicated journal/bus.

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
