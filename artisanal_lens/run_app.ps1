# Runs The Artisanal Lens on the Android emulator.
#
#   .\run_app.ps1              hot-reload dev session (flutter run)
#   .\run_app.ps1 -Apk         install the built APK instead (no dev session)
#   .\run_app.ps1 -Avd Pixel_6 use a different emulator
#
# Handles two quirks of this machine:
#   * the emulator window opens off-screen (top = -1096), so it gets moved back
#   * `flutter emulators --launch` ties the emulator to the shell, so it is
#     started detached instead and survives the terminal closing

param(
    [string]$Avd = "Pixel_7_Pro",
    [switch]$Apk
)

$ErrorActionPreference = "Stop"
$sdk     = "$env:LOCALAPPDATA\Android\Sdk"
$adb     = "$sdk\platform-tools\adb.exe"
$emuExe  = "$sdk\emulator\emulator.exe"
$package = "com.artisanallens.artisanal_lens"

Set-Location $PSScriptRoot

# ---------------------------------------------------------------- emulator ---
$running = & $adb devices | Select-String "emulator-\d+\s+device"

if (-not $running) {
    Write-Host "Starting emulator '$Avd'..." -ForegroundColor Cyan
    Start-Process -FilePath $emuExe -ArgumentList "-avd", $Avd -WindowStyle Normal

    Write-Host "Waiting for boot (can take a couple of minutes)..." -ForegroundColor Cyan
    for ($i = 0; $i -lt 90; $i++) {
        Start-Sleep -Seconds 5
        $booted = (& $adb shell getprop sys.boot_completed 2>$null) -replace '\s',''
        if ($booted -eq "1") { break }
    }
    if ($booted -ne "1") { throw "Emulator did not finish booting." }
    Write-Host "Emulator ready." -ForegroundColor Green
} else {
    Write-Host "Emulator already running." -ForegroundColor Green
}

# ------------------------------------------------- drag window back on screen ---
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class EmuWin {
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr h, int x, int y, int w, int ht, bool repaint);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
}
"@
$win = Get-Process qemu-system-x86_64 -ErrorAction SilentlyContinue |
       Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
if ($win) {
    [EmuWin]::ShowWindow($win.MainWindowHandle, 9)                      | Out-Null
    [EmuWin]::MoveWindow($win.MainWindowHandle, 60, 20, 420, 780, $true) | Out-Null
    [EmuWin]::SetForegroundWindow($win.MainWindowHandle)                 | Out-Null
    Write-Host "Emulator window placed at (60,20)." -ForegroundColor Green
}

# --------------------------------------------------------------------- app ---
if ($Apk) {
    $path = "build\app\outputs\flutter-apk\app-debug.apk"
    if (-not (Test-Path $path)) {
        Write-Host "No APK yet - building..." -ForegroundColor Cyan
        flutter build apk --debug
    }
    Write-Host "Installing..." -ForegroundColor Cyan
    & $adb install -r -t $path
    & $adb shell pm grant $package android.permission.CAMERA 2>$null
    & $adb shell am start -n "$package/.MainActivity" | Out-Null
    Write-Host "Launched. (No hot reload - run without -Apk for that.)" -ForegroundColor Green
} else {
    Write-Host "Starting dev session - press r to hot reload, q to quit." -ForegroundColor Cyan
    flutter run
}
