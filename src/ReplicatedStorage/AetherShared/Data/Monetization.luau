--!strict
-- Single source of truth for product descriptions and IDs.
-- IDs intentionally remain zero until a human owner creates and reviews the
-- matching products in Creator Hub. Zero IDs cannot trigger a live purchase.

local Monetization = {}

Monetization.Environment = "Development"

Monetization.GamePasses = {
    supporter = {
        Key = "supporter",
        Id = 0,
        Name = "Aether Patron",
        Description = "A permanent cosmetic supporter bundle and extra cosmetic loadout slot.",
        Grant = "CosmeticBundle",
    },
}

Monetization.DeveloperProducts = {
    shard_bundle_small = {
        Key = "shard_bundle_small",
        Id = 0,
        Name = "Aether Shards — Small",
        Description = "500 guaranteed Aether Shards for upgrades and crafting.",
        Grant = "Currency",
        Currency = "AetherShards",
        Amount = 500,
    },
    gem_bundle_small = {
        Key = "gem_bundle_small",
        Id = 0,
        Name = "Aether Gems — Small",
        Description = "25 guaranteed Aether Gems for the cosmetic shop.",
        Grant = "Currency",
        Currency = "AetherGems",
        Amount = 25,
    },
    harvest_comfort_15m = {
        Key = "harvest_comfort_15m",
        Id = 0,
        Name = "Harvest Comfort — 15 minutes",
        Description = "A capped 15-minute, 15% harvest-yield convenience boost.",
        Grant = "HarvestBoost",
        BoostId = "harvest_comfort",
        DurationSeconds = 900,
        Multiplier = 1.15,
    },
}

function Monetization.GetDeveloperProductById(productId: number)
    for _, product in pairs(Monetization.DeveloperProducts) do
        if product.Id == productId and product.Id > 0 then
            return product
        end
    end
    return nil
end

function Monetization.GetGamePasses()
    local result = {}
    for _, pass in pairs(Monetization.GamePasses) do
        if pass.Id > 0 then
            table.insert(result, {
                Key = pass.Key,
                Id = pass.Id,
                Name = pass.Name,
                Description = pass.Description,
            })
        end
    end
    return result
end

function Monetization.GetDeveloperProducts()
    local result = {}
    for _, product in pairs(Monetization.DeveloperProducts) do
        if product.Id > 0 then
            table.insert(result, {
                Key = product.Key,
                Id = product.Id,
                Name = product.Name,
                Description = product.Description,
                Grant = product.Grant,
            })
        end
    end
    return result
end

return Monetization
