--
-- Inventory.luau
-- Inventory management module for Aether Harvester Simulator
--

local Inventory = {}

-- Items data module is provided as a global in the game's boot chain;
-- resolve through _G so the module works under Lune tests too.
local function getItemDef(itemName)
    local Items = _G.Items
    if Items and Items.Get then
        return Items.Get(itemName)
    end
    return nil
end

-- Constants
local INVENTORY_SIZE = 30
local MAX_STACK_SIZE = 999
local INVENTORY_SLOT_WIDTH = 64
local INVENTORY_SLOT_HEIGHT = 64

--[[
    INVENTORY STRUCTURE:
    {
        slots = {
            {
                itemName = "ItemName",
                quantity = 1,
                durability = 100,
                properties = {
                    -- Item properties
                }
            },
            -- Empty slots
            {
                itemName = nil,
                quantity = 0
            }
        },
        currency = {
            gold = 0,
            aether = 0
        },
        equippedItems = {
            weapon = nil,
            armor = nil,
            tool = nil
        }
    }
]]

-- Initialize a new inventory
function Inventory.New()
    local inventory = {
        slots = {},
        currency = {
            gold = 0,
            aether = 0,
        },
        equippedItems = {
            weapon = nil,
            armor = nil,
            tool = nil,
        },
    }

    -- Fill inventory with empty slots
    for i = 1, INVENTORY_SIZE do
        table.insert(inventory.slots, {
            itemName = nil,
            quantity = 0,
            durability = nil,
        })
    end

    -- Instance methods resolve through the module (Inventory:AddItem etc.)
    setmetatable(inventory, { __index = Inventory })

    return inventory
end

-- Add an item to the inventory
function Inventory:AddItem(itemName, quantity, properties)
    local item = getItemDef(itemName)
    if not item then
        warn(string.format("Item %s not found.", itemName))
        return false
    end

    -- Check if item is stackable
    if item.stackable then
        local stackSlot = nil
        for i, slot in ipairs(self.slots) do
            if slot.itemName == itemName and slot.quantity < item.maxStack then
                stackSlot = i
                break
            end
        end

        if stackSlot then
            -- Add to existing stack
            self.slots[stackSlot].quantity = math.min(self.slots[stackSlot].quantity + quantity, item.maxStack)
            return true
        else
            -- Find first empty slot
            for i, slot in ipairs(self.slots) do
                if slot.itemName == nil then
                    self.slots[i] = {
                        itemName = itemName,
                        quantity = math.min(quantity, item.maxStack),
                        durability = properties and properties.durability or item.properties.durability,
                        properties = properties,
                    }
                    return true
                end
            end
        end
    else
        -- Find first empty slot
        for i, slot in ipairs(self.slots) do
            if slot.itemName == nil then
                self.slots[i] = {
                    itemName = itemName,
                    quantity = quantity,
                    durability = properties and properties.durability or item.properties.durability,
                    properties = properties,
                }
                return true
            end
        end
    end

    return false, "Inventory is full."
end

-- Remove an item from the inventory
function Inventory:RemoveItem(itemName, quantity)
    local item = getItemDef(itemName)
    if not item then
        warn(string.format("Item %s not found.", itemName))
        return false
    end

    -- Check if item is stackable
    if item.stackable then
        for i, slot in ipairs(self.slots) do
            if slot.itemName == itemName then
                if slot.quantity <= quantity then
                    -- Remove entire stack
                    self.slots[i] = {
                        itemName = nil,
                        quantity = 0,
                    }
                else
                    -- Reduce stack
                    self.slots[i].quantity = slot.quantity - quantity
                end
                return true
            end
        end
    else
        -- Find and remove first occurrence
        for i, slot in ipairs(self.slots) do
            if slot.itemName == itemName then
                self.slots[i] = {
                    itemName = nil,
                    quantity = 0,
                }
                return true
            end
        end
    end

    return false, "Item not found in inventory."
end

-- Use an item from the inventory
function Inventory:UseItem(itemName, player)
    local item = getItemDef(itemName)
    if not item then
        warn(string.format("Item %s not found.", itemName))
        return false
    end

    -- Find the item in inventory
    for i, slot in ipairs(self.slots) do
        if slot.itemName == itemName then
            -- Check if item is consumable
            if item.type == Enum.ItemType.Consumable then
                -- Execute ability if it exists
                if item.abilities and #item.abilities > 0 then
                    for _, ability in ipairs(item.abilities) do
                        if ability.effect then
                            ability.effect(player, slot)
                        end
                    end
                end

                -- Remove one use
                if slot.quantity > 1 then
                    slot.quantity = slot.quantity - 1
                else
                    -- Remove the item
                    self.slots[i] = {
                        itemName = nil,
                        quantity = 0,
                    }
                end
                return true
            end
            return false, "Item is not consumable."
        end
    end

    return false, "Item not found in inventory."
