--!strict
-- StateLayer.luau
-- Wraps any content frame with an optional loading overlay (LoadingSpinner + dim)
-- and an optional empty state (EmptyState). Loading/empty auto-hide when real
-- content children are added to the target frame.

local Theme = require(script.Parent.Theme)
local LoadingSpinner = require(script.Parent.LoadingSpinner)
local EmptyState = require(script.Parent.EmptyState)

export type StateLayerOptions = {
    LoadingLabel: string?,
    EmptyTitle: string?,
    EmptyBody: string?,
    EmptyIcon: string?,
    CtaText: string?,
    OnCta: (() -> ())?,
}

export type StateLayer = {
    ShowLoading: (label: string?) -> (),
    HideLoading: () -> (),
    ShowEmpty: (title: string?, body: string?) -> (),
    HideEmpty: () -> (),
    SetLoading: (enabled: boolean, label: string?) -> (),
    SetEmpty: (enabled: boolean, title: string?, body: string?) -> (),
    IsEmpty: () -> boolean,
    Destroy: () -> (),
}

local RESERVED = {
    AetherStateLayer = true,
    AetherEmptyState = true,
    AetherSpinner = true,
}

local StateLayer = {}

function StateLayer.new(target: Frame, opts: StateLayerOptions?): StateLayer
    opts = opts or {}

    local dim = Instance.new("Frame")
    dim.Name = "AetherStateLayer"
    dim.Size = UDim2.fromScale(1, 1)
    dim.AnchorPoint = Vector2.new(0, 0)
    dim.BackgroundColor3 = Theme.Color.BG_OVERLAY
    dim.BackgroundTransparency = 0.6
    dim.Visible = false
    dim.ZIndex = Theme.ZIndex.OVERLAY
    dim.Parent = target

    local dimCorner = Instance.new("UICorner")
    dimCorner.CornerRadius = UDim.new(0, Theme.Radius.LG)
    dimCorner.Parent = dim

    local spinnerHost = Instance.new("Frame")
    spinnerHost.Name = "SpinnerHost"
    spinnerHost.Size = UDim2.fromScale(1, 1)
    spinnerHost.BackgroundTransparency = 1
    spinnerHost.Parent = dim

    local spinner: Frame? = nil
    local emptyState: Frame? = nil

    local function showSpinner(label: string?)
        if not spinner then
            spinner = LoadingSpinner.new({ Parent = spinnerHost, Label = label or opts.LoadingLabel })
            spinner.AnchorPoint = Vector2.new(0.5, 0.5)
            spinner.Position = UDim2.fromScale(0.5, 0.5)
        elseif label then
            local lbl = spinner:FindFirstChild("Label")
            if lbl and lbl:IsA("TextLabel") then
                lbl.Text = label
            end
        end
    end

    local function showEmpty(title: string?, body: string?)
        if not emptyState then
            emptyState = EmptyState.new({
                Title = title or opts.EmptyTitle or "Nothing here",
                Body = body or opts.EmptyBody,
                Icon = opts.EmptyIcon,
                CtaText = opts.CtaText,
                OnCta = opts.OnCta,
                Parent = target,
            })
        else
            local titleLabel = emptyState:FindFirstChild("Title")
            if titleLabel and titleLabel:IsA("TextLabel") then
                titleLabel.Text = title or opts.EmptyTitle or "Nothing here"
            end
            local bodyLabel = emptyState:FindFirstChild("Body")
            if body ~= nil and bodyLabel and bodyLabel:IsA("TextLabel") then
                bodyLabel.Text = body
            end
        end
        emptyState.Visible = true
    end

    local function setLoading(enabled: boolean, label: string?)
        if enabled then
            if emptyState then
                emptyState.Visible = false
            end
            showSpinner(label)
            dim.Visible = true
        else
            dim.Visible = false
        end
    end

    local function setEmpty(enabled: boolean, title: string?, body: string?)
        if enabled then
            dim.Visible = false
            showEmpty(title, body)
        elseif emptyState then
            emptyState.Visible = false
        end
    end

    -- Auto-hide loading/empty once real content arrives.
    local contentConn = target.ChildAdded:Connect(function(child: Instance)
        if RESERVED[child.Name] then
            return
        end
        if child:IsA("GuiObject") then
            dim.Visible = false
            if emptyState then
                emptyState.Visible = false
            end
        end
    end)

    local function isEmpty(): boolean
        for _, child in ipairs(target:GetChildren()) do
            if not RESERVED[child.Name] and child:IsA("GuiObject") and child.Visible then
                return false
            end
        end
        return true
    end

    local function destroy()
        contentConn:Disconnect()
        if spinner then
            local d = spinner:GetAttribute("_AetherDestroy")
            if type(d) == "function" then
                (d :: () -> ())()
            else
                spinner:Destroy()
            end
        end
        if emptyState then
            emptyState:Destroy()
        end
        dim:Destroy()
    end

    return {
        ShowLoading = function(label: string?)
            setLoading(true, label)
        end,
        HideLoading = function()
            setLoading(false)
        end,
        ShowEmpty = function(title: string?, body: string?)
            setEmpty(true, title, body)
        end,
        HideEmpty = function()
            setEmpty(false)
        end,
        SetLoading = setLoading,
        SetEmpty = setEmpty,
        IsEmpty = isEmpty,
        Destroy = destroy,
    }
end

return StateLayer
