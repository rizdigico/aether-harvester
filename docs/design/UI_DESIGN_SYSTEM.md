# Aether Harvester — UI Design System

## 1. Design Principles

- **Clarity:** Every element communicates its purpose in under 200ms. Text labels beat icon-only ambiguity.
- **Hierarchy:** Rarity and urgency drive visual weight. A mythril item must look more important than a white item before the player reads the name.
- **Feedback:** Every action echoes within 100ms. Buttons depress, progress bars fill, toasts slide in.
- **Consistency:** Same component = same behavior everywhere. A `PrimaryButton` on the Shop and on Settings behaves identically.
- **Delight:** Neon glows, starfield particles, and rarity shimmer reward attention without obscuring information.

---

## 2. Token System

### 2.1 Color Tokens

#### Semantic Colors
| Token | Hex | RGB | Usage |
|---|---|---|---|
| `--bg-deep` | `#0a0c14` | 10, 12, 20 | Full-screen background behind game view |
| `--bg-base` | `#141623` | 20, 22, 35 | Panel/card base (from existing revamp) |
| `--bg-dim` | `#1a1d2e` | 26, 29, 46 | Secondary panels, list rows |
| `--bg-elevated` | `#222639` | 34, 38, 57 | Modals, dropdowns, popovers |
| `--aether-cyan` | `#64C8FF` | 100, 200, 255 | Primary accent, interactive highlights |
| `--aether-cyan-dim` | `#3a8ab3` | 58, 138, 179 | Disabled accents, hover states |
| `--text-primary` | `#e8eaf6` | 232, 234, 246 | Headings, body text |
| `--text-secondary` | `#9aa0b8` | 154, 160, 184 | Captions, disabled text |
| `--border-subtle` | `#2a2e42` | 42, 46, 66 | Dividers, input borders |
| `--success` | `#34d399` | 52, 211, 153 | Positive actions, gains |
| `--warning` | `#fbbf24` | 251, 191, 36 | Low energy, time-sensitive |
| `--danger` | `#f87171` | 248, 113, 113 | Sell/delete, errors |
| `--focus-ring` | `#64C8FF` | 100, 200, 255 | Keyboard/gamepad focus indicator |

#### Rarity Colors
| Rarity | Token | Hex | RGB |
|---|---|---|---|
| Common | `--rarity-common` | `#e8eaf6` | 232, 234, 246 (white) |
| Uncommon | `--rarity-uncommon` | `#34d399` | 52, 211, 153 (green) |
| Rare | `--rarity-rare` | `#60a5fa` | 96, 165, 250 (blue) |
| Epic | `--rarity-epic` | `#a78bfa` | 167, 139, 250 (purple) |
| Legendary | `--rarity-legendary` | `#fbbf24` | 251, 191, 36 (gold) |
| Mythril | `--rarity-mythril` | `#f0abfc` | 240, 171, 252 (pink-mythril) |

### 2.2 Typography Scale
| Token | Font Family | Weight | Size | Line Height | Usage |
|---|---|---|---|---|---|
| `--text-h1` | Space Grotesk | 700 | 32px | 38px | Screen titles |
| `--text-h2` | Space Grotesk | 600 | 24px | 30px | Section headers |
| `--text-h3` | Space Grotesk | 500 | 20px | 26px | Card titles, tabs |
| `--text-body` | Space Grotesk | 400 | 16px | 24px | Body copy, descriptions |
| `--text-caption` | Space Grotesk | 300 | 12px | 16px | Labels, timestamps |
| `--text-button` | Space Grotesk | 500 | 14px | 18px | Button text |
| `--text-numeral` | Space Grotesk | 700 | 20px | 24px | Currency, stats, counters |

### 2.3 Spacing Scale
| Token | Value | Usage |
|---|---|---|
| `--sp-2` | 4px | Icon padding, tight gaps |
| `--sp-3` | 8px | Small gaps, icon-to-text |
| `--sp-4` | 12px | Compact lists, card padding |
| `--sp-5` | 16px | Default padding, form fields |
| `--sp-6` | 24px | Section gaps, card margins |
| `--sp-8` | 32px | Screen padding, large blocks |
| `--sp-10` | 48px | Hero spacing, full-width breaks |

