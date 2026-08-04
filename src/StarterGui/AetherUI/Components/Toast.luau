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

-- === Queue manager ===
-- Parents toasts into a host container (auto-creates a UIListLayout), stacks them,
-- and caps the number of visible toasts at MAX_VISIBLE. Older toasts are dismissed
-- first when the cap is exceeded.

local MAX_VISIBLE = 4

export type ToastHost = {
    Queue: (props: ToastProps) -> (),
    Destroy: () -> (),
    Clear: () -> (),
}

function Toast.enqueue(parent: Instance, props: ToastProps): ToastHost
    local host = Instance.new("Frame")
    host.Name = "AetherToastHost"
    host.Size = UDim2.new(0, TOAST_WIDTH + Theme.Spacing.SP5 * 2, 0, 0)
    host.AutomaticSize = Enum.AutomaticSize.Y
    host.Position = UDim2.new(1, -Theme.Spacing.SP5, 0, Theme.Spacing.SP5)
    host.AnchorPoint = Vector2.new(1, 0)
    host.BackgroundTransparency = 1
    host.ZIndex = Theme.ZIndex.TOAST
    host.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.Name = "Layout"
    layout.Padding = UDim.new(0, Theme.Spacing.SP3)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Parent = host

    local stack: { Frame } = {}

    local function reflow()
        -- Dismiss oldest beyond the cap, oldest first.
        while #stack > MAX_VISIBLE do
            local oldest = table.remove(stack, 1)
            local d = oldest:GetAttribute("_AetherDestroy")
            if type(d) == "function" then
                (d :: () -> ())()
            else
                oldest:Destroy()
            end
        end
    end

    local function queue(entry: ToastProps)
        entry.Parent = host
        local frame = Toast.new(entry)
        table.insert(stack, frame)
        reflow()
        task.delay((entry.Duration or 4) + Theme.Animation.BASE * 2, function()
            for i, f in ipairs(stack) do
                if f == frame then
                    table.remove(stack, i)
                    break
                end
            end
        end)
    end

    -- Queue the initial toast passed to enqueue()
    if props and props.Text then
        queue(props)
    end

    local function clear()
        for _, f in ipairs(stack) do
            local d = f:GetAttribute("_AetherDestroy")
            if type(d) == "function" then
                (d :: () -> ())()
            else
                f:Destroy()
            end
        end
        table.clear(stack)
        host:Destroy()
    end

    return {
        Queue = queue,
        Clear = clear,
        Destroy = clear,
    }
end

return Toast
