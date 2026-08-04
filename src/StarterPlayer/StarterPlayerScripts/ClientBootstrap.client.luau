local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Wait for game to load
local function waitForGame()
    local GameClient = ReplicatedStorage.AetherShared.Modules:WaitForChild("GameClient")
    return GameClient
end

-- Initialize client
local function initClient()
    print("[ClientBootstrap] Starting client initialization...")

    -- Wait for modules
    local GameClient = waitForGame()

    -- Initialize GameClient
    local client = require(GameClient)
    client:Initialize()

    -- Wait for UI
    local AetherUI = playerGui:WaitForChild("AetherUI", 10)
    if not AetherUI then
        warn("[ClientBootstrap] AetherUI not found")
        return
    end

    -- Initialize HUD
    local HUD = AetherUI:WaitForChild("HUD", 5)
    if HUD then
        local HUDController = _G.HUDController
        if HUDController then
            HUDController:Initialize()
        end
    end

    -- Initialize Minimap
    local MinimapController = _G.MinimapController
    if MinimapController then
        MinimapController:Initialize()
    end

    -- Show StartingScreen for all players (new or returning)
    -- The AetherClient LocalScript handles all screen transitions and HUD state
    if HUD then
        HUD.Enabled = false
    end
    local StartingScreen = AetherUI.Screens:FindFirstChild("StartingScreen")
    if StartingScreen then
        StartingScreen.Enabled = true
    end
    -- Disable all other screens (ensure clean initial state)
    local Screens = AetherUI:FindFirstChild("Screens")
    if Screens then
        for _, screen in ipairs(Screens:GetChildren()) do
            if screen:IsA("ScreenGui") and screen.Name ~= "StartingScreen" then
                screen.Enabled = false
            end
        end
    end
    -- Mark as loaded
    player:SetAttribute("GameLoaded", true)

    print("[ClientBootstrap] Client initialization complete")
end

-- Start when player is ready
if player.PlayerGui then
    initClient()
else
    player.CharacterAdded:Wait()
    player.PlayerGui.ChildAdded:Wait()
    initClient()
end
