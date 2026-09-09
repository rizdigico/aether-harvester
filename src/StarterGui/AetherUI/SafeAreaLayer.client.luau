--!strict
-- SafeAreaLayer: applies mobile safe-area insets to every AetherUI screen so HUD and
-- panel content never collides with notches, punch-holes, or the top status bar.
-- Mobile-first: insets on top/bottom (plus sides where a device reports them).
-- Desktop: all insets are zero, so this is a no-op.
--
-- Approach: for every ScreenGui root Frame under PlayerGui.AetherUI (Screens/* + HUD),
-- we add/refresh a single UIPadding whose offsets equal the safe-area insets, clamped
-- to a small maximum so we never over-shove desktop content. We re-apply on
-- ViewportChanged and whenever a new ScreenGui appears (AetherUI.ChildAdded).
--
-- The ScreenGui "SafeAreaLayer" is a holder with IgnoreGuiInset=true so its root
-- children are laid out against the true viewport, matching the design system's
-- "inset at least 12px from safe-area guides" rule (see UI_DESIGN_SYSTEM.md §4.1).

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Clamp so desktop (zero insets) is untouched and we never push a panel off-screen.
local MAX_INSET = 48

-- Track paddings we created so we can update in place on rotation / window resize.
local paddings = {} :: { [Instance]: UIPadding }

-- Read safe-area insets with a pcall guard: some platforms/API states throw, and we
-- never want a UI helper to break the boot sequence.
local function getInsets(): (number, number, number, number)
    local top, bottom, left, right = 0, 0, 0, 0
    local ok, guiInset = pcall(function()
        return GuiService:GetGuiInset()
    end)
    if ok and guiInset then
        top = guiInset.Y
    end

    local ok2, safeArea = pcall(function()
        return UserInputService:GetSafeAreaInsets()
    end)
    if ok2 and safeArea then
        top = math.max(top, safeArea.Top)
        bottom = math.max(bottom, safeArea.Bottom)
        left = math.max(left, safeArea.Left)
        right = math.max(right, safeArea.Right)
    end

    -- Clamp to a sane bound; negative values from a flaky API are treated as zero.
    top = math.clamp(top, 0, MAX_INSET)
    bottom = math.clamp(bottom, 0, MAX_INSET)
    left = math.clamp(left, 0, MAX_INSET)
    right = math.clamp(right, 0, MAX_INSET)
    return top, bottom, left, right
end

-- Apply insets to a single root frame. We create a UIPadding on first sight and
-- refresh its offsets thereafter, so children laid out with UIPadding-based components
-- automatically keep clear of the unsafe region.
local function applyToRoot(root: Instance)
    if not root:IsA("GuiObject") or root.Name == "Background" then
        return
    end

    local top, bottom, left, right = getInsets()
    local padding = paddings[root]
    if not padding then
        local createdPadding = Instance.new("UIPadding")
        createdPadding.Name = "SafeAreaPadding"
        createdPadding.Parent = root
        paddings[root] = createdPadding
        padding = createdPadding
    end

    local activePadding = padding :: UIPadding
    activePadding.PaddingTop = UDim.new(0, top)
    activePadding.PaddingBottom = UDim.new(0, bottom)
    activePadding.PaddingLeft = UDim.new(0, left)
    activePadding.PaddingRight = UDim.new(0, right)
end

-- Walk a ScreenGui's direct children and apply to any root GuiObject (Frame/ScrollingFrame).
local function applyToScreen(screen: Instance)
    for _, child in ipairs(screen:GetChildren()) do
        if child:IsA("GuiObject") then
            applyToRoot(child)
        end
    end
end

-- Scan the whole AetherUI tree: every ScreenGui in the Screens folder plus the HUD sibling.
local function applyAll()
    local playerGui = player:WaitForChild("PlayerGui")
    local aetherUI = playerGui:FindFirstChild("AetherUI")
    if not aetherUI then
        return
    end

    for _, child in ipairs(aetherUI:GetChildren()) do
        if child:IsA("ScreenGui") then
            applyToScreen(child)
        elseif child.Name == "Screens" then
            for _, screen in ipairs(child:GetChildren()) do
                if screen:IsA("ScreenGui") then
                    applyToScreen(screen)
                end
            end
        end
    end
end

-- Main entry: set up the holder, run a first scan, then keep in sync.
local function init()
    local playerGui = player:WaitForChild("PlayerGui")

    -- Holder ScreenGui (IgnoreGuiInset = true so insets are not double-applied by Roblox).
    local holder = Instance.new("ScreenGui")
    holder.Name = "SafeAreaLayer"
    holder.IgnoreGuiInset = true
    holder.ResetOnSpawn = false
    holder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    holder.Parent = playerGui

    applyAll()

    -- Recompute when the window is resized / rotated (safe areas change on notch rotation).
    GuiService.ViewportChanged:Connect(applyAll)

    -- Recompute when a screen is (re)built by the Screens builder (AetherUI.ChildAdded).
    -- Wait for AetherUI first so we never miss the connection during async boot, and
    -- re-apply now that the tree exists (the first applyAll() may have run too early).
    local aetherUI = playerGui:WaitForChild("AetherUI", 15)
    if aetherUI then
        applyAll()
        aetherUI.ChildAdded:Connect(function(_child)
            task.defer(applyAll)
        end)
    end
end

task.defer(init)
