# Aether Harvester — Deep Research, Product Roadmap, and Release Gates

**Project root:** `C:\Users\aariz\kilo_HQ\roblox-dev\aether-harvester`  
**Current branch:** `reforge/full-autonomous-rebuild`  
**Scope:** Godot and Roblox Studio only, with Rojo/TestEZ/Luau tooling already pinned in the repository.  
**Status:** Baseline audit and roadmap; implementation continues until every gate below is evidenced.

## Executive decision

Aether Harvester should ship as a polished, exploration-first resource and creature-collection experience, not as a generic clicker and not as a gambling loop. Its durable engagement should come from meaningful choices, readable progression, social cooperation, discovery, seasonal goals, and player expression. Monetization should sell identity, convenience, optional social/private-server value, and content support without selling victory or making core play unpleasant.

The project has a substantial server-authoritative foundation: harvesting, player data, quests, pets, upgrades, travel, crafting, rewards, trading, guild, events, mail, analytics, anti-cheat, cosmetics, battle-pass, prestige/ascension, session parties, marketplace, and leaderboard modules are present. Presence of a module is not proof that its runtime path is complete. The next work therefore prioritizes wiring, adversarial verification, player-facing feedback, and a playable vertical slice before breadth expansion.

There is no honest basis for promising revenue or a specific Robux result. Roblox itself recommends improving retention, engagement, and monetization metrics before scaling acquisition, and those metrics must be measured from real players after staging. The roadmap treats monetization as an experiment with safety and compliance gates, not as a guaranteed business outcome.

## Evidence baseline

The following observations were made from the current checkout and local toolchain:

| Area | Current evidence | Meaning |
|---|---|---|
| Repository | Git checkout on `reforge/full-autonomous-rebuild` | Correct source of truth located and preserved |
| Main build | `rojo build` passed | Main place serializes successfully |
| Test build | `rojo build test.project.json` passed | Test place serializes successfully |
| Pure logic | 49 passed, 0 failed via Lune | PureMath, QuestProgress, DailyRewardProgress, and PrestigeMath coverage exists |
| Formatting | `stylua --check src tests` passed | Formatting is currently clean |
| Lint | `selene src tests` passed: 0 errors, 0 warnings, 0 parse errors | Static-analysis gate is green for the current checkout |
| Studio | A local Studio place and the Roblox bridge are available | Studio verification is possible, but must be rerun against this checkout |
| Assets | Blender-authored source and FBX exports exist | Imported assets still require scale, pivot, material, collision, and performance checks |
| External release | Not verified in this audit | Publishing and monetization remain gated behind human approval |

The checkout contains uncommitted user work, including accessibility/safe-area scripts, imported models, and autonomy documentation. That work is preserved; future commits must stage only files intentionally changed for the current slice.

## Product pillars

### 1. Aetheric expedition

Each island has a distinct visual identity, resource ecology, traversal problem, creature set, and small story. A player should be able to answer “why this island?” before entering it and “what did I learn?” after leaving it.

### 2. Skillful harvesting

Harvesting is the readable moment-to-moment action: aim, choose a node, manage tool timing, react to node state, and decide whether to continue the route or return to cash in. Combos and critical outcomes may add mastery, but they must not hide the base outcome or create an unbounded reward faucet.

### 3. Collection with agency

Creatures are earned through exploration, quests, taming, crafting, and clearly labeled optional purchases. Players need a non-paid path to meaningful collection progress. Paid random outcomes are excluded from the initial release; if ever reconsidered, PolicyService, eligibility handling, complete numerical odds, and a direct alternative are mandatory.

### 4. Social value

Parties, trades, guild goals, cooperative events, and player bases should make other players useful without forcing them to pay or compete for power. Leaderboard rewards should be cosmetic or recognition-based.

### 5. Long-term but healthy engagement

Daily and weekly goals should be generous, catch-up friendly, and completable without a punitive timer. The game should not use deceptive scarcity, fake countdowns, manipulative pressure, or mechanics designed to make players feel unable to stop. Roblox’s own monetization guidance warns against false urgency and unpopular forced appointment mechanics.

## Core loop and economy design

```text
enter Aethros -> choose route -> harvest -> return or push deeper
       -> sell/craft/upgrade -> tame or quest -> unlock a new decision
       -> cooperate, decorate, collect, or prestige -> return with a new goal
```

