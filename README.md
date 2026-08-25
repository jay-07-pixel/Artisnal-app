# The Artisanal Lens

A guided photography app for handloom artisans, built in Flutter.

Indian handloom weavers struggle to sell online largely because their product
photographs do not convey what the cloth is actually like — its texture, drape,
weight and transparency. This app closes that gap without asking the artisan to
learn photography: it tells them which photographs a listing needs, how to
arrange the cloth for each one, and then checks light, angle and framing live
through the camera before the shutter is pressed.

> Before you take the photo, The Artisanal Lens prepares the saree and shows
> you what a good photograph should look like.

---

## Where it comes from

| Source | Supplies |
|---|---|
| Figma file *Artisans lens* | Every colour, type ramp, spacing value, screen structure and string. Nothing visual is invented. |
| BTP report — *Product Photography Guide for Handloom Artisans* (IIT Guwahati) | The eight photography guidelines, the fabric-property mapping, and the findings from user testing with eight artisans in the Kamrup cluster, Assam. |
| *Artisanal Lens* solution deck | The category-first flow and the fold / styling preset lists. |

The research findings shaped concrete decisions, not just copy. Text
instructions failed in testing, so the UI is icon-led with one decision per
screen. Artisans could not judge lighting reliably, so the app measures it
rather than describing it. Low-opacity overlays were invisible in sunlight, so
the ghost frame is high contrast.

---

## Running it

```bash
cd artisanal_lens
flutter pub get
flutter run
```

Requires Flutter with Dart SDK `^3.13.1`.

For the web build, fetch the sqlite WASM worker first (it is gitignored):

```bash
dart run sqflite_common_ffi_web:setup
flutter run -d chrome
```

```bash
flutter analyze    # static analysis
flutter test       # 60 tests
```

**Use a release build to judge the app.** Debug builds JIT-compile Dart at
startup, which buries the opening animation behind several seconds of splash:

```bash
flutter build apk --release
```

---

## The flow

```
Opening sequence  (4.2s, tap to skip)
  └─ Home ──────────────┬─ New Product ─┐
     (bottom nav)       ├─ Continue ────┤
                        └─ Recent ──────┼─> Product Setup
                                        │     (category · name · Start Photography)
                                        │        └─> Shot & Style
                                        │              (step 1: type · step 2: style)
                                        │                 └─> Guided Capture
                                        │                       └─> Review & Retake
                                        │                             ├─ Retake ─┘
                                        │                             └─ Use Photo
                                        │                                  ├─ incomplete ─> Product Setup
                                        │                                  └─ complete ───> Completion
                                        └─> Product Viewer  <── Gallery
```

Every empty slot in the Product Viewer is tappable and re-enters the capture
flow aimed at that one photograph.

### A complete set is seven photographs

Taken from the Figma checklist (`0 / 7 Photos`) and the per-slot gallery
captions:

| Shot type | Count | Slots |
|---|---|---|
| Process | 2 | Loom setup, Dyeing |
| Product | 1 | Hero shot |
| Detail | 3 | Border, Weave, Motif |
| Lifestyle | 1 | Styled shot |

Process and Detail skip the style step. A fold preset describes how to arrange
finished cloth, and neither a loom nor a macro shot of the weave has a drape to
choose; both fall back to their shot type's own technique.

---

## The part with real logic behind it

Live capture guidance, in `lib/domain/services/`, is genuine image analysis
rather than a scripted animation.

**`FrameAnalyzer`** reads only the luma (Y) plane of each YUV420 preview frame,
sampling every 8th pixel and respecting row stride. It measures mean, centre
and border brightness, local texture inside and outside the ghost frame, and
the centre of mass of that texture — yielding a backlight ratio, a subject fill
ratio and a centring offset.

**`CaptureGuidanceService`** turns those plus device pitch into the single most
useful prompt, in a deliberate order:

1. **Light** — too dark / too bright. First, because framing cannot rescue an
   unusable exposure, and testing found light was what artisans got wrong most.
2. **Backlight** — unless the preset wants it; sheer fabrics are shot against
   the light on purpose to show transparency.
3. **Angle** — fixed by tilting, not moving.
4. **Distance** — move closer / move further.
5. **Centring.**
6. **Ready.**

One subtlety is covered by a test: when the subject *overflows* the guide, the
border becomes as textured as the centre, so the fill ratio collapses to the
same low value an *empty* guide produces. The two are told apart by absolute
centre texture, so that check must run before the ratio check.

