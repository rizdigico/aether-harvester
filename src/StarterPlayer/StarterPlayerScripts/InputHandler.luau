--
-- InputHandler.luau
-- Handles keyboard, mouse, and touch controls for Aether Harvester Simulator
--

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Constants
local MOVEMENT_SPEED = 16
local JUMP_POWER = 50
local HARVEST_KEY = Enum.KeyCode.E
local INTERACT_KEY = Enum.KeyCode.E

-- Variables
local character = Player.Character or Player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

-- Function to handle movement
local function handleMovement(input: Enum.UserInputType, gameProcessed: boolean)
    if gameProcessed then return end
    
    if input == Enum.UserInputType.Keyboard then
        local key = UserInputService:GetKeyFromKeyCode(input.KeyCode)
        
        if key == "W" then
            if humanoidRootPart then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -MOVEMENT_SPEED * RunService.Heartbeat:Wait())
            end
        elseif key == "A" then
            if humanoidRootPart then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(-MOVEMENT_SPEED * RunService.Heartbeat:Wait(), 0, 0)
            end
        elseif key == "S" then
            if humanoidRootPart then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, MOVEMENT_SPEED * RunService.Heartbeat:Wait())
            end
        elseif key == "D" then
            if humanoidRootPart then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(MOVEMENT_SPEED * RunService.Heartbeat:Wait(), 0, 0)
            end
        end
    end
end

-- Function to handle jump
local function handleJump(input: Enum.UserInputType, gameProcessed: boolean)
    if gameProcessed or input ~= Enum.UserInputType.Keyboard or UserInputService:GetKeyCode(input.KeyCode) ~= Enum.KeyCode.Space then
        return
    end
    
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Function to handle harvest
local function handleHarvest(input: Enum.UserInputType, gameProcessed: boolean)
    if gameProcessed or input ~= Enum.UserInputType.Keyboard or UserInputService:GetKeyCode(input.KeyCode) ~= HARVEST_KEY then
        return
    end
    
    -- Check if player is holding a tool
    local tool = Player.Character:FindFirstChildOfClass("Tool")
    if tool then
        -- Find the closest harvestable node
        local closestNode = nil
        local closestDistance = math.huge
        
        for _, node in ipairs(workspace:GetDescendants()) do
            if node:IsA("BasePart") and node:FindFirstChildOfClass("ClickDetector") then
                local distance = (humanoidRootPart.Position - node.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestNode = node
                end
            end
        end
        
        if closestNode then
            -- Fire harvest event to server
            game:GetService("ReplicatedStorage"):FindFirstChild("HarvestEvent"):FireServer(closestNode.Name, tool)
        end
    end
end

-- Function to handle interaction
local function handleInteraction(input: Enum.UserInputType, gameProcessed: boolean)
    if gameProcessed or input ~= Enum.UserInputType.Keyboard or UserInputService:GetKeyCode(input.KeyCode) ~= INTERACT_KEY then
        return
    end
    
    -- Check if player is near an interactable object
    local closestObject = nil
    local closestDistance = math.huge
    
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("BasePart") and object:FindFirstChildOfClass("ClickDetector") then
            local distance = (humanoidRootPart.Position - object.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestObject = object
            end
        end
    end
    
    if closestObject then
        -- Fire interaction event to server
        game:GetService("ReplicatedStorage"):FindFirstChild("InteractionEvent"):FireServer(closestObject.Name)
    end
end

-- Function to handle character added
local function onCharacterAdded(newCharacter: Model)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    -- Reconnect input handlers
    UserInputService.InputBegan:Connect(handleMovement)
    UserInputService.InputBegan:Connect(handleJump)
    UserInputService.InputBegan:Connect(handleHarvest)
    UserInputService.InputBegan:Connect(handleInteraction)
end

-- Connect to character added event
Player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize input handlers
UserInputService.InputBegan:Connect(handleMovement)
UserInputService.InputBegan:Connect(handleJump)
UserInputService.InputBegan:Connect(handleHarvest)
UserInputService.InputBegan:Connect(handleInteraction)

-- Handle initial character
if character then
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
end