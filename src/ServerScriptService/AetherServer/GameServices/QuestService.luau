-- QuestService
local QuestService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local QuestsData = require(game.ReplicatedStorage.AetherShared.Data.Quests)
local QuestProgress = require(game.ReplicatedStorage.AetherShared.Modules.QuestProgress)

-- Active quests per player: userId -> { questId -> {Progress = {...}, Completed = bool} }
local activeQuests = {}

local function copyProgress(progress)
    return table.clone(progress or {})
end

local function syncQuestToProfile(player, quest)
    local data = PlayerDataService.GetData(player)
    if not data then
        return
    end
    data.Quests = data.Quests or {}
    local saved = data.Quests[quest.Id] or { Status = "Active", AcceptedAt = quest.AcceptedAt }
    saved.Status = "Active"
    saved.Progress = copyProgress(quest.Progress)
    saved.AcceptedAt = quest.AcceptedAt
    data.Quests[quest.Id] = saved
end

local function getVisitedCount(visitedIslands)
    local count = 0
    for _, visited in pairs(visitedIslands or {}) do
        if visited == true then
            count += 1
        end
    end
    return count
end

local function getInitialProgress(player, quest)
    local progress = {}
    local data = PlayerDataService.GetData(player)
    local visitedIslands = data and data.VisitedIslands or {}
    for index, objective in ipairs(quest.Objectives or {}) do
        local value = 0
        if objective.Type == "Visit" then
            if objective.IslandId == "all" then
                value = getVisitedCount(visitedIslands)
            elseif objective.IslandId and visitedIslands[objective.IslandId] == true then
                value = 1
            end
        end
        local amount = type(objective.Amount) == "number" and objective.Amount or 1
        progress[index] = math.min(value, amount)
    end
    return progress
end

local function buildActiveQuest(questId, questDef, savedQuest)
    if type(savedQuest) ~= "table" or savedQuest.Status ~= "Active" then
        return nil
    end

    local progress = {}
    for index, objective in ipairs(questDef.Objectives or {}) do
        local savedProgress = savedQuest.Progress and savedQuest.Progress[index]
        local value = type(savedProgress) == "number" and math.max(0, math.floor(savedProgress)) or 0
        local targetAmount = type(objective.Amount) == "number" and objective.Amount or value
        progress[index] = math.min(value, targetAmount)
    end

    local restored = {
        Id = questId,
        Title = questDef.Title,
        Progress = progress,
        Objectives = questDef.Objectives,
        Completed = false,
        AcceptedAt = type(savedQuest.AcceptedAt) == "number" and savedQuest.AcceptedAt or os.time(),
    }
    local result = QuestProgress.ComputeQuestProgress(restored, progress)
    restored.Completed = result.completed
    return restored
end

function QuestService.GetActiveQuests(player)
    return activeQuests[player.UserId] or {}
end

function QuestService.GetQuestData(questId)
    return QuestsData.Get(questId)
end

function QuestService.GetQuestCatalog(player)
    local data = PlayerDataService.GetData(player)
    local active = activeQuests[player.UserId] or {}
    local catalog = {}
    for questId, questDef in pairs(QuestsData.GetAll()) do
        local saved = data and data.Quests and data.Quests[questId]
        if not saved or saved.Status ~= "Completed" then
            local current = active[questId]
            table.insert(catalog, {
                Id = questId,
                Title = questDef.Title,
                Description = questDef.Description,
                Type = questDef.Type,
                Difficulty = questDef.Difficulty,
                LevelRequired = questDef.LevelRequired,
                Objectives = questDef.Objectives,
                Status = current and (current.Completed and "ReadyToTurnIn" or "Active") or "Available",
                Progress = current and current.Progress or nil,
            })
        end
    end
    table.sort(catalog, function(left, right)
        if left.Status ~= right.Status then
            local rank = { Active = 1, ReadyToTurnIn = 1, Available = 2 }
            return (rank[left.Status] or 3) < (rank[right.Status] or 3)
        end
        if (left.LevelRequired or 1) ~= (right.LevelRequired or 1) then
            return (left.LevelRequired or 1) < (right.LevelRequired or 1)
        end
        return left.Title < right.Title
    end)
    return catalog
end

function QuestService.OnPlayerAdded(player)
    local data = PlayerDataService.GetData(player)
    local restored = {}
    if data and type(data.Quests) == "table" then
        for questId, savedQuest in pairs(data.Quests) do
            local questDef = QuestsData.Get(questId)
            local quest = questDef and buildActiveQuest(questId, questDef, savedQuest)
            if quest then
                restored[questId] = quest
            end
        end
    end
    activeQuests[player.UserId] = restored