### 2.4 Corner Radius
| Token | Value | Usage |
|---|---|---|
| `--radius-sm` | 4px | Badges, small toggles |
| `--radius-md` | 8px | Buttons, inputs, cards |
| `--radius-lg` | 12px | Panels, modals |
| `--radius-xl` | 16px | Large cards, featured items |
| `--radius-full` | 9999px | Pills, avatars, toggles |

### 2.5 Stroke Weights
| Token | Value | Usage |
|---|---|---|
| `--stroke-thin` | 1px | Dividers, subtle borders |
| `--stroke-medium` | 2px | Input borders, active tabs |
| `--stroke-thick` | 3px | Focus rings, rarity frames |

### 2.6 Shadow System
| Token | Blur | Offset | Color | Usage |
|---|---|---|---|---|
| `--shadow-sm` | 4px | 0 2px | `rgba(0,0,0,0.3)` | Elevated cards |
| `--shadow-md` | 8px | 0 4px | `rgba(0,0,0,0.4)` | Panels, dropdowns |
| `--shadow-lg` | 16px | 0 8px | `rgba(0,0,0,0.5)` | Modals, toasts |
| `--shadow-glow` | 12px | 0 0 | `rgba(100,200,255,0.25)` | Aether accent elements |

### 2.7 Surface Hierarchy
| Layer | Token | Z-Index Band |
|---|---|---|
| Background | `--bg-deep` | 0 |
| Panel | `--bg-base` | 10 |
| Dim Panel | `--bg-dim` | 20 |
| Elevated | `--bg-elevated` | 30 |
| Overlay | `--bg-overlay` | 40 |
| Modal | `--bg-modal` | 50 |
| Toast | `--bg-toast` | 60 |
| Tooltip | `--bg-tooltip` | 70 |

### 2.8 Animation Timings
| Token | Duration | Easing | Usage |
|---|---|---|---|
| `--ease-fast` | 100ms | ease-out | Button press, toggle |
| `--ease-base` | 200ms | ease-out | Panel open, list item enter |
| `--ease-slow` | 400ms | ease-in-out | Screen transition, modal |
| `--ease-glow` | 1200ms | ease-in-out | Idle aether pulse |

### 2.9 Sound Feedback Mapping
| Action | Sound Cue | Priority |
|---|---|---|
| Button press | Soft click | High |
| Tab switch | Subtle whoosh | Medium |
| Item pickup | Chime (pitch by rarity) | High |
| Level up | Ascending arpeggio | High |
| Error | Low buzz | Medium |
| Notification in | Gentle ping | Medium |
| Currency gain | Coin rattle | High |

---

## 3. Component Library Spec

### 3.1 Button
| Variant | Background | Text | Border | Shadow |
|---|---|---|---|---|
| Primary | `--aether-cyan` | `--bg-deep` | none | `--shadow-glow` |
| Secondary | `--bg-elevated` | `--text-primary` | `--border-subtle` | none |
| Danger | `--danger` | white | none | none |
| Ghost | transparent | `--text-secondary` | none | none |

- **Sizes:** Compact (32px), Default (44px), Large (56px)
- **States:** Disabled (opacity 0.4, no interaction), Loading (spinner right, text "…"), Hover (brightness +10%), Active (scale 0.97)
- **Minimum touch target:** 44 × 44px

### 3.2 Panel
- Background `--bg-base`, border `--border-subtle` (1px), radius `--radius-lg`
- Optional header with `--text-h3` title and close/action button
- Padding `--sp-6`; internal sections separated by `--sp-4`

### 3.3 Card
- Background `--bg-dim`, border `--border-subtle`, radius `--radius-xl`
- Hover: translateY(-2px), shadow `--shadow-md`
- Image/icon area (top), content area (bottom)
- Used for: inventory items, pets, shop listings

### 3.4 Tooltip
- Background `--bg-elevated`, border `--border-subtle`, radius `--radius-md`
- Max width 280px, padding `--sp-4`
- Arrow pointing to anchor
- Delay 400ms show, 200ms hide

### 3.5 Modal
- Overlay: `--bg-overlay` (rgba(10,12,20,0.85))
- Container: `--bg-elevated`, radius `--radius-lg`, max-width 520px
- Header (title + close), body (scrollable), footer (actions)
- Animation: scale 0.95 → 1, opacity 0 → 1, `--ease-slow`

