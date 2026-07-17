param(
    [Parameter(Mandatory = $true)]
    [string]$Owner = "MassimoSassanelli-NTTDATA",

    [string]$Root = "mobile-maintenance-platform"
)

$repositories = @(
    "mobile-maintenance-app",
    "maui-toolkit",
    "net-client-api"
)

New-Item -ItemType Directory -Force -Path $Root | Out-Null
Set-Location $Root

foreach ($repo in $repositories) {
    if (Test-Path $repo) {
        Write-Host "Repository already exists: $repo"
        continue
    }

    git clone "https://github.com/$Owner/$repo.git" $repo
}

Write-Host "Workspace ready: $Root"
