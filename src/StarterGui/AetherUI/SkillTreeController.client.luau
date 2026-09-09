--!strict
-- SkillTreeController: renders the server-owned upgrade catalog and sends
-- unlock requests. Currency, levels, and affordability are revalidated by the
-- server's UpgradeService.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local upgradeMath = require(shared:WaitForChild("Modules"):WaitForChild("UpgradeMath"))
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
local upgrades: any = {}
local purchased: any = {}
local playerCurrency = 0
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

local function getCost(definition: any, level: number): number
    return upgradeMath.CalculateCost(
        tonumber(definition.BaseCost and definition.BaseCost.AetherShards) or 0,
        tonumber(definition.CostMultiplier) or 1,
        level
    )
end

local function renderDetail()
    local definition = selectedId and upgrades[selectedId]
    local title = getDetailLabel("DetailTitle")
    local description = getDetailLabel("DetailDesc")
    local unlock = detail:FindFirstChild("UnlockButton")
    if not definition then
        if title then
            title.Text = "Select a skill"
        end
        if description then
            description.Text = "Click a skill node to see details."
        end
        return
    end
    local level = math.max(0, math.floor(tonumber(purchased[selectedId]) or 0))
    local cost = getCost(definition, level)
    if title then
        title.Text = string.format("%s  •  Lv. %d/%d", definition.Name or selectedId, level, definition.MaxLevel or 1)
    end
    if description then
        description.Text =
            string.format("%s\nCost: %d Aether Shards\nBalance: %d", definition.Description or "", cost, playerCurrency)
    end
    if unlock and unlock:IsA("TextButton") then
        if level >= (definition.MaxLevel or 1) then
            unlock.Text = "MAXED"
            unlock.Active = false
        elseif playerCurrency < cost then
            unlock.Text = "NOT ENOUGH SHARDS"
            unlock.Active = false
        else
            unlock.Text = "UNLOCK"
            unlock.Active = true
        end
    end
end

local function renderNodes()
    clearNodes()
    local ids: { string } = {}
    for id in pairs(upgrades) do
        table.insert(ids, id)
    end
    table.sort(ids)
    local columns = 3
    local cellWidth = 0.29
    local cellHeight = 80
    local rowCount = math.ceil(#ids / columns)
    canvas.CanvasSize = UDim2.new(0, 0, 0, math.max(360, rowCount * cellHeight + 30))

    for index, id in ipairs(ids) do
        local definition = upgrades[id]
        local node = template:Clone()
        node.Name = "Skill_" .. id
        node.Visible = true
        node.BackgroundColor3 = id == selectedId and Color3.fromRGB(54, 91, 128) or Color3.fromRGB(255, 183, 77)
        node.Position = UDim2.new(
            0.04 + ((index - 1) % columns) * cellWidth,
            0,
            0,
            15 + math.floor((index - 1) / columns) * cellHeight
        )
        node.Size = UDim2.new(cellWidth - 0.03, 0, 0, 58)
        local nodeLabel = node:FindFirstChild("NodeLabel")
        if nodeLabel and nodeLabel:IsA("TextLabel") then
            local level = math.max(0, math.floor(tonumber(purchased[id]) or 0))
            nodeLabel.Text = string.format("%s\n%d/%d", definition.Name or id, level, definition.MaxLevel or 1)
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
    local getUpgrades = remotes:FindFirstChild("GetUpgrades")
    if getUpgrades and getUpgrades:IsA("RemoteFunction") then
        local ok, result = pcall(function()
            return getUpgrades:InvokeServer()
        end)
        if ok and type(result) == "table" then
            upgrades = type(result.Database) == "table" and result.Database or {}
            purchased = type(result.Purchased) == "table" and result.Purchased or {}
        end
    end
    local getPlayerData = remotes:FindFirstChild("GetPlayerData")
    if getPlayerData and getPlayerData:IsA("RemoteFunction") then
        local ok, data = pcall(function()
            return getPlayerData:InvokeServer()
        end)
        if ok and type(data) == "table" then
            local currency = type(data.Currency) == "table" and data.Currency.AetherShards or 0
            playerCurrency = math.max(0, math.floor(tonumber(currency) or 0))
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
            if not selectedId then
                return
            end
            local purchase = remotes:FindFirstChild("PurchaseUpgrade")
            if purchase and purchase:IsA("RemoteEvent") then
                purchase:FireServer(selectedId)
            end
        end)
    end
end

local purchaseEvent = remotes:FindFirstChild("UpgradePurchased")
if purchaseEvent and purchaseEvent:IsA("RemoteEvent") then
    purchaseEvent.OnClientEvent:Connect(function(upgradeId, level, currency)
        if type(upgradeId) == "string" then
            purchased[upgradeId] = tonumber(level) or purchased[upgradeId]
        end
        if type(currency) == "table" then
            playerCurrency = tonumber(currency.AetherShards) or playerCurrency
        end
        showToast("Upgrade purchased", "success")
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
