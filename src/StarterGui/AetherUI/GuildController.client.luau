--!strict
-- GuildController: renders the server-backed guild state and its small set of
-- social actions. Guild membership remains authoritative on the server.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local gameClient = require(shared:WaitForChild("Modules"):WaitForChild("GameClient"))
local toast = require(script.Parent.Components.Toast)

local screen = screens:FindFirstChild("GuildScreen")
if not screen then
    return nil
end

local mainFrame = screen:FindFirstChild("MainFrame")
if not mainFrame or not mainFrame:IsA("Frame") then
    return nil
end

local guildInfo = mainFrame:FindFirstChild("GuildInfo")
local memberList = mainFrame:FindFirstChild("MemberList")
if not guildInfo or not guildInfo:IsA("Frame") or not memberList or not memberList:IsA("ScrollingFrame") then
    return nil
end

local uiConnections: { RBXScriptConnection } = {}
local globalConnections: { RBXScriptConnection } = {}
local memberRows: { TextLabel } = {}
local pendingInvite: any = nil
local toastHost: any = nil

local PANEL_COLOR = Color3.fromRGB(47, 54, 77)
local FIELD_COLOR = Color3.fromRGB(33, 37, 54)
local TEXT_COLOR = Color3.fromRGB(230, 235, 245)

local function showToast(message: string, kind: any)
    if toastHost then
        toastHost.Queue({ Text = message, Type = kind })
    else
        toastHost = toast.enqueue(screen, { Text = message, Type = kind })
    end
end

local function clearUiConnections()
    for _, connection in ipairs(uiConnections) do
        connection:Disconnect()
    end
    table.clear(uiConnections)
end

local function clearMemberRows()
    for _, row in ipairs(memberRows) do
        row:Destroy()
    end
    table.clear(memberRows)
end

local function makeTextBox(parent: Instance, name: string, position: UDim2, size: UDim2, placeholder: string): TextBox
    local existing = parent:FindFirstChild(name)
    if existing and existing:IsA("TextBox") then
        return existing
    end
    local field = Instance.new("TextBox")
    field.Name = name
    field.BackgroundColor3 = FIELD_COLOR
    field.BorderSizePixel = 0
    field.Position = position
    field.Size = size
    field.PlaceholderText = placeholder
    field.PlaceholderColor3 = Color3.fromRGB(145, 157, 180)
    field.TextColor3 = TEXT_COLOR
    field.Font = Enum.Font.Gotham
    field.TextSize = 12
    field.ClearTextOnFocus = false
    field.Parent = parent
    return field
end

local function makeButton(parent: Instance, name: string, position: UDim2, size: UDim2, label: string): TextButton
    local existing = parent:FindFirstChild(name)
    if existing and existing:IsA("TextButton") then
        return existing
    end
    local button = Instance.new("TextButton")
    button.Name = name
    button.BackgroundColor3 = PANEL_COLOR
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = size
    button.Text = label
    button.TextColor3 = TEXT_COLOR
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = parent
    return button
end

local function ensureControls(): Frame
    local existing = mainFrame:FindFirstChild("GuildControls")
    if existing and existing:IsA("Frame") then
        return existing
    end
    local controls = Instance.new("Frame")
    controls.Name = "GuildControls"
    controls.BackgroundTransparency = 1
    controls.Position = UDim2.new(0.01, 0, 0.84, 0)
    controls.Size = UDim2.new(0.98, 0, 0.14, 0)
    controls.Parent = mainFrame

    makeTextBox(controls, "GuildNameInput", UDim2.new(0, 0, 0, 0), UDim2.new(0.24, -4, 0.46, 0), "Guild name")
    makeButton(controls, "CreateGuildButton", UDim2.new(0.25, 0, 0, 0), UDim2.new(0.2, -4, 0.46, 0), "CREATE")
    makeTextBox(controls, "GuildIdInput", UDim2.new(0.46, 0, 0, 0), UDim2.new(0.24, -4, 0.46, 0), "Guild invite ID")
    makeButton(controls, "JoinGuildButton", UDim2.new(0.71, 0, 0, 0), UDim2.new(0.2, 0, 0.46, 0), "JOIN")
    makeTextBox(
        controls,
        "InvitePlayerInput",
        UDim2.new(0, 0, 0.52, 0),
        UDim2.new(0.46, -4, 0.46, 0),
        "Nearby player name"
    )
    makeButton(controls, "InvitePlayerButton", UDim2.new(0.47, 0, 0.52, 0), UDim2.new(0.24, -4, 0.46, 0), "INVITE")
    makeButton(controls, "LeaveGuildButton", UDim2.new(0.72, 0, 0.52, 0), UDim2.new(0.19, 0, 0.46, 0), "LEAVE")
    return controls
end

