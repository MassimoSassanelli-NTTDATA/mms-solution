param([string]$StoryBranch,[string]$BaseBranch="develop")
$repos=@("mms-solution","mms-app","maui-toolkit","net-client-api")
foreach($r in $repos){if(Test-Path $r){Push-Location $r; git fetch origin; git checkout $BaseBranch; git pull origin $BaseBranch; git checkout -B $StoryBranch; git push -u origin $StoryBranch; Pop-Location}}
