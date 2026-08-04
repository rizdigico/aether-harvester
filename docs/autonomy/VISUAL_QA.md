# Visual QA Plan — Aether Harvester

This document defines the deterministic screenshot scenarios used to validate the recovered UI against `docs/design/UI_DESIGN_SYSTEM.md`. Each scenario specifies setup via Roblox Studio MCP, capture name, Kimi review checklist, and accept/reject threshold.

**Scenario count: 15**

---

## Scenario 1: Loading / Boot
- **Setup:** Start play mode in Studio; capture before `StartingScreen` is shown (or force `LoadingScreen` visible if implemented).
- **Studio MCP steps:**
  1. `start_stop_play` → `true`
  2. Wait for client bootstrap; no input for 2 seconds.
- **Capture name:** `01_loading_boot`
- **Kimi review checklist:**
  1. Full-screen overlay covers viewport.
  2. Spinner visible and centered.
  3. Caption uses `--text-caption` / Gotham.
  4. Background is `--bg-deep`.
  5. No UI elements from other screens bleeding through.
- **Accept threshold:** All 5 criteria met; spinner does not overlap text.
- **Reject threshold:** Missing spinner, wrong background color, or unrelated UI visible.

## Scenario 2: Starting Screen
- **Setup:** Force `AetherUI.Screens.StartingScreen` visible; disable HUD.
- **Studio MCP steps:**
  1. `execute_luau` in Edit/Play: `game.StarterGui.AetherUI.Screens.StartingScreen.Enabled = true; game.StarterGui.AetherUI.HUD.Enabled = false`
- **Capture name:** `02_starting_screen`
- **Kimi review checklist:**
  1. Logo "AETHER HARVESTER" legible, centered, no truncation.
  2. "PLAY" button uses primary CTA styling (amber/gold, large, rounded).
  3. "SETTINGS" ghost button present and below PLAY.
  4. Subtitle "SIMULATOR" visible.
  5. Background gradient consistent with design system.
  6. Touch targets ≥ 44px.
- **Accept threshold:** 5 of 6 criteria met; no text overlap.
- **Reject threshold:** Missing CTA or text overlap.

## Scenario 3: Main Menu
- **Setup:** Open `MainMenu` ScreenGui with populated player data.
- **Studio MCP steps:**
  1. Enable `MainMenu`; set `PlayerInfo.PlayerName.Text = "Tester"`; `PlayerLevel.Text = "Lv. 12"`.
- **Capture name:** `03_main_menu`
- **Kimi review checklist:**
  1. Title "AETHER HARVESTER" in title bar.
  2. Player info card shows name and level.
  3. All nav buttons visible: Inventory, Quests, Pets, Guild, Skill Tree, Map, Settings.
  4. Close button in top-right.
  5. Buttons consistent size/radius.
  6. No layout overflow in 16:9 desktop.
- **Accept threshold:** All 6 criteria met.
- **Reject threshold:** Missing nav buttons or misaligned panel.

## Scenario 4: HUD Fresh Join
- **Setup:** Disable all screen GUIs except HUD; simulate fresh player data.
- **Studio MCP steps:**
  1. Disable all `Screens.*`; enable `HUD`.
  2. Set `LevelDisplay.Text = "Lv. 1"`, `CurrencyDisplay.Text = "Shards: 0"`, `ToolDisplay.Text = "Tool: None"`, `ActiveCreature.Text = "Pet: None"`, `QuestTracker.Text = "No active quest"`.
- **Capture name:** `04_hud_fresh_join`
- **Kimi review checklist:**
  1. EnergyBar top-left, HealthBar top-right.
  2. LevelDisplay and CurrencyDisplay top-left below bars.
  3. ToolDisplay and ActiveCreature bottom-left.
  4. MinimapFrame bottom-right.
  5. NotificationArea top-right.
  6. QuestTracker top-right below HealthBar.
  7. All text readable against background; no overlap.
- **Accept threshold:** 6 of 7 criteria met.
- **Reject threshold:** HUD elements overlap or unreadable.

## Scenario 5: Harvest Action
- **Setup:** Trigger harvest progress UI during gameplay.
- **Studio MCP steps:**
  1. Enable HUD; invoke client harvest loop or create a `HarvestProgress` frame if absent.
  2. Capture while progress ring/bar is 50%.