The economy has four jobs:

1. Give every activity a visible short-term reward.
2. Create medium-term decisions between tools, storage, travel, crafting, pets, and cosmetics.
3. Provide long-term collection and mastery goals.
4. Remove currency through understandable, optional or progression-relevant sinks so inflation does not erase meaning.

The first release should use deterministic and inspectable reward tables. Any random free reward must still be understandable in the UI; any future paid random reward is a separate compliance project, never a shortcut added to the shop.

### Initial balance targets

These are targets to validate with simulations and playtests, not claims about current balance:

| Journey | Target experience |
|---|---|
| First 60 seconds | Player moves, sees a node, harvests it, and receives a clear confirmation |
| First 5 minutes | Player completes the first quest, understands inventory, and has one meaningful upgrade choice |
| First 20 minutes | Player visits a second route or island and has a pet/collection decision |
| First session | Player leaves with an explicit next goal and no blocked core action |
| First week | Player has several parallel goals: collection, mastery, social, and exploration |

Reward curves must be simulated for new, returning, efficient, and inefficient players. Every source and sink should be logged with a balance snapshot so runaway generation is detectable.

## Monetization plan and compliance gates

### Release 1 offer hierarchy

1. **Cosmetics:** tool skins, auras, emotes, titles, base decoration, pet accessories, and photo-mode effects.
2. **Convenience:** additional cosmetic loadout slots, extra non-power storage organization, private-server tools, and quality-of-life features that do not multiply competitive output.
3. **Optional supporter pass:** permanent cosmetic bundle plus a small, clearly disclosed convenience benefit; no exclusive power needed to complete the game.
4. **Repeatable developer products:** only for guaranteed, clearly described consumables such as cosmetic currency or a named convenience item. Receipts must be idempotent and journaled.
5. **Private servers and creator rewards:** considered only after the experience is stable and players demonstrably use the social loop.

Game passes are for one-time privileges; developer products are for repeatable purchases. Roblox requires purchase grants to be processed on the server using `MarketplaceService.ProcessReceipt`, not by treating a client purchase-finished event as proof. The implementation must therefore keep a receipt journal, validate the player/product, grant exactly once, and return the correct decision when the grant cannot yet be completed.

Paid randomized eggs, chests, wheels, pity boosts, and paid luck modifiers are out of scope for the first release. Roblox classifies these as paid random items and requires numerical odds, all possible outcomes, and per-player policy handling through `PolicyService:GetPolicyInfoForPlayerAsync()`. If a future design includes them, users restricted by policy must receive a compliant alternative or the feature must be hidden/blocked. A transparent deterministic shop is the default.

Shop copy must avoid fake urgency, false scarcity, pressure aimed at minors, and permanent “limited” offers that reset. Pricing and product IDs belong in a single configuration module and must never be trusted from the client.

### Monetization success criteria

No monetization feature is release-ready until:

- the item has a clear value proposition and a non-paid core-game alternative where appropriate;
- the server owns entitlement and receipt state;
- duplicate delivery, retries, rejoin, leave-during-purchase, and unknown-product cases are tested;
- restricted users receive the correct policy treatment;
- the purchase UI works on desktop, touch, and gamepad layouts;
- analytics can measure impression, prompt, completion, grant, refund/rollback signal, and support path;
- a human owner reviews the final pricing and Creator Hub product setup.

Roblox’s DevEx documentation describes Earned Robux eligibility and exchange rules, but it does not guarantee eligibility, revenue, or approval. The project must not represent projected Robux as income until Creator Hub reports real eligible earnings.

## Measurement and healthy retention

The minimum funnel is:

```text
join -> spawn -> first movement -> first harvest -> first inventory view
     -> first upgrade -> first island decision -> first return session
     -> social interaction -> optional shop impression -> purchase/grant
```

Instrument events with privacy-minimizing, aggregate-friendly fields: event name, experience build, platform, zone, session age, and bounded numeric context. Do not log secrets or unnecessary personal data. Measure:

- first-session completion and time to first harvest;
- D1, D7, and D30 retention;
- average session time and meaningful actions per session;
- crash/error rates, join time, client memory, and server heartbeat;
- economy sources/sinks and inventory overflow;
- shop impression-to-purchase conversion and refund/support signals;
- social participation and repeat use of cooperative content.

