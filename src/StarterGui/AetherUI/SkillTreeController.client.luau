--!strict
-- SkillTreeController: renders the server-owned skill catalog and sends
-- bounded rank requests. Skill points, gates, and effects are authoritative
-- on the server; this screen only provides presentation and input.

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local remotes = game:GetService("ReplicatedStorage"):WaitForChild("AetherShared"):WaitForChild("Remotes")
local toast = require(script.Parent.Components.Toast)

local screen = screens:FindFirstChild("SkillTreeScreen")
if not screen then
    return nil
end

local mainFrame = screen:FindFirstChild("MainFrame")
local canvas = mainFrame and mainFrame:FindFirstChild("SkillCanvas")
local template = canvas and canvas:FindFirstChild("SkillNodeTemplate")
local detail = mainFrame and mainFrame:FindFirstChild("SkillDetail")
if
    not mainFrame
    or not mainFrame:IsA("Frame")
    or not canvas
    or not canvas:IsA("ScrollingFrame")
    or not template
    or not template:IsA("Frame")
    or not detail
    or not detail:IsA("Frame")
then
    return nil
end

local nodeRows: { Frame } = {}
local uiConnections: { RBXScriptConnection } = {}
local skills: { [string]: any } = {}
local levels: { [string]: number } = {}
local skillPoints = 0
local playerLevel = 1
local selectedId: string? = nil
local toastHost: any = nil

local function showToast(message: string, kind: any)
    if toastHost then
        toastHost.Queue({ Text = message, Type = kind })
    else
        toastHost = toast.enqueue(screen, { Text = message, Type = kind })
    end
end

local function clearNodes()
    for _, connection in ipairs(uiConnections) do
        connection:Disconnect()
    end
    table.clear(uiConnections)
    for _, node in ipairs(nodeRows) do
        node:Destroy()
    end
    table.clear(nodeRows)
end

local function getDetailLabel(name: string): TextLabel?
    local label = detail:FindFirstChild(name)
    if label and label:IsA("TextLabel") then
        return label
    end
    return nil
end

local function getLevel(skillId: string): number
    return math.max(0, math.floor(tonumber(levels[skillId]) or 0))
end

local function prerequisitesReady(definition: any): boolean
    for _, prerequisite in ipairs(definition.Prerequisites or {}) do
        if getLevel(prerequisite.Id) < (tonumber(prerequisite.Level) or 0) then
            return false
        end
    end
    return true
end

local function canPurchase(definition: any): boolean
    return getLevel(definition.Id) < (tonumber(definition.MaxLevel) or 1)
        and skillPoints > 0
        and playerLevel >= (tonumber(definition.RequiredLevel) or 1)
        and prerequisitesReady(definition)
end

local function renderDetail()
    local definition = selectedId and skills[selectedId]
    local title = getDetailLabel("DetailTitle")
    local description = getDetailLabel("DetailDesc")
    local unlock = detail:FindFirstChild("UnlockButton")
    if not definition then
        if title then
            title.Text = "Select a skill"
        end
        if description then
            description.Text = "Choose a node to inspect its real progression gates."
        end
        return
    end

    local level = getLevel(definition.Id)
    local maxLevel = tonumber(definition.MaxLevel) or 1
    local requiredLevel = tonumber(definition.RequiredLevel) or 1
    local gate = "Ready"
    if level >= maxLevel then
        gate = "MAXED"
    elseif playerLevel < requiredLevel then
        gate = "Requires player level " .. tostring(requiredLevel)
    elseif not prerequisitesReady(definition) then
        gate = "Prerequisite rank required"
    elseif skillPoints <= 0 then
        gate = "No skill points available"
    end

    if title then
        title.Text = string.format("%s  •  Lv. %d/%d", definition.Name or definition.Id, level, maxLevel)
    end
    if description then
        description.Text = string.format(
            "%s\nBranch: %s\n%s\nAvailable skill points: %d",
            definition.Description or "",
            definition.Branch or "Fieldwork",
            gate,
            skillPoints
        )
    end
    if unlock and unlock:IsA("TextButton") then
        unlock.Text = level >= maxLevel and "MAXED" or (canPurchase(definition) and "UNLOCK" or gate:upper())
        unlock.Active = canPurchase(definition)
        unlock.AutoButtonColor = unlock.Active
    end
end

