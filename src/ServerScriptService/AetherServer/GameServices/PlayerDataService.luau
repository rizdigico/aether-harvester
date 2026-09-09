local PlayerDataService = {}
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)
local PetsData = require(game.ReplicatedStorage.AetherShared.Data.Pets)
-- Studio must never point at the production profile namespace. Keep the
-- production key stable for published servers until an explicit migration is
-- performed.
local DATASTORE_NAME = RunService:IsStudio() and "PlayerData_Studio_v1" or "PlayerData_v1"
local PlayerDataStore = DataStoreService:GetDataStore(DATASTORE_NAME)

local playerData = {}
local playerSaveEnabled = {}
local saveLocks = {}
local SAVE_INTERVAL = 300 -- 5 minutes
local SCHEMA_VERSION = 2
local MAX_TRANSACTION_AMOUNT = 1000000000

local function isPositiveInteger(value)
    return type(value) == "number"
        and value == value
        and value < math.huge
        and value > -math.huge
        and value >= 1
        and value <= MAX_TRANSACTION_AMOUNT
        and value == math.floor(value)
end

local function isFiniteNumber(value)
    return type(value) == "number" and value == value and value < math.huge and value > -math.huge
end

local function cloneProfile(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for key, nestedValue in pairs(value) do
        copy[key] = cloneProfile(nestedValue)
    end
    return copy
end

local function sanitizeInventory(value)
    local inventory = {}
    if type(value) ~= "table" then
        return inventory
    end
    for itemId, amount in pairs(value) do
        if type(itemId) == "string" and ItemsData.GetItem(itemId) and isPositiveInteger(amount) then
            inventory[itemId] = amount
        end
    end
    return inventory
end

local function sanitizeMailbox(value)
    local mailbox = {}
    if type(value) ~= "table" then
        return mailbox
    end
    for _, rawMail in ipairs(value) do
        if
            type(rawMail) == "table"
            and type(rawMail.Id) == "string"
            and rawMail.Id ~= ""
            and type(rawMail.Subject) == "string"
            and type(rawMail.Message) == "string"
        then
            local mail = {
                Id = rawMail.Id:sub(1, 100),
                From = type(rawMail.From) == "string" and rawMail.From:sub(1, 64) or "Unknown",
                FromId = isFiniteNumber(rawMail.FromId) and math.floor(rawMail.FromId) or 0,
                Subject = rawMail.Subject:sub(1, 80),
                Message = rawMail.Message:sub(1, 1000),
                SentAt = isFiniteNumber(rawMail.SentAt) and math.floor(rawMail.SentAt) or 0,
                Read = rawMail.Read == true,
                Attachments = {},
            }
            if type(rawMail.Attachments) == "table" then
                for _, attachment in ipairs(rawMail.Attachments) do
                    if type(attachment) == "table" and type(attachment.ItemId) == "string" then
                        if ItemsData.GetItem(attachment.ItemId) and isPositiveInteger(attachment.Amount) then
                            table.insert(mail.Attachments, {
                                ItemId = attachment.ItemId,
                                Amount = attachment.Amount,
                            })
                        end
                    elseif type(attachment) == "table" and type(attachment.Currency) == "table" then
                        local currencyCopy = {}
                        for currency, amount in pairs(attachment.Currency) do
                            if
                                (
                                    currency == "AetherShards"
                                    or currency == "AetherGems"
                                    or currency == "EventTokens"
                                    or currency == "FamePoints"
                                )
                                and isPositiveInteger(amount)
                            then
                                currencyCopy[currency] = amount
                            end
                        end
                        if next(currencyCopy) then
                            table.insert(mail.Attachments, { Currency = currencyCopy })
                        end
                    end
                    if #mail.Attachments >= 10 then
                        break
                    end
                end
            end
            table.insert(mailbox, mail)
            if #mailbox >= 100 then
                break
            end
        end
    end
    return mailbox
end

local function sanitizePetInventory(value)
    local inventory = {}
    local seenInstanceIds = {}
    if type(value) ~= "table" then
        return inventory
    end
    for index, rawPet in ipairs(value) do
        local petId = type(rawPet) == "string" and rawPet or type(rawPet) == "table" and rawPet.PetId or nil
        local petDefinition = type(petId) == "string" and PetsData.GetPet(petId) or nil
        if petDefinition then
            local rawInstanceId = type(rawPet) == "table" and rawPet.InstanceId or index
            local instanceId = isFiniteNumber(rawInstanceId) and math.floor(rawInstanceId) or index
            if instanceId < 1 or seenInstanceIds[instanceId] then
                instanceId = index
            end
            while seenInstanceIds[instanceId] do
                instanceId += 1
            end
            seenInstanceIds[instanceId] = true
            table.insert(inventory, {
                InstanceId = instanceId,
                PetId = petId,
                Level = type(rawPet) == "table"
                        and isFiniteNumber(rawPet.Level)
                        and math.clamp(math.floor(rawPet.Level), 1, 100)
                    or 1,
                XP = type(rawPet) == "table"
                        and isFiniteNumber(rawPet.XP)
                        and math.clamp(math.floor(rawPet.XP), 0, MAX_TRANSACTION_AMOUNT)
                    or 0,
                Hunger = type(rawPet) == "table"
                        and isFiniteNumber(rawPet.Hunger)
                        and math.clamp(rawPet.Hunger, 0, 100)
                    or 100,
                Happiness = type(rawPet) == "table"
                        and isFiniteNumber(rawPet.Happiness)
                        and math.clamp(rawPet.Happiness, 0, 100)
                    or 100,
                Energy = type(rawPet) == "table"
                        and isFiniteNumber(rawPet.Energy)
                        and math.clamp(rawPet.Energy, 0, 100)
                    or 100,
                IsEquipped = type(rawPet) == "table" and rawPet.IsEquipped == true,
            })
        end
    end
    return inventory
end

local function sanitizeStringBooleanMap(value)
    local result = {}
    if type(value) ~= "table" then
        return result
    end
    for key, enabled in pairs(value) do
        if type(key) == "string" and enabled == true then
            result[key] = true
        end
    end
    return result
end

local function sanitizeNumberMap(value, minimum, maximum)
    local result = {}
    if type(value) ~= "table" then
        return result
    end
    for key, number in pairs(value) do
        if type(key) == "string" and isFiniteNumber(number) then
            result[key] = math.clamp(math.floor(number), minimum, maximum)
        end
    end
    return result
end

local function sanitizeBoosts(value)
    local boosts = {}
    if type(value) ~= "table" then
        return boosts
    end
    for boostId, boost in pairs(value) do
        if type(boostId) == "string" and type(boost) == "table" then
            local expiresAt = boost.ExpiresAt
            local multiplier = boost.Multiplier
            if isFiniteNumber(expiresAt) and isFiniteNumber(multiplier) then
                boosts[boostId] = {
                    ExpiresAt = math.max(0, math.floor(expiresAt)),
                    Multiplier = math.clamp(multiplier, 1, 1.25),
                }
            end
        end
    end
    return boosts
end

local function sanitizeReceiptJournal(value)
    local journal = {}
    if type(value) ~= "table" then
        return journal
    end
    for purchaseId, timestamp in pairs(value) do
        if type(purchaseId) == "string" and purchaseId ~= "" and isFiniteNumber(timestamp) and timestamp >= 0 then
            journal[purchaseId] = math.floor(timestamp)
        end
    end
    return journal
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
        SkillPoints = 0,
        Quests = {},
        Achievements = {},
        Cosmetics = {},
        EquippedCosmetic = nil,
        Entitlements = {},
        ProcessedReceipts = {},
        Boosts = {},
        Mailbox = {},
        BattlePassLevel = 1,
        BattlePassXP = 0,
        BattlePassPremium = false,
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
        GuildRank = nil,
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
    local merged = table.clone(base)
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
    -- Normalize every persisted container before services read it. A truthy
    -- string or malformed number in a DataStore record must never reach a
    -- state-changing service as if it were valid profile data.
    merged.Currency = type(merged.Currency) == "table" and merged.Currency or {}
    for currency, default in pairs(base.Currency) do
        local value = merged.Currency[currency]
        merged.Currency[currency] = isFiniteNumber(value) and math.clamp(value, 0, MAX_TRANSACTION_AMOUNT) or default
    end
    merged.Inventory = sanitizeInventory(merged.Inventory)
    merged.Mailbox = sanitizeMailbox(merged.Mailbox)
    merged.PetInventory = sanitizePetInventory(merged.PetInventory)
    merged.EquippedPets = sanitizeStringBooleanMap(merged.EquippedPets)
    merged.SkillPoints = isFiniteNumber(merged.SkillPoints)
            and math.clamp(math.floor(merged.SkillPoints), 0, MAX_TRANSACTION_AMOUNT)
        or base.SkillPoints
    merged.Cosmetics = type(merged.Cosmetics) == "table" and merged.Cosmetics or {}
    merged.Entitlements = sanitizeStringBooleanMap(merged.Entitlements)
    merged.ProcessedReceipts = sanitizeReceiptJournal(merged.ProcessedReceipts)
    merged.Boosts = sanitizeBoosts(merged.Boosts)
    merged.Quests = type(merged.Quests) == "table" and merged.Quests or {}
    merged.Skills = sanitizeNumberMap(merged.Skills, 0, 100)
    merged.Achievements = sanitizeStringBooleanMap(merged.Achievements)
    merged.Settings = {
        MusicVolume = isFiniteNumber(merged.Settings and merged.Settings.MusicVolume)
                and math.clamp(merged.Settings.MusicVolume, 0, 1)
            or base.Settings.MusicVolume,
        SFXVolume = isFiniteNumber(merged.Settings and merged.Settings.SFXVolume)
                and math.clamp(merged.Settings.SFXVolume, 0, 1)
            or base.Settings.SFXVolume,
        GraphicsQuality = isFiniteNumber(merged.Settings and merged.Settings.GraphicsQuality)
                and math.clamp(math.floor(merged.Settings.GraphicsQuality), 1, 10)
            or base.Settings.GraphicsQuality,
    }
    merged.Stats = type(merged.Stats) == "table" and merged.Stats or table.clone(base.Stats)
    for statName, default in pairs(base.Stats) do
        local value = merged.Stats[statName]
        merged.Stats[statName] = isFiniteNumber(value) and math.clamp(math.floor(value), 0, MAX_TRANSACTION_AMOUNT)
            or default
    end
    merged.Level = isFiniteNumber(merged.Level) and math.clamp(math.floor(merged.Level), 1, 1000) or base.Level
    merged.XP = isFiniteNumber(merged.XP) and math.clamp(math.floor(merged.XP), 0, MAX_TRANSACTION_AMOUNT) or base.XP
    merged.PrestigeLevel = isFiniteNumber(merged.PrestigeLevel)
            and math.clamp(math.floor(merged.PrestigeLevel), 0, 1000)
        or base.PrestigeLevel
    merged.BattlePassLevel = isFiniteNumber(merged.BattlePassLevel)
            and math.clamp(math.floor(merged.BattlePassLevel), 1, 100)
        or base.BattlePassLevel
    merged.BattlePassXP = isFiniteNumber(merged.BattlePassXP)
            and math.clamp(merged.BattlePassXP, 0, MAX_TRANSACTION_AMOUNT)
        or base.BattlePassXP
    merged.BattlePassPremium = merged.BattlePassPremium == true
    if type(merged.GuildId) ~= "string" or not merged.GuildId:match("^GUILD_%d+$") then
        merged.GuildId = nil
    end
    if type(merged.GuildRank) ~= "string" then
        merged.GuildRank = nil
    end
    return merged
end

-- Save with retry + backoff (P0: never silently drop a save)
local function SaveProfile(userId, data, attempt)
    if playerSaveEnabled[userId] == false then
        return false
    end
    attempt = attempt or 1

    -- DataStore calls yield. Serialize per-user writes so an autosave, receipt
    -- grant, and PlayerRemoving save cannot race and overwrite each other.
    while saveLocks[userId] do
        task.wait()
    end
    saveLocks[userId] = true
    local snapshot = cloneProfile(data)
    local ok, err = pcall(function()
        PlayerDataStore:SetAsync(tostring(userId), snapshot)
    end)
    saveLocks[userId] = nil
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
                if not RateLimiter.Check(player, "RequestPlayerData", 0.5) then
                    return
                end
                local PlayerDataLoaded = Remotes:FindFirstChild("PlayerDataLoaded")
                if PlayerDataLoaded and playerData[player.UserId] then
                    PlayerDataLoaded:FireClient(player, playerData[player.UserId])
                end
            end)
        end
    end

    -- Auto-save loop (background task so Initialize returns immediately). Pass
    -- the live profile into SaveProfile; SaveProfile clones only after its
    -- per-user lock is acquired, avoiding stale pre-loop snapshots.
    task.spawn(function()
        while true do
            task.wait(SAVE_INTERVAL)
            for uid, data in pairs(playerData) do
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

function PlayerDataService.AddPet(player, petId)
    local data = playerData[player.UserId]
    if not data then
        return false
    end
    data.PetInventory = data.PetInventory or {}
    -- Normalize: accept a string PetId or an existing pet record
    if type(petId) == "string" then
        local highestInstanceId = 0
        for _, existingPet in ipairs(data.PetInventory) do
            if type(existingPet) == "table" and type(existingPet.InstanceId) == "number" then
                highestInstanceId = math.max(highestInstanceId, existingPet.InstanceId)
            end
        end
        local newPet = {
            -- Instance IDs only need to be unique inside this player's profile.
            -- Deriving from the persisted inventory avoids collisions after a
            -- server restart or when multiple grant paths add pets.
            InstanceId = highestInstanceId + 1,
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
        return false
    end
    data.XP = (data.XP or 0) + math.floor(amount)
    return true
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