Roblox Analytics exposes retention, engagement, monetization, acquisition, demographics, and feedback KPIs. It should be used after real staging traffic exists; it is not a substitute for local tests. Avoid optimizing one metric at the expense of player trust or stability.

## Technical architecture and non-negotiables

### Server authority

Currency, inventory, quests, pets, trades, crafting, upgrades, entitlements, and reward grants remain server-owned. Clients send intentions with typed, bounded payloads. The server validates distance, ownership, cooldown, state version, item definitions, and player eligibility before changing data.

### Data safety

- one schema version and an explicit migration ledger;
- per-player session/save lock;
- bounded retries and a clear failed-save state;
- receipt journal separate from gameplay balance;
- development/staging key prefixes that cannot touch production data;
- corruption detection and recovery path;
- idempotent grants for rewards and purchases.

### Performance

Roblox identifies instance streaming as the highest-impact mechanism for client memory usage on large worlds. The project should enable and verify streaming, avoid unnecessary persistent models, bound per-frame work, pool repeated effects, and keep zone identity mostly data-driven. Performance checks must cover low-memory/mobile-like conditions as well as the development laptop.

Budgets are measured, not assumed:

- client target: 60 FPS, 30 FPS minimum on the supported low-end profile;
- server heartbeat: no sustained degradation under the target player count;
- join time: measured from play click to usable movement;
- memory: sample at join, 10 minutes, 30 minutes, and after teleport cycles;
- network: measure harvest, inventory, social, and event traffic separately.

### Governed imagegen → Godot → Roblox content pipeline

The image workflow is an acceleration path for authored content, not a bypass around asset quality or licensing checks:

1. **Concept/source:** use the `imagegen` skill for original concept sheets, icon explorations, decals, sprites, and texture references. Keep the selected prompt/output and provenance beside the asset manifest; do not ship an unreviewed variant or use a recognizable third-party character/logo as a source.
2. **Assembly/validation:** use the local Godot MCP for deterministic scene assembly, geometry/material setup, atlas or texture preparation, collision proxies, scale checks, and export. Prefer repository-owned `.tscn`, `.glb`, `.png`, and source metadata over opaque one-off edits. Godot is a content tool here unless a feature is explicitly proven portable to Roblox.
3. **Roblox import:** import through the local Roblox bridge/Studio workflow, then verify pivot/orientation, studs scale, material response, collision groups, streaming behavior, LOD/triangle counts, texture memory, and mobile readability. Validate the live asset in the actual place; an export file alone is not evidence.
4. **Release record:** every selected asset gets a stable ID, source path, generator/tool version, license/provenance note, dimensions, triangle/texture budget, target zone, and verification status in `ASSET_MANIFEST.json`. Never overwrite an existing user asset without an explicit versioned replacement.

No asset is production-ready until the Godot export, Roblox import, runtime placement, and visual/performance checks are all recorded. Generated art must serve a clear gameplay purpose and remain consistent with Aether Harvester’s visual language; quantity of generated variants is not a quality metric.

## Roadmap with exit gates

### Phase 0 — baseline and hygiene

**Work:** clean lint warnings, reconcile contradictory status docs, preserve uncommitted user changes, verify Rojo mappings, verify remotes against usage, and create a machine-readable test summary.

**Exit gate:** format, lint, pure tests, main build, test build, and project manifest validation all pass; no stale “verified” claims remain without evidence.

### Phase 1 — playable vertical slice

**Work:** make a new player’s first five minutes complete: spawn, movement, first harvest, inventory, quest, upgrade, pet/tame, and travel. Wire all feedback through the live UI with loading/error/empty states. Add a small Cloud Gardens route with a second route decision.

**Exit gate:** a fresh Studio client can complete the slice without console errors, duplicated rewards, invisible state changes, or dead-end buttons; the same flow passes with a second client present.

### Phase 2 — authoritative progression

**Work:** finish data schema/migrations, tool tiers, skill choices, daily rewards, achievements, quest tracker, pet feeding/energy, and node/route balancing. Add adversarial tests for malformed payloads, replay, distance spoofing, rate abuse, trade races, and save/rejoin.

