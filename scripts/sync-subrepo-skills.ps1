param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [switch]$Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$subrepos = @(
    "maui-toolkit",
    "mms-app",
    "net-client-api"
)

$mirrorRoot = Join-Path $RepoRoot ".github\skills"
$subrepoSkillPrefix = "_subrepo_"
$legacyMirrorRoot = Join-Path $mirrorRoot "subrepos"

if (Test-Path -LiteralPath $legacyMirrorRoot) {
    Remove-Item -LiteralPath $legacyMirrorRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $mirrorRoot -Force | Out-Null

# Remove previously generated prefixed subrepo skills in the root skills folder.
$generatedItems = @(Get-ChildItem -LiteralPath $mirrorRoot -Force | Where-Object { $_.Name -like "$subrepoSkillPrefix*" })
foreach ($generatedItem in $generatedItems) {
    Remove-Item -LiteralPath $generatedItem.FullName -Recurse -Force
}

# Remove legacy per-repo mirror folders from older script versions.
foreach ($repo in $subrepos) {
    $legacyRepoDestination = Join-Path $mirrorRoot $repo
    if (Test-Path -LiteralPath $legacyRepoDestination) {
        Remove-Item -LiteralPath $legacyRepoDestination -Recurse -Force
    }
}

$copiedAny = $false

foreach ($repo in $subrepos) {
    $source = Join-Path $RepoRoot "$repo\.github\skills"

    if (-not (Test-Path -LiteralPath $source)) {
        if (-not $Quiet) {
            Write-Host "[sync-subrepo-skills] Skip: source not found: $source"
        }

        continue
    }

    $items = @(Get-ChildItem -LiteralPath $source -Force)
    if ($items.Count -eq 0) {
        if (-not $Quiet) {
            Write-Host "[sync-subrepo-skills] Skip: empty source: $source"
        }

        continue
    }

    foreach ($item in $items) {
        $destinationName = "$subrepoSkillPrefix$repo`_$($item.Name)"
        $destination = Join-Path $mirrorRoot $destinationName

        if (Test-Path -LiteralPath $destination) {
            Remove-Item -LiteralPath $destination -Recurse -Force
        }

        Copy-Item -LiteralPath $item.FullName -Destination $destination -Recurse -Force
        $copiedAny = $true
    }

    if (-not $Quiet) {
        Write-Host "[sync-subrepo-skills] Copied $repo skills -> $mirrorRoot with prefix $subrepoSkillPrefix"
    }
}

if (-not $Quiet) {
    if ($copiedAny) {
        Write-Host "[sync-subrepo-skills] Done. Mirrored subrepo skills under $mirrorRoot"
    }
    else {
        Write-Host "[sync-subrepo-skills] Done. No source skills were copied."
    }
}
