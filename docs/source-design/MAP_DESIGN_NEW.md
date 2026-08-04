# Aether Harvester Simulator — World Map Design (Revamp)

> **Document:** `MAP_DESIGN_NEW.md`
> **Project:** Aether Harvester Simulator
> **Author:** Agent-Company-X (worker-c — map/world)
> **Status:** Final — ready for implementation in Roblox Studio
>
> This document fully supersedes the earlier `MAP_DESIGN.md`. It reimagines the world as a **four-layer vertical archipelago** rather than a flat cluster of floating islands, satisfying the six required biome pillars — floating islands (aether), crystal caves, enchanted forests, volcanic zones, ocean/water, and sky realms — while preserving every biome, resource, and creature already defined in `GAME_SPEC.md`.

---

## 1. World Premise & Vision

The world of **Aethros** is a sky-bound super-continent suspended in an endless cerulean void. It is not a single flat plane but a **stratified realm** composed of four distinct vertical layers, each with its own physics, lighting, and ecological niche. Players begin in the **Celestial Nexus** (the living hub) and spiral outward and downward through progressively deeper, more dangerous, and more lucrative strata of the world — literally and narratively descending into mystery.

The revamp replaces the old baseplate concept with a **hand-crafted constellation of 11 explorable zones** plus 6 minor sub-zones, each grounded in procedural generation rules defined in `TERRAIN_SPEC.luau`. Every zone answers the question *"what life does the aether nurture here?"* — from the gentle drifts of Cloud Gardens to the crushing pressure of the Abyssal Trench.

### World Scale
| Metric | Value |
|---|---|
| World diameter | ~3 000 studs (centred on origin) |
| Vertical span | Y = –400 (Abyssal floor) → Y = +600 (Astral Heights) |
| Streaming chunk size | 128 studs |
| Target visible draw distance | 1 000–1 200 studs |

---

## 2. Vertical Layer System

The world is partitioned vertically so that **height becomes biome**. A single (x, z) column can host up to four stacked environments accessed by ascending/descending.

```
        ┌────────────────────────────────────────── Y = 600 ────── ASTRAL HEIGHTS (Sky Realm)
        │  Astral Observatory  ·  Celestial Nexus spire
        │
        ├────────────────────────────────────────── Y = 349
        │  ── floating archipelago ceiling (storm peaks, crystal spires)
        │
        ├────────────────────────────────────────── Y =  39  FLOATING ARCHIPELAGO
        │  Cloud Gardens · Storm Peaks · Verdant Canopy · Ashen Maw
        │  Crystal Canyons · Ancient Ruins · Void Rifts
        │
        ├────────────────────────────────────────── Y =  25  AETHERIAL SEA (cloud-sea surface)
        │  Luminous Reef (ocean trench rim)
        │
        ├────────────────────────────────────────── Y =   0  WATER LEVEL
        │
        ├────────────────────────────────────────── Y = –20  ABYSSAL DEPTHS
        │  Abyssal Trench (sunken city, pressure zones)
        │
        └────────────────────────────────────────── Y = –400  ABYSSAL FLOOR
```

| Layer | Y-range | Feel | Access |
|---|---|---|---|
| **Astral Heights** | 350–600 | Thin air, starlight, wind howl | Ascend from Celestial Nexus via the Starward Spire elevator / wind tunnels |
| **Floating Archipelago** | 40–349 | Habitable sky-lands, bridges, aether wind | Default player layer — walk, bridge, teleport between islands |
| **Aetherial Sea** | –20–39 | Misty cloud-sea, swim/dive, water physics | Descend ladders/ducts from island undersides or dedicated diving platforms |
| **Abyssal Depths** | –400––20 | Crushing dark, bioluminescence, void pressure | Submarine / pressure-suit descent through Luminous Reef sinkholes |

---

## 3. World Layout (Constellation Map)

The floating islands form a **seven-pointed constellation** around the central hub. Below them, the ocean trench chain drops straight down the world-axis. Travel is non-Euclidean only in the sense that the Astral Observatory sits *above* the Nexus and the Abyss sits *below* the reef — horizontal distance is otherwise Euclidean.

```
                          N
                          ▲
                          │
[Void Rifts]      [Ancient Ruins]      [Storm Peaks]
     (-620,480)        (-400,-350)       (-550,0)            ← Astral Heights / Sky (y≈350-500)
        \              |  /              /
         \             | /              /
          \            |/             /
  [Astral Observatory  [Celestial     [Cloud
   (0,650)  y≈500]     Nexus (0,0)]  Gardens (550,0)]   ← Floating (y≈80-250)
                       y≈320          y≈120
          /            |\              \
         /             | \              \
        /              |  \              \
[Void Rifts]...   [Crystal Canyons]  [Storm Peaks]
                   (0,-350) y≈170     (-550,0)
                          │
                          │ descend →
                          ▼
                  [Verdant Canopy (300,-200) y≈80]  ← Enchanted Forest
                          │
                          ▼
                  [Luminous Reef (0,-650) y≈0 ]  ← Ocean / Water
                          │
                          ▼
                  [Abyssal Trench (0,-1300) y≈-250] ← Abyss
```

