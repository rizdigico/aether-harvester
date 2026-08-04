local Pets = {}

Pets.Database = {
    ["aether_spirit_pet"] = {
        Id = "aether_spirit_pet",
        Name = "Aether Spirit",
        Description = "A tiny companion spirit that aids in harvesting",
        Rarity = "Common",
        Class = "Harvester",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = {
            HarvestPower = 5,
            Speed = 3,
            Luck = 2,
            Defense = 1,
        },
        Abilities = {
            { Name = "Spark", Type = "Passive", Description = "+5% harvesting speed", Cooldown = 0 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["crystal_golem_pet"] = {
        Id = "crystal_golem_pet",
        Name = "Crystal Golem",
        Description = "A sturdy crystal companion that boosts resource yield",
        Rarity = "Rare",
        Class = "Harvester",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = {
            HarvestPower = 15,
            Speed = 2,
            Luck = 5,
            Defense = 10,
        },
        Abilities = {
            { Name = "Crystal Boost", Type = "Passive", Description = "+10% rare drop chance", Cooldown = 0 },
            { Name = "Crystal Shield", Type = "Active", Description = "+20% defense for 10s", Cooldown = 30 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["void_tentacle_pet"] = {
        Id = "void_tentacle_pet",
        Name = "Void Tentacle",
        Description = "A mysterious tentacle from the Void Rifts",
        Rarity = "Epic",
        Class = "Combat",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = {
            HarvestPower = 10,
            Speed = 8,
            Luck = 8,
            Defense = 5,
        },
        Abilities = {
            { Name = "Void Pull", Type = "Active", Description = "Pulls resources toward you", Cooldown = 15 },
            { Name = "Dark Vision", Type = "Passive", Description = "Reveals hidden resources", Cooldown = 0 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["fire_sprite_pet"] = {
        Id = "fire_sprite_pet",
        Name = "Fire Sprite",
        Description = "A playful flame spirit that speeds up smelting",
        Rarity = "Uncommon",
        Class = "Support",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = {
            HarvestPower = 8,
            Speed = 5,
            Luck = 3,
            Defense = 2,
        },
        Abilities = {
            { Name = "Heat Aura", Type = "Passive", Description = "+10% smelting speed", Cooldown = 0 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["storm_elemental_pet"] = {
        Id = "storm_elemental_pet",
        Name = "Storm Elemental",
        Description = "A powerful lightning being that grants flight",
        Rarity = "Epic",
        Class = "Mount",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = {
            HarvestPower = 12,
            Speed = 15,
            Luck = 10,
            Defense = 8,
        },
        Abilities = {
            { Name = "Flight", Type = "Active", Description = "Allows flying for 30s", Cooldown = 60 },
            { Name = "Lightning Boost", Type = "Passive", Description = "+15% movement speed", Cooldown = 0 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["ancient_dragon_pet"] = {
        Id = "ancient_dragon_pet",
        Name = "Ancient Dragon",
        Description = "A legendary dragon companion with immense power",
        Rarity = "Legendary",
        Class = "Combat",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = {
            HarvestPower = 25,
            Speed = 10,
            Luck = 15,
            Defense = 20,
        },
        Abilities = {
            { Name = "Dragon Breath", Type = "Active", Description = "Deals massive AoE damage", Cooldown = 45 },
            { Name = "Aura", Type = "Passive", Description = "+20% all stats to nearby allies", Cooldown = 0 },
            { Name = "Flight", Type = "Active", Description = "Allows flying for 60s", Cooldown = 90 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["cloud_sprite"] = {
        Id = "cloud_sprite",
        Name = "Cloud Sprite",
        Description = "A tiny spirit of the clouds",
        Rarity = "Common",
        Class = "Harvester",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = { HarvestPower = 5, Speed = 3, Luck = 2, Defense = 1 },
        Abilities = { { Name = "Spark", Type = "Passive", Description = "+5% harvesting speed", Cooldown = 0 } },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["verdant_deer"] = {
        Id = "verdant_deer",
        Name = "Verdant Deer",
        Description = "A gentle forest deer companion",
        Rarity = "Uncommon",
        Class = "Harvester",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = { HarvestPower = 7, Speed = 5, Luck = 4, Defense = 3 },
        Abilities = { { Name = "Forest Aura", Type = "Passive", Description = "+8% harvest yield", Cooldown = 0 } },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["storm_hawk"] = {
        Id = "storm_hawk",
        Name = "Storm Hawk",
        Description = "A hawk that rides the thunder",
        Rarity = "Uncommon",
        Class = "Combat",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = { HarvestPower = 10, Speed = 8, Luck = 3, Defense = 4 },
        Abilities = {
            { Name = "Thunder Dive", Type = "Active", Description = "Deals damage and stuns", Cooldown = 20 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["crystal_fox"] = {
        Id = "crystal_fox",
        Name = "Crystal Fox",
        Description = "A fox with fur that glitters like crystal",
        Rarity = "Rare",
        Class = "Harvester",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = { HarvestPower = 12, Speed = 6, Luck = 6, Defense = 5 },
        Abilities = {
            { Name = "Crystal Glint", Type = "Passive", Description = "+12% rare drop chance", Cooldown = 0 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["shadow_wolf"] = {
        Id = "shadow_wolf",
        Name = "Shadow Wolf",
        Description = "A loyal wolf born from shadow",
        Rarity = "Rare",
        Class = "Combat",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = { HarvestPower = 15, Speed = 10, Luck = 5, Defense = 8 },
        Abilities = { { Name = "Shadow Bite", Type = "Active", Description = "Deals heavy damage", Cooldown = 15 } },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
    ["aether_fox"] = {
        Id = "aether_fox",
        Name = "Aether Fox",
        Description = "A rare fox infused with pure aether",
        Rarity = "Epic",
        Class = "Combat",
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Hunger = 100,
        Happiness = 100,
        Energy = 100,
        Stats = { HarvestPower = 20, Speed = 12, Luck = 10, Defense = 10 },
        Abilities = {
            { Name = "Aether Storm", Type = "Active", Description = "Deals massive AoE damage", Cooldown = 40 },
        },
        Icon = "rbxassetid://0",
        ModelAsset = "",
    },
}

function Pets.GetPet(petId)
    return Pets.Database[petId]
end

function Pets.GetAllPets()
    return Pets.Database
end

function Pets.GetPetsByRarity(rarity)
    local results = {}
    for _, pet in pairs(Pets.Database) do
        if pet.Rarity == rarity then
            table.insert(results, pet)
        end
    end
    return results
end

function Pets.GetPetsByClass(classType)
    local results = {}
    for _, pet in pairs(Pets.Database) do
        if pet.Class == classType then
            table.insert(results, pet)
        end
    end
    return results
end

function Pets.CalculateXPRequired(level)
    return math.floor(100 * math.pow(1.5, level - 1))
end

function Pets.AddXP(petId, amount)
    local pet = Pets.Database[petId]
    if not pet then
        return false
    end

    pet.XP += amount
    while pet.XP >= pet.XPToNextLevel do
        pet.XP -= pet.XPToNextLevel
        pet.Level += 1
        pet.XPToNextLevel = Pets.CalculateXPRequired(pet.Level)
        pet.Stats.HarvestPower = math.floor(pet.Stats.HarvestPower * 1.1)
        pet.Stats.Speed = math.floor(pet.Stats.Speed * 1.05)
        print("[Pets] " .. pet.Name .. " leveled up to " .. pet.Level)
    end

    return true
end

function Pets.FeedPet(petId)
    local pet = Pets.Database[petId]
    if not pet then
        return false
    end

    if pet.Hunger >= 100 then
        return false, "Pet is not hungry"
    end

    pet.Hunger = math.min(100, pet.Hunger + 30)
    pet.Happiness = math.min(100, pet.Happiness + 10)
    return true, "Pet fed"
end

function Pets.PlayWithPet(petId)
    local pet = Pets.Database[petId]
    if not pet then
        return false
    end

    if pet.Energy < 10 then
        return false, "Pet is too tired"
    end

    pet.Happiness = math.min(100, pet.Happiness + 20)
    pet.Energy -= 10
    return true, "Pet played with"
end

function Pets.RestPet(petId)
    local pet = Pets.Database[petId]
    if not pet then
        return false
    end

    pet.Energy = math.min(100, pet.Energy + 50)
    pet.Happiness = math.max(0, pet.Happiness - 5)
    return true, "Pet rested"
end

return Pets
