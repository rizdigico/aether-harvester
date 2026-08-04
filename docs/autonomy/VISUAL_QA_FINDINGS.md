# Recovered UI Review — Aether Harvester

> **Scope:** Structural source-code review of `src/StarterGui/AetherUI/Screens.luau` and `src/StarterGui/AetherUI/Components/Theme.luau` against `docs/design/UI_DESIGN_SYSTEM.md`. No live screenshots were captured in this session; findings flagged `[SCREENSHOT REQUIRED]` need real-time visual confirmation.

```json
{
  "review_type": "recovered_ui_structural",
  "screens_reviewed": [
    "StartingScreen", "MainMenu", "InventoryScreen", "QuestLogScreen",
    "PetScreen", "MapScreen", "SettingsScreen", "SkillTreeScreen",
    "EventScreen", "RewardsScreen", "TradeWindow", "GuildScreen", "HUD"
  ],
  "total_findings": 18,
  "critical": 3,
  "major": 7,
  "minor": 8,
  "screenshot_required_count": 9,
  "top_5_findings": [
    {"severity": "critical", "screen": "HUD", "problem": "HUD parented to AetherUI instead of AetherUI.Screens, conflicting with ClientBootstrap expectation"},
    {"severity": "critical", "screen": "HUD", "problem": "LevelDisplay, CurrencyDisplay, ToolDisplay, ActiveCreature use TextSize=1, so text is effectively invisible"},
    {"severity": "critical", "screen": "HUD", "problem": "EnergyBar and HealthBar are top-left stacked instead of top-left/top-right mirrored per spec"},
    {"severity": "major", "screen": "Inventory", "problem": "Tabs are Items/Equipment/Resources/Crafting instead of design-spec All/Weapons/Tools/Consumables/Materials/Pets"},
    {"severity": "major", "screen": "Settings", "problem": "Missing Accessibility, Controls, Account sections; no reduced-motion toggle, font-size slider, or colorblind dropdown"}
  ],
  "status": " structural_review_complete_pending_screenshots"
}
```

---

## Executive Summary

The recovered `Screens.luau` is a deterministic reconstruction of the original StarterGui tree. It produces all 13 named screen GUIs plus the HUD, but the recovered implementation deviates from the design system in hierarchy, typography, color tokens, and responsive layout. The most severe issues are in the HUD: elements are parented outside the `Screens` folder, key readouts use `TextSize = 1`, and the Energy/Health bar placement does not mirror the spec. Without live screenshots, precise visual severity cannot be confirmed; the findings below identify structural mismatches that are highly likely to produce visible defects.

---

## Per-Screen Findings

### HUD
- **Hierarchy verdict:** ❌ Does not match design system. The HUD `ScreenGui` is created and parented directly to `AetherUI`, while all other screens are parented to `AetherUI.Screens`. Per the recovered source comment and project memory, ClientBootstrap expects `AetherUI.HUD`, but the design system treats screens as a unified folder. This is a structural inconsistency.
- **Component usage:** ⚠️ Mixed. Uses custom Frame/TextLabel constructions rather than shared `Components`. No `CurrencyDisplay` component; currency is a single TextLabel with hard-coded amber text.
- **States present:** ⚠️ Only default state. No low-health flash, no level-up particle burst, no toast animations, no collapsed mobile state.
- **Findings:**
  - **Critical:** `LevelDisplay.TextSize = 1`, `CurrencyDisplay.TextSize = 1`, `ToolDisplay.TextSize = 1`, `ActiveCreature.TextSize = 1` — these labels will be unreadable. [SCREENSHOT REQUIRED]
  - **Critical:** `EnergyBar` and `HealthBar` are both anchored top-left (`AnchorPoint 0,0`, positions 0.02,0.02 and 0.02,0.055). Spec says HealthBar should be top-right mirrored.
  - **Critical:** HUD not inside `Screens` folder; may break screen-management scripts that iterate `AetherUI.Screens:GetChildren()`.
  - **Major:** `NotificationArea` uses `BackgroundColor3` of `#0a0a12`-ish but no border or toast styling; spec expects elevated toasts with left-color border.
  - **Major:** `QuestTracker` is a plain TextLabel at top-right; spec wants a collapsible panel below HealthBar.
  - **Major:** Tool slots and active pet / harvest progress UI are missing from recovered HUD.
  - **Minor:** HUD backgrounds use `BackgroundTransparency = 0.5` on TextLabels; spec prefers solid `--bg-base` panels.
  - **Minor:** `MinimapFrame.PlayerDot` is green; spec does not define dot color, but markers should be recognizable.

### StartingScreen
- **Hierarchy verdict:** ⚠️ Mostly matches. Has logo, subtitle, PLAY, SETTINGS, loading text.
- **Component usage:** ⚠️ Buttons are raw TextButtons, not `PrimaryButton`/`GhostButton` components.
- **States present:** ⚠️ Default only; no loading spinner overlay state.
- **Findings:**
  - **Major:** No loading spinner; spec requires full-screen loading overlay with `--shadow-glow` spinner.
  - **Minor:** PLAY button uses amber (`#ff9e4d`) not `--aether-cyan` primary accent. [SCREENSHOT REQUIRED]
  - **Minor:** SETTINGS button is a dark secondary button, not the ghost style from the component spec.

