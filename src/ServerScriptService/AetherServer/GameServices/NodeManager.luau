            local nodeId = "Node_" .. biomeName:gsub(" ", "_") .. "_" .. i
            local position = biomePositions[math.random(1, #biomePositions)] or Vector3.new(0, 0, 0)
            
            local nodeData = createNodeData(nodeId, nodeType, position, biomeName)
            nodeData[nodeId] = nodeData
            
            -- Save the node
            saveNodeData(nodeId, nodeData)
        end
    end
    
    NodeDataStore:SetAsync("Nodes", nodeData)
end

function NodeManager:UpdateNodeState(nodeId)
    local nodeData = loadNodeData(nodeId)
    if not nodeData then
        warn("Node data not found: " .. nodeId)
        return false
    end
    
    -- Check if node is respawning
    if nodeData.State == NODE_STATES.Respawning then
        local elapsed = os.time() - nodeData.LastRespawn
        if elapsed >= nodeData.RespawnTime then
            nodeData.State = NODE_STATES.Available
            nodeData.LastRespawn = 0
            saveNodeData(nodeId, nodeData)
            
            -- Sync state to clients
            self:SyncNodeState(nodeId, nodeData.State)
            return true
        end
    end
    
    return true
end

function NodeManager:SyncNodeState(nodeId, state)
    local nodeData = loadNodeData(nodeId)
    if not nodeData then
        warn("Node data not found: " .. nodeId)
        return false
    end
    
    nodeData.State = state
    saveNodeData(nodeId, nodeData)
    
    -- Fire event to clients
    local nodeEvent = ReplicatedStorage:WaitForChild("NodeEvents"):WaitForChild("NodeStateUpdate")
    nodeEvent:FireAllClients(nodeId, state)
    
    return true
end

function NodeManager:HandleNodeInteraction(player, nodeId, tool)
    local nodeData = loadNodeData(nodeId)
    if not nodeData then
        warn("Node data not found: " .. nodeId)
        return false, "Node not found"
    end
    
    -- Validate interaction
    local valid, reason = checkNodeInteractionValidation(player, nodeId, nodeData.Position, tool)
    if not valid then
        return false, reason
    end
    
    -- Check if node is available
    if nodeData.State ~= NODE_STATES.Available then
        return false, "Node not available"
    end
    
    -- Update last interaction time
    nodeData.LastInteraction = os.time()
    saveNodeData(nodeId, nodeData)
    
    -- Determine critical roll
    local criticalRoll = math.random() < 0.1 -- 10% chance for critical
    
    -- Generate loot
    local loot = generateLoot(nodeData.Type, criticalRoll)
    
    -- Update node state
    nodeData.State = NODE_STATES.Depleted
    saveNodeData(nodeId, nodeData)
    
    -- Sync state to clients
    self:SyncNodeState(nodeId, nodeData.State)
    
    -- Fire event to client with loot
    local nodeEvent = ReplicatedStorage:WaitForChild("NodeEvents"):WaitForChild("NodeInteractionResult")
    nodeEvent:FireClient(player, nodeId, loot, criticalRoll)
    
    -- Start respawn timer
    nodeData.LastRespawn = os.time()
    nodeData.State = NODE_STATES.Respawning
    saveNodeData(nodeId, nodeData)
    
    -- Sync state to clients
    self:SyncNodeState(nodeId, nodeData.State)
    
    return true, "Interaction successful"
end

function NodeManager:GetNodeInfo(nodeId)
    local nodeData = loadNodeData(nodeId)
    if not nodeData then
        warn("Node data not found: " .. nodeId)
        return nil
    end
    
    return {
        NodeId = nodeData.NodeId,
        Type = nodeData.Type,
        Position = nodeData.Position,
        State = nodeData.State,
        Biome = nodeData.Biome
    }
end

-- Return module
NodeManager.__index = NodeManager
return setmetatable(NodeManager, {__call = function(self, ...) return self:Initialize(...) end})