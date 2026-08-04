--!strict
-- UIBootstrap: runtime entry that builds the AetherUI hierarchy from the Screens builder.
-- Mirrors the ServerBootstrap guarded pattern: only build what's missing, so a live place
-- with pre-built UI (Screens Folder + HUD ScreenGui) is left untouched when Rojo-synced.
--
-- Produced runtime shape under PlayerGui.AetherUI:
--   Screens (Folder)  <- 12 ScreenGuis
--   HUD    (ScreenGui)   (sibling of Screens)
--   ...    (bootstrap + component modules cloned from StarterGui)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

-- 1. Ensure the AetherUI folder exists under PlayerGui.
local AetherUI = playerGui:FindFirstChild("AetherUI")
if not AetherUI then
    AetherUI = Instance.new("Folder")
    AetherUI.Name = "AetherUI"
    AetherUI.Parent = playerGui
end

-- 2. Build the Screens folder + HUD only if the built result is missing.
--    The builder is a ModuleScript named "Screens" (child of AetherUI); requiring it
--    parents a Folder "Screens" to AetherUI and a ScreenGui "HUD" as an AetherUI sibling.
--    We only rebuild when no Folder "Screens" already exists (live place has pre-built UI).
local builtScreens = AetherUI:FindFirstChild("Screens")
if not builtScreens or not builtScreens:IsA("Folder") then
    local builder = script.Parent:FindFirstChild("Screens")
    if builder and builder:IsA("ModuleScript") then
        builtScreens = require(builder)
        -- The builder's output Folder is also named "Screens". Rename the builder module so
        -- the Folder owns the "Screens" name and ClientBootstrap's FindFirstChild resolves to it.
        builder.Name = "ScreensBuilder"
    end
end

print("[UIBootstrap] AetherUI ready. Screens:", tostring(builtScreens))
