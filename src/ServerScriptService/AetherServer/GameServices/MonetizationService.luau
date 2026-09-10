-- Server-owned monetization boundary.
-- Product IDs stay disabled (0) until the matching Creator Hub products are
-- created and reviewed. No client-supplied price or grant is trusted here.

local MonetizationService = {}
local RobloxMarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local AnalyticsService = require(game.ServerScriptService.AetherServer.GameServices.AnalyticsService)
local Monetization = require(ReplicatedStorage.AetherShared.Data.Monetization)
local ReceiptJournal = require(ReplicatedStorage.AetherShared.Modules.ReceiptJournal)
local CurrencyRules = require(ReplicatedStorage.AetherShared.Modules.CurrencyRules)

local initialized = false
local processingReceipts = {}

local function getRemotes()
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    return shared and shared:FindFirstChild("Remotes")
end

local function fireClient(player, remoteName, ...)
    local remotes = getRemotes()
    local remote = remotes and remotes:FindFirstChild(remoteName)
    if remote then
        remote:FireClient(player, ...)
    end
end

local function applyProduct(data, product)
    if product.Grant == "Currency" then
        if type(product.Currency) ~= "string" or type(product.Amount) ~= "number" then
            return false, "Invalid currency grant"
        end
        data.Currency = data.Currency or {}
        local definition = CurrencyRules.Definitions[product.Currency]
        local ok, nextBalance, reason =
            CurrencyRules.CanAdd(product.Currency, product.Amount, data.Currency[product.Currency], definition)
        if not ok then
            return false, reason
        end
        data.Currency[product.Currency] = nextBalance
        return true
    end

    if product.Grant == "HarvestBoost" then
        if
            type(product.BoostId) ~= "string"
            or type(product.DurationSeconds) ~= "number"
            or type(product.Multiplier) ~= "number"
        then
            return false, "Invalid boost grant"
        end

        data.Boosts = data.Boosts or {}
        local current = data.Boosts[product.BoostId]
        local currentExpiry = current and current.ExpiresAt or 0
        local currentMultiplier = current and current.Multiplier or 1
        data.Boosts[product.BoostId] = {
            ExpiresAt = math.max(os.time(), currentExpiry) + math.floor(product.DurationSeconds),
            Multiplier = math.min(1.25, math.max(currentMultiplier, product.Multiplier)),
        }
        return true
    end

    return false, "Unsupported product grant"
end

-- Capture the only profile fields a product can mutate. If persistence fails,
-- the in-memory mutation must be rolled back before Roblox retries the receipt;
-- otherwise a second attempt can observe a journaled purchase and acknowledge
-- it without a durable save.
local function snapshotProductGrant(data, product)
    if product.Grant == "Currency" and type(product.Currency) == "string" then
        local currency = data.Currency or {}
        return {
            Kind = "Currency",
            Key = product.Currency,
            Value = currency[product.Currency],
        }
    end

    if product.Grant == "HarvestBoost" and type(product.BoostId) == "string" then
        local boosts = data.Boosts or {}
        local current = boosts[product.BoostId]
        return {
            Kind = "HarvestBoost",
            Key = product.BoostId,
            Value = if type(current) == "table" then table.clone(current) else current,
        }
    end

    return nil
end

local function restoreProductGrant(data, snapshot)
    if not snapshot then
        return
    end

    if snapshot.Kind == "Currency" then
        data.Currency = data.Currency or {}
        data.Currency[snapshot.Key] = snapshot.Value
    elseif snapshot.Kind == "HarvestBoost" then
        data.Boosts = data.Boosts or {}
        data.Boosts[snapshot.Key] = snapshot.Value
    end
end