### 3.6 Toast
- Background `--bg-elevated`, left border 3px colored by type
- Slide from right, auto-dismiss 4000ms
- Types: info (cyan), success (green), warning (yellow), error (red)

### 3.7 ListItem
- Height 56px, padding `--sp-5`
- Left icon slot (40px), center text, right action/chevron
- Hover: `--bg-elevated`; Active: `--bg-dim`
- Divider: `--border-subtle` at bottom (except last)

### 3.8 TabBar
- Height 44px, background `--bg-dim`
- Active tab: bottom border 2px `--aether-cyan`, text `--text-primary`
- Inactive tab: text `--text-secondary`
- Swipeable on mobile; keyboard arrow navigation on desktop/gamepad

### 3.9 Slider
- Track height 4px, background `--border-subtle`
- Fill: `--aether-cyan`
- Thumb: 20px circle, `--bg-elevated`, border 2px `--aether-cyan`
- Touch target 44px tall; show value bubble on drag

### 3.10 Toggle
- Track 44 × 24px, radius `--radius-full`
- Off: `--bg-dim`; On: `--aether-cyan-dim`
- Thumb: 20px circle, white; translateX(20px) when on
- Label left, toggle right

### 3.11 Input
- Height 44px, background `--bg-elevated`, border 1px `--border-subtle`
- Focus: border `--aether-cyan`, shadow `--shadow-glow`
- Placeholder: `--text-secondary` at 50% opacity
- Error state: border `--danger`, helper text below in `--text-caption`

### 3.12 Badge
- Height 20px, padding `--sp-2` `--sp-3`, radius `--radius-full`
- Background `--aether-cyan`, text `--bg-deep`, weight 700
- Dot variant: 8px circle, no text

### 3.13 ProgressBar
- Track height 8px, background `--border-subtle`, radius `--radius-full`
- Fill height 8px, background gradient `--aether-cyan` → `--aether-cyan-dim`
- Label above: `--text-caption`
- Animated fill duration `--ease-base`

### 3.14 CurrencyDisplay
- Icon (16px) + numeral (`--text-numeral`) + label (`--text-caption`)
- Layout: horizontal, gap `--sp-2`
- Color by currency type (aether = cyan, coins = gold, gems = purple)

### 3.15 RarityFrame
- Outer border 2px solid rarity color
- Inner glow 4px blur rarity color at 30% opacity
- Corner accents: small diamond at each corner
- Background gradient: `--bg-dim` to rarity color at 8% opacity

### 3.16 EmptyState
- Icon (64px, `--text-secondary` at 40%), title `--text-h3`, body `--text-body`
- CTA button centered below
- Vertical stack, gap `--sp-6`

### 3.17 LoadingSpinner
- 40px ring, 3px stroke `--border-subtle`
- Spinning arc: `--aether-cyan`, 80% opacity
- Duration 800ms linear infinite
- Label: `--text-caption` below

### 3.18 ScrollContainer
- Padding `--sp-5`
- Scrollbar: 4px wide, `--border-subtle` track, `--aether-cyan` thumb
- Overscroll glow: radial gradient `--aether-cyan` at 15% opacity, 100px radius
- Momentum scroll enabled; snap on mobile for carousels

---

## 4. Screen-by-Screen Layout Spec

### 4.1 HUD (Heads-Up Display)
**Context:** Persistent during gameplay. Safe-area aware.

| Element | Anchor | Offset | Notes |
|---|---|---|---|
| Energy Bar | Top-left | 12px from edges | Horizontal bar, 200×12px. Regenerates with `--aether-cyan` fill. Tooltip on hover/press. |
| Health Bar | Top-right | 12px from edges | Mirror of Energy. Flashes red below 20%. |
| Level Display | Top-center | 12px from top | Large numeral + "Lv". Particle burst on level up. |
| Quest Tracker | Top-right (below Health) | 8px gap | Collapsible. Shows 1 active quest by default. |
| Tool Slots | Bottom-left | 16px from edges | 2×2 grid, 48px slots. Active slot has `--aether-cyan` border. |
| Active Pet | Bottom-right | 16px from edges | Circular avatar 56px + 4px rarity ring + tiny health bar. |
| Harvest Progress | Bottom-center | 16px from bottom | Circular 48px ring. Rotates during active harvest. |
| Currency Display | Top-left (below Energy) | 8px gap | Aether, Coins, Gems. Compact horizontal stack. |
| Notifications | Top-center | 12px from top, 80px below level | Stack up to 3. Slide in, auto-dismiss. |
| Menu Button | Top-left (below currencies) | 8px gap | 44×44px ghost button. Opens radial menu on gamepad. |
| Chat Bubble | Bottom-left (above tools) | 8px gap | Expandable. Latest message preview. |