> The trench chain (Reef → Trench) hangs directly beneath the central axis. The Astral Observatory crowns the axis above the Nexus. The six outer islands fan out in a rough hexagon of radius ~550–650 studs.

### Zone quick-reference table

| ID | Zone | Biome | Layer | Difficulty | Float Y | Primary Resources | Key Creatures |
|---|---|---|---|---|---|---|---|
| nexus | Celestial Nexus | Sky Realm | Astral | 1 (tutorial) | 320 | Aether Shard, Aether Core | Sky Whale (boss NPC) |
| astral | Astral Observatory | Astral / Aether | Astral | 5 (endgame) | 500 | Mythril Dust, Star Fragment | Astral Phoenix, Void Drake |
| clouds | Cloud Gardens | Aether / Forest | Floating | 1 | 120 | Aether Shard, Cloud Garden Seeds | Cloud Sprite, Sky Fox |
| storm | Storm Peaks | Storm / Highland | Floating | 2 | 190 | Storm Crystal | Storm Drake, Tempest Hawk |
| forest | Verdant Canopy | Enchanted Forest | Floating | 1 | 80 | Verdant Sap, Lush Vines, Moonbell | Forest Nymph, Thornback, Glimmerfox |
| volcano | Ashen Maw | Volcanic | Floating | 3 | 110 | Ember Core, Obsidian Shard, Sulfur | Magma Salamander, Ash Drake |
| crystal | Crystal Canyons | Crystal / Cave | Floating | 2 | 170 | Crystal Fragment, Crystal Shard, Prismatic Cluster | Crystal Guardian, Crystal Faerie |
| ruins | Ancient Ruins | Ruins / Temporal | Floating | 3 | 90 | Ancient Relic, Temporal Dust, Sunmetal | Ancient Wyrm, Ancient Stag |
| void | Void Rifts | Void / Rift | Floating | 4 | 150 | Void Essence, Void Core, Null Shard | Void Leviathan, Void Wisp, Rift Stalker |
| reef | Luminous Reef | Ocean / Reef | Aetherial Sea | 2 | 0 | Prism Coral, Deep Pearl, Coral Bloom | Coral Serpent, Deep Walker, Pearlback |
| abyss | Abyssal Trench | Abyss / Deep | Abyssal | 5 | –250 | Void Pearl, Abyssal Core, Deep Core | Abyssal Wraith, Deep Terror, Umbral Eel |

### Difficulty progression
Difficulty is a **1–5 tier** reflecting harvest risk vs. reward (resource rarity, creature aggression, environmental hazard), **not** a gating lock — players may free-roam any unlocked island. Tiers map to the skill-tree gating in `GAME_SPEC.md` (Exploration tree unlocks deeper islands at levels 2/3/4/5).

| Tier | Label | Meaning |
|---|---|---|
| 1 | Novice | No hazards, Common resources, passive creatures |
| 2 | Adept | Mild weather/hazards, Uncommon + rare nodes |
| 3 | Veteran | Environmental damage, aggressive creatures, Epic nodes |
| 4 | Elite | Constant hazards, Rare + Elite creatures |
| 5 | Mythic | Lethal environment + Mythic/Legendary creatures, prestige-gated |

---

## 4. Zones & Regions (Detailed)

Each major zone below carries the **required attributes**: name, biome, difficulty, primary resources, unique creatures, and spawn points. Minor sub-zones are listed under their parent where relevant.

---

### 4.1 Celestial Nexus — Sky Realm Hub
- **Biome type:** Sky Realm (hybrid: crystalline spire + floating gardens)
- **Difficulty:** 1 (safe zone / tutorial)
- **Primary resources:** Aether Shard (all islands), Aether Core (crafted), Mythril Dust (rare event spawns)
- **Unique creatures:** Sky Whale (non-hostile NPC boss), Aetherial Drifter (ambient), Zephyric Sprite (harmless)
- **Spawn points:** Nexus Plaza (centre), Observatory Balcony, Guild Terrace, Starward Spire base
- **Description:** The living heart of Aethros — a gravity-defying citadel of white-gold aetherstone threaded with floating gardens and a central spire that reaches into Astral Heights. Houses the **Marketplace**, **Guild Hall**, **Bank**, **Telescope** (event predictor), and **Fast-Travel Beacons** to every unlocked zone. A gentle *aether updraft* lets players glide down to any outer island. The **Sky Guardian** (world boss arena) appears here only during seasonal invasions.

