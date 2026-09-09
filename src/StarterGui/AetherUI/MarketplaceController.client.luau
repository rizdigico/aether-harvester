--!strict
-- Floating Market: a player-facing surface for the server-authoritative item market.
-- Prices, ownership, escrow, and settlement are always decided by the server.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local itemsData = require(shared:WaitForChild("Data"):WaitForChild("Items"))
local toast = require(script.Parent.Components.Toast)

local COLORS = {
    Background = Color3.fromRGB(13, 27, 42),
    Panel = Color3.fromRGB(28, 32, 48),
    Raised = Color3.fromRGB(38, 42, 62),
    Field = Color3.fromRGB(20, 24, 38),
    Text = Color3.fromRGB(230, 235, 245),
    Muted = Color3.fromRGB(150, 162, 184),
    Cyan = Color3.fromRGB(100, 220, 255),
    Gold = Color3.fromRGB(255, 183, 77),
    Green = Color3.fromRGB(111, 220, 151),
    Danger = Color3.fromRGB(255, 132, 132),
}

local screen: ScreenGui
local panel: Frame
local status: TextLabel
local listings: ScrollingFrame
local itemInput: TextBox
local amountInput: TextBox
local priceInput: TextBox
local rows: { GuiObject } = {}
local uiConnections: { RBXScriptConnection } = {}
local toastHost: any = nil
local refreshInFlight = false

local function round(instance: GuiObject, radius: number)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function outline(instance: GuiObject, color: Color3, transparency: number)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency
    stroke.Thickness = 1
    stroke.Parent = instance
end

local function makeLabel(parent: Instance, name: string, text: string, textSize: number, color: Color3): TextLabel
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = Enum.Font.GothamMedium
    label.TextSize = textSize
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local function makeButton(parent: Instance, name: string, text: string, color: Color3): TextButton
    local button = Instance.new("TextButton")
    button.Name = name
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = COLORS.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.TextWrapped = true
    button.AutoButtonColor = true
    button.Parent = parent
    round(button, 6)
    outline(button, COLORS.Cyan, 0.76)
    return button
end

local function makeField(parent: Instance, name: string, placeholder: string): TextBox
    local field = Instance.new("TextBox")
    field.Name = name
    field.BackgroundColor3 = COLORS.Field
    field.BorderSizePixel = 0
    field.PlaceholderText = placeholder
    field.PlaceholderColor3 = COLORS.Muted
    field.TextColor3 = COLORS.Text
    field.Font = Enum.Font.Gotham
    field.TextSize = 12
    field.ClearTextOnFocus = false
    field.TextXAlignment = Enum.TextXAlignment.Left
    field.Parent = parent
    round(field, 6)
    outline(field, COLORS.Cyan, 0.84)
    return field
end

local function showToast(message: string, kind: any)
    if toastHost then
        toastHost.Queue({ Text = message, Type = kind })
    else
        toastHost = toast.enqueue(screen, { Text = message, Type = kind })
    end
end

