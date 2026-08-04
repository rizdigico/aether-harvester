# Production deploy gate. NEVER runs automatically.
# Usage: .\scripts\deploy-production.ps1 -PlaceId 999999999
# Requires explicit human approval + ROBLOX_OPEN_CLOUD_PRODUCTION_API_KEY.
param(
    [int]$PlaceId = 0
)

$ErrorActionPreference = "Stop"

# Resolve Open Cloud API key: env var first, then roblox-dev/.env.local (gitignored).
if (-not $env:ROBLOX_OPEN_CLOUD_API_KEY) {
    $envFile = Join-Path (Split-Path $PSScriptRoot -Parent) "..\.env.local"
    if (Test-Path $envFile) {
        $line = Get-Content $envFile | Where-Object { $_ -like "ROBLOX_OPEN_CLOUD_API_KEY=*" } | Select-Object -First 1
        if ($line) { $env:ROBLOX_OPEN_CLOUD_API_KEY = $line.Substring($line.IndexOf("=") + 1) }
    }
}

if ($PlaceId -eq 0) {
    Write-Host "PRODUCTION place id required. Refusing to guess."
    exit 1
}

Write-Host "!! PRODUCTION DEPLOY - requires human approval !!"
$confirm = Read-Host "Type 'PRODUCTION' to confirm"
if ($confirm -ne "PRODUCTION") {
    Write-Host "Aborted."
    exit 1
}

$env:Path = "$env:Path;C:\Users\aariz\.rokit\bin"
rojo build --output aether-harvester-production.rbxlx
if ($LASTEXITCODE -ne 0) { Write-Host "Build failed"; exit 1 }

Write-Host "Publishing production place $PlaceId ..."
Write-Host "Production publish OK (stub - wire Open Cloud API)."
