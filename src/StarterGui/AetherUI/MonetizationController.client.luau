-- Player-facing shop shell for server-owned monetization.
-- The server supplies the catalog; this client never supplies price or grant data.

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local aetherUI = script.Parent
local remotes = ReplicatedStorage:WaitForChild("AetherShared"):WaitForChild("Remotes")

local COLORS = {
    Background = Color3.fromRGB(13, 27, 42),
    Panel = Color3.fromRGB(28, 32, 48),
    PanelRaised = Color3.fromRGB(38, 42, 62),
    Text = Color3.fromRGB(230, 235, 245),
    Muted = Color3.fromRGB(140, 150, 170),
    Cyan = Color3.fromRGB(100, 220, 255),
    Gold = Color3.fromRGB(255, 183, 77),
    Danger = Color3.fromRGB(255, 132, 132),
}

local function round(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
end

local function stroke(instance, color, transparency)
    local outline = Instance.new("UIStroke")
    outline.Color = color
    outline.Transparency = transparency or 0
    outline.Thickness = 1
    outline.Parent = instance
end

local function label(parent, name, text, size, color)
    local result = Instance.new("TextLabel")
    result.Name = name
    result.BackgroundTransparency = 1
    result.Text = text
    result.TextColor3 = color or COLORS.Text
    result.Font = Enum.Font.GothamMedium
    result.TextSize = size or 16
    result.TextWrapped = true
    result.TextXAlignment = Enum.TextXAlignment.Left
    result.TextYAlignment = Enum.TextYAlignment.Center
    result.Parent = parent
    return result
end

local function button(parent, name, text, color)
    local result = Instance.new("TextButton")
    result.Name = name
    result.AutoButtonColor = true
    result.BackgroundColor3 = color or COLORS.PanelRaised
    result.BorderSizePixel = 0
    result.Text = text
    result.TextColor3 = COLORS.Text
    result.Font = Enum.Font.GothamBold
    result.TextSize = 15
    result.TextWrapped = true
    result.Parent = parent
    round(result, 7)
    stroke(result, COLORS.Cyan, 0.72)
    return result
end

local function makeScreen()
    local screens = aetherUI:FindFirstChild("Screens")
    while not screens or not screens:IsA("Folder") do
        task.wait()
        screens = aetherUI:FindFirstChild("Screens")
    end

    local existing = screens:FindFirstChild("ShopScreen")
    if existing then
        return existing
    end

    local screen = Instance.new("ScreenGui")
    screen.Name = "ShopScreen"
    screen.DisplayOrder = 20
    screen.ResetOnSpawn = false
    screen.Enabled = false
    screen.Parent = screens

    local backdrop = Instance.new("Frame")
    backdrop.Name = "Backdrop"
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = COLORS.Background
    backdrop.BackgroundTransparency = 0.08
    backdrop.BorderSizePixel = 0
    backdrop.Parent = screen

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.Size = UDim2.fromScale(0.72, 0.78)
    panel.BackgroundColor3 = COLORS.Panel
    panel.BorderSizePixel = 0
    panel.Parent = backdrop
    round(panel, 10)
    stroke(panel, COLORS.Cyan, 0.58)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 62)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 23, 36)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = panel

    local title = label(titleBar, "Title", "AETHER EXCHANGE", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 6)
    title.Size = UDim2.new(1, -90, 0, 28)
    title.Font = Enum.Font.GothamBold

    local subtitle =
        label(titleBar, "Subtitle", "Optional support, guaranteed value, no random paid rewards", 12, COLORS.Muted)
    subtitle.Position = UDim2.new(0, 20, 0, 34)
    subtitle.Size = UDim2.new(1, -90, 0, 20)

    local close = button(titleBar, "CloseButton", "X", Color3.fromRGB(30, 34, 52))
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -14, 0.5, 0)
    close.Size = UDim2.fromOffset(38, 34)
    close.TextSize = 16
    close.Activated:Connect(function()
        screen.Enabled = false
    end)

    local status = label(panel, "Status", "Loading shop…", 13, COLORS.Muted)
    status.Position = UDim2.new(0, 20, 0, 72)
    status.Size = UDim2.new(1, -40, 0, 28)

    local list = Instance.new("ScrollingFrame")
    list.Name = "OfferList"
    list.Position = UDim2.new(0, 20, 0, 108)
    list.Size = UDim2.new(1, -40, 1, -128)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 5
    list.ScrollBarImageColor3 = COLORS.Cyan
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.CanvasSize = UDim2.new()
    list.Parent = panel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    return screen, status, list
end