local function renderNodes()
    clearNodes()
    local ids: { string } = {}
    for id in pairs(skills) do
        table.insert(ids, id)
    end
    table.sort(ids, function(left, right)
        local leftDefinition = skills[left]
        local rightDefinition = skills[right]
        local leftBranch = tostring(leftDefinition.Branch or "")
        local rightBranch = tostring(rightDefinition.Branch or "")
        if leftBranch == rightBranch then
            return left < right
        end
        return leftBranch < rightBranch
    end)
    local columns = 2
    local cellWidth = 0.46
    local cellHeight = 82
    local rowCount = math.ceil(#ids / columns)
    canvas.CanvasSize = UDim2.new(0, 0, 0, math.max(360, rowCount * cellHeight + 30))

    for index, id in ipairs(ids) do
        local definition = skills[id]
        local node = template:Clone()
        node.Name = "Skill_" .. id
        node.Visible = true
        local level = getLevel(id)
        local maxLevel = tonumber(definition.MaxLevel) or 1
        node.BackgroundColor3 = id == selectedId and Color3.fromRGB(54, 91, 128)
            or level >= maxLevel and Color3.fromRGB(74, 130, 100)
            or canPurchase(definition) and Color3.fromRGB(255, 183, 77)
            or Color3.fromRGB(88, 92, 105)
        node.Position = UDim2.new(
            0.04 + ((index - 1) % columns) * cellWidth,
            0,
            0,
            15 + math.floor((index - 1) / columns) * cellHeight
        )
        node.Size = UDim2.new(cellWidth - 0.03, 0, 0, 62)
        local nodeLabel = node:FindFirstChild("NodeLabel")
        if nodeLabel and nodeLabel:IsA("TextLabel") then
            nodeLabel.Text =
                string.format("%s\n%s\n%d/%d", definition.Name or id, definition.Branch or "Fieldwork", level, maxLevel)
        end
        local clickTarget = Instance.new("TextButton")
        clickTarget.Name = "Select"
        clickTarget.BackgroundTransparency = 1
        clickTarget.Size = UDim2.fromScale(1, 1)
        clickTarget.Text = ""
        clickTarget.Parent = node
        clickTarget.MouseButton1Click:Connect(function()
            selectedId = id
            renderNodes()
            renderDetail()
        end)
        node.Parent = canvas
        table.insert(nodeRows, node)
    end
end

local function fetchState()
    local getSkillTree = remotes:FindFirstChild("GetSkillTree")
    if not getSkillTree or not getSkillTree:IsA("RemoteFunction") then
        return
    end
    local ok, result = pcall(function()
        return getSkillTree:InvokeServer()
    end)
    if not ok or type(result) ~= "table" then
        return
    end
    skills = type(result.Catalog) == "table" and result.Catalog or {}
    levels = type(result.Levels) == "table" and result.Levels or {}
    skillPoints = math.max(0, math.floor(tonumber(result.SkillPoints) or 0))
    playerLevel = math.max(1, math.floor(tonumber(result.PlayerLevel) or 1))
    if selectedId and not skills[selectedId] then
        selectedId = nil
    end
    if not selectedId then
        for id in pairs(skills) do
            selectedId = id
            break
        end
    end
end

local function render()
    fetchState()
    renderNodes()
    renderDetail()
    local unlock = detail:FindFirstChild("UnlockButton")
    if unlock and unlock:IsA("TextButton") then
        uiConnections[#uiConnections + 1] = unlock.MouseButton1Click:Connect(function()
            if selectedId then
                local purchase = remotes:FindFirstChild("PurchaseSkill")
                if purchase and purchase:IsA("RemoteEvent") and canPurchase(skills[selectedId]) then
                    purchase:FireServer(selectedId)
                end
            end
        end)
    end
end

local skillPurchased = remotes:FindFirstChild("SkillPurchased")
if skillPurchased and skillPurchased:IsA("RemoteEvent") then
    skillPurchased.OnClientEvent:Connect(function(skillId, level, snapshot)
        if type(snapshot) == "table" then
            skills = type(snapshot.Catalog) == "table" and snapshot.Catalog or skills
            levels = type(snapshot.Levels) == "table" and snapshot.Levels or levels
            skillPoints = math.max(0, math.floor(tonumber(snapshot.SkillPoints) or skillPoints))
            playerLevel = math.max(1, math.floor(tonumber(snapshot.PlayerLevel) or playerLevel))
        elseif type(skillId) == "string" then
            levels[skillId] = tonumber(level) or levels[skillId]
            skillPoints = math.max(0, skillPoints - 1)
        end
        showToast("Skill rank unlocked", "success")
        if screen.Enabled then
            render()
        end
    end)
end

local errorRemote = remotes:FindFirstChild("Error")
if errorRemote and errorRemote:IsA("RemoteEvent") then
    errorRemote.OnClientEvent:Connect(function(message)
        showToast(tostring(message), "error")
    end)
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        render()
    else
        clearNodes()
    end
end)

if screen.Enabled then
    render()
end

print("[SkillTreeController] Initialized")
