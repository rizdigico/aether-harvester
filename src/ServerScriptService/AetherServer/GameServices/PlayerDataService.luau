local PlayerDataService = {}
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
-- Studio must never point at the production profile namespace. Keep the
-- production key stable for published servers until an explicit migration is
-- performed.
local DATASTORE_NAME = RunService:IsStudio() and "PlayerData_Studio_v1" or "PlayerData_v1"
local PlayerDataStore = DataStoreService:GetDataStore(DATASTORE_NAME)

local playerData = {}
local playerSaveEnabled = {}
local SAVE_INTERVAL = 300 -- 5 minutes
local SCHEMA_VERSION = 1
local MAX_TRANSACTION_AMOUNT = 1000000000

local function isPositiveInteger(value)
    return type(value) == "number" and value >= 1 and value <= MAX_TRANSACTION_AMOUNT and value == math.floor(value)
end

-- Default profile (v1). New players and migrated old profiles get this shape.
local function CreateDefaultProfile(userId)
    return {
        SchemaVersion = SCHEMA_VERSION,
        PlayerId = tostring(userId),
        Level = 1,
        XP = 0,
        Currency = {
            AetherShards = 0,
            AetherGems = 100,
            EventTokens = 0,
            FamePoints = 0,
        },
        Inventory = {},
        PetInventory = {},
        EquippedPets = {},
        Skills = {},
        Quests = {},
        Achievements = {},
        Stats = {
            HarvestCount = 0,
            CombatKills = 0,
            TradesCompleted = 0,
            PlaytimeMinutes = 0,
            ZonesDiscovered = 0,
        },
        Settings = {
            MusicVolume = 0.5,
            SFXVolume = 0.7,
            GraphicsQuality = 2,
        },
        PrestigeLevel = 0,
        GuildId = nil,
        DailyStreak = 0,
        LastDailyReward = nil,
        LastDailyRewardAt = 0,
        LastDailyRewardDay = nil,
    }
end

-- Migrate/repair any loaded profile to the current schema.
-- v0 (no SchemaVersion) profiles from the pre-versioning era are filled in.
local function SanitizeProfile(userId, raw)
    if type(raw) ~= "table" then
        return CreateDefaultProfile(userId)
    end
    local base = CreateDefaultProfile(userId)
    -- Merge: raw values win, missing fields fall back to defaults
    local merged = {}
    for k, v in pairs(base) do
        merged[k] = v
    end
    for k, v in pairs(raw) do
        if type(v) == "table" and type(base[k]) == "table" then
            merged[k] = {}
            for kk, vv in pairs(base[k]) do
                merged[k][kk] = vv
            end
            for kk, vv in pairs(v) do
                merged[k][kk] = vv
            end
        else
            merged[k] = v
        end
    end
    merged.SchemaVersion = SCHEMA_VERSION
    merged.PlayerId = tostring(userId)
    -- Guard: currencies/inventory must exist
    merged.Currency = merged.Currency or base.Currency
    merged.Inventory = merged.Inventory or {}
    merged.PetInventory = merged.PetInventory or {}
    return merged
end

-- Save with retry + backoff (P0: never silently drop a save)
local function SaveProfile(userId, data, attempt)
    if playerSaveEnabled[userId] == false then
        return false
    end
    attempt = attempt or 1
    local ok, err = pcall(function()
        PlayerDataStore:SetAsync(tostring(userId), data)
    end)
    if ok then
        return true
    end
    if attempt < 3 then
        task.wait(1.5 * attempt) -- 1.5s, 3s backoff
        return SaveProfile(userId, data, attempt + 1)
    end
    warn("[PlayerDataService] Save failed after 3 attempts for " .. tostring(userId) .. ": " .. tostring(err))
    return false
end

function PlayerDataService.Initialize()
    print("[PlayerDataService] Initializing...")

    -- Remote wiring
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local GetPlayerData = Remotes:FindFirstChild("GetPlayerData")
        if GetPlayerData then
            GetPlayerData.OnServerInvoke = function(player)
                return playerData[player.UserId]
            end
        end

        local GetInventory = Remotes:FindFirstChild("GetInventory")
        if GetInventory then
            GetInventory.OnServerInvoke = function(player)
                local data = playerData[player.UserId]
                if not data then
                    return {}
                end
                return data.Inventory or {}
            end
        end

        local RequestPlayerData = Remotes:FindFirstChild("RequestPlayerData")
        if RequestPlayerData then
            RequestPlayerData.OnServerEvent:Connect(function(player)
                local PlayerDataLoaded = Remotes:FindFirstChild("PlayerDataLoaded")
                if PlayerDataLoaded and playerData[player.UserId] then
                    PlayerDataLoaded:FireClient(player, playerData[player.UserId])
                end
            end)
        end
    end

    -- Auto-save loop (background task so Initialize returns immediately)
    task.spawn(function()
        while true do
            task.wait(SAVE_INTERVAL)
            local snapshot = {}
            for uid, data in pairs(playerData) do
                snapshot[uid] = data
            end
            for uid, data in pairs(snapshot) do
                task.spawn(function()
                    SaveProfile(uid, data, 1)
                end)
            end
        end
    end)
