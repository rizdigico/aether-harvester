# Aether Harvester Simulator - Game Systems Specification

## Overview
Aether Harvester Simulator is a resource management and exploration game set in a mystical universe where players harvest Aether, a rare and powerful energy source, to expand their settlements, unlock advanced technologies, and engage with a rich pet and social ecosystem. Players explore a vertically-layered archipelago of floating islands, manage resources, build complex ecosystems, and thrive in a dynamic environment.

This document outlines the core game systems, their data structures, API contracts, edge cases, and balance considerations. Each system is designed to be modular, extensible, and optimized for performance in a Roblox environment.

---

## 1. Pet System

### 1.1 Overview
Pets are companions that assist players in harvesting, combat, and support roles. They level up, gain abilities, and can be equipped with gear.

### 1.2 Pet Classes
- **Harvester**: Increases resource yield and gathering speed
- **Combat**: Fights enemies and protects the player
- **Support**: Provides buffs, healing, and utility
- **Mount**: Increases movement speed and allows aerial traversal

### 1.3 Rarity Tiers
| Tier | Color | Drop Rate | Max Level | Abilities |
|------|-------|-----------|-----------|-----------|
| Common | Gray | 60% | 30 | 1 passive |
| Uncommon | Green | 25% | 50 | 1 passive, 1 active |
| Rare | Blue | 10% | 75 | 2 passive, 1 active |
| Epic | Purple | 4% | 100 | 2 passive, 2 active |
| Legendary | Orange | 0.9% | 150 | 3 passive, 2 active |
| Mythical | Red | 0.1% | 200 | 3 passive, 3 active, unique aura |

### 1.4 Pet Stats
```lua
export type PetStats = {
    Level: number,
    XP: number,
    XPToNextLevel: number,
    Hunger: number,        -- 0-100, decays over time
    Happiness: number,     -- 0-100, increases with interaction
    Energy: number,        -- 0-100, used for active abilities
    HarvestPower: number,
    Speed: number,
    Luck: number,
    Defense: number,
}
```

### 1.5 Pet Abilities
- **Active Skills**: Player-triggered abilities with cooldowns
- **Passive Buffs**: Always-on bonuses (e.g., +10% mining speed)
- **Synergy Bonuses**: Bonus effects when multiple pets of the same class are active

### 1.6 Pet Inventory
- Maximum 12 pet slots (expandable via shop)
- 4 equip slots per pet: Hat, Collar, Backpack, Aura
- Pet fusion: combine 2 same-rarity pets for higher rarity chance

### 1.7 Breeding/Hatching
- Eggs obtained from drops, shop, or quests
- Hatching time: 30 min (common) to 24 hrs (mythical)
- Incubator upgrades reduce hatch time
- Genetics: parent stats influence offspring (mutation chance: 5%)

### 1.8 Pet UI
- Pet cards with portrait, name, level, rarity border
- Stats bars with icons
- Ability tooltips on hover
- Equip grid with drag-and-drop

### 1.9 Edge Cases
- Pet death: permanent (hardcore) or temporary (softcore)
- Hunger reaching 0: pet becomes ineffective until fed
- Energy depletion: active abilities disabled until recharged
- Duplicate pet handling: merge for XP or keep separate

### 1.10 Balance Considerations
- XP curves: exponential growth, ~2x per level
- Food costs: scale with pet level and rarity
- Ability power: capped at 200% of base stat
- Fusion costs: increase exponentially with target rarity

---

## 2. Reward System

### 2.1 Daily Login Rewards
- 30-day rolling calendar
- Streak bonuses: +50% on day 7, 14, 21, 28
- Monthly rare reward on day 30
- Streak freeze: 1 per month (premium currency)
- Login bonus scales with player level

### 2.2 Achievement System
| Category | Examples | Tier Rewards |
|----------|----------|--------------|
| Harvesting | Mine 1000 ore, Harvest 500 herbs | Currency, titles, cosmetics |
| Combat | Defeat 100 enemies, Clear 10 dungeons | Pets, weapons, armor |
| Social | Add 50 friends, Join a guild | Exclusive mounts, emotes |
| Exploration | Discover all zones, Find 100 secrets | Map skins, teleport unlocks |
| Collection | Collect 50 pets, Complete item set | Display cases, rare items |

