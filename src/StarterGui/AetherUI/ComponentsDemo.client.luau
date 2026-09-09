--!strict
-- ComponentsDemo.client.luau
-- Visual QA showcase for AetherUI component library.
-- Demonstrates 8+ components in a single screen.

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

local Theme = require(script.Parent.Components.Theme)
local Button = require(script.Parent.Components.Button)
local Card = require(script.Parent.Components.Card)
local LoadingSpinner = require(script.Parent.Components.LoadingSpinner)
local EmptyState = require(script.Parent.Components.EmptyState)
local Tooltip = require(script.Parent.Components.Tooltip)
local Modal = require(script.Parent.Components.Modal)
local Toast = require(script.Parent.Components.Toast)
local TabBar = require(script.Parent.Components.TabBar)
local Slider = require(script.Parent.Components.Slider)
local Toggle = require(script.Parent.Components.Toggle)
local Input = require(script.Parent.Components.Input)
local Badge = require(script.Parent.Components.Badge)
local ProgressBar = require(script.Parent.Components.ProgressBar)
local CurrencyDisplay = require(script.Parent.Components.CurrencyDisplay)
local ListItem = require(script.Parent.Components.ListItem)
local ScrollContainer = require(script.Parent.Components.ScrollContainer)

-- root screen
local screen = Instance.new("ScreenGui")
screen.Name = "AetherComponentsDemo"
screen.Parent = PlayerGui

local root = Instance.new("Frame")
root.Name = "Root"
root.Size = UDim2.new(1, 0, 1, 0)
root.BackgroundColor3 = Theme.Color.BG_DEEP
root.Parent = screen

local scroll = ScrollContainer.new({
    Parent = root,
    Size = UDim2.new(1, 0, 1, 0),
})

-- canvas inside scroll
local canvas = Instance.new("Frame")
canvas.Name = "Canvas"
canvas.Size = UDim2.new(1, 0, 0, 0)
canvas.AutomaticSize = Enum.AutomaticSize.Y
canvas.BackgroundTransparency = 1
canvas.Parent = scroll

local canvasLayout = Instance.new("UIListLayout")
canvasLayout.Padding = UDim.new(0, Theme.Spacing.SP6)
canvasLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
canvasLayout.VerticalAlignment = Enum.VerticalAlignment.Top
canvasLayout.Parent = canvas

-- title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 48)
title.BackgroundTransparency = 1
title.Text = "AetherUI Components Demo"
title.TextColor3 = Theme.Color.TEXT_PRIMARY
title.Font = Theme.Font.H1.Weight
title.TextSize = Theme.Font.H1.Size
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Top
title.Parent = canvas

-- sections container
local sections = Instance.new("Frame")
sections.Name = "Sections"
sections.Size = UDim2.new(1, -Theme.Spacing.SP10, 0, 0)
sections.AutomaticSize = Enum.AutomaticSize.Y
sections.BackgroundTransparency = 1
sections.Parent = canvas

local sectionsLayout = Instance.new("UIListLayout")
sectionsLayout.Padding = UDim.new(0, Theme.Spacing.SP6)
sectionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sectionsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
sectionsLayout.Parent = sections

local function section(titleText: string): Frame
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = titleText
    sectionFrame.Size = UDim2.new(1, -Theme.Spacing.SP10, 0, 0)
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.BackgroundColor3 = Theme.Color.BG_BASE
    sectionFrame.Parent = sections

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.Radius.LG)
    corner.Parent = sectionFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Color.BORDER_SUBTLE
    stroke.Thickness = Theme.Stroke.THIN
    stroke.Parent = sectionFrame

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP6)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP6)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP6)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP6)
    pad.Parent = sectionFrame

    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundTransparency = 1
    header.Text = titleText
    header.TextColor3 = Theme.Color.TEXT_PRIMARY
    header.Font = Theme.Font.H2.Weight
    header.TextSize = Theme.Font.H2.Size
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Top
    header.LayoutOrder = 1
    header.Parent = sectionFrame

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.BackgroundTransparency = 1
    body.LayoutOrder = 2
    body.Parent = sectionFrame

    return body
