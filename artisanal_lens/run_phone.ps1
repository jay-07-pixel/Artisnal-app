# Run Artisanal Lens on a physical Android phone (USB debugging).
#
#   .\run_phone.ps1              flutter run on the connected phone
#   .\run_phone.ps1 -Release     build + install release APK (no dev session)
#
# Prerequisites:
#   1. USB debugging ON (Developer options)
#   2. Phone connected by USB cable
#   3. Tap "Allow" on the USB debugging prompt on the phone
#   4. supabase.local.json present for cloud sync (gitignored)

param(
    [switch]$Release
)

$ErrorActionPreference = "Stop"
$sdk = "$env:LOCALAPPDATA\Android\Sdk"
$adb = "$sdk\platform-tools\adb.exe"
$package = "com.artisanallens.artisanal_lens"

Set-Location $PSScriptRoot

if (-not (Test-Path $adb)) {
    throw "adb not found at $adb - install Android SDK platform-tools."
}

Write-Host "Checking for Android devices..." -ForegroundColor Cyan
& $adb start-server | Out-Null
$lines = & $adb devices | Select-String "^\S+\s+device$"

if (-not $lines) {
    Write-Host ""
    Write-Host "No phone detected." -ForegroundColor Red
    Write-Host "  1. Connect phone with USB cable (data port, not charge-only)"
    Write-Host "  2. Settings > Developer options > USB debugging > ON"
    Write-Host "  3. On phone, tap Allow when asked for USB debugging"
    Write-Host "  4. Run: adb devices"
    Write-Host ""
    & $adb devices
    exit 1
}

$deviceId = ($lines[0].Line -split "\s+")[0]
Write-Host "Using device: $deviceId" -ForegroundColor Green

$defineFile = Join-Path $PSScriptRoot "supabase.local.json"
$defineArgs = @()
if (Test-Path $defineFile) {
    $defineArgs = @("--dart-define-from-file=$defineFile")
    Write-Host "Supabase: using supabase.local.json" -ForegroundColor Green
} else {
    Write-Host "Supabase: offline only (add supabase.local.json for cloud sync)." -ForegroundColor Yellow
}

if ($Release) {
    Write-Host "Building release APK..." -ForegroundColor Cyan
    flutter build apk --release @defineArgs
    $apk = "build\app\outputs\flutter-apk\app-release.apk"
    Write-Host "Installing $apk ..." -ForegroundColor Cyan
    & $adb -s $deviceId install -r $apk
    & $adb -s $deviceId shell pm grant $package android.permission.CAMERA 2>$null
    & $adb -s $deviceId shell pm grant $package android.permission.INTERNET 2>$null
    & $adb -s $deviceId shell pm grant $package android.permission.READ_MEDIA_IMAGES 2>$null
    & $adb -s $deviceId shell am start -n "$package/.MainActivity" | Out-Null
    Write-Host "Installed and launched on $deviceId." -ForegroundColor Green
} else {
    Write-Host "Starting dev session on $deviceId (r = hot reload, q = quit)..." -ForegroundColor Cyan
    flutter run -d $deviceId @defineArgs
}
