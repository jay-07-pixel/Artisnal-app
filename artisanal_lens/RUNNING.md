# Running the app on the emulator

## The short way

```powershell
cd "C:\Users\ACER\OneDrive\Desktop\The Artisanal Lens\artisanal_lens"
.\run_app.ps1
```

Starts the emulator if it isn't up, waits for boot, drags the window back
on-screen, and opens a hot-reload session. Press `r` to reload, `R` to restart,
`q` to quit.

`.\run_app.ps1 -Apk` installs the built APK instead — faster to launch, but no
hot reload.

If PowerShell refuses to run the script:

```powershell
powershell -ExecutionPolicy Bypass -File .\run_app.ps1
```

---

## The manual way

`flutter`, `adb` and `emulator` are all on your PATH now, so these work from a
fresh terminal. **Open a new terminal first** — an already-open one still has
the old PATH.

### 1. Start the emulator

```powershell
emulator -avd Pixel_7_Pro
```

That command holds the terminal open and the emulator dies when you close it.
To detach it, use:

```powershell
Start-Process emulator -ArgumentList "-avd","Pixel_7_Pro"
```

List your AVDs with `emulator -list-avds`.

### 2. Wait until it's ready

```powershell
adb wait-for-device
adb devices          # want: emulator-5554   device
```

### 3. Run the app

```powershell
cd "C:\Users\ACER\OneDrive\Desktop\The Artisanal Lens\artisanal_lens"
flutter run
```

Or install a prebuilt APK:

```powershell
flutter build apk --debug
adb install -r -t build\app\outputs\flutter-apk\app-debug.apk
adb shell am start -n com.artisanallens.artisanal_lens/.MainActivity
```

---

## The window opens off-screen

On this machine the emulator opens at `top = -1096`, above the visible desktop —
the taskbar icon works but there's nothing to see. `run_app.ps1` fixes it
automatically. To fix it by hand, either:

- Right-click the taskbar icon → **Move**, then press the arrow keys, or
- Run this:

```powershell
Add-Type 'using System;using System.Runtime.InteropServices;
public class W{[DllImport("user32.dll")]public static extern bool MoveWindow(IntPtr h,int x,int y,int w,int t,bool r);}'
$p = Get-Process qemu-system-x86_64 | Where-Object {$_.MainWindowHandle -ne 0}
[W]::MoveWindow($p.MainWindowHandle, 60, 20, 420, 780, $true)
```

---

## Handy commands

| Task | Command |
|---|---|
| Connected devices | `adb devices` |
| App logs only | `flutter logs` |
| Errors only | `adb logcat -s flutter:E AndroidRuntime:E` |
| Screenshot to PC | `adb exec-out screencap -p > shot.png` |
| Wipe app data (fresh install state) | `adb shell pm clear com.artisanallens.artisanal_lens` |
| Uninstall | `adb uninstall com.artisanallens.artisanal_lens` |
| Shut the emulator down | `adb emu kill` |
| Static analysis | `flutter analyze` |
| Tests | `flutter test` |
| Release build | `flutter build apk --release` |

---

## If something goes wrong

**`adb devices` is empty** — the emulator died. Restart it with
`Start-Process emulator -ArgumentList "-avd","Pixel_7_Pro"`.

**`flutter run` can't find a device** — run `adb wait-for-device` first; the
emulator takes a minute or two to finish booting.

**"Flutter failed to delete build\..."** — OneDrive or a Gradle daemon is
holding the folder. Run `cd android; .\gradlew --stop; cd ..` then retry.

**Camera looks like a fake room** — that's the emulator's simulated scene. The
light and framing prompts are reacting to it genuinely, but for a real sense of
the guidance install the APK on a physical phone.