**Exit gate:** every state-changing remote has validation and a test; load/rejoin preserves valid state; invalid actions never grant currency or items.

### Phase 3 — world and content quality

**Work:** complete zone registry and unlock rules, add distinct Cloud/Forest/Storm/Crystal/Volcano identities first, then expand only after the vertical slice is stable. Import Godot/Blender outputs through a repeatable checklist. Add traversal landmarks, readable node silhouettes, creature feedback, ambient audio, and reduced-effects mode.

**Exit gate:** each released zone has a purpose, route, resources, creatures, quest content, landmark, performance sample, and visual verification screenshot; no placeholder geometry or placeholder icons in the release slice.

### Phase 4 — social and economy depth

**Work:** complete atomic trading, crafting, marketplace guardrails, parties, guild progression, cooperative events, leaderboard refresh, mailbox overflow, and anti-fraud review. Keep competitive rewards cosmetic/recognition based.

**Exit gate:** two-client trade/guild/party tests pass; all transfers are atomic; disconnects and retries cannot duplicate or destroy items; economy simulation stays within documented bounds.

### Phase 5 — monetization and analytics

**Work:** implement guaranteed cosmetic/convenience products, receipt journal and ProcessReceipt, entitlement reconciliation, shop UI, PolicyService handling for any restricted feature, and funnel/economy telemetry. Create Creator Hub products only when a human owner is ready to review them.

**Exit gate:** purchase flows are testable without spending real Robux where Roblox test mode permits; real product IDs are separated from local/test IDs; every grant is idempotent; copy and UI pass policy review.

### Phase 6 — release candidate and human gate

**Work:** staging publish to a separate place/universe, smoke test, 30-minute soak, multi-client run, mobile/touch review, accessibility review, rollback rehearsal, and human playtest. Fix every reproducible defect before production approval.

**Exit gate:** release checklist is complete, staging evidence is attached, human playtest is explicitly approved, and production publishing is a separate owner-approved action. The autonomous workflow must stop at this gate rather than publish silently.

## Immediate implementation queue

The next executable slices are deliberately small and testable:

1. Reconcile the current status docs with the live source and preserve a machine-readable evidence trail.
2. Add pure modules/tests for upgrade costs, reward grants, trade atomicity, and receipt idempotency.
3. Audit `ServerMain` wiring and every remote against the registry/model.
4. Finish the first-session flow and UI state propagation.
5. Implement a release-safe purchase/entitlement skeleton with no live product IDs.
6. Run Studio bridge status, Rojo serve/build, and local Studio play verification.
7. Commit only focused slices, leaving unrelated user changes untouched.

## Sources

1. Roblox Creator Hub, [Monetization](https://create.roblox.com/docs/production/monetization) — available monetization methods, transparent promotion, and policy-aware product handling.
2. Roblox Creator Hub, [Developer Products](https://create.roblox.com/docs/production/monetization/developer-products) — repeatable products, ProcessReceipt, receipt validation, and test mode.
3. Roblox Creator Hub, [Paid random items policy guidelines](https://create.roblox.com/docs/production/monetization/paid-random-items) — odds disclosure, PolicyService restrictions, and alternatives for restricted users.
4. Roblox Creator Hub, [Analytics](https://create.roblox.com/docs/production/analytics) — retention, engagement, monetization, acquisition, and feedback measurement.
5. Roblox Creator Hub, [Analytics dashboard](https://create.roblox.com/docs/production/analytics/analytics-dashboard) — KPI availability and dashboard requirements.
6. Roblox Creator Hub, [Improve performance](https://create.roblox.com/docs/performance-optimization/improve) — instance streaming and memory guidance.
7. Roblox Creator Hub, [Performance optimization](https://create.roblox.com/docs/performance-optimization) — frame rate, memory, join time, and server heartbeat considerations.
8. Roblox Creator Hub, [Developer Exchange Program](https://create.roblox.com/docs/production/monetization/developer-exchange) — Earned Robux definitions and eligibility caveats.
9. Roblox Creator Hub, [Creator Rewards](https://create.roblox.com/docs/creator-rewards) — current engagement/audience expansion program requirements.
10. Godot Engine, [Complying with licenses](https://docs.godotengine.org/en/stable/about/complying_with_licenses.html) — MIT and third-party attribution requirements for shipped Godot-generated content.
