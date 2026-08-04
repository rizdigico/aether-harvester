--!strict
-- ListItem.luau
-- Height 56px, icon slot, center text, right action, divider.

local Theme = require(script.Parent.Theme)

export type ListItemProps = {
    Title: string,
    Subtitle: string?,
    Icon: string?,
    RightText: string?,
    Parent: Instance?,
    OnClick: (() -> ())?,
    Last: boolean?,
}

local ListItem = {}

function ListItem.new(props: ListItemProps): Frame
    local title: string = props.Title
    local subtitle: string? = props.Subtitle
    local icon: string? = props.Icon
    local rightText: string? = props.RightText
    local parent: Instance? = props.Parent
    local onClick: (() -> ())? = props.OnClick
    local last: boolean? = props.Last

    local frame = Instance.new("Frame")
    frame.Name = "AetherListItem"
    frame.Size = UDim2.new(1, 0, 0, Theme.Size.LIST_ITEM_HEIGHT)
    frame.BackgroundColor3 = Theme.Color.BG_DIM
    frame.Parent = parent

    -- hover / active feedback
    local function onHoverEnter()
        frame.BackgroundColor3 = Theme.Color.BG_ELEVATED
    end

    local function onHoverLeave()
        frame.BackgroundColor3 = Theme.Color.BG_DIM
    end

    local function onActive()
        frame.BackgroundColor3 = Theme.Color.BG_BASE
    end

    frame.MouseEnter:Connect(onHoverEnter)
    frame.MouseLeave:Connect(onHoverLeave)
    frame.MouseButton1Down:Connect(onActive)
    frame.MouseButton1Up:Connect(function()
        frame.BackgroundColor3 = Theme.Color.BG_ELEVATED
    end)

    if onClick then
        frame.MouseButton1Click:Connect(onClick)
    end

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, Theme.Spacing.SP3)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP3)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP3)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP4)
    pad.Parent = frame

    -- icon
    if icon then
        local iconFrame = Instance.new("Frame")
        iconFrame.Name = "Icon"
        iconFrame.Size = UDim2.new(0, 40, 0, 40)
        iconFrame.BackgroundTransparency = 1
        iconFrame.Parent = frame

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 40, 0, 40)
        img.BackgroundTransparency = 1
        img.Image = icon
        img.Parent = iconFrame
    end

    -- text stack
    local textStack = Instance.new("Frame")
    textStack.Name = "TextStack"
    textStack.Size = UDim2.new(1, 0, 0, 0)
    textStack.AutomaticSize = Enum.AutomaticSize.Y
    textStack.BackgroundTransparency = 1
    textStack.Parent = frame

    local textLayout = Instance.new("UIListLayout")
    textLayout.Padding = UDim.new(0, 0)
    textLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    textLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    textLayout.Parent = textStack

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Color.TEXT_PRIMARY
    titleLabel.Font = Theme.Font.BODY.Weight
    titleLabel.TextSize = Theme.Font.BODY.Size
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.Parent = textStack

    if subtitle then
        local subLabel = Instance.new("TextLabel")
        subLabel.Name = "Subtitle"
        subLabel.Size = UDim2.new(1, 0, 0, 14)
        subLabel.BackgroundTransparency = 1
        subLabel.Text = subtitle
        subLabel.TextColor3 = Theme.Color.TEXT_SECONDARY
        subLabel.Font = Theme.Font.CAPTION.Weight
        subLabel.TextSize = Theme.Font.CAPTION.Size
        subLabel.TextXAlignment = Enum.TextXAlignment.Left
        subLabel.TextYAlignment = Enum.TextYAlignment.Center
        subLabel.Parent = textStack
    end

    -- right action
    if rightText then
        local right = Instance.new("TextLabel")
        right.Name = "Right"
        right.Size = UDim2.new(0, 0, 0, 0)
        right.AutomaticSize = Enum.AutomaticSize.XY
        right.BackgroundTransparency = 1
        right.Text = rightText
        right.TextColor3 = Theme.Color.TEXT_SECONDARY
        right.Font = Theme.Font.BODY.Weight
        right.TextSize = Theme.Font.BODY.Size
        right.TextXAlignment = Enum.TextXAlignment.Right
        right.TextYAlignment = Enum.TextYAlignment.Center
        right.Parent = frame
    end

    -- divider
    if not last then
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, -Theme.Spacing.SP8, 0, Theme.Stroke.THIN)
        divider.Position = UDim2.new(0, Theme.Spacing.SP4, 1, 0)
        divider.BackgroundColor3 = Theme.Color.BORDER_SUBTLE
        divider.Parent = frame
    end

    return frame
end

return ListItem
