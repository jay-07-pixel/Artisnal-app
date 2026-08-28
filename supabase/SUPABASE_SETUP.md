# Supabase setup for Artisanal Lens

This app uses **Supabase** for artisan accounts, cloud backup of shot sets, and
photo storage. Local SQLite remains the source of truth; sync runs when the
device is online and the artisan is signed in.

## 1. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and create a project.
2. Open **Project Settings → API** and copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon public** key → `SUPABASE_ANON_KEY`

## 2. Apply the database schema

### Option A — Supabase Dashboard (quickest)

1. Open **SQL Editor** in your project.
2. Paste the contents of
   [`migrations/20250828120000_initial_schema.sql`](migrations/20250828120000_initial_schema.sql).
3. Run the script.

### Option B — Supabase CLI

```bash
npm install -g supabase
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase db push
```

## 3. Create the Storage bucket

The migration creates a private `photos` bucket and RLS policies. Verify in
**Storage** that `photos` exists. Photos are stored at:

```
{user_id}/{set_id}/{shot_id}.jpg
```

## 4. Auth settings (important for mobile)

### Fix the localhost confirm-email link

If the confirmation email opens **http://localhost:3000**, your Supabase
project Site URL is wrong for a phone-only app.

1. Open [Supabase Dashboard](https://supabase.com/dashboard) → your project.
2. Go to **Authentication → URL Configuration**.
3. Set **Site URL** to your project URL, e.g.  
   `https://tghlozzogdkejgophiqs.supabase.co`  
   (not `http://localhost:3000`).
4. Under **Redirect URLs**, you can add:  
   `https://tghlozzogdkejgophiqs.supabase.co/**`

### Recommended for this app: skip email confirmation

Artisans use the **Android app only** — there is no website at localhost to
complete sign-up.

1. **Authentication → Providers → Email**
2. Turn **OFF** **Confirm email**
3. Save

Then create account → sign in works immediately in the app. No email link
needed.

If you keep confirmation on: after clicking the email link (even on a dead
page), return to the app and tap **Sign in** with the same email/password.

## 5. Run the app with credentials

Never commit real keys. Pass them at run time:

```bash
cd artisanal_lens
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Release APK:

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Copy [`../artisanal_lens/supabase.local.example.json`](../artisanal_lens/supabase.local.example.json)
to `supabase.local.json` in the app folder (this file is gitignored).

## 6. Tutorial videos (keeps the APK small)

Tutorial `.mp4` files are **not** bundled in the app. They stream from a public
Supabase Storage bucket named `tutorial-videos`, so you can add more videos
without increasing APK size.

### Apply the bucket migration

Run the SQL in
[`migrations/20250828130000_tutorial_videos_bucket.sql`](migrations/20250828130000_tutorial_videos_bucket.sql)
in the Supabase SQL Editor (or `supabase db push`).

### Upload videos

Each catalog preset expects a filename like `cushion_propped.mp4`. Upload via:

1. **Dashboard** — **Storage → tutorial-videos → Upload file**
2. **CLI** — from a folder of `.mp4` files:

```bash
supabase storage cp ./my-videos/cushion_propped.mp4 ss:///tutorial-videos/cushion_propped.mp4
```

Name files exactly as listed in `preset_catalog.dart` (e.g. `cushion_flat_lay.mp4`,
`saree_pallu_drape.mp4`). After the first stream, the app caches the file on the
phone for faster replays.

### All 16 catalog video keys

| Key |
|-----|
| `saree_pallu_drape.mp4` |
| `saree_box_fold.mp4` |
| `saree_worn_drape.mp4` |
| `saree_roll_display.mp4` |
| `cushion_flat_lay.mp4` |
| `cushion_stacked_pair.mp4` |
| `cushion_propped.mp4` |
| `cushion_corner_tuck.mp4` |
| `shawl_draped_shoulder.mp4` |
| `shawl_folded_stack.mp4` |
| `shawl_hung_flat.mp4` |
| `shawl_corner_tuck.mp4` |
| `stole_neck_wrap.mp4` |
| `stole_flat_spread.mp4` |
| `stole_loose_knot.mp4` |
| `stole_rolled_coil.mp4` |

## 7. Sign in inside the app

1. Open **Settings → Account & backup**.
2. Create an account or sign in.
3. Tap **Sync photos now**, or capture photos — sync runs automatically after
   each accepted shot when online.

## Without Supabase

If you omit the `--dart-define` flags, the app works fully offline as before.
Settings shows “Cloud backup not configured”.

## What syncs

| Data | Where |
|---|---|
| Shot set metadata | `public.shot_sets` |
| Shot metadata | `public.shots` |
| JPEG files | Storage bucket `photos` |
| Tutorial videos | Storage bucket `tutorial-videos` (public, streamed) |
| User profile | `public.profiles` (auto-created on sign-up) |

Catalog presets, photography templates, and live camera guidance stay on-device.
Tutorial videos stream from Supabase when online.

## Troubleshooting sign-in

### Spinner never stops / “Supabase login is not responding”

This usually means the **Auth service** on your Supabase project is stuck or
paused — not a bug in turning off “Confirm email”.

1. Open [Supabase Dashboard](https://supabase.com/dashboard) → your project.
2. Check **Project Settings → General** — if the project is **Paused**, click
   **Restore project**.
3. If it shows as active, use **Restart project** (same page).
4. Go to **Authentication → Providers → Email**, turn **Confirm email** OFF,
   then click **Save changes** (required).
5. Open **Logs → Auth** and look for errors around the time sign-in failed.

You can verify Auth is healthy: in a browser or terminal,  
`https://YOUR_PROJECT.supabase.co/auth/v1/health` should respond in under 2
seconds. If it hangs, restart the project or contact Supabase support.

### “Invalid login credentials”

Wrong email/password, or the account was created before you turned off email
confirmation. Create a new account after saving the Auth settings, or confirm
the existing user in **Authentication → Users**.
