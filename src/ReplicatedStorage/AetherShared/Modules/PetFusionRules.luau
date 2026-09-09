--!strict
-- Deterministic, free-to-play pet fusion recipes.

local PetFusionRules = {}

local RECIPES = {
    ["aether_fox|aether_fox"] = "ancient_dragon_pet",
    ["aether_spirit_pet|aether_spirit_pet"] = "crystal_golem_pet",
    ["cloud_sprite|cloud_sprite"] = "verdant_deer",
    ["crystal_fox|crystal_fox"] = "aether_fox",
    ["crystal_golem_pet|crystal_golem_pet"] = "void_tentacle_pet",
    ["fire_sprite_pet|fire_sprite_pet"] = "storm_elemental_pet",
    ["shadow_wolf|shadow_wolf"] = "aether_fox",
    ["storm_hawk|storm_hawk"] = "storm_elemental_pet",
    ["verdant_deer|verdant_deer"] = "crystal_fox",
    ["void_tentacle_pet|void_tentacle_pet"] = "ancient_dragon_pet",
}

local function pairKey(first: any, second: any): string?
    if type(first) ~= "string" or type(second) ~= "string" or first == "" or second == "" then
        return nil
    end
    if first > second then
        first, second = second, first
    end
    return first .. "|" .. second
end

function PetFusionRules.Resolve(first: any, second: any): string?
    local key = pairKey(first, second)
    return key and RECIPES[key] or nil
end

function PetFusionRules.GetRecipes(): { [number]: { ParentA: string, ParentB: string, Result: string } }
    local recipes = {}
    for key, result in pairs(RECIPES) do
        local parentA, parentB = string.match(key, "^([^|]+)|(.+)$")
        if parentA and parentB then
            table.insert(recipes, { ParentA = parentA, ParentB = parentB, Result = result })
        end
    end
    table.sort(recipes, function(left, right)
        return left.ParentA .. left.ParentB < right.ParentA .. right.ParentB
    end)
    return recipes
end

return PetFusionRules
