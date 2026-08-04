# Aether Harvester Security Model

## Remote Catalog

### Remote Events & Functions
| Name               | Direction       | Payload                                      | File:Line                     | Validation Status       |
|--------------------|-----------------|-----------------------------------------------|----------------------------|------------------------|
| HarvestEvent       | Client→Server    | {nodeId: string, tool: Tool}                   | InputHandler:85   | No validation (P0)  |
| InteractionEvent   | Client→Server    | {objectName: string}                           | InputHandler:112  | No validation (P0)  |
| InventoryEvent     | Client→Server    | {action: string, item: table}                 | InventoryUI:156   | No validation (P0)  |
| MinimapEvent       | Server→Client    | {action: string, nodeId: string, nodePosition: Vector3} | Minimap:155 | Validated (P2) |
| HUDEvents          | Server→Client    | {action: string, xp: number, level: number}   | HUD:158        | Validated (P2) |
| CreatureEvent      | Server→Client    | {action: string, creature: table}             | CreatureService:236 | Validated (P2) |
| EventNotification  | Server→Client    | {eventId: string, action: string, message: string} | EventService:150 | Validated (P2) |
| QuestEvent         | Server→Client    | {questId: string, completed: boolean}         | QuestService:187 | Validated (P2) |
| TradeEvent         | Server→Client    | {action: string, tradeId: string, offer: table} | TradingService:282 | Validated (P2) |

### Authority Violations

- **InputHandler.lua:85** - `HarvestEvent` fires raw `nodeId` and `tool` without validation. Exploit: Malicious node IDs or tool manipulation.
- **InputHandler.lua:112** - `InteractionEvent` fires raw `objectName` without validation. Exploit: Object name spoofing.
- **InventoryUI.lua:156** - `InventoryEvent` fires raw `item` data without validation. Exploit: Inventory manipulation.

**Total Authority Violations:** 3
**Top 3 Severity:** P0

## Exploit Vectors

| Vector               | Attack                          | Impact                                      | Severity | Mitigation
|----------------------|--------------------------------|--------------------------------------------|----------|--------------|
| Unvalidated Remotes  | Client-side injection of arbitrary data | Data corruption, game state manipulation | P0       | Input validation, rate limiting
| Missing Rate Limits  | Spam attacks on server events    | Server overload, lag, crashes             | P1       | Rate limiting middleware
| DataStore Races      | Concurrent DataStore writes      | Inconsistent player data                | P1       | DataStore versioning, locking
| Currency Injection   | Fake currency transactions       | Cheating, balance manipulation             | P0       | Server-side validation
| Inventory Duplication| Duplicate item acquisition      | Unfair advantage, resource hoarding       | P0       | Inventory tracking, server-side checks
| Teleport Hacks       | Manipulated player position     | Game balance disruption, unfair advantage   | P1       | Position validation, movement restrictions

## DataStore Audit

- **Current Issues:**
  - No versioning for player data.
  - No locking mechanism for concurrent writes.
  - No key structure validation.

- **Secure Design:**
  - Implement versioning for player data.
  - Use locking for concurrent DataStore operations.
  - Enforce key structure validation.
  - Use sessions for temporary data.

## Validation Standards

### Per Remote Category
- **Input Validation:**
  - Validate all client inputs for type, range, and ownership.
  - Use server-side validation for all RemoteEvents.

- **Type Validation:**
  - Ensure payloads match expected types (e.g., `nodeId` must be a string).

- **Range Validation:**
  - Validate numeric ranges (e.g., `xp` must be non-negative).

- **Ownership Validation:**
  - Ensure players only interact with their own data.

- **Cooldown Validation:**
  - Implement rate limiting for all client actions.

## Rate Limit Design

- **Middleware:**
  - Implement a rate-limiting middleware for all RemoteEvents.
  - Default rate: 5 requests per second per player.
  - Exceptions: Critical actions (e.g., quest completion).

- **Implementation:**
  - Use a table to track player request timestamps.
  - Reject requests exceeding the rate limit.

## Anti-Exploit Test Checklist

- **Currency Manipulation:**
  - Test for fake currency transactions.
  - Verify server-side validation.

- **Inventory Duplication:**
  - Test for duplicate item acquisition.
  - Verify inventory tracking.

- **Teleport Hacks:**
  - Test for manipulated player positions.
  - Verify position validation.

- **DataStore Races:**
  - Test concurrent DataStore writes.
  - Verify locking mechanism.

- **Spam Attacks:**
  - Test server response to spam.
  - Verify rate limiting.

## Confirmation

- **Remote Count:** 8
- **Authority Violations Count:** 3
- **P0/P1 Exploits Found:** 5
- **Deliverable Path:** `C:\Users\aariz\kilo_HQ\roblox-dev\aether-harvester\docs\autonomy\SECURITY_MODEL.md`