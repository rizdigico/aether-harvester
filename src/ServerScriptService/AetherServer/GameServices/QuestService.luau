-- QuestService
local QuestService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local QuestsData = require(game.ReplicatedStorage.AetherShared.Data.Quests)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)
local QuestProgress = require(game.ReplicatedStorage.AetherShared.Modules.QuestProgress)

-- Active quests per player: userId -> { questId -> {Progress = {...}, Completed = bool} }
local activeQuests = {}

function QuestService.GetActiveQuests(player)
    return activeQuests[player.UserId] or {}
end

function QuestService.GetQuestData(questId)
    return QuestsData.Get(questId)
end

function QuestService.AcceptQuest(player, questId)
    local quest = QuestsData.Get(questId)
    if not quest then
        return false, "Quest not found"
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "No player data"
    end

    -- Check level requirement
    if quest.LevelRequired and (data.Level or 1) < quest.LevelRequired then
        return false, "Level " .. quest.LevelRequired .. " required"
    end

    -- Check not already active
    activeQuests[player.UserId] = activeQuests[player.UserId] or {}
    if activeQuests[player.UserId][questId] then
        return false, "Quest already active"
    end

    -- Initialize progress
    local progress = {}
    for i, objective in ipairs(quest.Objectives or {}) do
        progress[i] = 0
    end

    activeQuests[player.UserId][questId] = {
        Id = questId,
        Title = quest.Title,
        Progress = progress,
        Objectives = quest.Objectives,
        Completed = false,
        AcceptedAt = os.time(),
    }

    -- Sync to player data
    data.Quests = data.Quests or {}
    data.Quests[questId] = { Status = "Active", Progress = progress }

    -- Notify client
    QuestService.NotifyQuestUpdated(player, questId)

    return true, "Quest accepted"
end

function QuestService.UpdateProgress(player, objectiveType, target, amount)
    local quests = activeQuests[player.UserId]
    if not quests then
        return
    end

    for questId, quest in pairs(quests) do
        if not quest.Completed then
            local changed = false
            for i, objective in ipairs(quest.Objectives or {}) do
                local matches = false
                if objective.Type == objectiveType then
                    if objectiveType == "Harvest" then
                        matches = (objective.ItemId == nil) or (objective.ItemId == target)
                    elseif objectiveType == "Collect" then
                        matches = (objective.ItemId == nil) or (objective.ItemId == target)
                    elseif objectiveType == "Tame" then
                        matches = (objective.CreatureId == nil) or (objective.CreatureId == target)
                    elseif objectiveType == "Defeat" then
                        matches = (objective.CreatureId == nil) or (objective.CreatureId == target)
                    elseif objectiveType == "DefeatRarity" then
                        matches = (objective.CreatureRarity ~= nil) and (objective.CreatureRarity == target)
                    elseif objectiveType == "Visit" then
                        matches = true
                    else
                        matches = true
                    end
                end

                if matches then
                    quest.Progress[i] = (quest.Progress[i] or 0) + amount
                    changed = true
                end
            end

            if changed then
                -- Check completion (pure module: all objectives met)
                local result = QuestProgress.ComputeQuestProgress(quest, quest.Progress)
                if result.completed then
                    quest.Completed = true
                end

                QuestService.NotifyQuestUpdated(player, questId)
            end
        end
    end
end

function QuestService.CompleteQuest(player, questId)
    local quests = activeQuests[player.UserId]
    if not quests or not quests[questId] then
        return false, "Quest not active"
    end

    local quest = quests[questId]
    if not quest.Completed then
        return false, "Quest not complete yet"
    end

    local questDef = QuestsData.Get(questId)
    if not questDef then
        return false, "Quest not found"
    end

    -- Grant rewards
    if questDef.Rewards then
        if questDef.Rewards.XP then
            ProgressionService.AddXP(player, questDef.Rewards.XP)
        end
        if questDef.Rewards.Currency then
            for currency, amount in pairs(questDef.Rewards.Currency) do
                PlayerDataService.AddCurrency(player, currency, amount)
            end
        end
        if questDef.Rewards.Items then
            for _, itemId in ipairs(questDef.Rewards.Items) do
                PlayerDataService.AddItem(player, itemId, 1)
            end
        end
    end

    -- Remove from active
    quests[questId] = nil

    -- Update player data
    local data = PlayerDataService.GetData(player)
    if data and data.Quests then
        data.Quests[questId] = { Status = "Completed", CompletedAt = os.time() }
    end

    -- Notify client
    QuestService.NotifyQuestUpdated(player, questId)

    return true, "Quest complete!"
end

function QuestService.AbandonQuest(player, questId)
    local quests = activeQuests[player.UserId]
    if not quests or not quests[questId] then
        return false, "Quest not active"
    end

    quests[questId] = nil

    local data = PlayerDataService.GetData(player)
    if data and data.Quests then
        data.Quests[questId] = { Status = "Abandoned" }
    end

    QuestService.NotifyQuestUpdated(player, questId)
    return true, "Quest abandoned"
end

function QuestService.NotifyQuestUpdated(player, questId)
    local quests = activeQuests[player.UserId]
    local Remotes = ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    local QuestUpdated = Remotes:FindFirstChild("QuestUpdated")
    if not QuestUpdated then
        return
    end

    local quest = quests and quests[questId]
    local questDef = QuestsData.Get(questId)

    QuestUpdated:FireClient(player, {
        Id = questId,
        Title = questDef and questDef.Title or questId,
        Status = quest and (quest.Completed and "ReadyToTurnIn" or "InProgress") or "Updated",
        Progress = quest and quest.Progress or nil,
        Objectives = quest and quest.Objectives or nil,
    })
end

function QuestService.Initialize()
    print("[QuestService] Initializing...")

    local Remotes = ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    local AcceptQuest = Remotes:FindFirstChild("AcceptQuest")
    if AcceptQuest then
        AcceptQuest.OnServerEvent:Connect(function(player, questId)
            if type(questId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "AcceptQuest", 0.5) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, result = QuestService.AcceptQuest(player, questId)
            if not success then
                local ErrorRemote = Remotes:FindFirstChild("Error")
                if ErrorRemote then
                    ErrorRemote:FireClient(player, result)
                end
            end
        end)
    end

    local CompleteQuest = Remotes:FindFirstChild("CompleteQuest")
    if CompleteQuest then
        CompleteQuest.OnServerEvent:Connect(function(player, questId)
            if type(questId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "CompleteQuest", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, result = QuestService.CompleteQuest(player, questId)
            if not success then
                local ErrorRemote = Remotes:FindFirstChild("Error")
                if ErrorRemote then
                    ErrorRemote:FireClient(player, result)
                end
            end
        end)
    end

    local AbandonQuest = Remotes:FindFirstChild("AbandonQuest")
    if AbandonQuest then
        AbandonQuest.OnServerEvent:Connect(function(player, questId)
            if type(questId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "AbandonQuest", 0.5) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            QuestService.AbandonQuest(player, questId)
        end)
    end

    local GetQuests = Remotes:FindFirstChild("GetQuests")
    if GetQuests then
        GetQuests.OnServerInvoke = function(player)
            return QuestService.GetActiveQuests(player)
        end
    end

    local questCount = 0
    for _ in pairs(QuestsData.GetAll()) do
        questCount += 1
    end
    print("[QuestService] Initialized with " .. questCount .. " quests available")
end

return QuestService
