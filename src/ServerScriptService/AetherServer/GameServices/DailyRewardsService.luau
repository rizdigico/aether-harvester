local DailyRewardsService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RewardsData = require(game.ReplicatedStorage.AetherShared.Data.Rewards)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)
local PetsData = require(game.ReplicatedStorage.AetherShared.Data.Pets)
local CurrencyRules = require(game.ReplicatedStorage.AetherShared.Modules.CurrencyRules)
local DailyRewardProgress = require(game.ReplicatedStorage.AetherShared.Modules.DailyRewardProgress)
local InventoryRules = require(game.ReplicatedStorage.AetherShared.Modules.InventoryRules)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)

DailyRewardsService.Rewards = RewardsData.DailyCalendar

local function canGrantReward(data, reward)
    if type(reward) ~= "table" then
        return false
    end
    if reward.Currency ~= nil then
        local definition = CurrencyRules.Definitions.AetherShards
        local current = data.Currency and data.Currency.AetherShards
        local ok = CurrencyRules.CanAdd("AetherShards", reward.Currency, current, definition)
        if not ok then
            return false
        end
    end
    if reward.XP ~= nil and (type(reward.XP) ~= "number" or reward.XP <= 0 or reward.XP > 1000000) then
        return false
    end
    if reward.Item ~= nil then
        local itemId = reward.Item
        local amount = reward.Amount or 1
        local definition = ItemsData.GetItem(itemId)
        local current = data.Inventory and data.Inventory[itemId]
        local ok = InventoryRules.CanAdd(itemId, amount, current, definition)
        if not ok then
            return false
        end
    end
    if reward.Pet ~= nil and (type(reward.Pet) ~= "string" or not PetsData.GetPet(reward.Pet)) then
        return false
    end
    return true
end

function DailyRewardsService.Initialize()
    print("[DailyRewardsService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- ClaimDailyReward: canonical daily claim handler (streak + reward)
    local ClaimDailyReward = Remotes:FindFirstChild("ClaimDailyReward")
    if ClaimDailyReward then
        ClaimDailyReward.OnServerEvent:Connect(function(player)
            if not RateLimiter.Check(player, "ClaimDailyReward", 2) then
                return
            end
            local success, message = DailyRewardsService.ClaimDailyReward(player)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Claim failed")
                end
            end
        end)
    end

    print("[DailyRewardsService] Initialized")
end

function DailyRewardsService.ClaimDailyReward(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local now = os.time()
    local lastClaimDay = data.LastDailyRewardDay
    if type(lastClaimDay) ~= "number" and type(data.LastDailyRewardAt) == "number" and data.LastDailyRewardAt > 0 then
        lastClaimDay = DailyRewardProgress.GetDayIndex(data.LastDailyRewardAt)
    end
    local decision = DailyRewardProgress.ResolveClaim(lastClaimDay, data.DailyStreak, now)
    if not decision.canClaim then
        return false, "Already claimed today"
    end

    local rewardDay = DailyRewardProgress.GetRewardDay(decision.streak, 30)
    local reward = RewardsData.GetDailyReward(rewardDay)
    if not canGrantReward(data, reward) then
        return false, "Reward unavailable"
    end

    if reward.Currency and not PlayerDataService.AddCurrency(player, "AetherShards", reward.Currency) then
        return false, "Reward unavailable"
    end
    if reward.XP then
        local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
        if not ProgressionService.AddXP(player, reward.XP) then
            return false, "Reward unavailable"
        end
    end
    if reward.Item and not PlayerDataService.AddItem(player, reward.Item, reward.Amount or 1) then
        return false, "Reward unavailable"
    end
    if reward.Pet and not PlayerDataService.AddPet(player, reward.Pet) then
        return false, "Reward unavailable"
    end

    -- Update data
    data.LastDailyReward = DailyRewardProgress.GetDayKey(now)
    data.LastDailyRewardAt = now
    data.LastDailyRewardDay = decision.dayIndex
    data.DailyStreak = decision.streak

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local DailyRewardClaimed = Remotes:FindFirstChild("DailyRewardClaimed")
        if DailyRewardClaimed then
            DailyRewardClaimed:FireClient(player, decision.streak, reward)
        end
    end

    print("[DailyRewardsService] " .. player.Name .. " claimed calendar day " .. rewardDay .. " reward")
    return true, reward
end

function DailyRewardsService.GetStreak(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 0
    end
    return data.DailyStreak or 0
end

function DailyRewardsService.CanClaim(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false
    end

    local lastClaimDay = data.LastDailyRewardDay
    if type(lastClaimDay) ~= "number" and type(data.LastDailyRewardAt) == "number" and data.LastDailyRewardAt > 0 then
        lastClaimDay = DailyRewardProgress.GetDayIndex(data.LastDailyRewardAt)
    end
    return DailyRewardProgress.ResolveClaim(lastClaimDay, data.DailyStreak, os.time()).canClaim
end

return DailyRewardsService
