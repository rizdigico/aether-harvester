--
-- HUD.luau
-- Main HUD controller for Aether Harvester Simulator
--

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Create HUD frame
local HUDFrame = Instance.new("ScreenGui")
HUDFrame.Name = "HUDFrame"
HUDFrame.Parent = PlayerGui

-- Create main HUD container
local HUDContainer = Instance.new("Frame")
HUDContainer.Name = "HUDContainer"
HUDContainer.Size = UDim2.new(1, 0, 1, 0)
HUDContainer.Position = UDim2.new(0, 0, 0, 0)
HUDContainer.BackgroundTransparency = 1
HUDContainer.Parent = HUDFrame

-- Create player info panel
local PlayerInfoPanel = Instance.new("Frame")
PlayerInfoPanel.Name = "PlayerInfoPanel"
PlayerInfoPanel.Size = UDim2.new(0, 200, 0, 100)
PlayerInfoPanel.Position = UDim2.new(0, 10, 0, 10)
PlayerInfoPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerInfoPanel.BackgroundTransparency = 0.5
PlayerInfoPanel.BorderSizePixel = 2
PlayerInfoPanel.BorderColor3 = Color3.fromRGB(100, 100, 100)
PlayerInfoPanel.Parent = HUDContainer

-- Create player name label
local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Name = "PlayerNameLabel"
PlayerNameLabel.Size = UDim2.new(1, 0, 0, 25)
PlayerNameLabel.Position = UDim2.new(0, 0, 0, 0)
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Text = "Player Name"
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.TextSize = 18
PlayerNameLabel.Font = Enum.Font.GothamBold
PlayerNameLabel.Parent = PlayerInfoPanel

-- Create XP and level labels
local XPLabel = Instance.new("TextLabel")
XPLabel.Name = "XPLabel"
XPLabel.Size = UDim2.new(1, 0, 0, 25)
XPLabel.Position = UDim2.new(0, 0, 0, 30)
XPLabel.BackgroundTransparency = 1
XPLabel.Text = "XP: 0"
XPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
XPLabel.TextSize = 16
XPLabel.Font = Enum.Font.Gotham
XPLabel.Parent = PlayerInfoPanel

local LevelLabel = Instance.new("TextLabel")
LevelLabel.Name = "LevelLabel"
LevelLabel.Size = UDim2.new(1, 0, 0, 25)
LevelLabel.Position = UDim2.new(0, 0, 0, 60)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Text = "Level: 1"
LevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LevelLabel.TextSize = 16
LevelLabel.Font = Enum.Font.Gotham
LevelLabel.Parent = PlayerInfoPanel

-- Create quests panel
local QuestsPanel = Instance.new("Frame")
QuestsPanel.Name = "QuestsPanel"
QuestsPanel.Size = UDim2.new(0, 200, 0, 150)
QuestsPanel.Position = UDim2.new(0, 10, 0, 120)
QuestsPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
QuestsPanel.BackgroundTransparency = 0.5
QuestsPanel.BorderSizePixel = 2
QuestsPanel.BorderColor3 = Color3.fromRGB(100, 100, 100)
QuestsPanel.Parent = HUDContainer

-- Create quests title label
local QuestsTitleLabel = Instance.new("TextLabel")
QuestsTitleLabel.Name = "QuestsTitleLabel"
QuestsTitleLabel.Size = UDim2.new(1, 0, 0, 25)
QuestsTitleLabel.Position = UDim2.new(0, 0, 0, 0)
QuestsTitleLabel.BackgroundTransparency = 1
QuestsTitleLabel.Text = "Quests"
QuestsTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
QuestsTitleLabel.TextSize = 18
QuestsTitleLabel.Font = Enum.Font.GothamBold
QuestsTitleLabel.Parent = QuestsPanel

-- Create quests list
local QuestsList = Instance.new("ScrollingFrame")
QuestsList.Name = "QuestsList"
QuestsList.Size = UDim2.new(1, 0, 0, 125)
QuestsList.Position = UDim2.new(0, 0, 0, 30)
QuestsList.BackgroundTransparency = 1
QuestsList.ScrollBarThickness = 5
QuestsList.CanvasSize = UDim2.new(0, 0, 0, 0)
QuestsList.Parent = QuestsPanel

-- Function to update player info
local function updatePlayerInfo(xp: number, level: number)
    XPLabel.Text = "XP: " .. xp
    LevelLabel.Text = "Level: " .. level
end

-- Function to update quests
local function updateQuests(quests: table)
    -- Clear existing quests
    for _, child in ipairs(QuestsList:GetChildren()) do
        child:Destroy()
    end

    -- Add new quests
    for questId, questData in pairs(quests) do
        local questFrame = Instance.new("Frame")
        questFrame.Size = UDim2.new(1, 0, 0, 30)
        questFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        questFrame.BorderSizePixel = 0
        questFrame.Parent = QuestsList

        local questTitleLabel = Instance.new("TextLabel")
        questTitleLabel.Name = "QuestTitleLabel"
        questTitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
        questTitleLabel.Position = UDim2.new(0, 0, 0, 0)
        questTitleLabel.BackgroundTransparency = 1
        questTitleLabel.Text = questData.quest.name
        questTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        questTitleLabel.TextSize = 14
        questTitleLabel.Font = Enum.Font.Gotham
        questTitleLabel.Parent = questFrame

        local questProgressLabel = Instance.new("TextLabel")
        questProgressLabel.Name = "QuestProgressLabel"
        questProgressLabel.Size = UDim2.new(0.2, 0, 1, 0)
        questProgressLabel.Position = UDim2.new(0.8, 0, 0, 0)
        questProgressLabel.BackgroundTransparency = 1
        questProgressLabel.Text = "0/%"
        questProgressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        questProgressLabel.TextSize = 14
        questProgressLabel.Font = Enum.Font.Gotham
        questProgressLabel.Parent = questFrame
    end

    -- Update canvas size
    QuestsList.CanvasSize = UDim2.new(0, 0, 0, QuestsList.AbsoluteSize.Y)
end

-- Function to update player name
local function updatePlayerName(name: string)
    PlayerNameLabel.Text = name
end

-- Connect to remote events
local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("HUDEvents")
if remoteEvents then
    remoteEvents.OnClientEvent:Connect(function(action, ...)
        if action == "update_player_info" then
            local xp, level = ...
            updatePlayerInfo(xp, level)
        elseif action == "update_quests" then
            local quests = ...
            updateQuests(quests)
        elseif action == "update_player_name" then
            local name = ...
            updatePlayerName(name)
        end
    end)
end

-- Initialize HUD with player data
local function initializeHUD()
    updatePlayerName(Player.Name)
    updatePlayerInfo(0, 1) -- Default values
    updateQuests({})
end

-- Initialize HUD
initializeHUD()
