local PlayerDataService = {}
local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1")

local playerData = {}
local SAVE_INTERVAL = 300 -- 5 minutes

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
            for _, data in pairs(playerData) do
                pcall(function()
                    PlayerDataStore:SetAsync(tostring(data.PlayerId), data)
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

    if success and data then
        playerData[player.UserId] = data
        print("[PlayerDataService] Loaded data for " .. player.Name)
    else
        -- Create new player data
        playerData[player.UserId] = {
            PlayerId = tostring(player.UserId),
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
        }
        print("[PlayerDataService] Created new data for " .. player.Name)
    end

    -- Send data to client
    local PlayerDataLoaded = game.ReplicatedStorage.AetherShared.Remotes:FindFirstChild("PlayerDataLoaded")
    if PlayerDataLoaded then
        PlayerDataLoaded:FireClient(player, playerData[player.UserId])
    end
end

function PlayerDataService.OnPlayerRemoving(player)
    print("[PlayerDataService] Player leaving: " .. player.Name)

    -- Save data
    local success, err = pcall(function()
        PlayerDataStore:SetAsync(tostring(player.UserId), playerData[player.UserId])
    end)

    if success then
        print("[PlayerDataService] Data saved for " .. player.Name)
    else
        warn("[PlayerDataService] Failed to save data for " .. player.Name .. ": " .. tostring(err))
    end

    playerData[player.UserId] = nil
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
    if playerData[player.UserId] and playerData[player.UserId].Currency[currencyType] then
        playerData[player.UserId].Currency[currencyType] += amount
        return true
    end
    return false
end

function PlayerDataService.RemoveCurrency(player, currencyType, amount)
    if playerData[player.UserId] and playerData[player.UserId].Currency[currencyType] then
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
    if not data then
        return false
    end
    data.Inventory = data.Inventory or {}
    data.Inventory[itemId] = (data.Inventory[itemId] or 0) + amount
    return true
end

function PlayerDataService.RemoveItem(player, itemId, amount)
    local data = playerData[player.UserId]
    amount = amount or 1
    if not data then
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
    if not data then
        return
    end
    data.XP = (data.XP or 0) + amount
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