---

### 4.2 Astral Observatory — Astral Heights (Sky Realm)
- **Biome type:** Astral / Aether (high-altitude void)
- **Difficulty:** 5 (endgame / prestige-gated)
- **Primary resources:** Mythril Dust (All Biomes), Star Fragment (new — Epic), Astral Shard (new — Rare)
- **Unique creatures:** Astral Phoenix (Legendary), Void Drake (Mythic), Cosmic Moth (Rare)
- **Spawn points:** Observatory Deck, Constellation Ring, Stellar Cradle, Apex Wind-Tunnel
- **Description:** A lone tower of black-brittle star-iron bolted onto the world-axis at Y≈500. Thin atmosphere (players need a **Breath of Aether** buff). Gravity is reduced. The **Constellation Ring** — a zero-G arena — hosts the Astral Phoenix. Accessible only by ascending the Starward Spire from the Nexus. Weather is always "Stellar Drift" (meteor showers, aurora curtains).

---

### 4.3 Cloud Gardens — Aether / Forest (Floating)
- **Biome type:** Floating islands + aether theme (light forest)
- **Difficulty:** 1
- **Primary resources:** Aether Shard, Cloud Garden Seeds (Creature Egg), Luminous Dew (new — Rare)
- **Unique creatures:** Cloud Sprite (Common), Sky Fox (Common), Glimmerwing (Uncommon — new)
- **Spawn points:** Garden Terrace, Floating Grove, Misty Meadow, Drifting Pier
- **Description:** The starter biome — a cluster of small, marshmallow-soft islands carpeted in **sky-lily** pads and **wispleaf** shrubs that glow faintly. Light gravity lets players **bounce** between islands on aether-jumps. Resource nodes are **Aether Shards** (pulsating orbs) that respawn quickly. The **Breeding Garden** pen sits here for early creature care. Perfect for introducing new-player parkour and glide mechanics.

---

### 4.4 Storm Peaks — Storm / Highland (Floating)
- **Biome type:** Storm-wracked high-altitude peaks
- **Difficulty:** 2
- **Primary resources:** Storm Crystal (Uncommon), Lightning Rod Core (new — Rare), Thunder Moss (consumable forage)
- **Unique creatures:** Storm Drake (Uncommon), Tempest Hawk (Uncommon), Stormwrought Boar (Rare — new)
- **Spawn points:** Thunder Plateau, Lightning Ridge, Peak Sanctum, Gale Saddle
- **Description:** Jagged quartz-and-steel peaks perpetually wreathed in rolling thunderheads. **Lightning rods** channel strikes that players can harvest with the right tool. Wind tunnels launch players across gaps. Periodic **Aether Storms** (see §6) super-charge nodes here. Hazards: static discharge (drains energy), knockback gusts, exposed cliff edges.

---

### 4.5 Verdant Canopy — Enchanted Forest (Floating)
- **Biome type:** Enchanted forest (lush, bioluminescent canopy)
- **Difficulty:** 1 (low combat) → 3 (in night/void-touched events)
- **Primary resources:** Verdant Sap (new — Uncommon, crafting), Lush Vines (new — Common, building), Moonbell (new — Rare, consumable)
- **Unique creatures:** Forest Nymph (Rare — new), Thornback (Uncommon — new, territorial), Glimmerfox (Uncommon — new, stealthed)
- **Spawn points:** Canopy Village, Root Warren, Moonbell Glade, Thornheart Clearing
- **Description:** A single mega-tree whose canopy spreads across ~105 studs, its roots dangling into the cloud-sea below. **Bioluminescent flora** light the forest floor at night. Day/night swings the mood: peaceful glades by day; **shadow-wrought predators** emerge at night. Hidden **Root Warren** cave network links to Crystal Canyons underground.

---

### 4.6 Ashen Maw — Volcanic (Floating)
- **Biome type:** Active volcanic / scorched highlands
- **Difficulty:** 3
- **Primary resources:** Ember Core (new — Epic, furnace fuel), Obsidian Shard (new — Uncommon), Sulfur (common forage)
- **Unique creatures:** Magma Salamander (Rare — new), Ash Drake (Uncommon — new), Pyre Wisp (Common — ambient)
- **Spawn points:** Caldera Rim, Ember Path, Sulfur Fields, Forge Basin
- **Description:** A basalt-and-obsidian island cracked by lava flows and **eruption vents**. Ground glows red-hot in places. **Thermal updrafts** let players ride convection columns to high perches. Hazards: lava pools (insta-down), ash storms (vision debuff), periodic eruptions. The **Ashen Forge** here is the only place to craft **Sunmetal**-tier gear.

