local MarketplaceService = {}
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceDataStore = DataStoreService:GetDataStore("MarketplaceData_v2")
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)
local MarketplaceRules = require(game.ReplicatedStorage.AetherShared.Modules.MarketplaceRules)

MarketplaceService.Listings = {}
MarketplaceService.ListingIdCounter = 1
local processingListings = {}
local PERSISTENT_KEY = "ActiveListings"
local lastPersistentLoad = 0

local function cloneListing(listing)
    return table.clone(listing)
end

local function normalizeListings(rawListings, now)
    local listings = {}
    if type(rawListings) ~= "table" then
        return listings
    end
    for listingId, rawListing in pairs(rawListings) do
        local listing = MarketplaceRules.NormalizeListing(rawListing, listingId, now)
        if listing and ItemsData.GetItem(listing.ItemId) then
            listings[listingId] = listing
        end
    end
    return listings
end

local function updatePersistentListings(mutator)
    local updated
    local success, err = pcall(function()
        updated = MarketplaceDataStore:UpdateAsync(PERSISTENT_KEY, function(rawListings)
            local listings = normalizeListings(rawListings, os.time())
            local nextListings = mutator(listings)
            return nextListings or listings
        end)
    end)
    if not success then
        warn("[MarketplaceService] Persistent listing update failed: ", err)
    end
    return success, updated
end

local function loadPersistentListings()
    local success, rawListings = pcall(function()
        return MarketplaceDataStore:GetAsync(PERSISTENT_KEY)
    end)
    if not success then
        warn("[MarketplaceService] Persistent listing load failed: ", rawListings)
        return false
    end
    MarketplaceService.Listings = normalizeListings(rawListings, os.time())
    lastPersistentLoad = os.time()
    return true
end

local function getPersistentListing(listingId)
    local success, rawListings = pcall(function()
        return MarketplaceDataStore:GetAsync(PERSISTENT_KEY)
    end)
    if not success then
        return nil
    end
    local listings = normalizeListings(rawListings, os.time())
    return listings[listingId]
end

local function addPersistentListing(listing)
    local inserted = false
    local success = updatePersistentListings(function(listings)
        inserted = false
        if listings[listing.Id] == nil then
            listings[listing.Id] = cloneListing(listing)
            inserted = true
        else
            inserted = false
        end
        return listings
    end)
    return success and inserted
end

local function claimPersistentListing(listingId, buyerUserId)
    local claimed
    local success = updatePersistentListings(function(listings)
        claimed = nil
        local listing = listings[listingId]
        if not listing then
            return listings
        end
        if listing.Status == "Processing" then
            if listing.ProcessingBy ~= buyerUserId then
                return listings
            end
        elseif listing.Status ~= "Active" then
            return listings
        end
        listing.Status = "Processing"
        listing.ProcessingBy = buyerUserId
        listing.ProcessingAt = os.time()
        claimed = cloneListing(listing)
        return listings
    end)
    return success and claimed or nil
end

local function releasePersistentListing(listingId, buyerUserId)
    local released = false
    local success = updatePersistentListings(function(listings)
        released = false
        local listing = listings[listingId]
        if listing and listing.Status == "Processing" and listing.ProcessingBy == buyerUserId then
            listing.Status = "Active"
            listing.ProcessingBy = nil
            listing.ProcessingAt = nil
            released = true
        end
        return listings
    end)
    return success and released
end

local function removePersistentListing(listingId, expectedSellerId, expectedBuyerId, expectedStatus)
    local removed = false
    local success = updatePersistentListings(function(listings)
        removed = false
        local listing = listings[listingId]
        if
            listing
            and (expectedSellerId == nil or listing.SellerId == expectedSellerId)
            and (expectedBuyerId == nil or (listing.Status == "Processing" and listing.ProcessingBy == expectedBuyerId))
            and (expectedStatus == nil or listing.Status == expectedStatus)
        then
            listings[listingId] = nil
            removed = true
        end
        return listings
    end)
    return success and removed
