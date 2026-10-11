param(
  [switch]$Check,
  [switch]$Repo,
  [switch]$Install
)
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot ".."))
if ($Install) {
  Write-Host "S0 does not install software automatically. Install verified Node 24 LTS, pnpm 12.7.0 and Godot 4.7.2."
  exit 2
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Error "Node.js is unavailable. Install Node.js 24 LTS."
  exit 1
}
if ($Repo) {
  node scripts/doctor.mjs --repo
} else {
  node scripts/doctor.mjs --all
}
exit $LASTEXITCODE
