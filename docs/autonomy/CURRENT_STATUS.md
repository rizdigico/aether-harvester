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
| Unit tests | PASS | `lune run scripts/run-unit-tests.luau`: 49 passed, 0 failed |
| Rojo assembly | PASS | `roblox_rojo_build` and local `rojo build` produce `.rbxlx` places |
| Git delivery | PASS | Latest pushed commits include persistence hardening and the pet-care flow |

## Implemented source surfaces

The branch now includes server-authoritative harvesting, progression, quests,
crafting, upgrades, pets, guilds, player trading, marketplace listings, mail,
scoped global/island/guild/party chat, achievements, cosmetics, leaderboards, daily rewards, events,
analytics, monetization boundaries, battle-pass progression, prestige/ascension,
persistence, session party lifecycle,
sanitization, receipt journaling, save locking, accessibility/safe-area UI,
and the rebuilt screen/controller layer.

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
- Current MCP build output: `artifacts/mcp-party-current.rbxlx`.
- Studio RSS was approximately 1.88 GB at the last probe; Godot RSS was 0.

## Asset pipeline

The governed imagegen → Godot → Roblox workflow has concept PNGs, deterministic
Godot GLB exports, and a generated asset registry. The registry records the
Godot exports as verified. Roblox import status remains `not_run` until the
assets are imported into Studio and inspected in a connected play-mode/session.

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
