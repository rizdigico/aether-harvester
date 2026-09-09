local PetFusionRules = require("../../src/ReplicatedStorage/AetherShared/Modules/PetFusionRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "PetFusionRules.Resolve",
        tests = {
            {
                name = "resolves duplicate parents independent of order",
                fn = function()
                    expectEqual(PetFusionRules.Resolve("cloud_sprite", "cloud_sprite"), "verdant_deer", "cloud recipe")
                    expectEqual(PetFusionRules.Resolve("verdant_deer", "cloud_sprite"), nil, "mixed recipe")
                    expectEqual(
                        PetFusionRules.Resolve("cloud_sprite", "cloud_sprite"),
                        PetFusionRules.Resolve("cloud_sprite", "cloud_sprite"),
                        "stable result"
                    )
                end,
            },
            {
                name = "rejects malformed or unknown parents",
                fn = function()
                    expectEqual(PetFusionRules.Resolve(nil, "cloud_sprite"), nil, "nil parent")
                    expectEqual(PetFusionRules.Resolve("missing", "missing"), nil, "unknown recipe")
                    expectEqual(
                        PetFusionRules.Resolve("aether_fox", "aether_fox"),
                        "ancient_dragon_pet",
                        "endgame recipe"
                    )
                end,
            },
        },
    },
    {
        name = "PetFusionRules.GetRecipes",
        tests = {
            {
                name = "returns a stable non-empty catalog",
                fn = function()
                    local recipes = PetFusionRules.GetRecipes()
                    assert(#recipes >= 5, "catalog should contain multiple deterministic recipes")
                    expectEqual(recipes[1].ParentA ~= "", true, "first parent")
                    expectEqual(recipes[1].Result ~= "", true, "first result")
                end,
            },
        },
    },
}
