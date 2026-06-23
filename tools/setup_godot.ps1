$ErrorActionPreference = "Stop"

$Version = $env:GODOT_VERSION
if (-not $Version) {
    $Version = "4.7"
}

$Root = Join-Path (Resolve-Path ".").Path ".godot-bin"
$Zip = Join-Path $Root "godot-$Version-win64.zip"
$Url = "https://github.com/godotengine/godot-builds/releases/download/$Version-stable/Godot_v$Version-stable_win64.exe.zip"

New-Item -ItemType Directory -Force -Path $Root | Out-Null
if (-not (Test-Path -LiteralPath $Zip)) {
    Invoke-WebRequest -Uri $Url -OutFile $Zip
}
Expand-Archive -LiteralPath $Zip -DestinationPath $Root -Force
Get-ChildItem -LiteralPath $Root -Filter "Godot*_win64.exe" -Recurse | Select-Object -First 1