local function ensureInvitePanel(): Frame?
    local existing = mainFrame:FindFirstChild("GuildInvitePanel")
    if existing and existing:IsA("Frame") then
        existing:Destroy()
    end
    if not pendingInvite then
        return nil
    end
    local panel = Instance.new("Frame")
    panel.Name = "GuildInvitePanel"
    panel.BackgroundColor3 = PANEL_COLOR
    panel.BorderSizePixel = 0
    panel.Position = UDim2.new(0.26, 0, 0.075, 0)
    panel.Size = UDim2.new(0.72, 0, 0.11, 0)
    panel.Parent = mainFrame

    local message = Instance.new("TextLabel")
    message.BackgroundTransparency = 1
    message.Position = UDim2.new(0.03, 0, 0, 0)
    message.Size = UDim2.new(0.62, 0, 1, 0)
    message.Text = "Guild invite: " .. tostring(pendingInvite.name)
    message.TextColor3 = TEXT_COLOR
    message.Font = Enum.Font.GothamMedium
    message.TextSize = 12
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.Parent = panel

    local accept =
        makeButton(panel, "AcceptGuildInviteButton", UDim2.new(0.67, 0, 0.15, 0), UDim2.new(0.29, 0, 0.7, 0), "ACCEPT")
    uiConnections[#uiConnections + 1] = accept.MouseButton1Click:Connect(function()
        local join = remotes:FindFirstChild("JoinGuild")
        local guildId = pendingInvite and pendingInvite.guildId
        if join and guildId then
            pendingInvite = nil
            panel:Destroy()
            join:FireServer(guildId)
        end
    end)
    return panel
end

local function fetchGuild(): any
    local getGuildInfo = remotes:FindFirstChild("GetGuildInfo")
    if not getGuildInfo or not getGuildInfo:IsA("RemoteFunction") then
        return nil
    end
    local ok, guild = pcall(function()
        return getGuildInfo:InvokeServer()
    end)
    if ok and type(guild) == "table" then
        return guild
    end
    return nil
end

local function findOnlinePlayer(query: string): Player?
    local normalized = string.lower((string.gsub(query, "^%s*(.-)%s*$", "%1")))
    if normalized == "" then
        return nil
    end
    for _, candidate in ipairs(Players:GetPlayers()) do
        if
            candidate ~= player
            and (string.lower(candidate.Name) == normalized or string.lower(candidate.DisplayName) == normalized)
        then
            return candidate
        end
    end
    return nil
end

local function setVisible(parent: Instance, childName: string, visible: boolean)
    local child = parent:FindFirstChild(childName)
    if child and child:IsA("GuiObject") then
        child.Visible = visible
    end
end

local function render(guild: any)
    local nameLabel = guildInfo:FindFirstChild("GuildName")
    local levelLabel = guildInfo:FindFirstChild("GuildLevel")
    local xpBar = guildInfo:FindFirstChild("GuildXPBar")
    local xpFill = xpBar and xpBar:FindFirstChild("GuildXPFill")
    local controls = ensureControls()
    local descriptionInput: TextBox
    local descriptionInputInstance = controls:FindFirstChild("GuildDescriptionInput")
    if descriptionInputInstance and descriptionInputInstance:IsA("TextBox") then
        descriptionInput = descriptionInputInstance
    else
        descriptionInput = makeTextBox(
            controls,
            "GuildDescriptionInput",
            UDim2.new(0, 0, 0, 0),
            UDim2.new(0.24, -4, 0.46, 0),
            "Description"
        )
    end
    descriptionInput.Visible = false

    if guild then
        if nameLabel and nameLabel:IsA("TextLabel") then
            nameLabel.Text = tostring(guild.Name or "Guild")
        end
        if levelLabel and levelLabel:IsA("TextLabel") then
            levelLabel.Text = "Lv. " .. tostring(guild.Level or 1)
        end
        if xpFill and xpFill:IsA("Frame") then
            local current = tonumber(guild.XP) or 0
            local required = math.max(1, math.floor(500 * math.pow(1.2, (tonumber(guild.Level) or 1) - 1)))
            xpFill.Size = UDim2.new(math.clamp(current / required, 0, 1), 0, 1, 0)
        end
        setVisible(controls, "CreateGuildButton", false)
        setVisible(controls, "JoinGuildButton", false)
        setVisible(controls, "GuildNameInput", false)
        setVisible(controls, "GuildIdInput", false)
        setVisible(controls, "InvitePlayerInput", true)
        setVisible(controls, "InvitePlayerButton", true)
        setVisible(controls, "LeaveGuildButton", true)
    else
        if nameLabel and nameLabel:IsA("TextLabel") then
            nameLabel.Text = "No Guild"
        end
        if levelLabel and levelLabel:IsA("TextLabel") then
            levelLabel.Text = "Join or create one"
        end
        if xpFill and xpFill:IsA("Frame") then
            xpFill.Size = UDim2.new(0, 0, 1, 0)
        end
        setVisible(controls, "CreateGuildButton", true)
        setVisible(controls, "JoinGuildButton", true)
        setVisible(controls, "GuildNameInput", true)
        setVisible(controls, "GuildIdInput", true)
        setVisible(controls, "InvitePlayerInput", false)
        setVisible(controls, "InvitePlayerButton", false)
        setVisible(controls, "LeaveGuildButton", false)
    end

    clearMemberRows()
    local members = guild and guild.Members or {}
    local empty = memberList:FindFirstChild("EmptyState")
    if empty and empty:IsA("TextLabel") then
        empty.Visible = #members == 0
    end
    for index, userId in ipairs(members) do
        local member = Players:GetPlayerByUserId(userId)
        local row = Instance.new("TextLabel")
        row.Name = "Member_" .. tostring(userId)
        row.LayoutOrder = index
        row.Size = UDim2.new(0.95, 0, 0, 30)
        row.BackgroundColor3 = FIELD_COLOR
        row.BorderSizePixel = 0
        row.TextColor3 = TEXT_COLOR
        row.Font = Enum.Font.GothamMedium
        row.TextSize = 13
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.Text = string.format(
            "  %s  •  %s",
            member and member.DisplayName or ("User " .. tostring(userId)),
            userId == guild.OwnerId and "Owner" or "Member"
        )
        row.Parent = memberList
        table.insert(memberRows, row)
    end
    ensureInvitePanel()
