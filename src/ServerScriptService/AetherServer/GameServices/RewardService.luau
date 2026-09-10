local RewardService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
local RewardsData = require(game.ReplicatedStorage.AetherShared.Data.Rewards)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)
local CurrencyRules = require(game.ReplicatedStorage.AetherShared.Modules.CurrencyRules)
local InventoryRules = require(game.ReplicatedStorage.AetherShared.Modules.InventoryRules)
local DailyRewardsService = require(game.ServerScriptService.AetherServer.GameServices.DailyRewardsService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)

local function canGrantRewards(data, rewards)
    if type(rewards) ~= "table" then
        return false
    end

    if rewards.XP ~= nil and (type(rewards.XP) ~= "number" or rewards.XP <= 0 or rewards.XP > 1000000) then
        return false
    end

    local stagedCurrency = {}
    if rewards.Currency then
        if type(rewards.Currency) ~= "table" then
            return false
        end
        for currencyType, amount in pairs(rewards.Currency) do
            local definition = CurrencyRules.Definitions[currencyType]
            local current = stagedCurrency[currencyType]
            if current == nil then
                current = data.Currency and data.Currency[currencyType]
            end
            local ok, nextBalance = CurrencyRules.CanAdd(currencyType, amount, current, definition)
            if not ok then
                return false
            end
            stagedCurrency[currencyType] = nextBalance
        end
    end

    local stagedItems = {}
    if rewards.Items then
        if type(rewards.Items) ~= "table" then
            return false
        end
        for _, itemId in ipairs(rewards.Items) do
            local definition = ItemsData.GetItem(itemId)
            local current = stagedItems[itemId]
            if current == nil then
                current = data.Inventory and data.Inventory[itemId]
            end
            local ok, nextCount = InventoryRules.CanAdd(itemId, 1, current, definition)
            if not ok then
                return false
            end
            stagedItems[itemId] = nextCount
        end
    end

    return true
end

function RewardService.Initialize()
    print("[RewardService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- ClaimReward: generic reward claim flow (daily rewards are handled by DailyRewardsService)
    local ClaimReward = Remotes:FindFirstChild("ClaimReward")
    if ClaimReward then
        ClaimReward.OnServerEvent:Connect(function(player, rewardId)
            if type(rewardId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "ClaimReward", 1) then
                return
            end
            local success, message = RewardService.ClaimExtraReward(player, rewardId)
            local Error = Remotes:FindFirstChild("Error")
            if not success and Error then
                Error:FireClient(player, message or "Failed to claim reward")
            end
        end)
    end

    print("[RewardService] Initialized")
end

-- Grant an extra reward (weekly/seasonal etc.) idempotently.
-- Each rewardId can only be claimed once per player (tracked in data.ClaimedRewards).
function RewardService.ClaimExtraReward(player, rewardId)
    local reward = RewardsData.GetExtraReward(rewardId)
    if not reward then
        return false, "Unknown reward"
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    -- Idempotency: prevent double-claim
    data.ClaimedRewards = data.ClaimedRewards or {}
    if data.ClaimedRewards[rewardId] then
        return false, "Reward already claimed"
    end

    -- Grant the reward components
    local rewards = reward.Rewards or {}
    if not canGrantRewards(data, rewards) then
        return false, "Reward unavailable"
    end
    if rewards.XP then
        if not ProgressionService.AddXP(player, rewards.XP) then
            return false, "Reward unavailable"
        end
    end
    if rewards.Currency then
        for currencyType, amount in pairs(rewards.Currency) do
            if not PlayerDataService.AddCurrency(player, currencyType, amount) then
                return false, "Reward unavailable"
            end
        end
    end
    if rewards.Items then
        for _, itemId in ipairs(rewards.Items) do
            if not PlayerDataService.AddItem(player, itemId, 1) then
                return false, "Reward unavailable"
            end
        end
    end

    data.ClaimedRewards[rewardId] = true

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local RewardClaimed = Remotes:FindFirstChild("RewardClaimed")
        if RewardClaimed then
            RewardClaimed:FireClient(player, rewardId)
        end
    end

    print("[RewardService] Claimed extra reward: " .. rewardId)
    return true, reward
end

function RewardService.ClaimDailyReward(player)
    return DailyRewardsService.ClaimDailyReward(player)
end

function RewardService.GetDailyStreak(player)
    return DailyRewardsService.GetStreak(player)
end

function RewardService.CanClaimDailyReward(player)
    return DailyRewardsService.CanClaim(player)
end

return RewardService
