# Aether Harvester Simulator — Game Design Specification

## Overview
Aether Harvester Simulator is a sky-based resource management and creature care simulator where players harvest floating aether energy, upgrade their gear, build sky bases, befriend creatures, and engage in dynamic events. The game features deep progression systems, a player-driven economy, and a rich ecosystem of quests, creatures, and crafting.

---

## 1. Item Database

### **Item Categories**: 
- **Resources**: Raw materials harvested from nodes
- **Tools**: Equipment for harvesting and exploration
- **Consumables**: Items that provide temporary buffs or healing
- **Decorations**: Aesthetic items for sky bases
- **Creature Eggs**: Used to hatch creatures
- **Components**: Used for crafting and upgrades

### **Item Rarity**: 
- Common (White)
- Uncommon (Gray)
- Rare (Blue)
- Epic (Purple)
- Legendary (Gold)
- Mythic (Mythril, rare drops)

### **Item Database**

| **Name**               | **Type**         | **Rarity**   | **Value** | **Description**                                                                 | **Stats/Effects**                                                                 | **Drop Chance** | **Biome**          |
|------------------------|------------------|------------|---------|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------|------------------|-------------------|
| Aether Shard          | Resource         | Common      | 5        | Basic energy resource harvested from nodes.                                   | -                                                                           | 100%             | All Biomes        |
| Storm Crystal          | Resource         | Uncommon    | High-energy resource found in Storm Peaks.                                   | +20% energy yield when harvested with Energy Siphon.                         | 30%              | Storm Peaks       |
| Void Essence           | Resource         | Rare        | Dark matter harvested from Void Rifts.                                        | Grants +10% XP when used in crafting.                                         | 15%              | Void Rifts        |
| Crystal Fragment       | Resource         | Epic        | Shards of pure energy from Crystal Canyons.                                   | +30% harvesting speed with Quantum Harvester.                                 | 5%               | Crystal Canyons   |
| Ancient Relic          | Resource         | Legendary   | Ancient artifact from Ruins.                                                  | +50% critical harvest chance.                                                | 1%               | Ancient Ruins     |
| Mythril Dust           | Resource         | Mythic      | Rare cosmic dust.                                                             | Grants +100% XP for 1 hour when used in crafting.                             | 0.1%             | All Biomes        |
| Basic Net              | Tool            | Common      | Starter tool for harvesting.                                                  | Range: 5m, Speed: 1.0, Efficiency: 1.0, No special ability.                   | -                | -                 |
| Energy Siphon          | Tool            | Uncommon    | Advanced harvesting tool.                                                    | Range: 8m, Speed: 1.5, Efficiency: 1.2, Passive energy regen.               | -                | -                 |
| Quantum Harvester       | Tool            | Rare        | High-tech harvesting tool.                                                    | Range: 12m, Speed: 2.0, Efficiency: 1.5, Combo multiplier (x2 after 3 harvests). | -                | -                 |
| Chrono Collector        | Tool            | Epic        | Time-manipulating harvesting tool.                                           | Range: 15m, Speed: 2.5, Efficiency: 2.0, Time freeze on critical harvest.     | -                | -                 |
| Healing Potion          | Consumable      | Common      | Restores 30% health.                                                          | -                                                                           | -                | -                 |
| Energy Elixir           | Consumable      | Rare        | Restores 50% energy and grants +10% harvest speed for 10 minutes.            | -                                                                           | -                | -                 |
| Storm Shield            | Consumable      | Epic        | Protects against lightning damage.                                            | -                                                                           | -                | Storm Peaks       |
| Ancient Amulet          | Consumable      | Legendary   | Grants +20% XP and +15% harvest efficiency.                                  | -                                                                           | -                | Ancient Ruins     |
| Sky Lantern             | Decoration      | Common      | Floating light decoration.                                                   | -                                                                           | -                | -                 |
| Crystal Orb             | Decoration      | Rare        | Glowing orb decoration.                                                      | -                                                                           | -                | Crystal Canyons   |
| Void Mirror             | Decoration      | Epic        | Mystical mirror decoration.                                                   | -                                                                           | -                | Void Rifts        |
| Cloud Garden Seeds      | Creature Egg    | Common      | Egg for Cloud Sprite.                                                         | -                                                                           | -                | Cloud Gardens     |
| Storm Egg               | Creature Egg    | Uncommon    | Egg for Storm Drake.                                                          | -                                                                           | -                | Storm Peaks       |
| Void Core               | Creature Egg    | Rare        | Egg for Void Leviathan.                                                      | -                                                                           | -                | Void Rifts        |
| Crystal Shard           | Component       | Common      | Used in crafting tools and decorations.                                       | -                                                                           | -                | Crystal Canyons   |
| Aether Core             | Component       | Epic        | Rare component for advanced crafting.                                         | -                                                                           | -                | All Biomes        |