end

function MarketplaceService.Initialize()
    -- Listings survive server restarts. Any stale processing claim is reset by
    -- normalizeListings so an interrupted buyer cannot lock an item forever.
    loadPersistentListings()
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
    if not MarketplaceRules.IsValidAmount(amount) then
        return false, "Invalid amount"
    end
    if not MarketplaceRules.IsValidPrice(price) then
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

    local listingId = string.format("LISTING_%d_%d_%s", player.UserId, os.time(), HttpService:GenerateGUID(false))
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

    -- Remove item from seller's inventory (verified ownership above)
    local removed = PlayerDataService.RemoveItem(player, itemId, amount)
    if not removed then
        -- Ownership changed between check and removal (race): abort listing.
        return false, "Could not remove item"
    end

    -- Persist the escrowed inventory state before publishing the listing. This
    -- prevents a server restart from exposing an item that was never removed.
    if not PlayerDataService.SaveNow(player) then
        PlayerDataService.AddItem(player, itemId, amount)
        PlayerDataService.SaveNow(player)
        return false, "Could not save escrowed item"
    end

    if not addPersistentListing(listing) then
        PlayerDataService.AddItem(player, itemId, amount)
        PlayerDataService.SaveNow(player)
        return false, "Could not save marketplace listing"
    end

    MarketplaceService.Listings[listingId] = listing

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
    if not MarketplaceRules.IsValidListingId(listingId) then
        return false, "Invalid listing"
    end

    local listing = MarketplaceService.Listings[listingId] or getPersistentListing(listingId)
    if not listing then
        return false, "Listing not found"
    end

    if
        listing.Status ~= "Active" and not (listing.Status == "Processing" and listing.ProcessingBy == player.UserId)
    then
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

    -- Settlement remains same-server by design: both profiles must be loaded so
    -- the buyer debit, item grant, and seller payout can be rolled back as one
    -- guarded operation. The listing itself is durable across restarts.
    local seller = Players:GetPlayerByUserId(listing.SellerId)
    if not seller or not PlayerDataService.GetData(seller) then
        return fail("Seller is unavailable")
    end

    local buyerAlreadySettled = PlayerDataService.GetMarketplaceTransaction(player, listingId) == "BuyerSettled"
    if not buyerAlreadySettled and buyerData.Currency.AetherShards < listing.Price then
        return fail("Not enough currency")
    end

    local claimedListing = claimPersistentListing(listingId, player.UserId)
    if not claimedListing then
        return fail("Listing is no longer available")
    end
    listing = claimedListing
    MarketplaceService.Listings[listingId] = listing

    local sellerAlreadySettled = PlayerDataService.GetMarketplaceTransaction(seller, listingId) == "SellerSettled"
    local buyerDebited = false
    local buyerItemAdded = false
    local sellerCredited = false
    local buyerMarked = false
    local sellerMarked = false

    local function rollback()
        if sellerCredited then
            PlayerDataService.RemoveCurrency(seller, "AetherShards", listing.Price)
        end
        if buyerItemAdded then
            PlayerDataService.RemoveItem(player, listing.ItemId, listing.Amount)
        end
        if buyerDebited then
            PlayerDataService.AddCurrency(player, "AetherShards", listing.Price)
        end
        if buyerMarked then
            PlayerDataService.ClearMarketplaceTransaction(player, listingId, "BuyerSettled")
        end
        if sellerMarked then
            PlayerDataService.ClearMarketplaceTransaction(seller, listingId, "SellerSettled")
        end
        -- Best-effort profile snapshots keep the in-memory rollback durable.
        PlayerDataService.SaveNow(player)
        PlayerDataService.SaveNow(seller)
        releasePersistentListing(listingId, player.UserId)
        local released = getPersistentListing(listingId)
        if released then
            MarketplaceService.Listings[listingId] = released
        end
    end

    -- Resume already-saved sides after a crash; only apply each mutation once.
    if not buyerAlreadySettled then
        if not PlayerDataService.RemoveCurrency(player, "AetherShards", listing.Price) then
            rollback()
            return fail("Not enough currency")
        end
        buyerDebited = true

        -- Add item to buyer.
        if not PlayerDataService.AddItem(player, listing.ItemId, listing.Amount) then
            rollback()
            return fail("Could not deliver purchased item")
        end
        buyerItemAdded = true

        if not PlayerDataService.MarkMarketplaceTransaction(player, listingId, "BuyerSettled") then
            rollback()
            return fail("Could not record buyer settlement")
        end
        buyerMarked = true
    end

    -- Give money to seller.
    if not sellerAlreadySettled then
        if not PlayerDataService.AddCurrency(seller, "AetherShards", listing.Price) then
            rollback()
            return fail("Seller payout failed")
        end
        sellerCredited = true

        if not PlayerDataService.MarkMarketplaceTransaction(seller, listingId, "SellerSettled") then
            rollback()
            return fail("Could not record seller settlement")
        end
        sellerMarked = true
    end

    -- Persist both profile mutations before removing the durable listing. If
    -- either save fails, restore all in-memory mutations and release the claim.
    local saved = true
    if buyerDebited or buyerItemAdded or buyerMarked then
        saved = PlayerDataService.SaveNow(player) and saved
    end
    if sellerCredited or sellerMarked then
        saved = PlayerDataService.SaveNow(seller) and saved
    end
    if not saved then
        rollback()
        return fail("Could not save marketplace settlement")
    end

    if not removePersistentListing(listingId, seller.UserId, player.UserId, "Processing") then
        rollback()
        return fail("Could not finalize marketplace settlement")
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
    -- Durable listings remain active while their seller is offline. The item
    -- stays escrowed in the saved profile and will be returned only by an
    -- explicit cancellation, preventing a disconnect from erasing a listing.
    for listingId, listing in pairs(MarketplaceService.Listings) do
        if listing.SellerId == player.UserId then
            MarketplaceService.Listings[listingId] = nil
        end
    end
