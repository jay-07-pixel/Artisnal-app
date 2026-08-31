# Cursor prompt — run The Artisanal Lens after clone

Copy everything below into a **new Cursor chat** after opening the cloned repo.

---

```
Clone: https://github.com/jay-07-pixel/Artisnal-app
App folder: artisanal_lens/

Supabase is already configured in the repo (defaults in lib/app/supabase_config.dart and artisanal_lens/supabase.local.json). Shared project URL: https://tghlozzogdkejgophiqs.supabase.co

Do this for me on Windows:

1. cd artisanal_lens
2. flutter pub get
3. If I want web: dart run sqflite_common_ffi_web:setup
4. flutter run   (plain run — Supabase should initialize; Settings should NOT say "Cloud backup not configured")
5. If flutter run fails on device, try: .\run_app.ps1

For release APK:
flutter build apk --release --dart-define-from-file=supabase.local.json

Do not ask me for Supabase keys — they are already in the repo. If cloud sync still fails, check flutter analyze and fix any issues, then run again.

Requirements: Flutter SDK with Dart ^3.12.0, Android phone or emulator for camera features.
```

---

## Quick manual steps (no Cursor)

```bash
git clone https://github.com/jay-07-pixel/Artisnal-app.git
cd Artisnal-app/artisanal_lens
flutter pub get
flutter run
```

On Windows PowerShell you can also use `.\run_app.ps1`.
