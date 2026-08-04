local MarketplaceService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

MarketplaceService.Listings = {}
MarketplaceService.ListingIdCounter = 1

function MarketplaceService.Initialize()
    print("[MarketplaceService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- GetMarketplaceListings: return all active listings
    local GetMarketplaceListings = Remotes:FindFirstChild("GetMarketplaceListings")
    if GetMarketplaceListings then
        GetMarketplaceListings.OnServerInvoke = function()
            return MarketplaceService.GetActiveListings()
        end
    end

    -- CreateListing
    local CreateListing = Remotes:FindFirstChild("CreateListing")
    if CreateListing then
        CreateListing.OnServerEvent:Connect(function(player, itemId, amount, price)
            if type(itemId) ~= "string" or type(amount) ~= "number" or type(price) ~= "number" then
                return
            end
            MarketplaceService.CreateListing(player, itemId, math.floor(amount), math.floor(price))
        end)
    end

    -- CancelListing
    local CancelListing = Remotes:FindFirstChild("CancelListing")
    if CancelListing then
        CancelListing.OnServerEvent:Connect(function(player, listingId)
            if type(listingId) ~= "string" then
                return
            end
            local success, message = MarketplaceService.CancelListing(player, listingId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Failed to cancel listing")
                end
            end
        end)
    end

    -- PurchaseListing
    local PurchaseListing = Remotes:FindFirstChild("PurchaseListing")
    if PurchaseListing then
        PurchaseListing.OnServerEvent:Connect(function(player, listingId)
            if type(listingId) ~= "string" then
                return
            end
            local success, message = MarketplaceService.PurchaseListing(player, listingId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Purchase failed")
                end
            end
        end)
    end

    print("[MarketplaceService] Initialized")
end

function MarketplaceService.CreateListing(player, itemId, amount, price)
    local listingId = "LISTING_" .. MarketplaceService.ListingIdCounter
    MarketplaceService.ListingIdCounter += 1

    local listing = {
        Id = listingId,
        SellerId = player.UserId,
        SellerName = player.Name,
        ItemId = itemId,
        Amount = amount,
        Price = price,
        Status = "Active",
        CreatedAt = os.time(),
    }

    MarketplaceService.Listings[listingId] = listing

    -- Remove item from seller's inventory
    local data = PlayerDataService.GetData(player)
    if data then
        PlayerDataService.RemoveItem(player, itemId, amount)
    end

    -- Notify all clients
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local ListingCreated = Remotes:FindFirstChild("ListingCreated")
        if ListingCreated then
            ListingCreated:FireAllClients(listing)
        end
    end

    print("[MarketplaceService] Listing created: " .. listingId)
    return listingId, listing
end

function MarketplaceService.PurchaseListing(player, listingId)
    local listing = MarketplaceService.Listings[listingId]
    if not listing then
        return false, "Listing not found"
    end

    if listing.Status ~= "Active" then
        return false, "Listing not available"
    end

    if listing.SellerId == player.UserId then
        return false, "Cannot buy your own listing"
    end

    local buyerData = PlayerDataService.GetData(player)
    if not buyerData then
        return false, "Player data not found"
    end

    if buyerData.Currency.AetherShards < listing.Price then
        return false, "Not enough currency"
    end

    -- Deduct price from buyer
    PlayerDataService.RemoveCurrency(player, "AetherShards", listing.Price)

    -- Add item to buyer
    PlayerDataService.AddItem(player, listing.ItemId, listing.Amount)

    -- Give money to seller
    local seller = game.Players:GetPlayerByUserId(listing.SellerId)
    if seller then
        PlayerDataService.AddCurrency(seller, "AetherShards", listing.Price)
    end

    -- Mark listing as sold
    listing.Status = "Sold"
    MarketplaceService.Listings[listingId] = nil

    -- Notify clients
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local ListingPurchased = Remotes:FindFirstChild("ListingPurchased")
        if ListingPurchased then
            ListingPurchased:FireAllClients(listingId)
        end
    end

    print("[MarketplaceService] Listing purchased: " .. listingId)
    return true, "Purchase successful"
end

function MarketplaceService.CancelListing(player, listingId)
    local listing = MarketplaceService.Listings[listingId]
    if not listing then
        return false, "Listing not found"
    end

    if listing.SellerId ~= player.UserId then
        return false, "Not your listing"
    end

    -- Return item to seller
    local data = PlayerDataService.GetData(player)
    if data then
        PlayerDataService.AddItem(player, listing.ItemId, listing.Amount)
    end

    -- Remove listing
    MarketplaceService.Listings[listingId] = nil

    -- Notify clients
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local ListingCancelled = Remotes:FindFirstChild("ListingCancelled")
        if ListingCancelled then
            ListingCancelled:FireAllClients(listingId)
        end
    end

    return true, "Listing cancelled"
end

function MarketplaceService.GetActiveListings()
    local listings = {}
    for _, listing in pairs(MarketplaceService.Listings) do
        if listing.Status == "Active" then
            table.insert(listings, listing)
        end
    end
    return listings
end

return MarketplaceService
