--
-- Harvesting.luau
-- Harvesting logic module for Aether Harvester Simulator
--

local Harvesting = {}

-- Constants
local MINING_SPEED = 1.0
local MINING_POWER = 10
local HARVESTING_CRITICAL_CHANCE = 0.1
local HARVESTING_CRITICAL_MULTIPLIER = 2.0

--[[
    HARVESTING STRUCTURE:
    {
        node = {
            type = "ResourceNode",
            itemName = "Resource",
            quantity = 10,
            respawnTime = 30,
            lastHarvested = os.time(),
            state = "available"
        },
        tool = {
            name = "ToolName",
            miningSpeed = 1.0,
            miningPower = 10,
            durability = 100,
            criticalChance = 0.1
        },
        player = {
            character = nil,
            humanoid = nil,
            miningSpeed = 1.0
        }
    }
]]

-- Initialize a new harvesting session
function Harvesting.New(node, tool, player)
    return {
        node = node,
        tool = tool,
        player = player,
    }
end

-- Check if node is available for harvesting
function Harvesting:IsNodeAvailable()
    if not self.node then
        return false
    end

    local currentTime = os.time()
    if currentTime - self.node.lastHarvested < self.node.respawnTime then
        return false
    end

    return true
end

-- Harvest a node
function Harvesting:Harvest()
    if not self:IsNodeAvailable() then
        return false, "Node is not available for harvesting."
    end

    local node = self.node
    local tool = self.tool
    local player = self.player

    -- Check if player has the required tool
    if not tool then
        return false, "No tool equipped."
    end

    -- Check if player is close enough to the node
    if not player.character then
        return false, "Player has no character."
    end

    local humanoidRootPart = player.character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return false, "Player has no HumanoidRootPart."
    end

    local distance = (humanoidRootPart.Position - node.Position).Magnitude
    if distance > 5 then
        return false, "Player is too far from the node."
    end

    -- Calculate harvest time
    local harvestTime = (node.quantity / (tool.miningSpeed * tool.miningPower)) * 1000

    -- Simulate harvest time
    local startTime = os.clock()
    while os.clock() - startTime < harvestTime / 1000 do
        task.wait()
    end

    -- Check for critical hit
    local criticalHit = false
    if math.random() <= tool.criticalChance then
        criticalHit = true
    end

    -- Calculate final quantity
    local finalQuantity = node.quantity
    if criticalHit then
        finalQuantity = math.floor(node.quantity * HARVESTING_CRITICAL_MULTIPLIER)
    end

    -- Update node
    node.quantity = math.max(0, node.quantity - finalQuantity)
    node.lastHarvested = os.time()

    -- Add items to player's inventory
    local inventory = player:GetAttribute("Inventory") or Inventory.New()
    if not inventory:AddItem(node.itemName, finalQuantity) then
        warn("Failed to add items to player's inventory.")
    end

    -- Play sound and particle effects
    local sound = Instance.new("Sound")
    sound.Name = "HarvestSound"
    sound.SoundId = "rbxassetid://123456789"
    sound.Volume = 0.5
    sound.Parent = workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)

    -- Play particle effect
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Name = "HarvestParticles"
    particleEmitter.Texture = "rbxassetid://987654321"
    particleEmitter.LightEmission = 0.5
    particleEmitter.Lifetime = NumberSequence.new({ 0.5, 1.0 })
    particleEmitter.EmissionDirection = Enum.NormalId.Top
    particleEmitter.Parent = node
    game:GetService("Debris"):AddItem(particleEmitter, 2)

    -- Update player's mining speed attribute
    player:SetAttribute("MiningSpeed", player:GetAttribute("MiningSpeed") or MINING_SPEED)

    -- Return success
    return true, finalQuantity, criticalHit
end

-- Get harvestable nodes in a radius
function Harvesting.GetHarvestableNodes(player, radius)
    local nodes = {}
    local character = player.Character
    if not character then
        return nodes
    end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return nodes
    end

    -- Find all resource nodes in the game
    local resourceNodes = workspace:FindFirstChildOfClass("ResourceNode")
    if not resourceNodes then
        return nodes
    end

    -- Check each node
    for _, node in ipairs(resourceNodes:GetChildren()) do
        if node:IsA("BasePart") then
            local distance = (humanoidRootPart.Position - node.Position).Magnitude
            if distance <= radius and node:GetAttribute("State") == "available" then
                table.insert(nodes, node)
            end
        end
    end

    return nodes
end

-- Get tool stats
function Harvesting.GetToolStats(toolName)
    local item = Items.Get(toolName)
    if not item or item.type ~= Enum.ItemType.Tool then
        return nil
    end

    return {
        miningSpeed = item.properties.miningSpeed or MINING_SPEED,
        miningPower = item.properties.miningPower or MINING_POWER,
        durability = item.properties.durability or 100,
        criticalChance = item.properties.criticalChance or HARVESTING_CRITICAL_CHANCE,
    }
end

-- Update tool durability
function Harvesting.UpdateToolDurability(toolName, damage)
    local item = Items.Get(toolName)
    if not item or item.type ~= Enum.ItemType.Tool then
        return false
    end

    -- Find the tool in player's inventory
    local player = game.Players:GetPlayerFromCharacter(playerCharacter)
    if not player then
        return false
    end

    local inventory = player:GetAttribute("Inventory") or Inventory.New()
    for i, slot in ipairs(inventory:GetSlots()) do
        if slot.itemName == toolName then
            slot.durability = math.max(0, (slot.durability or item.properties.durability) - damage)
            return true
        end
    end

    return false
end

-- Get critical chance multiplier
function Harvesting.GetCriticalChanceMultiplier()
    return HARVESTING_CRITICAL_MULTIPLIER
end

return Harvesting