end

-- Section: Buttons
local btnSection = section("Buttons")
local btnLayout = Instance.new("UIListLayout")
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.Padding = UDim.new(0, Theme.Spacing.SP4)
btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
btnLayout.Parent = btnSection

local buttonVariants: { Button.ButtonVariant } = { "primary", "secondary", "danger", "ghost" }
for _, variant in buttonVariants do
    Button.new({
        Text = variant:gsub("^%l", string.upper),
        Variant = variant :: Button.ButtonVariant,
        Size = "medium",
        Parent = btnSection,
        OnClick = function()
            Toast.new({ Text = variant .. " clicked", Type = "info", Parent = root })
        end,
    })
end

-- Section: Panel + Cards
local cardSection = section("Cards & Panels")
local cardLayout = Instance.new("UIListLayout")
cardLayout.FillDirection = Enum.FillDirection.Horizontal
cardLayout.Padding = UDim.new(0, Theme.Spacing.SP4)
cardLayout.VerticalAlignment = Enum.VerticalAlignment.Top
cardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
cardLayout.Parent = cardSection

Card.new({
    Title = "Aether Blade",
    Subtitle = "Rare weapon",
    Rarity = "rare",
    Badge = "Lv.5",
    Size = UDim2.new(0, 140, 0, 160),
    Parent = cardSection,
})

Card.new({
    Title = "Mythril Core",
    Subtitle = "Mythril material",
    Rarity = "mythril",
    Badge = "NEW",
    Size = UDim2.new(0, 140, 0, 160),
    Parent = cardSection,
})

-- Section: Toggles & Inputs
local formSection = section("Forms")
local formLayout = Instance.new("UIListLayout")
formLayout.Padding = UDim.new(0, Theme.Spacing.SP3)
formLayout.VerticalAlignment = Enum.VerticalAlignment.Top
formLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
formLayout.Parent = formSection

Toggle.new({
    Label = "Enable particles",
    Value = true,
    Parent = formSection,
    OnChanged = function(v)
        Toast.new({ Text = "Particles: " .. tostring(v), Type = "success", Parent = root })
    end,
})

Toggle.new({
    Label = "Reduced motion",
    Value = false,
    Parent = formSection,
})

Input.new({
    Placeholder = "Enter code…",
    Parent = formSection,
    OnChanged = function(v)
        print("Input changed: " .. v)
    end,
})

-- Section: Slider & Progress
local sliderSection = section("Sliders & Progress")
local sliderLayout = Instance.new("UIListLayout")
sliderLayout.Padding = UDim.new(0, Theme.Spacing.SP3)
sliderLayout.VerticalAlignment = Enum.VerticalAlignment.Top
sliderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
sliderLayout.Parent = sliderSection

Slider.new({
    Min = 0,
    Max = 100,
    Value = 65,
    Parent = sliderSection,
    OnChanged = function(_value)
        -- real-time feedback optional
    end,
})

ProgressBar.new({
    Value = 7,
    Max = 10,
    Label = "Harvest progress",
    Parent = sliderSection,
})

-- Section: Tabs & List
local tabSection = section("Tabs & Lists")
TabBar.new({
    Tabs = { "All", "Weapons", "Tools", "Pets" },
    ActiveTab = 1,
    Parent = tabSection,
})

local listFrame = Instance.new("Frame")
listFrame.Name = "List"
listFrame.Size = UDim2.new(1, 0, 0, 0)
listFrame.AutomaticSize = Enum.AutomaticSize.Y
listFrame.BackgroundTransparency = 1
listFrame.Parent = tabSection

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, Theme.Spacing.SP2)
listLayout.Parent = listFrame

