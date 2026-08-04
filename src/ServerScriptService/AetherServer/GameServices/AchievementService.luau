local AchievementService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local AchievementsData = require(game.ReplicatedStorage.AetherShared.Data.Achievements)

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
            local AchievementUnlocked = Remotes:FindFirstChild("AchievementUnlocked")
            if not AchievementUnlocked then
                return
            end
            local all = AchievementService.GetAllAchievements()
            local list = {}
            for _, a in pairs(all) do
                table.insert(list, {
                    Id = a.Id,
                    Title = a.Title,
                    Description = a.Description,
                    Progress = AchievementService.GetAchievementProgress(player, a.Id),
                })
            end
            AchievementUnlocked:FireClient(player, list)
        end)
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

return AchievementService
