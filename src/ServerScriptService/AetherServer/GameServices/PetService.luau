local PetService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local PetsData = require(game.ReplicatedStorage.AetherShared.Data.Pets)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)

local activePets = {}
local petFollowers = {}

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

local function findOwnedPet(player, petKey)
    local data = PlayerDataService.GetData(player)
    if not data or type(data.PetInventory) ~= "table" then
        return nil
    end

    for _, pet in ipairs(data.PetInventory) do
        if type(pet) == "table" then
            if type(petKey) == "number" and pet.InstanceId == petKey then
                return pet
            elseif type(petKey) == "string" and pet.PetId == petKey then
                return pet
            end
        end
    end

    return nil
end

function PetService.SpawnFollower(player, petId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end
    local petDef = PetsData.GetPet(petId)
    if not petDef then
        return false, "Unknown pet"
    end
    if not findOwnedPet(player, petId) then
        return false, "Pet not owned"
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

    return true
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
            if not RateLimiter.Check(player, "EquipPet", 0.25) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            if type(petKey) ~= "number" and type(petKey) ~= "string" then
                return
            end
            local data = PlayerDataService.GetData(player)
            if not data then
                return
            end
            local success, message = PetService.EquipPet(player, petKey)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Failed to equip pet")
                end
            end
        end)
    end

    -- FeedPet: consume one owned pet-food item and update only the selected
    -- player's pet record. Never mutate the shared pet definition table.
    local FeedPet = Remotes:FindFirstChild("FeedPet")
    if FeedPet then
        FeedPet.OnServerEvent:Connect(function(player, petKey)
            if not RateLimiter.Check(player, "FeedPet", 0.5) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            if type(petKey) ~= "number" and type(petKey) ~= "string" then
                return
            end
            local success, message = PetService.FeedPet(player, petKey)
            local Error = Remotes:FindFirstChild("Error")
            if not success then
                if Error then
                    Error:FireClient(player, message or "Failed to feed pet")
                end
                return
            end
            local PetUpdated = Remotes:FindFirstChild("PetUpdated")
            if PetUpdated then
                PetUpdated:FireClient(player)
            end
        end)
    end

    -- UnequipPet: unequip a specific owned pet by instance ID or legacy key
    local UnequipPet = Remotes:FindFirstChild("UnequipPet")
    if UnequipPet then
        UnequipPet.OnServerEvent:Connect(function(player, petInstanceId)
            if not RateLimiter.Check(player, "UnequipPet", 0.25) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            if type(petInstanceId) ~= "number" and type(petInstanceId) ~= "string" then
                return
            end
            local pet = findOwnedPet(player, petInstanceId)
            if pet then
                pet.IsEquipped = false
                local PetUpdated = Remotes:FindFirstChild("PetUpdated")
                if PetUpdated then
                    PetUpdated:FireClient(player)
                end
            end
        end)
    end

    -- SummonPet: track the active summoned pet for a player
    local SummonPet = Remotes:FindFirstChild("SummonPet")
    if SummonPet then
        SummonPet.OnServerEvent:Connect(function(player, petId)
            if not RateLimiter.Check(player, "SummonPet", 0.5) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            if type(petId) ~= "string" then
                return
            end
            local success, message = PetService.SpawnFollower(player, petId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Failed to summon pet")
                end
                return
            end
            activePets[player.UserId] = petId
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
            if not RateLimiter.Check(player, "ReleasePet", 0.25) then
                return
            end
            AntiCheatService:CheckPlayer(player)
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

function PetService.OnPlayerRemoving(player)
    activePets[player.UserId] = nil
    PetService.DespawnFollower(player)
end

function PetService.GivePet(player, petId)
    local petData = PetsData.GetPet(petId)
    if not petData then
        return false, "Invalid pet ID"
    end

    if not PlayerDataService.GetData(player) then
        return false, "Player data not found"
    end
    if PlayerDataService.AddPet(player, petId) then
        return true, "Pet added to inventory"
    end
    return false, "Could not add pet to inventory"
end

function PetService.EquipPet(player, petInstanceId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local selectedPet = findOwnedPet(player, petInstanceId)
    if not selectedPet then
        return false, "Pet not found in inventory"
    end

    -- Unequip all other pets only after validating the requested pet.
    for _, pet in ipairs(data.PetInventory) do
        pet.IsEquipped = false
    end

    selectedPet.IsEquipped = true
    return true, "Pet equipped"
end

function PetService.FeedPet(player, petInstanceId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local pet = findOwnedPet(player, petInstanceId)
    if not pet then
        return false, "Pet not found"
    end

    if pet.Hunger >= 100 then
        return false, "Pet is not hungry"
    end
    if PlayerDataService.GetItemCount(player, "pet_food") < 1 then
        return false, "You need pet food"
    end
    if not PlayerDataService.RemoveItem(player, "pet_food", 1) then
        return false, "Could not consume pet food"
    end

    pet.Hunger = math.min(100, (pet.Hunger or 0) + 30)
    pet.Happiness = math.min(100, (pet.Happiness or 0) + 10)
    return true, "Pet fed"
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
