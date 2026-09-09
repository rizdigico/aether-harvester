--!strict
-- BaseController: manages the server-owned personal decoration grid.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local itemsData = require(shared:WaitForChild("Data"):WaitForChild("Items"))

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
local status: TextLabel
local summary: TextLabel
local list: ScrollingFrame
local itemInput: TextBox
local xInput: TextBox
local zInput: TextBox
local rotationInput: TextBox
local placeButton: TextButton
local visitButton: TextButton
local rows: { GuiObject } = {}
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

local function field(parent: Instance, name: string, placeholder: string): TextBox
    local result = Instance.new("TextBox")
    result.Name = name
    result.BackgroundColor3 = COLORS.Field
    result.BorderSizePixel = 0
    result.PlaceholderText = placeholder
    result.PlaceholderColor3 = COLORS.Muted
    result.TextColor3 = COLORS.Text
    result.Font = Enum.Font.GothamMedium
    result.TextSize = 12
    result.ClearTextOnFocus = false
    result.TextXAlignment = Enum.TextXAlignment.Center
    result.Parent = parent
    round(result, 6)
    outline(result, COLORS.Cyan, 0.84)
    return result
end

local function makeScreen(): (
    ScreenGui,
    TextLabel,
    TextLabel,
    ScrollingFrame,
    TextBox,
    TextBox,
    TextBox,
    TextBox,
    TextButton,
    TextButton
)
    local existing = screens:FindFirstChild("BaseScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "BaseScreen"
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

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.Size = UDim2.fromScale(0.78, 0.8)
    panel.BackgroundColor3 = COLORS.Panel
    panel.BorderSizePixel = 0
    panel.Parent = backdrop
    round(panel, 10)
    outline(panel, COLORS.Cyan, 0.6)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 68)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 23, 36)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = panel
    local title = label(titleBar, "Title", "AETHER BASE", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 8)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle =
        label(titleBar, "Subtitle", "Place owned decorations on a protected server grid.", 12, COLORS.Muted)
    subtitle.Position = UDim2.new(0, 20, 0, 37)
    subtitle.Size = UDim2.new(1, -90, 0, 18)
    local close = button(titleBar, "CloseButton", "X", COLORS.Raised)
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -14, 0.5, 0)
    close.Size = UDim2.fromOffset(38, 34)
    close.TextSize = 16
    close.Activated:Connect(function()
        createdScreen.Enabled = false
    end)

    local createdStatus = label(panel, "Status", "Reading server base state…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 24, 0, 84)
    createdStatus.Size = UDim2.new(1, -48, 0, 25)
    local createdSummary = label(panel, "Summary", "0/30 decorations  •  grid -7..7", 12, COLORS.Cyan)
    createdSummary.Position = UDim2.new(0, 24, 0, 108)
    createdSummary.Size = UDim2.new(1, -48, 0, 23)

    local createdList = Instance.new("ScrollingFrame")
    createdList.Name = "DecorationList"
    createdList.Position = UDim2.new(0, 24, 0, 140)
    createdList.Size = UDim2.new(1, -48, 1, -280)
    createdList.BackgroundTransparency = 1
    createdList.BorderSizePixel = 0
    createdList.ScrollBarThickness = 5
    createdList.ScrollBarImageColor3 = COLORS.Cyan
    createdList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdList.CanvasSize = UDim2.new()
    createdList.Parent = panel
    local layout = Instance.new("UIListLayout")
    layout.Name = "DecorationLayout"
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = createdList

    local controls = Instance.new("Frame")
    controls.Name = "Controls"
    controls.Position = UDim2.new(0, 24, 1, -126)
    controls.Size = UDim2.new(1, -48, 0, 104)
    controls.BackgroundTransparency = 1
    controls.Parent = panel
    local createdItem = field(controls, "ItemInput", "item id  e.g. sky_lantern")
    createdItem.Position = UDim2.new(0, 0, 0, 0)
    createdItem.Size = UDim2.new(0.48, -7, 0, 36)
    local createdX = field(controls, "XInput", "X")
    createdX.Position = UDim2.new(0.48, 0, 0, 0)
    createdX.Size = UDim2.new(0.13, -5, 0, 36)
    local createdZ = field(controls, "ZInput", "Z")
    createdZ.Position = UDim2.new(0.61, 0, 0, 0)
    createdZ.Size = UDim2.new(0.13, -5, 0, 36)
    local createdRotation = field(controls, "RotationInput", "°")
    createdRotation.Position = UDim2.new(0.74, 0, 0, 0)
    createdRotation.Size = UDim2.new(0.13, -5, 0, 36)
    local createdPlace = button(controls, "PlaceButton", "PLACE", Color3.fromRGB(31, 77, 91))
    createdPlace.Position = UDim2.new(0.87, 0, 0, 0)
    createdPlace.Size = UDim2.new(0.13, 0, 0, 36)
    local hint = label(
        controls,
        "Hint",
        "Grid cells are -7 to 7. Removing a decoration returns it to inventory.",
        11,
        COLORS.Muted
    )
    hint.Position = UDim2.new(0, 0, 0, 43)
    hint.Size = UDim2.new(0.7, 0, 0, 20)
    local createdVisit = button(controls, "VisitButton", "VISIT MY BASE", Color3.fromRGB(83, 65, 35))
    createdVisit.Position = UDim2.new(0.72, 0, 0, 43)
    createdVisit.Size = UDim2.new(0.28, 0, 0, 36)

    return createdScreen,
        createdStatus,
        createdSummary,
        createdList,
        createdItem,
        createdX,
        createdZ,
        createdRotation,
        createdPlace,
        createdVisit
end

screen, status, summary, list, itemInput, xInput, zInput, rotationInput, placeButton, visitButton = makeScreen()

local function clearRows()
    for _, row in ipairs(rows) do
        row:Destroy()
    end
    table.clear(rows)
end

local function parseInteger(value: string, fallback: number): number
    local number = tonumber(value)
    if number and number == math.floor(number) then
        return number
    end
    return fallback
end

local function render(snapshot: any)
    clearRows()
    if type(snapshot) ~= "table" then
        status.TextColor3 = COLORS.Danger
        status.Text = "Base unavailable: invalid server snapshot."
        return
    end
    local decorations = type(snapshot.Decorations) == "table" and snapshot.Decorations or {}
    local maxDecorations = math.max(#decorations, math.floor(tonumber(snapshot.MaxDecorations) or 30))
    summary.Text = string.format("%d/%d decorations  •  grid -7..7  •  server-owned", #decorations, maxDecorations)
    placeButton.Active = #decorations < maxDecorations
    placeButton.AutoButtonColor = #decorations < maxDecorations
    if #decorations == 0 then
        local empty = label(
            list,
            "EmptyState",
            "No decorations placed yet. Use an owned Decoration item below.",
            14,
            COLORS.Muted
        )
        empty.Size = UDim2.new(1, -8, 0, 60)
        empty.TextXAlignment = Enum.TextXAlignment.Center
        table.insert(rows, empty)
        return
    end
    for index, decoration in ipairs(decorations) do
        if type(decoration) == "table" then
            local item = itemsData.GetItem(decoration.ItemId)
            local row = Instance.new("Frame")
            row.Name = "Decoration_" .. tostring(decoration.Id or index)
            row.LayoutOrder = index
            row.Size = UDim2.new(1, -8, 0, 48)
            row.BackgroundColor3 = COLORS.Raised
            row.BorderSizePixel = 0
            row.Parent = list
            round(row, 7)
            outline(row, item and item.Color or COLORS.Cyan, 0.8)
            local text = label(
                row,
                "Description",
                string.format(
                    "%s  •  cell (%d, %d)  •  %d°",
                    tostring(item and item.Name or decoration.ItemId),
                    tonumber(decoration.X) or 0,
                    tonumber(decoration.Z) or 0,
                    tonumber(decoration.Rotation) or 0
                ),
                12,
                COLORS.Text
            )
            text.Position = UDim2.new(0, 14, 0, 0)
            text.Size = UDim2.new(0.74, 0, 1, 0)
            local remove = button(row, "Remove", "RETURN", Color3.fromRGB(83, 48, 55))
            remove.AnchorPoint = Vector2.new(1, 0.5)
            remove.Position = UDim2.new(1, -10, 0.5, 0)
            remove.Size = UDim2.fromOffset(78, 30)
            remove.Activated:Connect(function()
                local remote = remotes:FindFirstChild("RemoveDecoration")
                if remote and remote:IsA("RemoteEvent") then
                    remote:FireServer(decoration.Id)
                end
            end)
            table.insert(rows, row)
        end
    end
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server base state…"
    local remote = remotes:FindFirstChild("GetBase")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Base unavailable: endpoint is missing."
        refreshInFlight = false
        return
    end
    local ok, snapshot = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok then
        status.TextColor3 = COLORS.Danger
        status.Text = "Base unavailable: server snapshot failed."
    else
        status.TextColor3 = COLORS.Cyan
        status.Text = "Server-owned base  •  decorations are returned on removal"
        render(snapshot)
    end
    refreshInFlight = false
end

placeButton.Activated:Connect(function()
    if not placeButton.Active then
        return
    end
    local itemId = string.lower((string.gsub(itemInput.Text, "^%s*(.-)%s*$", "%1")))
    if itemId == "" then
        status.TextColor3 = COLORS.Danger
        status.Text = "Enter a Decoration item id."
        return
    end
    local remote = remotes:FindFirstChild("PlaceDecoration")
    if remote and remote:IsA("RemoteEvent") then
        placeButton.Active = false
        placeButton.Text = "PLACING…"
        remote:FireServer(
            itemId,
            parseInteger(xInput.Text, 0),
            parseInteger(zInput.Text, 0),
            parseInteger(rotationInput.Text, 0)
        )
    end
end)

visitButton.Activated:Connect(function()
    local remote = remotes:FindFirstChild("VisitBase")
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer()
    end
end)

local updated = remotes:FindFirstChild("BaseUpdated")
if updated and updated:IsA("RemoteEvent") then
    updated.OnClientEvent:Connect(function(snapshot)
        if screen.Enabled then
            render(snapshot)
        end
    end)
end

local errorRemote = remotes:FindFirstChild("Error")
if errorRemote and errorRemote:IsA("RemoteEvent") then
    errorRemote.OnClientEvent:Connect(function(message)
        if screen.Enabled then
            status.TextColor3 = COLORS.Danger
            status.Text = tostring(message)
            task.delay(0.4, refresh)
        end
    end)
end

local function wireNav()
    local mainMenu = screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("NavContainer", true)
    if not nav or not nav:IsA("GuiObject") then
        return
    end
    local existing = nav:FindFirstChild("NavBase")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavBase", "AETHER BASE", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 19
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

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        refresh()
    else
        clearRows()
    end
end)

wireNav()
print("[BaseController] Initialized")
