# Aether Harvester staging deploy via rbxcloud (Open Cloud).
# Usage: .\scripts\deploy-staging.ps1 [-PlaceId 123456789] [-UniverseId 987654321]
# Reads ROBLOX_OPEN_CLOUD_API_KEY from env or roblox-dev/.env.local (gitignored).
param(
    [int]$PlaceId = 0,
    [int]$UniverseId = 0
)

$ErrorActionPreference = "Stop"
$env:Path = "$env:Path;C:\Users\aariz\.rokit\bin;C:\Users\aariz\.local\bin"

# Resolve Open Cloud API key: env var first, then roblox-dev/.env.local (gitignored).
if (-not $env:ROBLOX_OPEN_CLOUD_API_KEY) {
    $envFile = Join-Path (Split-Path $PSScriptRoot -Parent) "..\.env.local"
    if (Test-Path $envFile) {
        $line = Get-Content $envFile | Where-Object { $_ -like "ROBLOX_OPEN_CLOUD_API_KEY=*" } | Select-Object -First 1
        if ($line) { $env:ROBLOX_OPEN_CLOUD_API_KEY = $line.Substring($line.IndexOf("=") + 1) }
    }
}

Write-Host "== Aether Harvester staging deploy =="

# Try to resolve IDs from config/environments.yaml if not passed explicitly.
if ($PlaceId -eq 0 -or $UniverseId -eq 0) {
    $configPath = Join-Path (Split-Path $PSScriptRoot -Parent) "config\environments.yaml"
    if (Test-Path $configPath) {
        # Minimal YAML parse: read development/staging blocks
        $yaml = Get-Content $configPath -Raw
        $match = [regex]::Match($yaml, "development:\s*\n\s*universeId:\s*(\d+)\s*\n\s*placeId:\s*(\d+)")
        if ($match.Success) {
            if ($UniverseId -eq 0) { $UniverseId = [int]$match.Groups[1].Value }
            if ($PlaceId -eq 0) { $PlaceId = [int]$match.Groups[2].Value }
        }
        $stage = [regex]::Match($yaml, "staging:\s*\n\s*universeId:\s*(\d+)\s*\n\s*placeId:\s*(\d+)")
        if ($stage.Success) {
            $stagingUniverse = [int]$stage.Groups[1].Value
            $stagingPlace = [int]$stage.Groups[2].Value
            if ($stagingPlace -gt 0) { $PlaceId = $stagingPlace }
            if ($stagingUniverse -gt 0) { $UniverseId = $stagingUniverse }
        }
    }
}

if ($PlaceId -eq 0 -or $UniverseId -eq 0) {
    Write-Host "Missing IDs. Publish the game once in Studio, then set universeId/placeId"
    Write-Host "in config/environments.yaml (or pass -PlaceId/-UniverseId)."
    exit 1
}

# Build the place file
rojo build --output aether-harvester-staging.rbxlx
if ($LASTEXITCODE -ne 0) { Write-Host "Build failed"; exit 1 }

if (-not $env:ROBLOX_OPEN_CLOUD_API_KEY) {
    Write-Host "ROBLOX_OPEN_CLOUD_API_KEY not set - skipping publish (build only)."
    exit 0
}

Write-Host "Publishing staging place $PlaceId (universe $UniverseId) ..."
rbxcloud experience publish `
    --filename aether-harvester-staging.rbxlx `
    --place-id $PlaceId `
    --universe-id $UniverseId `
    --version-type saved `
    --api-key $env:ROBLOX_OPEN_CLOUD_API_KEY `
    --pretty
if ($LASTEXITCODE -ne 0) { Write-Host "Publish failed"; exit 1 }
Write-Host "Staging publish OK."
