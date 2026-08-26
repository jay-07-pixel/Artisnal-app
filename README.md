# The Artisanal Lens

A guided photography app for Indian handloom artisans, built in Flutter.

Handloom weavers struggle to sell online when product photographs do not show
what the cloth is actually like — texture, drape, weight, sheen. This app
closes that gap without asking the artisan to learn photography: it tells them
which photographs a listing needs, how to arrange the cloth, and then checks
light, angle and framing live through the camera before the shutter is pressed.

> Before you take the photo, The Artisanal Lens prepares the saree and shows
> you what a good photograph should look like.

Flutter app: [`artisanal_lens/`](artisanal_lens/). Package id:
`com.artisanallens.artisanal_lens`.

---

## Where it comes from

| Source | Supplies |
|---|---|
| Figma file *Artisans lens* | Colour, type, spacing, screen structure and copy. Nothing visual is invented. |
| BTP report — *Product Photography Guide for Handloom Artisans* (IIT Guwahati) | Eight photography guidelines, fabric-property mapping, five Saree photography templates, and findings from testing with artisans in the Kamrup cluster, Assam. |
| *Artisanal Lens* solution deck | Category-first flow and the fold / styling preset lists. |

Research shaped the product, not just the copy. Text instructions failed in
testing, so the UI is icon-led with one decision per screen. Artisans could not
judge lighting reliably, so the app measures it rather than describing it.

---

## Running it

```bash
cd artisanal_lens
flutter pub get
flutter run
```

Requires Flutter with Dart SDK `^3.12.0`. Use a physical Android phone to judge
live capture guidance — it reads real camera frames and the accelerometer.

For the web build, fetch the sqlite WASM worker first (it is gitignored):

```bash
dart run sqflite_common_ffi_web:setup
flutter run -d chrome
```

```bash
flutter analyze
flutter test
```

**Use a release build to judge the opening animation.** Debug builds JIT-compile
Dart at startup, which buries that sequence behind a long splash:

```bash
flutter build apk --release
```

More device notes: [`artisanal_lens/RUNNING.md`](artisanal_lens/RUNNING.md).

---

## The flow

```
Opening sequence  (tap to skip)
  └─ Home  (New Product · Continue · Previous sets)
        │
        ├─ New Product
        │     Material (Silk, Cotton, Wool, Jute)
        │       └─ Fibre type
        │            Silk → Mulberry, Eri, Tasar, Muga
        │            Cotton / Wool / Jute → four empty slots (types not documented yet)
        │              └─ Category (Saree, Cushion Cover, Shawl, Stole) + name
        │                   └─ Photo list
        │                        └─ How should it look?  (fold / style; skipped for Process and Detail)
        │                             └─ Lighting → Tutorial → Camera (live guidance)
        │                                  └─ Review (Use photo / Retake)
        │
        ├─ Previous sets  (All / Finished / Pending)
        └─ Gallery → Product viewer
```

Finished sets open the product viewer. Pending sets return to the photo list.
Empty slots in the viewer re-enter capture for that one photograph.

### Saree — five photography templates

Saree follows the Product Photography Guide, not the seven-shot Figma list:

| Template | Content |
|---|---|
| Full Saree Display | Colour, pattern, material |
| Texture & Weave | Texture, thickness, material, transparency |
| Draped Look | Flimsiness, sheen, flow, weight |
| Embroidery & Border Details | Embroidery, quality |
| Folded Stack / Saree Stack | Thickness, material weight |

List thumbnails and **How should it look?** cards use one matching saree
(teal/emerald silk, maroon gold-zari border) in the pose each step needs.

After a template is chosen, Saree still offers the four documented folds:
Pallu drape, Box / flat fold, Worn drape, Roll display.

### Other categories — seven photographs

Cushion Cover, Shawl and Stole keep the Figma checklist:

| Shot type | Count | Slots |
|---|---|---|
| Process | 2 | Loom setup, Dyeing |
| Product | 1 | Hero shot |
| Detail | 3 | Border, Weave, Motif |
| Lifestyle | 1 | Styled shot |

Process and Detail skip the style step. A fold describes how to arrange
finished cloth; a loom or a weave close-up has no drape to choose.

Each of those categories has four folds in the solution deck (for example
Cushion: Flat lay, Stacked pair, Propped, Corner tuck).

---

## Live capture guidance

