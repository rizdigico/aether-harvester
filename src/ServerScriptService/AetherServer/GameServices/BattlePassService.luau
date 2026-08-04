local BattlePassService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

BattlePassService.Seasons = {
    ["season_1"] = {
        Id = "season_1",
        Name = "Aether Awakening",
        StartDate = os.time({ year = 2026, month = 8, day = 1 }),
        EndDate = os.time({ year = 2026, month = 9, day = 1 }),
        Levels = 50,
        FreeRewards = {
            [5] = { AetherShards = 100, XP = 200 },
            [10] = { AetherShards = 250, Items = { "pet_food" } },
            [15] = { AetherShards = 500, XP = 500 },
            [20] = { Items = { "energy_potion", "crystal_fragment" } },
            [25] = { AetherShards = 1000, XP = 1000 },
            [30] = { Items = { "harvest_boost" } },
            [35] = { AetherShards = 1500, XP = 1500 },
            [40] = { Items = { "aether_crystal" } },
            [45] = { AetherShards = 2000, XP = 2000 },
            [50] = { Items = { "portal_key" }, Special = "Exclusive Reward" },
        },
        PremiumRewards = {
            [5] = { AetherShards = 200, XP = 400 },
            [10] = { Items = { "lucky_charm" } },
            [15] = { AetherShards = 500, XP = 1000 },
            [20] = { Items = { "island_deed" } },
            [25] = { AetherShards = 2000, XP = 2000 },
            [30] = { Items = { "ancient_relic" } },
            [35] = { AetherShards = 3000, XP = 3000 },
            [40] = { Items = { "aether_pickaxe" } },
            [45] = { AetherShards = 5000, XP = 5000 },
            [50] = { Items = { "sky_leviathan_pet" }, Special = "Exclusive Pet" },
        },
    },
}

function BattlePassService.Initialize()
    print("[BattlePassService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- PurchaseBattlePassPremium: buy premium for the current season
    local PurchaseBattlePassPremium = Remotes:FindFirstChild("PurchaseBattlePassPremium")
    if PurchaseBattlePassPremium then
        PurchaseBattlePassPremium.OnServerEvent:Connect(function(player)
            local success, message = BattlePassService.PurchasePremium(player)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Purchase failed")
                end
            end
        end)
    end

    print("[BattlePassService] Initialized")
end

function BattlePassService.AddXP(player, amount)
    local data = PlayerDataService.GetData(player)
    if not data then
        return
    end

    data.BattlePassXP = (data.BattlePassXP or 0) + amount

    -- Check for level ups
    local currentLevel = data.BattlePassLevel or 1
    local xpRequired = BattlePassService.CalculateXPRequired(currentLevel)

    while data.BattlePassXP >= xpRequired do
        data.BattlePassXP -= xpRequired
        data.BattlePassLevel = currentLevel + 1
        currentLevel += 1

        -- Award rewards
        BattlePassService:AwardLevelRewards(player, currentLevel)
    end
end

function BattlePassService.CalculateXPRequired(level)
    return math.floor(1000 * math.pow(1.1, level - 1))
end

function BattlePassService:AwardLevelRewards(player, level)
    local data = PlayerDataService.GetData(player)
    if not data then
        return
    end

    local currentSeason = BattlePassService:GetCurrentSeason()
    if not currentSeason then
        return
    end

    -- Free rewards
    local freeReward = currentSeason.FreeRewards[level]
    if freeReward then
        if freeReward.AetherShards then
            PlayerDataService.AddCurrency(player, "AetherShards", freeReward.AetherShards)
        end
        if freeReward.XP then
            local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
            ProgressionService.AddXP(player, freeReward.XP)
        end
        if freeReward.Items then
            for _, itemId in ipairs(freeReward.Items) do
                PlayerDataService.AddItem(player, itemId, 1)
            end
        end
    end

    -- Premium rewards
    if data.BattlePassPremium then
        local premiumReward = currentSeason.PremiumRewards[level]
        if premiumReward then
            if premiumReward.AetherShards then
                PlayerDataService.AddCurrency(player, "AetherShards", premiumReward.AetherShards)
            end
            if premiumReward.XP then
                local ProgressionService =
                    require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
                ProgressionService.AddXP(player, premiumReward.XP)
            end
            if premiumReward.Items then
                for _, itemId in ipairs(premiumReward.Items) do
                    PlayerDataService.AddItem(player, itemId, 1)
                end
            end
        end
    end

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local BattlePassLevelUp = Remotes:FindFirstChild("BattlePassLevelUp")
        if BattlePassLevelUp then
            BattlePassLevelUp:FireClient(
                player,
                level,
                freeReward,
                data.BattlePassPremium and currentSeason.PremiumRewards[level]
            )
        end
    end
end

function BattlePassService:GetCurrentSeason()
    local now = os.time()
    for _, season in pairs(BattlePassService.Seasons) do
        if now >= season.StartDate and now <= season.EndDate then
            return season
        end
    end
    return nil
end

function BattlePassService.GetLevel(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 1
    end
    return data.BattlePassLevel or 1
end

function BattlePassService.GetXP(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 0
    end
    return data.BattlePassXP or 0
end

function BattlePassService.PurchasePremium(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false
    end

    if data.Currency.AetherShards < 2000 then
        return false, "Not enough currency"
    end

    PlayerDataService.RemoveCurrency(player, "AetherShards", 2000)
    data.BattlePassPremium = true

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local BattlePassPremiumPurchased = Remotes:FindFirstChild("BattlePassPremiumPurchased")
        if BattlePassPremiumPurchased then
            BattlePassPremiumPurchased:FireClient(player)
        end
    end

    return true, "Premium purchased"
end

return BattlePassService
