# ADVERSARIAL REVIEW — Aether Harvester Reforge

## 1. Verdict Summary

| Document | Verdict | Reason |
|---|---|---|
| `design/GAME_DESIGN_DOCUMENT.md` | **FAIL** | Core thesis promises a 4-layer world but v1 scope delivers only 2 layers; onboarding claims are physically impossible; anti-grind pillar is marketing fluff with no concrete numbers. |
| `design/UI_DESIGN_SYSTEM.md` | **FAIL** | Entire token system uses web/CSS syntax (`--vars`, `rem`, `aria-label`) that is incompatible with Roblox Luau GUI; massively overengineered for the proposed thin-client architecture. |
| `autonomy/ARCHITECTURE.md` | **PASS WITH ISSUES** | Sound structural decisions (Shared/Domain, RemoteRegistry, schema versioning) but no migration path from legacy prototype; 80% of existing modules marked REWRITE with zero timeline. |
| `autonomy/ECONOMY_MODEL.md` + sims | **FAIL** | Sim scripts do not implement the doc's own anti-grind rule; sim-sinks is a fake model with no real sinks; economy curves produce 38-hour upgrade gaps with no stated player journey to bridge them. |

---

## 2. Numbered Findings

**P0 — Economy is mathematically broken**
- **DOC:** `autonomy/ECONOMY_MODEL.md` §Cost Curves + `sim-progression.luau`
- **Flaw:** Tool upgrade cost = `100 * 1.5^(tier-1)`. Tier 10 = 3,843 shards. Casual rate = 100 shards/hr. A casual player needs **38 hours of gameplay for a single tier-10 upgrade**. The sims output "Day 1: Upgrades: 1" because the sim divides by 100 and buys everything at once — it does not model actual tiered costs.
- **Fix:** Tie upgrade costs to player level, not flat tiers. Add a "shard multiplier per session" that scales with layer depth so deeper play yields proportionally more. Rerun sims with real tiered costs.

**P0 — Diminishing returns not simulated, claim unverified**
- **DOC:** `autonomy/ECONOMY_MODEL.md` §Anti-Grind Rule + `sim-progression.luau`
- **Flaw:** The doc states "10% per hour reduction after 2 hours, capped at 50%" but `sim-progression.luau` applies zero diminishing returns. The user-flagged "Day 3-4 stall (0 shards)" cannot be reproduced from the provided sim logic.
- **Fix:** Add diminishing returns to `sim-progression.luau`. If the stall is real, the fix is lower XP/shard scaling on repeat nodes, not harder sinks.

**P1 — Thesis contradicts v1 scope**
- **DOC:** `design/GAME_DESIGN_DOCUMENT.md` §1 Product Thesis + §10 Release Scope
- **Flaw:** Thesis sells "a four-layer vertical world — from starlit observatories to crushing abyssal trenches." v1 ships only Celestial Nexus + Floating Archipelago (2 of 4 layers). This is a 50% feature cut masquerading as the core fantasy.
- **Fix:** Rewrite thesis to match v1 scope, or move Astral Heights + Abyssal Depths into v1 and demote Aetherial Sea to post-launch.

**P1 — UI system is web design dropped into a Roblox project**
- **DOC:** `design/UI_DESIGN_SYSTEM.md` §2 Token System, §6 Accessibility
- **Flaw:** Uses CSS custom properties (`--bg-deep`), `rem` units, and ARIA attributes. Roblox Luau uses `Color3`, `UDim2`, and `GuiService` — none of these tokens are usable without a build-time transpiler that does not exist in the repo.
- **Fix:** Redesign tokens as Roblox-native: `Color3.fromRGB()` values, `UDim2` spacing constants, and Roblox accessibility APIs (`GuiService.Translate` instead of `aria-label`).

