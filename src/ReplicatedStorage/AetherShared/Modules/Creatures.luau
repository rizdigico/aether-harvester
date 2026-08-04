--
-- Creatures.luau
-- Creature management module for Aether Harvester Simulator
--

local Creatures = {}

-- Constants
local MAX_CREATURES_PER_PLAYER = 5
local MAX_CREATURE_LEVEL = 20
local TAMING_SUCCESS_CHANCE = 0.7
local BREEDING_SUCCESS_CHANCE = 0.8

--[[
    CREATURE MANAGEMENT STRUCTURE:
    {
        player = {
            character = nil,
            humanoid = nil
        },
        creatures = {
            {
                name = "CreatureName",
                level = 1,
                health = 100,
                maxHealth = 100,
                tamingStatus = "Tamed",
                owner = player,
                stats = {
                    attack = 10,
                    defense = 5,
                    speed = 5,
                    agility = 5,
                    intelligence = 5,
                    luck = 5
                },
                abilities = {
                    {
                        name = "AbilityName",
                        cooldown = 5,
                        lastUsed = 0
                    }
                },
                drops = {
                    {
                        itemName = "ItemName",
                        minQuantity = 1,
                        maxQuantity = 3,
                        chance = 0.7
                    }
                }
            }
        }
    }
]]

-- Initialize creature management
function Creatures.New(player)
    return {
        player = player,
        creatures = {},
    }
end

-- Tame a creature
function Creatures:Tame(creatureName, player)
    local creatureData = Creatures.Get(creatureName)
    if not creatureData then
        warn(string.format("Creature %s not found.", creatureName))
        return false
    end

    -- Check if player already has the creature
    for _, creature in ipairs(self.creatures) do
        if creature.name == creatureName then
            return false, "Player already has this creature."
        end
    end

    -- Check if creature can be tamed
    if not creatureData.properties.tamable then
        return false, "Creature cannot be tamed."
    end

    -- Check taming requirements
    local success = false
    local inventory = player:GetAttribute("Inventory") or Inventory.New()

    for _, requirement in ipairs(creatureData.taming.requiredItems or {}) do
        if not inventory:HasItem(requirement.itemName, requirement.quantity) then
            return false, string.format("Missing required item: %s (%d).", requirement.itemName, requirement.quantity)
        end
    end

    -- Check taming success chance
    if math.random() <= TAMING_SUCCESS_CHANCE then
        success = true
    end

    -- Create tamed creature
    if success then
        -- Remove required items
        for _, requirement in ipairs(creatureData.taming.requiredItems or {}) do
            inventory:RemoveItem(requirement.itemName, requirement.quantity)
        end

        -- Add tamed creature to player
        table.insert(self.creatures, {
            name = creatureName,
            level = 1,
            health = creatureData.stats.health,
            maxHealth = creatureData.stats.maxHealth,
            tamingStatus = "Tamed",
            owner = player,
            stats = {
                attack = creatureData.stats.attack,
                defense = creatureData.stats.defense,
                speed = creatureData.stats.speed,
                agility = creatureData.stats.agility,
                intelligence = creatureData.stats.intelligence,
                luck = creatureData.stats.luck,
            },
            abilities = creatureData.abilities or {},
            drops = creatureData.drops or {},
        })

        -- Spawn creature model
        self:SpawnCreatureModel(creatureName, player)

        return true, "Creature tamed successfully!"
    else
        return false, "Failed to tame creature."
    end
end

