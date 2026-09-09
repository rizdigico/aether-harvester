--!strict
-- QuestController: renders the server-owned quest catalog and turns the
-- existing QuestLog screen into an actionable accept/deliver/turn-in flow.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local gameClient = require(shared:WaitForChild("Modules"):WaitForChild("GameClient"))

local screen = screens:FindFirstChild("QuestLogScreen")
if not screen or not screen:IsA("ScreenGui") then
    warn("[QuestController] QuestLogScreen is missing")
    return
end

local questList = screen:FindFirstChild("QuestList", true)
local template = questList and questList:FindFirstChild("QuestTemplate")
local emptyState = questList and questList:FindFirstChild("EmptyState")
if
    not questList
    or not questList:IsA("ScrollingFrame")
    or not template
    or not template:IsA("GuiObject")
    or not emptyState
    or not emptyState:IsA("TextLabel")
then
    warn("[QuestController] Quest list template is incomplete")
    return
end

local statusLabel: TextLabel? = nil
local refreshInFlight = false

local function ensureStatus(): TextLabel
    if statusLabel then
        return statusLabel
    end

    local panel = screen:FindFirstChild("Panel", true)
    local result = Instance.new("TextLabel")
    result.Name = "QuestStatus"
    result.BackgroundTransparency = 1
    result.TextColor3 = Color3.fromRGB(140, 220, 255)
    result.Font = Enum.Font.GothamMedium
    result.TextSize = 13
    result.TextXAlignment = Enum.TextXAlignment.Left
    result.Text = ""
    result.Visible = false
    result.Position = UDim2.new(0.03, 0, 0.92, 0)
    result.Size = UDim2.new(0.9, 0, 0.05, 0)
    result.Parent = panel or screen
    statusLabel = result
    return result
end

local function setStatus(message: string, color: Color3?, visible: boolean?)
    local result = ensureStatus()
    result.Text = message
    result.TextColor3 = color or Color3.fromRGB(140, 220, 255)
    result.Visible = visible ~= false
end

local function clearCards()
    for _, child in ipairs(questList:GetChildren()) do
        if child ~= template and child ~= emptyState and not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    emptyState.Visible = false
end

local function progressText(quest: any): string
    local done = 0
    local total = 0
    for index, objective in ipairs(quest.Objectives or {}) do
        local amount = type(objective.Amount) == "number" and objective.Amount or 1
        local current = quest.Progress and quest.Progress[index] or 0
        done += math.min(type(current) == "number" and current or 0, amount)
        total += amount
    end
    return tostring(done) .. "/" .. tostring(total)
end

local function isDeliveryQuest(quest: any): boolean
    for _, objective in ipairs(quest.Objectives or {}) do
        if objective.Type == "Deliver" then
            return true
        end
    end
    return false
end

local function addAction(card: GuiObject, quest: any)
    local action = Instance.new("TextButton")
    action.Name = "QuestAction"
    action.AnchorPoint = Vector2.new(0.5, 0.5)
    action.Position = UDim2.new(0.93, 0, 0.28, 0)
    action.Size = UDim2.new(0.12, 0, 0.38, 0)
    action.BackgroundColor3 = Color3.fromRGB(31, 77, 91)
    action.BorderSizePixel = 0
    action.TextColor3 = Color3.fromRGB(230, 245, 255)
    action.Font = Enum.Font.GothamBold
    action.TextSize = 10
    action.AutoButtonColor = true
    action.Parent = card

    local status = quest.Status
    if status == "Available" then
        action.Text = "ACCEPT"
        action.Activated:Connect(function()
            gameClient:AcceptQuest(quest.Id)
            setStatus("Accepting " .. tostring(quest.Title) .. "…")
        end)
    elseif status == "ReadyToTurnIn" then
        action.Text = "TURN IN"
        action.BackgroundColor3 = Color3.fromRGB(42, 103, 73)
        action.Activated:Connect(function()
            local remote = remotes:FindFirstChild("CompleteQuest")
            if remote then
                remote:FireServer(quest.Id)
                setStatus("Turning in " .. tostring(quest.Title) .. "…")
            end
        end)
    elseif isDeliveryQuest(quest) then
        action.Text = "DELIVER"
        action.Activated:Connect(function()
            gameClient:DeliverQuest(quest.Id)
            setStatus("Delivering items for " .. tostring(quest.Title) .. "…")
        end)
    else
        action.Text = "ACTIVE"
        action.Active = false
        action.AutoButtonColor = false
        action.BackgroundColor3 = Color3.fromRGB(45, 51, 70)
    end