local function makeScreen(): (ScreenGui, Frame, TextLabel, ScrollingFrame, TextBox, TextBox, TextBox)
    local existing = screens:FindFirstChild("MarketScreen")
    if existing and existing:IsA("ScreenGui") then
        local existingPanel = existing:FindFirstChild("Panel")
        local existingStatus = existing:FindFirstChild("Status", true)
        local existingListings = existing:FindFirstChild("Listings", true)
        local existingItem = existing:FindFirstChild("ItemIdInput", true)
        local existingAmount = existing:FindFirstChild("AmountInput", true)
        local existingPrice = existing:FindFirstChild("PriceInput", true)
        if
            existingPanel
            and existingPanel:IsA("Frame")
            and existingStatus
            and existingStatus:IsA("TextLabel")
            and existingListings
            and existingListings:IsA("ScrollingFrame")
            and existingItem
            and existingItem:IsA("TextBox")
            and existingAmount
            and existingAmount:IsA("TextBox")
            and existingPrice
            and existingPrice:IsA("TextBox")
        then
            return existing,
                existingPanel,
                existingStatus,
                existingListings,
                existingItem,
                existingAmount,
                existingPrice
        end
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "MarketScreen"
    createdScreen.DisplayOrder = 21
    createdScreen.ResetOnSpawn = false
    createdScreen.Enabled = false
    createdScreen.Parent = screens

    local backdrop = Instance.new("Frame")
    backdrop.Name = "Backdrop"
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = COLORS.Background
    backdrop.BackgroundTransparency = 0.08
    backdrop.BorderSizePixel = 0
    backdrop.Parent = createdScreen

    local createdPanel = Instance.new("Frame")
    createdPanel.Name = "Panel"
    createdPanel.AnchorPoint = Vector2.new(0.5, 0.5)
    createdPanel.Position = UDim2.fromScale(0.5, 0.5)
    createdPanel.Size = UDim2.fromScale(0.84, 0.82)
    createdPanel.BackgroundColor3 = COLORS.Panel
    createdPanel.BorderSizePixel = 0
    createdPanel.Parent = backdrop
    round(createdPanel, 10)
    outline(createdPanel, COLORS.Cyan, 0.6)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 62)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 23, 36)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = createdPanel

    local title = makeLabel(titleBar, "Title", "FLOATING MARKET", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 7)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle = makeLabel(titleBar, "Subtitle", "Trade gathered items with other explorers", 12, COLORS.Muted)
    subtitle.Position = UDim2.new(0, 20, 0, 35)
    subtitle.Size = UDim2.new(1, -90, 0, 18)

    local close = makeButton(titleBar, "CloseButton", "X", COLORS.Raised)
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -14, 0.5, 0)
    close.Size = UDim2.fromOffset(38, 34)
    close.TextSize = 16
    close.Activated:Connect(function()
        createdScreen.Enabled = false
    end)

    local createdStatus = makeLabel(createdPanel, "Status", "Loading listings…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 20, 0, 72)
    createdStatus.Size = UDim2.new(1, -40, 0, 25)

    local form = Instance.new("Frame")
    form.Name = "CreateListingForm"
    form.Position = UDim2.new(0, 20, 0, 105)
    form.Size = UDim2.new(1, -40, 0, 75)
    form.BackgroundColor3 = COLORS.Raised
    form.BorderSizePixel = 0
    form.Parent = createdPanel
    round(form, 8)

    local createdItem = makeField(form, "ItemIdInput", "Item ID (e.g. aether_shard)")
    createdItem.Position = UDim2.new(0, 10, 0, 10)
    createdItem.Size = UDim2.new(0.32, -14, 0, 28)
    local createdAmount = makeField(form, "AmountInput", "Amount")
    createdAmount.Position = UDim2.new(0.32, 0, 0, 10)
    createdAmount.Size = UDim2.new(0.16, -4, 0, 28)
    createdAmount.Text = "1"
    local createdPrice = makeField(form, "PriceInput", "Price in shards")
    createdPrice.Position = UDim2.new(0.48, 0, 0, 10)
    createdPrice.Size = UDim2.new(0.23, -4, 0, 28)
    local create = makeButton(form, "CreateListingButton", "LIST ITEM", Color3.fromRGB(31, 77, 91))
    create.Position = UDim2.new(0.72, 0, 0, 10)
    create.Size = UDim2.new(0.28, -10, 0, 28)
    local hint = makeLabel(form, "Hint", "Items are escrowed until sold or cancelled.", 11, COLORS.Muted)
    hint.Position = UDim2.new(0, 10, 0, 43)
    hint.Size = UDim2.new(1, -20, 0, 20)

    local createdListings = Instance.new("ScrollingFrame")
    createdListings.Name = "Listings"
    createdListings.Position = UDim2.new(0, 20, 0, 190)
    createdListings.Size = UDim2.new(1, -40, 1, -210)
    createdListings.BackgroundTransparency = 1
    createdListings.BorderSizePixel = 0
    createdListings.ScrollBarThickness = 5
    createdListings.ScrollBarImageColor3 = COLORS.Cyan
    createdListings.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdListings.CanvasSize = UDim2.new()
    createdListings.Parent = createdPanel
    local layout = Instance.new("UIListLayout")
    layout.Name = "ListingLayout"
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = createdListings

    return createdScreen, createdPanel, createdStatus, createdListings, createdItem, createdAmount, createdPrice
end

screen, panel, status, listings, itemInput, amountInput, priceInput = makeScreen()

local function clearRows()
    for _, row in ipairs(rows) do
        row:Destroy()
    end
    table.clear(rows)
end

local function parsePositiveInteger(value: string): number?
    local number = tonumber(value)
    if not number or number < 1 or number ~= math.floor(number) then
        return nil
    end
    return number
end

local function itemName(itemId: string): string
    local definition = itemsData.GetItem(itemId)
    return if definition and type(definition.Name) == "string" then definition.Name else itemId
end

local function addEmpty(message: string, color: Color3)
    local empty = makeLabel(listings, "EmptyState", message, 14, color)
    empty.Size = UDim2.new(1, -8, 0, 60)
    empty.LayoutOrder = 1
    empty.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(rows, empty)
end

local function addListing(listing: any, order: number)
    if type(listing) ~= "table" or type(listing.Id) ~= "string" then
        return
    end
    local itemId = type(listing.ItemId) == "string" and listing.ItemId or "unknown"
    local amount = math.max(0, math.floor(tonumber(listing.Amount) or 0))
    local price = math.max(0, math.floor(tonumber(listing.Price) or 0))
    local sellerId = tonumber(listing.SellerId) or 0
    local card = Instance.new("Frame")
    card.Name = "Listing_" .. listing.Id
    card.Size = UDim2.new(1, -8, 0, 64)
    card.BackgroundColor3 = COLORS.Raised
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = listings
    round(card, 7)
    outline(card, sellerId == player.UserId and COLORS.Gold or COLORS.Cyan, 0.78)

    local title = makeLabel(
        card,
        "Item",
        string.format("%s  ×%d", itemName(itemId), amount),
        14,
        sellerId == player.UserId and COLORS.Gold or COLORS.Text
    )
    title.Position = UDim2.new(0, 14, 0, 8)
    title.Size = UDim2.new(0.55, 0, 0, 22)
    title.Font = Enum.Font.GothamBold
    local seller = makeLabel(card, "Seller", "Seller: " .. tostring(listing.SellerName or sellerId), 11, COLORS.Muted)
    seller.Position = UDim2.new(0, 14, 0, 32)
    seller.Size = UDim2.new(0.55, 0, 0, 18)
    local priceLabel = makeLabel(card, "Price", tostring(price) .. " shards", 13, COLORS.Gold)
    priceLabel.Position = UDim2.new(0.58, 0, 0, 0)
    priceLabel.Size = UDim2.new(0.18, 0, 1, 0)
    priceLabel.TextXAlignment = Enum.TextXAlignment.Right
    local action = makeButton(
        card,
        "Action",
        sellerId == player.UserId and "CANCEL" or "BUY",
        sellerId == player.UserId and Color3.fromRGB(83, 65, 35) or Color3.fromRGB(31, 77, 91)
    )
    action.AnchorPoint = Vector2.new(1, 0.5)
    action.Position = UDim2.new(1, -12, 0.5, 0)
    action.Size = UDim2.fromOffset(82, 34)
    action.Activated:Connect(function()
        local remoteName = sellerId == player.UserId and "CancelListing" or "PurchaseListing"
        local remote = remotes:FindFirstChild(remoteName)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(listing.Id)
            action.Active = false
            action.Text = "WORKING…"
        end
    end)
    table.insert(rows, card)
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    clearRows()
    status.TextColor3 = COLORS.Muted
    status.Text = "Checking server listings…"

    local remote = remotes:FindFirstChild("GetMarketplaceListings")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Market unavailable: listings remote is missing."
        addEmpty("No market action is available in this state.", COLORS.Danger)
        refreshInFlight = false
        return
    end

    local ok, result = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok or type(result) ~= "table" then
        status.TextColor3 = COLORS.Danger
        status.Text = "Market unavailable: the server did not return listings."
        addEmpty("Try refreshing in a moment.", COLORS.Danger)
        refreshInFlight = false
        return
    end

    table.sort(result, function(left, right)
        return tostring(left.CreatedAt or "") > tostring(right.CreatedAt or "")
    end)
    if #result == 0 then
        status.Text = "No active listings yet. Be the first explorer to list an item."
        addEmpty("Your escrowed items will return when you cancel a listing.", COLORS.Muted)
    else
        status.TextColor3 = COLORS.Cyan
        status.Text = tostring(#result) .. " active listing(s)  •  server-authoritative settlement"
        for index, listing in ipairs(result) do
            addListing(listing, index)
        end
    end
    refreshInFlight = false
end

local function wireCreate()
    local create = panel:FindFirstChild("CreateListingForm")
    local button = create and create:FindFirstChild("CreateListingButton")
    if not button or not button:IsA("TextButton") then
        return
    end
    uiConnections[#uiConnections + 1] = button.Activated:Connect(function()
        local itemId = string.lower((string.gsub(itemInput.Text, "^%s*(.-)%s*$", "%1")))
        local amount = parsePositiveInteger(amountInput.Text)
        local price = parsePositiveInteger(priceInput.Text)
        if itemId == "" or not amount or not price then
            showToast("Enter a valid item ID, whole amount, and whole price", "warning")
            return
        end
        local remote = remotes:FindFirstChild("CreateListing")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(itemId, amount, price)
            button.Active = false
            button.Text = "LISTING…"
            task.delay(2, function()
                if button.Parent then
                    button.Active = true
                    button.Text = "LIST ITEM"
                end
            end)
        end
    end)
end

local function wireNav()
    local mainMenu = screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("NavContainer", true)
    if not nav or not nav:IsA("GuiObject") then
        return
    end
    local existing = nav:FindFirstChild("NavMarket")
    local button = if existing and existing:IsA("TextButton")
        then existing
        else makeButton(nav, "NavMarket", "FLOATING MARKET", Color3.fromRGB(31, 77, 91))
    button.Size = UDim2.new(0.9, 0, 0, 42)
    button.LayoutOrder = 9
    button.Activated:Connect(function()
        for _, sibling in ipairs(screens:GetChildren()) do
            if sibling:IsA("ScreenGui") then
                sibling.Enabled = false
            end
        end
        screen.Enabled = true
        refresh()
    end)
end

local function wireEvents()
    local created = remotes:FindFirstChild("ListingCreated")
    if created and created:IsA("RemoteEvent") then
        uiConnections[#uiConnections + 1] = created.OnClientEvent:Connect(function()
            if screen.Enabled then
                refresh()
            end
        end)
    end
    local purchased = remotes:FindFirstChild("ListingPurchased")
    if purchased and purchased:IsA("RemoteEvent") then
        uiConnections[#uiConnections + 1] = purchased.OnClientEvent:Connect(function()
            showToast("Market listing settled", "success")
            if screen.Enabled then
                refresh()
            end
        end)
    end
    local cancelled = remotes:FindFirstChild("ListingCancelled")
    if cancelled and cancelled:IsA("RemoteEvent") then
        uiConnections[#uiConnections + 1] = cancelled.OnClientEvent:Connect(function()
            showToast("Listing cancelled and item returned", "success")
            if screen.Enabled then
                refresh()
            end
        end)
    end
    local errorRemote = remotes:FindFirstChild("Error")
    if errorRemote and errorRemote:IsA("RemoteEvent") then
        uiConnections[#uiConnections + 1] = errorRemote.OnClientEvent:Connect(function(message)
            showToast(tostring(message), "error")
            if screen.Enabled then
                refresh()
            end
        end)
    end
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        refresh()
    end
end)

wireCreate()
wireNav()
wireEvents()
print("[MarketplaceController] Floating Market initialized")