---

## 2. Creature Database

### **Creature Stats**: 
- **Health**: Base health value
- **Attack**: Damage dealt in battles
- **Defense**: Reduction in damage taken
- **Speed**: Movement speed
- **Harvest Bonus**: Passive bonus to player's harvest speed
- **XP Bonus**: Bonus XP granted when player harvests near creature

### **Creature Abilities**: 
- **Passive**: Automatic effects while in proximity
- **Active**: Abilities used in battles or special situations

### **Creature Database**

| **Name**               | **Rarity**   | **Biome**          | **Health** | **Attack** | **Defense** | **Speed** | **Harvest Bonus** | **XP Bonus** | **Passive Ability**                     | **Active Ability**                     | **Breeding Rules**                     |
|------------------------|--------------|-------------------|-----------|-----------|----------|--------|------------------|------------|----------------------------------------|----------------------------------------|----------------------------------------|
| Cloud Sprite          | Common      | Cloud Gardens     | 50        | 10        | 5        | 3.0    | +5%                               | +2%        | Floating: Hovers above ground.         | Wind Dash: Dash forward.               | Breeds with Cloud Sprite + Cloud Flower. |
| Storm Drake           | Uncommon    | Storm Peaks       | 120       | 25        | 15       | 2.5    | +10%                              | +5%        | Storm Call: Summons lightning.          | Thunder Strike: Lightning attack.       | Breeds with Storm Drake + Crystal Shard. |
| Void Leviathan         | Rare        | Void Rifts        | 200       | 40        | 30       | 2.0    | +15%                              | +10%       | Void Phase: Becomes intangible.        | Void Suck: Pulls enemy closer.        | Breeds with Void Leviathan + Void Essence. |
| Crystal Guardian       | Epic        | Crystal Canyons    | 300       | 50        | 40       | +20%                              | +15%       | Crystal Barrier: Reflects damage.      | Shatter: Explosive crystal attack.     | Breeds with Crystal Guardian + Storm Crystal. |
| Ancient Wyrm           | Legendary   | Ancient Ruins     | 500       | 70        | 60       | +25%                              | +20%       | Time Warp: Slows time around self.     | Chrono Blast: Time-based attack.       | Breeds with Ancient Wyrm + Ancient Relic. |
| Mythril Golem          | Mythic      | All Biomes        | 800       | 100       | 100      | +30%                              | +30%       | Mythril Armor: Immune to critical hits. | Mythril Smash: Heavy melee attack.     | Breeds with Mythril Golem + Mythril Dust. |
| Sky Fox                | Common      | Cloud Gardens     | 40        | 15        | 8        | +3%                               | +1%        | Swift: Faster movement.                | Quick Strike: Fast melee attack.       | Breeds with Sky Fox + Cloud Garden Seeds. |
| Tempest Hawk           | Uncommon    | Storm Peaks       | 80        | 20        | 10       | +8%                               | +3%        | Wind Rider: Glides through air.        | Storm Talon: Lightning melee attack.   | Breeds with Tempest Hawk + Storm Egg.   |
| Void Wisp              | Rare        | Void Rifts        | 100       | 25        | 12       | +12%                              | +8%        | Invisibility: Becomes invisible.        | Void Burst: Explosive attack.          | Breeds with Void Wisp + Void Core.      |
| Crystal Faerie          | Epic        | Crystal Canyons    | 150       | 30        | 20       | +18%                              | +12%       | Crystal Aura: Grants +5% harvest bonus to nearby players. | Crystal Beam: Ranged attack. | Breeds with Crystal Faerie + Crystal Fragment. |
| Ancient Stag           | Legendary   | Ancient Ruins     | 250       | 40        | 30       | +22%                              | +18%       | Time Step: Teleports short distance.    | Ancient Horn: Heavy melee attack.      | Breeds with Ancient Stag + Ancient Relic. |
| Mythril Imp             | Mythic      | All Biomes        | 120       | 35        | 25       | +28%                              | +25%       | Mythril Wings: Faster flight.          | Mythril Claw: Piercing attack.         | Breeds with Mythril Imp + Mythril Dust.  |

