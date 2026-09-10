-- EconomyService
local EconomyService = {}

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local CurrencyRules = require(game.ReplicatedStorage.AetherShared.Modules.CurrencyRules)

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
    local balance = data.Currency[currencyType]
    if type(balance) ~= "number" or balance ~= balance or balance < 0 or balance > 1000000000 then
        return 0
    end
    return balance
end

function EconomyService.AddCurrency(player, currencyType, amount)
    if type(amount) ~= "number" or amount <= 0 then
        return false, "Amount must be positive"
    end
    if not PlayerDataService.GetData(player) then
        return false, "No player data"
    end
    if not PlayerDataService.AddCurrency(player, currencyType, amount) then
        return false, "Currency mutation rejected"
    end
    EconomyService.LogTransaction(player, "ADD", currencyType, amount)
    return true
end

function EconomyService.SpendCurrency(player, currencyType, amount)
    if type(amount) ~= "number" or amount <= 0 then
        return false, "Amount must be positive"
    end
    if not PlayerDataService.GetData(player) then
        return false, "No player data"
    end
    if EconomyService.GetBalance(player, currencyType) < amount then
        return false, "Insufficient " .. currencyType
    end
    if not PlayerDataService.RemoveCurrency(player, currencyType, amount) then
        return false, "Currency mutation rejected"
    end
    EconomyService.LogTransaction(player, "SPEND", currencyType, amount)
    return true
end

function EconomyService.ConvertCurrency(player, fromCurrency, amount)
    local rate = EconomyService.ExchangeRates[fromCurrency]
    if not rate then
        return false, "No exchange rate for " .. fromCurrency
    end

    if type(amount) ~= "number" or amount <= 0 then
        return false, "Amount must be positive"
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "No player data"
    end

    local converted = amount * rate.Rate
    local definition = CurrencyRules.Definitions[rate.To]
    local current = data.Currency and data.Currency[rate.To]
    local canAdd = CurrencyRules.CanAdd(rate.To, converted, current, definition)
    if not canAdd then
        return false, "Conversion target rejected"
    end

    local success, err = EconomyService.SpendCurrency(player, fromCurrency, amount)
    if not success then
        return false, err
    end

    if not EconomyService.AddCurrency(player, rate.To, converted) then
        -- The target was preflighted above; restore the source if a concurrent
        -- mutation or a malformed profile still makes the final grant fail.
        PlayerDataService.AddCurrency(player, fromCurrency, amount)
        return false, "Conversion target rejected"
    end

    return true, converted
end

function EconomyService.CanAfford(player, currencyType, amount)
    return type(amount) == "number" and amount >= 0 and EconomyService.GetBalance(player, currencyType) >= amount
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
