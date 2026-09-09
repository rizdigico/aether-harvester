local ProgressionService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local UpgradeService = require(game.ServerScriptService.AetherServer.GameServices.UpgradeService)

function ProgressionService.Initialize()
    print("[ProgressionService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- XP is granted only by server-owned gameplay services.  The legacy AddXP
    -- RemoteEvent may still exist in an older place file, but it must never be
    -- connected here because any client can fire a RemoteEvent.

    -- LevelUp: client asks to sync current level/skill points
    local LevelUp = Remotes:FindFirstChild("LevelUp")
    if LevelUp then
        LevelUp.OnServerEvent:Connect(function(player)
            local data = PlayerDataService.GetData(player)
            if not data then
                return
            end
            local PlayerLeveledUp = Remotes:FindFirstChild("PlayerLeveledUp")
            if PlayerLeveledUp then
                PlayerLeveledUp:FireClient(player, data.Level or 1, data.SkillPoints or 0)
            end
        end)
    end

    print("[ProgressionService] Initialized")
end

function ProgressionService.AddXP(player, amount)
    if type(amount) ~= "number" or amount <= 0 or amount > 1000000 then
        return false
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false
    end

    data.XP = (data.XP or 0) + math.floor(amount)

    -- Check for level up
    local currentLevel = data.Level or 1
    local xpRequired = ProgressionService.CalculateXPRequired(currentLevel)

    while data.XP >= xpRequired do
        data.XP -= xpRequired
        data.Level = currentLevel + 1
        currentLevel += 1
        xpRequired = ProgressionService.CalculateXPRequired(currentLevel)

        -- Award level up rewards
        ProgressionService.OnLevelUp(player, currentLevel)
    end

    return true
end

function ProgressionService.CalculateXPRequired(level)
    return math.floor(100 * math.pow(1.5, level - 1))
end

function ProgressionService.OnLevelUp(player, newLevel)
    print("[ProgressionService] " .. player.Name .. " leveled up to " .. newLevel)

    -- Award skill points
    local data = PlayerDataService.GetData(player)
    if data then
        data.SkillPoints = (data.SkillPoints or 0) + 5
    end

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local PlayerLeveledUp = Remotes:FindFirstChild("PlayerLeveledUp")
        if PlayerLeveledUp then
            PlayerLeveledUp:FireClient(player, newLevel, 5)
        end
    end
end

function ProgressionService.GetLevel(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 1
    end
    return data.Level or 1
end

function ProgressionService.GetXP(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 0
    end
    return data.XP or 0
end

function ProgressionService.GetXPToNextLevel(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 100
    end
    return ProgressionService.CalculateXPRequired(data.Level or 1)
end

function ProgressionService.AddSkillPoint(player, skillId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false
    end

    if (data.SkillPoints or 0) <= 0 then
        return false, "No skill points available"
    end

    data.SkillPoints -= 1
    data.Skills[skillId] = (data.Skills[skillId] or 0) + 1

    return true, "Skill point added"
end

function ProgressionService.GetSkillPoints(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return 0
    end
    return data.SkillPoints or 0
end

return ProgressionService