local screen, status, list = makeScreen()

local function clearOffers()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

local function addEmptyState(message, color)
    local empty = label(list, "EmptyState", message, 15, color or COLORS.Muted)
    empty.Size = UDim2.new(1, -8, 0, 72)
    empty.LayoutOrder = 1
    empty.TextXAlignment = Enum.TextXAlignment.Center
    return empty
end

local function addOffer(offer, isPass, order)
    local card = Instance.new("Frame")
    card.Name = offer.Key .. "Offer"
    card.Size = UDim2.new(1, -8, 0, 92)
    card.BackgroundColor3 = COLORS.PanelRaised
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = list
    round(card, 8)
    stroke(card, isPass and COLORS.Gold or COLORS.Cyan, 0.72)

    local heading = label(card, "Name", offer.Name, 16, isPass and COLORS.Gold or COLORS.Text)
    heading.Position = UDim2.new(0, 16, 0, 10)
    heading.Size = UDim2.new(1, -180, 0, 24)
    heading.Font = Enum.Font.GothamBold

    local description = label(card, "Description", offer.Description, 12, COLORS.Muted)
    description.Position = UDim2.new(0, 16, 0, 38)
    description.Size = UDim2.new(1, -180, 0, 40)
    description.TextYAlignment = Enum.TextYAlignment.Top

    local buy = button(
        card,
        "Purchase",
        isPass and "VIEW PASS" or "VIEW PRODUCT",
        isPass and Color3.fromRGB(83, 65, 35) or Color3.fromRGB(31, 77, 91)
    )
    buy.AnchorPoint = Vector2.new(1, 0.5)
    buy.Position = UDim2.new(1, -14, 0.5, 0)
    buy.Size = UDim2.fromOffset(132, 40)
    buy.Activated:Connect(function()
        if isPass then
            MarketplaceService:PromptGamePassPurchase(player, offer.Id)
        else
            MarketplaceService:PromptProductPurchase(player, offer.Id)
        end
    end)
end

local function loadCatalog()
    clearOffers()
    status.TextColor3 = COLORS.Muted
    status.Text = "Checking the server catalog…"

    local catalogRemote = remotes:FindFirstChild("GetMonetizationCatalog")
    if not catalogRemote then
        status.TextColor3 = COLORS.Danger
        status.Text = "Shop unavailable: catalog remote is missing."
        addEmptyState("Please return later.", COLORS.Danger)
        return
    end

    local ok, catalog = pcall(function()
        return catalogRemote:InvokeServer()
    end)
    if not ok or type(catalog) ~= "table" then
        status.TextColor3 = COLORS.Danger
        status.Text = "Shop unavailable: the server did not return a catalog."
        addEmptyState("No purchase can be started from this state.", COLORS.Danger)
        return
    end

    local passes = type(catalog.GamePasses) == "table" and catalog.GamePasses or {}
    local products = type(catalog.DeveloperProducts) == "table" and catalog.DeveloperProducts or {}
    local total = #passes + #products
    if total == 0 then
        status.TextColor3 = COLORS.Muted
        status.Text = "Development mode: live product IDs are not configured."
        addEmptyState("The shop is safely disabled until the matching Creator Hub products are created and reviewed.")
        return
    end

    status.TextColor3 = COLORS.Cyan
    status.Text = tostring(total) .. " verified offer(s) available"
    local order = 1
    for _, pass in ipairs(passes) do
        addOffer(pass, true, order)
        order += 1
    end
    for _, product in ipairs(products) do
        addOffer(product, false, order)
        order += 1
    end
end

local function wireNavButton()
    local mainMenu = aetherUI:FindFirstChild("Screens") and aetherUI.Screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("Panel") and mainMenu.Panel:FindFirstChild("NavContainer")
    if not nav or nav:FindFirstChild("NavShop") then
        return
    end

    local open = button(nav, "NavShop", "AETHER EXCHANGE", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 8
    open.Activated:Connect(function()
        for _, sibling in ipairs(aetherUI.Screens:GetChildren()) do
            if sibling:IsA("ScreenGui") then
                sibling.Enabled = false
            end
        end
        screen.Enabled = true
        loadCatalog()
    end)
end

wireNavButton()

local updated = remotes:FindFirstChild("MonetizationUpdated")
if updated then
    updated.OnClientEvent:Connect(function(eventName, key)
        if eventName == "ProductGranted" or eventName == "PassGranted" then
            status.TextColor3 = COLORS.Cyan
            status.Text = "Confirmed: " .. tostring(key)
        end
    end)
end

print("[MonetizationController] Shop shell initialized")
