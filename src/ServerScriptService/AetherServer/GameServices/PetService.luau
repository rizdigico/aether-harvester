local PetService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local PetsData = require(game.ReplicatedStorage.AetherShared.Data.Pets)

local activePets = {}
local petFollowers = {}
local petIdCounter = 0

local RunService = game:GetService("RunService")
local PetFolder = Instance.new("Folder")
PetFolder.Name = "SummonedPets"
PetFolder.Parent = game.Workspace

-- Pet visual palette by pet class (all neon, small, distinct)
local PET_VISUALS = {
    Harvester = { Color3.fromRGB(120, 220, 160), Color3.fromRGB(180, 255, 200) }, -- green
    Combat = { Color3.fromRGB(255, 120, 120), Color3.fromRGB(255, 200, 160) }, -- red
    Support = { Color3.fromRGB(120, 180, 255), Color3.fromRGB(180, 220, 255) }, -- blue
    Mount = { Color3.fromRGB(220, 160, 255), Color3.fromRGB(240, 210, 255) }, -- purple
}

function PetService.SpawnFollower(player, petId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return
    end
    local petDef = PetsData.GetPet(petId)
    if not petDef then
        return
    end

    -- Remove any existing follower for this player
    local existing = petFollowers[player.UserId]
    if existing then
        existing:Destroy()
    end

    local palette = PET_VISUALS[petDef.Class] or PET_VISUALS.Harvester
    local mdl = Instance.new("Model")
    mdl.Name = "Pet_" .. petId

    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(2, 2, 2)
    body.Shape = Enum.PartType.Ball
    body.Material = Enum.Material.Neon
    body.Color = palette[1]
    body.Anchored = true
    body.CanCollide = false
    body.Parent = mdl

    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(1.2, 1.2, 1.2)
    head.Shape = Enum.PartType.Ball
    head.Material = Enum.Material.Neon
    head.Color = palette[2]
    head.Anchored = true
    head.CanCollide = false
    head.Parent = mdl

    mdl.Parent = PetFolder
    petFollowers[player.UserId] = mdl

    -- Follow the player's character until released
    task.spawn(function()
        while mdl and mdl.Parent do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position + Vector3.new(0, 3.2, 0)
                body.CFrame = CFrame.new(pos)
                head.CFrame = CFrame.new(pos + Vector3.new(0, 1.4, 0))
            end
            task.wait(0.05)
        end
    end)
end

function PetService.DespawnFollower(player)
    local existing = petFollowers[player.UserId]
    if existing then
        existing:Destroy()
        petFollowers[player.UserId] = nil
    end
end

-- Helper function to handle player character changes
local function onPlayerCharacterChanged(player)
    PetService.DespawnFollower(player)
end

-- Connect character change events
local Players = game:GetService("Players")
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        onPlayerCharacterChanged(player)
    end)
    player.CharacterRemoving:Connect(function(character)
        onPlayerCharacterChanged(player)
    end)
end)

