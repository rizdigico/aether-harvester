--!strict
-- ScrollContainer.luau
-- Padding sp5, custom scrollbar (4px), overscroll glow.

local Theme = require(script.Parent.Theme)

export type ScrollContainerProps = {
    Parent: Instance?,
    Size: UDim2?,
    Position: UDim2?,
}

local ScrollContainer = {}

function ScrollContainer.new(props: ScrollContainerProps): ScrollingFrame
    local parent: Instance? = props.Parent
    local size: UDim2? = props.Size
    local position: UDim2? = props.Position

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "AetherScroll"
    scroll.Size = size or UDim2.new(1, 0, 1, 0)
    scroll.Position = position or UDim2.new(0, 0, 0, 0)
    scroll.BackgroundColor3 = Theme.Color.BG_BASE
    scroll.ScrollBarThickness = Theme.Size.SCROLLBAR_WIDTH
    scroll.ScrollBarImageTransparency = 0
    scroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    scroll.ScrollBarImageColor3 = Theme.Color.AETHER_CYAN
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.ElasticBehavior = Enum.ElasticBehavior.Always
    scroll.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.Radius.MD)
    corner.Parent = scroll

    local pad = Instance.new("UIPadding")
    pad.Name = "Padding"
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP5)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP5)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP5)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP5)
    pad.Parent = scroll

    -- overscroll glow
    local glow = Instance.new("Frame")
    glow.Name = "OverscrollGlow"
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.BackgroundColor3 = Theme.Color.AETHER_CYAN
    glow.BackgroundTransparency = 0.85
    glow.Visible = false
    glow.ZIndex = -1
    glow.Parent = scroll

    local glowGrad = Instance.new("UIGradient")
    glowGrad.Name = "RadialGlow"
    glowGrad.Color = ColorSequence.new(Theme.Color.AETHER_CYAN)
    glowGrad.Transparency = NumberSequence.new(0.15)
    glowGrad.Rotation = 90
    glowGrad.Parent = glow

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, Theme.Radius.MD)
    glowCorner.Parent = glow

    -- show glow on overscroll via input
    local connections: { RBXScriptConnection } = {}
    local lastY: number = 0

    table.insert(
        connections,
        scroll.InputBegan:Connect(function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            then
                lastY = input.Position.Y
            end
        end)
    )

    table.insert(
        connections,
        scroll.InputChanged:Connect(function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            then
                local delta = input.Position.Y - lastY
                lastY = input.Position.Y
                if math.abs(delta) > 5 then
                    glow.Visible = true
                    task.delay(0.3, function()
                        if glow and glow.Parent then
                            glow.Visible = false
                        end
                    end)
                end
            end
        end)
    )

    local function destroy()
        for _, conn in connections do
            conn:Disconnect()
        end
        table.clear(connections)
        scroll:Destroy()
    end

    scroll:SetAttribute("_AetherDestroy", destroy)

    return scroll
end

return ScrollContainer
