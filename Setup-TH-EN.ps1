# Restore the fixed English/Thai badge mapping beside this script.
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$carets = Join-Path $root 'carets'
$assets = Join-Path $root 'assets'
foreach ($name in @('EN.png','TH.png')) {
    if (-not (Test-Path -LiteralPath (Join-Path $assets $name))) { throw "Missing assets\$name. Extract the complete ZIP first." }
}
if (Test-Path -LiteralPath $carets) {
    $backup = Join-Path $root ('carets-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmssfff'))
    Copy-Item -LiteralPath $carets -Destination $backup -Recurse
    Write-Host "Backup: $backup"
} else { New-Item -ItemType Directory -Path $carets | Out-Null }
foreach ($entry in @(@('1','EN'),@('2','TH'))) {
    foreach ($suffix in @('','-capslock')) {
        Copy-Item -LiteralPath (Join-Path $assets ($entry[1] + '.png')) -Destination (Join-Path $carets ($entry[0] + $suffix + '.png')) -Force
    }
}
Write-Host 'Done: 1 = EN (blue), 2 = TH (green). Exit and reopen Language Indicator to apply.'
Read-Host 'Press Enter to close'
