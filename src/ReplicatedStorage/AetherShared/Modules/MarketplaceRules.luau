--!strict
-- Pure marketplace rules shared by the server and offline tests.

local MarketplaceRules = {}

MarketplaceRules.MAX_AMOUNT = 9999
MarketplaceRules.MAX_PRICE = 1000000
MarketplaceRules.MAX_SELLER_NAME_LENGTH = 64
MarketplaceRules.MAX_PROCESSING_SECONDS = 120

local function isFiniteNumber(value: any): boolean
    return type(value) == "number" and value == value and value < math.huge and value > -math.huge
end

function MarketplaceRules.IsValidUserId(value: any): boolean
    return isFiniteNumber(value) and value > 0 and value == math.floor(value)
end

function MarketplaceRules.IsValidListingId(value: any): boolean
    return type(value) == "string" and #value >= 9 and #value <= 80 and value:match("^LISTING_[%w_-]+$") ~= nil
end

function MarketplaceRules.IsValidAmount(value: any): boolean
    return isFiniteNumber(value) and value >= 1 and value <= MarketplaceRules.MAX_AMOUNT and value == math.floor(value)
end

function MarketplaceRules.IsValidPrice(value: any): boolean
    return isFiniteNumber(value) and value >= 1 and value <= MarketplaceRules.MAX_PRICE and value == math.floor(value)
end

function MarketplaceRules.NormalizeListing(rawListing: any, listingId: any, now: any): { [string]: any }?
    if type(rawListing) ~= "table" or not MarketplaceRules.IsValidListingId(listingId) then
        return nil
    end
    if not MarketplaceRules.IsValidUserId(rawListing.SellerId) then
        return nil
    end
    if type(rawListing.SellerName) ~= "string" or rawListing.SellerName == "" then
        return nil
    end
    if type(rawListing.ItemId) ~= "string" or rawListing.ItemId == "" then
        return nil
    end
    if not MarketplaceRules.IsValidAmount(rawListing.Amount) or not MarketplaceRules.IsValidPrice(rawListing.Price) then
        return nil
    end

    local status = rawListing.Status
    if status ~= "Active" and status ~= "Processing" then
        return nil
    end

    local createdAt = isFiniteNumber(rawListing.CreatedAt) and math.max(0, math.floor(rawListing.CreatedAt)) or 0
    local normalized = {
        Id = listingId,
        SellerId = math.floor(rawListing.SellerId),
        SellerName = rawListing.SellerName:sub(1, MarketplaceRules.MAX_SELLER_NAME_LENGTH),
        ItemId = rawListing.ItemId,
        Amount = math.floor(rawListing.Amount),
        Price = math.floor(rawListing.Price),
        Status = status,
        CreatedAt = createdAt,
    }

    if status == "Processing" then
        local processingBy = rawListing.ProcessingBy
        local processingAt = rawListing.ProcessingAt
        if
            not MarketplaceRules.IsValidUserId(processingBy)
            or not isFiniteNumber(processingAt)
            or type(now) ~= "number"
            or processingAt + MarketplaceRules.MAX_PROCESSING_SECONDS <= now
        then
            normalized.Status = "Active"
        else
            normalized.ProcessingBy = math.floor(processingBy)
            normalized.ProcessingAt = math.floor(processingAt)
        end
    end

    return normalized
end

return MarketplaceRules
