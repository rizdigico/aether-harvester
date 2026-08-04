--
-- TradingService.luau
-- Manages trading and marketplace logic between players
--

local Players = game:GetService("Players")
local DataStoreService = require(script.Parent.DataStoreService)

-- Constants
local TRADE_MAX_ITEMS = 5
local TRADE_TIMEOUT = 30 -- Seconds

-- Function to initialize trading data for a player
local function initializePlayerTrading(player: Player)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Trading then
        playerData.Trading = {
            offers = {},
            activeTrades = {}
        }
    end
    player:SetAttribute("PlayerData", playerData)
end

-- Function to create a trade offer
local function createTradeOffer(player: Player, items: table, price: number)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Trading then
        return false, "Trading data not found."
    end
    
    -- Validate items
    if #items > TRADE_MAX_ITEMS then
        return false, "Cannot offer more than " .. TRADE_MAX_ITEMS .. " items."
    end
    
    -- Check if player has enough items
    for _, item in pairs(items) do
        local inventoryData = playerData.Inventory or {}
        if not inventoryData[item.itemId] or inventoryData[item.itemId] < item.quantity then
            return false, "Not enough items in inventory."
        end
    end
    
    -- Create trade offer
    local offerId = tostring(tick())
    local offer = {
        id = offerId,
        playerId = player.UserId,
        items = items,
        price = price,
        createdAt = tick()
    }
    
    -- Add offer to player's trading data
    playerData.Trading.offers[offerId] = offer
    
    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Trading = playerData.Trading
    })
    
    -- Notify client
    game:GetService("ReplicatedStorage"):FindFirstChild("TradeEvent"):FireClient(player, "offer_created", offer)
    
    return true, "Trade offer created."
end

-- Function to accept a trade offer
local function acceptTradeOffer(player: Player, offerId: string)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Trading then
        return false, "Trading data not found."
    end
    
    -- Find the offer
    local offer = playerData.Trading.offers[offerId]
    if not offer then
        return false, "Trade offer not found."
    end
    
    -- Check if the offer is from another player
    if offer.playerId == player.UserId then
        return false, "Cannot trade with yourself."
    end
    
    -- Check if the offer is still valid
    if tick() - offer.createdAt > TRADE_TIMEOUT then
        return false, "Trade offer expired."
    end
    
    -- Check if the player has enough currency
    local currency = 100 -- Example currency
    if player:GetAttribute("Currency") < offer.price then
        return false, "Not enough currency."
    end
    
    -- Create active trade
    local activeTradeId = tostring(tick())
    local activeTrade = {
        id = activeTradeId,
        player1Id = player.UserId,
        player2Id = offer.playerId,
        items1 = offer.items,
        items2 = {}, -- Items from the other player
        price = offer.price,
        createdAt = tick()
    }
    
    -- Add active trade to both players' trading data
    playerData.Trading.activeTrades[activeTradeId] = activeTrade
    
    -- Find the other player and add the trade to their data
    local otherPlayer = Players:GetPlayerByUserId(offer.playerId)
    if otherPlayer then
        local otherPlayerData = otherPlayer:GetAttribute("PlayerData") or {}
        if not otherPlayerData.Trading then
            otherPlayerData.Trading = {
                offers = {},
                activeTrades = {}
            }
        end
        otherPlayerData.Trading.activeTrades[activeTradeId] = activeTrade
        DataStoreService.savePlayerData(otherPlayer, {
            Trading = otherPlayerData.Trading
        })
    end
    
    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Trading = playerData.Trading
    })
    
    -- Notify clients
    game:GetService("ReplicatedStorage"):FindFirstChild("TradeEvent"):FireClient(player, "trade_accepted", activeTrade)
    game:GetService("ReplicatedStorage"):FindFirstChild("TradeEvent"):FireClient(otherPlayer, "trade_requested", activeTrade)
    
    return true, "Trade accepted."
end

