local TradingService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

TradingService.ActiveTrades = {}

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
            if type(offerItems) ~= "table" or type(requestItems) ~= "table" then
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
    local tradeId = "TRADE_" .. player.UserId .. "_" .. os.time()
    local trade = {
        Id = tradeId,
        PlayerId = player.UserId,
        OfferItems = offerItems,
        RequestItems = requestItems,
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

    trade.Status = "Accepted"
    trade.AcceptedBy = player.UserId

    -- Process trade
    -- Remove offer items from trader
    -- Add request items to trader
    -- Add offer items to accepter
    -- Remove request items from accepter

    print("[TradingService] Trade accepted: " .. tradeId)

    -- Notify both players
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local TradeCompleted = Remotes:FindFirstChild("TradeCompleted")
        if TradeCompleted then
            TradeCompleted:FireAllClients(trade)
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
