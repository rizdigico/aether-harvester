--!strict
-- AccessibilitySettings: applies a player's persisted Settings to the live client.
--   * MusicVolume / SFXVolume -> SoundService sound groups (if they exist).
--   * GraphicsQuality        -> a global quality request (consumed by render scripts).
--   * ReducedMotion          -> sets _G.ReducedMotion (checked by UI components/screens).
--
-- This is intentionally minimal: it only reads+applies. It does NOT rebuild the Settings
-- screen. The Settings screen can call AccessibilityController:SetReducedMotion(false/true)
-- to flip the flag at runtime (see VISUAL_QA_FINDINGS.md: missing Accessibility section).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local AccessibilityController = {}

-- Map persisted Setting key -> SoundGroup name we look for under SoundService.
local VOLUME_BINDINGS = {
    MusicVolume = "Music", -- SoundService.Music
    SFXVolume = "SFX", -- SoundService.SFX
}

-- pcall-guarded setter so a missing/renamed group is never fatal.
local function applyVolume(bindingName: string, value: any)
    local group = SoundService:FindFirstChild(bindingName)
    if not group or not group:IsA("SoundGroup") then
        return
    end
    local volume = if type(value) == "number" then value else 0.5
    pcall(function()
        group.Volume = math.clamp(volume, 0, 1)
    end)
end

local function applyVolumes(settings: { [string]: any }?)
    if not settings then
        return
    end
    for key, groupName in pairs(VOLUME_BINDINGS) do
        applyVolume(groupName, settings[key])
    end
end

-- Expose a runtime toggle the Settings screen / any UI can call.
function AccessibilityController.SetReducedMotion(enabled: boolean)
    _G.ReducedMotion = enabled
end

local function init()
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    local remotes = shared and shared:FindFirstChild("Remotes")
    local getPlayerData = remotes and remotes:FindFirstChild("GetPlayerData")

    if not getPlayerData then
        -- No data remote; still default the flag so UI checks never error.
        _G.ReducedMotion = false
        return
    end

    local ok, data = pcall(function()
        return getPlayerData:InvokeServer()
    end)

    local settings = if ok and data and type(data) == "table" then data.Settings else nil
    applyVolumes(settings)

    -- Graphics quality: forward to a global request if any render script reads it.
    local quality = settings and settings.GraphicsQuality
    if type(quality) == "number" then
        _G.RequestedGraphicsQuality = quality
    end

    -- Reduced motion defaults OFF. The Settings screen toggles it via the controller.
    _G.ReducedMotion = false
end

-- Store a controller for other scripts (Settings screen) to drive.
_G.AccessibilityController = AccessibilityController

task.defer(init)