Guidance advises but never blocks — the shutter stays live whatever it says.

---

## Architecture

Layered, dependencies pointing inward. `domain/` imports no Flutter and knows
nothing about storage. 45 Dart files, ~7,800 lines.

```
artisanal_lens/lib/
├── app/                  MaterialApp, router, DI, locale, theme tokens
│   └── theme/            app_colors · app_typography · app_dimens   (from Figma)
├── domain/
│   ├── entities/         ShotSet, ShotType, FoldPreset, TechniquePreset,
│   │                     PhotographyGuideline, FabricProperty, CaptureFeedback
│   ├── repositories/     abstract interfaces
│   └── services/         FrameAnalyzer, CaptureGuidanceService   (pure logic)
├── data/
│   ├── datasources/      preset_catalog · app_database · photo_storage
│   └── repositories/     implementations
├── features/<feature>/   presentation + its controller
└── shared/widgets/       AppShell, PhotoThumb, AppPill, AppProgressBar …
```

**State** — Riverpod. `shotSetsProvider` is the single source of truth for
shoots, so a photo accepted on the review screen updates home, gallery and
viewer without any of them re-querying. `captureSessionProvider` carries the
accumulated choices across the one-decision-per-screen flow.

**Navigation** — `go_router`. A `ShellRoute` holds the tabbed destinations; the
capture flow runs above the shell so the bottom bar is out of the way mid-shoot.

**Storage** — sqflite, local only, offline-first: a shoot survives being closed
mid-set with no connectivity. `PhotoStorage` is an interface with two
implementations chosen by conditional import, because the platforms have
nothing in common here — Android copies the capture into app documents and also
writes it to the phone gallery, while a browser has no filesystem and keeps the
bytes in memory. On web the same SQL runs against sqlite compiled to WASM over
IndexedDB, so no query is forked.

---

## Platform support

| | Android | Web |
|---|---|---|
| Full navigation flow | yes | yes |
| Camera preview and capture | yes | yes |
| **Live light / angle / framing guidance** | **yes** | **no** |
| Photos survive a restart | yes | records yes, images no |
| Save to device gallery | yes | no |

`camera_web` exposes no image stream, so the frame analysis cannot run in a
browser. The chips are hidden there rather than left showing a stale verdict.
**Judge the guidance on Android.**

---

## Adding a category

Categories and presets are plain data in
`lib/data/datasources/preset_catalog.dart`. Add a `ProductCategory` and its
`FoldPreset`s; no UI changes needed. `test/catalog_coverage_test.dart` then
asserts, across every category × shot type, that the artisan can actually reach
the camera — the check that catches a preset list with a hole in it.

Preset thumbnails are built by `tools/make_preset_images.py`.

---

## Known gaps

- **Preset artwork.** The four saree cards are photographs recovered from the
  Figma image fills. The other twelve are drawn, because Figma has no artwork
  for cushion cover, shawl or stole. Cropping the category photograph into four
  variants was rejected: a card labelled "folded stack" showing a draped shawl
  teaches the wrong arrangement, which is worse than an obvious diagram.
- **Detail presets.** Detail needs 3 photographs but each category defines at
  most one Detail preset. Not blocking, since Detail skips the style step, but
  those shots currently get no styling guidance.
- **Setup tutorials.** `FoldPreset` already carries `setupSteps`,
  `tutorialVideoAsset` and `tutorialTranscript` — the BTP report (§8.2) replaced
  static illustrations with short localised videos after user testing. No screen
  consumes them yet because Figma has no tutorial screen.
- **Localisation.** The language choice is real: it persists across launches and
  drives `MaterialApp.locale`. The app's own strings are not translated — about
  108 in the screens and 200 in the preset catalogue. Deliberately left for a
  native Assamese speaker rather than machine-filled, because this app exists
  precisely because its users cannot read English instructions, and a wrong verb
  in "Move closer to the window" is worse than no translation.

---

## Repository layout

```
.
├── artisanal_lens/     the Flutter application
├── docs/               BTP report and solution deck
└── README.md
```

Detailed architecture notes live in [`artisanal_lens/README.md`](artisanal_lens/README.md),
and how to run on an emulator or localhost in
[`artisanal_lens/RUNNING.md`](artisanal_lens/RUNNING.md).