end

function PlayerDataService.OnPlayerAdded(player)
    print("[PlayerDataService] Player added: " .. player.Name)

    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(tostring(player.UserId))
    end)

    playerSaveEnabled[player.UserId] = success
    if success and data then
        playerData[player.UserId] = SanitizeProfile(player.UserId, data)
        print("[PlayerDataService] Loaded data for " .. player.Name)
    else
        -- Create new player data
        playerData[player.UserId] = CreateDefaultProfile(player.UserId)
        if success then
            print("[PlayerDataService] Created new data for " .. player.Name)
        else
            warn("[PlayerDataService] Load failed; saves disabled for " .. player.Name)
        end
    end

    -- Send data to client
    local PlayerDataLoaded = game.ReplicatedStorage.AetherShared.Remotes:FindFirstChild("PlayerDataLoaded")
    if PlayerDataLoaded then
        PlayerDataLoaded:FireClient(player, playerData[player.UserId])
    end
end

function PlayerDataService.OnPlayerRemoving(player)
    print("[PlayerDataService] Player leaving: " .. player.Name)

    -- Save data (with retry)
    local data = playerData[player.UserId]
    if data and playerSaveEnabled[player.UserId] ~= false then
        SaveProfile(player.UserId, data, 1)
    end

    playerData[player.UserId] = nil
    playerSaveEnabled[player.UserId] = nil
end

function PlayerDataService.GetData(player)
    return playerData[player.UserId]
end

function PlayerDataService.UpdateData(player, key, value)
    if playerData[player.UserId] then
        playerData[player.UserId][key] = value
    end
end

function PlayerDataService.AddCurrency(player, currencyType, amount)
    if type(currencyType) ~= "string" or not isPositiveInteger(amount) then
        return false
    end
    if playerData[player.UserId] and playerData[player.UserId].Currency[currencyType] ~= nil then
        playerData[player.UserId].Currency[currencyType] += amount
        return true
    end
    return false
end

function PlayerDataService.RemoveCurrency(player, currencyType, amount)
    if type(currencyType) ~= "string" or not isPositiveInteger(amount) then
        return false
    end
    if playerData[player.UserId] and playerData[player.UserId].Currency[currencyType] ~= nil then
        if playerData[player.UserId].Currency[currencyType] >= amount then
            playerData[player.UserId].Currency[currencyType] -= amount
            return true
        end
    end
    return false
end

function PlayerDataService.AddItem(player, itemId, amount)
    local data = playerData[player.UserId]
    amount = amount or 1
    if not data or type(itemId) ~= "string" or itemId == "" or not isPositiveInteger(amount) then
        return false
    end
    data.Inventory = data.Inventory or {}
    data.Inventory[itemId] = (data.Inventory[itemId] or 0) + amount
    return true
end

function PlayerDataService.RemoveItem(player, itemId, amount)
    local data = playerData[player.UserId]
    amount = amount or 1
    if not data or type(itemId) ~= "string" or itemId == "" or not isPositiveInteger(amount) then
        return false
    end
    data.Inventory = data.Inventory or {}
    local current = data.Inventory[itemId] or 0
    if current < amount then
        return false
    end
    data.Inventory[itemId] = current - amount
    if data.Inventory[itemId] <= 0 then
        data.Inventory[itemId] = nil
    end
    return true
end

function PlayerDataService.GetItemCount(player, itemId)
    local data = playerData[player.UserId]
    if not data then
        return 0
    end
    return (data.Inventory and data.Inventory[itemId]) or 0
end

-- Synchronous save hook for durable receipt grants and other critical writes.
-- Callers must only acknowledge an external transaction after this returns true.
function PlayerDataService.SaveNow(player)
    local data = playerData[player.UserId]
    if not data then
        return false
    end
    return SaveProfile(player.UserId, data, 1)
end

local petIdCounter = 0

function PlayerDataService.AddPet(player, petId)
    local data = playerData[player.UserId]
    if not data then
        return false
    end
    data.PetInventory = data.PetInventory or {}
    -- Normalize: accept a string PetId or an existing pet record
    if type(petId) == "string" then
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
    else
        table.insert(data.PetInventory, petId)
    end
    return true
end

function PlayerDataService.AddXP(player, amount)
    local data = playerData[player.UserId]
    if not data or not isPositiveInteger(amount) or amount > 10000 then
        return
    end
    data.XP = (data.XP or 0) + math.floor(amount)

    -- Update battle pass XP
    local BattlePassService = require(game.ServerScriptService.AetherServer.GameServices.BattlePassService)
    BattlePassService.AddXP(player, amount)
end

function PlayerDataService.IncrementStat(player, statName, amount)
    local data = playerData[player.UserId]
    if not data then
        return
    end
    data.Stats = data.Stats or {}
    data.Stats[statName] = (data.Stats[statName] or 0) + (amount or 1)
end

return PlayerDataService
