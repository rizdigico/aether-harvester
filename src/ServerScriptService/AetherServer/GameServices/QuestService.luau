--
-- QuestService.luau
-- Manages quest tracking, objectives, and rewards
--

local Players = game:GetService("Players")
local DataStoreService = require(script.Parent.DataStoreService)

-- Define quests (example structure)
local QUESTS = {
    ["FindFirstNode"] = {
        name = "Find Your First Harvestable Node",
        description = "Locate and harvest your first harvestable node.",
        objectives = {
            {
                type = "harvest",
                target = "Node1",
                completed = false,
                count = 1,
            },
        },
        rewards = {
            items = {
                {
                    itemId = "BasicHarvestingTool",
                    quantity = 1,
                },
            },
            xp = 100,
        },
    },
    ["TameFirstCreature"] = {
        name = "Tame Your First Creature",
        description = "Find and tame a creature to start your adventure.",
        objectives = {
            {
                type = "tame",
                creatureId = "Rabbit",
                completed = false,
                count = 1,
            },
        },
        rewards = {
            items = {
                {
                    itemId = "CreatureTamingKit",
                    quantity = 1,
                },
            },
            xp = 150,
        },
    },
}

-- Function to initialize player quests
local function initializePlayerQuests(player: Player)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Quests then
        playerData.Quests = {}
    end

    -- Assign default quests to new players
    if #playerData.Quests == 0 then
        for questId, quest in pairs(QUESTS) do
            playerData.Quests[questId] = {
                quest = quest,
                progress = {},
            }
        end
    end

    player:SetAttribute("PlayerData", playerData)
end

-- Function to update quest progress
local function updateQuestProgress(player: Player, questId: string, objectiveIndex: number, completed: boolean)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Quests then
        return false, "Quests data not found."
    end

    local questData = playerData.Quests[questId]
    if not questData then
        return false, "Quest not found."
    end

    local quest = questData.quest
    local progress = questData.progress
    if not progress then
        progress = {}
        questData.progress = progress
    end

    if not quest.objectives[objectiveIndex] then
        return false, "Objective not found."
    end

    local objective = quest.objectives[objectiveIndex]
    objective.completed = completed

    -- Check if all objectives are completed
    local allCompleted = true
    for _, obj in pairs(quest.objectives) do
        if not obj.completed then
            allCompleted = false
            break
        end
    end

    if allCompleted then
        -- Quest completed, give rewards
        giveQuestRewards(player, questId)
    end

    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Quests = playerData.Quests,
    })

    return true, "Quest progress updated."
end

-- Function to give quest rewards
local function giveQuestRewards(player: Player, questId: string)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Quests then
        return false, "Quests data not found."
    end

    local questData = playerData.Quests[questId]
    if not questData then
        return false, "Quest not found."
    end

    local quest = questData.quest

    -- Give XP
    local xpReward = quest.rewards.xp or 0
    if xpReward > 0 then
        -- Update player progression
        local progressionData = playerData.Progression or {}
        progressionData.xp = (progressionData.xp or 0) + xpReward
        playerData.Progression = progressionData
    end

    -- Give items
    local itemsReward = quest.rewards.items or {}
    for _, item in pairs(itemsReward) do
        -- Add items to player's inventory
        local inventoryData = playerData.Inventory or {}
        inventoryData[item.itemId] = (inventoryData[item.itemId] or 0) + item.quantity
        playerData.Inventory = inventoryData
    end

    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Progression = playerData.Progression,
        Inventory = playerData.Inventory,
    })

    -- Notify client that quest is completed
    game:GetService("ReplicatedStorage"):FindFirstChild("QuestEvent"):FireClient(player, questId, true)

    return true, "Quest rewards given."
end

-- Function to handle remote events for quest updates
local function handleQuestEvent(player: Player, questId: string, objectiveIndex: number, completed: boolean)
    local success, message = updateQuestProgress(player, questId, objectiveIndex, completed)
    if success then
        game:GetService("ReplicatedStorage")
            :FindFirstChild("QuestEvent")
            :FireClient(player, questId, "progress_updated", message)
    else
        warn("Failed to update quest progress: " .. message)
    end
end

-- Initialize player quests for existing players
for _, player in ipairs(Players:GetPlayers()) do
    initializePlayerQuests(player)
end

-- Connect to player added event
Players.PlayerAdded:Connect(function(player)
    initializePlayerQuests(player)

    -- Connect to remote events
    local questEvent = game:GetService("ReplicatedStorage"):FindFirstChild("QuestEvent")
    if questEvent then
        questEvent.OnServerEvent:Connect(function(player, questId, objectiveIndex, completed)
            handleQuestEvent(player, questId, objectiveIndex, completed)
        end)
    end
end)

-- Export functions for use by other modules
return {
    initializePlayerQuests = initializePlayerQuests,
    updateQuestProgress = updateQuestProgress,
    giveQuestRewards = giveQuestRewards,
}
