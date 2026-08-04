--!strict
-- Panel.luau
-- Surface hierarchy: background / dim / panel / elevated

local Theme = require(script.Parent.Theme)

export type Surface = "background" | "dim" | "panel" | "elevated"
export type PanelProps = {
    Title: string?,
    Surface: Surface?,
    Parent: Instance?,
    Size: UDim2?,
    Position: UDim2?,
    OnClose: (() -> ())?,
}

local Panel = {}

local SURFACE_COLORS = {
    background = Theme.Color.BG_DEEP,
    dim = Theme.Color.BG_DIM,
    panel = Theme.Color.BG_BASE,
    elevated = Theme.Color.BG_ELEVATED,
}

local SURFACE_Z = {
    background = Theme.ZIndex.BG,
    dim = Theme.ZIndex.DIM,
    panel = Theme.ZIndex.PANEL,
    elevated = Theme.ZIndex.ELEVATED,
}

function Panel.new(props: PanelProps): Frame
    local surface: Surface = props.Surface or "panel"
    local title: string? = props.Title
    local parent: Instance? = props.Parent
    local size: UDim2? = props.Size
    local position: UDim2? = props.Position
    local onClose: (() -> ())? = props.OnClose

    local frame = Instance.new("Frame")
    frame.Name = "AetherPanel"
    frame.Size = size or UDim2.new(1, 0, 1, 0)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = SURFACE_COLORS[surface]
    frame.ZIndex = SURFACE_Z[surface]

    local corner = Instance.new("UICorner")
    corner.Name = "Corner"
    corner.CornerRadius = UDim.new(0, Theme.Radius.LG)
    corner.Parent = frame

    -- subtle border
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Border"
    stroke.Color = Theme.Color.BORDER_SUBTLE
    stroke.Thickness = Theme.Stroke.THIN
    stroke.Parent = frame

    -- internal padding container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.Name = "Padding"
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP6)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP6)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP6)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP6)
    pad.Parent = content

    -- title bar
    if title then
        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 36)
        header.BackgroundTransparency = 1
        header.Parent = content

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, 0, 1, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Theme.Color.TEXT_PRIMARY
        titleLabel.Font = Theme.Font.H3.Weight
        titleLabel.TextSize = Theme.Font.H3.Size
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextYAlignment = Enum.TextYAlignment.Center
        titleLabel.Parent = header

        -- body offset below header
        local body = Instance.new("Frame")
        body.Name = "Body"
        body.Size = UDim2.new(1, 0, 1, -36)
        body.Position = UDim2.new(0, 0, 0, 36)
        body.BackgroundTransparency = 1
        body.Parent = content
    end

    -- close button
    if onClose then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseButton"
        closeBtn.Size = UDim2.new(0, 36, 0, 36)
        closeBtn.Position = UDim2.new(1, -36, 0, 0)
        closeBtn.BackgroundColor3 = Theme.Color.BG_DIM
        closeBtn.Text = "×"
        closeBtn.TextColor3 = Theme.Color.TEXT_SECONDARY
        closeBtn.Font = Theme.Font.BODY.Weight
        closeBtn.TextSize = Theme.Font.BODY.Size
        closeBtn.AutoButtonColor = false
        closeBtn.Parent = content

        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, Theme.Radius.SM)
        closeCorner.Parent = closeBtn

        closeBtn.MouseButton1Click:Connect(onClose)
    end

    if parent then
        frame.Parent = parent
    end

    return frame
end

return Panel