end

local function addQuestCard(quest: any, order: number)
    local card = template:Clone() :: GuiObject
    card.Name = "Quest_" .. tostring(quest.Id)
    card.Visible = true
    card.LayoutOrder = order

    local name = card:FindFirstChild("QuestName")
    if name and name:IsA("TextLabel") then
        name.Text = tostring(quest.Title or quest.Id)
    end

    local description = card:FindFirstChild("QuestDesc")
    if description and description:IsA("TextLabel") then
        description.Text = tostring(quest.Description or quest.Type or "Quest")
    end

    local progress = card:FindFirstChild("QuestProgress")
    if progress and progress:IsA("TextLabel") then
        progress.Text = progressText(quest)
    end

    local check = card:FindFirstChild("QuestCheck")
    if check and check:IsA("TextLabel") then
        check.Visible = quest.Status == "ReadyToTurnIn"
        check.Text = quest.Status == "ReadyToTurnIn" and "OK" or ""
    end

    addAction(card, quest)
    card.Parent = questList
end

local function requestTable(remoteName: string): any
    local remote = remotes:FindFirstChild(remoteName)
    if not remote or not remote:IsA("RemoteFunction") then
        return nil
    end
    local ok, result = pcall(function()
        return remote:InvokeServer()
    end)
    return ok and result or nil
end

local function refresh()
    if refreshInFlight then
        return
    end
    refreshInFlight = true
    setStatus("Loading server quest state…")

    local catalog = requestTable("GetQuestCatalog")
    local active = requestTable("GetQuests")
    if type(catalog) ~= "table" then
        refreshInFlight = false
        emptyState.Text = "Quest service is unavailable"
        emptyState.Visible = true
        setStatus("Quest catalog unavailable.", Color3.fromRGB(255, 130, 130))
        return
    end

    clearCards()
    local count = 0
    for _, quest in ipairs(catalog) do
        if type(quest) == "table" and type(quest.Id) == "string" then
            local activeQuest = type(active) == "table" and active[quest.Id]
            if activeQuest then
                quest.Progress = activeQuest.Progress
                quest.Status = activeQuest.Completed and "ReadyToTurnIn" or "Active"
            end
            count += 1
            addQuestCard(quest, count)
        end
    end

    emptyState.Visible = count == 0
    if count == 0 then
        emptyState.Text = "No quests available at your current level"
    end
    setStatus(tostring(count) .. " server-authoritative quest(s)", Color3.fromRGB(140, 220, 255))
    refreshInFlight = false
end

local closeButton = screen:FindFirstChild("CloseButton", true)
if closeButton and closeButton:IsA("TextButton") then
    closeButton.Activated:Connect(function()
        screen.Enabled = false
    end)
end

local navQuests = aetherUI:FindFirstChild("NavQuests", true)
if navQuests and navQuests:IsA("TextButton") then
    navQuests.Activated:Connect(function()
        gameClient:OpenScreen("QuestLogScreen")
        refresh()
    end)
end

local questUpdated = remotes:FindFirstChild("QuestUpdated")
if questUpdated and questUpdated:IsA("RemoteEvent") then
    questUpdated.OnClientEvent:Connect(function()
        if screen.Enabled then
            task.defer(refresh)
        end
    end)
end

local errorRemote = remotes:FindFirstChild("Error")
if errorRemote and errorRemote:IsA("RemoteEvent") then
    errorRemote.OnClientEvent:Connect(function(message)
        if screen.Enabled then
            setStatus(tostring(message), Color3.fromRGB(255, 130, 130))
            task.defer(refresh)
        end
    end)
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        refresh()
    end
end)

print("[QuestController] Initialized")
