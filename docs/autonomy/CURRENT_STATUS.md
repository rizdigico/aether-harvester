# Aether Harvester — Current Verification Status

Updated: 2026-09-10
Branch: `reforge/full-autonomous-rebuild`

This file is the current evidence index. `FEATURE_MATRIX.md`, `BACKLOG.md`, and
the original recovery audit remain useful for intent and historical gaps, but
their early “missing” statements are not a description of the current source
tree.

## Source and build gates

| Gate | Result | Evidence |
|---|---|---|
| Luau formatting | PASS | `stylua --check` on touched services/controllers |
| Luau language analysis | PASS | `luau-lsp analyze` returned 0 errors and 0 warnings; only the file-watch capability info line is emitted |
| Static lint | PASS | `selene src tests` returned 0 errors, 0 warnings, 0 parse errors |
| Unit tests | PASS | `lune run scripts/run-unit-tests.luau`: 87 passed, 0 failed |
| Rojo assembly | PASS | `roblox_rojo_build` and local `rojo build` produce `.rbxlx` places |
| Local engine plugins | PASS | Installed Godot Local MCP `0.1.0+codex.20260910004615` and Roblox Local MCP `0.1.0+codex.20260910010125` both completed direct stdio handshakes |
| Git delivery | PASS | Latest pushed commits include personal bases, pet fusion, party flow, prestige, quest progression, upgrade effects, durable marketplace settlement, durable leaderboards, bounded autosave, and player energy/tool state |

## Implemented source surfaces

The branch now includes server-authoritative harvesting with persistent energy
spend/regeneration, energy-potion use, and equipped tools with durability and
tool-driven yield/cooldown effects; progression, quests,
crafting, upgrades, pets, guilds, player trading, marketplace listings, mail,
scoped global/island/guild/party chat, achievements, cosmetics, leaderboards,
daily rewards and active event effects,
analytics, monetization boundaries, battle-pass progression, event XP/resource
bonuses, server-owned energy regeneration and energy-potion use,
prestige/ascension,
persistence, session party lifecycle, deterministic pet fusion, personal base
placement,
sanitization, receipt journaling, save locking, accessibility/safe-area UI,
and the rebuilt screen/controller layer. Upgrade levels now have a durable,
sanitized profile field alongside persisted quest progression,
collection/crafting hooks advance only after successful grants, island discovery
is unique and durable, named visit objectives use canonical world IDs, and
delivery objectives consume inventory through an atomic server action.
Extra reward claim state and anti-cheat action counters are also initialized and
sanitized as part of the profile boundary. Upgrade Power and Speed effects now
feed the server harvest yield and cooldown calculations. Marketplace listings
now use a dedicated durable DataStore with bounded records, UpdateAsync-backed
claims, expiring processing locks, saved escrow, same-server settlement, and a
per-profile transaction journal for crash-safe retry of each side of a sale.
Developer-product receipt grants now use the same canonical currency rules as
ordinary server rewards, so receipt processing cannot bypass balance bounds or
introduce an unknown currency key.
Trade acceptance likewise validates both inventories, rolls back failed item
moves, persists both profiles before reporting success, and only cancels
pending offers on disconnect.
Leaderboards now persist category scores in isolated OrderedDataStores with a
15-second cached top-100 read path and a local fallback when Studio API access
is unavailable. The skill-tree screen now consumes a server-owned catalog with
bounded prerequisites and durable ranks; its harvesting, vitality, and
tool-output effects are applied by server services. Tool durability also has a
server-priced repair path exposed in inventory for the equipped tool.
Profile autosave now snapshots active user IDs and saves them sequentially with
small request spacing instead of launching one concurrent task per player. Save
locks are rechecked after waits and player removal blocks stale profile
references, preventing a leaving player’s data from being written by a delayed
autosave pass.

The latest server-core hardening makes service initialization deterministic,
prevents duplicate `ServerMain.Initialize()` wiring, rejects unknown or
overflowing inventory and currency mutations, rejects unknown pet grants, and
refuses to remove a tamed creature when its profile mutation cannot be
committed.

The client presentation layer now refreshes HUD elements on state/remote
changes instead of running an unconditional per-frame polling loop. Zero-valued
server states (empty energy, depleted durability, or zero inventory counts) are
preserved rather than being replaced by stale local fallbacks.

The pet flow specifically preserves duplicate pet instances, validates ownership
on the server, consumes `pet_food`, updates only the selected player record, and
exposes working Equip/Unequip/Feed controls.

