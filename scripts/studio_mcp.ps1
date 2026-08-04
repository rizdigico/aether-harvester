# studio_mcp.ps1 - JSON-RPC wrapper for Roblox Studio MCP proxy.
# Usage: .\studio_mcp.ps1 -Method tools/list
#        .\studio_mcp.ps1 -Method tools/call -Params '{"name":"execute_luau","arguments":{"code":"return 1","datamodel_type":"Edit"}}'
param(
    [Parameter(Mandatory = $true)][string]$Method,
    [string]$Params = "{}",
    [int]$TimeoutSec = 120
)

$exe = "$env:LOCALAPPDATA\Roblox\Versions\version-ff6341faef444107\StudioMCP.exe"
if (-not (Test-Path $exe)) {
    Write-Error "StudioMCP.exe not found"
    exit 1
}

$reqs = @(
    '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"kilo-reforge","version":"1.0"}}}',
    '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}',
    "{`"jsonrpc`":`"2.0`",`"id`":2,`"method`":`"$Method`",`"params`":$Params}"
)
$input = $reqs -join "`n"

$output = $input | & $exe 2>$null | Out-String
# Extract the last JSON line (the response to id:2)
$lines = $output -split "`n" | Where-Object { $_ -match '"id":2' }
if ($lines.Count -eq 0) {
    Write-Error "No response for id:2. Raw: $output"
    exit 1
}
$resp = $lines[-1] | ConvertFrom-Json
if ($resp.error) {
    Write-Error "MCP error: $($resp.error | ConvertTo-Json -Compress)"
    exit 1
}
$resp.result | ConvertTo-Json -Depth 12
