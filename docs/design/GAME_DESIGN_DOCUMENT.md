# Aether Harvester Simulator — Game Design Document v2

> **Status:** Draft — Product Thesis & Design Pillars
> **Supersedes:** `kilo_HQ/.team/deliverables/GAME_DESIGN_DOCUMENT.md` (v1)
> **Author:** Game Director (Aether Harvester Reforge)

---

## 1. Product Thesis

Aether Harvester is a sky-based resource-collection sim where the player descends through a four-layer vertical world — from starlit observatories to crushing abyssal trenches — harvesting aether energy that is literally the substance of the world itself. Every tool upgrade, creature bond, and base expansion is a step deeper into Aethros, and the core fantasy is not accumulation but *transformation*: the player begins as a novice harvester and becomes an aether-sculptor who reshapes the world's ecology, breeds creatures with inherited traits, and earns the right to reach the mythic layers where the sky meets the void. The game is a click-and-rebirth simulator only in the loosest sense — its real identity is a skill-based, vertically stratified exploration loop where harvesting is a deliberate, combo-driven action, not a grind, and where the world reacts to what you take.

---

## 2. Player Fantasy

**What aether is:** Aether is the raw substance of Aethros — the cerulean void that suspends the floating islands. It is not magic; it is physics. It flows in currents between layers, pools in nodes on island surfaces, and is the only currency that matters. Harvesting aether is literally pulling the world's energy through your tool, and the tool determines how you interact with it (siphon, freeze, resonate, compress).

**The harvest fantasy:** The player is a lone harvester with a tool and a backpack, descending into increasingly dangerous strata. Each harvest is a micro-decision — which node to target, which tool to use, whether to push deeper or retreat. The fantasy is competence: you get better at reading node patterns, timing combos, and managing creature companions. It is not about clicking faster; it is about choosing wisely.

**Transformation:** The player's arc is from harvester to aether-sculptor. Early game is about survival and basic collection. Mid-game is about building a base, taming and breeding creatures, and mastering tool combos. Late game is about reaching the Astral Observatory and Abyssal Trench, where the world's deepest secrets await. Prestige rebirths are not resets — they are ascensions that leave permanent visual auras and unlock new layers, so each rebirth feels like a transformation, not a loss.

---

## 3. Core / Meta / Session Loops

**Core Loop (per session, ~15–30 min):**
1. Spawn at Celestial Nexus → glide to target island (1–2 min)
2. Harvest aether nodes using tool combos (8–15 min)
3. Tame/breed a creature or craft an upgrade (3–5 min)
4. Return to Nexus → sell, craft, upgrade tool (2–3 min)
5. Decide: push deeper to a new layer or repeat for mastery (1 min)

**Meta Loop (100–200 hours):**
Daily login → harvest → craft/trade → upgrade → unlock new island layer → discover legendary creature → expand base → prestige rebirth → repeat with deeper layers and permanent bonuses.

**Session Loop (per play session, ~30–60 min):**
Warm-up (10 min, easy layer) → core grind (20 min, target tier) → event/expedition (15 min, special zone) → wind-down (5 min, sell/craft, check leaderboard). Diminishing returns activate after 2 hours continuous play, enforcing natural session breaks.

---

## 4. Selected Differentiation Pillars

### Pillar 1: Vertical 4-Layer World (Score: 9.2/10)
**What:** The world is stratified into Astral Heights, Floating Archipelago, Aetherial Sea, and Abyssal Depths. Height = biome. Descending is mechanically and narratively distinct from horizontal travel.
**Why it fits Aether Harvester:** The vertical axis is the game's identity. It transforms a flat Roblox sim into a world with genuine depth (literal and figurative). It justifies the difficulty tier system and gives every layer a unique visual identity, resource pool, and creature roster.
**Moment-to-moment:** Players make vertical navigation decisions — do I descend to the Reef for Prism Coral or push to the Abyss for Void Pearl? Each descent requires preparation (pressure suit, breath buff), creating tension and resource management around layer access.
**Dev cost:** High (7/10) — requires full world geometry, streaming, lighting per layer, and vertical pathfinding.
**Risks:** Performance on mobile (draw distance across layers); streaming bugs at layer boundaries.

