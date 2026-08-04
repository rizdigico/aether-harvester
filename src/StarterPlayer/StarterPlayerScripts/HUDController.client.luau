local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Wait for HUD to load
local HUD = playerGui:WaitForChild("AetherUI"):WaitForChild("HUD")
local GameClient = require(game.ReplicatedStorage.AetherShared.Modules.GameClient)

-- HUD elements (FindFirstChild - never crash on missing element)
local Elements = {}
for _, name in ipairs({
    "EnergyBar",
    "HealthBar",
    "LevelDisplay",
    "CurrencyDisplay",
    "ToolDisplay",
    "ActiveCreature",
    "NotificationArea",
    "QuestTracker",
}) do
    Elements[name] = HUD:FindFirstChild(name)
end

-- Animation tweens
local TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local HUDController = {}

local initialized = false

function HUDController:Initialize()
    if initialized then
        return
    end
    initialized = true
    print("[HUDController] Initializing...")

    -- Connect to game events
    self:ConnectEvents()

    -- Initial update
    self:UpdateHUD()

    print("[HUDController] Initialized")
end

function HUDController:ConnectEvents()
    -- Update HUD every frame
    RunService.Heartbeat:Connect(function()
        self:UpdateHUD()
    end)

    -- Connect to remote events for updates
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local UpdateHUD = Remotes:FindFirstChild("UpdateHUD")
        if UpdateHUD then
            UpdateHUD.OnClientEvent:Connect(function(data)
                self:OnHUDUpdate(data)
            end)
        end
    end
end

function HUDController:UpdateHUD()
    -- This would normally get data from the server
    -- For now, we'll just update with local state
    local data = GameClient.State

    -- Update level
    if Elements.LevelDisplay then
        Elements.LevelDisplay.Text = "Lv. " .. (data.Level or 1)
    end

    -- Update currency
    local shards = (data.Currency and data.Currency.AetherShards) or 0
    if Elements.CurrencyDisplay then
        Elements.CurrencyDisplay.Text = "Shards: " .. shards
    end

    -- Update tool + creature displays
    if Elements.ToolDisplay then
        Elements.ToolDisplay.Text = "Tool: " .. (data.CurrentTool or "None")
    end
    if Elements.ActiveCreature then
        Elements.ActiveCreature.Text = "Pet: " .. (data.ActivePet and data.ActivePet.Name or "None")
    end

    -- Energy and health bars
    self:UpdateBar(Elements.EnergyBar, data.Energy, data.MaxEnergy)
    self:UpdateBar(Elements.HealthBar, data.Health, data.MaxHealth)
end

function HUDController:OnHUDUpdate(data)
    if data.Energy then
        self:UpdateBar(Elements.EnergyBar, data.Energy, data.MaxEnergy or 100)
    end

    if data.Health then
        self:UpdateBar(Elements.HealthBar, data.Health, data.MaxHealth or 100)
    end

    if data.Level then
        Elements.LevelDisplay.Text = "Lv. " .. data.Level
    end

    if data.Currency then
        Elements.CurrencyDisplay.Text = "Shards: " .. (data.Currency.AetherShards or 0)
    end

    if data.Quest then
        Elements.QuestTracker.Text = data.Quest.Title or "No active quest"
    end
end

function HUDController:UpdateBar(bar, current, max)
    if not bar then
        return
    end

    local fill = bar:FindFirstChild("Fill")
    if fill then
        local percentage = math.clamp(current / max, 0, 1)
        fill.Size = UDim2.new(percentage, 0, 1, 0)

        -- Color based on percentage
        if percentage > 0.5 then
            fill.BackgroundColor3 = Color3.new(0, 1, 0)
        elseif percentage > 0.25 then
            fill.BackgroundColor3 = Color3.new(1, 1, 0)
        else
            fill.BackgroundColor3 = Color3.new(1, 0, 0)
        end
    end
end

function HUDController:ShowNotification(text, color)
    if Elements.NotificationArea then
        local Notification = Elements.NotificationArea.Notification
        if Notification then
            Notification.Text = text
            if color then
                Notification.TextColor3 = color
            end
            Notification.Visible = true

            task.delay(3, function()
                Notification.Visible = false
                Notification.TextColor3 = Color3.new(1, 1, 1)
            end)
        end
    end
end

-- Initialize
HUDController:Initialize()

_G.HUDController = HUDController
