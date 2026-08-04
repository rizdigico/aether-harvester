--!strict
-- Badge.luau
-- Height 20px, pill shape, aether-cyan bg + deep text.

local Theme = require(script.Parent.Theme)

export type BadgeProps = {
    Text: string,
    Dot: boolean?,
    Color: Color3?,
    Parent: Instance?,
}

local Badge = {}

function Badge.new(props: BadgeProps): Frame
    local text: string = props.Text
    local dot: boolean = props.Dot or false
    local color: Color3? = props.Color
    local parent: Instance? = props.Parent

    local frame = Instance.new("Frame")
    frame.Name = "AetherBadge"
    frame.Size = UDim2.new(0, 0, 0, Theme.Size.BADGE_HEIGHT)
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.BackgroundColor3 = color or Theme.Color.AETHER_CYAN
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.Radius.FULL)
    corner.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP3)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP3)
    pad.Parent = frame

    if dot then
        local dotFrame = Instance.new("Frame")
        dotFrame.Name = "Dot"
        dotFrame.Size = UDim2.new(0, 8, 0, 8)
        dotFrame.BackgroundColor3 = Theme.Color.TEXT_PRIMARY
        dotFrame.Parent = frame

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(0, Theme.Radius.FULL)
        dotCorner.Parent = dotFrame
    else
        local label = Instance.new("TextLabel")
        label.Name = "Text"
        label.Size = UDim2.new(0, 0, 0, Theme.Size.BADGE_HEIGHT)
        label.AutomaticSize = Enum.AutomaticSize.XY
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.Color.BG_DEEP
        label.Font = Theme.Font.BUTTON.Weight
        label.TextSize = Theme.Font.BUTTON.Size
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = frame
    end

    return frame
end

return Badge
