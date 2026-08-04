# REPO-STUDIO DIFF — Truthful baseline (2026-08-04)

## Summary
The live Studio place (universe 10612238315, place 97649669204650) contained the ONLY
full copy of the real game. Recovery completed 2026-08-04: every script, remote, UI
screen, and world inventory entry extracted into `src/` + `artifacts/recovery/`.

## Source of truth decision
| System | Source | Status |
|---|---|---|
| 24 GameServices | Live Studio (extracted) | ✅ recovered to src/ServerScriptService/AetherServer/GameServices/ |
| 7 Data modules | Live Studio (extracted) | ✅ src/ReplicatedStorage/AetherShared/Data/ |
| 3 Shared Modules (Utils, ServerMain, GameClient) | Live Studio (extracted) | ✅ src/ReplicatedStorage/AetherShared/Modules/ |
| 6 Client controllers | Live Studio (extracted) | ✅ src/StarterPlayer/StarterPlayerScripts/ |
| 5 World scripts (FallGuard, LightingConfig, PortalScript, WorldAnimation, ServerBootstrap) | Live Studio (extracted) | ✅ src/ServerScriptService/ |
| 81 Remotes (73 events + 8 functions) | Live Studio (inventoried) | ✅ src/ReplicatedStorage/AetherShared/Remotes.model.json |
| 12 UI screens | Live Studio (tree-dumped) | ✅ artifacts/recovery/StarterGui_AetherUI_Screens_*.json (instance trees; UI reforge will rebuild declaratively) |
| World: 10 islands, 29 nodes, 17 creatures, 5 portals, 30 props | Live Studio (inventoried) | ✅ artifacts/recovery/Workspace_AetherWorld.json |
| HUD ScreenGui | Live Studio | ⚠️ confirmed exists (AetherUI.HUD); tree dump pending in world/UI reforge |

## README claim verification (from §2.2 baseline)
| Claim | Verdict |
|---|---|
| SkySanctum spawn (0,147,0) | ✅ CONFIRMED (live boot log: onCharacterAdded -> SkySanctum, teleport result: true) |
| FallGuard | ✅ CONFIRMED (live script + boot log) |
| 24 services | ✅ CONFIRMED (boot log lists 24; all recovered) |
| 10 floating islands | ✅ CONFIRMED (boot log: Registered 10 playable islands; world dump) |
| 29 harvest nodes | ✅ CONFIRMED (boot log: Discovered 29 resource nodes) |
| Live harvesting | ✅ CONFIRMED (earlier E2E evidence) — regression test pending on recovered code |
| First Harvest quest | ✅ CONFIRMED (quest_first_harvest in Data/Quests) — regression pending |
| Pet taming + Cloud Sprite follower | ✅ CONFIRMED (PetService + Data/Pets + TameCreature remote) — regression pending |
| Upgrade purchasing | ✅ CONFIRMED (UpgradeService + PurchaseUpgrade remote) — regression pending |
| Inventory/Quest/Pet screens | ✅ CONFIRMED (screens exist + ScreenController populates) — regression pending |
| Five portals | ✅ CONFIRMED (PortalScript + 5 portal entries in world dump) |
| Server-authoritative player data | ✅ CONFIRMED by design (PlayerDataService) — security audit pending |

## Obsolete/removed during recovery
- Legacy prototype Modules (Inventory, Progression, Trading, Creatures, Events, Harvesting)
- Legacy GameServices (DataStoreService, HarvestingService)
- Placeholder init.luau / Util.luau / ClientBoot
- Dead specs referencing removed modules
- 3 broken legacy services (CreatureService/NodeManager/TradingService prototype era)
