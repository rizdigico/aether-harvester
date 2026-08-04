--
-- HarvestingService.luau
-- Manages server-authoritative node state, respawn timers, and harvest actions
--

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local DataStoreService = require(script.Parent.DataStoreService)

-- Constants
local HARVEST_NODES = {} -- Will be populated with node data
local NODE_RESPAWN_TIME = 30 -- Seconds
local HARVEST_COOLDOWN = 5 -- Seconds

-- Function to initialize harvest nodes
local function initializeHarvestNodes()
    -- Example: Populate HARVEST_NODES with node data from the environment
    -- This would typically be done by scanning the workspace for harvestable nodes
    -- For now, we'll simulate some data
    HARVEST_NODES = {
        ["Node1"] = {
            respawnTime = NODE_RESPAWN_TIME,
            currentRespawnTime = 0,
            lastHarvested = 0,
            maxHarvests = 10,
            currentHarvests = 0,
        },
        ["Node2"] = {
            respawnTime = NODE_RESPAWN_TIME,
            currentRespawnTime = 0,
            lastHarvested = 0,
            maxHarvests = 15,
            currentHarvests = 0,
        },
    }

    -- Start respawn timers
    startRespawnTimers()
end

-- Function to start respawn timers for all nodes
local function startRespawnTimers()
    for nodeId, nodeData in pairs(HARVEST_NODES) do
        nodeData.respawnTimer = RunService:CreateConnection(function()
            nodeData.currentRespawnTime = nodeData.currentRespawnTime + 1
            if nodeData.currentRespawnTime >= nodeData.respawnTime then
                nodeData.currentRespawnTime = 0
                nodeData.currentHarvests = 0
                -- Node is now ready to be harvested again
            end
        end)
    end
end

-- Function to validate and process harvest actions
local function validateHarvestAction(player: Player, nodeId: string, tool: Instance)
    -- Check if the node exists
    if not HARVEST_NODES[nodeId] then
        warn("Node does not exist: " .. nodeId)
        return false, "Node does not exist."
    end

    local nodeData = HARVEST_NODES[nodeId]

    -- Check if the node is ready to be harvested
    if nodeData.currentHarvests >= nodeData.maxHarvests then
        return false, "Node is depleted. Wait for it to respawn."
    end

    -- Check if the player has a valid tool
    if not tool or not tool:IsA("Tool") then
        return false, "Invalid tool."
    end

    -- Check if the player is close enough to the node
    local character = player.Character
    if not character then
        return false, "Character not found."
    end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return false, "HumanoidRootPart not found."
    end

    local nodePart = workspace:FindFirstChild(nodeId)
    if not nodePart then
        return false, "Node part not found in workspace."
    end

    local distance = (humanoidRootPart.Position - nodePart.Position).Magnitude
    if distance > 10 then
        return false, "Too far from the node."
    end

    -- Process the harvest
    nodeData.currentHarvests = nodeData.currentHarvests + 1
    nodeData.lastHarvested = tick()

    -- Return success
    return true, "Harvest successful."
end

-- Function to handle remote events for harvest actions
local function handleHarvestEvent(player: Player, nodeId: string, tool: Instance)
    local success, message = validateHarvestAction(player, nodeId, tool)

    if success then
        -- Broadcast harvest success to client
        game:GetService("ReplicatedStorage"):FindFirstChild("HarvestEvent"):FireClient(player, true, nodeId)
        -- Save player data if needed
        DataStoreService.savePlayerData(player, {
            Inventory = {
                -- Example: Add harvested items to player's inventory
                -- This would be implemented based on node type and player's tool
            },
        })
    else
        -- Broadcast harvest failure to client
        game:GetService("ReplicatedStorage"):FindFirstChild("HarvestEvent"):FireClient(player, false, message)
    end
end

-- Initialize harvest nodes
initializeHarvestNodes()

-- Connect to remote events
local harvestEvent = game:GetService("ReplicatedStorage"):FindFirstChild("HarvestEvent")
if harvestEvent then
    harvestEvent.OnServerEvent:Connect(function(player, nodeId, tool)
        handleHarvestEvent(player, nodeId, tool)
    end)
end

-- Export functions for use by other modules
return {
    validateHarvestAction = validateHarvestAction,
    initializeHarvestNodes = initializeHarvestNodes,
}
