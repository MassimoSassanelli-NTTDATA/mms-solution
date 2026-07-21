param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

git -C $RepoRoot config core.hooksPath .githooks

$syncScript = Join-Path $RepoRoot "scripts\sync-subrepo-skills.ps1"
& $syncScript

Write-Host "[install-git-hooks] core.hooksPath set to .githooks"
Write-Host "[install-git-hooks] Initial skill sync completed"