---

### 4.7 Crystal Canyons — Crystal / Cave (Floating)
- **Biome type:** Towering crystalline gorge + subterranean cave network
- **Difficulty:** 2 (surface) → 4 (deep caves)
- **Primary resources:** Crystal Fragment (Epic), Crystal Shard (Common component), Prismatic Cluster (new — Rare), Deep Crystal (cave-only Rare)
- **Unique creatures:** Crystal Guardian (Epic — boss), Crystal Faerie (Epic), Crystalmaw (Rare cave predator — new), Prism Spider (Uncommon cave)
- **Spawn points:** Canyon Rim, Crystal Bridge, Echoing Vault, Deep Cavern Mouth, Glimmervein Chamber
- **Description & sub-zones:**
  - **Surface (y≈170):** Sheer crystal cliffs that refract light into rainbows. Bridges of solid light span the gorge.
  - **Crystal Caves (y≈40–120):** A winding cave system carved from living crystal. **Crystal resonance** lets players *tune* nodes to change their resource type. Home to the **Crystal Guardian** boss and **Prism Spider** packs.
  - **Prism Chamber (secret):** A room of pure light that only renders when the player holds a **Prismatic Focus** — the rarest node in the game.
  - Connects via tunnels to the **Verdant Canopy Root Warren**.

---

### 4.8 Ancient Ruins — Ruins / Temporal (Floating)
- **Biome type:** Floating ancient architecture, temporal anomaly
- **Difficulty:** 3
- **Primary resources:** Ancient Relic (Legendary), Temporal Dust (new — Epic, time crafting), Sunmetal Ingot (new — Rare)
- **Unique creatures:** Ancient Wyrm (Legendary — boss), Ancient Stag (Legendary), Time Wraith (Rare — hostile — new), Chrono Bat (Uncommon)
- **Spawn points:** Grand Courtyard, Sanctum of Stars, Sunken Library, Astral Altar, Temporal Garden
- **Description:** Gravity-defying blocks of pale stone inscribed with **aether-runes** that glow in sequences. Time flows oddly — some courtyards are frozen in sunrise, others in midnight. The **Sanctum of Stars** houses the Ancient Wyrm; the **Sunken Library** holds lore scrolls needed for crafting the **Chrono Collector**. Ruins occasionally **phase** — geometry shifts at dawn/dusk, opening new paths.

---

### 4.9 Void Rifts — Void / Rift (Floating)
- **Biome type:** Reality-torn rift pockets and void-wounds
- **Difficulty:** 4
- **Primary resources:** Void Essence (Rare), Void Core (Rare creature egg), Null Shard (new — Epic), Echoing Fragment (new — Legendary)
- **Unique creatures:** Void Leviathan (Rare — boss), Void Wisp (Rare), Rift Stalker (new — Elite), Void Horror (new — hostile ambient)
- **Spawn points:** Rift Observatory, Null Anchor, Entropy Garden, Maw Entrance
- **Description:** The fabric of Aethros is torn here. **Floating fragments** of impossible geometry drift in zero-g pockets. Touching a **Void Wound** deals damage but can drop **Null Shard**. The **Void Leviathan** dwells in the central **Maw** — a bottomless-looking pit that actually teleports players into a mirrored pocket dimension for the boss fight. Reality **flickers** (brief vision inversion) every few minutes.

---

### 4.10 Luminous Reef — Ocean / Coral Reef (Aetherial Sea)
- **Biome type:** Sunlit coral reef & underwater caverns at the cloud-sea edge
- **Difficulty:** 2
- **Primary resources:** Prism Coral (new — Uncommon, dye/crafting), Deep Pearl (new — Rare), Coral Bloom (new — consumable)
- **Unique creatures:** Coral Serpent (Rare — new), Deep Walker (Uncommon crustacean — new), Pearlback (Common), Azure Sardisk (schooling ambient)
- **Spawn points:** Reef Crest, Coral Gardens, Tide Pools, Sunken Galleon (shipwreck), Cavern Mouth
- **Description:** Where the cloud-sea deepens into a real, swimmable ocean. **Coral castles** and the **Sunken Galleon** wreck are dive sites. Water here is clear and teeming with colourful life, but **pressure begins** below Y=–20. Players need a **Breath of Aether** or water-breathing buff. The reef feeds a chain of **sinkholes** that lead down to the Abyss.

---

