local GameClient = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- A client-only signal lets presentation layers render on actual state changes
-- instead of polling every frame. Server-originated remotes remain the source
-- of truth; this only coordinates local presentation.
GameClient.StateChanged = Instance.new("BindableEvent")
GameClient.StateRevision = 0

function GameClient:NotifyStateChanged()
    self.StateRevision += 1
    self.StateChanged:Fire(self.StateRevision)
end

-- Client state
GameClient.State = {
    CurrentIsland = "CloudGardens",
    CurrentNode = nil,
    IsHarvesting = false,
    CurrentTool = "basic_pickaxe",
    ToolDurability = 100,
    MaxToolDurability = 100,
    ActivePet = nil,
    Level = 1,
    XP = 0,
    MaxEnergy = 100,
    Energy = 100,
    MaxHealth = 100,
    Health = 100,
    Currency = { AetherShards = 0, AetherGems = 0, EventTokens = 0, FamePoints = 0 },
    Inventory = {},
    PetInventory = {},
    Quests = {},
    Settings = {
        MusicVolume = 0.5,
        SFXVolume = 0.7,
        GraphicsQuality = "High",
    },
}

-- Initialize client
function GameClient.Initialize()
    print("[GameClient] Initializing...")

    -- Setup remotes
    local Remotes = ReplicatedStorage.AetherShared.Remotes
    GameClient.Remotes = Remotes

    -- Connect to remote events
    GameClient:ConnectRemotes()

    -- Setup input
    GameClient:SetupInput()

    -- Load settings
    GameClient:LoadSettings()

    print("[GameClient] Initialized successfully")
end

function GameClient:ConnectRemotes()
    if not self.Remotes then
        return
    end

    -- Node harvested
    local NodeHarvested = self.Remotes:FindFirstChild("NodeHarvested")
    if NodeHarvested then
        NodeHarvested.OnClientEvent:Connect(function(nodeId, rewards)
            self:OnNodeHarvested(nodeId, rewards)
        end)
    end

    -- Player data loaded
    local PlayerDataLoaded = self.Remotes:FindFirstChild("PlayerDataLoaded")
    if PlayerDataLoaded then
        PlayerDataLoaded.OnClientEvent:Connect(function(data)
            self:OnPlayerDataLoaded(data)
        end)
    end

    -- Quest updated
    local QuestUpdated = self.Remotes:FindFirstChild("QuestUpdated")
    if QuestUpdated then
        QuestUpdated.OnClientEvent:Connect(function(questData)
            self:OnQuestUpdated(questData)
        end)
    end

    -- Level up
    local PlayerLeveledUp = self.Remotes:FindFirstChild("PlayerLeveledUp")
    if PlayerLeveledUp then
        PlayerLeveledUp.OnClientEvent:Connect(function(newLevel, skillPoints)
            self:OnPlayerLeveledUp(newLevel, skillPoints)
        end)
    end

    -- Achievement unlocked
    local AchievementUnlocked = self.Remotes:FindFirstChild("AchievementUnlocked")
    if AchievementUnlocked then
        AchievementUnlocked.OnClientEvent:Connect(function(achievementId)
            self:OnAchievementUnlocked(achievementId)
        end)
    end

    -- Pet summoned: show active pet in HUD
    local PetSummon = self.Remotes:FindFirstChild("PetSummon")
    if PetSummon then
        PetSummon.OnClientEvent:Connect(function(petId)
            local PetsData = require(game.ReplicatedStorage.AetherShared.Data.Pets)
            local def = PetsData.GetPet(petId)
            self.State.ActivePet = def and { Name = def.Name, PetId = petId } or { Name = petId, PetId = petId }
            self:NotifyStateChanged()
        end)
    end

    -- Pet released
    local PetReleased = self.Remotes:FindFirstChild("PetReleased")
    if PetReleased then
        PetReleased.OnClientEvent:Connect(function()
            self.State.ActivePet = nil
            self:NotifyStateChanged()
        end)
    end

    -- Upgrade purchased: refresh currency + purchased levels
    local UpgradePurchased = self.Remotes:FindFirstChild("UpgradePurchased")
    if UpgradePurchased then
        UpgradePurchased.OnClientEvent:Connect(function(upgradeId, level, currency)
            self.State.Upgrades = self.State.Upgrades or {}
            self.State.Upgrades[upgradeId] = level
            if currency then
                self.State.Currency = currency
            end
            self:NotifyStateChanged()
        end)
    end

    local ItemUsed = self.Remotes:FindFirstChild("ItemUsed")
    if ItemUsed then
        ItemUsed.OnClientEvent:Connect(function(itemId, remainingCount, vitals)
            self:OnItemUsed(itemId, remainingCount, vitals)
        end)
    end

    local ToolUpdated = self.Remotes:FindFirstChild("ToolUpdated")
    if ToolUpdated then
        ToolUpdated.OnClientEvent:Connect(function(snapshot)
            self:OnToolUpdated(snapshot)
        end)
    end
end

function GameClient:SetupInput()
    -- Input will be handled by InputHandler
    print("[GameClient] Input setup delegated to InputHandler")
