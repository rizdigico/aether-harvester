--
-- Trading.luau
-- Trading and marketplace logic module for Aether Harvester Simulator
--

local Trading = {}

-- Constants
local TRADE_DURATION = 30 -- seconds
local TRADE_RANGE = 15 -- studs
local MARKETPLACE_FEE = 0.1 -- 10% fee
local TRADE_CONFIRMATION_TIME = 5 -- seconds

--[[
    TRADING STRUCTURE:
    {
        player = {
            character = nil,
            humanoidRootPart = nil,
            inventory = nil
        },
        trade = {
            initiator = nil,
            acceptor = nil,
            items = {
                {
                    player = "Initiator",
                    itemName = "ItemName",
                    quantity = 1
                },
                {
                    player = "Acceptor",
                    itemName = "ItemName",n                    quantity = 1
                }
            },
            currency = {
                initiator = 0,
                acceptor = 0
            },
            status = "pending",
            createdAt = os.time(),
            confirmedAt = nil
        },
        marketplace = {
            listings = {
                {
                    seller = "PlayerName",
                    itemName = "ItemName",
                    quantity = 1,
                    price = 100,
                    createdAt = os.time()
                }
            }
        }
    }
]]

-- Initialize trading system
function Trading.New(player)
    return {
        player = player,
        trade = nil,
        marketplace = {
            listings = {}
        }
    }
end

-- Start a trade with another player
function Trading:StartTrade(targetPlayer, items, currency)
    -- Check if target player exists
    if not game.Players:FindFirstChild(targetPlayer.Name) then
        warn(string.format("Target player %s not found.", targetPlayer.Name))
        return false, "Target player not found."
    end
    
    -- Check if trade already exists
    if self.trade and self.trade.status ~= "completed" then
        return false, "Trade already in progress."
    end
    
    -- Check if items are valid
    for _, item in ipairs(items) do
        local itemData = Items.Get(item.itemName)
        if not itemData then
            warn(string.format("Item %s not found.", item.itemName))
            return false, string.format("Item %s not found.", item.itemName)
        end
        
        -- Check if player has enough items
        local inventory = item.player:GetAttribute("Inventory") or Inventory.New()
        if inventory:GetItemCount(item.itemName) < item.quantity then
            return false, string.format("Player does not have enough %s.", item.itemName)
        end
    end
    
    -- Create trade
    self.trade = {
        initiator = self.player,
        acceptor = targetPlayer,
        items = items,
        currency = currency or {initiator = 0, acceptor = 0},
        status = "pending",
        createdAt = os.time(),
        confirmedAt = nil
    }
    
    -- Notify players
    self:NotifyPlayers()
    
    return true, "Trade initiated successfully."
end

-- Accept a trade
function Trading:AcceptTrade()
    if not self.trade then
        return false, "No trade in progress."
    end
    
    if self.trade.status ~= "pending" then
        return false, "Trade already accepted or completed."
    end
    
    -- Update trade status
    self.trade.status = "accepted"
    self.trade.confirmedAt = os.time()
    
    -- Notify players
    self:NotifyPlayers()
    
    return true, "Trade accepted."
end

-- Confirm a trade
function Trading:ConfirmTrade()
    if not self.trade then
        return false, "No trade in progress."
    end
    
    if self.trade.status ~= "accepted" then
        return false, "Trade not accepted yet."
    end
    
    -- Check if trade is within confirmation time
    if os.time() - self.trade.createdAt > TRADE_CONFIRMATION_TIME then
        return false, "Trade confirmation time expired."
    end
    
    -- Process trade
    local success, message = self:ProcessTrade()
    
    if success then
        -- Reset trade
        self.trade = nil
        
        -- Notify players
        self:NotifyPlayers()
        
        return true, message
    else
        return false, message
    end
end

-- Process trade
function Trading:ProcessTrade()
    if not self.trade then
        return false, "No trade in progress."
    end
    
    -- Check if trade is valid
    if self.trade.status ~= "accepted" then
        return false, "Trade not accepted."
    end
    
    -- Transfer items
    for _, item in ipairs(self.trade.items) do
        local inventory = item.player:GetAttribute("Inventory") or Inventory.New()
        
        -- Remove items from initiator
        if item.player == self.trade.initiator then
            inventory:RemoveItem(item.itemName, item.quantity)
        end
        
        -- Add items to acceptor
        if item.player == self.trade.acceptor then
            inventory:AddItem(item.itemName, item.quantity)
        end
    end
    
    -- Transfer currency
    if self.trade.currency.initiator > 0 then
        local initiatorInventory = self.trade.initiator:GetAttribute("Inventory") or Inventory.New()
        initiatorInventory:RemoveCurrency("gold", self.trade.currency.initiator)
    end
    
    if self.trade.currency.acceptor > 0 then
        local acceptorInventory = self.trade.acceptor:GetAttribute("Inventory") or Inventory.New()
        acceptorInventory:AddCurrency("gold", self.trade.currency.acceptor)
    end
    
    -- Apply marketplace fee if applicable
    if self.trade.currency.initiator > 0 then
        local fee = math.floor(self.trade.currency.initiator * MARKETPLACE_FEE)
        local marketplaceInventory = game:GetService("MarketplaceService"):GetPlayerMarketplaceData(self.trade.initiator.UserId).Currency
        marketplaceInventory = marketplaceInventory or 0
        marketplaceInventory = marketplaceInventory + fee
        self.trade.initiator:SetAttribute("MarketplaceFee", fee)
    end
    
    -- Update trade status
    self.trade.status = "completed"
    
    return true, "Trade completed successfully."