### 4.11 Abyssal Trench — Abyss / Deep Ocean (Abyssal Depths)
- **Biome type:** Crushing-depth trench, bioluminescent / void-corrupted
- **Difficulty:** 5
- **Primary resources:** Void Pearl (new — Legendary), Abyssal Core (new — Mythic), Deep Core (new — Rare), Dredged Relic (new — Epic)
- **Unique creatures:** Abyssal Wraith (Legendary — new), Deep Terror (Mythic leviathan — new), Umbral Eel (Rare), Shadow Jelly (Uncommon)
- **Spawn points:** Trench Floor, Abyssal City (ruined sunken city), Pressure Gate, Void Spring, Chasm Maw
- **Description:** The darkest place in Aethros. The **Abyssal City** — a ring of black spires older than the floating islands — rises from Y=–250. **Pressure** ticks up every stud descended; without a **Pressure Hull** upgrade the player takes escalating damage. **Void Springs** (purple geysers) corrupt creatures into Shadow variants. The **Deep Terror** dwells in the **Chasm Maw** — the world's deepest point (Y≈–400). Only reachable with endgame gear and the **Mythril**-lineage pressure suit.

### Minor sub-zones (spawn islands & pockets)
| ID | Parent | Type | Notes |
|---|---|---|---|
| skywhale_grave | nexus | Sky-Whale Graveyard | Hanging bones above the Nexus; rare bone loot |
| thunder_cleft | storm | Thunder Cleft | Canyon that only opens during storms |
| dreamer_grove | forest | Dreamer's Grove | Night-only grove for Moonbell harvesting |
| magma_chamber | volcano | Magma Chamber | Lava cave, high Ember Core density |
| geode_caverns | crystal | Geode Caverns | Cluster of giant geodes; Prismatic Cluster farm |
| astral_sanctum | ruins | Astral Sanctum | Rooftop temple; Sunmetal node |
| null_vestibule | void | Null Vestibule | Zero-G pocket; Echoing Fragment cluster |
| drowned_reefs | reef | Drowned Reefs | Deeper than main reef; Prism Coral + Pearlback |
| forgotten depths | abyss | Forgotten Depths | Mid-trench plateau; Dredged Relic cluster |

---

## 5. Terrain Generation Approach

`TERRAIN_SPEC.luau` drives generation via **seed + Perlin/fractals**, with biome chosen by the **vertical layer + nearest island** so the same generator produces cloud-sea, crystal caves, and abyssal floor deterministically.

### 5.1 Heightmap & vertical layering
1. **Base cloud-sea plane** at `WaterLevel = 0`, surface noise amplitude = 0.4 → ranges –20..+25 (the misty **Aetherial Sea**).
2. **Island float height** per zone from `ZONES[zone].floatHeight` (e.g. Nexus 320, Storm 190, Canopy 80). The island's top is `floatHeight + terrainOffset(x,z)`.
3. **Height scale**: `IslandFloat` scale (±80 studs undulation on plateau top), `PeakAmplitude` for mountains (±1.0×), `CaveDepth` (up to 60 studs carved below an island).
4. **Layer thresholds** (see `TERRAIN_SPEC.Config.Layers`) route `(x, y, z)` to the correct generation pass — you can stand on a floating island's *underside* and fall into the Aetherial Sea, or dive a sinkhole from the reef into the Abyss. Layers are **vertically stacked**, not blended.

### 5.2 Erosion
- **Thermal erosion** sharpens volcanic spines (Ashen Maw) and crystal facets (Crystal Canyons).
- **Hydraulic flow** carves the reef sinkholes and the Abyssal trench walls.
- **Wind abrasion** smooths the cloud-sea surface and etches the Storm Peaks.
- **Aether dissolution** (custom pass) hollows sub-surface caverns in Void Rifts and Crystal Caves without collapsing the surface — keeps the floating islands intact from below.

### 5.3 Water levels
- **Cloud-sea surface** (`CloudSeaLevel = 25`): a soft, buoyant mist that gently lifts players (swim-but-floats-up).
- **Real ocean** (`WaterLevel = 0`): swimmable, in Luminous Reef / around Ashen Maw's base.
- **Deep ocean / abyss** (–20 → –400): increasing **pressure** and decreasing **light**; physics drag ramps via `WaterDensity` config.

### 5.4 Decoration placement
- **Poisson-disk sampling** at biome-appropriate density (`DecorationDensity` per zone).
- **Height-biased placement**: flowers cluster on plateaus, crystals on cliff faces, ruins on flat summits.
- **Rarity gates**: Mythic props (e.g. Astral Observatory spire ornaments) only place on chunks where the world seed + coords hash into the top decile.
- Decoration families are **biome-tagged** so a single `placeDecorations(region, biome)` call knows to drop `CrystalShardCluster` in Crystal Canyons but `AshVents` in Ashen Maw.

