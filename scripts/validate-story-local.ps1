param([string]$Root=".",[string]$Report="story-validation-report.md")
Set-Location $Root
"# Local Story Validation Report" | Out-File $Report -Encoding utf8
Get-ChildItem -Recurse -Include *.sln,*.slnx | ForEach-Object { dotnet restore $_.FullName; dotnet build $_.FullName --no-restore; dotnet test $_.FullName --no-build }
