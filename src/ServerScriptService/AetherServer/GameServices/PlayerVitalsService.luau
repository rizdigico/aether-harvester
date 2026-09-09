--!strict
-- Server-authoritative energy and consumable handling.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local UpgradeService = require(game.ServerScriptService.AetherServer.GameServices.UpgradeService)
local VitalsMath = require(ReplicatedStorage.AetherShared.Modules.VitalsMath)

local PlayerVitalsService = {}
local initialized = false
local regenAccumulator = 0

PlayerVitalsService.HARVEST_ENERGY_COST = VitalsMath.HARVEST_ENERGY_COST

local function getRemotes()
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    return shared and shared:FindFirstChild("Remotes")
end

local function getData(player)
    return PlayerDataService.GetData(player)
end

local function getSnapshot(player): { Energy: number, MaxEnergy: number }?
    local data = getData(player)
    if not data then
        return nil
    end

    local maxEnergy = VitalsMath.NormalizeMaxEnergy(data.MaxEnergy)
    data.MaxEnergy = maxEnergy
    data.Energy = VitalsMath.NormalizeEnergy(data.Energy, maxEnergy)
    return {
        Energy = data.Energy,
        MaxEnergy = maxEnergy,
    }
end

local function notifyVitals(player)
    local snapshot = getSnapshot(player)
    local remotes = getRemotes()
    local updateHUD = remotes and remotes:FindFirstChild("UpdateHUD")
    if snapshot and updateHUD and updateHUD:IsA("RemoteEvent") then
        updateHUD:FireClient(player, snapshot)
    end
    return snapshot
end

function PlayerVitalsService.GetSnapshot(player)
    return getSnapshot(player)
end

function PlayerVitalsService.ConsumeEnergy(player, amount)
    local data = getData(player)
    if not data then
        return false, "Player data is still loading"
    end

    local maxEnergy = VitalsMath.NormalizeMaxEnergy(data.MaxEnergy)
    local remaining, consumed = VitalsMath.ConsumeEnergy(data.Energy, amount, maxEnergy)
    if not consumed then
        return false, "Not enough energy"
    end
    data.MaxEnergy = maxEnergy
    data.Energy = remaining
    notifyVitals(player)
    return true, "Energy consumed"
end

function PlayerVitalsService.RestoreEnergy(player, amount)
    local data = getData(player)
    if not data or type(amount) ~= "number" or amount <= 0 then
        return false
    end

    local maxEnergy = VitalsMath.NormalizeMaxEnergy(data.MaxEnergy)
    data.MaxEnergy = maxEnergy
    data.Energy = math.min(maxEnergy, VitalsMath.NormalizeEnergy(data.Energy, maxEnergy) + amount)
    notifyVitals(player)
    return true
end

function PlayerVitalsService.UseItem(player, itemId): (boolean, string, { Energy: number, MaxEnergy: number }?)
    if itemId ~= "energy_potion" then
        return false, "That item cannot be used here"
    end

    local data = getData(player)
    if not data then
        return false, "Player data is still loading"
    end
    local snapshot = getSnapshot(player)
    if not snapshot then
        return false, "Player data is still loading"
    end
    if snapshot.Energy >= snapshot.MaxEnergy then
        return false, "Energy is already full"
    end
    if PlayerDataService.GetItemCount(player, itemId) < 1 then
        return false, "You do not own that item"
    end
    if not PlayerDataService.RemoveItem(player, itemId, 1) then
        return false, "Could not consume the item"
    end

    local restored = PlayerVitalsService.RestoreEnergy(player, 50)
    if not restored then
        PlayerDataService.AddItem(player, itemId, 1)
        return false, "Could not restore energy"
    end
    return true, "Energy restored", getSnapshot(player)
end

function PlayerVitalsService.Initialize()
    if initialized then
        return
    end
    initialized = true
    print("[PlayerVitalsService] Initializing...")

    local remotes = getRemotes()
    local useItem = remotes and remotes:FindFirstChild("UseItem")
    if useItem and useItem:IsA("RemoteEvent") then
        useItem.OnServerEvent:Connect(function(player, itemId)
            if type(itemId) ~= "string" or not RateLimiter.Check(player, "UseItem", 0.5) then
                return
            end
            local success, message, snapshot = PlayerVitalsService.UseItem(player, itemId)
            if not success then
                local errorRemote = remotes:FindFirstChild("Error")
                if errorRemote and errorRemote:IsA("RemoteEvent") then
                    errorRemote:FireClient(player, message)
                end
                return
            end
            local itemUsed = remotes:FindFirstChild("ItemUsed")
            if itemUsed and itemUsed:IsA("RemoteEvent") then
                itemUsed:FireClient(player, itemId, PlayerDataService.GetItemCount(player, itemId), snapshot)
            end
        end)
    end

    RunService.Heartbeat:Connect(function(dt)
        regenAccumulator += dt
        if regenAccumulator < 1 then
            return
        end
        local elapsed = regenAccumulator
        regenAccumulator = 0

        for _, player in ipairs(Players:GetPlayers()) do
            local data = getData(player)
            if data then
                local maxEnergy = VitalsMath.NormalizeMaxEnergy(data.MaxEnergy)
                local regenBonus = math.clamp(UpgradeService.GetEffectTotal(player, "EnergyRegen"), 0, 5)
                local regenRate = VitalsMath.BASE_REGEN_PER_SECOND * (1 + regenBonus)
                local current = VitalsMath.NormalizeEnergy(data.Energy, maxEnergy)
                local nextEnergy = VitalsMath.RegenEnergy(current, elapsed, regenRate, maxEnergy)
                if nextEnergy ~= current then
                    data.MaxEnergy = maxEnergy
                    data.Energy = nextEnergy
                    notifyVitals(player)
                end
            end
        end
    end)

    print("[PlayerVitalsService] Initialized")
end

return PlayerVitalsService