**Safe Area:** All HUD elements inset at least 12px from safe-area guides. On notched devices, respect `env(safe-area-inset-*)`.

### 4.2 Inventory
- **Header:** Title "Inventory" + CurrencyDisplay + Sort/Filter buttons (right)
- **TabBar:** All / Weapons / Tools / Consumables / Materials / Pets
- **Grid:** Responsive columns (3 mobile, 4 tablet, 5 desktop). 56px slot size.
- **Item Card:** RarityFrame + icon + quantity badge + name (caption). Tap opens detail Modal.
- **Detail Modal:** Large RarityFrame, stats list, Action buttons (Equip, Sell, Drop).
- **Empty State:** When tab is empty.

### 4.3 Quest Log
- **TabBar:** Active / Completed / Daily
- **Active List:** Each quest is a Card. Shows title, description (2 lines max), progress bar, reward preview.
- **Completed List:** Dimmed cards, checkmark overlay, "Claim" button for unclaimed rewards.
- **Detail Panel:** Slide-in from right on desktop/tablet; full-screen modal on mobile.

### 4.4 Pet Management
- **Header:** "Pets" + count badge + "Summon" button (primary)
- **Grid:** Same responsive logic as Inventory. Pet cards show avatar, name, rarity, level.
- **Detail View:** Large avatar, stats bars (HP, Energy, Attack, Speed), ability list, equip slots.
- **Formation Slots:** 3 active slots at bottom. Drag-and-drop on desktop; tap-to-assign on mobile.

### 4.5 Upgrade
- **Header:** "Upgrades" + current level indicator
- **List:** Grouped by category (Tool, Pet, Backpack, Energy). Each row: icon, name, current level, next-level preview, cost, "Upgrade" button.
- **Cost Display:** CurrencyDisplay inside button or adjacent.
- **Maxed State:** Button disabled, text "MAX", green accent.

### 4.6 Shop / Monetization
- **TabBar:** Featured / Currency Packs / Cosmetics / Battle Pass
- **Featured Carousel:** Horizontal scroll, snap. Large Card with image, title, discount badge, CTA.
- **Currency Packs:** Grid of cards. Each shows amount, price (real-world), bonus percentage, "Buy" button.
- **Ethics Guardrails:** All prices shown in local currency upfront. No countdown timers on purchase pages. No pre-checked bundles.
- **Receipt Modal:** After purchase, show item name, price, transaction ID, "Done" button. No upsell modal on close.

### 4.7 Settings
- **Sections:** Graphics, Audio, Controls, Accessibility, Account
- **Graphics:** Toggle grid (Shadows, Particles, VSync). Slider for Render Scale.
- **Audio:** Sliders (0–100) for Master, Music, SFX. Mute toggles per channel.
- **Controls:** Keybind list with "Rebind" button per action. Gamepad layout preview.
- **Accessibility:** Font size slider (80%–150%), Colorblind mode dropdown, Reduced motion toggle.

### 4.8 Achievements
- **TabBar:** All / In Progress / Completed
- **Grid:** Cards with icon, title, description, progress bar, reward.
- **Rarity indicator:** Border color matches reward rarity.
- **Completion animation:** Confetti + toast when last achievement in a set completes.

### 4.9 Leaderboards
- **TabBar:** Global / Friends / Guild
- **List:** Top 10 rows. Each row: rank (1–3 have gold/silver/bronze accent), avatar, name, score.
- **Player Row:** Highlighted with `--aether-cyan` left border. Auto-scrolls into view.
- **Refresh:** Pull-to-refresh on mobile; manual "Refresh" button on desktop.

### 4.10 Events
- **Timeline:** Vertical list of event cards.
- **Active Event:** Highlighted border `--aether-cyan`, countdown timer, progress bar, "Participate" button.
- **Past Event:** Dimmed, "View Results" link.
- **Preview:** Hover/tap shows reward ladder.

