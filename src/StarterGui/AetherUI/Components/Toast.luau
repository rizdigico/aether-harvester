--!strict
-- Toast.luau
-- Left border colored by type, slide from right, auto-dismiss 4000ms, queue support.

local Theme = require(script.Parent.Theme)

export type ToastType = "info" | "success" | "warning" | "error"
export type ToastProps = {
    Text: string,
    Type: ToastType?,
    Duration: number?,
    Parent: Instance?,
}

local Toast = {}

local TYPE_COLORS: { [ToastType]: Color3 } = {
    info = Theme.Color.AETHER_CYAN,
    success = Theme.Color.SUCCESS,
    warning = Theme.Color.WARNING,
    error = Theme.Color.DANGER,
}

local TOAST_WIDTH = 320

function Toast.new(props: ToastProps): Frame
    local text: string = props.Text
    local toastType: ToastType = props.Type or "info"
    local duration: number = props.Duration or 4
    local parent: Instance? = props.Parent

    local frame = Instance.new("Frame")
    frame.Name = "AetherToast"
    frame.Size = UDim2.new(0, TOAST_WIDTH, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundColor3 = Theme.Color.BG_ELEVATED
    frame.ZIndex = Theme.ZIndex.TOAST
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.Radius.MD)
    corner.Parent = frame

    -- left border
    local border = Instance.new("Frame")
    border.Name = "LeftBorder"
    border.Size = UDim2.new(0, Theme.Size.TOAST_BORDER, 1, 0)
    border.BackgroundColor3 = TYPE_COLORS[toastType]
    border.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP5)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP5)
    pad.Parent = frame

    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.Size = UDim2.new(1, -Theme.Size.TOAST_BORDER, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Color.TEXT_PRIMARY
    label.Font = Theme.Font.BODY.Weight
    label.TextSize = Theme.Font.BODY.Size
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Parent = frame

    -- entrance: slide from right
    frame.Position = UDim2.new(1, 20, 0, 0)
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Transparency = 1

    local TweenService = game:GetService("TweenService")
    local enterInfo = TweenInfo.new(Theme.Animation.BASE, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService
        :Create(
            frame,
            enterInfo,
            { Position = UDim2.new(1, -Theme.Spacing.SP5, 0, Theme.Spacing.SP5), Transparency = 0 }
        )
        :Play()

    -- auto dismiss
    task.delay(duration, function()
        if frame and frame.Parent then
            local exitInfo = TweenInfo.new(Theme.Animation.BASE, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenService:Create(frame, exitInfo, { Position = UDim2.new(1, 20, 0, 0), Transparency = 1 }):Play()
            task.wait(Theme.Animation.BASE)
            frame:Destroy()
        end
    end)

    local connections: { RBXScriptConnection } = {}

    local function destroy()
        for _, conn in connections do
            conn:Disconnect()
        end
        table.clear(connections)
        frame:Destroy()
    end

    frame:SetAttribute("_AetherDestroy", destroy)

    return frame
end

return Toast