end

-- Cancel a trade
function Trading:CancelTrade()
    if not self.trade then
        return false, "No trade in progress."
    end
    
    if self.trade.status == "completed" then
        return false, "Trade already completed."
    end
    
    -- Reset trade
    self.trade = nil
    
    -- Notify players
    self:NotifyPlayers()
    
    return true, "Trade cancelled."
end

-- List an item for sale
function Trading:ListItem(itemName, quantity, price)
    local item = Items.Get(itemName)
    if not item then
        warn(string.format("Item %s not found.", itemName))
        return false, string.format("Item %s not found.", itemName)
    end
    
    -- Check if player has enough items
    local inventory = self.player:GetAttribute("Inventory") or Inventory.New()
    if inventory:GetItemCount(itemName) < quantity then
        return false, string.format("Player does not have enough %s.", itemName)
    end
    
    -- Add listing to marketplace
    table.insert(self.marketplace.listings, {
        seller = self.player.Name,
        itemName = itemName,
        quantity = quantity,
        price = price,
        createdAt = os.time()
    })
    
    return true, "Item listed for sale successfully."
end

-- Buy an item from marketplace
function Trading:BuyItem(listingIndex, buyerPlayer)
    if not self.marketplace.listings[listingIndex] then
        warn(string.format("Listing %d not found.", listingIndex))
        return false, string.format("Listing %d not found.", listingIndex)
    end
    
    local listing = self.marketplace.listings[listingIndex]
    
    -- Check if buyer has enough currency
    local buyerInventory = buyerPlayer:GetAttribute("Inventory") or Inventory.New()
    if buyerInventory:GetCurrency().gold < listing.price then
        return false, "Buyer does not have enough currency."
    end
    
    -- Transfer items from seller to buyer
    local sellerInventory = self.player:GetAttribute("Inventory") or Inventory.New()
    sellerInventory:RemoveItem(listing.itemName, listing.quantity)
    buyerInventory:AddItem(listing.itemName, listing.quantity)
    
    -- Transfer currency from buyer to seller
    buyerInventory:RemoveCurrency("gold", listing.price)
    sellerInventory:AddCurrency("gold", listing.price)
    
    -- Apply marketplace fee
    local fee = math.floor(listing.price * MARKETPLACE_FEE)
    local marketplaceInventory = game:GetService("MarketplaceService"):GetPlayerMarketplaceData(self.player.UserId).Currency
    marketplaceInventory = marketplaceInventory or 0
    marketplaceInventory = marketplaceInventory + fee
    self.player:SetAttribute("MarketplaceFee", fee)
    
    -- Remove listing
    table.remove(self.marketplace.listings, listingIndex)
    
    return true, "Item purchased successfully."
end

-- Get marketplace listings
function Trading:GetMarketplaceListings()
    return self.marketplace.listings
end

-- Get trade status
function Trading:GetTradeStatus()
    if not self.trade then
        return "no trade"
    end
    return self.trade.status
end

-- Get trade items
function Trading:GetTradeItems()
    if not self.trade then
        return nil
    end
    return self.trade.items
end

-- Get trade currency
function Trading:GetTradeCurrency()
    if not self.trade then
        return nil
    end
    return self.trade.currency
end

-- Notify players about trade status
function Trading:NotifyPlayers()
    if not self.trade then
        return
    end
    
    local message = string.format("Trade status: %s", self.trade.status)
    
    -- Notify initiator
    if self.trade.initiator.Character then
        local leaderboard = self.trade.initiator.Character:FindFirstChildOfClass("ScreenGui"):FindFirstChild("Leaderboard")
        if leaderboard then
            local textLabel = leaderboard:FindFirstChild("TextLabel")
            if textLabel then
                textLabel.Text = message
            end
        end
    end
    
    -- Notify acceptor
    if self.trade.acceptor.Character then
        local leaderboard = self.trade.acceptor.Character:FindFirstChildOfClass("ScreenGui"):FindFirstChild("Leaderboard")
        if leaderboard then
            local textLabel = leaderboard:FindFirstChild("TextLabel")
            if textLabel then
                textLabel.Text = message
            end
        end
    end
end

-- Check if players are within trade range
function Trading:ArePlayersInRange(player1, player2)
    if not player1.Character or not player2.Character then
        return false
    end
    
    local rootPart1 = player1.Character:FindFirstChild("HumanoidRootPart")
    local rootPart2 = player2.Character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart1 or not rootPart2 then
        return false
    end
    
    local distance = (rootPart1.Position - rootPart2.Position).Magnitude
    return distance <= TRADE_RANGE
end

return Trading