end

function GameClient:LoadSettings()
    -- Settings persist per-player via attributes (DataStore is server-only; client uses attributes)
    -- Load from local storage if available
    local player = Players.LocalPlayer
    if player then
        local saved = player:GetAttribute("Settings")
        if saved then
            self.State.Settings = saved
        end
    end
end

function GameClient:SaveSettings()
    local player = Players.LocalPlayer
    if player then
        player:SetAttribute("Settings", self.State.Settings)
    end
end

-- Event handlers
function GameClient:OnNodeHarvested(nodeId, rewards)
    print("[GameClient] Node harvested: " .. nodeId)

    -- The server is authoritative. The event itself is server-originated, so
    -- mirroring the item stack locally is safe for immediate inventory UX, but
    -- never convert a resource into wallet currency or mutate a wallet that
    -- the server did not grant.
    self.State.Inventory = self.State.Inventory or {}
    if type(rewards) == "table" then
        for itemId, amount in pairs(rewards) do
            if type(itemId) == "string" and type(amount) == "number" and amount > 0 then
                self.State.Inventory[itemId] = (self.State.Inventory[itemId] or 0) + amount
            end
        end
    end

    -- Show rewards popup
    local rewardText = "Harvested: "
    local items = {}
    if type(rewards) == "table" then
        for itemId, amount in pairs(rewards) do
            table.insert(items, tostring(itemId) .. " x" .. tostring(amount))
        end
    end
    rewardText = rewardText .. table.concat(items, ", ")

    -- Notify HUD
    local HUD = Players.LocalPlayer and Players.LocalPlayer.PlayerGui.AetherUI.HUD
    if HUD then
        local Notification = HUD.NotificationArea.Notification
        if Notification then
            Notification.Text = rewardText
            Notification.Visible = true
            task.delay(3, function()
                Notification.Visible = false
            end)
        end
    end
    self:NotifyStateChanged()
end

function GameClient:OnPlayerDataLoaded(data)
    if type(data) ~= "table" then
        return
    end
    print("[GameClient] Player data loaded")
    GameClient.State.Level = data.Level or 1
    GameClient.State.XP = data.XP or 0
    GameClient.State.Currency = data.Currency or GameClient.State.Currency
    GameClient.State.Inventory = data.Inventory or {}
    GameClient.State.PetInventory = data.PetInventory or {}
    GameClient.State.Quests = data.Quests or {}
    GameClient.State.Settings = data.Settings or GameClient.State.Settings
    if type(data.Energy) == "number" then
        GameClient.State.Energy = data.Energy
    end
    if type(data.MaxEnergy) == "number" then
        GameClient.State.MaxEnergy = data.MaxEnergy
    end
    GameClient.State.CurrentTool = data.EquippedTool or GameClient.State.CurrentTool
    if type(data.ToolDurability) == "table" and GameClient.State.CurrentTool then
        GameClient.State.ToolDurability = data.ToolDurability[GameClient.State.CurrentTool]
            or GameClient.State.ToolDurability
    end

    -- Notify HUD to refresh immediately
    if self.OnDataUpdated then
        self:OnDataUpdated()
    end
    self:NotifyStateChanged()
end

function GameClient:OnItemUsed(itemId, remainingCount, vitals)
    if type(itemId) == "string" and type(remainingCount) == "number" then
        self.State.Inventory = self.State.Inventory or {}
        if remainingCount > 0 then
            self.State.Inventory[itemId] = remainingCount
        else
            self.State.Inventory[itemId] = nil
        end
    end
    if type(vitals) == "table" then
        if type(vitals.Energy) == "number" then
            self.State.Energy = vitals.Energy
        end
        if type(vitals.MaxEnergy) == "number" then
            self.State.MaxEnergy = vitals.MaxEnergy
        end
    end
    self:NotifyStateChanged()
end

function GameClient:OnToolUpdated(snapshot)
    if type(snapshot) ~= "table" then
        return
    end
    self.State.CurrentTool = snapshot.EquippedTool or self.State.CurrentTool
    if type(snapshot.Durability) == "number" then
        self.State.ToolDurability = snapshot.Durability
    end
    if type(snapshot.MaxDurability) == "number" then
        self.State.MaxToolDurability = snapshot.MaxDurability
    end
    self:NotifyStateChanged()
end

function GameClient:OnQuestUpdated(questData)
    print("[GameClient] Quest updated")
    -- Update quest tracker in HUD
    local HUD = Players.LocalPlayer and Players.LocalPlayer.PlayerGui.AetherUI.HUD
    if HUD and HUD.QuestTracker then
        HUD.QuestTracker.Text = "Quest: " .. (questData.Title or "Unknown")
    end
end

function GameClient:OnPlayerLeveledUp(newLevel, _skillPoints)
    if type(newLevel) == "number" then
        self.State.Level = newLevel
        self:NotifyStateChanged()
    end
    print("[GameClient] Level up! New level: " .. newLevel)

    -- Show level up notification
    local HUD = Players.LocalPlayer and Players.LocalPlayer.PlayerGui.AetherUI.HUD
    if HUD then
        local Notification = HUD.NotificationArea.Notification
        if Notification then
            Notification.Text = "Level Up! You are now level " .. newLevel .. "!"
            Notification.TextColor3 = Color3.new(1, 1, 0)
            Notification.Visible = true
            task.delay(3, function()
                Notification.Visible = false
                Notification.TextColor3 = Color3.new(1, 1, 1)
            end)
        end
    end
