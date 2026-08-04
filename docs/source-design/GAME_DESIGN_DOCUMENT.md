# Aether Harvester Simulator — Game Design Document

## Concept
A sky-based resource management simulator where players harvest floating aether energy, upgrade their gear, build sky bases, befriend aether creatures, trade at the floating market, and survive world events.

## Core Loop
Harvest aether from floating islands → earn Aether Shards → upgrade tools/backpack → access rarer islands → discover legendary creatures → expand sky base → compete in leaderboards.

## Systems

### 1. World & Map
- Floating island map (20+ islands, 5 biomes: Cloud Gardens, Storm Peaks, Void Rifts, Crystal Canyons, Ancient Ruins)
- Each island has unique resources, creatures, and hazards
- Day/night cycle with weather
- Procedural placement of resource nodes
- Player can fast-travel between unlocked islands

### 2. Harvesting System
- Tools: Basic Net → Energy Siphon → Quantum Harvester → Chrono Collector
- Each tool has range, speed, efficiency, and special ability
- Nodes respawn on timers (5-60 min based on rarity)
- Critical harvests (random chance for bonus)
- Combo system: harvest same node type consecutively for multipliers

### 3. Progression
- Level system (XP from harvesting, exploring, completing quests)
- Skill tree: Harvesting, Exploration, Trading, Engineering, Creature Care
- Prestige system for endgame (reset for permanent bonuses)
- Achievement system (50+ achievements)

### 4. Inventory & Storage
- Backpack upgrades (expand slots)
- Item rarity: Common, Uncommon, Rare, Epic, Legendary, Mythic
- Item tags: Resource, Tool, Creature Egg, Decoration, Consumable
- Quick-bar for active tools
- Auto-sort and filter

### 5. Creature System
- 12 creature types across biomes
- Creatures have rarity, stats, abilities
- Players can tame, breed, and train creatures
- Creatures assist in harvesting (passive bonuses)
- Creature battles (turn-based, 3v3)
- Creature trading

### 6. Base Building
- Sky base starts as small platform
- Expandable: resource storage, crafting stations, creature pens, garden plots, telescope
- Base can be visited by other players
- Base rating system

### 7. Economy & Trading
- Player-driven marketplace
- Dynamic pricing based on supply/demand
- Trading posts on each island
- Quests from NPCs (fetch, collect, deliver, explore)

### 8. Social
- Friends list and parties (up to 4)
- Cooperative harvesting (bonus when near friends)
- Guilds (up to 20 players, guild island, shared vault)
- Leaderboards (individual + guild)

### 9. Events
- Weekly: Aether Storm (all nodes boosted, rare spawns)
- Monthly: Rift Convergence (special dimension opens)
- Seasonal: Limited creatures, decorations, cosmetics
- Real-world holidays: themed events

### 10. UI/UX
- Clean HUD: health, energy, level, XP bar, quick-bar, minimap
- Inventory grid with drag-drop
- Skill tree visualizer
- Quest log with auto-navigation
- Settings menu (graphics, controls, audio)
- Mobile-friendly touch controls

### 11. Audio/Visual
- Ambient music per biome
- Harvesting sound effects
- Creature sounds
- Particle effects for harvesting, upgrades, events
- Screen effects (weather, rifts)

### 12. Game Balance
- Economy tuned for 100-200 hour playthrough
- No pay-to-win; cosmetics only in Robux catalog
- Anti-grind mechanics (diminishing returns after 2 hours continuous play)
- New player protection in PvP zones

## Technical Architecture

### Folder Structure
```
ReplicatedStorage/
  Shared/
    Data/
      Items/* (item definitions)
      Creatures/* (creature stats)
      Quests/* (quest definitions)
      Recipes/* (crafting recipes)
    Modules/
      Inventory.luau
      Harvesting.luau
      Progression.luau
      Trading.luau
      Creatures.luau
      Events.luau
      Utils.luau

ServerScriptService/
  GameServices/
    DataStoreService.luau
    QuestService.luau
    EventService.luau
    TradingService.luau
    CreatureService.luau
    ProgressionService.luau

StarterPlayer/
  StarterPlayerScripts/
    Client/
      HUD.luau
      InventoryUI.luau
      Minimap.luau
      InputHandler.luau

StarterGui/
  UI/
    HUD/
    Inventory/
    SkillTree/
    QuestLog/
    Settings/
    Marketplace/
```

### Key Scripts
- `DataStoreService`: Handles saving/loading player data (backed by Roblox DataStoreService)
- `HarvestingManager`: Server-authoritative node state, respawn timers, loot rolls
- `InventoryManager`: Client prediction + server validation for inventory actions
- `QuestService`: Quest tracking, objective updates, reward distribution
- `EventService`: Scheduled event management, participant tracking, reward distribution
- `TradingService`: Player trade validation, marketplace listings, price history

## Deliverables
1. Complete place file (.rbxl) with full map
2. All Luau scripts organized per architecture
3. 3D assets: tools, creatures, islands, decorations (OBJ/FBX + imported)
4. UI mockups implemented in Roblox GUI
5. Audio assets (ambient, SFX)
6. Documentation: README, script comments, balance spreadsheet