### 2.3 Quest Rewards
- Main quests: large XP, unique items, story progression
- Side quests: moderate XP, currency, common items
- Daily quests: small XP, currency, daily tokens
- Weekly quests: large currency, rare items, pet eggs
- Event quests: exclusive event currency, limited-time items

### 2.4 Event Rewards
- Event currency earned during active events
- Limited-time shop with exclusive items
- Event pass: free track + premium track
- Event pets/items become unobtainable after event ends

### 2.5 Loot Box System
- Rates published transparently
- Pity system: guaranteed rare at 50 pulls, legendary at 200 pulls
- Animation: 3-second reveal with rarity spotlight
- Duplicate protection: no duplicate pets from standard boxes

### 2.6 Progression Rewards
- Level up: skill points, currency, small loot box
- Rank ups: exclusive title, cosmetics, access to new zones
- Prestige: reset progress for permanent bonuses (XP boost, unique aura)

### 2.7 Edge Cases
- Offline rewards: capped at 8 hours
- Streak recovery: paid option vs. natural recovery over 3 days
- Achievement popups: queue system, max 3 visible
- Reward overflow: auto-sent to mailbox (7-day expiry)

### 2.8 Balance Considerations
- Daily login value: ~15 min of active gameplay equivalent
- Achievement difficulty: bronze (easy), silver (medium), gold (hard), platinum (very hard)
- Loot box rates: verified by third party, publish odds
- Pity system: carries over between box types

---

## 3. Economy System

### 3.1 Currencies
| Currency | Source | Sink | Exchange Rate |
|----------|--------|------|---------------|
| Aether Shards | Harvesting, quests | Upgrades, shop | 1:1000 (soft:hard) |
| Aether Gems | Daily, achievements | Premium shop, trades | 1:10000 (hard:premium) |
| Event Tokens | Events | Event shop | Event-specific |
| Fame Points | Leaderboards, guilds | Prestige, cosmetics | Prestige-specific |

### 3.2 Item Rarities and Values
| Rarity | Color | Base Value | Drop Rate |
|--------|-------|------------|-----------|
| Common | Gray | 1-10 shards | 60% |
| Uncommon | Green | 10-50 shards | 25% |
| Rare | Blue | 50-200 shards | 10% |
| Epic | Purple | 200-1000 shards | 4% |
| Legendary | Orange | 1000-5000 shards | 0.9% |
| Mythical | Red | 5000+ shards | 0.1% |

### 3.3 Shop System
- **Daily Shop**: 6 rotating items, refreshes every 24h
- **Rotating Shop**: 12 items, refreshes every 7 days
- **Permanent Shop**: Always-available upgrades and cosmetics
- **Bundle Deals**: Discounted packs with currency + items
- **Premium Pass**: Monthly subscription with daily rewards

### 3.4 Trading System
- Player-to-player trading with item/currency offers
- 5% marketplace tax on all trades
- Trade limits: max 10 trades/day for free, 50 for premium
- Trade history and scam protection (value mismatch warnings)
- Trade offers expire after 7 days

### 3.5 Crafting Costs and Profits
- Crafting recipes require materials + currency
- Material costs: 60-80% of item market value
- Profit margin: 20-40% for crafted items
- Critical craft: 10% chance for +1 rarity item
- Crafting stations: basic (home), advanced (guild), master (special zone)

### 3.6 Inflation Control
- Currency sinks: repairs, upgrades, travel, trades
- Dynamic pricing: prices adjust based on supply/demand
- Item degradation: tools lose durability and require repair/replacement
- Luxury taxes: high-value trades taxed at 10%
- Guild taxes: guilds can set member tax rates (5-15%)

### 3.7 Edge Cases
- Currency cap: 999,999,999 per currency type
- Trade exploits: value validation, anti-Scam checks
- Market manipulation: price bounds, cooldowns
- Duplicate items: stackable items have max stack size

### 3.8 Balance Considerations
- Soft currency: abundant, primarily for upgrades
- Hard currency: scarce, for premium items and trades
- Premium currency: purchasable only, never farmable
- Item values: adjusted weekly based on market data

---

## 4. Progression System

### 4.1 Player Levels and XP
- Max level: 100 (soft cap), prestige levels beyond
- XP requirements: exponential curve (~1.5x per level)
- XP sources: harvesting (+1 per resource), quests (+10-100), events (+50-200)
- Level effects: unlock zones, increase inventory, unlock skill points