In `artisanal_lens/lib/domain/services/`. This is real image analysis, not a
scripted animation.

There is no setup slideshow and nothing to press through. The camera opens,
reads frames four times a second, and says one thing about the cloth actually
in front of the lens. What it says changes as the cloth or the phone moves.

**`FrameAnalyzer`** reads the luma (Y) plane of each YUV420 preview frame in a
single pass and measures: brightness and clipped highlights, texture, a coarse
map of where the product is (its bounding box, how much of the ghost frame it
fills, how much of the frame edge it runs over), fine-versus-coarse detail for
focus, and the dominant direction the fabric runs in.

**`CaptureGuidanceService`** turns those plus device pitch into one prompt, in
triage order: nothing in view → product outside the guide or off the edge →
too small or too large → fabric direction against the grid → light → blur →
angle and centring → ready. Only the top complaint is shown, and prompts name
the product ("Center the saree", "Place the cushion cover in view").

Each preset supplies its own profile: its ghost frame, how much of it to fill,
and whether its grid asks for a direction the analyser can measure. Only two
do — folds parallel to the horizontal guides, and fabric along the diagonals.
Fabric type, sheen, transparency, embroidery quality and whether a human
folded something correctly are not measurable here and are never claimed;
they are listed per preset in `CameraGuidanceProfile.undetectableConditions`.

**`LiveGuidanceStabiliser`** holds a message on screen until a new verdict
repeats, and makes "Ready to capture" earn an extra frame, so the pill does
not strobe. Guidance advises but never blocks — the shutter stays live
whatever it says. `camera_web` has no image stream, so this runs on Android
only; on the web the pill shows the preset's composition rule and never
claims the shot is ready.

---

## Architecture

Layered, dependencies pointing inward. `domain/` imports no Flutter and knows
nothing about storage.

```
artisanal_lens/lib/
├── app/                  MaterialApp, router, DI, locale, theme tokens
├── domain/
│   ├── entities/         ShotSet, ShotType, FoldPreset, PhotographyTemplate,
│   │                     FabricMaterial, CaptureFeedback, …
│   ├── repositories/     abstract interfaces
│   └── services/         FrameAnalyzer, CaptureGuidanceService,
│                         LiveGuidanceStabiliser
├── data/
│   ├── datasources/      preset_catalog · app_database · photo_storage
│   └── repositories/     implementations
├── features/<feature>/   presentation + its controller
└── shared/widgets/
```

**State** — Riverpod. `shotSetsProvider` is the source of truth for shoots.
`captureSessionProvider` carries choices across the one-decision-per-screen
flow.

**Navigation** — `go_router`. Tabs sit in a `ShellRoute`; capture runs above
the shell so the bottom bar is hidden mid-shoot.

**Storage** — sqflite, local only, offline-first. A shoot survives being closed
mid-set. Photographs are copied into app storage and, on Android, into the
device gallery album *The Artisanal Lens*.

---

## Platform support

| | Android | Web |
|---|---|---|
| Full navigation flow | yes | yes |
| Camera preview and capture | yes | yes |
| **Live light / angle / framing guidance** | **yes** | **no** |
| Photos survive a restart | yes | records yes, images no |
| Save to device gallery | yes | no |

**Judge the guidance on Android.**

---

## Adding a category

Categories and folds are data in
`artisanal_lens/lib/data/datasources/preset_catalog.dart`. Add a
`ProductCategory` and its `FoldPreset`s. `test/catalog_coverage_test.dart`
checks that every category × shot type can reach the camera.

Saree photography templates live in
`artisanal_lens/lib/domain/entities/photography_template.dart`.

---

## Known gaps

- **Cotton, Wool and Jute types.** Those materials use the same type screen as
  Silk, with four empty boxes. Varieties are not named until a source documents
  them.
- **Tutorial videos and step illustrations.** The catalog points at those
  files; most are still missing, so the screens fail safe with placeholders.
- **Localisation.** Language choice persists and drives `MaterialApp.locale`.
  App strings are still English. Translation is left for a native Assamese
  speaker rather than machine-filled.

---

## Repository layout

```
.
├── artisanal_lens/     Flutter application
├── docs/               audit notes (BTP report / solution deck used as sources)
└── README.md
```

Architecture notes: [`artisanal_lens/README.md`](artisanal_lens/README.md).
