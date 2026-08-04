--
-- CreatureService.luau
-- Manages creature persistence, taming, breeding, and battles
--

local Players = game:GetService("Players")
local DataStoreService = require(script.Parent.DataStoreService)

-- Constants
local MAX_CREATURES_PER_PLAYER = 10
local CREATURE_TYPES = {
    Rabbit = {
        name = "Rabbit",
        maxHealth = 100,
        attack = 10,
        defense = 5,
        speed = 20,
        rarity = "Common"
    },
    Fox = {
        name = "Fox",
        maxHealth = 120,
        attack = 15,
        defense = 8,
        speed = 25,
        rarity = "Uncommon"
    },
    Wolf = {
        name = "Wolf",
        maxHealth = 150,
        attack = 20,
        defense = 10,
        speed = 22,
        rarity = "Rare"
    }
}

-- Function to initialize player creatures
local function initializePlayerCreatures(player: Player)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Creatures then
        playerData.Creatures = {
            tamed = {},
            trained = {}
        }
    end
    player:SetAttribute("PlayerData", playerData)
end

-- Function to tame a creature
local function tameCreature(player: Player, creatureType: string, creature: Instance)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Creatures then
        return false, "Creatures data not found."
    end
    
    -- Check if the creature type exists
    if not CREATURE_TYPES[creatureType] then
        return false, "Creature type not found."
    end
    
    -- Check if the player already has the maximum number of creatures
    if #playerData.Creatures.tamed >= MAX_CREATURES_PER_PLAYER then
        return false, "Maximum number of creatures reached."
    end
    
    -- Check if the creature is already tamed
    for _, tamedCreature in pairs(playerData.Creatures.tamed) do
        if tamedCreature.creatureType == creatureType then
            return false, "Creature already tamed."
        end
    end
    
    -- Add the creature to the player's tamed creatures
    local newCreature = {
        creatureType = creatureType,
        health = CREATURE_TYPES[creatureType].maxHealth,
        level = 1,
        xp = 0,
        stats = CREATURE_TYPES[creatureType]
    }
    
    table.insert(playerData.Creatures.tamed, newCreature)
    
    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Creatures = playerData.Creatures
    })
    
    -- Notify client
    game:GetService("ReplicatedStorage"):FindFirstChild("CreatureEvent"):FireClient(player, "tamed", newCreature)
    
    return true, "Creature tamed."
end

-- Function to train a creature
local function trainCreature(player: Player, creatureIndex: number, xp: number)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Creatures then
        return false, "Creatures data not found."
    end
    
    -- Check if the creature exists
    if not playerData.Creatures.tamed[creatureIndex] then
        return false, "Creature not found."
    end
    
    local creature = playerData.Creatures.tamed[creatureIndex]
    
    -- Add XP to the creature
    creature.xp = creature.xp + xp
    
    -- Check for level-up
    local levelUpThreshold = (creature.level - 1) * 50 + 100
    if creature.xp >= levelUpThreshold then
        creature.level = creature.level + 1
        creature.xp = creature.xp - levelUpThreshold
        
        -- Increase stats based on level
        creature.stats.attack = creature.stats.attack + 2
        creature.stats.defense = creature.stats.defense + 1
        creature.stats.speed = creature.stats.speed + 1
    end
    
    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Creatures = playerData.Creatures
    })
    
    -- Notify client
    game:GetService("ReplicatedStorage"):FindFirstChild("CreatureEvent"):FireClient(player, "trained", creature)
    
    return true, "Creature trained."
end