---

## 6. Prop Placement Catalogue

Props are authored as **prefab families** keyed by biome tag, then scattered by the procedural placer. Each family has a `modelId`, `density`, `scaleRange`, and `placementRule`.

### 6.1 Trees / flora
| Prop | Biome tag | Model family | Density | Notes |
|---|---|---|---|---|
| Wispleaf Shrub | `aether`, `forest` | `rbxasset://props/Wispleaf` | high | Glows at night; bounces softly |
| Starblossom Tree | `astral`, `sky` | `rbxasset://props/Starblossom` | sparse | Zero-g flower; petals float away |
| Thunder Bloom | `storm` | `rbxasset://props/ThunderBloom` | medium | Conducts lightning; detonates on strike |
| Verdant Canopy Tree | `forest` | `rbxasset://props/CanopyTree` | medium | Mega-tree anchor; roots double as bridges |
| Ashbrush | `volcanic` | `rbxasset://props/Ashbrush` | high | Regrows after eruptions |
| Crystal Sapling | `crystal` | `rbxasset://props/CrystalSapling` | medium | Refracts projectiles |

### 6.2 Rocks / crystals
| Prop | Biome tag | Notes |
|---|---|---|
| Skystone Boulder | `aether`, `ruins` | Light; can be hopped |
| Obsidian Pillar | `volcanic` | Spawns near vents; radiates heat |
| Prism Crystal Cluster | `crystal` | Resonates; tunnable with Focus |
| Void Shard Spire | `void` | Flickers out of sync with reality |
| Deep Coral Outcrop | `ocean` | Sways; drops Prism Coral |
| Abyssal Chimney | `abyss` | Emits faint purple light; pressure node |

### 6.3 Ruins / structures
| Prop | Biome tag | Notes |
|---|---|---|
| Aethermoor Ruined Arch | `sky`, `ruins` | Fast-travel beacon mount |
| Temporal Obelisk | `ruins` | Phase-shift trigger at dawn/dusk |
| Stormforged Pillar | `storm` | Channels lightning to nodes |
| Forge Hearth | `volcanic` | Sunmetal crafting station |
| Crystal Vault Door | `crystal` | Opens when two prisms align |
| Abyssal Spires | `abyss` | Older-than-time; lore glyphs |
| Sunken Galleon | `ocean` | Shipwreck raid site |

### 6.4 Portals / connectors
| Prop | Biome tag | Purpose |
|---|---|---|
| Aetherial Beacon | `all` | Fast-travel anchor (one per major zone) |
| Nexus Gateway | `sky` | Teleport hub linking all beacons |
| Rift Gate | `void` | Event-only teleport to pocket dims |
| Submarine Lift | `ocean`, `abyss` | Pressure-rated descent between Reef ↔ Trench |
| Wind Tunnel | `storm`, `astral` | Updraft launch to higher layers |

---

## 7. Lighting & Atmosphere per Biome

Atmosphere is a **per-zone LayerSetup** swapped at zone boundaries; day/night + weather are applied as overlays. `TERRAIN_SPEC.luau` (WeatherConfig + DayNightConfig) is the source of truth for dynamic values; this section defines the *look*.

| Biome | Sky tint | Fog | Ambient | Sun tint | Point lights | Particles |
|---|---|---|---|---|---|---|
| Celestial Nexus | pale gold→rose (dawn) | thin, pearl-white, End 900 | 0.85, 0.88, 0.95 | warm gold | float-lanterns (Neon, 8s) | drifting aether motes |
| Astral Observatory | deep indigo→starfield | very thin, violet, End 1200 | 0.6, 0.6, 0.8 | cool white | constellation points | meteor shower, aurora curtains |
| Cloud Gardens | soft cyan→peach | low, blue-white, End 1400 | 0.9, 0.95, 1.0 | bright white | wispleaf glow (green Neon) | sky-lily petal drift |
| Storm Peaks | slate grey→electric | rolling, grey-blue, End 600 | 0.5, 0.55, 0.7 | steel grey | lightning flash (transient) | rain sheets, static arcs |
| Verdant Canopy | emerald→twilight violet (night) | medium, green, End 800 | 0.55–0.75 | daylight: 0.9,0.9,0.7 / night: 0.3,0.35,0.5 | moonbell (soft yellow) | glowing spores, firefly clusters |
| Ashen Maw | orange-red→ash grey | thick, ochre, End 400 | 0.45, 0.3, 0.25 | dull orange | lava embers (orange→yellow) | cinders, heat haze, eruption debris |
| Crystal Canyons | prismatic refraction | low, crystal-clear, End 1000 | 0.8, 0.8, 1.0 | refracted rainbow | crystal pulse (cycle hues) | light shafts through facets |
| Ancient Ruins | bronze→deep blue (night) | medium, warm grey, End 700 | 0.6, 0.55, 0.5 | amber (day) / silver (night) | rune glow (blue-white) | floating glyphs, time-dilation shimmer |
| Void Rifts | void black→purple | dense, purple-black, End 500 | 0.15, 0.1, 0.25 | dim violet | void orbs (blackbody 2000K) | reality flicker, particle inversion |
| Luminous Reef | turquoise→deep sapphire | water murk, End 60 (underwater) | 0.4, 0.7, 0.8 | refracted sunspecks | coral polyps (colour-cycle Neon) | bubble trails, plankton sparkle |
| Abyssal Trench | absolute black→dim violet | heavy, black, End 30 | 0.05, 0.05, 0.1 | none (replaced by vents) | abyssal vents (purple) | crushing-dark, occasional jelly glow |

