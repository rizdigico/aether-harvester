local TradingService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)

TradingService.ActiveTrades = {}
TradingService.TradeIdCounter = 0

local MAX_TRADE_ENTRIES = 20
local MAX_ITEM_AMOUNT = 9999
local MAX_TRADE_DISTANCE = 50

local function getRemotes()
    return game.ReplicatedStorage.AetherShared.Remotes
end

local function notify(player, message)
    local remotes = getRemotes()
    local errorRemote = remotes and remotes:FindFirstChild("Error")
    if errorRemote then
        errorRemote:FireClient(player, message)
    end
end

local function playersAreNearby(firstPlayer, secondPlayer)
    local firstCharacter = firstPlayer.Character
    local secondCharacter = secondPlayer.Character
    local firstRoot = firstCharacter and firstCharacter:FindFirstChild("HumanoidRootPart")
    local secondRoot = secondCharacter and secondCharacter:FindFirstChild("HumanoidRootPart")
    if not firstRoot or not secondRoot then
        return false
    end
    return (firstRoot.Position - secondRoot.Position).Magnitude <= MAX_TRADE_DISTANCE
end

local function notifyTradePlayers(trade, remoteName)
    local remotes = getRemotes()
    local remote = remotes and remotes:FindFirstChild(remoteName)
    if not remote then
        return
    end
    local offerer = game.Players:GetPlayerByUserId(trade.PlayerId)
    local target = game.Players:GetPlayerByUserId(trade.TargetPlayerId)
    if offerer then
        remote:FireClient(offerer, trade)
    end
    if target then
        remote:FireClient(target, trade)
    end
end

