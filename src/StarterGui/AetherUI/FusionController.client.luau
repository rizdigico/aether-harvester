--!strict
-- FusionController: selects two owned pet instances for deterministic fusion.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local petsData = require(shared:WaitForChild("Data"):WaitForChild("Pets"))
local fusionRules = require(shared:WaitForChild("Modules"):WaitForChild("PetFusionRules"))

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
local selectedStatus: TextLabel
local list: ScrollingFrame
local fuseButton: TextButton
local cards: { GuiObject } = {}
local selected: { [number]: boolean } = {}
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

local function makeScreen(): (ScreenGui, TextLabel, TextLabel, ScrollingFrame, TextButton)
    local existing = screens:FindFirstChild("FusionScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "FusionScreen"
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
    panel.Size = UDim2.fromScale(0.72, 0.78)
    panel.BackgroundColor3 = COLORS.Panel
    panel.BorderSizePixel = 0
    panel.Parent = backdrop
    round(panel, 10)
    outline(panel, COLORS.Gold, 0.6)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 68)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 23, 36)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = panel
    local title = label(titleBar, "Title", "FUSION LAB", 22, COLORS.Gold)
    title.Position = UDim2.new(0, 20, 0, 8)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle = label(titleBar, "Subtitle", "Combine two un-equipped pets into a known result.", 12, COLORS.Muted)
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

    local createdStatus = label(panel, "Status", "Select two pets…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 24, 0, 84)
    createdStatus.Size = UDim2.new(1, -48, 0, 26)
    local createdSelected = label(panel, "Selected", "0/2 selected  •  deterministic recipes only", 12, COLORS.Cyan)
    createdSelected.Position = UDim2.new(0, 24, 0, 108)
    createdSelected.Size = UDim2.new(1, -48, 0, 24)

    local createdList = Instance.new("ScrollingFrame")
    createdList.Name = "PetList"
    createdList.Position = UDim2.new(0, 24, 0, 142)
    createdList.Size = UDim2.new(1, -48, 1, -232)
    createdList.BackgroundTransparency = 1
    createdList.BorderSizePixel = 0
    createdList.ScrollBarThickness = 5
    createdList.ScrollBarImageColor3 = COLORS.Cyan
    createdList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdList.CanvasSize = UDim2.new()
    createdList.Parent = panel
    local layout = Instance.new("UIListLayout")
    layout.Name = "PetLayout"
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = createdList

    local createdFuse = button(panel, "FuseButton", "SELECT TWO PETS", Color3.fromRGB(83, 65, 35))
    createdFuse.Position = UDim2.new(0, 24, 1, -62)
    createdFuse.Size = UDim2.new(1, -48, 0, 38)
    createdFuse.TextSize = 14

    return createdScreen, createdStatus, createdSelected, createdList, createdFuse
end

screen, status, selectedStatus, list, fuseButton = makeScreen()

local function clearCards()
    for _, card in ipairs(cards) do
        card:Destroy()
    end
    table.clear(cards)
end

local function selectedIds(): { number }
    local ids = {}
    for id, isSelected in pairs(selected) do
        if isSelected then
            table.insert(ids, id)
        end
    end
    table.sort(ids)
    return ids
end

local function render(pets: any)
    clearCards()
    local entries = type(pets) == "table" and pets or {}
    local available: { [number]: boolean } = {}
    for _, pet in ipairs(entries) do
        if type(pet) == "table" and type(pet.InstanceId) == "number" and type(pet.PetId) == "string" then
            available[pet.InstanceId] = true
        end
    end
    for id in pairs(selected) do
        if not available[id] then
            selected[id] = nil
        end
    end

    local ids = selectedIds()
    local resultId: string? = nil
    if #ids == 2 then
        local first: any
        local second: any
        for _, pet in ipairs(entries) do
            if type(pet) == "table" and pet.InstanceId == ids[1] then
                first = pet
            elseif type(pet) == "table" and pet.InstanceId == ids[2] then
                second = pet
            end
        end
        if first and second then
            resultId = fusionRules.Resolve(first.PetId, second.PetId)
        end
    end

    selectedStatus.TextColor3 = resultId and COLORS.Green or COLORS.Cyan
    selectedStatus.Text = resultId
            and string.format(
                "2/2 selected  •  result: %s",
                tostring((petsData.GetPet(resultId) or {}).Name or resultId)
            )
        or string.format("%d/2 selected  •  select a recipe-compatible pair", #ids)
    fuseButton.Active = resultId ~= nil
    fuseButton.AutoButtonColor = resultId ~= nil
    fuseButton.Text = resultId and "FUSE SELECTED PETS" or "SELECT TWO COMPATIBLE PETS"

    if #entries == 0 then
        local empty =
            label(list, "EmptyState", "You need two owned pets before using the Fusion Lab.", 14, COLORS.Muted)
        empty.Size = UDim2.new(1, -8, 0, 60)
        empty.TextXAlignment = Enum.TextXAlignment.Center
        table.insert(cards, empty)
        return
    end
    for index, pet in ipairs(entries) do
        if type(pet) == "table" and type(pet.InstanceId) == "number" and type(pet.PetId) == "string" then
            local def = petsData.GetPet(pet.PetId)
            local isSelected = selected[pet.InstanceId] == true
            local row = Instance.new("Frame")
            row.Name = "Pet_" .. tostring(pet.InstanceId)
            row.LayoutOrder = index
            row.Size = UDim2.new(1, -8, 0, 56)
            row.BackgroundColor3 = isSelected and Color3.fromRGB(43, 75, 65) or COLORS.Raised
            row.BorderSizePixel = 0
            row.Parent = list
            round(row, 7)
            outline(row, isSelected and COLORS.Green or COLORS.Cyan, 0.78)
            local name = label(
                row,
                "Name",
                string.format("%s  •  #%d", tostring(def and def.Name or pet.PetId), pet.InstanceId),
                13,
                isSelected and COLORS.Green or COLORS.Text
            )
            name.Position = UDim2.new(0, 14, 0, 0)
            name.Size = UDim2.new(0.68, 0, 1, 0)
            local state = button(
                row,
                "Select",
                isSelected and "SELECTED" or "SELECT",
                isSelected and Color3.fromRGB(43, 75, 65) or Color3.fromRGB(31, 77, 91)
            )
            state.AnchorPoint = Vector2.new(1, 0.5)
            state.Position = UDim2.new(1, -10, 0.5, 0)
            state.Size = UDim2.fromOffset(88, 32)
            state.Activated:Connect(function()
                if selected[pet.InstanceId] then
                    selected[pet.InstanceId] = nil
                elseif #selectedIds() < 2 then
                    selected[pet.InstanceId] = true
                end
                render(entries)
            end)
            table.insert(cards, row)
        end
    end
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server pet inventory…"
    local remote = remotes:FindFirstChild("GetPets")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Fusion unavailable: pet endpoint is missing."
        refreshInFlight = false
        return
    end
    local ok, pets = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok then
        status.TextColor3 = COLORS.Danger
        status.Text = "Fusion unavailable: server inventory failed."
    else
        status.TextColor3 = COLORS.Cyan
        status.Text = "Server-owned inventory  •  equipped pets cannot be consumed"
        render(pets)
    end
    refreshInFlight = false
end

fuseButton.Activated:Connect(function()
    if not fuseButton.Active then
        return
    end
    local ids = selectedIds()
    if #ids ~= 2 then
        return
    end
    local remote = remotes:FindFirstChild("FusePets")
    if remote and remote:IsA("RemoteEvent") then
        fuseButton.Active = false
        fuseButton.AutoButtonColor = false
        fuseButton.Text = "FUSING…"
        remote:FireServer(ids[1], ids[2])
    end
end)

local completed = remotes:FindFirstChild("PetFusionCompleted")
if completed and completed:IsA("RemoteEvent") then
    completed.OnClientEvent:Connect(function(resultPet: any)
        table.clear(selected)
        status.TextColor3 = COLORS.Green
        local resultId = type(resultPet) == "table" and resultPet.PetId or nil
        local def = resultId and petsData.GetPet(resultId)
        status.Text =
            string.format("FUSION COMPLETE  •  %s added", tostring(def and def.Name or resultId or "new pet"))
        task.delay(0.25, refresh)
    end)
end

local updated = remotes:FindFirstChild("PetUpdated")
if updated and updated:IsA("RemoteEvent") then
    updated.OnClientEvent:Connect(function()
        if screen.Enabled then
            refresh()
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
    local existing = nav:FindFirstChild("NavFusion")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavFusion", "FUSION LAB", Color3.fromRGB(83, 65, 35))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 18
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
        clearCards()
    end
end)

wireNav()
print("[FusionController] Initialized")
