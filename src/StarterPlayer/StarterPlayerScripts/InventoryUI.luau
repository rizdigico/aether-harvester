--
-- InventoryUI.luau
-- Handles inventory grid, drag-and-drop functionality, and item tooltips
--

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Constants
local INVENTORY_SIZE = 20 -- Number of slots in inventory
local SLOT_SIZE = UDim2.new(0, 50, 0, 50)
local SLOT_SPACING = UDim2.new(0, 10, 0, 10)

-- Create inventory frame
local InventoryFrame = Instance.new("ScreenGui")
InventoryFrame.Name = "InventoryFrame"
InventoryFrame.Parent = PlayerGui

-- Create inventory container
local InventoryContainer = Instance.new("Frame")
InventoryContainer.Name = "InventoryContainer"
InventoryContainer.Size = UDim2.new(0, 300, 0, 300)
InventoryContainer.Position = UDim2.new(0.5, -150, 0.5, -150)
InventoryContainer.BackgroundTransparency = 1
InventoryContainer.Parent = InventoryFrame

-- Create inventory grid
local InventoryGrid = Instance.new("Frame")
InventoryGrid.Name = "InventoryGrid"
InventoryGrid.Size = UDim2.new(1, 0, 1, 0)
InventoryGrid.BackgroundTransparency = 1
InventoryGrid.Parent = InventoryContainer

-- Create inventory slots
local InventorySlots = {}
for i = 1, INVENTORY_SIZE do
    local slot = Instance.new("ImageButton")
    slot.Name = "Slot" .. i
    slot.Size = SLOT_SIZE
    slot.Position = UDim2.new(
        math.floor((i - 1) % 5) * (SLOT_SIZE.X.Offset + SLOT_SPACING.X.Offset),
        math.floor((i - 1) / 5) * (SLOT_SIZE.Y.Offset + SLOT_SPACING.Y.Offset),
        0,
        0
    )
    slot.BackgroundTransparency = 1
    slot.BorderSizePixel = 0
    slot.Parent = InventoryGrid

    -- Create item label for each slot
    local itemLabel = Instance.new("TextLabel")
    itemLabel.Name = "ItemLabel"
    itemLabel.Size = UDim2.new(1, 0, 1, 0)
    itemLabel.Position = UDim2.new(0, 0, 0, 0)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Text = ""
    itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemLabel.TextSize = 14
    itemLabel.Font = Enum.Font.Gotham
    itemLabel.Parent = slot

    -- Create item icon placeholder
    local itemIcon = Instance.new("ImageLabel")
    itemIcon.Name = "ItemIcon"
    itemIcon.Size = UDim2.new(1, 0, 1, 0)
    itemIcon.Position = UDim2.new(0, 0, 0, 0)
    itemIcon.BackgroundTransparency = 1
    itemIcon.Parent = slot

    -- Store references
    InventorySlots[i] = {
        slot = slot,
        itemLabel = itemLabel,
        itemIcon = itemIcon,
        item = nil,
    }
end

-- Create tooltip frame
local TooltipFrame = Instance.new("ScreenGui")
TooltipFrame.Name = "TooltipFrame"
TooltipFrame.Parent = PlayerGui

local TooltipContainer = Instance.new("Frame")
TooltipContainer.Name = "TooltipContainer"
TooltipContainer.Size = UDim2.new(0, 200, 0, 100)
TooltipContainer.Position = UDim2.new(0, 0, 0, 0)
TooltipContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TooltipContainer.BackgroundTransparency = 0.8
TooltipContainer.BorderSizePixel = 2
TooltipContainer.BorderColor3 = Color3.fromRGB(100, 100, 100)
TooltipContainer.Visible = false
TooltipContainer.Parent = TooltipFrame

local TooltipTitleLabel = Instance.new("TextLabel")
TooltipTitleLabel.Name = "TooltipTitleLabel"
TooltipTitleLabel.Size = UDim2.new(1, 0, 0, 25)
TooltipTitleLabel.Position = UDim2.new(0, 0, 0, 0)
TooltipTitleLabel.BackgroundTransparency = 1
TooltipTitleLabel.Text = ""
TooltipTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TooltipTitleLabel.TextSize = 16
TooltipTitleLabel.Font = Enum.Font.GothamBold
TooltipTitleLabel.Parent = TooltipContainer

