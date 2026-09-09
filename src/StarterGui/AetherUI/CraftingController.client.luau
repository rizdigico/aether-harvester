--!strict
-- CraftingController: turns InventoryScreen's CRAFTING tab into a real,
-- server-authoritative crafting surface. Recipe availability and ingredient
-- ownership are calculated server-side; this script only renders and requests.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local inventoryScreen = screens:WaitForChild("InventoryScreen")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local itemsData = require(shared:WaitForChild("Data"):WaitForChild("Items"))

local content = inventoryScreen:FindFirstChild("Content", true)
local tabBar = inventoryScreen:FindFirstChild("TabBar", true)
local template = content and content:FindFirstChild("ItemTemplate")
local emptyState = content and content:FindFirstChild("EmptyState")

if
    not content
    or not content:IsA("ScrollingFrame")
    or not template
    or not template:IsA("GuiObject")
    or not emptyState
    or not emptyState:IsA("TextLabel")
then
    warn("[CraftingController] Inventory crafting surface is incomplete")
    return
end

local status: TextLabel? = nil
local requestInFlight = false

local function ensureStatus(): TextLabel
    if status then
        return status
    end

    local panel = inventoryScreen:FindFirstChild("Panel", true)
    local result = Instance.new("TextLabel")
    result.Name = "CraftingStatus"
    result.BackgroundTransparency = 1
    result.TextColor3 = Color3.fromRGB(140, 220, 255)
    result.Font = Enum.Font.GothamMedium
    result.TextSize = 13
    result.TextXAlignment = Enum.TextXAlignment.Left
    result.Text = ""
    result.Visible = false
    result.Position = UDim2.new(0.03, 0, 0.94, 0)
    result.Size = UDim2.new(0.94, 0, 0.04, 0)
    result.Parent = panel or inventoryScreen
    status = result
    return result
end

local function setStatus(message: string, color: Color3?, visible: boolean?)
    local result = ensureStatus()
    result.Text = message
    result.TextColor3 = color or Color3.fromRGB(140, 220, 255)
    result.Visible = visible ~= false
end

local function clearCards()
    for _, child in ipairs(content:GetChildren()) do
        if child ~= template and child ~= emptyState and not child:IsA("UIGridLayout") then
            child:Destroy()
        end
    end
    emptyState.Visible = false
end

local function formatIngredients(recipe: any): string
    local parts = {}
    for _, ingredient in ipairs(recipe.Ingredients or {}) do
        local definition = itemsData.GetItem(ingredient.ItemId)
        local name = definition and definition.Name or ingredient.ItemId
        table.insert(parts, tostring(ingredient.Amount) .. " " .. name)
    end
    return table.concat(parts, " • ")
end

local function addRecipeCard(recipe: any, order: number)
    local card = template:Clone() :: GuiObject
    card.Name = "Recipe_" .. tostring(recipe.Id)
    card.Visible = true
    card.LayoutOrder = order

    local name = card:FindFirstChild("ItemName")
    if name and name:IsA("TextLabel") then
        name.Text = tostring(recipe.Name or recipe.Id)
    end

    local requirements = card:FindFirstChild("ItemCount")
    if requirements and requirements:IsA("TextLabel") then
        requirements.Text = formatIngredients(recipe)
        requirements.TextWrapped = true
        requirements.TextYAlignment = Enum.TextYAlignment.Top
    end

    local icon = card:FindFirstChild("Icon")
    if icon and icon:IsA("ImageLabel") then
        icon.BackgroundColor3 = Color3.fromRGB(100, 220, 255)
        icon.Image = ""
    end

    local craft = Instance.new("TextButton")
    craft.Name = "CraftButton"
    craft.AnchorPoint = Vector2.new(0.5, 1)
    craft.Position = UDim2.new(0.5, 0, 0.97, 0)
    craft.Size = UDim2.new(0.82, 0, 0.22, 0)
    craft.BackgroundColor3 = Color3.fromRGB(31, 77, 91)
    craft.BorderSizePixel = 0
    craft.TextColor3 = Color3.fromRGB(230, 245, 255)
    craft.Font = Enum.Font.GothamBold
    craft.TextSize = 11
    craft.Text = "CRAFT"
    craft.AutoButtonColor = true
    craft.Parent = card

    local busy = false
    craft.Activated:Connect(function()
        if busy then
            return
        end
        local remote = remotes:FindFirstChild("CraftItem")
        if not remote then
            setStatus("Crafting is unavailable: server remote is missing.", Color3.fromRGB(255, 130, 130))
            return
        end
        busy = true
        craft.Text = "CHECKING..."
        setStatus("Checking ingredients on the server…")
        remote:FireServer(recipe.Id)
        task.delay(1, function()
            if craft.Parent then
                busy = false
                craft.Text = "CRAFT"
            end
        end)
    end)
    card.Parent = content
end

local function renderRecipes(recipes: any)
    requestInFlight = false
    clearCards()
    if type(recipes) ~= "table" or #recipes == 0 then
        emptyState.Text = "No recipes are unlocked at your current level"
        emptyState.Visible = true
        setStatus("Unlock more recipes by leveling up.", Color3.fromRGB(170, 180, 200))
        return
    end

    emptyState.Text = ""
    for index, recipe in ipairs(recipes) do
        if type(recipe) == "table" and type(recipe.Id) == "string" then
            addRecipeCard(recipe, index)
        end
    end
    setStatus(tostring(#recipes) .. " server-available recipe(s)", Color3.fromRGB(140, 220, 255))
end

local function requestRecipes()
    if requestInFlight then
        return
    end
    local remote = remotes:FindFirstChild("RequestRecipes")
    if not remote then
        setStatus("Crafting is unavailable: recipe remote is missing.", Color3.fromRGB(255, 130, 130))
        return
    end
    requestInFlight = true
    setStatus("Loading server recipes…")
    remote:FireServer()
end

local itemCrafted = remotes:FindFirstChild("ItemCrafted")
if itemCrafted then
    itemCrafted.OnClientEvent:Connect(function(resultId, payload)
        if resultId == "recipes" and type(payload) == "table" then
            renderRecipes(payload)
            return
        end
        if type(resultId) == "string" then
            setStatus("Crafted " .. resultId .. " successfully.", Color3.fromRGB(130, 240, 170))
            task.defer(requestRecipes)
        end
    end)
end

local errorRemote = remotes:FindFirstChild("Error")
if errorRemote then
    errorRemote.OnClientEvent:Connect(function(message)
        if inventoryScreen.Enabled then
            setStatus(tostring(message), Color3.fromRGB(255, 130, 130))
        end
    end)
end

if tabBar then
    local tab = tabBar:FindFirstChild("TabCrafting")
    if tab and tab:IsA("TextButton") then
        tab.Activated:Connect(function()
            requestRecipes()
        end)
    end
end

inventoryScreen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if not inventoryScreen.Enabled then
        requestInFlight = false
    end
end)

print("[CraftingController] Initialized")