### MainMenu
- **Hierarchy verdict:** ⚠️ Partial. Has title bar, player info, nav container.
- **Component usage:** ⚠️ Nav buttons are raw TextButtons; no shared component usage.
- **States present:** ⚠️ Default only; no hover/active state definitions.
- **Findings:**
  - **Major:** `CloseButton` exists as a direct child of `MainMenu` ScreenGui at `Position = 0.92,0.25` with `Size = 0.08,0.5`, but the panel itself is at `0.225,0.15 / 0.55,0.7`. The close button is not inside the panel, risking misalignment. [SCREENSHOT REQUIRED]
  - **Major:** No currency display in header; design system header for many screens expects `CurrencyDisplay`.
  - **Minor:** Nav buttons lack icons; spec does not strictly require icons, but labels alone reduce clarity on touch.

### InventoryScreen
- **Hierarchy verdict:** ⚠️ Partial. Has title bar, tab bar, scrolling content grid, item template.
- **Component usage:** ⚠️ Uses raw frames; no `RarityFrame` component.
- **States present:** ⚠️ Empty state visible; item template exists but hidden.
- **Findings:**
  - **Major:** Tabs are `Items / Equipment / Resources / Crafting`, not the design-spec tabs `All / Weapons / Tools / Consumables / Materials / Pets`.
  - **Major:** `ItemTemplate` does not use `RarityFrame`; there is no rarity border, glow, or corner diamonds.
  - **Major:** `UIGridLayout` has no cell size or padding set in recovered source; layout may collapse or produce uneven cells. [SCREENSHOT REQUIRED]
  - **Minor:** No sort/filter buttons in header; spec expects them.
  - **Minor:** No detail modal; item tap behavior cannot be verified structurally.

### QuestLogScreen
- **Hierarchy verdict:** ⚠️ Partial. Title bar, scrolling quest list, quest template.
- **Component usage:** ⚠️ No `Card` or `ProgressBar` components; quest row is a raw frame.
- **States present:** ⚠️ Empty state and active template; completed checkmark hidden.
- **Findings:**
  - **Major:** No TabBar for Active/Completed/Daily; spec requires it.
  - **Major:** No progress bar in quest row; only a progress text label.
  - **Major:** No reward preview in quest row.
  - **Minor:** Quest description is 30% height; spec says 2 lines max, which may be okay but needs screenshot.

### PetScreen
- **Hierarchy verdict:** ⚠️ Partial. Has split list/detail layout.
- **Component usage:** ⚠️ No shared `Card`/`ProgressBar` components.
- **States present:** ⚠️ Equipped badge, detail stats.
- **Findings:**
  - **Major:** Pet list uses `UIListLayout` with no padding set; rows may stick together. [SCREENSHOT REQUIRED]
  - **Major:** Pet rarity label is plain gray text; spec wants rarity-colored indicators.
  - **Major:** No formation slots at bottom; spec requires 3 active slots.
  - **Minor:** `PetDetail.DetailHeader` centered but rest left-aligned; alignment inconsistency.

### MapScreen
- **Hierarchy verdict:** ⚠️ Partial. Title bar, map content, location markers.
- **Component usage:** ⚠️ Uses raw frames; no map-specific component.
- **States present:** ⚠️ Default only.
- **Findings:**
  - **Major:** All markers are identical green squares; spec expects visually distinct location markers.
  - **Major:** No player position arrow; only a green dot inside `MapBG` is missing — the player dot lives in `MinimapFrame` on the HUD, not the map.
  - **Minor:** No zoom/pan controls or teleport button.

### SettingsScreen
- **Hierarchy verdict:** ⚠️ Partial. Audio sliders and two graphics toggles only.
- **Component usage:** ⚠️ No `Slider`/`Toggle`/`Dropdown` components.
- **States present:** ⚠️ Default values shown.
- **Findings:**
  - **Major:** Missing entire sections: Graphics toggles are reduced to Quality dropdown and Fullscreen toggle; no Shadows/Particles/VSync toggles, no Render Scale slider.
  - **Major:** Missing Accessibility section entirely: no font-size slider, colorblind dropdown, or reduced-motion toggle.
  - **Major:** Missing Controls section: no keybind list or gamepad preview.
  - **Major:** Missing Account section.
  - **Major:** Sliders are frame-fill pairs with invisible `ClickArea` buttons; no visible thumb or value bubble. [SCREENSHOT REQUIRED]
  - **Minor:** `FullscreenToggle` is a text button, not the spec toggle component.

### SkillTreeScreen
- **Hierarchy verdict:** ⚠️ Partial. Canvas + detail panel + node template.
- **Component usage:** ⚠️ Raw frames.
- **States present:** ⚠️ Node template hidden.
- **Findings:**
  - **Major:** `SkillCanvas` size is `0.6,-10,0.83,-10` but uses no scrolling content size; nodes may not layout.
  - **Major:** `SkillNodeTemplate` is 50×50 px with no dynamic layout; spec expects connected nodes with lines.
  - **Minor:** Detail panel title defaults to "Select a skill"; acceptable but plain.

