# studio_mcp.ps1 - JSON-RPC wrapper for Roblox Studio MCP proxy.
# Usage: .\studio_mcp.ps1 -Method tools/list
#        .\studio_mcp.ps1 -Method tools/call -Params '{"name":"execute_luau","arguments":{"code":"return 1","datamodel_type":"Edit"}}'
param(
    [Parameter(Mandatory = $true)][string]$Method,
    [string]$Params = "{}",
    [int]$TimeoutSec = 120
)

$versionsRoot = Join-Path $env:LOCALAPPDATA 'Roblox\Versions'
$exe = $null

# Roblox rotates the version directory on every Studio update. Prefer the
# bridge beside an already-open Studio process so the proxy version matches
# the session that needs to be attached; otherwise use the newest installed
# bridge instead of pinning a historical version hash.
try {
    $runningStudio = Get-Process -Name 'RobloxStudioBeta' -ErrorAction SilentlyContinue |
        Where-Object { $_.Path } |
        Select-Object -First 1
    if ($runningStudio) {
        $matching = Join-Path (Split-Path -Parent $runningStudio.Path) 'StudioMCP.exe'
        if (Test-Path -LiteralPath $matching) { $exe = $matching }
    }
} catch {
    $exe = $null
}

if (Test-Path $versionsRoot) {
    if (-not $exe) {
        $exe = Get-ChildItem -LiteralPath $versionsRoot -Directory -ErrorAction SilentlyContinue |
            ForEach-Object { Join-Path $_.FullName 'StudioMCP.exe' } |
            Where-Object { Test-Path $_ } |
            Sort-Object { (Get-Item -LiteralPath $_).LastWriteTime } -Descending |
            Select-Object -First 1
    }
}

if (-not $exe) {
    $contentFolder = (Get-ItemProperty -Path 'HKCU:\Software\Roblox\RobloxStudio' -Name ContentFolder -ErrorAction SilentlyContinue).ContentFolder
    if ($contentFolder) {
        $candidate = Join-Path (Split-Path $contentFolder -Parent) 'StudioMCP.exe'
        if (Test-Path $candidate) { $exe = $candidate }
    }
}

if (-not $exe) {
    Write-Error "StudioMCP.exe not found under $versionsRoot or the RobloxStudio ContentFolder"
    exit 1
}

$reqs = @(
    '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"kilo-reforge","version":"1.0"}}}',
    '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}',
    "{`"jsonrpc`":`"2.0`",`"id`":2,`"method`":`"$Method`",`"params`":$Params}"
)
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = $exe
$processInfo.UseShellExecute = $false
$processInfo.CreateNoWindow = $true
$processInfo.RedirectStandardInput = $true
$processInfo.RedirectStandardOutput = $true
$processInfo.RedirectStandardError = $true
$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo
[void]$process.Start()

# Give StudioMCP time to bind its proxy WebSocket and for Roblox Studio to
# reconnect before issuing the first Studio-facing request.
$process.StandardInput.WriteLine($reqs[0])
$process.StandardInput.Flush()
Start-Sleep -Milliseconds 750
$process.StandardInput.WriteLine($reqs[1])
$process.StandardInput.Flush()
Start-Sleep -Milliseconds 2250
$process.StandardInput.WriteLine($reqs[2])
$process.StandardInput.Flush()
$process.StandardInput.Close()

$output = $process.StandardOutput.ReadToEnd()
$diagnostics = $process.StandardError.ReadToEnd()
$process.WaitForExit([Math]::Max(1000, $TimeoutSec * 1000))
# Extract the last JSON line (the response to id:2)
$lines = $output -split "`n" | Where-Object { $_.Contains('"id":2') }
if (@($lines).Count -eq 0) {
    Write-Error "No response for id:2. Raw: $output Diagnostics: $diagnostics"
    exit 1
}
$responseLine = @($lines) | Select-Object -Last 1
$resp = $responseLine | ConvertFrom-Json
if ($resp.error) {
    Write-Error "MCP error: $($resp.error | ConvertTo-Json -Compress)"
    exit 1
}
$resp.result | ConvertTo-Json -Depth 12