---

## 3. Quest Design

### **Quest Types**:
- **Fetch Quests**: Retrieve an item from a location
- **Collect Quests**: Gather a specific resource or creature egg
- **Deliver Quests**: Bring an item to a specific NPC
- **Explore Quests**: Visit a specific island or location
- **Boss Quests**: Defeat a boss creature

### **Quest Database**

| **Quest ID** | **Name**                     | **Type**       | **Description**                                                                 | **Reward**                                                                 | **Location**          | **Difficulty** |
|--------------|------------------------------|----------------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------|----------------------|----------------|
| QST001       | First Harvest               | Collect        | Harvest 10 Aether Shards.                                                 | 50 XP, Basic Net (Uncommon)                                           | Cloud Gardens        | Easy            |
| QST002       | Storm Caller                | Explore        | Visit Storm Peaks.                                                          | 100 XP, Storm Shield (Consumable)                                        | Storm Peaks          | Easy            |
| QST003       | Void Wanderer               | Explore        | Visit Void Rifts.                                                           | 150 XP, Void Core (Creature Egg)                                         | Void Rifts           | Medium          |
| QST004       | Crystal Collector            | Collect        | Collect 5 Crystal Fragments.                                                | 200 XP, Crystal Orb (Decoration)                                         | Crystal Canyons      | Medium          |
| QST005       | Ancient Relic Hunter        | Fetch          | Retrieve Ancient Relic from Ancient Ruins.                                    | 300 XP, Ancient Amulet (Consumable)                                      | Ancient Ruins        | Hard            |
| QST006       | Tame a Cloud Sprite          | Deliver        | Deliver a Cloud Sprite to the Creature Keeper.                              | 250 XP, Cloud Garden Seeds (Creature Egg)                                | Cloud Gardens        | Easy            |
| QST007       | Storm Drake Tamer           | Deliver        | Deliver a Storm Drake to the Creature Keeper.                                | 350 XP, Storm Egg (Creature Egg)                                          | Storm Peaks          | Medium          |
| QST008       | Void Leviathan Hunter       | Boss           | Defeat Void Leviathan in Void Rifts.                                         | 500 XP, Void Essence (Resource)                                          | Void Rifts           | Hard            |
| QST009       | Crystal Guardian Defeat     | Boss           | Defeat Crystal Guardian in Crystal Canyons.                                   | 600 XP, Crystal Shard (Component)                                         | Crystal Canyons      | Hard            |
| QST010       | Ancient Wyrm Slayer         | Boss           | Defeat Ancient Wyrm in Ancient Ruins.                                       | 800 XP, Ancient Relic (Resource)                                          | Ancient Ruins        | Epic            |
| QST011       | Mythril Dust Collector      | Collect        | Collect 3 Mythril Dust.                                                     | 400 XP, Mythril Golem (Creature Egg)                                     | All Biomes          | Rare            |
| QST012       | Sky Base Expansion          | Deliver        | Deliver 10 Aether Shards to the Architect.                                  | 300 XP, Sky Base Expansion Blueprint                                     | Cloud Gardens        | Easy            |
| QST013       | Harvesting Mastery          | Collect        | Harvest 100 Aether Shards in one session.                                   | 500 XP, Chrono Collector (Tool)                                          | All Biomes          | Hard            |
| QST014       | Creature Breeding           | Deliver        | Deliver 2 Cloud Sprite eggs to the Breeder.                                | 400 XP, Breeding Potion (Consumable)                                     | Cloud Gardens        | Medium          |
| QST015       | Trading Empire              | Deliver        | Sell 50 Aether Shards on the marketplace.                                    | 600 XP, Trading Guild Membership                                         | All Biomes          | Medium          |
| QST016       | Event Survivor              | Explore        | Survive the Aether Storm event.                                             | 1000 XP, Storm Shield (Consumable)                                       | All Biomes          | Epic            |
| QST017       | Rift Convergence            | Explore        | Visit the special dimension during Rift Convergence.                        | 1200 XP, Void Core (Creature Egg)                                         | Void Rifts           | Epic            |
| QST018       | Mythril Collector           | Collect        | Collect 10 Mythril Dust.                                                   | 1000 XP, Mythril Imp (Creature Egg)                                       | All Biomes          | Rare            |
| QST019       | Legendary Creature Tamer    | Deliver        | Deliver a Mythril Golem to the Creature Keeper.                            | 1500 XP, Mythril Dust (Resource)                                          | All Biomes          | Legendary       |
| QST020       | Sky Base Architect          | Deliver        | Deliver 50 Crystal Fragments to the Architect.                              | 1200 XP, Sky Base Upgrade Blueprint                                       | Crystal Canyons      | Epic            |

