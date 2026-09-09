local MarketplaceRules = require("../../src/ReplicatedStorage/AetherShared/Modules/MarketplaceRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "MarketplaceRules.IsValidListingId",
        tests = {
            {
                name = "accepts bounded listing identifiers",
                fn = function()
                    expectEqual(MarketplaceRules.IsValidListingId("LISTING_42_100_1"), true, "valid id")
                    expectEqual(MarketplaceRules.IsValidListingId("LISTING_"), false, "empty suffix")
                    expectEqual(MarketplaceRules.IsValidListingId("bad"), false, "wrong prefix")
                end,
            },
        },
    },
    {
        name = "MarketplaceRules.NormalizeListing",
        tests = {
            {
                name = "normalizes active listings and clamps seller names",
                fn = function()
                    local listing = MarketplaceRules.NormalizeListing({
                        SellerId = 7,
                        SellerName = string.rep("x", 80),
                        ItemId = "aether_shard",
                        Amount = 3,
                        Price = 40,
                        Status = "Active",
                        CreatedAt = 12.9,
                    }, "LISTING_7_12_1", 20)
                    assert(listing ~= nil, "listing should normalize")
                    expectEqual(listing.Id, "LISTING_7_12_1", "canonical id")
                    expectEqual(listing.Amount, 3, "amount floor")
                    expectEqual(listing.Price, 40, "price floor")
                    expectEqual(#listing.SellerName, MarketplaceRules.MAX_SELLER_NAME_LENGTH, "seller name cap")
                end,
            },
            {
                name = "releases stale processing claims",
                fn = function()
                    local listing = MarketplaceRules.NormalizeListing({
                        SellerId = 7,
                        SellerName = "Seller",
                        ItemId = "aether_shard",
                        Amount = 1,
                        Price = 10,
                        Status = "Processing",
                        ProcessingBy = 8,
                        ProcessingAt = 100,
                    }, "LISTING_7_100_1", 100 + MarketplaceRules.MAX_PROCESSING_SECONDS)
                    assert(listing ~= nil, "listing should normalize")
                    expectEqual(listing.Status, "Active", "stale claim released")
                    expectEqual(listing.ProcessingBy, nil, "claim owner cleared")
                end,
            },
        },
    },
}
