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
Opening sequence  (tap to skip)
  └─ Home  (New Product · Continue · Previous sets)
        └─ New Product
              Material → fibre type → category + name
                └─ Photo list
                     Saree: five BTP photography templates
                     Others: seven Figma shots
                       └─ How should it look?  (skipped for Process and Detail)
                            └─ Lighting → Tutorial → Camera (live guidance)
                                 └─ Review
```

New Product does not jump straight to Saree. Every material opens a type
screen; Cotton, Wool and Jute show empty boxes until varieties are documented.

The root [`README.md`](../README.md) has the full flow, Saree template list,
and fold names.

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

The artisan is never walked through setup steps. The camera opens, analyses a
frame every 250 ms, and shows one sentence about the cloth in front of it.

`FrameAnalyzer` reads only the luma (Y) plane of each YUV420 preview frame,
sampling every 8th pixel, and in one pass measures:

- mean / centre / border brightness, plus clipped highlights and shadows;
- local texture inside and outside the ghost frame, and its centre of mass;
- a 16×16 occupancy map of where the product is — a cell counts as product if
  it is noticeably woven, or noticeably brighter or darker than the surface
  running around the edge of the picture. That yields subject coverage, how
  much of the ghost frame is filled, the bounding box, and how much of the
  frame edge the cloth runs over;
- fine-versus-coarse detail, which collapses when a frame is smeared;
- the dominant edge direction and how strongly the frame agrees on it, from a
  structure tensor built with central differences.

`CaptureGuidanceService` turns those plus device pitch into the single most
useful prompt, in triage order — an artisan cannot act on "improve the light"
while the cloth is still out of shot:

1. **Nothing in view** — or, if the exposure is what is hiding it, the light.
2. **Position** — mostly outside the guide, or running off the edge.
3. **Size** — too small or too large.
4. **Fabric direction** — only for grids whose source guidance names one
   (folds along the horizontal guides; fabric along the diagonals), and only
   when the frame has a direction to speak of.
5. **Light** — too dark / too bright / backlit, unless the preset wants
   backlight (sheer fabrics are shot against the light on purpose).
6. **Blur** — needs both a collapsed detail ratio and near-absent fine detail,
   so a bold sharp weave is not mistaken for a shaky hand.
7. **Angle and centring.**
8. **Ready to capture.**

Each preset contributes a `CameraGuidanceProfile`: its ghost frame, how much
of it to fill, its product noun, its placement line, and which checks apply.
Anything the analyser cannot measure — fabric, sheen, transparency,
embroidery quality, whether a fold was made correctly — is listed in
`undetectableConditions` and never emitted as a prompt.

`LiveGuidanceStabiliser` requires a new verdict to repeat before it replaces
what is on screen, and gives "Ready to capture" an extra frame, so the pill
does not strobe between competing readings.

Distance ordering is subtle and covered by a test: when the subject overflows
the guide, the border becomes as textured as the centre, which drags the fill
ratio down to the same low value an *empty* guide produces. The two are told
apart by the occupancy map, which knows where the cloth actually is.

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
- **Cotton, Wool and Jute types** — those materials use the same type screen as
  Silk, with four empty boxes until a source names the varieties.
- **Tutorial videos and step illustrations** — Lighting → Tutorial exists.
  Catalog video and illustration paths are still mostly missing, so those
  screens fail safe with placeholders.
- **What the camera cannot see** — fabric type, sheen, transparency,
  embroidery quality and correct folding need a model that is not on the
  device. Each preset lists these in `undetectableConditions` rather than
  guessing at them.
- **Localisation polish** — Settings switches the UI between Assamese, Hindi
  and English (`lib/l10n/`, `LocaleController`). Catalog transcript lines and
  a few long setup sentences are still English; a native speaker should
  review the translations.
