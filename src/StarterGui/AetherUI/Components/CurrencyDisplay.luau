--!strict
-- CurrencyDisplay.luau
-- Icon (16px) + numeral + label. Color by currency type.

local Theme = require(script.Parent.Theme)

export type CurrencyType = "aether" | "coins" | "gems"
export type CurrencyDisplayProps = {
    Type: CurrencyType,
    Amount: number,
    Label: string?,
    Parent: Instance?,
}

local CurrencyDisplay = {}

local CURRENCY_COLORS: { [CurrencyType]: Color3 } = {
    aether = Theme.Color.AETHER_CYAN,
    coins = Theme.Color.WARNING,
    gems = Theme.Color.RARITY_EPIC,
}

function CurrencyDisplay.new(props: CurrencyDisplayProps): Frame
    local currencyType: CurrencyType = props.Type
    local amount: number = props.Amount
    local label: string? = props.Label
    local parent: Instance? = props.Parent

    local frame = Instance.new("Frame")
    frame.Name = "AetherCurrency"
    frame.Size = UDim2.new(0, 0, 0, Theme.Size.CURRENCY_ICON_SIZE + Theme.Spacing.SP4)
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, Theme.Spacing.SP2)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.Parent = frame

    local icon = Instance.new("Frame")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, Theme.Size.CURRENCY_ICON_SIZE, 0, Theme.Size.CURRENCY_ICON_SIZE)
    icon.BackgroundColor3 = CURRENCY_COLORS[currencyType]
    icon.Parent = frame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, Theme.Radius.SM)
    iconCorner.Parent = icon

    -- placeholder icon shape (circle)
    local iconInner = Instance.new("Frame")
    iconInner.Size = UDim2.new(1, 0, 1, 0)
    iconInner.BackgroundTransparency = 0.5
    iconInner.BackgroundColor3 = Theme.Color.BG_DEEP
    iconInner.Parent = icon

    local iconInnerCorner = Instance.new("UICorner")
    iconInnerCorner.CornerRadius = UDim.new(1, 0)
    iconInnerCorner.Parent = iconInner

    local numeral = Instance.new("TextLabel")
    numeral.Name = "Numeral"
    numeral.Size = UDim2.new(0, 0, 0, Theme.Font.NUMERAL.Size)
    numeral.AutomaticSize = Enum.AutomaticSize.XY
    numeral.BackgroundTransparency = 1
    numeral.Text = tostring(amount)
    numeral.TextColor3 = Theme.Color.TEXT_PRIMARY
    numeral.Font = Theme.Font.NUMERAL.Weight
    numeral.TextSize = Theme.Font.NUMERAL.Size
    numeral.TextXAlignment = Enum.TextXAlignment.Left
    numeral.TextYAlignment = Enum.TextYAlignment.Center
    numeral.Parent = frame

    if label then
        local labelObj = Instance.new("TextLabel")
        labelObj.Name = "Label"
        labelObj.Size = UDim2.new(0, 0, 0, Theme.Font.CAPTION.Size)
        labelObj.AutomaticSize = Enum.AutomaticSize.XY
        labelObj.BackgroundTransparency = 1
        labelObj.Text = label
        labelObj.TextColor3 = Theme.Color.TEXT_SECONDARY
        labelObj.Font = Theme.Font.CAPTION.Weight
        labelObj.TextSize = Theme.Font.CAPTION.Size
        labelObj.TextXAlignment = Enum.TextXAlignment.Left
        labelObj.TextYAlignment = Enum.TextYAlignment.Center
        labelObj.Parent = frame
    end

    return frame
end

return CurrencyDisplay