end

local function wireScreen()
    local controls = ensureControls()
    local create = controls:FindFirstChild("CreateGuildButton")
    local nameInput = controls:FindFirstChild("GuildNameInput")
    local join = controls:FindFirstChild("JoinGuildButton")
    local guildIdInput = controls:FindFirstChild("GuildIdInput")
    local invite = controls:FindFirstChild("InvitePlayerButton")
    local inviteInput = controls:FindFirstChild("InvitePlayerInput")
    local leave = controls:FindFirstChild("LeaveGuildButton")

    if create and create:IsA("TextButton") and nameInput and nameInput:IsA("TextBox") then
        uiConnections[#uiConnections + 1] = create.MouseButton1Click:Connect(function()
            local name = nameInput.Text
            if #name < 3 then
                showToast("Guild name must be at least 3 characters", "warning")
                return
            end
            local remote = remotes:FindFirstChild("CreateGuild")
            if remote then
                remote:FireServer(name, "")
            end
        end)
    end
    if join and join:IsA("TextButton") and guildIdInput and guildIdInput:IsA("TextBox") then
        uiConnections[#uiConnections + 1] = join.MouseButton1Click:Connect(function()
            local guildId = string.gsub(guildIdInput.Text, "^%s*(.-)%s*$", "%1")
            if guildId == "" then
                showToast("Enter a guild ID", "warning")
                return
            end
            local remote = remotes:FindFirstChild("JoinGuild")
            if remote then
                remote:FireServer(guildId)
            end
        end)
    end
    if invite and invite:IsA("TextButton") and inviteInput and inviteInput:IsA("TextBox") then
        uiConnections[#uiConnections + 1] = invite.MouseButton1Click:Connect(function()
            local target = findOnlinePlayer(inviteInput.Text)
            if not target then
                showToast("Enter an online player name", "warning")
                return
            end
            local remote = remotes:FindFirstChild("InviteToGuild")
            if remote then
                remote:FireServer(target.UserId)
                showToast("Invite sent", "info")
            end
        end)
    end
    if leave and leave:IsA("TextButton") then
        uiConnections[#uiConnections + 1] = leave.MouseButton1Click:Connect(function()
            local remote = remotes:FindFirstChild("LeaveGuild")
            if remote then
                remote:FireServer()
            end
        end)
    end
    render(fetchGuild())
end

local function refreshIfOpen()
    if screen.Enabled then
        clearUiConnections()
        wireScreen()
    end
end

local function wireGlobalEvents()
    local guildCreated = remotes:FindFirstChild("GuildCreated")
    if guildCreated and guildCreated:IsA("RemoteEvent") then
        globalConnections[#globalConnections + 1] = guildCreated.OnClientEvent:Connect(function()
            showToast("Guild created", "success")
            refreshIfOpen()
        end)
    end
    local memberJoined = remotes:FindFirstChild("GuildMemberJoined")
    if memberJoined and memberJoined:IsA("RemoteEvent") then
        globalConnections[#globalConnections + 1] = memberJoined.OnClientEvent:Connect(function(guildId)
            local guild = fetchGuild()
            if guild and guild.Id == guildId then
                refreshIfOpen()
            end
        end)
    end
    local memberLeft = remotes:FindFirstChild("GuildMemberLeft")
    if memberLeft and memberLeft:IsA("RemoteEvent") then
        globalConnections[#globalConnections + 1] = memberLeft.OnClientEvent:Connect(function(guildId)
            local guild = fetchGuild()
            if (guild and guild.Id == guildId) or not guild then
                refreshIfOpen()
            end
        end)
    end
    local guildInvite = remotes:FindFirstChild("GuildInvite")
    if guildInvite and guildInvite:IsA("RemoteEvent") then
        globalConnections[#globalConnections + 1] = guildInvite.OnClientEvent:Connect(function(guildId, guildName)
            pendingInvite = { guildId = guildId, name = guildName }
            if not screen.Enabled then
                gameClient:OpenScreen("GuildScreen")
            else
                refreshIfOpen()
            end
            showToast("New guild invite", "info")
        end)
    end
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    clearUiConnections()
    if screen.Enabled then
        wireScreen()
    end
end)

wireGlobalEvents()
if screen.Enabled then
    wireScreen()
end

print("[GuildController] Initialized")