function TradingService.ValidateItemMap(items)
    if type(items) ~= "table" then
        return false
    end

    local entries = 0
    for itemId, amount in pairs(items) do
        if type(itemId) ~= "string" or itemId == "" or type(amount) ~= "number" then
            return false
        end
        if not ItemsData.GetItem(itemId) then
            return false
        end
        if amount ~= amount or amount < 1 or amount > MAX_ITEM_AMOUNT or amount ~= math.floor(amount) then
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

    -- CreateTrade: open a new targeted trade offer.
    local CreateTrade = Remotes:FindFirstChild("CreateTrade")
    if CreateTrade then
        CreateTrade.OnServerEvent:Connect(function(player, targetUserId, offerItems, requestItems)
            if type(targetUserId) ~= "number" or targetUserId ~= math.floor(targetUserId) then
                notify(player, "Select a nearby player first")
                return
            end
            if not TradingService.ValidateItemMap(offerItems) or not TradingService.ValidateItemMap(requestItems) then
                notify(player, "Invalid trade items")
                return
            end
            if next(offerItems) == nil and next(requestItems) == nil then
                return
            end
            -- Rate limit: max one trade creation per 2 seconds per player
            if not RateLimiter.Check(player, "CreateTrade", 2) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local tradeId, message = TradingService.CreateTrade(player, targetUserId, offerItems, requestItems)
            if not tradeId and message then
                notify(player, message)
            end
        end)
    end

    -- AcceptTrade: accept a pending trade
    local AcceptTrade = Remotes:FindFirstChild("AcceptTrade")
    if AcceptTrade then
        AcceptTrade.OnServerEvent:Connect(function(player, tradeId)
            if type(tradeId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "AcceptTrade", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
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
            if not RateLimiter.Check(player, "CancelTrade", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = TradingService.CancelTrade(player, tradeId)
            if not success and message then
                notify(player, message)
            end
        end)
    end

    game.Players.PlayerRemoving:Connect(function(player)
        TradingService.CancelTradesForPlayer(player)
    end)

    print("[TradingService] Initialized")
end

function TradingService.CreateTrade(player, targetUserId, offerItems, requestItems)
    if type(targetUserId) ~= "number" or targetUserId ~= math.floor(targetUserId) then
        return nil, "Invalid trade recipient"
    end
    if not TradingService.ValidateItemMap(offerItems) or not TradingService.ValidateItemMap(requestItems) then
        return nil, "Invalid trade payload"
    end
    if next(offerItems) == nil and next(requestItems) == nil then
        return nil, "Trade must contain an item"
    end

    local targetPlayer = game.Players:GetPlayerByUserId(targetUserId)
    if not targetPlayer or targetPlayer == player then
        return nil, "Trade recipient is unavailable"
    end
    if not playersAreNearby(player, targetPlayer) then
        return nil, "Trade players must be nearby"
    end
    if not PlayerDataService.GetData(player) or not PlayerDataService.GetData(targetPlayer) then
        return nil, "Player data is still loading"
    end
    for itemId, amount in pairs(offerItems) do
        if PlayerDataService.GetItemCount(player, itemId) < amount then
            return nil, "You no longer own the offered items"
        end
    end

    TradingService.TradeIdCounter += 1
    local tradeId = "TRADE_" .. player.UserId .. "_" .. TradingService.TradeIdCounter
    local trade = {
        Id = tradeId,
        PlayerId = player.UserId,
        TargetPlayerId = targetPlayer.UserId,
        OfferItems = cloneItemMap(offerItems),
        RequestItems = cloneItemMap(requestItems),
        Status = "Pending",
        CreatedAt = os.time(),
    }

    TradingService.ActiveTrades[tradeId] = trade

    notifyTradePlayers(trade, "TradeCreated")

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
    if trade.TargetPlayerId ~= player.UserId then
        return false, "This trade is not addressed to you"
    end
    if not playersAreNearby(offerer, player) then
        return false, "Trade players must remain nearby"
    end
    if not PlayerDataService.GetData(offerer) or not PlayerDataService.GetData(player) then
        return false, "Player data is still loading"
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

    -- Phase 2: execute transfers. Keep a journal so an unexpected profile
    -- failure cannot silently destroy an item during the exchange.
    local removed = {}
    local added = {}
    local function rollback()
        for _, entry in ipairs(added) do
            PlayerDataService.RemoveItem(entry.player, entry.itemId, entry.amount)
        end
        for _, entry in ipairs(removed) do
            PlayerDataService.AddItem(entry.player, entry.itemId, entry.amount)
        end
    end

    local function moveItem(fromPlayer, toPlayer, itemId, amount)
        if not PlayerDataService.RemoveItem(fromPlayer, itemId, amount) then
            return false
        end
        table.insert(removed, { player = fromPlayer, itemId = itemId, amount = amount })
        if not PlayerDataService.AddItem(toPlayer, itemId, amount) then
            return false
        end
        table.insert(added, { player = toPlayer, itemId = itemId, amount = amount })
        return true
    end

    for itemId, amount in pairs(trade.OfferItems) do
        if not moveItem(offerer, player, itemId, amount) then
            rollback()
            return false, "Trade could not be completed"
        end
    end
    for itemId, amount in pairs(trade.RequestItems) do
        if not moveItem(player, offerer, itemId, amount) then
            rollback()
            return false, "Trade could not be completed"
        end
    end

    -- Do not report success until both durable profiles contain the transfer.
    -- If either write fails, reverse every item mutation before releasing the
    -- trade so a retry cannot create or destroy inventory.
    if not PlayerDataService.SaveNow(offerer) or not PlayerDataService.SaveNow(player) then
        rollback()
        PlayerDataService.SaveNow(offerer)
        PlayerDataService.SaveNow(player)
        return false, "Trade could not be saved"
    end

    trade.Status = "Accepted"
    trade.AcceptedBy = player.UserId

    print("[TradingService] Trade accepted: " .. tradeId)

    notifyTradePlayers(trade, "TradeCompleted")

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

    if trade.PlayerId ~= player.UserId and trade.TargetPlayerId ~= player.UserId then
        return false, "Not your trade"
    end

    if trade.Status ~= "Pending" then
        return false, "Trade already processed"
    end

    trade.Status = "Cancelled"
    TradingService.ActiveTrades[tradeId] = nil

    notifyTradePlayers(trade, "TradeCancelled")

    return true, "Trade cancelled"
end

function TradingService.CancelTradesForPlayer(player)
    local toCancel = {}
    for tradeId, trade in pairs(TradingService.ActiveTrades) do
        if trade.Status == "Pending" and (trade.PlayerId == player.UserId or trade.TargetPlayerId == player.UserId) then
            table.insert(toCancel, tradeId)
        end
    end
    for _, tradeId in ipairs(toCancel) do
        local trade = TradingService.ActiveTrades[tradeId]
        if trade then
            trade.Status = "Cancelled"
            TradingService.ActiveTrades[tradeId] = nil
            notifyTradePlayers(trade, "TradeCancelled")
        end
    end
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