The prestige flow is server-authoritative and save-rollback-safe: level 100 is
required, prestige is capped at 50, each completed prestige adds a permanent
10% XP multiplier, pets/cosmetics/achievements/gems/guild state are retained,
and level/skills/upgrades/inventory/soft currency/temporary boosts reset. The
client surface reads the snapshot through `GetPrestige` and can request the
transition through `RequestPrestige`.

The party flow is session-only by design: the server owns a four-player party,
validates online invites and expiring responses, transfers ownership when the
owner leaves, supports owner removal, broadcasts member snapshots, and cleans
up membership on disconnect. Party chat now routes only to the server-confirmed
party membership and remains live-only rather than exposing unscoped history.
It is intentionally not persisted into player profiles.

The Fusion Lab adds deterministic, free-to-play recipes for owned pet instances.
The server requires two distinct owned, un-equipped instances, removes them
atomically, restores them if the result cannot be granted, and emits the new
pet only after the server has completed the mutation. The client exposes the
inventory selection and known-result preview; it never decides ownership or
the result.

The personal base flow persists a bounded 15×15 decoration grid, consumes only
owned Decoration items, rejects occupied or malformed cells, returns items on
removal, renders the result on a server-created base platform, and provides a
server-controlled visit action. Base data is sanitized during profile load.

## Local MCP evidence

### Godot Local MCP

- Godot 4.7.2 is detected.
- The content project at `assets` exists and has `project.godot`.
- Headless import/parse check returned exit code 0.
- The content lab is intentionally custom; it does not use the conventional
  `scenes/`, `scripts/`, `addons/`, or `export_presets.cfg` layout.
- No Godot process is left running after verification.
- The headless command emits Godot’s harmless `Scan thread aborted` shutdown
  warning after the successful scan; the exit code remains 0.

### Roblox Local MCP

- Roblox Studio, Rojo 7.7.0, and Wally 0.3.2 are detected.
- The Aesther Harvest Studio window is visible locally.
- Project inspection passes for `default.project.json` and `src`.
- Current MCP build output: `artifacts/mcp-base-current.rbxlx`.
- The installed plugin status probe is green for both Rojo and Wally; Rojo
  version detection uses its pinned Rokit binary when the shim is called
  outside a project manifest.
- The companion native `roblox-studio` MCP server exposes 29 StudioMCP tools
  through a persistent stdio passthrough and selects the active Studio version.
- StudioMCP currently returns a connected instance id, but
  `get_studio_state` reports `Place is not open`; live play-mode verification
  therefore remains pending.
- Studio RSS was approximately 1.88 GB at the last probe; Godot RSS was 0.

## Asset pipeline

The governed imagegen → Godot → Roblox workflow has concept PNGs, deterministic
Godot GLB exports, and a generated asset registry. The latest production
reference is `assets/concepts/aether_bloom_concept_v2.png`; it was assembled
and exported as `AetherBloom_Godot_v2.glb` through the corrected Godot local
bridge. The v2 GLB contains 12 nodes, 11 meshes/primitives, 840 triangles, and
11 materials. The registry records the Godot export and image provenance as
verified. Roblox import status remains `not_run` until the model is imported
into Studio and inspected in a connected play-mode/session.

## Remaining release gates

These are genuine external or human gates, not silently marked complete:

1. Connected Studio play-mode verification with real screenshots and runtime
   logs for boot, spawn, harvest, travel, UI, pets, social, and persistence.
2. Import/scale/material/pivot verification for generated assets in Studio.
3. Creator Hub creation and human review of real game-pass/developer-product
   IDs; product IDs intentionally remain zero in source until that happens.
4. Staging publish, multi-client/soak testing, human playtest, and production
   approval.

No claim of live production publishing, live player revenue, or guaranteed
monetization is made by this repository.

## Refreshed external policy evidence

- Roblox developer products must be created on a published, accessible
  experience and granted through server-side `ProcessReceipt`; the client
  purchase-finished event is not proof of payment. See the [official Developer
  Products documentation](https://create.roblox.com/docs/production/monetization/developer-products).
- Roblox treats paid eggs/chests/wheels and paid luck or pity modifiers as paid
  random items. Such features require outcome/odds disclosure and per-user
  `PolicyService` handling, so they remain excluded from the first release. See
  the [official paid random items policy](https://create.roblox.com/docs/production/monetization/paid-random-items).
- DevEx and Creator Rewards describe eligibility and payout programs, not a
  revenue guarantee. See [DevEx](https://create.roblox.com/docs/production/monetization/developer-exchange)
  and [Creator Rewards](https://create.roblox.com/docs/creator-rewards).
- Godot content shipped with the project must retain appropriate MIT/third-party
  attribution. See Godot’s [license compliance guidance](https://docs.godotengine.org/en/stable/about/complying_with_licenses.html).
