local AchievementService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local AchievementsData = require(game.ReplicatedStorage.AetherShared.Data.Achievements)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)

function AchievementService.Initialize()
    print("[AchievementService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- RequestAchievements: send all achievements with per-player progress
    local RequestAchievements = Remotes:FindFirstChild("RequestAchievements")
    if RequestAchievements then
        RequestAchievements.OnServerEvent:Connect(function(player)
            if not RateLimiter.Check(player, "RequestAchievements", 1) then
                return
            end
            local AchievementUnlocked = Remotes:FindFirstChild("AchievementUnlocked")
            if not AchievementUnlocked then
                return
            end
            AchievementUnlocked:FireClient(player, AchievementService.GetSnapshot(player))
        end)
    end

    local GetAchievements = Remotes:FindFirstChild("GetAchievements")
    if GetAchievements then
        GetAchievements.OnServerInvoke = function(player)
            if not RateLimiter.Check(player, "GetAchievements", 0.5) then
                return {}
            end
            return AchievementService.GetSnapshot(player)
        end
    end

    print("[AchievementService] Initialized")
end

function AchievementService.CheckAllAchievements(player)
    local newlyUnlocked = AchievementsData.CheckAchievements(player)

    for _, achievement in ipairs(newlyUnlocked) do
        print("[AchievementService] " .. player.Name .. " unlocked: " .. achievement.Title)

        -- Award rewards
        local data = PlayerDataService.GetData(player)
        if data then
            if achievement.Reward.Currency then
                PlayerDataService.AddCurrency(player, "AetherShards", achievement.Reward.Currency)
            end
            if achievement.Reward.XP then
                local ProgressionService =
                    require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
                ProgressionService.AddXP(player, achievement.Reward.XP)
            end
            if achievement.Reward.Item then
                PlayerDataService.AddItem(player, achievement.Reward.Item, 1)
            end
        end

        -- Notify client
        local Remotes = game.ReplicatedStorage.AetherShared.Remotes
        if Remotes then
            local AchievementUnlocked = Remotes:FindFirstChild("AchievementUnlocked")
            if AchievementUnlocked then
                AchievementUnlocked:FireClient(player, achievement)
            end
        end
    end

    return newlyUnlocked
end

function AchievementService.GetAchievementProgress(player, achievementId)
    return AchievementsData.GetProgress(player, achievementId)
end

function AchievementService.GetAllAchievements()
    return AchievementsData.GetAllAchievements()
end

function AchievementService.GetSnapshot(player)
    local list = {}
    for _, achievement in pairs(AchievementService.GetAllAchievements()) do
        local reward = achievement.Reward or {}
        table.insert(list, {
            Id = achievement.Id,
            Title = achievement.Title,
            Description = achievement.Description,
            Category = achievement.Category,
            Tier = achievement.Tier,
            Progress = AchievementService.GetAchievementProgress(player, achievement.Id),
            Reward = {
                Currency = type(reward.Currency) == "number" and reward.Currency or 0,
                XP = type(reward.XP) == "number" and reward.XP or 0,
                Item = type(reward.Item) == "string" and reward.Item or nil,
            },
        })
    end
    table.sort(list, function(a, b)
        if a.Progress == b.Progress then
            return a.Title < b.Title
        end
        return a.Progress > b.Progress
    end)
    return list
end

return AchievementService