### Day/night cycle overlay
A shared **TimeOfDayController** modulates each zone's `Ambient` and `DirectionalLight` by a global `TimeOfDay` (0–1). Night biomes (Void, Abyss) brighten slightly at local midnight to avoid total darkness; the **Verdant Canopy** flips to its enchanted palette at 0.7–0.1.

---

## 8. Pathfinding & Navigation

### 8.1 Roads & trails
- **Aetherial Highway:** a winding sky-road of solidified light connecting the outer six major islands (player-walkable, but *not* vehicle-grade — too fragile).
- Per-island **dirt/flagstone paths** link each zone's spawn points; these are the **quest auto-path targets**.

### 8.2 Bridges
- **Solid bridges:** material bridges (stone/crystal/metal) between islands in the same layer (e.g. Cloud Gardens ↔ Verdant Canopy via the **Grove Swing Bridge**).
- **Light bridges:** hard-light spans in Crystal Canyons and the Nexus (toggle on/off via puzzles).
- **Cable / zipline network:** Storm Peaks ↔ Ashen Maw **Storm Line**, and Nexus ↔ Astral Observatory **Starward Cable**.

### 8.3 Teleport pads & fast travel
- **Aetherial Beacons:** one per major zone, activate when the zone is first visited. The **Nexus Gateway** console in the Celestial Nexus lets players teleport instantly to any unlocked beacon.
- **Fast-Travel cooldown:** 5 min per island (configurable), enforced by `WorldManager` (existing module) with minor extension.
- Teleport VFX: **aether dissolve** (pixelate → swirl → rematerialise).

### 8.4 Spawn islands & safety
- Default spawn: **Nexus Plaza** (always safe, tutorial area).
- Each major zone has a clearly-marked **Spawn Point**. The `validateSpawnPoints` routine from the old `TERRAIN_SCRIPTS.luau` is replaced by `TERRAIN_SPEC.getSpawnPoint(zoneId)` which returns a safe, obstacle-cleared CFrame and validates against the heightmap so spawns never clip into terrain.
- **Emergency teleport** ("/return") drops players at their current zone's beacon, or the Nexus if offline/in-combat.

### 8.5 Navigation aids
- **Minimap** (existing `Minimap.luau`) shows beacon icons + current altitude layer.
- **Compass HUD** shows the direction of the three nearest quest objectives + the Nexus.
- **Glide assist** auto-deploys near cliff edges on any floating island.

---

## 9. Performance Considerations

The map is large but **vertically dense**, so streaming must be 3-D aware.

| Concern | Strategy |
|---|---|
| **LOD** | Static meshes switch to impostor billboards past 180 studs; terrain (chunk) meshes collapse past 250 studs. Crystal refraction and void flicker are **distance-faded**. |
| **Streaming** | `Workspace.StreamingEnabled = true`; chunks are 128×128×128 studs. Sky-realm chunks (altitude > 350) stream only when a player is in Astral Heights. Abyssal chunks (–20–) stream only when submerged. Cross-layer visibility (e.g. looking down from Nexus) uses a **low-detail proxy column** so distant layers render cheaply. |
| **Occlusion / culling** | Back-to-camera island plates are culled. Cave interiors use `CameraFrustum` portals — only the near cell and adjacent cells render. Void Rifts use **distance fog** to hide draw beyond 600 studs (cheap, and on-theme). |
| **Particles** | Particle emitters are rate-culled by distance and capped globally (budget: 4 000 active emitters). Heavy effects (Aurora, meteor shower) only activate for the nearest player. |
| **Physics** | Floating islands use `NetworkOwnership = Manual` locked to server (no client physics thrash). Only **creatures, players, and held props** are client-authoritative. |
| **Light culling** | Each biome carries a `LightInfluenceRadius`; point lights outside a player's 96-stud influence sphere are muted. |
| **Water** | The cloud-sea surface is a single large **transparent Part** + shaderless foam decal rather than a fluid sim. Underwater caustics are baked into the water tint, not real-time. |