- **Capture name:** `05_harvest_action`
- **Kimi review checklist:**
  1. Progress indicator visible and centered bottom.
  2. EnergyBar depletes during harvest.
  3. No screen-blocking elements.
  4. HUD remains readable.
  5. Feedback (toast/notification) appears within 100ms if implemented.
- **Accept threshold:** All 5 criteria met.
- **Reject threshold:** Progress hidden or HUD unreadable during action.

## Scenario 6: Inventory with Items
- **Setup:** Open `InventoryScreen`; populate `ItemTemplate` clones with sample data.
- **Studio MCP steps:**
  1. Enable `InventoryScreen`; hide others.
  2. Clone `ItemTemplate` 6 times into `Content`; set names/counts/rarity colors.
- **Capture name:** `06_inventory_items`
- **Kimi review checklist:**
  1. Title "INVENTORY" visible.
  2. TabBar present: Items, Equipment, Resources, Crafting.
  3. Grid layout with 4+ items.
  4. Each item has icon, name, count.
  5. Rarity colors applied per design system.
  6. ScrollContainer works if items exceed viewport.
  7. EmptyState hidden when items present.
- **Accept threshold:** 6 of 7 criteria met.
- **Reject threshold:** Items not rendering or no rarity distinction.

## Scenario 7: Quest Log Active Quest
- **Setup:** Open `QuestLogScreen`; clone active quest from `QuestTemplate`.
- **Studio MCP steps:**
  1. Enable `QuestLogScreen`; hide others.
  2. Clone `QuestTemplate`; set `QuestName`, `QuestDesc`, `QuestProgress.Text = "2/5"`; hide `QuestCheck`.
- **Capture name:** `07_quest_log_active`
- **Kimi review checklist:**
  1. Title "QUEST LOG" visible.
  2. Active quest card shows title, description, progress.
  3. Progress text uses numeral style.
  4. Description limited to 2 lines.
  5. EmptyState hidden.
  6. Card uses `--bg-dim` / radius.
- **Accept threshold:** All 6 criteria met.
- **Reject threshold:** Missing progress or text overflow.

## Scenario 8: Pets with a Pet
- **Setup:** Open `PetScreen`; clone `PetTemplate` and show detail panel.
- **Studio MCP steps:**
  1. Enable `PetScreen`; hide others.
  2. Clone `PetTemplate` 3 times into `PetScroll`; set one as equipped (`PetActiveBadge.Visible = true`).
  3. Select first pet; populate `PetDetail.DetailStats` stat rows.
- **Capture name:** `08_pets_with_pet`
- **Kimi review checklist:**
  1. Title "PET COMPANION" visible.
  2. Pet list left, detail panel right.
  3. Pet cards show icon, name, level, rarity, equip button.
  4. Equipped badge visible on active pet.
  5. Detail panel shows stats bars with fill.
  6. Rarity color on pet name or badge.
- **Accept threshold:** 5 of 6 criteria met.
- **Reject threshold:** Detail panel empty or missing equipped state.

## Scenario 9: Settings
- **Setup:** Open `SettingsScreen`.
- **Studio MCP steps:**
  1. Enable `SettingsScreen`; hide others.
  2. Leave default values for Music 50%, SFX 70%, Quality "High".
- **Capture name:** `09_settings`
- **Kimi review checklist:**
  1. Title "SETTINGS" visible.
  2. Audio section label present.
  3. Music and SFX sliders visible with fill.
  4. Graphics section label present.
  5. Quality dropdown and Fullscreen toggle visible.
  6. Close button present.
  7. Touch targets ≥ 44px for toggles/dropdown.
- **Accept threshold:** 6 of 7 criteria met.
- **Reject threshold:** Missing audio or graphics controls.

## Scenario 10: Map
- **Setup:** Open `MapScreen` with all markers visible.
- **Studio MCP steps:**
  1. Enable `MapScreen`; hide others.
  2. Ensure all location markers visible; set `LocationMarker.Text = "Current: CloudGardens"`.
- **Capture name:** `10_map`
- **Kimi review checklist:**
  1. Title "MAP" visible.
  2. MapBG area visible.
  3. All 5 location markers rendered.
  4. Current location label visible.
  5. Markers use distinct colors/icons.
  6. Close button present.
  7. Map does not overflow panel bounds.
- **Accept threshold:** 6 of 7 criteria met.
- **Reject threshold:** Missing markers or map overflow.

