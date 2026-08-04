local Achievements = {}

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

Achievements.Database = {
    ["first_harvest"] = {
        Id = "first_harvest",
        Title = "First Harvest",
        Description = "Harvest your first resource",
        Icon = "rbxassetid://0",
        Category = "Harvesting",
        Tier = "Bronze",
        Reward = { Currency = 100, XP = 50 },
        Check = function(data)
            return data.Stats and data.Stats.HarvestCount >= 1
        end,
    },
    ["harvest_100"] = {
        Id = "harvest_100",
        Title = "Dedicated Harvester",
        Description = "Harvest 100 resources",
        Icon = "rbxassetid://0",
        Category = "Harvesting",
        Tier = "Silver",
        Reward = { Currency = 500, XP = 200 },
        Check = function(data)
            return data.Stats and data.Stats.HarvestCount >= 100
        end,
    },
    ["first_pet"] = {
        Id = "first_pet",
        Title = "Pet Owner",
        Description = "Obtain your first pet",
        Icon = "rbxassetid://0",
        Category = "Collection",
        Tier = "Bronze",
        Reward = { Currency = 200, XP = 100 },
        Check = function(data)
            return data.PetInventory and #data.PetInventory >= 1
        end,
    },
    ["level_10"] = {
        Id = "level_10",
        Title = "Rising Star",
        Description = "Reach level 10",
        Icon = "rbxassetid://0",
        Category = "Progression",
        Tier = "Silver",
        Reward = { Currency = 1000, XP = 500 },
        Check = function(data)
            return data.Level >= 10
        end,
    },
    ["first_trade"] = {
        Id = "first_trade",
        Title = "Deal Maker",
        Description = "Complete your first trade",
        Icon = "rbxassetid://0",
        Category = "Social",
        Tier = "Bronze",
        Reward = { Currency = 300, XP = 150 },
        Check = function(data)
            return data.Stats and data.Stats.TradesCompleted >= 1
        end,
    },
    ["explorer"] = {
        Id = "explorer",
        Title = "Explorer",
        Description = "Visit all 5 major zones",
        Icon = "rbxassetid://0",
        Category = "Exploration",
        Tier = "Gold",
        Reward = { Currency = 2000, XP = 1000, Item = "crystal_pickaxe" },
        Check = function(data)
            return data.Stats and data.Stats.ZonesDiscovered >= 5
        end,
    },
}

function Achievements.GetAchievement(achievementId)
    return Achievements.Database[achievementId]
end

function Achievements.GetAllAchievements()
    return Achievements.Database
end

function Achievements.GetAchievementsByCategory(category)
    local results = {}
    for _, achievement in pairs(Achievements.Database) do
        if achievement.Category == category then
            table.insert(results, achievement)
        end
    end
    return results
end

function Achievements.CheckAchievements(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return {}
    end

    local newlyUnlocked = {}
    for achievementId, achievement in pairs(Achievements.Database) do
        if not data.Achievements[achievementId] then
            if achievement.Check(data) then
                data.Achievements[achievementId] = true
                table.insert(newlyUnlocked, achievement)
            end
        end
    end

    return newlyUnlocked
end

function Achievements.GetProgress(player, achievementId)
    local achievement = Achievements.Database[achievementId]
    if not achievement then
        return 0
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return 0
    end

    return achievement.Check(data) and 1 or 0
end

return Achievements