### 4.2 Skill Tree
| Branch | Focus | Key Skills |
|--------|-------|------------|
| Harvesting | Resource gathering | Faster gathering, rare finds, bonus drops |
| Combat | Fighting enemies | Damage, defense, critical hits, abilities |
| Trading | Market and economy | Trade discounts, market analysis, bulk selling |
| Exploration | Map and movement | Speed, teleport unlocks, secret finding |
| Pets | Pet management | Pet capacity, training speed, fusion bonuses |

- Max skill points: 5 per level (500 total)
- Skill respec: free once, then costs currency
- Synergy bonuses: 3+ points in a branch unlocks ultimate ability

### 4.3 Prestige/Rebirth
- Prestige available at level 100
- Reset: level, skills, inventory, currency (soft)
- Keep: pets (with level cap), cosmetics, account data
- Prestige bonus: +10% XP per prestige level (max 50 prestiges)
- Prestige title and unique aura

### 4.4 Region Unlocks
- Tier 1 (Level 1-20): Cloud Gardens, Enchanted Forest
- Tier 2 (Level 21-40): Storm Peaks, Crystal Canyons
- Tier 3 (Level 41-60): Volcanic Wastes, Ocean Depths
- Tier 4 (Level 61-80): Void Rifts, Astral Plane
- Tier 5 (Level 81-100): Ancient Ruins, Core Aether
- Each tier requires: level + skill points + completion of previous tier quests

### 4.5 Tool Upgrades
| Tier | Material | Power | Speed | Durability |
|------|----------|-------|-------|------------|
| Basic | Wood, Stone | 10 | 1x | 100 |
| Iron | Iron Ore | 25 | 1.5x | 250 |
| Steel | Steel Ingot | 50 | 2x | 500 |
| Crystal | Crystal Shard | 100 | 3x | 1000 |
| Aether | Aether Core | 200 | 5x | 2500 |
| Divine | Divine Essence | 500 | 10x | 5000 |

### 4.6 Edge Cases
- XP overflow: excess XP carries to next level
- Prestige protection: items marked "prestige-safe" are kept
- Region lock: player cannot enter higher-tier zones even with high-level items
- Skill refunds: only available at special NPCs in hub

### 4.7 Balance Considerations
- Level 100 time investment: ~200 hours for casual, ~100 hours for hardcore
- Prestige curve: diminishing returns after 10 prestiges
- Tool upgrades: meaningful power increase, not game-breaking
- Region difficulty: enemies scale with player level

---

## 5. Quest System

### 5.1 Quest Types
- **Main Quest**: Story-driven, linear progression, unique rewards
- **Side Quest**: Optional, open world, repeatable variants
- **Daily Quest**: Resets every 24h, 3-5 per day, token rewards
- **Weekly Quest**: Resets every Monday, harder, rare rewards
- **Event Quest**: Active only during events, exclusive rewards
- **Hidden Quest**: Discovered through exploration, secret rewards

### 5.2 Quest Structure
```lua
export type Quest = {
    Id: string,
    Title: string,
    Description: string,
    Type: "Main" | "Side" | "Daily" | "Weekly" | "Event" | "Hidden",
    Objectives: { QuestObjective },
    Rewards: { QuestReward },
    Prerequisites: { string }, -- quest IDs
    LevelRequirement: number,
    IsRepeatable: boolean,
    CooldownHours: number,
    IsHidden: boolean,
    IsCompleted: boolean,
    IsActive: boolean,
    Progress: { [string]: number }, -- objective ID -> progress
}
```

### 5.3 Quest Objectives
- Harvest X amount of resource
- Visit X location
- Defeat X enemies
- Craft X items
- Trade X items with players
- Level up pet to X
- Complete X side quests
- Discover X secrets

### 5.4 Quest Chain Design
- 5-act main quest with boss at end of each act
- Side quest chains unlock world events
- Hidden quests triggered by specific actions (e.g., stand on specific tile at midnight)
- Quest givers: NPCs in hubs, random world encounters

### 5.5 Quest UI
- Active tracker (top-right): current quest + objectives
- Quest log (full list): tabs by type, filters, search
- Objective checklist: completed objectives struck through, current highlighted
- Reward preview: hover quest to see rewards
- Abandon quest: with confirmation, 1h cooldown

### 5.6 Edge Cases
- Quest abandonment: progress lost, can re-accept after cooldown
- Objective failure: some quests have fail conditions (time limit)
- Prerequisite loops: circular dependencies not allowed
- Hidden quest discovery: tracked separately, only visible in quest log after discovery

