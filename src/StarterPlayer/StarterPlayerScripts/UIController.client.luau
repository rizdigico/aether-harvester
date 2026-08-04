local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local AetherUI = playerGui:WaitForChild("AetherUI")
local Shared = ReplicatedStorage:WaitForChild("AetherShared")
local GameClient = require(Shared:WaitForChild("Modules"):WaitForChild("GameClient"))
local Remotes = Shared:WaitForChild("Remotes")

local UIController = {}

function UIController:FetchPlayerData()
    local GetPlayerData = Remotes:FindFirstChild("GetPlayerData")
    if GetPlayerData then
        local ok, data = pcall(function()
            return GetPlayerData:InvokeServer()
        end)
        if ok and data then
            GameClient:OnPlayerDataLoaded(data)
        end
    end
end

function UIController:Initialize()
    print("[UIController] Initializing...")

    local Screens = AetherUI:WaitForChild("Screens")
    local HUD = AetherUI:WaitForChild("HUD")

    -- Initial state: only StartingScreen visible, HUD hidden until play
    for _, screen in ipairs(Screens:GetChildren()) do
        if screen:IsA("ScreenGui") then
            screen.Enabled = (screen.Name == "StartingScreen")
        end
    end
    HUD.Enabled = false

    -- StartingScreen buttons
    local SS = Screens:FindFirstChild("StartingScreen")
    if SS then
        local PlayButton = SS:FindFirstChild("PlayButton", true)
        local SettingsButton = SS:FindFirstChild("SettingsButton", true)
        if PlayButton and PlayButton:IsA("TextButton") then
            PlayButton.MouseButton1Click:Connect(function()
                HUD.Enabled = true
                GameClient:OpenScreen("MainMenu")
                self:FetchPlayerData()
            end)
        end
        if SettingsButton and SettingsButton:IsA("TextButton") then
            SettingsButton.MouseButton1Click:Connect(function()
                GameClient:OpenScreen("SettingsScreen")
            end)
        end
    end

    -- MainMenu nav buttons
    local MM = Screens:FindFirstChild("MainMenu")
    if MM then
        local navMap = {
            NavInventory = "InventoryScreen",
            NavQuests = "QuestLogScreen",
            NavPets = "PetScreen",
            NavGuild = "GuildScreen",
            NavSkillTree = "SkillTreeScreen",
            NavMap = "MapScreen",
            NavSettings = "SettingsScreen",
        }
        for buttonName, screenName in pairs(navMap) do
            local btn = MM:FindFirstChild(buttonName, true)
            if btn and btn:IsA("TextButton") then
                btn.MouseButton1Click:Connect(function()
                    GameClient:OpenScreen(screenName)
                end)
            end
        end
    end

    -- Close buttons on every screen
    for _, screen in ipairs(Screens:GetChildren()) do
        if screen:IsA("ScreenGui") then
            local close = screen:FindFirstChild("CloseButton", true)
            if not close then
                close = screen:FindFirstChild("Close", true)
            end
            if close and close:IsA("TextButton") then
                close.MouseButton1Click:Connect(function()
                    GameClient:CloseAllScreens()
                end)
            end
        end
    end

    print("[UIController] Initialized")
end

if playerGui then
    UIController:Initialize()
end