end

function GameClient:OnAchievementUnlocked(payload)
    -- Payload is either a single achievement table, a list of achievement tables,
    -- or (legacy) a bare achievement id string. Handle all shapes.
    local items = {}
    if type(payload) == "table" then
        if payload.Id or payload.Title then
            items = { payload }
        else
            for _, a in ipairs(payload) do
                if type(a) == "table" then
                    items[#items + 1] = a
                end
            end
        end
    elseif type(payload) == "string" then
        items = { { Id = payload, Title = payload } }
    end

    for _, achievement in ipairs(items) do
        local name = achievement.Title or achievement.Id or "Unknown"
        print("[GameClient] Achievement unlocked: " .. tostring(name))

        -- Show achievement popup
        local HUD = Players.LocalPlayer and Players.LocalPlayer.PlayerGui.AetherUI.HUD
        if HUD then
            local Notification = HUD.NotificationArea.Notification
            if Notification then
                Notification.Text = "Achievement Unlocked: " .. tostring(name)
                Notification.TextColor3 = Color3.new(1, 0.5, 0)
                Notification.Visible = true
                task.delay(3, function()
                    Notification.Visible = false
                    Notification.TextColor3 = Color3.new(1, 1, 1)
                end)
            end
        end
    end
end

-- Utility functions
function GameClient:GetCurrentIsland()
    return self.State.CurrentIsland
end

function GameClient:SetCurrentIsland(islandId)
    self.State.CurrentIsland = islandId
    local Remotes = self.Remotes
    if Remotes then
        local ChangeIsland = Remotes:FindFirstChild("ChangeIsland")
        if ChangeIsland then
            ChangeIsland:FireServer(islandId)
        end
    end
end

function GameClient:HarvestNode(nodeId)
    if self.State.IsHarvesting then
        return
    end

    self.State.IsHarvesting = true
    self.State.CurrentNode = nodeId

    local Remotes = self.Remotes
    if Remotes then
        local HarvestNode = Remotes:FindFirstChild("HarvestResource")
        if HarvestNode then
            HarvestNode:FireServer(nodeId)
        end
    end

    -- Reset harvesting state after delay
    task.delay(2, function()
        self.State.IsHarvesting = false
        self.State.CurrentNode = nil
    end)
end

function GameClient:EquipPet(petId)
    self.State.ActivePet = petId
    local Remotes = self.Remotes
    if Remotes then
        local EquipPet = Remotes:FindFirstChild("EquipPet")
        if EquipPet then
            EquipPet:FireServer(petId)
        end
    end
end

function GameClient:UseItem(itemId)
    if type(itemId) ~= "string" then
        return
    end
    local Remotes = self.Remotes
    local UseItem = Remotes and Remotes:FindFirstChild("UseItem")
    if UseItem then
        UseItem:FireServer(itemId)
    end
end

function GameClient:EquipTool(toolId)
    if type(toolId) ~= "string" then
        return
    end
    local Remotes = self.Remotes
    local EquipTool = Remotes and Remotes:FindFirstChild("EquipTool")
    if EquipTool then
        EquipTool:FireServer(toolId)
    end
end

function GameClient:AcceptQuest(questId)
    local Remotes = self.Remotes
    if Remotes then
        local AcceptQuest = Remotes:FindFirstChild("AcceptQuest")
        if AcceptQuest then
            AcceptQuest:FireServer(questId)
        end
    end
end

function GameClient:DeliverQuest(questId)
    local Remotes = self.Remotes
    if Remotes then
        local DeliverQuest = Remotes:FindFirstChild("DeliverQuest")
        if DeliverQuest then
            DeliverQuest:FireServer(questId)
        end
    end
end

function GameClient:OpenScreen(screenName)
    local PlayerGui = Players.LocalPlayer and Players.LocalPlayer.PlayerGui
    if not PlayerGui then
        return
    end

    local Screens = PlayerGui.AetherUI.Screens
    if not Screens then
        return
    end

    -- Hide all screens
    for _, screen in ipairs(Screens:GetChildren()) do
        if screen:IsA("ScreenGui") then
            screen.Enabled = false
        end
    end

    -- Show requested screen
    local targetScreen = Screens:FindFirstChild(screenName)
    if targetScreen then
        targetScreen.Enabled = true
    end
end

function GameClient:CloseAllScreens()
    local PlayerGui = Players.LocalPlayer and Players.LocalPlayer.PlayerGui
    if not PlayerGui then
        return
    end

    local Screens = PlayerGui.AetherUI.Screens
    if not Screens then
        return
    end

    for _, screen in ipairs(Screens:GetChildren()) do
        if screen:IsA("ScreenGui") then
            screen.Enabled = false
        end
    end
end

return GameClient
