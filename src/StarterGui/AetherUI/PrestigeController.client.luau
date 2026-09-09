--!strict
-- PrestigeController: presents the server-owned ascension decision and result.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")

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
local progress: TextLabel
local bonus: TextLabel
local keeps: TextLabel
local resets: TextLabel
local ascend: TextButton
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

local function makeScreen(): (ScreenGui, TextLabel, TextLabel, TextLabel, TextLabel, TextLabel, TextButton)
    local existing = screens:FindFirstChild("PrestigeScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "PrestigeScreen"
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
    panel.Size = UDim2.fromScale(0.68, 0.68)
    panel.BackgroundColor3 = COLORS.Panel
    panel.BorderSizePixel = 0
    panel.Parent = backdrop
    round(panel, 10)
    outline(panel, COLORS.Gold, 0.5)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 68)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 23, 36)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = panel

    local title = label(titleBar, "Title", "ASCENSION", 22, COLORS.Gold)
    title.Position = UDim2.new(0, 20, 0, 8)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle = label(titleBar, "Subtitle", "Reset the climb. Keep the legacy.", 12, COLORS.Muted)
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

    local createdStatus = label(panel, "Status", "Reading your ascension state…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 24, 0, 84)
    createdStatus.Size = UDim2.new(1, -48, 0, 28)

    local card = Instance.new("Frame")
    card.Name = "ProgressCard"
    card.Position = UDim2.new(0, 24, 0, 124)
    card.Size = UDim2.new(1, -48, 0, 112)
    card.BackgroundColor3 = COLORS.Raised
    card.BorderSizePixel = 0
    card.Parent = panel
    round(card, 8)
    outline(card, COLORS.Cyan, 0.8)

    local createdProgress = label(card, "Progress", "LEVEL — / 100", 22, COLORS.Text)
    createdProgress.Position = UDim2.new(0, 16, 0, 13)
    createdProgress.Size = UDim2.new(0.55, 0, 0, 34)
    createdProgress.Font = Enum.Font.GothamBold
    local createdBonus = label(card, "Bonus", "XP bonus: +0%  →  next: +10%", 13, COLORS.Cyan)
    createdBonus.Position = UDim2.new(0, 16, 0, 55)
    createdBonus.Size = UDim2.new(0.65, 0, 0, 28)
    local rule = label(card, "Rule", "LEVEL 100 REQUIRED", 11, COLORS.Gold)
    rule.Position = UDim2.new(0.67, 0, 0, 34)
    rule.Size = UDim2.new(0.29, -8, 0, 28)
    rule.TextXAlignment = Enum.TextXAlignment.Right

    local keepHeader = label(panel, "KeepsHeader", "KEEPS", 11, COLORS.Green)
    keepHeader.Position = UDim2.new(0, 24, 0, 254)
    keepHeader.Size = UDim2.new(0.45, -24, 0, 20)
    keepHeader.Font = Enum.Font.GothamBold
    local createdKeeps =
        label(panel, "Keeps", "Pets  •  Cosmetics  •  Achievements  •  Gems  •  Guild", 12, COLORS.Text)
    createdKeeps.Position = UDim2.new(0, 24, 0, 276)
    createdKeeps.Size = UDim2.new(0.47, -24, 0, 54)
    createdKeeps.TextYAlignment = Enum.TextYAlignment.Top

    local resetHeader = label(panel, "ResetsHeader", "RESETS", 11, COLORS.Danger)
    resetHeader.Position = UDim2.new(0.53, 0, 0, 254)
    resetHeader.Size = UDim2.new(0.47, -24, 0, 20)
    resetHeader.Font = Enum.Font.GothamBold
    local createdResets =
        label(panel, "Resets", "Level  •  Skills  •  Upgrades  •  Inventory  •  Soft currency", 12, COLORS.Text)
    createdResets.Position = UDim2.new(0.53, 0, 0, 276)
    createdResets.Size = UDim2.new(0.47, -24, 0, 54)
    createdResets.TextYAlignment = Enum.TextYAlignment.Top

    local createdAscend = button(panel, "AscendButton", "ASCEND", Color3.fromRGB(83, 65, 35))
    createdAscend.Position = UDim2.new(0, 24, 1, -60)
    createdAscend.Size = UDim2.new(1, -48, 0, 38)
    createdAscend.TextSize = 14

    return createdScreen, createdStatus, createdProgress, createdBonus, createdKeeps, createdResets, createdAscend
end

screen, status, progress, bonus, keeps, resets, ascend = makeScreen()

local function setUnavailable(message: string)
    status.TextColor3 = COLORS.Danger
    status.Text = message
    ascend.Active = false
    ascend.AutoButtonColor = false
    ascend.Text = "ASCENSION UNAVAILABLE"
end

local function render(snapshot: any)
    if type(snapshot) ~= "table" then
        setUnavailable("Ascension unavailable: invalid server snapshot.")
        return
    end

    local prestige = math.max(0, math.floor(tonumber(snapshot.PrestigeLevel) or 0))
    local maxPrestige = math.max(prestige, math.floor(tonumber(snapshot.MaxPrestige) or 50))
    local level = math.max(1, math.floor(tonumber(snapshot.CurrentLevel) or 1))
    local required = math.max(1, math.floor(tonumber(snapshot.RequiredLevel) or 100))
    local currentBonus = math.max(0, math.floor(tonumber(snapshot.XPBonusPercent) or 0))
    local nextBonus = math.max(currentBonus, math.floor(tonumber(snapshot.NextXPBonusPercent) or currentBonus))
    local canPrestige = snapshot.CanPrestige == true

    status.TextColor3 = canPrestige and COLORS.Green or COLORS.Cyan
    status.Text = string.format(
        "PRESTIGE %d/%d  •  %s",
        prestige,
        maxPrestige,
        tostring(snapshot.Reason or "Server state ready")
    )
    progress.Text = string.format("LEVEL %d / %d", level, required)
    bonus.Text = string.format("XP bonus: +%d%%  →  next: +%d%%", currentBonus, nextBonus)
    keeps.Text = "Pets  •  Cosmetics  •  Achievements  •  Gems  •  Guild"
    resets.Text = "Level  •  Skills  •  Upgrades  •  Inventory  •  Soft currency"
    ascend.Active = canPrestige
    ascend.AutoButtonColor = canPrestige
    ascend.Text = canPrestige and string.format("ASCEND TO PRESTIGE %d", prestige + 1) or "ASCENSION LOCKED"
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server ascension state…"
    local remote = remotes:FindFirstChild("GetPrestige")
    if not remote or not remote:IsA("RemoteFunction") then
        setUnavailable("Ascension unavailable: endpoint is missing.")
        refreshInFlight = false
        return
    end
    local ok, snapshot = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok then
        setUnavailable("Ascension unavailable: server snapshot failed.")
    else
        render(snapshot)
    end
    refreshInFlight = false
end

ascend.Activated:Connect(function()
    if not ascend.Active then
        return
    end
    local remote = remotes:FindFirstChild("RequestPrestige")
    if not remote or not remote:IsA("RemoteEvent") then
        setUnavailable("Ascension unavailable: request endpoint is missing.")
        return
    end
    ascend.Active = false
    ascend.AutoButtonColor = false
    ascend.Text = "ASCENDING…"
    remote:FireServer()
end)

local completed = remotes:FindFirstChild("PrestigeCompleted")
if completed and completed:IsA("RemoteEvent") then
    completed.OnClientEvent:Connect(function(snapshot)
        if screen.Enabled then
            render(snapshot)
            status.TextColor3 = COLORS.Green
            status.Text = "ASCENSION COMPLETE  •  Your legacy is intact."
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
    local existing = nav:FindFirstChild("NavPrestige")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavPrestige", "ASCENSION", Color3.fromRGB(83, 65, 35))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 16
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
    end
end)

wireNav()
print("[PrestigeController] Initialized")