### 4.11 Codes
- **Input Field:** Large text input + "Redeem" button.
- **History:** List of redeemed codes with status (Success / Already Used / Expired).
- **Feedback:** Toast on redeem. Error shake animation on invalid input.

### 4.12 Notifications
- **Inbox:** Reverse-chronological list.
- **Types:** System (cyan), Reward (green), Social (purple), Urgent (red).
- **Actions:** "Claim", "Dismiss", "Navigate". Swipe to dismiss on mobile.

### 4.13 Loading / Failure States
- **Loading:** Full-screen overlay, `--shadow-glow` spinner, "Harvesting aether…" caption, sub-caption with tip.
- **Failure:** Red accent, error icon, plain-language message, "Retry" primary button, "Report" ghost button.
- **Offline:** Same overlay, message "No signal. Progress saved locally.", auto-retry indicator.

---

## 5. Responsive Rules

### 5.1 Breakpoints
| Name | Width | Layout Notes |
|---|---|---|
| Mobile Portrait | < 640px | Single column, bottom nav or hamburger, 3-col grid |
| Mobile Landscape | 640–840px | 4-col grid, HUD elements compress vertically |
| Tablet | 840–1024px | 4–5 col grid, side panels allowed |
| Desktop | > 1024px | 5–6 col grid, persistent side nav, HUD can be semi-transparent |

### 5.2 Adaptive Behaviors
- **Typography:** Base size scales 14px (mobile) → 16px (tablet) → 16px (desktop). User scaling ±30% via Accessibility setting.
- **Touch Targets:** Minimum 44×44px on touch devices. On desktop, can drop to 32px for secondary actions but keep 44px for primary.
- **HUD Density:** Mobile shows 3 HUD elements max; desktop shows all 8. Tapping a collapsed HUD element expands it.
- **Input Methods:** 
  - Touch: Swipe, tap, long-press (context menu).
  - Mouse: Hover tooltips, scroll wheel, drag-and-drop.
  - Gamepad: D-pad / left stick navigates focus ring. A confirms, B backs, Y opens context, X activates primary action. Focus ring animates with `--ease-fast`.

---

## 6. Accessibility

### 6.1 Contrast Ratios
- `--text-primary` on `--bg-base`: 12.6:1 (AAA)
- `--text-secondary` on `--bg-base`: 5.8:1 (AA)
- `--aether-cyan` on `--bg-deep`: 7.2:1 (AA)
- All interactive states maintain ≥ 3:1 against adjacent surfaces.

### 6.2 Text Scaling
- System supports 80%, 100%, 120%, 150% via rem-based sizing.
- At 150%, grids collapse columns before text truncates.
- No horizontal scroll below 120% scale on any breakpoint.

### 6.3 Reduced Motion
- Toggle disables all non-essential animations.
- Remaining motion: opacity transitions only (≤ 100ms).
- Particle effects and parallax are suppressed.
- Screen transitions become instant fades.

### 6.4 Screen Reader
- All interactive elements have `aria-label`.
- Icon-only buttons have descriptive labels.
- Toast and modal focus trap: focus moves into modal on open, returns on close.
- Live regions for dynamic updates (currency change, quest progress).

---

## 7. Monetization UI Ethics

### 7.1 Clear Pricing
- Every offer shows final price, currency, and billing period (if subscription) in the button label itself: "Buy 1000 Aether — $4.99".
- No fine-print-only terms. "Restores every 24h" shown adjacent to daily pack.

### 7.2 No Dark Patterns
- No countdown timers on purchase pages.
- No pre-selected bundles or auto-renew toggles.
- No fake scarcity ("Only 2 left!") unless the limit is real and disclosed.
- No hiding the "No thanks" / close button.

### 7.3 Confirm Dialogs
- Any purchase ≥ $9.99 triggers a confirmation modal showing item, price, and "Cancel / Confirm".
- Subscription changes show a summary modal before processing.
- Post-purchase receipt is shown; no auto-redirect to another offer.

### 7.4 Refund Path
- Settings > Account > Purchase History. Each entry has "Request Refund" button linking to platform store flow.
- No guilt messaging or retention friction on refund request.
