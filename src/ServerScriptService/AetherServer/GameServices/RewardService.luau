local RewardService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RewardsData = require(game.ReplicatedStorage.AetherShared.Data.Rewards)

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
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    -- Check if already claimed today
    local lastClaim = data.LastDailyReward or 0
    local currentTime = os.time()
    local dayNumber = os.date("%d", currentTime)

    if lastClaim == dayNumber then
        return false, "Already claimed today"
    end

    -- Calculate streak
    local yesterday = dayNumber - 1
    if lastClaim == yesterday or (lastClaim == 0 and data.LastLoginDay == yesterday) then
        data.DailyStreak = (data.DailyStreak or 0) + 1
    else
        data.DailyStreak = 1
    end

    data.LastLoginDay = dayNumber
    data.LastDailyReward = dayNumber

    -- Get reward for current day
    local reward = RewardsData.GetDailyReward(data.DailyStreak)
    if not reward then
        reward = RewardsData.GetDailyReward(30) -- Monthly reward
    end

    -- Apply streak bonus
    local streakBonus = RewardsData.CalculateStreakBonus(data.DailyStreak)
    if reward.Currency then
        PlayerDataService.AddCurrency(player, "AetherShards", math.floor(reward.Currency * streakBonus))
    end

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local DailyRewardClaimed = Remotes:FindFirstChild("DailyRewardClaimed")
        if DailyRewardClaimed then
            DailyRewardClaimed:FireClient(player, reward, data.DailyStreak)
        end
    end

    return true, reward
end

function RewardService.GetDailyStreak(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 0
    end
    return data.DailyStreak or 0
end

function RewardService.CanClaimDailyReward(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return true
    end

    local dayNumber = os.date("%d", os.time())
    return data.LastDailyReward ~= dayNumber
end

return RewardService
