# Aether Harvester deployment scripts
# Staging publish is agent-automatable; production requires human approval.

# ---------------------------------------------------------------------------
# deploy-staging: build + publish staging place via rbxcloud / Open Cloud API.
# Usage: .\scripts\deploy-staging.ps1 [-PlaceId 123456789]
# Requires: env ROBLOX_OPEN_CLOUD_API_KEY (CI secret or local dev env, never committed)
# ---------------------------------------------------------------------------
param(
    [int]$PlaceId = 0
)

$ErrorActionPreference = "Stop"
$env:Path = "$env:Path;C:\Users\aariz\.rokit\bin"

Write-Host "== Aether Harvester staging deploy =="
if ($PlaceId -eq 0) {
    Write-Host "STAGING_PLACE_ID not provided. Set -PlaceId or env STAGING_PLACE_ID."
    exit 1
}

# Build the place file
rojo build --output aether-harvester-staging.rbxlx
if ($LASTEXITCODE -ne 0) { Write-Host "Build failed"; exit 1 }

if (-not $env:ROBLOX_OPEN_CLOUD_API_KEY) {
    Write-Host "ROBLOX_OPEN_CLOUD_API_KEY not set - skipping publish (build only)."
    exit 0
}

Write-Host "Publishing staging place $PlaceId ..."
# Placeholder - wire rbxcloud or direct Open Cloud Place Publishing API here.
# Example with rbxcloud:  rbxcloud place publish --place $PlaceId --file aether-harvester-staging.rbxlx
Write-Host "Staging publish OK (stub)."