---

## 4. Skill Tree Design

### **Skill Trees**:
1. **Harvesting**: Improves harvesting efficiency and tool performance
2. **Exploration**: Enhances exploration speed and discovery
3. **Trading**: Boosts trading profits and marketplace influence
4. **Engineering**: Increases crafting efficiency and tool durability
5. **Creature Care**: Enhances creature taming, breeding, and battle performance

### **Skill Tree Database**

#### **Harvesting Tree**

| **Level** | **Skill Name**               | **Effect**                                                                                     | **Prerequisite** |
|-----------|------------------------------|-------------------------------------------------------------------------------------------------|------------------|
| 1         | **Basic Harvesting**         | +5% harvest speed.                                                                             | -                |
| 2         | **Efficient Siphon**          | +10% energy efficiency with Energy Siphon.                                                     | Basic Harvesting |
| 3         | **Combo Mastery**            | +20% combo multiplier (x3 after 3 harvests).                                                     | Efficient Siphon |
| 4         | **Critical Strike**          | +15% critical harvest chance.                                                                   | Combo Mastery    |
| 5         | **Quantum Boost**            | +25% harvest speed with Quantum Harvester.                                                     | Critical Strike  |

#### **Exploration Tree**

| **Level** | **Skill Name**               | **Effect**                                                                                     | **Prerequisite** |
|-----------|------------------------------|-------------------------------------------------------------------------------------------------|------------------|
| 1         | **Swift Traveler**            | +10% fast-travel speed.                                                                         | -                |
| 2         | **Island Mastery**           | Unlocks one additional island per level.                                                         | Swift Traveler  |
| 3         | **Night Vision**             | Can see in the dark.                                                                           | Island Mastery   |
| 4         | **Resource Scout**           | +20% chance to find hidden resource nodes.                                                       | Night Vision    |
| 5         | **Biome Adaptation**         | +10% harvest bonus in all biomes.                                                                | Resource Scout   |

#### **Trading Tree**

| **Level** | **Skill Name**               | **Effect**                                                                                     | **Prerequisite** |
|-----------|------------------------------|-------------------------------------------------------------------------------------------------|------------------|
| 1         | **Marketplace Savvy**        | +5% profit margin on sales.                                                                     | -                |
| 2         | **Supply Chain**             | +10% chance to find rare items in marketplace.                                                   | Marketplace Savvy |
| 3         | **Negotiator**               | +15% discount when buying from marketplace.                                                       | Supply Chain    |
| 4         | **Trading Guild**            | +20% XP when trading with guild members.                                                          | Negotiator       |
| 5         | **Economy Dominance**        | +25% marketplace listing duration.                                                              | Trading Guild    |

#### **Engineering Tree**

| **Level** | **Skill Name**               | **Effect**                                                                                     | **Prerequisite** |
|-----------|------------------------------|-------------------------------------------------------------------------------------------------|------------------|
| 1         | **Tool Upgrade**             | +10% durability for all tools.                                                                 | -                |
| 2         | **Crafting Efficiency**      | +15% XP when crafting.                                                                           | Tool Upgrade     |
| 3         | **Advanced Components**      | Can craft Epic items with Rare components.                                                       | Crafting Efficiency |
| 4         | **Automation**               | +20% faster crafting speed.                                                                       | Advanced Components |
| 5         | **Legendary Crafting**       | Can craft Legendary items with Epic components.                                                  | Automation       |

