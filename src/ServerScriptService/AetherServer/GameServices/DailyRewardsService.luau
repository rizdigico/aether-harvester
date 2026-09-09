local DailyRewardsService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RewardsData = require(game.ReplicatedStorage.AetherShared.Data.Rewards)
local DailyRewardProgress = require(game.ReplicatedStorage.AetherShared.Modules.DailyRewardProgress)

DailyRewardsService.Rewards = RewardsData.DailyCalendar

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
    if reward then
        if reward.Currency then
            PlayerDataService.AddCurrency(player, "AetherShards", reward.Currency)
        end
        if reward.XP then
            local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
            ProgressionService.AddXP(player, reward.XP)
        end
        if reward.Item then
            PlayerDataService.AddItem(player, reward.Item, reward.Amount or 1)
        end
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
        return true
    end

    local lastClaimDay = data.LastDailyRewardDay
    if type(lastClaimDay) ~= "number" and type(data.LastDailyRewardAt) == "number" and data.LastDailyRewardAt > 0 then
        lastClaimDay = DailyRewardProgress.GetDayIndex(data.LastDailyRewardAt)
    end
    return DailyRewardProgress.ResolveClaim(lastClaimDay, data.DailyStreak, os.time()).canClaim
end

return DailyRewardsService