---

## 10. Zone Connectivity Matrix

Quick reference for how every zone connects. "Ascend/Descend" = vertical layer transition.

| From → To | Route type | Notes |
|---|---|---|
| Celestial Nexus → Astral Observatory | Ascend (Starward Spire / Wind Tunnel) | prestige-gated |
| Celestial Nexus → Cloud Gardens | Glide / Beacon | starter route |
| Celestial Nexus → Storm Peaks | Light-bridge / Beacon | stormy approach |
| Celestial Nexus → Verdant Canopy | Grove Swing Bridge / Beacon | |
| Celestial Nexus → Ashen Maw | Ashen Bridge / Beacon | heat-hazmat recommended |
| Celestial Nexus → Crystal Canyons | Light-bridge / Beacon | |
| Celestial Nexus → Ancient Ruins | Temporal Arch / Beacon | |
| Celestial Nexus → Void Rifts | Rift Gate (event-only) | or glide during storm |
| Celestial Nexus → Luminous Reef | Submarine Lift (diving platform) | or glide down the central shaft |
| Luminous Reef → Abyssal Trench | Descend (sinkhole chain) | pressure suit required |
| Crystal Canyons ⇄ Verdant Canopy | Root Warren tunnel | hidden, requires Moonbell key |
| Storm Peaks → Ashen Maw | Storm Line zipline | high-speed, weather-gated |
| Ancient Ruins → Void Rifts | Phase-walk (temporal puzzle) | unstable |
| Verdant Canopy → Crystal Canyons | Crystal Resonance Bridge | light-based puzzle |

---

## 11. Implementation Cross-References

| Asset | Consumed by | Source |
|---|---|---|
| `TERRAIN_SPEC.Zones` table | TERRAIN_SPEC.luau (this spec's twin) | §4, §5 |
| Biome thresholds / layers | `TERRAIN_SPEC.getBiomeAt`, `getHeightAt` | §5.1, §5.4 |
| Spawn points | `TERRAIN_SPEC.getSpawnPoint(zoneId)` | §4 (every zone table) |
| Weather + day/night | `TERRAIN_SPEC.DayNightConfig`, `WeatherConfig` | §7 |
| Resource per biome | `TERRAIN_SPEC.getResourceAt(x,z)` | GAME_SPEC §1–2 |
| Creatures per biome | `Creatures.luau` data module | §4 |
| WorldManager fast-travel | `WorldManager:CanFastTravel`, `GetSpawnPoint` | existing module (extended) |
| Node placement | `NodeManager` | `TERRAIN_SPEC.ChunkSize`, `DecorationDensity` |
| UI minimap / compass | `Minimap.luau`, `HUD.luau` | §8.5 |
| Lighting swap | `LIGHTING_ATMOSPHERE.luau` (existing) | §7 (upgrade target) |

---

## 12. Design Decisions & Rationale

- **Four-layer verticality over flat cluster:** Satisfies *all six* required biome pillars (sky realm + floating islands cover "floating islands (aether)" and "sky realms"; Crystal Canyons carries "crystal caves"; Verdant Canopy carries "enchanted forests"; Ashen Maw carries "volcanic zones"; Luminous Reef + Abyssal Trench carry "ocean/water areas") without sacrificing the established `GAME_SPEC.md` biomes.
- **Preserved GAME_SPEC biomes verbatim:** Cloud Gardens, Storm Peaks, Void Rifts, Crystal Canyons, Ancient Ruins retain their resource pools and creature rosters so existing item/creature databases drop in unchanged.
- **New content for new biomes:** Verdant Canopy, Ashen Maw, Luminous Reef, Abyssal Trench, Astral Observatory each get dedicated resources + creatures (introduced in §4) so progression depth matches the 1–5 difficulty ladder.
- **getSpawnPoint replaces validateSpawnPoints:** The new spec centralises safe-spawn logic in `TERRAIN_SPEC.getSpawnPoint(zoneId)`, returning an obstacle-cleared CFrame consistent with the heightmap, fixing the older module's brittle hardcoded-vector approach.

---

*The world of Aethros hangs in the void: climb high enough and you touch the stars; fall far enough and you break reality. Every island has its story, every cave its secret, and every aether node its echo of the forge that made the sky. Harvest, explore, and leave your mark on the floating world.*