end

function MarketplaceService.CancelListing(player, listingId)
    if not MarketplaceRules.IsValidListingId(listingId) then
        return false, "Invalid listing"
    end

    local listing = MarketplaceService.Listings[listingId] or getPersistentListing(listingId)
    if not listing then
        return false, "Listing not found"
    end

    if listing.SellerId ~= player.UserId then
        return false, "Not your listing"
    end

    if listing.Status ~= "Active" then
        return false, "Listing is being processed"
    end

    -- Remove the durable listing before returning escrow. If the profile save
    -- fails, restore the listing so an item can never be both returned and
    -- purchasable.
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end
    if not removePersistentListing(listingId, player.UserId, nil, "Active") then
        return false, "Could not save listing cancellation"
    end
    if not PlayerDataService.AddItem(player, listing.ItemId, listing.Amount) then
        addPersistentListing(listing)
        return false, "Could not return escrowed item"
    end
    if not PlayerDataService.SaveNow(player) then
        PlayerDataService.RemoveItem(player, listing.ItemId, listing.Amount)
        addPersistentListing(listing)
        return false, "Could not save returned item"
    end

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
    -- Refresh other servers' durable listings periodically. Do not replace a
    -- local snapshot while a same-server settlement is in progress.
    if os.time() - lastPersistentLoad >= 10 and next(processingListings) == nil then
        loadPersistentListings()
    end
    local listings = {}
    for _, listing in pairs(MarketplaceService.Listings) do
        -- The same-server settlement rule means only show listings that can
        -- actually be purchased in this server.
        if listing.Status == "Active" and Players:GetPlayerByUserId(listing.SellerId) then
            table.insert(listings, cloneListing(listing))
        end
    end
    table.sort(listings, function(a, b)
        if a.CreatedAt == b.CreatedAt then
            return a.Id < b.Id
        end
        return a.CreatedAt < b.CreatedAt
    end)
    return listings
end

return MarketplaceService
