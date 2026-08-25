# The Artisanal Lens

A guided photography app for handloom artisans. The artisan picks a product,
the app tells them exactly which photographs to take and how to set each one
up, checks framing, light and angle live through the camera, and tracks the set
until it is complete.

Built from two sources:

- **UI/UX** — the Figma file *Artisans lens*
  (`rrmw1aZ2InrsBFfy3QwL5L`). Colours, type, spacing, screen structure and copy
  are taken from it directly; nothing visual is invented here.
- **Behaviour** — the BTP report *Product Photography Guide for Handloom
  Artisans* (IIT Guwahati) and the *Artisanal Lens* solution deck, which supply
  the photography guidelines, fabric-property mapping and preset definitions.

## Running it

```bash
flutter pub get
flutter run
```

Requires a physical device for the capture flow — the guidance reads real
camera frames and the accelerometer.

```bash
flutter analyze     # static analysis
flutter test        # unit tests
```

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
                                        │                                  ├─ set incomplete ─> Product Setup
                                        │                                  └─ set complete ───> Completion
                                        └─> Product Viewer  <── Gallery
```

Every empty slot in the Product Viewer is tappable and re-enters the capture
flow aimed at that specific photograph.

## A complete set is seven photographs

Taken from the Figma checklist (`0 / 7 Photos`) and the gallery captions:

| Shot type | Count | Slots                     |
|-----------|-------|---------------------------|
| Process   | 2     | Loom setup, Dyeing        |
| Product   | 1     | Hero shot                 |
| Detail    | 3     | Border, Weave, Motif      |
| Lifestyle | 1     | Styled shot               |

Process and Detail shots skip the style step: a fold preset describes how to
arrange finished cloth, and neither a loom nor a macro shot of the weave has a
drape to choose. Both use their shot type's own `fallbackTechnique`.

## The opening sequence

`features/onboarding/` paints a 4.2-second sequence on every launch: an empty
warm workspace, a folded saree dropping in, opening into a drape, the capture
guide drawing itself over it with light/angle/frame chips, a focus lock and
shutter, then a handoff into Home. Tapping anywhere skips it.

It is drawn rather than played from a video, so it costs a few kilobytes, scales
to any screen and uses the real palette. The cloth is thirty vertical panels
shaded by a sine running across the width — fabric reads as light catching
successive folds — with width opening ahead of height so it falls open the way
folded cloth does rather than scaling like a rectangle.

## Architecture

Layered, with dependencies pointing inward. `domain` has no Flutter import and
no knowledge of storage.

```
lib/
├── app/                  MaterialApp, router, DI, theme tokens
│   └── theme/            app_colors · app_typography · app_dimens  (from Figma)
├── domain/
│   ├── entities/         ShotSet, ShotType, FoldPreset, TechniquePreset,
│   │                     PhotographyGuideline, FabricProperty, CaptureFeedback
│   ├── repositories/     abstract interfaces
│   └── services/         FrameAnalyzer, CaptureGuidanceService  (pure logic)
├── data/
│   ├── datasources/      preset_catalog (bundled) · app_database (sqflite)
│   └── repositories/     implementations
├── features/<feature>/   presentation + its controller
└── shared/widgets/       AppShell, PhotoThumb, AppPill, AppProgressBar …
```

**State** — Riverpod. `shotSetsProvider` is the single source of truth for
shoots, so a photo accepted on the review screen updates the home, checklist,
gallery and viewer without any of them re-querying. `captureSessionProvider`
carries the accumulated choices across the one-decision-per-screen flow.

**Navigation** — `go_router`. A `ShellRoute` holds the three tabbed
destinations; the capture flow runs above the shell so the bottom bar is out of
the way mid-shoot.

**Storage** — sqflite, local-only. A shoot survives being closed mid-set with
no connectivity. Accepted photographs are copied out of the camera's temp
directory into app storage and also written to the phone gallery under the
album *The Artisanal Lens*.

### Live capture guidance

This is the part with real logic behind it, in `domain/services/`:

`FrameAnalyzer` reads only the luma (Y) plane of each YUV420 preview frame,
sampling every 8th pixel, and measures mean/centre/border brightness, local
texture inside and outside the ghost frame, and the centre of mass of that
texture. From those it derives backlight ratio, subject fill and centring
offset.

`CaptureGuidanceService` turns those measurements plus device pitch into the
single most useful prompt, in a deliberate priority order:

1. **Light** — too dark / too bright. Checked first: framing cannot rescue an
   unusable exposure, and user testing found light was what artisans got wrong
   most often.
2. **Backlight** — unless the preset wants it (sheer fabrics are shot against
   the light on purpose to show transparency).
3. **Angle** — fixed by tilting, not moving.
4. **Distance** — move closer / move further.
5. **Centring**.
6. **Ready**.

Distance ordering is subtle and covered by a test: when the subject overflows
the guide, the border becomes as textured as the centre, which drags the fill
ratio down to the same low value an *empty* guide produces. The two are told
apart by absolute centre texture, so that check runs before the ratio check.

Guidance advises but never blocks — the shutter stays enabled whatever the
prompt says.

## Adding a category

Categories and presets are plain data in
`lib/data/datasources/preset_catalog.dart`. Add a `ProductCategory` and its
`FoldPreset`s; nothing in the UI needs touching. Swap
`BundledCatalogDataSource` for a remote or JSON-backed `CatalogDataSource` when
the catalogue should be updatable without a release.

## Preset artwork

`tools/make_preset_images.py` builds all sixteen preset thumbnails into
`assets/images/presets/`. Run it after changing the catalogue:

```bash
python tools/make_preset_images.py
```

It does two different things, because the design file only covers saree:

**The four saree cards are photographs**, recovered from the Figma image fills
in `tools/figma_src/`. Two of those uploaded assets are UI screenshots with the
real photograph sitting inside them, so the script crops each down to just the
photograph — hence the pixel crop boxes in `salvage_saree()`.

**The other twelve are drawn.** Figma has no artwork for cushion cover, shawl or
stole. Cropping the category photograph into four variants was rejected: a card
labelled "folded stack" showing a draped shawl teaches the artisan the wrong
arrangement, which is worse than an obvious diagram. Each card is drawn instead
in the Figma palette, showing the arrangement plainly.

They are placeholders in the sense that real photographs would serve better —
drop a photograph into `tools/figma_src/` and add it to `salvage_saree()` to
replace one.

## Known gaps
- **Setup tutorials** — `FoldPreset` carries `setupSteps`, `tutorialVideoAsset`
  and `tutorialTranscript`, which the BTP report calls for (§8.2: static
  illustrations were replaced by short localised videos after user testing).
  No screen consumes them yet because the Figma file has no tutorial screen.
  The data is in place for when that screen is designed.
- **Localisation** — the language choice is real: it persists across launches
  (`LocaleController`) and drives `MaterialApp.locale`, so Flutter's own
  widgets follow it. The app's own copy does not: roughly 108 strings in the
  screens and another ~200 in the preset catalogue are still English literals.

  Translating them is deliberately left open rather than machine-filled. This
  app exists because artisans cannot read English instructions (BTP: 42% cite
  language barriers), so a wrong Assamese verb in "Move closer to the window"
  is worse than no translation at all — these need a native speaker from the
  Kamrup cluster, ideally the same artisans from the §8 testing round. The
  plumbing is in place: add `flutter_localizations` ARB files and swap the
  literals for generated getters.
