local RewardService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RewardsData = require(game.ReplicatedStorage.AetherShared.Data.Rewards)
local DailyRewardsService = require(game.ServerScriptService.AetherServer.GameServices.DailyRewardsService)

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
    if rewards.XP then
        PlayerDataService.AddXP(player, rewards.XP)
    end
    if rewards.Currency then
        for currencyType, amount in pairs(rewards.Currency) do
            PlayerDataService.AddCurrency(player, currencyType, amount)
        end
    end
    if rewards.Items then
        for _, itemId in ipairs(rewards.Items) do
            PlayerDataService.AddItem(player, itemId, 1)
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