function PetService.Initialize()
    print("[PetService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- GetPets: fetch the player's pet inventory
    local GetPets = Remotes:FindFirstChild("GetPets")
    if GetPets then
        GetPets.OnServerInvoke = function(player)
            local data = PlayerDataService.GetData(player)
            if not data then
                return {}
            end
            return data.PetInventory or {}
        end
    end

    -- EquipPet: accepts a numeric InstanceId or a string PetId (client may send either)
    local EquipPet = Remotes:FindFirstChild("EquipPet")
    if EquipPet then
        EquipPet.OnServerEvent:Connect(function(player, petKey)
            if type(petKey) ~= "number" and type(petKey) ~= "string" then
                return
            end
            local data = PlayerDataService.GetData(player)
            if not data then
                return
            end
            local success, message = PetService.EquipPet(player, petKey)
            if not success and type(petKey) == "string" then
                -- Fall back to matching by PetId
                for _, pet in ipairs(data.PetInventory or {}) do
                    if pet.PetId == petKey then
                        PetService.EquipPet(player, pet.InstanceId)
                        success = true
                        break
                    end
                end
            end
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Failed to equip pet")
                end
            end
        end)
    end

    -- UnequipPet: unequip a specific pet by InstanceId
    local UnequipPet = Remotes:FindFirstChild("UnequipPet")
    if UnequipPet then
        UnequipPet.OnServerEvent:Connect(function(player, petInstanceId)
            if type(petInstanceId) ~= "number" then
                return
            end
            local data = PlayerDataService.GetData(player)
            if not data then
                return
            end
            for _, pet in ipairs(data.PetInventory or {}) do
                if pet.InstanceId == petInstanceId then
                    pet.IsEquipped = false
                end
            end
        end)
    end

    -- SummonPet: track the active summoned pet for a player
    local SummonPet = Remotes:FindFirstChild("SummonPet")
    if SummonPet then
        SummonPet.OnServerEvent:Connect(function(player, petId)
            if type(petId) ~= "string" then
                return
            end
            activePets[player.UserId] = petId
            PetService.SpawnFollower(player, petId)
            local PetSummon = Remotes:FindFirstChild("PetSummon")
            if PetSummon then
                PetSummon:FireClient(player, petId)
            end
        end)
    end

    -- ReleasePet: despawn the active pet
    local ReleasePet = Remotes:FindFirstChild("ReleasePet")
    if ReleasePet then
        ReleasePet.OnServerEvent:Connect(function(player)
            activePets[player.UserId] = nil
            PetService.DespawnFollower(player)
            local PetReleased = Remotes:FindFirstChild("PetReleased")
            if PetReleased then
                PetReleased:FireClient(player)
            end
        end)
    end

    print("[PetService] Initialized")
end

function PetService.GivePet(player, petId)
    local petData = PetsData.GetPet(petId)
    if not petData then
        return false, "Invalid pet ID"
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    petIdCounter += 1

    local newPet = {
        InstanceId = petIdCounter,
        PetId = petId,
        Level = 1,
        XP = 0,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        IsEquipped = false,
    }

    table.insert(data.PetInventory, newPet)

    return true, "Pet added to inventory"
end

function PetService.EquipPet(player, petInstanceId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    -- Unequip all other pets
    for _, pet in ipairs(data.PetInventory) do
        pet.IsEquipped = false
    end

    -- Equip selected pet
    for _, pet in ipairs(data.PetInventory) do
        if pet.InstanceId == petInstanceId then
            pet.IsEquipped = true
            return true, "Pet equipped"
        end
    end

    return false, "Pet not found in inventory"
end

function PetService.FeedPet(player, petInstanceId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    for _, pet in ipairs(data.PetInventory) do
        if pet.InstanceId == petInstanceId then
            local success, message = PetsData.FeedPet(pet.PetId)
            if success then
                pet.Hunger = PetsData.GetPet(pet.PetId).Hunger
                pet.Happiness = PetsData.GetPet(pet.PetId).Happiness
            end
            return success, message
        end
    end

    return false, "Pet not found"
end

function PetService.GetEquippedPet(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return nil
    end

    for _, pet in ipairs(data.PetInventory) do
        if pet.IsEquipped then
            return pet
        end
    end

    return nil
end

function PetService.GetPetBonuses(player)
    local equippedPet = PetService.GetEquippedPet(player)
    if not equippedPet then
        return { HarvestPower = 0, Speed = 0, Luck = 0, Defense = 0 }
    end

    local petData = PetsData.GetPet(equippedPet.PetId)
    if not petData then
        return { HarvestPower = 0, Speed = 0, Luck = 0, Defense = 0 }
    end

    return petData.Stats
end

function PetService.UpdatePetEnergy(dt)
    -- Decay pet energy over time
    local Players = game:GetService("Players")
    for _, player in ipairs(Players:GetPlayers()) do
        local data = PlayerDataService.GetData(player)
        if data then
            for _, pet in ipairs(data.PetInventory or {}) do
                if pet.IsEquipped then
                    pet.Energy = math.max(0, pet.Energy - dt * 0.1)
                    pet.Hunger = math.max(0, pet.Hunger - dt * 0.05)
                end
            end
        end
    end
end

return PetService