#### **Creature Care Tree**

| **Level** | **Skill Name**               | **Effect**                                                                                     | **Prerequisite** |
|-----------|------------------------------|-------------------------------------------------------------------------------------------------|------------------|
| 1         | **Taming Expert**            | +10% success rate when taming creatures.                                                         | -                |
| 2         | **Breeding Mastery**         | +20% success rate when breeding creatures.                                                        | Taming Expert    |
| 3         | **Creature Bond**            | +15% XP bonus when creatures assist in harvesting.                                               | Breeding Mastery |
| 4         | **Battle Training**          | +25% creature attack and defense in battles.                                                      | Creature Bond    |
| 5         | **Legendary Companion**      | +30% harvest bonus with Mythril Golem.                                                           | Battle Training  |

---

## 5. Economy Balance

### **Pricing System**:
- **Base Prices**: Set for common items
- **Dynamic Pricing**: Supply and demand affect prices
- **Marketplace Fees**: 5% fee on all sales

### **Drop Rates**:
- **Common**: 50-70% chance
- **Uncommon**: 20-30% chance
- **Rare**: 5-15% chance
- **Epic**: 1-5% chance
- **Legendary**: 0.1-1% chance
- **Mythic**: 0.01-0.1% chance

### **XP Curve**:
- **Early Game**: Linear XP gain for quick progression
- **Mid Game**: Diminishing returns to encourage exploration
- **Late Game**: Prestige system for endgame content

### **Prestige Bonuses**:
- **Prestige 1**: +10% XP gain, +5% harvest bonus
- **Prestige 2**: +20% XP gain, +10% harvest bonus, unlocks Mythril Dust drops
- **Prestige 3**: +30% XP gain, +15% harvest bonus, unlocks Mythril Golem breeding

### **Economy Balance Notes**:
- **Anti-Grind**: Diminishing returns after 2 hours of continuous play
- **New Player Protection**: Reduced drop rates in PvP zones
- **Cosmetic-Only P2W**: Mythril Dust and other rare items are cosmetic-only

---

## 6. Event Calendar

### **Weekly Events**:
- **Aether Storm**: All nodes boosted by +50%, rare spawns, +100 XP for harvesting during event
- **Harvesting Festival**: +30% harvest speed, special decorations available
- **Creature Carnival**: +20% taming success rate, rare creature eggs available

### **Monthly Events**:
- **Rift Convergence**: Special dimension opens with unique creatures and resources
- **Ancient Ruins Festival**: Ancient Relics and Mythril Dust available for purchase
- **Sky Base Expo**: Special blueprints and decorations available

### **Seasonal Events**:
- **Spring**: New creature eggs, pastel decorations, +10% XP for harvesting
- **Summer**: Beach-themed decorations, +20% harvest speed during day
- **Autumn**: Harvesting bonuses for specific resources, new creature types
- **Winter**: Snow-themed decorations, +15% XP for harvesting at night

### **Real-World Holiday Events**:
- **Christmas**: Snowflake decorations, Mythril Dust giveaways
- **Halloween**: Spooky decorations, rare creature eggs
- **Valentine’s Day**: Love-themed decorations, special creature bonds

---

## 7. Achievement List

### **Achievement Categories**:
- **Harvesting**: Focused on resource collection
- **Exploration**: Focused on discovering new areas
- **Creature Care**: Focused on taming and breeding
- **Trading**: Focused on marketplace activity
- **Base Building**: Focused on sky base expansion
- **Events**: Focused on participating in events

### **Achievement Database**

