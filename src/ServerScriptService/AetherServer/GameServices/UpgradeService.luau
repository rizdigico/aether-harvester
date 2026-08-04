local UpgradeService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

UpgradeService.Database = {
    ["pickaxe_power_1"] = {
        Id = "pickaxe_power_1",
        Name = "Pickaxe Power I",
        Description = "+20% mining power",
        Type = "Tool",
        MaxLevel = 10,
        BaseCost = { AetherShards = 100 },
        CostMultiplier = 1.5,
        Effect = { Power = 0.2 },
    },
    ["pickaxe_speed_1"] = {
        Id = "pickaxe_speed_1",
        Name = "Pickaxe Speed I",
        Description = "+15% mining speed",
        Type = "Tool",
        MaxLevel = 10,
        BaseCost = { AetherShards = 150 },
        CostMultiplier = 1.6,
        Effect = { Speed = 0.15 },
    },
    ["inventory_1"] = {
        Id = "inventory_1",
        Name = "Inventory Expansion I",
        Description = "+20 inventory slots",
        Type = "Inventory",
        MaxLevel = 5,
        BaseCost = { AetherShards = 500 },
        CostMultiplier = 2.0,
        Effect = { InventorySlots = 20 },
    },
    ["pet_capacity_1"] = {
        Id = "pet_capacity_1",
        Name = "Pet Capacity I",
        Description = "+2 pet slots",
        Type = "Pet",
        MaxLevel = 5,
        BaseCost = { AetherShards = 1000 },
        CostMultiplier = 2.5,
        Effect = { PetSlots = 2 },
    },
    ["energy_regen_1"] = {
        Id = "energy_regen_1",
        Name = "Energy Regen I",
        Description = "+10% energy regeneration",
        Type = "Player",
        MaxLevel = 10,
        BaseCost = { AetherShards = 200 },
        CostMultiplier = 1.4,
        Effect = { EnergyRegen = 0.1 },
    },
}

function UpgradeService.Initialize()
    print("[UpgradeService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- GetUpgrades: return the upgrade database plus the player's purchased levels
    local GetUpgrades = Remotes:FindFirstChild("GetUpgrades")
    if GetUpgrades then
        GetUpgrades.OnServerInvoke = function(player)
            return {
                Database = UpgradeService.GetAllUpgrades(),
                Purchased = UpgradeService.GetPlayerUpgrades(player),
            }
        end
    end

    -- PurchaseUpgrade: buy an upgrade for the player
    local PurchaseUpgrade = Remotes:FindFirstChild("PurchaseUpgrade")
    if PurchaseUpgrade then
        PurchaseUpgrade.OnServerEvent:Connect(function(player, upgradeId)
            if type(upgradeId) ~= "string" then
                return
            end
            local success, message = UpgradeService.PurchaseUpgrade(player, upgradeId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Upgrade failed")
                end
            end
        end)
    end

    print("[UpgradeService] Initialized")
end

function UpgradeService.GetUpgrade(upgradeId)
    return UpgradeService.Database[upgradeId]
end

function UpgradeService.GetAllUpgrades()
    return UpgradeService.Database
end

function UpgradeService.GetUpgradeLevel(player, upgradeId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 0
    end
    return data.Upgrades and data.Upgrades[upgradeId] or 0
end

function UpgradeService.CanUpgrade(player, upgradeId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local upgrade = UpgradeService.GetUpgrade(upgradeId)
    if not upgrade then
        return false, "Invalid upgrade"
    end

    local currentLevel = UpgradeService.GetUpgradeLevel(player, upgradeId)
    if currentLevel >= upgrade.MaxLevel then
        return false, "Upgrade maxed out"
    end

    local cost = UpgradeService.CalculateCost(player, upgradeId)
    if data.Currency.AetherShards < cost then
        return false, "Not enough currency"
    end

    return true, "Can upgrade"
end

function UpgradeService.CalculateCost(player, upgradeId)
    local upgrade = UpgradeService.GetUpgrade(upgradeId)
    if not upgrade then
        return 0
    end

    local currentLevel = UpgradeService.GetUpgradeLevel(player, upgradeId)
    local baseCost = upgrade.BaseCost.AetherShards or 0
    return math.floor(baseCost * math.pow(upgrade.CostMultiplier, currentLevel))
end

function UpgradeService.PurchaseUpgrade(player, upgradeId)
    local canUpgrade, reason = UpgradeService.CanUpgrade(player, upgradeId)
    if not canUpgrade then
        return false, reason
    end

    local data = PlayerDataService.GetData(player)
    local cost = UpgradeService.CalculateCost(player, upgradeId)

    -- Deduct cost
    PlayerDataService.RemoveCurrency(player, "AetherShards", cost)

    -- Increase level
    if not data.Upgrades then
        data.Upgrades = {}
    end
    data.Upgrades[upgradeId] = (data.Upgrades[upgradeId] or 0) + 1

    print("[UpgradeService] " .. player.Name .. " upgraded " .. upgradeId .. " to level " .. data.Upgrades[upgradeId])

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local UpgradePurchased = Remotes:FindFirstChild("UpgradePurchased")
        if UpgradePurchased then
            UpgradePurchased:FireClient(player, upgradeId, data.Upgrades[upgradeId], data.Currency)
        end
    end

    return true, "Upgrade purchased"
end

function UpgradeService.GetPlayerUpgrades(player)
    local data = PlayerDataService.GetData(player)
    if not data or not data.Upgrades then
        return {}
    end
    return data.Upgrades
end

return UpgradeService