**P1 — No migration path from legacy prototype**
- **DOC:** `autonomy/ARCHITECTURE.md` §9 Legacy Assessment
- **Flaw:** 10 of 13 legacy server modules and 3 of 4 client modules are marked REWRITE. The architecture assumes a greenfield rewrite but the repo contains a live prototype that players may already use.
- **Fix:** Add a phased migration plan with feature flags and dual-write periods. Specify which modules can be rewritten in-place vs. which need a hot-swap.

**P2 — Shop UI contradicts cosmetic-only monetization**
- **DOC:** `design/UI_DESIGN_SYSTEM.md` §4.6 Shop / Monetization + `design/GAME_DESIGN_DOCUMENT.md` §9 Monetization Philosophy
- **Flaw:** Shop UI spec includes "Currency Packs," "Battle Pass" tab, and "Featured Carousel." GDD says "The only Robux purchases are: tool skins, creature auras, base decorations, and seasonal cosmetics." The UI is already drifting toward gameplay-affecting purchases.
- **Fix:** Remove Currency Packs and Battle Pass from v1 UI spec. Lock the Shop to a single "Cosmetics" tab.

**P2 — Gems have no meaningful sink**
- **DOC:** `autonomy/ECONOMY_MODEL.md` §Currencies + `design/GAME_DESIGN_DOCUMENT.md` §9
- **Flaw:** Gems are "hard currency" earned from daily login/achievements/prestige. The only listed sink is "Premium Shop." If cosmetics are the only Robux purchase and gems are free-to-earn, there is no gem sink that feels meaningful without violating the cosmetic-only promise.
- **Fix:** Either (a) make gems a true premium currency purchased with Robux with clear conversion rates, or (b) remove gems entirely and use a single soft currency.

**P3 — Missing Roblox platform constraints**
- **DOC:** All four documents
- **Flaw:** No mention of DataStore request limits (Roblox enforces strict per-minute caps), server player caps (Roblox standard servers cap at 12-32 depending on configuration), HTTP request budgets, or memory budgets per server/client. The architecture assumes unlimited backend resources.
- **Fix:** Add a "Platform Constraints" section to ARCHITECTURE.md documenting Roblox-specific limits and how the design works within them.

**P3 — No moderation, safety, or parental controls**
- **DOC:** `design/GAME_DESIGN_DOCUMENT.md` §6 Target Audience
- **Flaw:** Target is ages 10–25 with social features (guilds, chat, trading) but zero design for chat filtering, reporting, block lists, or parental consent flows. Roblox requires COPPA compliance for under-13 users.
- **Fix:** Add a Safety & Compliance section covering chat filtering, report flows, and under-13 data handling.

---

## 3. Top 5 Must-Fix Items Before Implementation

1. **Fix economy math.** Rerun sims with real tiered costs and diminishing returns. If Day 3-4 stall exists, fix shard scaling before any other work.
2. **Rewrite UI tokens for Roblox.** Convert all CSS variables to `Color3`/`UDim2` constants. Remove ARIA references.
3. **Align thesis with v1 scope.** Either expand v1 to 4 layers or rewrite the product thesis to match the 2-layer reality.
4. **Strip non-cosmetic monetization from UI spec.** Remove Currency Packs, Battle Pass, and any gameplay-affecting shop tabs.
5. **Add migration plan to architecture.** Define dual-write periods, feature flags, and rollback procedures for the 80% rewrite workload.

---

## 4. What the Design Got RIGHT

- **Shared/Domain pure-function layer** is the correct architectural pattern for Roblox and eliminates client-server desync risk.
- **Schema versioning with forward-only migrations** is production-grade and exactly what a live Roblox game needs.
- **Anti-scam trade validation** and **server-authoritative state** show security awareness.
- **The vertical-layer world concept** is genuinely differentiated from horizontal-skyblock sims if executed.
- **Colorblind-safe rarity** and **reduced-motion toggle** are thoughtful accessibility choices, even if the implementation syntax is wrong for Roblox.
