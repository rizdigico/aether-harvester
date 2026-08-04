local DailyRewardsService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

DailyRewardsService.Rewards = {
    [1] = { AetherShards = 50, Items = { "energy_potion" } },
    [2] = { AetherShards = 75, XP = 100 },
    [3] = { AetherShards = 100, Items = { "pet_food" } },
    [4] = { AetherShards = 150, Items = { "crystal_fragment" } },
    [5] = { AetherShards = 200, XP = 250, Items = { "harvest_boost" } },
    [6] = { AetherShards = 250, Items = { "aether_crystal" } },
    [7] = { AetherShards = 500, XP = 500, Items = { "lucky_charm" }, Special = "Bonus Reward" },
}

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

    -- Check if already claimed today
    local lastClaim = data.LastDailyReward or 0
    local today = os.date("*t")
    local todayString = today.year .. "-" .. today.month .. "-" .. today.day

    if lastClaim == todayString then
        return false, "Already claimed today"
    end

    -- Calculate streak
    local streak = data.DailyStreak or 0
    if lastClaim ~= 0 then
        local yesterday = os.time({ year = today.year, month = today.month, day = today.day - 1 })
        if lastClaim == os.date("%Y-%m-%d", yesterday) then
            streak += 1
        else
            streak = 1
        end
    else
        streak = 1
    end

    -- Cap streak at 7
    if streak > 7 then
        streak = 7
    end

    -- Give rewards
    local reward = DailyRewardsService.Rewards[streak]
    if reward then
        if reward.AetherShards then
            PlayerDataService.AddCurrency(player, "AetherShards", reward.AetherShards)
        end
        if reward.XP then
            local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
            ProgressionService.AddXP(player, reward.XP)
        end
        if reward.Items then
            for _, itemId in ipairs(reward.Items) do
                PlayerDataService.AddItem(player, itemId, 1)
            end
        end
    end

    -- Update data
    data.LastDailyReward = todayString
    data.DailyStreak = streak

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local DailyRewardClaimed = Remotes:FindFirstChild("DailyRewardClaimed")
        if DailyRewardClaimed then
            DailyRewardClaimed:FireClient(player, streak, reward)
        end
    end

    print("[DailyRewardsService] " .. player.Name .. " claimed day " .. streak .. " reward")
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

    local lastClaim = data.LastDailyReward or 0
    local today = os.date("*t")
    local todayString = today.year .. "-" .. today.month .. "-" .. today.day

    return lastClaim ~= todayString
end

return DailyRewardsService
