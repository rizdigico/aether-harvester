--!strict
-- EmptyState.luau
-- Icon (placeholder), title, body, optional CTA button.

local Theme = require(script.Parent.Theme)
local Button = require(script.Parent.Button)

export type EmptyStateProps = {
    Title: string,
    Body: string?,
    Icon: string?,
    CtaText: string?,
    OnCta: (() -> ())?,
    Parent: Instance?,
}

local EmptyState = {}

function EmptyState.new(props: EmptyStateProps): Frame
    local title: string = props.Title
    local body: string? = props.Body
    local icon: string? = props.Icon
    local ctaText: string? = props.CtaText
    local onCta: (() -> ())? = props.OnCta
    local parent: Instance? = props.Parent

    local frame = Instance.new("Frame")
    frame.Name = "AetherEmptyState"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.Name = "Layout"
    layout.Padding = UDim.new(0, Theme.Spacing.SP6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.Name = "Padding"
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP8)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP8)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP6)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP6)
    pad.Parent = frame

    -- icon
    if icon then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.Size = UDim2.new(0, 64, 0, 64)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = icon
        iconImg.ImageColor3 = Theme.Color.TEXT_SECONDARY
        iconImg.ImageTransparency = 0.6
        iconImg.Parent = frame
    else
        -- placeholder circle
        local placeholder = Instance.new("Frame")
        placeholder.Name = "Placeholder"
        placeholder.Size = UDim2.new(0, 64, 0, 64)
        placeholder.BackgroundColor3 = Theme.Color.BORDER_SUBTLE
        placeholder.Parent = frame

        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(1, 0)
        pCorner.Parent = placeholder
    end

    -- title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Color.TEXT_PRIMARY
    titleLabel.Font = Theme.Font.H3.Weight
    titleLabel.TextSize = Theme.Font.H3.Size
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.Parent = frame

    -- body
    if body then
        local bodyLabel = Instance.new("TextLabel")
        bodyLabel.Name = "Body"
        bodyLabel.Size = UDim2.new(1, 0, 0, 0)
        bodyLabel.AutomaticSize = Enum.AutomaticSize.Y
        bodyLabel.BackgroundTransparency = 1
        bodyLabel.Text = body
        bodyLabel.TextColor3 = Theme.Color.TEXT_SECONDARY
        bodyLabel.Font = Theme.Font.BODY.Weight
        bodyLabel.TextSize = Theme.Font.BODY.Size
        bodyLabel.TextXAlignment = Enum.TextXAlignment.Center
        bodyLabel.TextYAlignment = Enum.TextYAlignment.Center
        bodyLabel.TextWrapped = true
        bodyLabel.Parent = frame
    end

    -- CTA
    if ctaText and onCta then
        local cta = Button.new({
            Text = ctaText,
            Variant = "primary",
            Size = "medium",
            OnClick = onCta,
        })
        cta.Parent = frame
    end

    return frame
end

return EmptyState
