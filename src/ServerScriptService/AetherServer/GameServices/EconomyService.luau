-- EconomyService
local EconomyService = {}

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

-- Currency definitions
EconomyService.Currencies = {
    AetherShards = { Name = "Aether Shards", Icon = "rbxassetid://0" },
    AetherGems = { Name = "Aether Gems", Icon = "rbxassetid://0" },
    EventTokens = { Name = "Event Tokens", Icon = "rbxassetid://0" },
    FamePoints = { Name = "Fame Points", Icon = "rbxassetid://0" },
}

-- Exchange rates (gems -> shards)
EconomyService.ExchangeRates = {
    AetherGems = { To = "AetherShards", Rate = 10 }, -- 1 gem = 10 shards
}

local transactionLog = {}

function EconomyService.GetBalance(player, currencyType)
    local data = PlayerDataService.GetData(player)
    if not data or not data.Currency then
        return 0
    end
    return data.Currency[currencyType] or 0
end

function EconomyService.AddCurrency(player, currencyType, amount)
    if amount <= 0 then
        return false, "Amount must be positive"
    end
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "No player data"
    end
    data.Currency = data.Currency or {}
    data.Currency[currencyType] = (data.Currency[currencyType] or 0) + amount
    EconomyService.LogTransaction(player, "ADD", currencyType, amount)
    return true
end

function EconomyService.SpendCurrency(player, currencyType, amount)
    if amount <= 0 then
        return false, "Amount must be positive"
    end
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "No player data"
    end
    data.Currency = data.Currency or {}
    local balance = data.Currency[currencyType] or 0
    if balance < amount then
        return false, "Insufficient " .. currencyType
    end
    data.Currency[currencyType] = balance - amount
    EconomyService.LogTransaction(player, "SPEND", currencyType, amount)
    return true
end

function EconomyService.ConvertCurrency(player, fromCurrency, amount)
    local rate = EconomyService.ExchangeRates[fromCurrency]
    if not rate then
        return false, "No exchange rate for " .. fromCurrency
    end

    local success, err = EconomyService.SpendCurrency(player, fromCurrency, amount)
    if not success then
        return false, err
    end

    local converted = amount * rate.Rate
    EconomyService.AddCurrency(player, rate.To, converted)

    return true, converted
end

function EconomyService.CanAfford(player, currencyType, amount)
    return EconomyService.GetBalance(player, currencyType) >= amount
end

function EconomyService.LogTransaction(player, action, currencyType, amount)
    local entry = {
        Player = player.Name,
        Action = action,
        Currency = currencyType,
        Amount = amount,
        Time = os.time(),
    }
    table.insert(transactionLog, entry)
    -- Keep log bounded
    if #transactionLog > 200 then
        table.remove(transactionLog, 1)
    end
end

function EconomyService.GetTransactionLog(player)
    local results = {}
    for _, entry in ipairs(transactionLog) do
        if entry.Player == player.Name then
            table.insert(results, entry)
        end
    end
    return results
end

function EconomyService.Initialize()
    print("[EconomyService] Initializing...")
    local firstCurrency = next(EconomyService.Currencies)
    print("[EconomyService] Currencies: " .. tostring(firstCurrency))
end

return EconomyService