### 5.7 Balance Considerations
- Daily quest time: 15-30 min for full completion
- Weekly quest time: 1-2 hours
- Main quest pacing: 1 hour per act
- Reward scaling: main quests give 10x daily quest rewards

---

## 6. Event System

### 6.1 Seasonal Events
| Season | Event | Duration | Theme |
|--------|-------|----------|-------|
| Spring | Bloom Festival | 2 weeks | Nature, growth, flowers |
| Summer | Solar Festival | 2 weeks | Sun, fire, beach |
| Autumn | Harvest Festival | 2 weeks | Abundance, pumpkins, gratitude |
| Winter | Frost Festival | 2 weeks | Ice, snow, gifts |

### 6.2 Event Mechanics
- Event zones: temporary areas with unique resources and enemies
- Event currencies: earned only during event, spent in event shop
- Event quests: chain quests with story and rewards
- Event bosses: raid-style encounters with multiple players
- Event pass: free + premium reward track

### 6.3 Event Shop
- Exclusive pets (event-themed)
- Limited-time cosmetics (outfits, accessories, auras)
- Event currency bundles
- Permanent unlock tokens (for event items after event)

### 6.4 Event Balance
- Event power: comparable to T3 gear (not overpowered)
- Event currency rate: ~100/hour for active players
- Premium pass value: ~2x free track rewards
- FOMO mitigation: reruns every 6-12 months

### 6.5 Edge Cases
- Event overlap: max 1 active event at a time
- Event catch-up: catch-up mechanics for late joiners
- Event persistence: event items usable outside event zones
- Event bugs: server-side validation, rollback capability

---

## 7. Social Systems

### 7.1 Friends List
- Max 200 friends
- Online/offline status, current zone, activity
- Friend requests with message (500 char limit)
- Best friends: highlighted, priority notifications
- Block list: 100 max, no interaction allowed

### 7.2 Parties
- Max 4 players per party
- Party benefits: +10% XP, shared resource nodes, party-only loot
- Party leader: can invite/kick, set region lock
- Party chat: dedicated channel
- Disband: auto after 30 min inactivity or all leave

### 7.3 Guild System
- Guild creation: level 10+, 1000 shards
- Max 30 members per guild
- Ranks: Member, Officer, Elder, Leader
- Guild perks: XP boost, resource boost, shared bank, guild quests
- Guild bank: shared storage, withdrawal limits by rank
- Guild quests: weekly objectives, guild-wide rewards
- Guild wars: competitive events against other guilds

### 7.4 Leaderboards
- Personal: level, wealth, pets collected, quests completed
- Guild: total guild power, event points, wealth
- Global: top 100 per category, weekly resets
- Seasonal leaderboards with exclusive rewards

### 7.5 Chat System
- Local: proximity-based, 50 stud radius
- Party: party members only
- Guild: guild members only
- Global: all players, rate-limited (10 msg/min)
- Chat filters: profanity filter, spam detection
- Chat history: 100 messages per channel

### 7.6 Edge Cases
- Guild disband: leader can transfer or disband
- Party invites: auto-decline after 60s, spam protection
- Chat exploits: rate limiting, character limits
- Friend limits: remove oldest friend if at capacity

### 7.7 Balance Considerations
- Guild perks: +5% to +25% based on guild level
- Party bonuses: small, encourage grouping without forcing
- Leaderboard rewards: cosmetic only, no pay-to-win
- Chat: essential for social play, minimal performance impact

---

## 8. Combat System

### 8.1 Overview
Combat is optional and non-lethal. Players can choose peaceful mode (no PvP) or engage with enemies for rewards.

### 8.2 Enemy Types
- **Passive Creatures**: Harvesting targets, no combat
- **Defensive Creatures**: Attack when harvested, flee at low HP
- **Aggressive Creatures**: Attack on sight, guard resources
- **Bosses**: Multi-phase, require groups, drop rare items

### 8.3 Combat Stats
```lua
export type CombatStats = {
    Health: number,
    Attack: number,
    Defense: number,
    Speed: number,
    CriticalChance: number,
    CriticalDamage: number,
    Resistance: { [string]: number }, -- damage type -> resistance %
}
```

### 8.4 Abilities
- **Basic Attack**: No cooldown, low damage
- **Special Ability**: 5-30s cooldown, medium damage + effect
- **Ultimate Ability**: 60-180s cooldown, high damage + area effect
- **Pet Assist**: pet uses active ability, costs pet energy