| **ID** | **Name**                     | **Category**      | **Criteria**                                                                                     | **Reward**                                                                 |
|-------|------------------------------|------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| ACH001 | First Harvest               | Harvesting      | Harvest 10 Aether Shards.                                                               | 100 XP, Basic Net (Uncommon)                                           |
| ACH002 | Storm Caller                | Exploration      | Visit Storm Peaks.                                                                  | 200 XP, Storm Shield (Consumable)                                        |
| ACH003 | Void Wanderer               | Exploration      | Visit Void Rifts.                                                                     | 300 XP, Void Core (Creature Egg)                                         |
| ACH004 | Crystal Collector            | Harvesting      | Collect 50 Crystal Fragments.                                                           | 400 XP, Crystal Orb (Decoration)                                         |
| ACH005 | Ancient Relic Hunter        | Exploration      | Retrieve Ancient Relic from Ancient Ruins.                                          | 500 XP, Ancient Amulet (Consumable)                                      |
| ACH006 | Tame a Cloud Sprite          | Creature Care    | Tame a Cloud Sprite.                                                                | 250 XP, Cloud Garden Seeds (Creature Egg)                                |
| ACH007 | Storm Drake Tamer           | Creature Care    | Tame a Storm Drake.                                                                  | 350 XP, Storm Egg (Creature Egg)                                          |
| ACH008 | Void Leviathan Hunter       | Harvesting      | Defeat Void Leviathan in Void Rifts.                                                 | 600 XP, Void Essence (Resource)                                          |
| ACH009 | Crystal Guardian Defeat     | Harvesting      | Defeat Crystal Guardian in Crystal Canyons.                                           | 700 XP, Crystal Shard (Component)                                         |
| ACH010 | Ancient Wyrm Slayer         | Harvesting      | Defeat Ancient Wyrm in Ancient Ruins.                                               | 800 XP, Ancient Relic (Resource)                                          |
| ACH011 | Mythril Dust Collector      | Harvesting      | Collect 10 Mythril Dust.                                                               | 900 XP, Mythril Golem (Creature Egg)                                     |
| ACH012 | Sky Base Expansion          | Base Building   | Expand your sky base to level 3.                                                      | 500 XP, Sky Base Blueprint (Component)                                   |
| ACH013 | Harvesting Mastery          | Harvesting      | Harvest 1000 Aether Shards in one session.                                             | 1000 XP, Chrono Collector (Tool)                                          |
| ACH014 | Creature Breeding           | Creature Care    | Breed 5 creatures.                                                                     | 600 XP, Breeding Potion (Consumable)                                     |
| ACH015 | Trading Empire              | Trading         | Sell 500 Aether Shards on the marketplace.                                           | 700 XP, Trading Guild Membership                                         |
| ACH016 | Event Survivor              | Events          | Survive the Aether Storm event.                                                     | 1000 XP, Storm Shield (Consumable)                                       |
| ACH017 | Rift Convergence            | Exploration      | Visit the special dimension during Rift Convergence.                                      | 1200 XP, Void Core (Creature Egg)                                         |
| ACH018 | Mythril Collector           | Harvesting      | Collect 50 Mythril Dust.                                                              | 1500 XP, Mythril Imp (Creature Egg)                                       |
| ACH019 | Legendary Creature Tamer    | Creature Care    | Tame a Mythril Golem.                                                                  | 2000 XP, Mythril Dust (Resource)                                          |
| ACH020 | Sky Base Architect          | Base Building   | Complete a Sky Base Expansion Blueprint.                                             | 1200 XP, Sky Base Upgrade Blueprint                                       |
| ACH021 | First Prestige              | Progression     | Prestige once.                                                                         | 5000 XP, Prestige Token (Consumable)                                     |
| ACH022 | Sky Explorer                | Exploration      | Visit all 5 biomes.                                                                  | 1500 XP, Explorer’s Map (Decoration)                                     |
| ACH023 | Harvesting Champion         | Harvesting      | Harvest 10,000 Aether Shards in one session.                                           | 2000 XP, Harvesting Champion Badge (Decoration)                           |
| ACH024 | Creature Enthusiast         | Creature Care    | Collect all 12 creature types.                                                          | 2500 XP, Creature Enthusiast Badge (Decoration)                           |
| ACH025 | Trading Mogul                | Trading         | Sell 10,000 Aether Shards on the marketplace.                                          | 3000 XP, Trading Mogul Badge (Decoration)                                 |
| ACH026 | Sky Base Titan              | Base Building   | Expand your sky base to level 5.                                                      | 3000 XP, Sky Base Titan Badge (Decoration)                               |
| ACH027 | Event Champion              | Events          | Complete all weekly events in a month.                                                 | 5000 XP, Event Champion Badge (Decoration)                               |
| ACH028 | Mythril Master              | Harvesting      | Collect 100 Mythril Dust.                                                              | 5000 XP, Mythril Master Badge (Decoration)                               |
| ACH029 | Legendary Collector          | Harvesting      | Collect all 6 resource rarities.                                                      | 4000 XP, Legendary Collector Badge (Decoration)                           |
| ACH030 | Sky Pioneer                 | Exploration      | Discover all hidden resource nodes in the game.                                         | 6000 XP, Sky Pioneer Badge (Decoration)                                 |
| ACH031 | Ultimate Tamer              | Creature Care    | Tame all 12 creature types.                                                           | 7000 XP, Ultimate Tamer Badge (Decoration)                               |
| ACH032 | Trading Legend              | Trading         | Sell 50,000 Aether Shards on the marketplace.                                           | 8000 XP, Trading Legend Badge (Decoration)                               |
| ACH033 | Sky Architect               | Base Building   | Complete all Sky Base Expansion Blueprints.                                           | 7000 XP, Sky Architect Badge (Decoration)                               |
| ACH034 | Event Master                | Events          | Complete all seasonal events in a year.                                                 | 10000 XP, Event Master Badge (Decoration)                                |
| ACH035 | Mythril Connoisseur         | Harvesting      | Collect 500 Mythril Dust.                                                              | 10000 XP, Mythril Connoisseur Badge (Decoration)                          |
| ACH036 | Sky Conqueror               | Exploration      | Visit all islands in the game.                                                          | 5000 XP, Sky Conqueror Badge (Decoration)                               |
| ACH037 | Ultimate Harvesting          | Harvesting      | Harvest 100,000 Aether Shards in one session.                                            | 15000 XP, Ultimate Harvesting Badge (Decoration)                          |
| ACH038 | Sky Guardian                | Base Building   | Defend your sky base against 10 invasions.                                             | 10000 XP, Sky Guardian Badge (Decoration)                               |
| ACH039 | Mythril Sage                | Harvesting      | Prestige 3 times.                                                                     | 15000 XP, Mythril Sage Badge (Decoration)                                 |
| ACH040 | Sky Legend                  | Progression     | Complete all achievements.                                                              | 20000 XP, Sky Legend Badge (Decoration)                                 |

