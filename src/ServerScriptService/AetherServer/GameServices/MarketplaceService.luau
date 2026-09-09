local MarketplaceService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)

MarketplaceService.Listings = {}
MarketplaceService.ListingIdCounter = 1
local processingListings = {}

function MarketplaceService.Initialize()
    print("[MarketplaceService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- GetMarketplaceListings: return all active listings
    local GetMarketplaceListings = Remotes:FindFirstChild("GetMarketplaceListings")
    if GetMarketplaceListings then
        GetMarketplaceListings.OnServerInvoke = function(player)
            if not RateLimiter.Check(player, "GetMarketplaceListings", 0.5) then
                return {}
            end
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
            -- Rate limit: max one listing creation per 2 seconds per player
            if not RateLimiter.Check(player, "CreateListing", 2) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = MarketplaceService.CreateListing(player, itemId, amount, price)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Failed to create listing")
                end
            end
        end)
    end

    -- CancelListing
    local CancelListing = Remotes:FindFirstChild("CancelListing")
    if CancelListing then
        CancelListing.OnServerEvent:Connect(function(player, listingId)
            if type(listingId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "CancelListing", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
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
            if not RateLimiter.Check(player, "PurchaseListing", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
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
    -- VALIDATION: bounds + ownership (fixes currency-from-nothing dupe)
    if type(itemId) ~= "string" or itemId == "" then
        return false, "Invalid item"
    end
    if not ItemsData.GetItem(itemId) then
        return false, "Unknown item"
    end
    if type(amount) ~= "number" or amount ~= amount or amount < 1 or amount > 9999 or amount ~= math.floor(amount) then
        return false, "Invalid amount"
    end
    if type(price) ~= "number" or price ~= price or price < 1 or price > 1000000 or price ~= math.floor(price) then
        return false, "Invalid price"
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end
    local owned = PlayerDataService.GetItemCount(player, itemId)
    if owned < amount then
        return false, "You don't own enough of that item"
    end

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

    -- Remove item from seller's inventory (verified ownership above)
    local removed = PlayerDataService.RemoveItem(player, itemId, amount)
    if not removed then
        -- Ownership changed between check and removal (race): abort listing
        MarketplaceService.Listings[listingId] = nil
        return false, "Could not remove item"
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
    return true, listingId, listing
end

function MarketplaceService.PurchaseListing(player, listingId)
    local listing = MarketplaceService.Listings[listingId]
    if not listing then
        return false, "Listing not found"
    end

    if listing.Status ~= "Active" then
        return false, "Listing not available"
    end

    if processingListings[listingId] then
        return false, "Listing is being processed"
    end
    processingListings[listingId] = true
    local function fail(message)
        processingListings[listingId] = nil
        return false, message
    end

    if listing.SellerId == player.UserId then
        return fail("Cannot buy your own listing")
    end

    local buyerData = PlayerDataService.GetData(player)
    if not buyerData then
        return fail("Player data not found")
    end

    -- Listings are held in server memory. Require the seller to be present so
    -- a sale can never deduct a buyer and silently lose the seller payout.
    local seller = game.Players:GetPlayerByUserId(listing.SellerId)
    if not seller or not PlayerDataService.GetData(seller) then
        return fail("Seller is unavailable")
    end

    if buyerData.Currency.AetherShards < listing.Price then
        return fail("Not enough currency")
    end

    -- Deduct price from buyer
    if not PlayerDataService.RemoveCurrency(player, "AetherShards", listing.Price) then
        return fail("Not enough currency")
    end

    -- Add item to buyer. Roll back the debit if the inventory mutation fails.
    if not PlayerDataService.AddItem(player, listing.ItemId, listing.Amount) then
        PlayerDataService.AddCurrency(player, "AetherShards", listing.Price)
        return fail("Could not deliver purchased item")
    end

    -- Give money to seller
    if not PlayerDataService.AddCurrency(seller, "AetherShards", listing.Price) then
        -- This should be unreachable after the seller data check. Keep the
        -- sale active if the payout cannot be recorded.
        PlayerDataService.RemoveItem(player, listing.ItemId, listing.Amount)
        PlayerDataService.AddCurrency(player, "AetherShards", listing.Price)
        return fail("Seller payout failed")
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
    processingListings[listingId] = nil
    return true, "Purchase successful"
end

function MarketplaceService.OnPlayerRemoving(player)
    -- Return all escrowed items before PlayerDataService saves and clears the
    -- player's profile. This prevents disconnects from destroying listings.
    local cancelled = {}
    for listingId, listing in pairs(MarketplaceService.Listings) do
        if listing.SellerId == player.UserId and listing.Status == "Active" then
            if PlayerDataService.AddItem(player, listing.ItemId, listing.Amount) then
                listing.Status = "Cancelled"
                MarketplaceService.Listings[listingId] = nil
                table.insert(cancelled, listingId)
            end
        end
    end

    if #cancelled == 0 then
        return
    end

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    local ListingCancelled = Remotes and Remotes:FindFirstChild("ListingCancelled")
    if ListingCancelled then
        for _, listingId in ipairs(cancelled) do
            ListingCancelled:FireAllClients(listingId)
        end
    end
end

function MarketplaceService.CancelListing(player, listingId)
    local listing = MarketplaceService.Listings[listingId]
    if not listing then
        return false, "Listing not found"
    end

    if listing.SellerId ~= player.UserId then
        return false, "Not your listing"
    end

    -- Return item to seller before deleting the listing. If the profile is
    -- unavailable or the escrow return fails, keep the listing intact.
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end
    if not PlayerDataService.AddItem(player, listing.ItemId, listing.Amount) then
        return false, "Could not return escrowed item"
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