### Pillar 2: Creature Breeding with Genetics (Score: 8.0/10)
**What:** Creatures inherit parent stats with mutation chance. Breeding requires specific biome resources, has hatching timers, and produces offspring with variable traits. Four pet classes (Harvester, Combat, Support, Mount) with skill-like synergies.
**Why it fits Aether Harvester:** The existing creature system (12 types, taming, pet inventory) is already deep. Breeding adds a genetic dimension that makes each creature unique and gives players a long-term investment beyond taming. It transforms creatures from collectibles into lineage.
**Moment-to-moment:** Players plan breedings for stat optimization, wait for hatching timers, and experiment with mutation outcomes. Companion synergies (e.g., Harvester pet + Quantum Harvester tool = combo bonus) make creature choices matter in every harvest.
**Dev cost:** Medium (6/10) — genetics system is data-driven; breeding UI and hatching timers are standard Roblox patterns.
**Risks:** Balancing mutation rates so rare traits feel achievable but not guaranteed; preventing breeding from becoming the only viable progression path.

### Pillar 3: Reactive World & Aether Currents (Score: 7.5/10)
**What:** The world responds to player harvesting. Nodes deplete locally, aether currents shift, and creature behavior changes based on resource extraction. Events (Aether Storm, Rift Convergence) dynamically alter node availability and creature spawns.
**Why it fits Aether Harvester:** The current design has static node respawn timers and scheduled events. Making the world reactive turns harvesting from a repetitive task into a strategic decision — over-harvest one node and the current shifts, forcing players to adapt.
**Moment-to-moment:** Players read the world state before committing to a harvest route. A depleted node cluster means moving to a new area. Aether Storm events super-charge specific layers, creating urgency and opportunity windows.
**Dev cost:** Medium (5/10) — node depletion and current shifts are state-machine changes; event overlays reuse existing event infrastructure.
**Risks:** Over-complexity in early game; players may not notice or understand reactive systems without clear feedback.

### Pillar 4: Anti-Grind Ethical Monetization (Score: 7.0/10)
**What:** Cosmetic-only monetization (Robux catalog). No pay-to-win. Diminishing returns after 2 hours continuous play. Daily login rewards with streak bonuses. Loot boxes with transparent published rates and pity system.
**Why it fits Aether Harvester:** The existing design already has anti-grind and cosmetic-only monetization. Elevating this to a pillar makes it a brand identity — the game is positioned as respectful of player time and money, differentiating it from predatory Roblox sims.
**Moment-to-moment:** Players know their time is valued. The 2-hour diminishing return cap means sessions feel productive without being exhausting. Cosmetic purchases are identity expressions (aura colors, tool skins, base decorations) that don't affect gameplay.
**Dev cost:** Low (2/10) — cosmetic items are UI/design work; anti-grind is a simple multiplier decay.
**Risks:** Cosmetic revenue may underperform if players expect gameplay-affecting purchases; pity system requires careful tuning to feel fair without being exploitative.

### Pillar 5: Skill-Based Harvesting Combos (Score: 6.5/10)
**What:** The existing combo system (consecutive same-type harvests build multipliers) is elevated into a skill-based system. Timing, tool selection, and node-type sequencing matter. Critical harvests require precise tool-node pairing. Mastery trees unlock combo variants.
**Why it fits Aether Harvester:** The current combo is a simple multiplier. Making it skill-based transforms harvesting from "click the shiny thing" into a deliberate, satisfying action loop that rewards attention and practice.
**Moment-to-moment:** Players actively manage their combo chain, choosing which node type to prioritize and when to use special tool abilities. A missed combo break costs multiplier progress, creating tension in every harvest session.
**Dev cost:** Low (3/10) — builds on existing combo system; mastery tree integration reuses skill-tree infrastructure.
**Risks:** May feel punishing to casual players if combo breaks are too frequent; needs forgiving visual/audio feedback.

---

## 5. Rejected Ideas

| Idea | Reason |
|---|---|
| Prestige rebirth with permanent auras | Overlaps with transformation fantasy; auras are cosmetic and can be folded into Pillar 4 |
| Dynamic marketplace with supply/demand pricing | Complex for v1; can be post-launch; current static pricing is sufficient |
| Aether Storm weekly event | Already in design as an event; not a structural differentiator |
| Creature combat as optional PvP | Turn-based 3v3 adds scope without core identity; combat is secondary to harvesting |
| Base building with visitable player bases | P2 scope; can be post-launch; current design has base building as roadmap |
| Procedural terrain generation | High dev cost (9/10) for marginal value over hand-crafted zones; use seed-based placement only |
| Skill tree synergy bonuses | Already in design; not a separate pillar |
| Loot box pity system | Subset of ethical monetization (Pillar 4) |
| Aether currents (standalone) | Folded into Pillar 3 (Reactive World) |
| Harvesting combos (standalone) | Elevated to Pillar 5 with skill-based depth |
| Reactive worlds (standalone) | Folded into Pillar 3 |
| Companion synergies (standalone) | Folded into Pillar 2 (Creature Breeding) |
| Mastery trees (standalone) | Already in design; not a separate pillar |
| Expeditions | Can be a post-launch event type; not a structural pillar |
| World restoration | Narrative concept; no mechanical differentiation for v1 |
| Dynamic resource ecology | Folded into Pillar 3 |
| Challenge rifts | Can be a post-launch zone type; not a structural pillar |
| Seasonal world transformations | Already in design as seasonal events; not a structural pillar |
| Skill-based harvesting (standalone) | Elevated to Pillar 5 |

