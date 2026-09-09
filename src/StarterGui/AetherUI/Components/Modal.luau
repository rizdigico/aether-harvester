--!strict
-- Modal.luau
-- Overlay + container with header/body/footer. Scale+fade entrance.

local Theme = require(script.Parent.Theme)
local Button = require(script.Parent.Button)

export type ModalAction = {
    Text: string,
    Variant: Button.ButtonVariant,
    OnClick: (() -> ())?,
}

export type ModalProps = {
    Title: string,
    Body: string?,
    Parent: Instance?,
    Size: UDim2?,
    OnClose: (() -> ())?,
    Actions: { ModalAction }?,
}

local Modal = {}

function Modal.new(props: ModalProps): Frame
    local title: string = props.Title
    local body: string? = props.Body
    local parent: Instance? = props.Parent
    local size: UDim2? = props.Size
    local onClose: (() -> ())? = props.OnClose
    local actions: { ModalAction }? = props.Actions

    local TweenService = game:GetService("TweenService")

    -- overlay
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Theme.Color.BG_OVERLAY
    overlay.BackgroundTransparency = 0.15
    overlay.ZIndex = Theme.ZIndex.OVERLAY
    overlay.Parent = parent

    -- modal container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = size or UDim2.new(0, Theme.Size.MODAL_MAX_WIDTH, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundColor3 = Theme.Color.BG_ELEVATED
    container.ZIndex = Theme.ZIndex.MODAL
    container.Parent = overlay

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, Theme.Radius.LG)
    containerCorner.Parent = container

    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = Theme.Color.BORDER_SUBTLE
    containerStroke.Thickness = Theme.Stroke.THIN
    containerStroke.Parent = container

    local containerPad = Instance.new("UIPadding")
    containerPad.PaddingTop = UDim.new(0, Theme.Spacing.SP6)
    containerPad.PaddingBottom = UDim.new(0, Theme.Spacing.SP6)
    containerPad.PaddingLeft = UDim.new(0, Theme.Spacing.SP6)
    containerPad.PaddingRight = UDim.new(0, Theme.Spacing.SP6)
    containerPad.Parent = container

    -- header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundTransparency = 1
    header.Parent = container

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Name = "Title"
    headerTitle.Size = UDim2.new(1, 0, 1, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = title
    headerTitle.TextColor3 = Theme.Color.TEXT_PRIMARY
    headerTitle.Font = Theme.Font.H3.Weight
    headerTitle.TextSize = Theme.Font.H3.Size
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.TextYAlignment = Enum.TextYAlignment.Center
    headerTitle.Parent = header

    if onClose then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseButton"
        closeBtn.Size = UDim2.new(0, 40, 0, 40)
        closeBtn.Position = UDim2.new(1, -40, 0, 0)
        closeBtn.BackgroundColor3 = Theme.Color.BG_DIM
        closeBtn.Text = "×"
        closeBtn.TextColor3 = Theme.Color.TEXT_SECONDARY
        closeBtn.Font = Theme.Font.BODY.Weight
        closeBtn.TextSize = Theme.Font.BODY.Size
        closeBtn.AutoButtonColor = false
        closeBtn.Parent = header

        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, Theme.Radius.SM)
        closeCorner.Parent = closeBtn

        closeBtn.MouseButton1Click:Connect(onClose)
    end

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
        bodyLabel.TextWrapped = true
        bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
        bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
        bodyLabel.LayoutOrder = 1
        bodyLabel.Parent = container
    end

    -- footer
    if actions and #actions > 0 then
        local footer = Instance.new("Frame")
        footer.Name = "Footer"
        footer.Size = UDim2.new(1, 0, 0, 48)
        footer.BackgroundTransparency = 1
        footer.LayoutOrder = 2
        footer.Parent = container

        local footerLayout = Instance.new("UIListLayout")
        footerLayout.FillDirection = Enum.FillDirection.Horizontal
        footerLayout.Padding = UDim.new(0, Theme.Spacing.SP4)
        footerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        footerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        footerLayout.Parent = footer

        for _, action in actions do
            local btn = Button.new({
                Text = action.Text,
                Variant = action.Variant,
                Size = "medium",
                OnClick = action.OnClick,
            })
            btn.LayoutOrder = 2
            btn.Parent = footer
        end
    end

    -- entrance animation
    container.Size = UDim2.new(0, Theme.Size.MODAL_MAX_WIDTH * 0.95, 0, 0)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Transparency = 1

    local enterInfo = TweenInfo.new(Theme.Animation.SLOW, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(container, enterInfo, {
        Size = size or UDim2.new(0, Theme.Size.MODAL_MAX_WIDTH, 0, 0),
        Transparency = 0,
    }):Play()

    local connections: { RBXScriptConnection } = {}

    local function destroy()
        for _, conn in connections do
            conn:Disconnect()
        end
        table.clear(connections)
        overlay:Destroy()
    end

    overlay:SetAttribute("_AetherDestroy", destroy)

    return overlay
end

return Modal