### EventScreen
- **Hierarchy verdict:** ⚠️ Partial. Title bar, event list, event template.
- **Component usage:** ⚠️ Raw frames.
- **States present:** ⚠️ Empty state and hidden template.
- **Findings:**
  - **Major:** No active-event highlighting or countdown styling per spec.
  - **Major:** JOIN button uses amber, not primary cyan.
  - **Minor:** No reward ladder preview.

### RewardsScreen
- **Hierarchy verdict:** ⚠️ Basic. Title bar + rewards list.
- **Component usage:** ⚠️ Raw frames.
- **States present:** ⚠️ Empty state only.
- **Findings:**
  - **Major:** No reward item template; list cannot show claimable items structurally.
  - **Minor:** Title is "REWARDS", not "Achievements" or "Inbox"; ambiguous scope.

### TradeWindow
- **Hierarchy verdict:** ⚠️ Partial. Player list + trade slots + confirm.
- **Component usage:** ⚠️ Raw frames.
- **States present:** ⚠️ Empty state.
- **Findings:**
  - **Major:** Trade slots have no item grid or inventory selection UI.
  - **Major:** No currency/confirmation safeguards; monetization ethics cannot be verified.
  - **Minor:** No status labels (e.g., "Ready").

### GuildScreen
- **Hierarchy verdict:** ⚠️ Partial. Guild info + member list.
- **Component usage:** ⚠️ Raw frames.
- **States present:** ⚠️ Empty state.
- **Findings:**
  - **Major:** No member template; member list cannot render populated rows.
  - **Major:** No guild actions (join, leave, donate).
  - **Minor:** Guild XP bar fill color is amber, not success/cyan.

---

## HUD Token / Contrast Review

| Element | Spec token | Recovered value | Risk |
|---|---|---|---|
| HUD panel base | `--bg-base` `#141623` | `#0a0a12` / black at 50% transparency | Low contrast with `#0a0c14` background; may look muddy. [SCREENSHOT REQUIRED] |
| Energy fill | `--aether-cyan` gradient | `#ff9e4d` amber | Wrong semantic color; energy should be cyan. |
| Health fill | `--danger` red | `#e63946` red | Close to spec; acceptable. |
| Currency text | `--aether-cyan` for shards | `#ff9e4d` amber | Color mismatch. |
| Primary text | `--text-primary` `#e8eaf6` | `#e6ecf5` | Close enough. |
| Secondary text | `--text-secondary` `#9aa0b8` | `#8c97aa` | Close enough. |
| Title accent | `--aether-cyan` `#64C8FF` | `#64dcff` | Close enough. |

**Readability risks:**
- `TextSize = 1` on four HUD readouts is the biggest risk; text will be unreadable regardless of color.
- TextLabels with `BackgroundTransparency = 0.5` over dark world backgrounds may be hard to read at low brightness.
- Spec requires 12px minimum safe-area insets; recovered offsets are 0.02 scale (~19px at 1080p), which may not satisfy notched-device safe areas.

---

## Findings Requiring Screenshot Confirmation

1. `[SCREENSHOT REQUIRED]` HUD readout text visibility due to `TextSize = 1`.
2. `[SCREENSHOT REQUIRED]` Close button alignment in MainMenu outside panel bounds.
3. `[SCREENSHOT REQUIRED]` Inventory grid cell sizing and padding.
4. `[SCREENSHOT REQUIRED]` Quest description two-line truncation behavior.
5. `[SCREENSHOT REQUIRED]` Pet list row spacing.
6. `[SCREENSHOT REQUIRED]` Settings slider thumb/value bubble visibility.
7. `[SCREENSHOT REQUIRED]` StartingScreen PLAY/SETTINGS button contrast and hierarchy.
8. `[SCREENSHOT REQUIRED]` HUD background transparency readability over live world.
9. `[SCREENSHOT REQUIRED]` Skill tree node layout inside scrolling canvas.

---

## Recommended Fix Priority

### Critical (block release)
1. Move HUD into `AetherUI.Screens` or update ClientBootstrap to expect `AetherUI.HUD`; do not leave ambiguous.
2. Set readable `TextSize` values on `LevelDisplay`, `CurrencyDisplay`, `ToolDisplay`, `ActiveCreature` (e.g., 16–20 px).
3. Mirror `HealthBar` to top-right per design system.

### Major (next sprint)
4. Reconcile Inventory tabs with design system or update design system to match recovered tabs.
5. Implement `RarityFrame` on inventory/pet items.
6. Add missing Settings sections (Accessibility, Controls, Account) and proper toggle/slider components.
7. Add TabBar to Quest Log with progress bars and reward previews.
8. Add formation slots to PetScreen.
9. Build reward item template for RewardsScreen.

### Minor (polish)
10. Standardize button colors: primary actions should use `--aether-cyan` unless intentionally amber.
11. Add safe-area padding offset for notched devices.
12. Replace TextLabel HUD backgrounds with `--bg-base` panels for better contrast.
