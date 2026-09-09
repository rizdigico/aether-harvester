--!strict
-- CosmeticsController: renders the server-owned cosmetic catalog and ownership.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local toast = require(script.Parent.Components.Toast)

local COLORS = {
    Background = Color3.fromRGB(13, 27, 42),
    Panel = Color3.fromRGB(28, 32, 48),
    Raised = Color3.fromRGB(38, 42, 62),
    Text = Color3.fromRGB(230, 235, 245),
    Muted = Color3.fromRGB(150, 162, 184),
    Cyan = Color3.fromRGB(100, 220, 255),
    Gold = Color3.fromRGB(255, 183, 77),
    Green = Color3.fromRGB(111, 220, 151),
    Danger = Color3.fromRGB(255, 132, 132),
}

local screen: ScreenGui
local status: TextLabel
local list: ScrollingFrame
local cards: { GuiObject } = {}
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

local function label(parent: Instance, name: string, text: string, size: number, color: Color3): TextLabel
    local result = Instance.new("TextLabel")
    result.Name = name
    result.BackgroundTransparency = 1
    result.Text = text
    result.TextColor3 = color
    result.Font = Enum.Font.GothamMedium
    result.TextSize = size
    result.TextWrapped = true
    result.TextXAlignment = Enum.TextXAlignment.Left
    result.TextYAlignment = Enum.TextYAlignment.Center
    result.Parent = parent
    return result
end

local function button(parent: Instance, name: string, text: string, color: Color3): TextButton
    local result = Instance.new("TextButton")
    result.Name = name
    result.BackgroundColor3 = color
    result.BorderSizePixel = 0
    result.Text = text
    result.TextColor3 = COLORS.Text
    result.Font = Enum.Font.GothamBold
    result.TextSize = 12
    result.TextWrapped = true
    result.AutoButtonColor = true
    result.Parent = parent
    round(result, 6)
    outline(result, COLORS.Cyan, 0.78)
    return result
end

