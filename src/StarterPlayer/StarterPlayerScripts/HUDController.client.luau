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
local BAR_TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

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

        local ErrorRemote = Remotes:FindFirstChild("Error")
        if ErrorRemote then
            ErrorRemote.OnClientEvent:Connect(function(message)
                self:ShowNotification(tostring(message), Color3.fromRGB(255, 120, 120))
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
        local toolText = data.CurrentTool or "None"
        if data.CurrentTool and type(data.ToolDurability) == "number" and type(data.MaxToolDurability) == "number" then
            toolText = toolText .. " " .. tostring(data.ToolDurability) .. "/" .. tostring(data.MaxToolDurability)
        end
        Elements.ToolDisplay.Text = "Tool: " .. toolText
    end
    if Elements.ActiveCreature then
        Elements.ActiveCreature.Text = "Pet: " .. (data.ActivePet and data.ActivePet.Name or "None")
    end

    -- Energy and health bars
    self:UpdateBar(Elements.EnergyBar, data.Energy, data.MaxEnergy)
    self:UpdateBar(Elements.HealthBar, data.Health, data.MaxHealth)
end

function HUDController:OnHUDUpdate(data)
    if type(data) ~= "table" then
        return
    end

    if type(data.XP) == "number" then
        GameClient.State.XP = data.XP
    end

    if type(data.Energy) == "number" then
        GameClient.State.Energy = data.Energy
        GameClient.State.MaxEnergy = data.MaxEnergy or GameClient.State.MaxEnergy
        self:UpdateBar(Elements.EnergyBar, data.Energy, data.MaxEnergy or 100)
    end

    if type(data.Health) == "number" then
        GameClient.State.Health = data.Health
        GameClient.State.MaxHealth = data.MaxHealth or GameClient.State.MaxHealth
        self:UpdateBar(Elements.HealthBar, data.Health, data.MaxHealth or 100)
    end

    if type(data.Level) == "number" then
        GameClient.State.Level = data.Level
        if Elements.LevelDisplay then
            Elements.LevelDisplay.Text = "Lv. " .. data.Level
        end
    end

    if data.Currency then
        GameClient.State.Currency = data.Currency
        if Elements.CurrencyDisplay then
            Elements.CurrencyDisplay.Text = "Shards: " .. (data.Currency.AetherShards or 0)
        end
    end

    if data.Quest then
        if Elements.QuestTracker then
            Elements.QuestTracker.Text = data.Quest.Title or "No active quest"
        end
    end
end

function HUDController:UpdateBar(bar, current, max)
    if not bar then
        return
    end

    if type(current) ~= "number" or type(max) ~= "number" or max <= 0 then
        return
    end

    local fill = bar:FindFirstChild("Fill")
    if fill then
        local percentage = math.clamp(current / max, 0, 1)
        local previousPercentage = fill:GetAttribute("TargetPercentage")
        if type(previousPercentage) ~= "number" or math.abs(previousPercentage - percentage) > 0.001 then
            fill:SetAttribute("TargetPercentage", percentage)
            TweenService:Create(fill, BAR_TWEEN_INFO, { Size = UDim2.new(percentage, 0, 1, 0) }):Play()
        end

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
        local Notification = Elements.NotificationArea:FindFirstChild("Notification")
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