end

-- Equip an item
function Inventory:EquipItem(itemName, slotType)
    local item = getItemDef(itemName)
    if not item then
        warn(string.format("Item %s not found.", itemName))
        return false
    end

    -- Check if item can be equipped
    if not item.equippable then
        return false, "Item is not equippable."
    end

    -- Find the item in inventory
    for i, slot in ipairs(self.slots) do
        if slot.itemName == itemName then
            -- Unequip previous item if needed
            if self.equippedItems[slotType] then
                local previousItem = getItemDef(self.equippedItems[slotType])
                if previousItem and previousItem.equippable then
                    -- Return previous item to inventory
                    self:AddItem(self.equippedItems[slotType], 1)
                end
            end

            -- Equip new item
            self.equippedItems[slotType] = itemName
            return true
        end
    end

    return false, "Item not found in inventory."
end

-- Unequip an item
function Inventory:UnequipItem(slotType)
    if not self.equippedItems[slotType] then
        return false, "No item equipped in this slot."
    end

    local itemName = self.equippedItems[slotType]
    local item = getItemDef(itemName)
    if not item then
        warn(string.format("Item %s not found.", itemName))
        return false
    end

    -- Add item back to inventory
    self:AddItem(itemName, 1)
    self.equippedItems[slotType] = nil
    return true
end

-- Check if inventory has enough space for an item
function Inventory:HasSpace(itemName, quantity)
    local item = getItemDef(itemName)
    if not item then
        warn(string.format("Item %s not found.", itemName))
        return false
    end

    local totalSpace = INVENTORY_SIZE
    local usedSpace = 0

    -- Calculate used space
    for _, slot in ipairs(self.slots) do
        if slot.itemName then
            usedSpace = usedSpace + 1
        end
    end

    -- If item is stackable, check if we have space for the quantity
    if item.stackable then
        local stackSlot = nil
        for i, slot in ipairs(self.slots) do
            if slot.itemName == itemName then
                stackSlot = i
                break
            end
        end

        if stackSlot then
            -- Check if we can add to existing stack
            if self.slots[stackSlot].quantity + quantity <= item.maxStack then
                return true
            end
        end
    end

    return usedSpace < INVENTORY_SIZE
end

-- Get inventory size
function Inventory:GetSize()
    return INVENTORY_SIZE
end

-- Get inventory slots
function Inventory:GetSlots()
    return self.slots
end

-- Get equipped items
function Inventory:GetEquippedItems()
    return self.equippedItems
end

-- Get currency
function Inventory:GetCurrency()
    return self.currency
end

-- Add currency
function Inventory:AddCurrency(currencyType, amount)
    if currencyType == "gold" then
        self.currency.gold = self.currency.gold + amount
    elseif currencyType == "aether" then
        self.currency.aether = self.currency.aether + amount
    end
end

-- Remove currency
function Inventory:RemoveCurrency(currencyType, amount)
    if currencyType == "gold" then
        if self.currency.gold >= amount then
            self.currency.gold = self.currency.gold - amount
            return true
        end
    elseif currencyType == "aether" then
        if self.currency.aether >= amount then
            self.currency.aether = self.currency.aether - amount
            return true
        end
    end
    return false, "Insufficient currency."
end

-- Get item count
function Inventory:GetItemCount(itemName)
    local item = getItemDef(itemName)
    if not item then
        warn(string.format("Item %s not found.", itemName))
        return 0
    end

    local count = 0
    for _, slot in ipairs(self.slots) do
        if slot.itemName == itemName then
            count = count + slot.quantity
        end
    end
    return count
end

-- Get total weight
function Inventory:GetTotalWeight()
    local totalWeight = 0
    for _, slot in ipairs(self.slots) do
        if slot.itemName then
            local item = getItemDef(slot.itemName)
            if item then
                local weight = slot.properties and slot.properties.weight or item.properties.weight
                totalWeight = totalWeight + (slot.quantity * weight)
            end
        end
    end
    return totalWeight
end

return Inventory