---

## 6. Target Audience & Onboarding

**Target audience:** Roblox players aged 10–25 who enjoy collection, progression, and exploration games. Primary: players who like Skyblock, Pet Simulator, and resource-management sims. Secondary: players seeking a less grindy, more atmospheric alternative.

**Onboarding arc:**
- **First 5 minutes:** Spawn at Celestial Nexus. Tutorial NPC (Sky Whale) guides player to Cloud Gardens. First harvest of Aether Shards. First tool upgrade. First creature tame (Cloud Sprite). Player leaves with a sense of "this world is beautiful and I can interact with it."
- **First session (30 min):** Complete the starter quest chain (First Harvest → Storm Caller → Void Wanderer). Unlock Energy Siphon. Tame a second creature. Visit two islands. Understand the core loop and layer system.
- **First week:** Reach Tier 2 (Adept). Breed first creature pair. Participate in first Aether Storm event. Expand sky base once. Understand prestige as a concept. Have 5–8 hours of play and a clear sense of what the deeper layers hold.

---

## 7. Controls & Camera Design Intent

**Desktop:** WASD movement, mouse look, left-click harvest, right-click interact, scroll wheel tool switch, E for quick-bar, Space for glide, Shift for sprint. Camera is third-person over-the-shoulder with smooth orbit (mouse drag). Minimap shows layer depth indicator.

**Mobile:** Virtual joystick (left) for movement, swipe (right) for camera orbit, tap to harvest/interact, double-tap tool switch, pinch to zoom. Camera auto-adjusts to layer transitions (zoom out when ascending, tilt down when descending). Touch controls must be usable with one hand for harvesting.

**Camera intent:** The camera should always convey verticality. When the player looks down, the abyss is visible; when looking up, the Astral Heights are in frame. Layer transitions use a subtle vignette and color shift so the player always knows their depth.

---

## 8. Accessibility & Performance-Aware Design

**Accessibility:** Colorblind-safe rarity colors (shape + color coding). Subtitles for all ambient audio cues (node harvest, creature sounds, event warnings). Adjustable UI scale. Option to reduce particle density. Controller support (Xbox/Playground) for desktop.

**Performance:** Streaming chunk size 128 studs. LOD switching at 180 studs (impostor billboards). Particle budget: 4,000 active emitters globally, rate-culled by distance. Sky-realm and abyssal chunks stream only when the player is in that layer. Underwater caustics are baked, not real-time. Floating islands use server-authoritative physics (no client physics thrash). Target 60 FPS on mid-range mobile (Adreno 640 / Apple A12 equivalent).

---

## 9. Monetization Philosophy

Cosmetic-only. No gameplay-affecting purchases. No loot boxes with hidden rates. All loot boxes display published drop rates and have a pity system (rare at 50 pulls, legendary at 200). Daily login rewards are free and generous. The only Robux purchases are: tool skins, creature auras, base decorations, and seasonal cosmetics. The game must never feel like it is asking the player to pay to progress. This is a brand promise, not a feature.

---

## 10. Release Scope

**IN v1:**
- Celestial Nexus + Floating Archipelago layer (7 islands: Cloud Gardens, Storm Peaks, Verdant Canopy, Ashen Maw, Crystal Canyons, Ancient Ruins, Void Rifts)
- Full harvesting system (4 tools, combo system, critical harvests)
- Creature taming, pet inventory, and first breeding (Cloud Sprite + Sky Fox)
- 5-branch skill tree (Harvesting, Exploration, Trading, Engineering, Creature Care)
- Quest system (20 quests, 6 types)
- Sky base (level 1–3 expansion)
- Aether Storm weekly event
- Cosmetic-only Robux catalog
- Anti-grind diminishing returns
- Desktop controls; mobile touch controls (basic)

**POST-LAUNCH:**
- Astral Heights and Abyssal Depths layers
- Full creature breeding genetics system
- Aetherial Sea (Luminous Reef) layer
- Base building expansion (visitable bases, guild island)
- Player-to-player trading
- PvP creature combat
- Seasonal world transformations
- Challenge rifts
- Per-biome audio and mobile optimization pass