-- Function to complete a trade
local function completeTrade(player: Player, tradeId: string, items: table)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Trading then
        return false, "Trading data not found."
    end
    
    -- Find the active trade
    local activeTrade = playerData.Trading.activeTrades[tradeId]
    if not activeTrade then
        return false, "Active trade not found."
    end
    
    -- Check if the trade is still valid
    if tick() - activeTrade.createdAt > TRADE_TIMEOUT then
        return false, "Trade expired."
    end
    
    -- Check if the player is the correct one for this trade
    if activeTrade.player1Id ~= player.UserId or activeTrade.player2Id ~= player.UserId then
        return false, "You are not part of this trade."
    end
    
    -- Update player inventories
    local player1 = Players:GetPlayerByUserId(activeTrade.player1Id)
    local player2 = Players:GetPlayerByUserId(activeTrade.player2Id)
    
    if player1 and player2 then
        -- Remove items from player1's inventory
        for _, item in pairs(activeTrade.items1) do
            local inventoryData = player1:GetAttribute("PlayerData"):GetAttribute("Inventory") or {}
            inventoryData[item.itemId] = (inventoryData[item.itemId] or 0) - item.quantity
            player1:SetAttribute("Inventory", inventoryData)
        end
        
        -- Add items from player2 to player1's inventory
        for _, item in pairs(items) do
            local inventoryData = player1:GetAttribute("PlayerData"):GetAttribute("Inventory") or {}
            inventoryData[item.itemId] = (inventoryData[item.itemId] or 0) + item.quantity
            player1:SetAttribute("Inventory", inventoryData)
        end
        
        -- Remove items from player2's inventory
        for _, item in pairs(activeTrade.items2) do
            local inventoryData = player2:GetAttribute("PlayerData"):GetAttribute("Inventory") or {}
            inventoryData[item.itemId] = (inventoryData[item.itemId] or 0) - item.quantity
            player2:SetAttribute("Inventory", inventoryData)
        end
        
        -- Add items from player1 to player2's inventory
        for _, item in pairs(activeTrade.items1) do
            local inventoryData = player2:GetAttribute("PlayerData"):GetAttribute("Inventory") or {}
            inventoryData[item.itemId] = (inventoryData[item.itemId] or 0) + item.quantity
            player2:SetAttribute("Inventory", inventoryData)
        end
        
        -- Deduct currency
        local currency = 100 -- Example currency
        player1:SetAttribute("Currency", player1:GetAttribute("Currency") - activeTrade.price)
        player2:SetAttribute("Currency", player2:GetAttribute("Currency") + activeTrade.price)
        
        -- Remove completed trade
        playerData.Trading.activeTrades[tradeId] = nil
        local otherPlayerData = player2:GetAttribute("PlayerData") or {}
        otherPlayerData.Trading.activeTrades[tradeId] = nil
        
        -- Save updated player data
        DataStoreService.savePlayerData(player1, {
            Inventory = player1:GetAttribute("Inventory"),
            Currency = player1:GetAttribute("Currency")
        })
        DataStoreService.savePlayerData(player2, {
            Inventory = player2:GetAttribute("Inventory"),
            Currency = player2:GetAttribute("Currency")
        })
        
        -- Notify clients
        game:GetService("ReplicatedStorage"):FindFirstChild("TradeEvent"):FireClient(player1, "trade_completed", tradeId)
        game:GetService("ReplicatedStorage"):FindFirstChild("TradeEvent"):FireClient(player2, "trade_completed", tradeId)
        
        return true, "Trade completed."
    end
    
    return false, "Failed to complete trade."
end

-- Function to cancel a trade
local function cancelTrade(player: Player, tradeId: string)
    local playerData = player:GetAttribute("PlayerData") or {}
    if not playerData.Trading then
        return false, "Trading data not found."
    end
    
    -- Find the active trade
    local activeTrade = playerData.Trading.activeTrades[tradeId]
    if not activeTrade then
        return false, "Active trade not found."
    end
    
    -- Check if the player is the correct one for this trade
    if activeTrade.player1Id ~= player.UserId and activeTrade.player2Id ~= player.UserId then
        return false, "You are not part of this trade."
    end
    
    -- Remove the trade
    playerData.Trading.activeTrades[tradeId] = nil
    
    -- Find the other player and remove the trade from their data
    local otherPlayer = Players:GetPlayerByUserId(activeTrade.player1Id == player.UserId and activeTrade.player2Id or activeTrade.player1Id)
    if otherPlayer then
        local otherPlayerData = otherPlayer:GetAttribute("PlayerData") or {}
        otherPlayerData.Trading.activeTrades[tradeId] = nil
        DataStoreService.savePlayerData(otherPlayer, {
            Trading = otherPlayerData.Trading
        })
    end
    
    -- Save updated player data
    DataStoreService.savePlayerData(player, {
        Trading = playerData.Trading
    })
    
    -- Notify clients
    game:GetService("ReplicatedStorage"):FindFirstChild("TradeEvent"):FireClient(player, "trade_cancelled", tradeId)
    if otherPlayer then
        game:GetService("ReplicatedStorage"):FindFirstChild("TradeEvent"):FireClient(otherPlayer, "trade_cancelled", tradeId)
    end
    
    return true, "Trade cancelled."
end

-- Initialize trading data for existing players
for _, player in ipairs(Players:GetPlayers()) do
    initializePlayerTrading(player)
end

-- Connect to player added event
Players.PlayerAdded:Connect(function(player)
    initializePlayerTrading(player)
    
    -- Connect to remote events
    local tradeEvent = game:GetService("ReplicatedStorage"):FindFirstChild("TradeEvent")
    if tradeEvent then
        tradeEvent.OnServerEvent:Connect(function(player, action, ...)
            if action == "create_offer" then
                local items, price = ..., ...
                createTradeOffer(player, items, price)
            elseif action == "accept_offer" then
                local offerId = ...
                acceptTradeOffer(player, offerId)
            elseif action == "complete_trade" then
                local tradeId, items = ..., ...
                completeTrade(player, tradeId, items)
            elseif action == "cancel_trade" then
                local tradeId = ...
                cancelTrade(player, tradeId)
            end
        end)
    end
end

-- Export functions for use by other modules
return {
    initializePlayerTrading = initializePlayerTrading,
    createTradeOffer = createTradeOffer,
    acceptTradeOffer = acceptTradeOffer,
    completeTrade = completeTrade,
    cancelTrade = cancelTrade
}