### 8.5 Combat Flow
1. Target acquisition: click enemy or use tab targeting
2. Auto-attack: basic attack every 1s
3. Ability rotation: player uses special/ultimate on cooldown
4. Pet assist: pet uses abilities automatically when energy available
5. Loot: drops on enemy death, auto-collected or manual

### 8.6 Damage Types
- Physical: reduced by Defense
- Magic: reduced by Resistance
- True: ignores defense/resistance
- Elemental: Fire, Ice, Lightning (additional resistances)

### 8.7 Edge Cases
- Death: respawn at nearest spawn point, 10s immunity
- Combat logging: 5s grace period before logout allowed
- PvP: consent-based, no forced PvP
- Enemy respawn: 30s-5min based on enemy type
- Combat exploits: server-side validation, speed cap

### 8.8 Balance Considerations
- Player damage: ~100-500 DPS depending on level and gear
- Enemy HP: scales with level (player HP x 2-5)
- Combat duration: 10-30s for normal enemies, 2-5 min for bosses
- Pet contribution: ~20-30% of total DPS
- Peaceful mode: players cannot be attacked, enemies ignore peaceful players

---

## 9. Cross-System APIs

### 9.1 Core Data Structures
```lua
export type PlayerData = {
    PlayerId: string,
    Level: number,
    XP: number,
    Currency: { AetherShards: number, AetherGems: number, EventTokens: number, FamePoints: number },
    Inventory: { [string]: ItemStack },
    PetInventory: { PetData },
    EquippedPets: { number }, -- pet indices
    Skills: { [string]: number }, -- skill ID -> points invested
    Quests: { [string]: QuestState },
    Achievements: { [string]: boolean },
    Stats: {
        HarvestCount: number,
        CombatKills: number,
        TradesCompleted: number,
        PlaytimeMinutes: number,
    },
    Settings: PlayerSettings,
    PrestigeLevel: number,
    GuildId: string?,
}
```

### 9.2 RemoteEvents
- `HarvestResource`: client -> server, request harvest
- `ResourceHarvested`: server -> client, confirm harvest + rewards
- `UseItem`: client -> server, use inventory item
- `EquipPet`: client -> server, equip/unequip pet
- `PetAbilityUsed`: client -> server, trigger pet ability
- `AcceptQuest`: client -> server, accept quest
- `UpdateQuestProgress`: server -> client, quest progress update
- `TradeRequest`: client -> server, initiate trade
- `TradeUpdate`: server -> client, trade state update
- `GuildAction`: client -> server, guild management
- `ChatMessage`: client -> server, send chat message

### 9.3 Edge Cases (Cross-System)
- Concurrent access: server-authoritative, all state changes server-side
- Data validation: all client inputs validated server-side
- Race conditions: atomic operations, no client-side state trust
- Memory leaks: event connections disconnected on player leave
- DataStore limits: batch writes, retry logic, fallback to cache

### 9.4 Balance Considerations (Cross-System)
- Grinding vs. engagement: rewards taper off after 2 hours of continuous play
- Pay-to-win prevention: no pay-to-win items, only cosmetics and convenience
- New player experience: starter pack, boosted XP for first 10 levels
- End-game content: prestige, leaderboards, guild competition

---

## 10. Implementation Notes

### 10.1 Performance Targets
- Server tick rate: 20 Hz
- Client frame rate: 60 FPS target, 30 FPS minimum
- Network usage: <50 KB/s per player
- Memory usage: <500 MB per client, <2 GB per server

### 10.2 Security Considerations
- Server-authoritative: all critical logic on server
- Input validation: all RemoteEvent args validated
- Anti-exploit: speed checks, fly detection, noclip detection
- Data integrity: DataStore writes atomic, backup every 5 min
- Rate limiting: max actions per second per player

### 10.3 Scalability
- Player count: 50 per server (target), 100 max
- Instance limits: 10,000 parts per server
- Streaming: zones load/unload based on player proximity
- Sharding: multiple servers for high-population events

### 10.4 Testing Strategy
- Unit tests: server modules with TestService
- Integration tests: full quest chains, trading, combat
- Load tests: 50+ players, measure tick time
- Playtests: weekly sessions with feedback collection

---

*Document generated by Agent-Company-X worker-e / orchestrator.*
*Last updated: 2026-08-02.*
