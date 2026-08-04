local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Input state
local InputState = {
    MoveVector = Vector2.new(0, 0),
    IsJumping = false,
    IsSprinting = false,
    HarvestPressed = false,
    PetPressed = false,
    InventoryPressed = false,
    QuestPressed = false,
    MapPressed = false,
    SettingsPressed = false,
}

-- Key bindings (customizable)
local KeyBindings = {
    Harvest = Enum.KeyCode.E,
    Pet = Enum.KeyCode.R,
    Inventory = Enum.KeyCode.Tab,
    Quest = Enum.KeyCode.Q,
    Map = Enum.KeyCode.M,
    Settings = Enum.KeyCode.Escape,
    Sprint = Enum.KeyCode.LeftShift,
    Jump = Enum.KeyCode.Space,
}

-- Input handler
local InputHandler = {}

function InputHandler:Initialize()
    print("[InputHandler] Initializing...")

    -- Connect input events
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        self:OnInputBegan(input)
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        self:OnInputEnded(input)
    end)

    -- Connect character events
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = character:WaitForChild("Humanoid")
    end)

    print("[InputHandler] Initialized")
end

function InputHandler:OnInputBegan(input)
    -- Movement
    if input.KeyCode == KeyBindings.Sprint then
        InputState.IsSprinting = true
        humanoid.WalkSpeed = 32
    end

    if input.KeyCode == KeyBindings.Jump then
        InputState.IsJumping = true
    end

    -- Actions
    if input.KeyCode == KeyBindings.Harvest then
        InputState.HarvestPressed = true
        self:HandleHarvest()
    end

    if input.KeyCode == KeyBindings.Pet then
        InputState.PetPressed = true
        self:HandlePet()
    end

    if input.KeyCode == KeyBindings.Inventory then
        InputState.InventoryPressed = true
        self:HandleInventory()
    end

    if input.KeyCode == KeyBindings.Quest then
        InputState.QuestPressed = true
        self:HandleQuest()
    end

    if input.KeyCode == KeyBindings.Map then
        InputState.MapPressed = true
        self:HandleMap()
    end

    if input.KeyCode == KeyBindings.Settings then
        InputState.SettingsPressed = true
        self:HandleSettings()
    end
end

function InputHandler:OnInputEnded(input)
    if input.KeyCode == KeyBindings.Sprint then
        InputState.IsSprinting = false
        humanoid.WalkSpeed = 16
    end

    if input.KeyCode == KeyBindings.Jump then
        InputState.IsJumping = false
    end
end

function InputHandler:HandleHarvest()
    -- Get target node from raycast
    local camera = workspace.CurrentCamera
    local mousePos = UserInputService:GetMouseLocation()
    local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = { character }
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(ray.Origin, ray.Direction * 50, raycastParams)

    if result and result.Instance then
        -- Check if we hit a creature (tame it)
        local creature = result.Instance:FindFirstAncestorOfClass("Model")
        if creature and creature:GetAttribute("CreatureId") then
            local TameCreature = game.ReplicatedStorage.AetherShared.Remotes:FindFirstChild("TameCreature")
            if TameCreature then
                TameCreature:FireServer(creature)
            end
            return
        end
        -- Check if we hit a resource node
        local node = result.Instance:FindFirstAncestorOfClass("Model")
        if node and node:GetAttribute("NodeId") then
            local GameClient = require(game.ReplicatedStorage.AetherShared.Modules.GameClient)
            GameClient:HarvestNode(node:GetAttribute("NodeId"))
        end
    end
end

function InputHandler:HandlePet()
    -- Toggle pet follow/summon
    local GameClient = require(game.ReplicatedStorage.AetherShared.Modules.GameClient)
    if GameClient.State.ActivePet then
        GameClient:EquipPet(GameClient.State.ActivePet)
    end
end

function InputHandler:HandleInventory()
    local GameClient = require(game.ReplicatedStorage.AetherShared.Modules.GameClient)
    GameClient:OpenScreen("InventoryScreen")
end

function InputHandler:HandleQuest()
    local GameClient = require(game.ReplicatedStorage.AetherShared.Modules.GameClient)
    GameClient:OpenScreen("QuestLogScreen")
end

function InputHandler:HandleMap()
    local GameClient = require(game.ReplicatedStorage.AetherShared.Modules.GameClient)
    GameClient:OpenScreen("MapScreen")
end

function InputHandler:HandleSettings()
    local GameClient = require(game.ReplicatedStorage.AetherShared.Modules.GameClient)
    GameClient:OpenScreen("SettingsScreen")
end

-- Initialize
InputHandler:Initialize()

-- Expose for other scripts
_G.InputHandler = InputHandler
