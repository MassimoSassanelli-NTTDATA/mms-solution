param(
    [string]$Owner = "MassimoSassanelli-NTTDATA",

    # Workspace root where the sub-repositories are cloned as sibling folders.
    # Defaults to the platform repository root (this script's folder), matching
    # the layout expected by .gitignore and scripts/generate-workspace-context.ps1.
    [string]$Root = $PSScriptRoot,

    # Skip generating WORKSPACE.md / REPOSITORY_CONTEXT.md after cloning.
    [switch]$SkipContext
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositories = @(
    "mms-app",
    "maui-toolkit",
    "net-client-api"
)

New-Item -ItemType Directory -Force -Path $Root | Out-Null

foreach ($repo in $repositories) {
    $target = Join-Path $Root $repo
    if (Test-Path -LiteralPath $target) {
        Write-Host "Repository already exists: $repo"
        continue
    }

    git clone "https://github.com/$Owner/$repo.git" $target
}

if (-not $SkipContext) {
    # Reproduce the Copilot Cloud Agent setup locally: generate WORKSPACE.md and
    # REPOSITORY_CONTEXT.md from the platform manifest.
    & (Join-Path $PSScriptRoot "scripts\generate-workspace-context.ps1") -RepoRoot $Root
}

Write-Host "Workspace ready: $Root"