end

function QuestService.OnPlayerRemoving(player)
    activeQuests[player.UserId] = nil
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

    -- Initialize from durable discovery state so accepting an exploration
    -- quest after earlier travel does not discard real progress.
    local progress = getInitialProgress(player, quest)
    local completion = QuestProgress.ComputeQuestProgress({ Objectives = quest.Objectives }, progress)

    activeQuests[player.UserId][questId] = {
        Id = questId,
        Title = quest.Title,
        Progress = progress,
        Objectives = quest.Objectives,
        Completed = completion.completed,
        AcceptedAt = os.time(),
    }

    -- Sync to player data
    data.Quests = data.Quests or {}
    data.Quests[questId] = { Status = "Active", Progress = copyProgress(progress), AcceptedAt = os.time() }

    -- Notify client
    QuestService.NotifyQuestUpdated(player, questId)

    return true, "Quest accepted"
end

function QuestService.UpdateProgress(player, objectiveType, target, amount)
    if type(amount) ~= "number" or amount <= 0 then
        return
    end
    amount = math.floor(amount)
    local quests = activeQuests[player.UserId]
    if not quests then
        return
    end

    for questId, quest in pairs(quests) do
        if not quest.Completed then
            local changed = false
            for i, objective in ipairs(quest.Objectives or {}) do
                local matches = QuestProgress.MatchesObjective(objective, objectiveType, target)

                if matches then
                    local current = quest.Progress[i] or 0
                    local targetAmount = type(objective.Amount) == "number" and objective.Amount or (current + amount)
                    quest.Progress[i] = math.min(targetAmount, current + amount)
                    changed = true
                end
            end

            if changed then
                -- Check completion (pure module: all objectives met)
                local result = QuestProgress.ComputeQuestProgress(quest, quest.Progress)
                if result.completed then
                    quest.Completed = true
                end

                syncQuestToProfile(player, quest)

                QuestService.NotifyQuestUpdated(player, questId)
            end
        end
    end
end

-- Deliver objectives are explicit inventory sinks. The server determines the
-- required amount, removes it atomically, and only then advances progress.
function QuestService.DeliverQuest(player, questId)
    local quests = activeQuests[player.UserId]
    local quest = quests and quests[questId]
    if not quest then
        return false, "Quest not active"
    end

    local requiredByItem = {}
    for index, objective in ipairs(quest.Objectives or {}) do
        if objective.Type == "Deliver" and objective.ItemId then
            local required = math.max(0, (objective.Amount or 1) - (quest.Progress[index] or 0))
            if required > 0 then
                requiredByItem[objective.ItemId] = (requiredByItem[objective.ItemId] or 0) + required
            end
        end
    end
    if not next(requiredByItem) then
        return false, "Nothing remains to deliver"
    end

    for itemId, amount in pairs(requiredByItem) do
        if PlayerDataService.GetItemCount(player, itemId) < amount then
            return false, "Not enough " .. itemId
        end
    end

    local removed = {}
    for itemId, amount in pairs(requiredByItem) do
        if not PlayerDataService.RemoveItem(player, itemId, amount) then
            for rollbackId, rollbackAmount in pairs(removed) do
                PlayerDataService.AddItem(player, rollbackId, rollbackAmount)
            end
            return false, "Could not remove delivery items"
        end
        removed[itemId] = amount
    end

    for itemId, amount in pairs(requiredByItem) do
        QuestService.UpdateProgress(player, "Deliver", itemId, amount)
    end
    return true, "Delivery accepted"
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

    local DeliverQuest = Remotes:FindFirstChild("DeliverQuest")
    if DeliverQuest then
        DeliverQuest.OnServerEvent:Connect(function(player, questId)
            if type(questId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "DeliverQuest", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, result = QuestService.DeliverQuest(player, questId)
            if not success then
                local ErrorRemote = Remotes:FindFirstChild("Error")
                if ErrorRemote then
                    ErrorRemote:FireClient(player, result)
                end
            end
        end)
    end

    local GetQuests = Remotes:FindFirstChild("GetQuests")
    if GetQuests then
        GetQuests.OnServerInvoke = function(player)
            return QuestService.GetActiveQuests(player)
        end
    end

    local GetQuestCatalog = Remotes:FindFirstChild("GetQuestCatalog")
    if GetQuestCatalog then
        GetQuestCatalog.OnServerInvoke = function(player)
            return QuestService.GetQuestCatalog(player)
        end
    end

    local questCount = 0
    for _ in pairs(QuestsData.GetAll()) do
        questCount += 1
    end
    print("[QuestService] Initialized with " .. questCount .. " quests available")
end

return QuestService
