param([string]$StoryBranch,[string]$FallbackBranch="develop")
$repos=@("mms-solution","mms-app","maui-toolkit","net-client-api")
foreach($r in $repos){if(Test-Path $r){Push-Location $r; git fetch origin; git checkout $StoryBranch; if($LASTEXITCODE -ne 0){git checkout $FallbackBranch}; Pop-Location}}
