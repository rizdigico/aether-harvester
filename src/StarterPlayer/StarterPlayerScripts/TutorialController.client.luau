-- Client presentation for the server-owned first-five-minutes guide.
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local remotes = game.ReplicatedStorage.AetherShared.Remotes
local tutorialUpdated = remotes:WaitForChild("TutorialUpdated")
local tutorialAction = remotes:WaitForChild("TutorialAction")
local getTutorial = remotes:WaitForChild("GetTutorial")

local function createLabel(parent, name, size, position, textSize, color)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextSize = textSize
    label.Font = Enum.Font.GothamMedium
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local overlay = Instance.new("ScreenGui")
overlay.Name = "TutorialOverlay"
overlay.DisplayOrder = 25
overlay.ResetOnSpawn = false
overlay.IgnoreGuiInset = false
overlay.Enabled = false
overlay.Parent = aetherUI

local card = Instance.new("Frame")
card.Name = "Card"
card.AnchorPoint = Vector2.new(0.5, 0)
card.Position = UDim2.fromScale(0.5, 0.08)
card.Size = UDim2.fromScale(0.38, 0.14)
card.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
card.BackgroundTransparency = 0.08
card.BorderSizePixel = 0
card.Parent = overlay

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = card

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 220, 255)
stroke.Transparency = 0.35
stroke.Parent = card

local title = createLabel(
    card,
    "Title",
    UDim2.fromScale(0.9, 0.28),
    UDim2.fromScale(0.05, 0.08),
    20,
    Color3.fromRGB(130, 235, 255)
)
local body = createLabel(
    card,
    "Body",
    UDim2.fromScale(0.9, 0.42),
    UDim2.fromScale(0.05, 0.36),
    15,
    Color3.fromRGB(230, 236, 248)
)
local progress = createLabel(
    card,
    "Progress",
    UDim2.fromScale(0.9, 0.14),
    UDim2.fromScale(0.05, 0.81),
    12,
    Color3.fromRGB(150, 165, 190)
)

local movementReported = false

local function render(snapshot)
    if type(snapshot) ~= "table" then
        return
    end
    if snapshot.Completed == true then
        overlay.Enabled = false
        return
    end
    title.Text = tostring(snapshot.Title or "Expedition guide")
    body.Text = tostring(snapshot.Body or "Follow the next objective.")
    progress.Text = string.format("Step %d/%d", tonumber(snapshot.Progress) or 0, tonumber(snapshot.TotalSteps) or 5)
    overlay.Enabled = true
end

tutorialUpdated.OnClientEvent:Connect(render)

local function requestSnapshot()
    for _ = 1, 6 do
        local ok, snapshot = pcall(function()
            return getTutorial:InvokeServer()
        end)
        if ok and type(snapshot) == "table" then
            render(snapshot)
            return
        end
        task.wait(1)
    end
end

task.spawn(requestSnapshot)

local function watchCharacter(character)
    movementReported = false
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then
        return
    end
    humanoid.Running:Connect(function(speed)
        if movementReported or speed <= 0.5 then
            return
        end
        movementReported = true
        tutorialAction:FireServer("Move")
    end)
end

if player.Character then
    task.spawn(watchCharacter, player.Character)
end
player.CharacterAdded:Connect(watchCharacter)