-- Function to breed two creatures
local function breedCreatures(player: Player, creatureIndex1: number, creatureIndex2: number)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Creatures then
        return false, "Creatures data not found."
    end
    
    -- Check if the creatures exist
    if not playerData.Creatures.tamed[creatureIndex1] or not playerData.Creatures.tamed[creatureIndex2] then
        return false, "One or both creatures not found."
    end
    
    local creature1 = playerData.Creatures.tamed[creatureIndex1]
    local creature2 = playerData.Creatures.tamed[creatureIndex2]
    
    -- Check if the creatures are of the same type
    if creature1.creatureType ~= creature2.creatureType then
        return false, "Cannot breed different creature types."
    end
    
    -- Check if the player already has the maximum number of creatures
    if #playerData.Creatures.tamed >= MAX_CREATURES_PER_PLAYER then
        return false, "Maximum number of creatures reached."
    end
    
    -- Create a new creature (child)
    local childCreatureType = creature1.creatureType
    local childCreature = {
        creatureType = childCreatureType,
        health = CREATURE_TYPES[childCreatureType].maxHealth,
        level = 1,
        xp = 0,
        stats = {
            attack = math.floor((CREATURE_TYPES[childCreatureType].attack + creature1.stats.attack + creature2.stats.attack) / 3),
            defense = math.floor((CREATURE_TYPES[childCreatureType].defense + creature1.stats.defense + creature2.stats.defense) / 3),
            speed = math.floor((CREATURE_TYPES[childCreatureType].speed + creature1.stats.speed + creature2.stats.speed) / 3)
        }
    }
    
    -- Add the child creature to the player's tamed creatures
    table.insert(playerData.Creatures.tamed, childCreature)
    
    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Creatures = playerData.Creatures
    })
    
    -- Notify client
    game:GetService("ReplicatedStorage"):FindFirstChild("CreatureEvent"):FireClient(player, "bred", childCreature)
    
    return true, "Creatures bred."
end

-- Function to handle creature battles
local function handleCreatureBattle(player: Player, creatureIndex: number, opponentCreature: table)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Creatures then
        return false, "Creatures data not found."
    end
    
    -- Check if the creature exists
    if not playerData.Creatures.tamed[creatureIndex] then
        return false, "Creature not found."
    end
    
    local creature = playerData.Creatures.tamed[creatureIndex]
    
    -- Simulate battle logic
    local playerDamage = math.floor(creature.stats.attack * 0.8)
    local opponentDamage = math.floor(opponentCreature.stats.attack * 0.8)
    
    creature.health = creature.health - opponentDamage
    
    -- Check if the player's creature is defeated
    if creature.health <= 0 then
        creature.health = 0
        return false, "Creature defeated."
    end
    
    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Creatures = playerData.Creatures
    })
    
    -- Notify client
    game:GetService("ReplicatedStorage"):FindFirstChild("CreatureEvent"):FireClient(player, "battle_result", creature)
    
    return true, "Battle in progress."
end

-- Initialize creature data for existing players
for _, player in ipairs(Players:GetPlayers()) do
    initializePlayerCreatures(player)
end

-- Connect to player added event
Players.PlayerAdded:Connect(function(player)
    initializePlayerCreatures(player)
    
    -- Connect to remote events
    local creatureEvent = game:GetService("ReplicatedStorage"):FindFirstChild("CreatureEvent")
    if creatureEvent then
        creatureEvent.OnServerEvent:Connect(function(player, action, ...)
            if action == "tame" then
                local creatureType, creature = ..., ...
                tameCreature(player, creatureType, creature)
            elseif action == "train" then
                local creatureIndex, xp = ..., ...
                trainCreature(player, creatureIndex, xp)
            elseif action == "breed" then
                local creatureIndex1, creatureIndex2 = ..., ...
                breedCreatures(player, creatureIndex1, creatureIndex2)
            elseif action == "battle" then
                local creatureIndex, opponentCreature = ..., ...
                handleCreatureBattle(player, creatureIndex, opponentCreature)
            end
        end)
    end
end

-- Export functions for use by other modules
return {
    initializePlayerCreatures = initializePlayerCreatures,
    tameCreature = tameCreature,
    trainCreature = trainCreature,
    breedCreatures = breedCreatures,
    handleCreatureBattle = handleCreatureBattle
}