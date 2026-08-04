--
-- Minimap.luau
-- Creates and manages the island minimap with player markers and harvestable nodes
--

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Constants
local MINIMAP_SIZE = UDim2.new(0, 200, 0, 200)
local MINIMAP_POSITION = UDim2.new(0.9, -100, 0.9, -100)
local PLAYER_MARKER_SIZE = UDim2.new(0, 10, 0, 10)
local NODE_MARKER_SIZE = UDim2.new(0, 8, 0, 8)

-- Create minimap frame
local MinimapFrame = Instance.new("ScreenGui")
MinimapFrame.Name = "MinimapFrame"
MinimapFrame.Parent = PlayerGui

-- Create minimap container
local MinimapContainer = Instance.new("Frame")
MinimapContainer.Name = "MinimapContainer"
MinimapContainer.Size = MINIMAP_SIZE
MinimapContainer.Position = MINIMAP_POSITION
MinimapContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimapContainer.BorderSizePixel = 2
MinimapContainer.BorderColor3 = Color3.fromRGB(100, 100, 100)
MinimapContainer.Parent = MinimapFrame

-- Create minimap image
local MinimapImage = Instance.new("ImageLabel")
MinimapImage.Name = "MinimapImage"
MinimapImage.Size = UDim2.new(1, 0, 1, 0)
MinimapImage.Position = UDim2.new(0, 0, 0, 0)
MinimapImage.BackgroundTransparency = 1
MinimapImage.Image = "rbxassetid://454481894" -- Default minimap texture
MinimapImage.Parent = MinimapContainer

-- Create player marker
local PlayerMarker = Instance.new("ImageLabel")
PlayerMarker.Name = "PlayerMarker"
PlayerMarker.Size = PLAYER_MARKER_SIZE
PlayerMarker.Position = UDim2.new(0.5, 0, 0.5, 0)
PlayerMarker.BackgroundTransparency = 1
PlayerMarker.Image = "rbxassetid://357069579" -- Player marker texture
PlayerMarker.Parent = MinimapContainer

-- Create harvestable node markers
local NodeMarkers = {}

-- Function to update minimap
local function updateMinimap()
    local character = Player.Character
    if not character then
        return
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end
    
    -- Update player marker position
    local camera = workspace.CurrentCamera
    local cameraCFrame = camera.CFrame
    local playerPosition = humanoidRootPart.Position
    local screenPosition, onScreen = camera:WorldToViewportPoint(playerPosition)
    
    if onScreen then
        local minimapSize = MinimapContainer.AbsoluteSize
        local minimapCenter = Vector2.new(minimapSize.X / 2, minimapSize.Y / 2)
        local relativePosition = Vector2.new(screenPosition.X, screenPosition.Y) - minimapCenter
        
        -- Normalize relative position to fit within minimap
        local normalizedPosition = Vector2.new(
            math.clamp(relativePosition.X / minimapSize.X, 0, 1),
            math.clamp(relativePosition.Y / minimapSize.Y, 0, 1)
        )
        
        PlayerMarker.Position = UDim2.new(normalizedPosition.X, 0, normalizedPosition.Y, 0)
    end
    
    -- Update node markers
    for _, nodeMarker in pairs(NodeMarkers) do
        local nodePart = workspace:FindFirstChild(nodeMarker.nodeId)
        if nodePart then
            local nodePosition = nodePart.Position
            local screenPosition, onScreen = camera:WorldToViewportPoint(nodePosition)
            
            if onScreen then
                local minimapSize = MinimapContainer.AbsoluteSize
                local minimapCenter = Vector2.new(minimapSize.X / 2, minimapSize.Y / 2)
                local relativePosition = Vector2.new(screenPosition.X, screenPosition.Y) - minimapCenter
                
                -- Normalize relative position to fit within minimap
                local normalizedPosition = Vector2.new(
                    math.clamp(relativePosition.X / minimapSize.X, 0, 1),
                    math.clamp(relativePosition.Y / minimapSize.Y, 0, 1)
                )
                
                nodeMarker.image.Position = UDim2.new(normalizedPosition.X, 0, normalizedPosition.Y, 0)
            end
        end
    end
end

-- Function to add a harvestable node marker
local function addNodeMarker(nodeId: string, nodePosition: Vector3)
    local nodeMarker = Instance.new("ImageLabel")
    nodeMarker.Name = "NodeMarker" .. nodeId
    nodeMarker.Size = NODE_MARKER_SIZE
    nodeMarker.Position = UDim2.new(0.5, 0, 0.5, 0)
    nodeMarker.BackgroundTransparency = 1
    nodeMarker.Image = "rbxassetid://357069579" -- Node marker texture
    nodeMarker.Parent = MinimapContainer
    
    -- Store reference
    table.insert(NodeMarkers, {
        image = nodeMarker,
        nodeId = nodeId
    })
    
    -- Update marker position
    updateMinimap()
end

-- Function to remove a harvestable node marker
local function removeNodeMarker(nodeId: string)
    for i, nodeMarker in ipairs(NodeMarkers) do
        if nodeMarker.nodeId == nodeId then
            nodeMarker.image:Destroy()
            table.remove(NodeMarkers, i)
            break
        end
    end
end

-- Function to update all node markers
local function updateAllNodeMarkers()
    for _, nodeMarker in pairs(NodeMarkers) do
        local nodePart = workspace:FindFirstChild(nodeMarker.nodeId)
        if nodePart then
            nodeMarker.image.Position = UDim2.new(0.5, 0, 0.5, 0)
        else
            removeNodeMarker(nodeMarker.nodeId)
        end
    end
end

-- Connect to remote events
local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("MinimapEvent")
if remoteEvents then
    remoteEvents.OnClientEvent:Connect(function(action, ...)
        if action == "add_node" then
            local nodeId, nodePosition = ...
            addNodeMarker(nodeId, nodePosition)
        elseif action == "remove_node" then
            local nodeId = ...
            removeNodeMarker(nodeId)
        end
    end)
end

-- Connect to RunService for continuous updates
RunService:BindToRenderStep("MinimapUpdate", Enum.RenderPriority.Camera.Value, updateMinimap)

-- Initialize minimap
local function initializeMinimap()
    -- Add default harvestable nodes
    -- Example: addNodeMarker("Node1", Vector3.new(100, 0, 100))
    -- In a real implementation, these would be populated from the server
end

-- Initialize minimap
initializeMinimap()