---

## Technical Implementation Notes

### **Data Structures**:
- **Items**: JSON table with name, type, rarity, value, description, stats, drop chance, biome
- **Creatures**: JSON table with name, rarity, biome, stats, abilities, breeding rules
- **Quests**: JSON table with ID, name, type, description, reward, location, difficulty
- **Skills**: JSON table with tree, level, name, effect, prerequisite
- **Achievements**: JSON table with ID, name, category, criteria, reward

### **Scripting**:
- **Inventory System**: Client-side prediction with server validation
- **Harvesting System**: Server-authoritative node state and respawn timers
- **Creature System**: Taming, breeding, and battle mechanics
- **Event System**: Scheduled events with participant tracking
- **Trading System**: Marketplace listings with dynamic pricing

### **UI/UX**:
- **HUD**: Health, energy, level, XP bar, quick-bar, minimap
- **Inventory Grid**: Drag-and-drop interface
- **Skill Tree Visualizer**: Interactive tree with level-up animations
- **Quest Log**: Auto-navigation with objective tracking

### **Audio/Visual**:
- **Ambient Music**: Per biome
- **Sound Effects**: Harvesting, creature interactions, events
- **Particle Effects**: Harvesting, upgrades, events

---

## Balance Notes

- **Anti-Grind**: Diminishing returns after 2 hours of continuous play
- **New Player Protection**: Reduced drop rates in PvP zones
- **Cosmetic-Only P2W**: Mythril Dust and other rare items are cosmetic-only
- **Dynamic Economy**: Supply and demand affect prices

---

## Conclusion

Aether Harvester Simulator offers a rich, immersive experience with deep progression systems, a player-driven economy, and a variety of content to explore. The game encourages creativity, strategy, and community interaction through its quests, creature care, and base-building systems.

---