local TooltipDescriptionLabel = Instance.new("TextLabel")
TooltipDescriptionLabel.Name = "TooltipDescriptionLabel"
TooltipDescriptionLabel.Size = UDim2.new(1, 0, 0, 75)
TooltipDescriptionLabel.Position = UDim2.new(0, 0, 0, 30)
TooltipDescriptionLabel.BackgroundTransparency = 1
TooltipDescriptionLabel.Text = ""
TooltipDescriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TooltipDescriptionLabel.TextSize = 14
TooltipDescriptionLabel.Font = Enum.Font.Gotham
TooltipDescriptionLabel.Parent = TooltipContainer

-- Function to update inventory slots
local function updateInventorySlots(inventory: table)
    for i, slotData in pairs(InventorySlots) do
        local item = inventory[i]
        if item then
            slotData.itemLabel.Text = item.name
            slotData.itemIcon.Image = "rbxassetid://" .. item.iconId
            slotData.item = item
        else
            slotData.itemLabel.Text = ""
            slotData.itemIcon.Image = ""
            slotData.item = nil
        end
    end
end

-- Function to show tooltip
local function showTooltip(item: table, x: number, y: number)
    if not item then
        TooltipContainer.Visible = false
        return
    end

    TooltipTitleLabel.Text = item.name
    TooltipDescriptionLabel.Text = item.description
    TooltipContainer.Position = UDim2.new(0, x, 0, y)
    TooltipContainer.Visible = true
end

-- Function to hide tooltip
local function hideTooltip()
    TooltipContainer.Visible = false
end

-- Function to handle slot click
local function handleSlotClick(slot: number)
    local slotData = InventorySlots[slot]
    if slotData.item then
        -- Broadcast item selection to server
        game:GetService("ReplicatedStorage"):FindFirstChild("InventoryEvent"):FireServer("use_item", slotData.item)
    end
end

-- Function to handle drag start
local function handleDragStart(slot: number)
    local slotData = InventorySlots[slot]
    if slotData.item then
        slotData.slot.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        slotData.slot:Connect(function()
            -- Handle drag end
            slotData.slot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end
end

-- Function to handle drag over
local function handleDragOver(slot: number)
    local slotData = InventorySlots[slot]
    if slotData.item then
        slotData.slot.BackgroundColor3 = Color3.fromRGB(150, 150, 255)
    end
end

-- Function to handle drag leave
local function handleDragLeave(slot: number)
    local slotData = InventorySlots[slot]
    slotData.slot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end

-- Function to handle drag end
local function handleDragEnd(slot: number)
    local slotData = InventorySlots[slot]
    slotData.slot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end

-- Connect slot clicks
for i, slotData in pairs(InventorySlots) do
    slotData.slot.MouseButton1Click:Connect(function()
        handleSlotClick(i)
    end)

    slotData.slot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleDragStart(i)
        end
    end)

    slotData.slot.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            handleDragOver(i)
        end
    end)

    slotData.slot.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            handleDragLeave(i)
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleDragEnd(i)
        end
    end)
end

-- Connect to remote events
local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("InventoryEvent")
if remoteEvents then
    remoteEvents.OnClientEvent:Connect(function(action, ...)
        if action == "update_inventory" then
            local inventory = ...
            updateInventorySlots(inventory)
        end
    end)
end

-- Connect mouse move for tooltips
game:GetService("UserInputService"):Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = game:GetService("Players"):GetPlayerFromCharacter(game.Players.LocalPlayer.Character).GetMouse()
        local mouseX, mouseY = mouse.X, mouse.Y

        -- Check if mouse is over any slot
        for i, slotData in pairs(InventorySlots) do
            local slotPos = slotData.slot.AbsolutePosition
            local slotSize = slotData.slot.AbsoluteSize

            if
                mouseX >= slotPos.X
                and mouseX <= slotPos.X + slotSize.X
                and mouseY >= slotPos.Y
                and mouseY <= slotPos.Y + slotSize.Y
            then
                showTooltip(slotData.item, mouseX, mouseY)
                return
            end
        end

        hideTooltip()
    end
end)

-- Initialize inventory
local function initializeInventory()
    updateInventorySlots({})
end

-- Initialize inventory
initializeInventory()