for i, item in { "Iron Ore", "Aether Shard", "Mythril Ingot" } do
    ListItem.new({
        Title = item,
        Subtitle = "Material · Common",
        RightText = "x" .. (10 - i),
        Parent = listFrame,
        Last = i == 3,
        OnClick = function()
            Toast.new({ Text = item .. " selected", Type = "info", Parent = root })
        end,
    })
end

-- Section: Badges & Currency
local badgeSection = section("Badges & Currency")
local badgeLayout = Instance.new("UIListLayout")
badgeLayout.FillDirection = Enum.FillDirection.Horizontal
badgeLayout.Padding = UDim.new(0, Theme.Spacing.SP4)
badgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
badgeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
badgeLayout.Parent = badgeSection

Badge.new({ Text = "NEW", Parent = badgeSection })
Badge.new({ Text = "HOT", Dot = false, Color = Theme.Color.DANGER, Parent = badgeSection })
Badge.new({ Text = "", Dot = true, Parent = badgeSection })

CurrencyDisplay.new({ Type = "aether", Amount = 1250, Parent = badgeSection })
CurrencyDisplay.new({ Type = "coins", Amount = 8400, Label = "Coins", Parent = badgeSection })
CurrencyDisplay.new({ Type = "gems", Amount = 42, Label = "Gems", Parent = badgeSection })

-- Section: Loading & Empty
local miscSection = section("Loading & Empty States")
local miscLayout = Instance.new("UIListLayout")
miscLayout.FillDirection = Enum.FillDirection.Horizontal
miscLayout.Padding = UDim.new(0, Theme.Spacing.SP6)
miscLayout.VerticalAlignment = Enum.VerticalAlignment.Top
miscLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
miscLayout.Parent = miscSection

LoadingSpinner.new({
    Parent = miscSection,
    Label = "Harvesting…",
})

EmptyState.new({
    Title = "No pets equipped",
    Body = "Visit the pet manager to summon your first companion.",
    CtaText = "Open Pets",
    Parent = miscSection,
    OnCta = function()
        Toast.new({ Text = "Opening Pets…", Type = "success", Parent = root })
    end,
})

-- Section: Modal & Toast triggers
local actionSection = section("Overlays")
local actionLayout = Instance.new("UIListLayout")
actionLayout.FillDirection = Enum.FillDirection.Horizontal
actionLayout.Padding = UDim.new(0, Theme.Spacing.SP4)
actionLayout.VerticalAlignment = Enum.VerticalAlignment.Top
actionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
actionLayout.Parent = actionSection

Button.new({
    Text = "Open Modal",
    Variant = "primary",
    Parent = actionSection,
    OnClick = function()
        local demoActions: { Modal.ModalAction } = {
            { Text = "Cancel", Variant = "secondary", OnClick = function() end },
            {
                Text = "Confirm",
                Variant = "primary",
                OnClick = function()
                    Toast.new({ Text = "Confirmed!", Type = "success", Parent = root })
                end,
            },
        }
        Modal.new({
            Title = "Confirm Action",
            Body = "This is a demonstration modal with confirmation actions.",
            Parent = root,
            OnClose = function()
                Toast.new({ Text = "Modal closed", Type = "info", Parent = root })
            end,
            Actions = demoActions,
        })
    end,
})

Button.new({
    Text = "Show Tooltip",
    Variant = "ghost",
    Parent = actionSection,
    OnClick = function()
        Toast.new({ Text = "Hover over elements for tooltips", Type = "info", Parent = root })
    end,
})

-- tooltip demo
local tooltipAnchor = Button.new({
    Text = "Hover me",
    Variant = "secondary",
    Parent = actionSection,
})
Tooltip.new({
    Text = "This is a tooltip attached to a button.",
    Target = tooltipAnchor,
    Parent = root,
})

-- entrance animation
root.Transparency = 1
local enter = TweenService:Create(
    root,
    TweenInfo.new(Theme.Animation.SLOW, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { Transparency = 0 }
)
enter:Play()

print("[AetherUI] ComponentsDemo loaded successfully.")
