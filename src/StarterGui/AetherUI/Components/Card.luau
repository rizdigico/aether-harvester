--!strict
-- Card.luau
-- Used for inventory items, pets, shop listings. Optional RarityFrame accent.

local Theme = require(script.Parent.Theme)
local RarityFrame = require(script.Parent.RarityFrame)

export type CardProps = {
    Title: string?,
    Subtitle: string?,
    Icon: string?,
    Rarity: string?,
    Badge: string?,
    Parent: Instance?,
    Size: UDim2?,
    OnClick: (() -> ())?,
}

local Card = {}

function Card.new(props: CardProps): Frame
    local title: string? = props.Title
    local subtitle: string? = props.Subtitle
    local icon: string? = props.Icon
    local rarity: string? = props.Rarity
    local badge: string? = props.Badge
    local parent: Instance? = props.Parent
    local size: UDim2? = props.Size
    local onClick: (() -> ())? = props.OnClick

    local frame = Instance.new("Frame")
    frame.Name = "AetherCard"
    frame.Size = size or UDim2.new(0, 160, 0, 180)
    frame.BackgroundColor3 = Theme.Color.BG_DIM
    frame.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.Name = "Corner"
    corner.CornerRadius = UDim.new(0, Theme.Radius.XL)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Name = "Border"
    stroke.Color = Theme.Color.BORDER_SUBTLE
    stroke.Thickness = Theme.Stroke.THIN
    stroke.Parent = frame

    -- rarity frame wrapper
    if rarity then
        local rarityFrame = RarityFrame.new({
            Rarity = rarity,
            Parent = frame,
        })
        rarityFrame.Size = UDim2.new(1, 0, 1, 0)
    end

    -- layout
    local layout = Instance.new("UIListLayout")
    layout.Name = "Layout"
    layout.Padding = UDim.new(0, Theme.Spacing.SP3)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.Name = "Padding"
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP4)
    pad.Parent = frame

    -- icon area
    if icon then
        local iconFrame = Instance.new("Frame")
        iconFrame.Name = "IconArea"
        iconFrame.Size = UDim2.new(1, 0, 0, 64)
        iconFrame.BackgroundTransparency = 1
        iconFrame.Parent = frame

        local img = Instance.new("ImageLabel")
        img.Name = "Icon"
        img.Size = UDim2.new(0, 56, 0, 56)
        img.Position = UDim2.new(0.5, 0, 0.5, 0)
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.BackgroundTransparency = 1
        img.Image = icon
        img.Parent = iconFrame
    end

    -- title
    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, 0, 0, 20)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Theme.Color.TEXT_PRIMARY
        titleLabel.Font = Theme.Font.H3.Weight
        titleLabel.TextSize = Theme.Font.H3.Size
        titleLabel.TextXAlignment = Enum.TextXAlignment.Center
        titleLabel.TextYAlignment = Enum.TextYAlignment.Top
        titleLabel.Parent = frame
    end

    -- subtitle
    if subtitle then
        local subLabel = Instance.new("TextLabel")
        subLabel.Name = "Subtitle"
        subLabel.Size = UDim2.new(1, 0, 0, 16)
        subLabel.BackgroundTransparency = 1
        subLabel.Text = subtitle
        subLabel.TextColor3 = Theme.Color.TEXT_SECONDARY
        subLabel.Font = Theme.Font.CAPTION.Weight
        subLabel.TextSize = Theme.Font.CAPTION.Size
        subLabel.TextXAlignment = Enum.TextXAlignment.Center
        subLabel.TextYAlignment = Enum.TextYAlignment.Top
        subLabel.Parent = frame
    end

    -- badge
    if badge then
        local badgeLabel = Instance.new("TextLabel")
        badgeLabel.Name = "Badge"
        badgeLabel.Size = UDim2.new(0, 0, 0, Theme.Size.BADGE_HEIGHT)
        badgeLabel.AutomaticSize = Enum.AutomaticSize.XY
        badgeLabel.BackgroundColor3 = Theme.Color.AETHER_CYAN
        badgeLabel.Text = badge
        badgeLabel.TextColor3 = Theme.Color.BG_DEEP
        badgeLabel.Font = Theme.Font.BUTTON.Weight
        badgeLabel.TextSize = Theme.Font.BUTTON.Size
        badgeLabel.Parent = frame

        local badgeCorner = Instance.new("UICorner")
        badgeCorner.CornerRadius = UDim.new(0, Theme.Radius.FULL)
        badgeCorner.Parent = badgeLabel

        local badgePad = Instance.new("UIPadding")
        badgePad.PaddingLeft = UDim.new(0, Theme.Spacing.SP3)
        badgePad.PaddingRight = UDim.new(0, Theme.Spacing.SP3)
        badgePad.Parent = badgeLabel
    end

    if onClick then
        local btn = Instance.new("TextButton")
        btn.Name = "ClickTarget"
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = frame
        btn.MouseButton1Click:Connect(onClick)
    end

    if parent then
        frame.Parent = parent
    end

    return frame
end

return Card
