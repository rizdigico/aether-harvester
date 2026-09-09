local TradingService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)

TradingService.ActiveTrades = {}
TradingService.TradeIdCounter = 0

local MAX_TRADE_ENTRIES = 20
local MAX_ITEM_AMOUNT = 9999

function TradingService.ValidateItemMap(items)
    if type(items) ~= "table" then
        return false
    end

    local entries = 0
    for itemId, amount in pairs(items) do
        if type(itemId) ~= "string" or itemId == "" or type(amount) ~= "number" then
            return false
        end
        if amount < 1 or amount > MAX_ITEM_AMOUNT or amount ~= math.floor(amount) then
            return false
        end
        entries += 1
        if entries > MAX_TRADE_ENTRIES then
            return false
        end
    end

    return true
end

local function cloneItemMap(items)
    return table.clone(items)
end

function TradingService.Initialize()
    print("[TradingService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- CreateTrade: open a new trade offer
    local CreateTrade = Remotes:FindFirstChild("CreateTrade")
    if CreateTrade then
        CreateTrade.OnServerEvent:Connect(function(player, offerItems, requestItems)
            if not TradingService.ValidateItemMap(offerItems) or not TradingService.ValidateItemMap(requestItems) then
                return
            end
            if next(offerItems) == nil and next(requestItems) == nil then
                return
            end
            -- Rate limit: max one trade creation per 2 seconds per player
            if not RateLimiter.Check(player, "CreateTrade", 2) then
                return
            end
            TradingService.CreateTrade(player, offerItems, requestItems)
        end)
    end

    -- AcceptTrade: accept a pending trade
    local AcceptTrade = Remotes:FindFirstChild("AcceptTrade")
    if AcceptTrade then
        AcceptTrade.OnServerEvent:Connect(function(player, tradeId)
            if type(tradeId) ~= "string" then
                return
            end
            local success, message = TradingService.AcceptTrade(player, tradeId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Trade failed")
                end
            end
        end)
    end

    -- CancelTrade: cancel an own trade
    local CancelTrade = Remotes:FindFirstChild("CancelTrade")
    if CancelTrade then
        CancelTrade.OnServerEvent:Connect(function(player, tradeId)
            if type(tradeId) ~= "string" then
                return
            end
            TradingService.CancelTrade(player, tradeId)
        end)
    end

    print("[TradingService] Initialized")
end

function TradingService.CreateTrade(player, offerItems, requestItems)
    if not TradingService.ValidateItemMap(offerItems) or not TradingService.ValidateItemMap(requestItems) then
        return nil, "Invalid trade payload"
    end
    if next(offerItems) == nil and next(requestItems) == nil then
        return nil, "Trade must contain an item"
    end

    TradingService.TradeIdCounter += 1
    local tradeId = "TRADE_" .. player.UserId .. "_" .. TradingService.TradeIdCounter
    local trade = {
        Id = tradeId,
        PlayerId = player.UserId,
        OfferItems = cloneItemMap(offerItems),
        RequestItems = cloneItemMap(requestItems),
        Status = "Pending",
        CreatedAt = os.time(),
    }

    TradingService.ActiveTrades[tradeId] = trade

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local TradeCreated = Remotes:FindFirstChild("TradeCreated")
        if TradeCreated then
            TradeCreated:FireClient(player, trade)
        end
    end

    return tradeId, trade
end

function TradingService.AcceptTrade(player, tradeId)
    local trade = TradingService.ActiveTrades[tradeId]
    if not trade then
        return false, "Trade not found"
    end

    if trade.Status ~= "Pending" then
        return false, "Trade already processed"
    end

    if trade.PlayerId == player.UserId then
        return false, "Cannot accept your own trade"
    end

    if
        not TradingService.ValidateItemMap(trade.OfferItems) or not TradingService.ValidateItemMap(trade.RequestItems)
    then
        return false, "Invalid trade payload"
    end

    local offerer = game.Players:GetPlayerByUserId(trade.PlayerId)
    if not offerer then
        return false, "Trade partner left the game"
    end

    -- Phase 1: validate ownership for BOTH sides before any mutation (atomic)
    for itemId, amount in pairs(trade.OfferItems) do
        if PlayerDataService.GetItemCount(offerer, itemId) < amount then
            return false, "Offerer no longer owns the offered items"
        end
    end
    for itemId, amount in pairs(trade.RequestItems) do
        if PlayerDataService.GetItemCount(player, itemId) < amount then
            return false, "You don't own the requested items"
        end
    end

    -- Phase 2: execute transfers (validated above -> cannot fail)
    for itemId, amount in pairs(trade.OfferItems) do
        PlayerDataService.RemoveItem(offerer, itemId, amount)
        PlayerDataService.AddItem(player, itemId, amount)
    end
    for itemId, amount in pairs(trade.RequestItems) do
        PlayerDataService.RemoveItem(player, itemId, amount)
        PlayerDataService.AddItem(offerer, itemId, amount)
    end

    trade.Status = "Accepted"
    trade.AcceptedBy = player.UserId

    print("[TradingService] Trade accepted: " .. tradeId)

    -- Notify both players
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local TradeCompleted = Remotes:FindFirstChild("TradeCompleted")
        if TradeCompleted then
            TradeCompleted:FireClient(offerer, trade)
            TradeCompleted:FireClient(player, trade)
        end
    end

    -- Clean up trade after delay
    task.delay(60, function()
        TradingService.ActiveTrades[tradeId] = nil
    end)

    return true, "Trade completed"
end

function TradingService.CancelTrade(player, tradeId)
    local trade = TradingService.ActiveTrades[tradeId]
    if not trade then
        return false, "Trade not found"
    end

    if trade.PlayerId ~= player.UserId then
        return false, "Not your trade"
    end

    trade.Status = "Cancelled"
    TradingService.ActiveTrades[tradeId] = nil

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local TradeCancelled = Remotes:FindFirstChild("TradeCancelled")
        if TradeCancelled then
            TradeCancelled:FireClient(player, tradeId)
        end
    end

    return true, "Trade cancelled"
end

function TradingService.GetActiveTrades()
    local trades = {}
    for _, trade in pairs(TradingService.ActiveTrades) do
        if trade.Status == "Pending" then
            table.insert(trades, trade)
        end
    end
    return trades
end

return TradingService