-- Spawn creature model
function Creatures:SpawnCreatureModel(creatureName, player)
    local creatureData = Creatures.Get(creatureName)
    if not creatureData then
        warn(string.format("Creature %s not found.", creatureName))
        return false
    end

    -- Create creature model
    local creatureModel = Instance.new("Model")
    creatureModel.Name = creatureName
    creatureModel.Parent = workspace

    -- Create humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.Name = "CreatureHumanoid"
    humanoid.Parent = creatureModel

    -- Set creature stats
    humanoid.MaxHealth = creatureData.stats.health
    humanoid.Health = creatureData.stats.health
    humanoid.WalkSpeed = creatureData.stats.speed * 2
    humanoid.JumpPower = 5

    -- Set attributes
    humanoid:SetAttribute("CreatureName", creatureName)
    humanoid:SetAttribute("Owner", player)
    humanoid:SetAttribute("Level", 1)
    humanoid:SetAttribute("TamingStatus", "Tamed")

    -- Create head
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(3, 3, 3)
    head.Anchored = false
    head.CanCollide = true
    head.Parent = creatureModel

    -- Create body
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(6, 4, 6)
    body.Anchored = false
    body.CanCollide = true
    body.Parent = creatureModel

    -- Position head and body
    head.Position = body.Position + Vector3.new(0, 3, 0)

    -- Follow player
    local connection
    connection = game:GetService("RunService"):Connect(function(deltaTime)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = player.Character.HumanoidRootPart.Position
            targetPosition.Y = targetPosition.Y + 2
            humanoid:MoveTo(targetPosition)
        end
    end)

    -- Clean up connection when creature is no longer needed
    local function cleanup()
        if connection then
            connection:Disconnect()
        end
        if creatureModel then
            creatureModel:Destroy()
        end
    end

    -- Store cleanup function
    for _, creature in ipairs(self.creatures) do
        if creature.name == creatureName then
            creature.cleanup = cleanup
            break
        end
    end

    return true
end

-- Breed two creatures
function Creatures:Breed(creature1Name, creature2Name, player)
    local creature1Data = Creatures.Get(creature1Name)
    local creature2Data = Creatures.Get(creature2Name)

    if not creature1Data or not creature2Data then
        warn(string.format("One or both creatures not found."))
        return false
    end

    -- Check if creatures can breed
    for _, compatibleSpecies in ipairs(creature1Data.breeding.compatibleSpecies or {}) do
        if compatibleSpecies == creature2Name then
            break
        end
    end

    -- Check breeding success chance
    if math.random() <= BREEDING_SUCCESS_CHANCE then
        -- Determine offspring
        local offspring = nil
        for _, offspringData in ipairs(creature1Data.breeding.offspring or {}) do
            if math.random() <= offspringData.chance then
                offspring = offspringData.name
                break
            end
        end

        if not offspring then
            return false, "Breeding failed: no valid offspring."
        end

        -- Add offspring to player
        table.insert(self.creatures, {
            name = offspring,
            level = 1,
            health = Creatures.Get(offspring).stats.health,
            maxHealth = Creatures.Get(offspring).stats.maxHealth,
            tamingStatus = "Egg",
            owner = player,
            stats = {
                attack = Creatures.Get(offspring).stats.attack,
                defense = Creatures.Get(offspring).stats.defense,
                speed = Creatures.Get(offspring).stats.speed,
                agility = Creatures.Get(offspring).stats.agility,
                intelligence = Creatures.Get(offspring).stats.intelligence,
                luck = Creatures.Get(offspring).stats.luck,
            },
            abilities = Creatures.Get(offspring).abilities or {},
            drops = Creatures.Get(offspring).drops or {},
        })

        return true,
            string.format("Successfully bred %s and %s to produce %s!", creature1Name, creature2Name, offspring)
    else
        return false, "Breeding failed."
    end
end

-- Train a creature
function Creatures:Train(creatureName, statType, player)
    local creature = nil
    for _, c in ipairs(self.creatures) do
        if c.name == creatureName then
            creature = c
            break
        end
    end

    if not creature then
        warn(string.format("Creature %s not found.", creatureName))
        return false
    end

    local creatureData = Creatures.Get(creatureName)
    if not creatureData then
        warn(string.format("Creature data %s not found.", creatureName))
        return false
    end

    -- Check if creature can be trained
    if not creatureData.properties.breedable then
        return false, "Creature cannot be trained."
    end

    -- Check training stats
    if not creatureData.training.stats[statType] then
        return false, string.format("Cannot train %s stat.", statType)
    end

    -- Increase creature level
    if creature.level < MAX_CREATURE_LEVEL then
        creature.level = creature.level + 1

        -- Increase stats
        local statGrowth = creatureData.training.stats[statType].growth or 0
        if statType == "health" then
            creature.maxHealth = creature.maxHealth + creatureData.training.stats[statType].base
            creature.health = creature.maxHealth
        elseif statType == "attack" then
            creature.stats.attack = creature.stats.attack + creatureData.training.stats[statType].base
        elseif statType == "defense" then
            creature.stats.defense = creature.stats.defense + creatureData.training.stats[statType].base
        elseif statType == "speed" then
            creature.stats.speed = creature.stats.speed + creatureData.training.stats[statType].base
        end

        -- Update model
        self:UpdateCreatureModel(creatureName, player)

        return true, string.format("Successfully trained %s!", creatureName)
    else
        return false, string.format("Creature %s is already at max level.", creatureName)
    end