## Scenario 11: Mobile Portrait
- **Setup:** Resize Studio viewport to 390×844; open `MainMenu` and `InventoryScreen`.
- **Studio MCP steps:**
  1. Use device simulator or resize viewport to 390×844.
  2. Capture `MainMenu` then `InventoryScreen`.
- **Capture name:** `11_mobile_portrait_menu` / `11_mobile_portrait_inventory`
- **Kimi review checklist:**
  1. Panel fits within viewport; no horizontal scroll.
  2. Text remains readable at mobile scale.
  3. Buttons scale to touch targets ≥ 44px.
  4. Inventory grid reduces to 3 columns.
  5. No clipped elements.
- **Accept threshold:** All 5 criteria met.
- **Reject threshold:** Horizontal scroll or clipped UI.

## Scenario 12: Mobile Landscape
- **Setup:** Resize Studio viewport to 844×390; capture HUD and `MainMenu`.
- **Studio MCP steps:**
  1. Resize viewport to 844×390.
  2. Enable HUD and MainMenu separately.
- **Capture name:** `12_mobile_landscape_hud` / `12_mobile_landscape_menu`
- **Kimi review checklist:**
  1. HUD compresses vertically; no overlap.
  2. Menu panel uses available width without overflow.
  3. Touch targets ≥ 44px.
  4. Safe-area offsets respected if simulator supports.
  5. Text remains readable.
- **Accept threshold:** 4 of 5 criteria met.
- **Reject threshold:** HUD overlap or menu overflow.

## Scenario 13: Tablet
- **Setup:** Resize Studio viewport to 1024×768; open `PetScreen` and `SkillTreeScreen`.
- **Studio MCP steps:**
  1. Resize viewport to 1024×768.
  2. Capture `PetScreen` and `SkillTreeScreen`.
- **Capture name:** `13_tablet_pets` / `13_tablet_skilltree`
- **Kimi review checklist:**
  1. Side-by-side panels use tablet width appropriately.
  2. No excessive whitespace or crowding.
  3. Skill nodes visible on canvas.
  4. Text and touch targets still ≥ 44px.
  5. Panel radius and shadows consistent.
- **Accept threshold:** 4 of 5 criteria met.
- **Reject threshold:** Panels unusable or excessive whitespace.

## Scenario 14: Low Graphics
- **Setup:** Set graphics quality to lowest level; capture HUD and `MainMenu`.
- **Studio MCP steps:**
  1. Set `UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic` or lowest.
  2. Capture HUD and MainMenu.
- **Capture name:** `14_low_graphics_hud` / `14_low_graphics_menu`
- **Kimi review checklist:**
  1. UI still renders correctly at low quality.
  2. Gradients and shadows remain visible (fallback acceptable).
  3. Text readable.
  4. No missing UI elements due to quality culling.
- **Accept threshold:** All 4 criteria met.
- **Reject threshold:** UI invisible or severely degraded.

## Scenario 15: Error State
- **Setup:** Trigger error overlay or display failure state.
- **Studio MCP steps:**
  1. If no error screen exists, create a temporary `ErrorFrame` with red accent, message, Retry and Report buttons.
  2. Otherwise enable existing error screen.
- **Capture name:** `15_error_state`
- **Kimi review checklist:**
  1. Error icon or red accent visible.
  2. Plain-language error message readable.
  3. "Retry" primary button visible.
  4. "Report" ghost button visible if spec'd.
  5. No blameful or technical jargon.
- **Accept threshold:** 4 of 5 criteria met.
- **Reject threshold:** Missing Retry or unreadable error message.

---

## Capture Workflow
1. Build/sync place via `rojo build`.
2. Launch Studio play mode.
3. Run `scripts/capture-screenshot.lua` (or Studio MCP screen_capture) for each scenario.
4. Save to `tests/current/<capture_name>.png`.
5. Run Kimi review checklist against each capture.
6. Record PASS/REJECT and defects in `docs/autonomy/VISUAL_QA_FINDINGS.md`.

## Acceptance Summary
- **Total scenarios:** 14
- **Minimum passing:** 12 of 14 scenarios PASS; any critical scenario (1, 2, 4, 6) must PASS.
- **Critical scenarios:** Loading/Boot, Starting Screen, HUD Fresh Join, Inventory with Items.