local function processReceipt(receiptInfo)
    if
        type(receiptInfo) ~= "table"
        or type(receiptInfo.PlayerId) ~= "number"
        or type(receiptInfo.ProductId) ~= "number"
        or type(receiptInfo.PurchaseId) ~= "string"
        or receiptInfo.PurchaseId == ""
    then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local purchaseId = receiptInfo.PurchaseId
    if processingReceipts[purchaseId] then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local product = Monetization.GetDeveloperProductById(receiptInfo.ProductId)
    if not product then
        warn("[MonetizationService] Unknown or disabled developer product: " .. tostring(receiptInfo.ProductId))
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    data.ProcessedReceipts = data.ProcessedReceipts or {}
    if ReceiptJournal.IsProcessed(data.ProcessedReceipts, purchaseId) then
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    processingReceipts[purchaseId] = true
    local grantApplied = false
    local grantSnapshot = snapshotProductGrant(data, product)
    local ok, err = pcall(function()
        if not ReceiptJournal.TryMark(data.ProcessedReceipts, purchaseId, os.time()) then
            error("Receipt journal refused a new purchase")
        end

        local granted, grantError = applyProduct(data, product)
        if not granted then
            data.ProcessedReceipts[purchaseId] = nil
            error(grantError or "Product grant failed")
        end
        grantApplied = true

        -- Acknowledge only after the profile save path accepts the grant. If
        -- saving fails, roll back both grant and journal so Roblox can safely
        -- retry the receipt.
        if not PlayerDataService.SaveNow(player) then
            restoreProductGrant(data, grantSnapshot)
            data.ProcessedReceipts[purchaseId] = nil
            grantApplied = false
            error("Profile save failed; receipt remains pending")
        end
    end)
    processingReceipts[purchaseId] = nil

    if not ok then
        if not grantApplied then
            data.ProcessedReceipts[purchaseId] = nil
        end
        warn("[MonetizationService] Receipt pending for " .. player.Name .. ": " .. tostring(err))
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    AnalyticsService:TrackEvent("purchase_granted", player.UserId, {
        ProductKey = product.Key,
        ProductId = receiptInfo.ProductId,
        PurchaseId = purchaseId,
    })
    fireClient(player, "MonetizationUpdated", "ProductGranted", product.Key)
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

function MonetizationService.Initialize()
    if initialized then
        return
    end
    initialized = true
    RobloxMarketplaceService.ProcessReceipt = processReceipt

    local remotes = getRemotes()
    local catalogRemote = remotes and remotes:FindFirstChild("GetMonetizationCatalog")
    if catalogRemote then
        catalogRemote.OnServerInvoke = function(_player)
            return {
                Environment = Monetization.Environment,
                GamePasses = Monetization.GetGamePasses(),
                DeveloperProducts = Monetization.GetDeveloperProducts(),
            }
        end
    end

    local entitlementsRemote = remotes and remotes:FindFirstChild("GetEntitlements")
    if entitlementsRemote then
        entitlementsRemote.OnServerInvoke = function(player)
            local data = PlayerDataService.GetData(player)
            return data and data.Entitlements or {}
        end
    end

    print(
        "[MonetizationService] Initialized (live product IDs configured: "
            .. tostring(#Monetization.GetGamePasses() + #Monetization.GetDeveloperProducts())
            .. ")"
    )
end

function MonetizationService.OnPlayerAdded(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return
    end
    data.Entitlements = data.Entitlements or {}

    for _, pass in pairs(Monetization.GamePasses) do
        if pass.Id > 0 then
            task.spawn(function()
                local ok, owned = pcall(function()
                    return RobloxMarketplaceService:UserOwnsGamePassAsync(player.UserId, pass.Id)
                end)
                if ok and owned then
                    local changed = data.Entitlements[pass.Key] ~= true
                    data.Entitlements[pass.Key] = true
                    if changed then
                        PlayerDataService.SaveNow(player)
                        fireClient(player, "MonetizationUpdated", "PassGranted", pass.Key)
                    end
                elseif not ok then
                    warn("[MonetizationService] Pass reconciliation failed for " .. player.Name)
                end
            end)
        end
    end
end

function MonetizationService.HasEntitlement(player, key)
    local data = PlayerDataService.GetData(player)
    return data ~= nil and data.Entitlements ~= nil and data.Entitlements[key] == true
end

function MonetizationService.GetHarvestMultiplier(player)
    local data = PlayerDataService.GetData(player)
    local boosts = data and data.Boosts
    local boost = boosts and boosts.harvest_comfort
    if not boost then
        return 1
    end
    if type(boost.ExpiresAt) ~= "number" or boost.ExpiresAt <= os.time() then
        boosts.harvest_comfort = nil
        return 1
    end
    return math.min(1.25, math.max(1, boost.Multiplier or 1))
end

return MonetizationService