end

-- Update creature model
function Creatures:UpdateCreatureModel(creatureName, player)
    -- Find creature model
    local creatureModel = workspace:FindFirstChild(creatureName)
    if not creatureModel then
        warn(string.format("Creature model %s not found.", creatureName))
        return false
    end

    -- Update humanoid stats
    local humanoid = creatureModel:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.MaxHealth = self:GetCreature(creatureName).maxHealth
        humanoid.Health = self:GetCreature(creatureName).health
        humanoid.WalkSpeed = self:GetCreature(creatureName).stats.speed * 2
    end

    return true
end

-- Get creature by name
function Creatures:GetCreature(creatureName)
    for _, creature in ipairs(self.creatures) do
        if creature.name == creatureName then
            return creature
        end
    end
    return nil
end

-- Get all creatures
function Creatures:GetAll()
    return self.creatures
end

-- Get creature count
function Creatures:GetCount()
    return #self.creatures
end

-- Get creature by index
function Creatures:Get(index)
    if index and index > 0 and index <= #self.creatures then
        return self.creatures[index]
    end
    return nil
end

-- Release a creature
function Creatures:Release(creatureName, player)
    local creature = self:GetCreature(creatureName)
    if not creature then
        warn(string.format("Creature %s not found.", creatureName))
        return false
    end

    -- Remove creature from player
    for i, c in ipairs(self.creatures) do
        if c.name == creatureName then
            table.remove(self.creatures, i)
            break
        end
    end

    -- Drop items from creature
    local drops = creature.drops or {}
    for _, drop in ipairs(drops) do
        local item = Items.Get(drop.itemName)
        if item then
            local quantity = math.random(drop.minQuantity, drop.maxQuantity)
            if math.random() <= drop.chance then
                local inventory = player:GetAttribute("Inventory") or Inventory.New()
                inventory:AddItem(drop.itemName, quantity)
            end
        end
    end

    -- Destroy creature model
    local creatureModel = workspace:FindFirstChild(creatureName)
    if creatureModel then
        creatureModel:Destroy()
    end

    return true
end

-- Battle between two creatures
function Creatures:Battle(creature1Name, creature2Name, player)
    local creature1 = self:GetCreature(creature1Name)
    local creature2 = self:GetCreature(creature2Name)

    if not creature1 or not creature2 then
        warn(string.format("One or both creatures not found."))
        return false
    end

    -- Simulate battle
    local winner = nil
    local loser = nil

    -- Battle logic
    while creature1.health > 0 and creature2.health > 0 do
        -- Creature 1 attacks
        local dmg1 = creature1.stats.attack * (1 + (math.random() / 10))
        creature2.health = math.max(0, creature2.health - dmg1)

        -- Creature 2 attacks
        local dmg2 = creature2.stats.attack * (1 + (math.random() / 10))
        creature1.health = math.max(0, creature1.health - dmg2)
    end

    -- Determine winner
    if creature1.health <= 0 then
        winner = creature2
        loser = creature1
    else
        winner = creature1
        loser = creature2
    end

    -- Drop items from loser
    local drops = loser.drops or {}
    for _, drop in ipairs(drops) do
        local item = Items.Get(drop.itemName)
        if item then
            local quantity = math.random(drop.minQuantity, drop.maxQuantity)
            if math.random() <= drop.chance then
                local inventory = player:GetAttribute("Inventory") or Inventory.New()
                inventory:AddItem(drop.itemName, quantity)
            end
        end
    end

    -- Return winner
    return winner.name
end

return Creatures