local function makeScreen(): (ScreenGui, Frame, TextLabel, ScrollingFrame)
    local existing = screens:FindFirstChild("CosmeticsScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "CosmeticsScreen"
    createdScreen.DisplayOrder = 20
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
    createdPanel.Size = UDim2.fromScale(0.76, 0.8)
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
    local title = label(titleBar, "Title", "AETHER COSMETICS", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 7)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle =
        label(titleBar, "Subtitle", "Permanent looks purchased with earned Aether Shards", 12, COLORS.Muted)
    subtitle.Position = UDim2.new(0, 20, 0, 35)
    subtitle.Size = UDim2.new(1, -90, 0, 18)
    local close = button(titleBar, "CloseButton", "X", COLORS.Raised)
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -14, 0.5, 0)
    close.Size = UDim2.fromOffset(38, 34)
    close.TextSize = 16
    close.Activated:Connect(function()
        createdScreen.Enabled = false
    end)

    local createdStatus = label(createdPanel, "Status", "Loading cosmetics…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 20, 0, 72)
    createdStatus.Size = UDim2.new(1, -40, 0, 25)

    local createdList = Instance.new("ScrollingFrame")
    createdList.Name = "CosmeticList"
    createdList.Position = UDim2.new(0, 20, 0, 105)
    createdList.Size = UDim2.new(1, -40, 1, -125)
    createdList.BackgroundTransparency = 1
    createdList.BorderSizePixel = 0
    createdList.ScrollBarThickness = 5
    createdList.ScrollBarImageColor3 = COLORS.Cyan
    createdList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdList.CanvasSize = UDim2.new()
    createdList.Parent = createdPanel
    local layout = Instance.new("UIListLayout")
    layout.Name = "CosmeticLayout"
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = createdList

    return createdScreen, createdPanel, createdStatus, createdList
end

local _panel: Frame
screen, _panel, status, list = makeScreen()

local function showToast(message: string, kind: any)
    if toastHost then
        toastHost.Queue({ Text = message, Type = kind })
    else
        toastHost = toast.enqueue(screen, { Text = message, Type = kind })
    end
end

local function clearCards()
    for _, card in ipairs(cards) do
        card:Destroy()
    end
    table.clear(cards)
end

local function addEmpty(message: string, color: Color3)
    local empty = label(list, "EmptyState", message, 15, color)
    empty.Size = UDim2.new(1, -8, 0, 60)
    empty.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(cards, empty)
end

local function addCosmetic(cosmetic: any, owned: boolean, equipped: boolean, order: number)
    if type(cosmetic) ~= "table" or type(cosmetic.Id) ~= "string" then
        return
    end
    local card = Instance.new("Frame")
    card.Name = "Cosmetic_" .. cosmetic.Id
    card.Size = UDim2.new(1, -8, 0, 78)
    card.BackgroundColor3 = equipped and Color3.fromRGB(43, 75, 65) or COLORS.Raised
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = list
    round(card, 7)
    outline(card, equipped and COLORS.Green or COLORS.Cyan, 0.78)

    local title =
        label(card, "Name", tostring(cosmetic.Name or cosmetic.Id), 15, equipped and COLORS.Green or COLORS.Text)
    title.Position = UDim2.new(0, 14, 0, 8)
    title.Size = UDim2.new(0.48, 0, 0, 22)
    title.Font = Enum.Font.GothamBold
    local detail = label(
        card,
        "Detail",
        string.format(
            "%s  •  %s  •  %s",
            tostring(cosmetic.Type or "Cosmetic"),
            tostring(cosmetic.Rarity or ""),
            tostring(cosmetic.Effect or "")
        ),
        11,
        COLORS.Muted
    )
    detail.Position = UDim2.new(0, 14, 0, 34)
    detail.Size = UDim2.new(0.62, 0, 0, 30)
    detail.TextYAlignment = Enum.TextYAlignment.Top
    local action = button(
        card,
        "Action",
        equipped and "EQUIPPED" or (owned and "EQUIP" or (tostring(cosmetic.Price) .. " SHARDS")),
        equipped and Color3.fromRGB(42, 91, 62) or (owned and Color3.fromRGB(31, 77, 91) or Color3.fromRGB(83, 65, 35))
    )
    action.AnchorPoint = Vector2.new(1, 0.5)
    action.Position = UDim2.new(1, -12, 0.5, 0)
    action.Size = UDim2.fromOffset(112, 36)
    action.Active = not equipped
    action.AutoButtonColor = not equipped
    action.Activated:Connect(function()
        if equipped then
            return
        end
        local remoteName = owned and "EquipCosmetic" or "PurchaseCosmetic"
        local remote = remotes:FindFirstChild(remoteName)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(cosmetic.Id)
            action.Active = false
            action.Text = "WORKING…"
        end
    end)
    table.insert(cards, card)
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    clearCards()
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server cosmetic catalog…"
    local remote = remotes:FindFirstChild("GetCosmeticCatalog")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Cosmetics unavailable: catalog remote is missing."
        addEmpty("No cosmetic action is available in this state.", COLORS.Danger)
        refreshInFlight = false
        return
    end
    local ok, result = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok or type(result) ~= "table" then
        status.TextColor3 = COLORS.Danger
        status.Text = "Cosmetics unavailable: server catalog failed."
        addEmpty("Try again in a moment.", COLORS.Danger)
        refreshInFlight = false
        return
    end
    local catalog = type(result.Cosmetics) == "table" and result.Cosmetics or {}
    local owned = type(result.Owned) == "table" and result.Owned or {}
    local equipped = result.Equipped
    status.TextColor3 = COLORS.Cyan
    status.Text = string.format("%d cosmetics  •  earned-currency catalog  •  permanent ownership", #catalog)
    if #catalog == 0 then
        addEmpty("No cosmetics are configured yet.", COLORS.Muted)
    else
        for index, cosmetic in ipairs(catalog) do
            addCosmetic(cosmetic, owned[cosmetic.Id] == true, equipped == cosmetic.Id, index)
        end
    end
    refreshInFlight = false
end

local function wireNav()
    local mainMenu = screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("NavContainer", true)
    if not nav or not nav:IsA("GuiObject") then
        return
    end
    local existing = nav:FindFirstChild("NavCosmetics")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavCosmetics", "COSMETICS", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 11
    open.Activated:Connect(function()
        for _, sibling in ipairs(screens:GetChildren()) do
            if sibling:IsA("ScreenGui") then
                sibling.Enabled = false
            end
        end
        screen.Enabled = true
        refresh()
    end)
end

local purchased = remotes:FindFirstChild("CosmeticPurchased")
if purchased and purchased:IsA("RemoteEvent") then
    purchased.OnClientEvent:Connect(function(cosmeticId)
        showToast("Purchased " .. tostring(cosmeticId), "success")
        if screen.Enabled then
            refresh()
        end
    end)
end
local equipped = remotes:FindFirstChild("CosmeticEquipped")
if equipped and equipped:IsA("RemoteEvent") then
    equipped.OnClientEvent:Connect(function(cosmeticId)
        showToast("Equipped " .. tostring(cosmeticId), "success")
        if screen.Enabled then
            refresh()
        end
    end)
end
local errorRemote = remotes:FindFirstChild("Error")
if errorRemote and errorRemote:IsA("RemoteEvent") then
    errorRemote.OnClientEvent:Connect(function(message)
        showToast(tostring(message), "error")
        if screen.Enabled then
            refresh()
        end
    end)
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        refresh()
    else
        clearCards()
    end
end)

wireNav()
print("[CosmeticsController] Initialized")
