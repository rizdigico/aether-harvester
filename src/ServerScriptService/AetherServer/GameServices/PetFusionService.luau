--!strict
-- Server-authoritative, deterministic pet fusion.

local PetFusionService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local PetsData = require(ReplicatedStorage.AetherShared.Data.Pets)
local PetFusionRules = require(ReplicatedStorage.AetherShared.Modules.PetFusionRules)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)

local function getRemotes(): Folder?
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    local remotes = shared and shared:FindFirstChild("Remotes")
    return if remotes and remotes:IsA("Folder") then remotes else nil
end

local function fireError(player: Player, message: string)
    local remotes = getRemotes()
    local errorRemote = remotes and remotes:FindFirstChild("Error")
    if errorRemote and errorRemote:IsA("RemoteEvent") then
        errorRemote:FireClient(player, message)
    end
end

local function isValidInstanceId(value: any): boolean
    return type(value) == "number" and value == value and value > 0 and value < math.huge and value == math.floor(value)
end

local function findPet(data: any, instanceId: number): (number?, any)
    if type(data.PetInventory) ~= "table" then
        return nil, nil
    end
    for index, pet in ipairs(data.PetInventory) do
        if type(pet) == "table" and pet.InstanceId == instanceId then
            return index, pet
        end
    end
    return nil, nil
end

function PetFusionService.FusePets(player: Player, firstId: number, secondId: number): (boolean, string, any?)
    if not isValidInstanceId(firstId) or not isValidInstanceId(secondId) or firstId == secondId then
        return false, "Select two different owned pets"
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local firstIndex, firstPet = findPet(data, firstId)
    local secondIndex, secondPet = findPet(data, secondId)
    if not firstIndex or not secondIndex or not firstPet or not secondPet then
        return false, "Both pets must be owned by you"
    end
    if firstPet.IsEquipped == true or secondPet.IsEquipped == true then
        return false, "Unequip both pets before fusion"
    end

    local resultId = PetFusionRules.Resolve(firstPet.PetId, secondPet.PetId)
    if not resultId or not PetsData.GetPet(resultId) then
        return false, "No stable fusion recipe exists for those pets"
    end

    -- Remove the higher index first so the second record's index remains valid.
    local highIndex = math.max(firstIndex, secondIndex)
    local lowIndex = math.min(firstIndex, secondIndex)
    local highPet = table.remove(data.PetInventory, highIndex)
    local lowPet = table.remove(data.PetInventory, lowIndex)
    if not highPet or not lowPet then
        return false, "Fusion could not reserve both pets"
    end

    if not PlayerDataService.AddPet(player, resultId) then
        table.insert(data.PetInventory, lowIndex, lowPet)
        table.insert(data.PetInventory, highIndex, highPet)
        return false, "Fusion failed; both pets were restored"
    end

    local resultPet = data.PetInventory[#data.PetInventory]
    return true, "Fusion complete", resultPet
end

function PetFusionService.Initialize()
    print("[PetFusionService] Initializing...")
    local remotes = getRemotes()
    if not remotes then
        return
    end

    local fusePets = remotes:FindFirstChild("FusePets")
    if fusePets and fusePets:IsA("RemoteEvent") then
        fusePets.OnServerEvent:Connect(function(player: Player, firstId: any, secondId: any)
            if not RateLimiter.Check(player, "FusePets", 3) then
                return
            end
            if not isValidInstanceId(firstId) or not isValidInstanceId(secondId) then
                fireError(player, "Select two valid pet instances")
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message, resultPet = PetFusionService.FusePets(player, firstId, secondId)
            if not success then
                fireError(player, message)
                return
            end
            local completed = remotes:FindFirstChild("PetFusionCompleted")
            if completed and completed:IsA("RemoteEvent") then
                completed:FireClient(player, resultPet)
            end
            local petUpdated = remotes:FindFirstChild("PetUpdated")
            if petUpdated and petUpdated:IsA("RemoteEvent") then
                petUpdated:FireClient(player)
            end
        end)
    end

    print("[PetFusionService] Initialized")
end

function PetFusionService.OnPlayerRemoving(_player: Player)
    -- Fusion is an atomic in-memory action, so there is no session state to retain.
end

return PetFusionService
