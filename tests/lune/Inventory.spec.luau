--!strict
-- Pure-Luau spec for Modules/Inventory.luau runnable by Lune.
-- Tests: New, currency ops, slot structure, HasSpace, GetSize.
-- Note: AddItem/RemoveItem require a global Items.Get() mock.

-- Mock the Items global that Inventory depends on
_G.Items = {
    Get = function(name: string)
        -- Return a mock item definition
        return {
            name = name,
            stackable = true,
            maxStack = 99,
            properties = {
                durability = 100,
                weight = 1.0,
            },
        }
    end,
}

local Inventory = require("../../src/ReplicatedStorage/AetherShared/Modules/Inventory")

local function expectEqual(actual: any, expected: any, label: string)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)), 2)
    end
end

local function expectTrue(value: any, label: string)
    if not value then
        error(string.format("%s: expected truthy, got %s", label, tostring(value)), 2)
    end
end

local function expectFalse(value: any, label: string)
    if value then
        error(string.format("%s: expected falsy, got %s", label, tostring(value)), 2)
    end
end

return {
    -- ============================================================
    -- New()
    -- ============================================================
    {
        name = "Inventory.New",
        tests = {
            {
                name = "creates inventory with 30 slots",
                fn = function()
                    local inv = Inventory.New()
                    expectEqual(#inv.slots, 30, "slot count")
                end,
            },
            {
                name = "all slots are empty",
                fn = function()
                    local inv = Inventory.New()
                    for i, slot in ipairs(inv.slots) do
                        expectEqual(slot.itemName, nil, "slot " .. i .. " empty")
                        expectEqual(slot.quantity, 0, "slot " .. i .. " qty 0")
                    end
                end,
            },
            {
                name = "currency starts at 0",
                fn = function()
                    local inv = Inventory.New()
                    expectEqual(inv.currency.gold, 0, "gold")
                    expectEqual(inv.currency.aether, 0, "aether")
                end,
            },
            {
                name = "equipped items start nil",
                fn = function()
                    local inv = Inventory.New()
                    expectEqual(inv.equippedItems.weapon, nil, "weapon nil")
                    expectEqual(inv.equippedItems.armor, nil, "armor nil")
                    expectEqual(inv.equippedItems.tool, nil, "tool nil")
                end,
            },
        },
    },

    -- ============================================================
    -- GetSize / GetSlots / GetEquippedItems / GetCurrency
    -- ============================================================
    {
        name = "Inventory getters",
        tests = {
            {
                name = "GetSize returns 30",
                fn = function()
                    local inv = Inventory.New()
                    expectEqual(inv:GetSize(), 30, "size")
                end,
            },
            {
                name = "GetSlots returns slots table",
                fn = function()
                    local inv = Inventory.New()
                    local slots = inv:GetSlots()
                    expectEqual(#slots, 30, "GetSlots count")
                end,
            },
            {
                name = "GetEquippedItems returns table",
                fn = function()
                    local inv = Inventory.New()
                    local equipped = inv:GetEquippedItems()
                    expectTrue(type(equipped) == "table", "equipped is table")
                end,
            },
            {
                name = "GetCurrency returns currency",
                fn = function()
                    local inv = Inventory.New()
                    local currency = inv:GetCurrency()
                    expectEqual(currency.gold, 0, "currency gold")
                    expectEqual(currency.aether, 0, "currency aether")
                end,
            },
        },
    },

    -- ============================================================
    -- Currency ops
    -- ============================================================
    {
        name = "Inventory.AddCurrency",
        tests = {
            {
                name = "adds gold",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddCurrency("gold", 100)
                    expectEqual(inv.currency.gold, 100, "gold after add")
                end,
            },
            {
                name = "adds aether",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddCurrency("aether", 50)
                    expectEqual(inv.currency.aether, 50, "aether after add")
                end,
            },
            {
                name = "accumulates currency",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddCurrency("gold", 100)
                    inv:AddCurrency("gold", 50)
                    expectEqual(inv.currency.gold, 150, "gold accumulated")
                end,
            },
        },
    },
    {
        name = "Inventory.RemoveCurrency",
        tests = {
            {
                name = "removes gold when sufficient",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddCurrency("gold", 100)
                    local ok = inv:RemoveCurrency("gold", 60)
                    expectTrue(ok, "remove ok")
                    expectEqual(inv.currency.gold, 40, "gold after remove")
                end,
            },
            {
                name = "fails when insufficient gold",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddCurrency("gold", 10)
                    local ok = inv:RemoveCurrency("gold", 50)
                    expectFalse(ok, "remove fail")
                    expectEqual(inv.currency.gold, 10, "gold unchanged")
                end,
            },
            {
                name = "removes aether",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddCurrency("aether", 200)
                    local ok = inv:RemoveCurrency("aether", 200)
                    expectTrue(ok, "remove aether ok")
                    expectEqual(inv.currency.aether, 0, "aether zero")
                end,
            },
        },
    },

    -- ============================================================
    -- HasSpace
    -- ============================================================
    {
        name = "Inventory.HasSpace",
        tests = {
            {
                name = "has space in empty inventory",
                fn = function()
                    local inv = Inventory.New()
                    expectTrue(inv:HasSpace("TestItem", 1), "has space")
                end,
            },
        },
    },

    -- ============================================================
    -- GetItemCount
    -- ============================================================
    {
        name = "Inventory.GetItemCount",
        tests = {
            {
                name = "returns 0 for empty inventory",
                fn = function()
                    local inv = Inventory.New()
                    expectEqual(inv:GetItemCount("TestItem"), 0, "count empty")
                end,
            },
        },
    },

    -- ============================================================
    -- AddItem / RemoveItem (with mocked Items)
    -- ============================================================
    {
        name = "Inventory.AddItem",
        tests = {
            {
                name = "adds item to first empty slot",
                fn = function()
                    local inv = Inventory.New()
                    local ok = inv:AddItem("Wood", 5)
                    expectTrue(ok, "add ok")
                    expectEqual(inv.slots[1].itemName, "Wood", "slot 1 item")
                    expectEqual(inv.slots[1].quantity, 5, "slot 1 qty")
                end,
            },
            {
                name = "stacks on existing slot",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddItem("Wood", 5)
                    inv:AddItem("Wood", 3)
                    -- Should stack into slot 1
                    expectEqual(inv.slots[1].quantity, 8, "stacked qty")
                end,
            },
            {
                name = "respects maxStack",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddItem("Wood", 99)
                    inv:AddItem("Wood", 10)
                    -- maxStack is 99, so slot 1 capped at 99, overflow in slot 2
                    expectEqual(inv.slots[1].quantity, 99, "capped at maxStack")
                    expectEqual(inv.slots[2].quantity, 10, "overflow in slot 2")
                end,
            },
        },
    },
    {
        name = "Inventory.RemoveItem",
        tests = {
            {
                name = "reduces stack quantity",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddItem("Wood", 10)
                    local ok = inv:RemoveItem("Wood", 3)
                    expectTrue(ok, "remove ok")
                    expectEqual(inv.slots[1].quantity, 7, "reduced qty")
                end,
            },
            {
                name = "clears slot when removing all",
                fn = function()
                    local inv = Inventory.New()
                    inv:AddItem("Wood", 5)
                    local ok = inv:RemoveItem("Wood", 5)
                    expectTrue(ok, "remove all ok")
                    expectEqual(inv.slots[1].itemName, nil, "slot cleared")
                    expectEqual(inv.slots[1].quantity, 0, "qty zeroed")
                end,
            },
            {
                name = "returns false for missing item",
                fn = function()
                    local inv = Inventory.New()
                    local ok = inv:RemoveItem("NonExistent", 1)
                    expectFalse(ok, "missing item")
                end,
            },
        },
    },
}
