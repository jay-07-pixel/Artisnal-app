# The Artisanal Lens — Full Audit Report

**Date:** 25 August 2026  
**Type:** Source-of-truth verification only. No code was changed for this audit.  
**App:** `artisanal_lens` (`com.artisanallens.artisanal_lens`)  
**Workspace:** `C:\Users\jayjo\Artisan-App`

---

## Sources used

| Source | File | Role |
|---|---|---|
| The Artisanal Lens specification | `docs/Artisanal-Lens-Solution-Deck.pdf` (13 pages) | Category-first flow, fold/style lists, live capture, vernacular, offline |
| BTP Product Photography Guide / research report | `docs/BTP-Report-Product-Photography-Guide.pdf` (47 pages) | Guidelines G1–G8, fabric properties, five Saree templates, lighting/video/alignment sequence, live camera prompts, Assamese testing |
| UI reference screenshots | Not present as standalone files in the repo | Visual comparison cannot be verified from files. Screen descriptions exist as images inside the BTP PDF (Images 16–27) and low-fidelity wireframes on deck pages 11–13 |
| Figma file *Artisans lens* | Cited in README as `rrmw1aZ2InrsBFfy3QwL5L` | Not in the workspace. The 7-shot checklist in code cites this file |
| Current implementation | `artisanal_lens/lib/` | What the app actually does |

**Rule used:** documents + UI references = required behaviour. Code = current implementation. Requirements not stated in the sources are marked **not specified**, not invented.

**Status words used in this report**

| Status | Meaning |
|---|---|
| COMPLETE | Implemented as the cited source states |
| PARTIALLY COMPLETE | Structure or data exists; assets, wiring, or coverage are incomplete |
| NOT IMPLEMENTED | Source requires it; code does not have it |
| DIFFERENT FROM SOURCE | Implemented, but not as that source states |
| NOT SPECIFIED / CANNOT VERIFY | Source does not define it, files are missing, or it was not observed at runtime |

---

## 1. Overall completion

**Overall: 58%**

This is a weighted score of source-required capabilities, not a count of screens.

| Area | Weight (how central it is in the documents) | Completeness | Notes |
|---|---|---|---|
| Category-first catalog + 16 fold names | 12% | 95% | Names match the deck. Roll display thumbnail is missing. |
| Photography templates (BTP section 7.3) + fabric properties (section 7.2) | 14% | 70% | Five Saree templates exist as data. Hero and Styled shots use folds, not templates. Non-Saree grids are not specified in BTP section 7.3. |
| Main instruction + checklist flow | 18% | 75% | Lighting, Tutorial, Alignment, Camera exist. Videos and step art are missing. The deck’s separate shot-type step is gone. BTP material/type/gamcha path is absent. |
| Live camera (ghost frame, grid, light, angle, prompts) | 16% | 80% | Code and unit tests cover analysis. No device was attached during this audit session. |
| Review / save to gallery / retake-before-accept | 10% | 85% | Retake of an already accepted photo has no user interface. |
| Tutorial videos (BTP section 8.2) | 10% | 8% | Screen exists. All `.mp4` files are missing. No video player even if a file were present. |
| Vernacular UI (deck pages 8–10; BTP sections 7.5 and 8.1) | 10% | 10% | Language picker only. Strings are English. |
| Voice guidance (deck page 10; BTP section 8.1 medium priority) | 5% | 0% | No text-to-speech. |
| Offline + “sync when connected” (deck page 10) | 5% | 50% | Local SQLite and camera work. Sync is a banner only. |

Calculation:

`0.12×0.95 + 0.14×0.70 + 0.18×0.75 + 0.16×0.80 + 0.10×0.85 + 0.10×0.08 + 0.10×0.10 + 0.05×0.00 + 0.05×0.50 = 0.58`

A 7-photo set can be completed in English with placeholders. After user testing, the documents treat local-language video tutorials as the main instruction medium. Those videos are not present.

---

## 2. Executive summary

### Fully complete

- Four category names and sixteen fold/style names (deck page 5)
- Category isolation (one category does not list another category’s presets)
- Shot types Process, Product, Detail, Lifestyle (deck page 6)
- G1–G8 guideline copy on Settings (BTP section 6.3)
- Fabric-property technique list in `FabricProperty` (BTP section 7.2)
- Five Saree photography templates as data (BTP section 7.3)
- Lighting, Tutorial, and Alignment screens in the router (BTP section 8.2)
- Live prompt strings for Move closer, Move further, Center, Backlight, Ready (BTP section 8.2)
- 12:00–15:00 harsh-sun advisory (BTP section 8.2)
- Save into the app and into the device gallery (BTP page 36)
- Offline-local catalog and SQLite
- Automated tests: 77 passed, 0 failed (see section 10)

### Partially complete

- Main flow (deck, BTP, and Figma disagree; the app is a hybrid)
- Template-to-camera wiring (Weave and Border yes; Hero uses the chosen fold)
- Content and Needs (Saree Detail and Process labeled; Hero and Styled only after a fold is chosen)
- Camera overlays (five grid types coded; not observed on a device this session)
- Tutorial and transcript (structure yes; videos no)
- Alignment (structure yes; illustration assets no)
- Checklist of 7 (Figma; BTP does not give that count)
- Localization plumbing without translations
- Home recents without All / Finished / Pending (BTP pages 32–33)

### Missing

- Tutorial `.mp4` files and step illustrations
- `saree_roll_display.png`
- Assamese and Hindi app strings
- Voice / voiceover
- BTP product path: material (silk/cotton/wool/jute) then type (eri/muga) then category including gamcha
- Photo sync when online
- Indoor/outdoor overlay toggle, pulse/blink alignment, demo-mode process video (BTP section 8.1)
- User interface to retake an already accepted photo
- Weather/haze detection (`hazyOrCloudy` exists in code, never used)

### Different from source

- Deck sample Saree flow: Pallu drape loads rule of thirds. Code loads leading lines (BTP Preset 3).
- Deck flow: Category then Shot type then Fold then Camera. App: Photo List (named slots), then fold only for Product and Lifestyle.
- Completion banner: “Offline — photos will sync when connected” with no sync implementation.
- BTP section 7.3 templates are Saree photography templates; the app also uses them for every category’s Border and Weave slots.

### Cannot verify

- Pixel match to supplied UI screenshots (no screenshot files in the repo)
- Figma file *Artisans lens* (not in the workspace)
- Live camera and overlay contrast in sunlight (no device this session)
- Gallery write on a physical phone this session

---

## 3. Requirement-by-requirement matrix

| Requirement | Source | Current implementation | Status | Evidence |
|---|---|---|---|---|
| Category-first: pick product type first | Deck pages 2–4 | Setup grid: Saree, Cushion Cover, Shawl, Stole | COMPLETE | `product_setup_page.dart`; `preset_catalog.dart` `categories()` |
| Categories: Saree, Cushion cover, Shawl, Stole | Deck page 4 | Same four; UI label Cushion Cover | COMPLETE | Deck wraps “Cushion cover”; catalog `name: 'Cushion Cover'` |
| Then material then type then category (silk/cotton/wool/jute; eri/muga; saree or gamcha) | BTP section 7.5 Image 17, page 33 | Only the four deck categories; no material/type; no gamcha | NOT IMPLEMENTED | `product_setup_page.dart` category grid only |
| Product name + recents with date/thumbnail | BTP pages 32–33 | Name field; recents on Home | PARTIALLY COMPLETE | Home has recents. No All / Finished / Pending filters. Gallery filters by category, not status. |
| New product from Home | BTP page 32; Deck | New Product goes to setup | COMPLETE | `home_page.dart` `_NewProductCard` |
| Fold presets: 4 per category, exact names | Deck page 5 | Exact 16 names and IDs | COMPLETE | `preset_catalog.dart`; `test/preset_audit_test.dart` |
| Each fold auto-pairs angle, lighting, composition | Deck pages 5–6 | Each `FoldPreset` has `TechniquePreset` | PARTIALLY COMPLETE | Pairing exists. Deck page 9 says Pallu uses rule of thirds; code Pallu uses `leadingLines` |
| Technique options: 4 angles, 4 lightings, 4 compositions, 4 shot types | Deck page 6 | Enums match those lists | COMPLETE | `technique_preset.dart`; `shot_type.dart` |
| G1–G8 photography guidelines | BTP section 6.3 pages 24–26 | `PhotographyGuideline` plus Settings list | COMPLETE | `photography_guideline.dart`; `settings_page.dart` |
| Fabric-property capture methods (Colour through Embroidery) | BTP section 7.2 pages 27–29 | `FabricProperty.techniques` | PARTIALLY COMPLETE | Data present. UI shows property names as Content, not the full bullet list |
| Five Saree templates: Full Display, Texture and Weave, Draped Look, Embroidery and Border, Folded Stack | BTP section 7.3 pages 29–32 | `SareePhotographyTemplates` | PARTIALLY COMPLETE | Data complete. Not offered as a template picker. Mapped onto slots and folds (see sections 5–6) |
| Templates are a non-exhaustive list | BTP section 7.3 page 28 | App also has Motif, Loom, Dyeing, 7-slot Figma checklist | NOT SPECIFIED | Extra slots come from Figma citations in code, not from BTP section 7.3 |
| Illustrated setup sequence after template | BTP section 7.5 page 34 | `setupSteps` plus Lighting page | PARTIALLY COMPLETE | Structure yes. All `assets/images/steps/*.png` missing |
| Live camera with gridlines | BTP page 34; Deck page 7 | `CapturePage` plus `GuideOverlay` | PARTIALLY COMPLETE | Code yes. Runtime not observed this session |
| Ghost frame, light check, angle indicator, grid | Deck page 7 | Overlay plus Light and Angle chips | PARTIALLY COMPLETE | `guide_overlay.dart`; `capture_page.dart` `_FeedbackChips`. Sunlight contrast not verified |
| Photo saved in app and phone gallery | BTP page 36 | `persist` plus `Gal.putImage` album “The Artisanal Lens” | PARTIALLY COMPLETE | Code: `photo_storage_io.dart`. Device write not verified this session |
| To-do list of required photo types | BTP page 36; Deck page 8 | `PhotoListPage` 7 slots | PARTIALLY COMPLETE | Count of 7 is Figma (`shot_type.dart`), not BTP. BTP does not state 7 |
| Lighting and Setup screen (sun, shadows, weather) | BTP section 8.2 pages 41–42 | `LightingSetupPage` plus `LightingAdvisory.forTime` | PARTIALLY COMPLETE | 12–3pm and night handled. Hazy/cloudy not detected. Illustration missing |
| Video tutorial, on-screen transcript, fullscreen | BTP section 8.2 pages 40, 42 | `TutorialPage` | PARTIALLY COMPLETE | Transcript and placeholder exist. Fullscreen is a stub. No video player. Zero mp4 files |
| Alignment illustration then camera | BTP section 8.2 page 42 | `AlignmentPage` then capture | PARTIALLY COMPLETE | Phone mock plus `GuideOverlay`. Reference art often missing |
| Live prompts: Move closer; Move further from subject; Center your subject; Backlight detected; Ready | BTP section 8.2 page 43 | Exact strings in `CapturePrompt` | COMPLETE | `capture_feedback.dart`. Extra prompts: Too dark, Too bright, Tilt phone (deck angle chip plus BTP section 8.1 light detection) |
| Light-quality detection, e.g. too dark then window/outside | BTP section 8.1 page 39 | `tooDark` message matches | COMPLETE | `capture_feedback.dart`; `capture_guidance_service.dart` |
| High-contrast overlays for outdoor use | BTP section 8.1 pages 39–40 | `AppColors.guideStroke` | CANNOT VERIFY | Not verified in sunlight |
| Indoor/outdoor overlay brightness toggle | BTP section 8.1 high priority | Not in code | NOT IMPLEMENTED | No toggle |
| Pulse/blink alignment zone | BTP section 8.1 high priority | Not in code | NOT IMPLEMENTED | Static dashed frame |
| Demo mode: one video of the whole process | BTP section 8.1 high priority | Opening animation, not a process demo | NOT IMPLEMENTED | `opening_sequence_page.dart` |
| Voiceover in Assamese | Deck page 10; BTP section 8.1 medium priority | None | NOT IMPLEMENTED | No TTS package or code |
| App in local language; test UI was Assamese | BTP section 7.5 page 32; section 8.1 page 36; Deck pages 8, 10 | Locale picker; English literals | NOT IMPLEMENTED | `locale_controller.dart`; no ARB files |
| One decision per screen | Deck page 10 | Mostly one decision; setup combines category and name | PARTIALLY COMPLETE | `product_setup_page.dart` |
| Works offline; photos sync when connected | Deck page 10 | Local database and camera. Banner claims sync | DIFFERENT FROM SOURCE | `completion_page.dart` “photos will sync”; no sync code |
| Review versus reference; retake or accept | Deck pages 8–9 | Review, Retake, Use Photo | PARTIALLY COMPLETE | Reference panel only if a fold preset exists. Detail shots have no reference panel |
| Guided capture chips Light: Good / Angle: OK | Deck page 7 | Chips implemented | COMPLETE | `capture_page.dart` |
| Sample flow: Saree then Product shot then Pallu drape then eye-level, soft light, rule of thirds | Deck page 9 | Pallu: eye-level, soft window, leading lines | DIFFERENT FROM SOURCE | `preset_catalog.dart` `saree_pallu_drape` versus deck page 9 |
| Expand later (dupattas, bedsheets) | Deck page 4 | Not implemented (explicitly “later”) | NOT SPECIFIED | Not a current requirement |
| VR / 3D mockups | BTP section 7.1 rejected | Not built | COMPLETE | Correctly omitted |
| Backend / Supabase | Not in these two PDFs | None | NOT SPECIFIED | Not specified in source |
| Exactly 7 photos / Hero, Border, Weave, Motif, Loom, Dyeing, Styled | Code cites Figma; not in these PDFs | Implemented | NOT SPECIFIED | BTP does not name those seven slots |
| Figma visual tokens | README / code comments | Terracotta plus Playfair Display and Inter | CANNOT VERIFY | Screenshot files not in repo |

---

## 4. UI flow audit

### Documented (three sources, not one sequence)

**A. Solution deck pages 3 and 9**

Select Category → Choose Shot Type (Process / Product / Detail / Lifestyle) → Pick Fold / Styling Preset → Guided Capture → Review and Retake → Save to Gallery → Checklist marks that type done, next type prompted.

**B. BTP sections 7.4–7.5**

Product details: material then type then category → photography templates → illustrated guides → camera with grid → save to app and gallery → to-do list.

**C. BTP section 8.2 revised instruction**

Lighting and Setup → Video Tutorial with Transcript → Alignment Illustration → Camera (live prompts).

**D. Figma (cited in code, file not in repo)**

Seven named slots. Photo List as hub.

### Current flow (code)

```
OpeningSequencePage (4.2 seconds)
→ Home (New / Continue / Recents)
→ ProductSetupPage (category and name together)
→ PhotoListPage (7 named slots)
   → if Product or Lifestyle: ShotAndStylePage (fold only)
   → LightingSetupPage
   → TutorialPage
   → AlignmentPage
   → CapturePage
   → ReviewPage
        Retake → Capture
        Use Photo → persist + gallery + PhotoListPage
→ when 7 of 7: CompletionPage
```

Process and Detail skip `ShotAndStylePage`.

### Differences

| Documented | Current |
|---|---|
| Deck: explicit shot type screen | Shot is a row on Photo List (Hero, Border, and so on). `pickerDescription` is unused |
| Deck: fold after shot type for the flow shown | Fold only for Product and Lifestyle |
| BTP: material and fabric type first | Not implemented |
| BTP: gamcha as a category example | Not implemented |
| BTP: pick a photography template | User picks a checklist slot and maybe a fold |
| BTP section 8.2 video as the real tutorial | Placeholder; no playback |
| Deck: after save, prompt next shot type | Returns to Photo List; next slot highlighted |
| BTP Home: filter All / Finished / Pending | Home has Recents; Gallery filters by category |
| One decision per screen | Category and name share setup |

---

## 5. Category and preset audit

| Category | Documented (deck page 5) | Implemented | Status |
|---|---|---|---|
| Saree | Pallu drape (hanger); Box / flat fold; Worn drape (model); Roll display | IDs `saree_pallu_drape`, `saree_box_fold`, `saree_worn_drape`, `saree_roll_display` | COMPLETE for names. PARTIALLY COMPLETE because Roll PNG is missing |
| Cushion Cover | Flat lay; Stacked pair; Propped on seating; Corner tuck close-up | Matching four IDs | COMPLETE |
| Shawl | Draped on shoulder; Folded stack; Hung / pinned flat; Corner tuck close-up | Matching four IDs | COMPLETE |
| Stole | Neck wrap (worn); Flat spread; Loose knot; Rolled coil | Matching four IDs | COMPLETE |

No duplicate names. `saree_hanger` is not in the catalog. `saree_hanger.png` is an unused leftover on disk.

`CatalogRepositoryImpl.presets(categoryId:, shotType:)` filters by category then `supportedShotTypes`. Isolation is covered by tests.

**Category-specific camera:** Product and Lifestyle use that category’s fold technique. Detail Border and Weave use Saree templates for all categories. That mapping is not stated in the PDFs.

---

## 6. Photography technique audit

The templates below are BTP section 7.3 only. They are not fold styles.

### Full Saree Display (Color, Pattern, Material) — BTP page 29

| Field | Source | Code (`SareePhotographyTemplates.fullDisplay`) | Status |
|---|---|---|---|
| Content | Color, Pattern, Material | Colour, Pattern, Material | COMPLETE |
| Needs | Not named as Needs. Colour section 7.2: daylight, background | Natural daylight; neutral or contrasting background | PARTIALLY COMPLETE — derived from section 7.2 Colour, not from Preset 1 bullets |
| Grid | Rule of Thirds 3×3 | `ruleOfThirds` | COMPLETE |
| Placement | Spread flat or draped over a surface | Same string | COMPLETE |
| Lighting | Not named on the template | `diffusedDaylight` | NOT SPECIFIED on Preset 1 |
| Angle | Not named | `eyeLevel` | NOT SPECIFIED |
| Camera behaviour | Not a selectable template in the UI | Not loaded as Hero by default. Worn and Roll share colour/pattern/material and rule of thirds; they are not this template | DIFFERENT FROM SOURCE |

### Close-up of Texture and Weave — BTP page 29

| Field | Source | Code | Status |
|---|---|---|---|
| Content | Texture, Thickness, Material, Transparency | Same | COMPLETE |
| Needs | Preferably in natural light | Natural light | COMPLETE |
| Grid | Center Focus | `centerFocus` | COMPLETE |
| Placement | Well-lit section, natural light | Same | COMPLETE |
| Lighting | Soft light, avoid harsh reflections | `softWindowLight` | COMPLETE |
| Angle | Not named; close-up implied | `macroCloseUp` | PARTIALLY COMPLETE — careful use of close-up, not named |
| Camera | Weave slot (Detail index 1) | `ShotGuidance.forSlot(detail, 1)` | PARTIALLY COMPLETE — applied to every category’s Weave, not Saree-only |

### Draped Look (Flimsiness, Sheen, Flow, weight) — BTP page 30

| Field | Source | Code | Status |
|---|---|---|---|
| Content | Flimsiness, Sheen, Flow, Weight | Same | COMPLETE |
| Needs | Hanger, bamboo, or mannequin; side light | Hanger, bamboo or mannequin; side lighting | COMPLETE |
| Grid | Leading Lines (diagonals) | `leadingLines` | COMPLETE |
| Placement | Hanger, bamboo, or mannequin | Same | COMPLETE |
| Lighting | Side light for sheen | `softWindowLight` | COMPLETE |
| Angle | Not named | `eyeLevel` | NOT SPECIFIED |
| Camera | Not a template picker. Pallu fold shares this grid | Pallu is not named Draped Look | DIFFERENT FROM SOURCE (share versus identity) |

### Embroidery and Border Details — BTP page 30

| Field | Source | Code | Status |
|---|---|---|---|
| Content | Embroidery, Quality | Same | COMPLETE |
| Needs | Side lighting; contrast background | Side lighting; contrasting background | COMPLETE |
| Grid | Detail Frame plus leading lines | `detailFrame` (painter draws diagonals and a small rectangle) | COMPLETE |
| Placement | Close-up border or embroidery | Same | COMPLETE |
| Lighting | Side lighting, sharp, well-lit | `softWindowLight` | COMPLETE |
| Angle | Close-up | `macroCloseUp` | COMPLETE |
| Camera | Border slot (Detail index 0) | Yes | PARTIALLY COMPLETE — all categories |

### Folded Stack (Thickness and Material) — BTP page 32

| Field | Source | Code | Status |
|---|---|---|---|
| Content | Thickness and Material; purpose also material weight | Thickness, Material weight | COMPLETE |
| Needs | Side lighting (guideline) | Side lighting | COMPLETE |
| Grid | Horizontal and diagonal | `horizontalFolds` | COMPLETE |
| Placement | Neat stack, visible folds | Same | COMPLETE |
| Lighting | Side lighting for depth | `softWindowLight` | COMPLETE |
| Angle | Not named | `eyeLevel` | NOT SPECIFIED |
| Camera | Box / flat fold shares grid | Not named Folded Stack in the fold list | DIFFERENT FROM SOURCE (share versus identity) |

**Code mapping (explicit in code; not stated in the PDFs as identity):**

- Weave → Texture and Weave template
- Border → Embroidery and Border template
- Pallu drape → same grid/lighting family as Draped Look
- Box / flat fold → same grid family as Folded Stack
- Worn drape / Roll display → Full Display content and rule of thirds, not claimed as the template in tests

BTP does not say those folds are those templates.

---

## 7. Camera audit

| Documented behaviour | Implementation | Status |
|---|---|---|
| Ghost frame | Dashed rectangle in `GuideOverlay` | PARTIALLY COMPLETE — code yes; runtime not observed |
| Grid overlay types from section 7.3 | Five `GridOverlayType` values painted in `_GuidePainter` | PARTIALLY COMPLETE |
| Light: Good chip | `LightQuality` plus chip | PARTIALLY COMPLETE |
| Angle: OK chip | Pitch versus `CameraAngle.targetPitchDegrees` | PARTIALLY COMPLETE |
| Move closer / further / center / backlight / Ready | `CaptureGuidanceService` plus tests | COMPLETE in unit tests; device not observed |
| Too dark → window/outside | Implemented | COMPLETE versus section 8.1 |
| Too bright / tilt phone | Implemented | NOT SPECIFIED on the section 8.2 prompt list; tilt matches the deck angle indicator |
| Alignment versus gridlines | Uses texture fill and centre of mass, not line-to-line geometry | DIFFERENT FROM SOURCE versus the sentence “detects whether the fabric is properly aligned with the on-screen gridlines” |
| Shutter never blocked | Comment plus UI: shutter enabled when camera ready | COMPLETE versus testing (artisans must be able to override) |
| Flash / front-back | `toggleFlash`, `switchCamera` | NOT SPECIFIED in the PDFs |
| High-contrast outdoor overlays | Stroke colors in theme | CANNOT VERIFY |
| Indoor/outdoor toggle | Absent | NOT IMPLEMENTED |
| Pulse alignment | Absent | NOT IMPLEMENTED |
| Web: no frame stream | Guidance hidden on web | NOT SPECIFIED IN SOURCE (platform) |

`CameraController` and `FrameAnalyzer` were inspected only, not changed.

---

## 8. Checklist, save, and retake audit

**Count:** 7 slots — Process 2 (Loom setup, Dyeing), Product 1 (Hero shot), Detail 3 (Border, Weave, Motif), Lifestyle 1 (Styled shot). Source in code: Figma. BTP does not specify 7 or these names. The deck tracks the four types, not seven named photos.

**Current behaviour (code inspection):**

- Photo List shows progress `completed/7`, a NEXT marker, and empty slots that are tappable.
- Filled slots: `onTap: null` — cannot retake from the list.
- Use Photo: persist file → gallery attempt → SQLite `UNIQUE(set_id, shot_type, slot_index)` with `ConflictAlgorithm.replace` (replace is possible in the database, not in the user interface).
- `removeShot` exists, no user interface.
- Resume: Home Continue only if `completedCount > 0`; empty created sets still appear in Recents and Gallery.
- No delete-product user interface.

**Retake:** Only before accept (Review back to camera). After accept: not in the user interface.

---

## 9. Asset audit

Referenced from `preset_catalog.dart`: **71** paths. On disk: **19**. Missing: **52**.

| Asset | Required by | Exists | Used | Status |
|---|---|---|---|---|
| Category PNGs (4) | Deck category screen | Yes | Yes | COMPLETE |
| Fold PNGs except roll | Deck presets / review | Yes | Yes | COMPLETE |
| `saree_roll_display.png` | Roll display fold | No | Referenced | Missing source asset; placeholder at runtime |
| `saree_hanger.png` | Old hanger fold | Yes | No | Unused leftover |
| All `assets/images/steps/*.png` (36) | BTP sections 7.5 and 8.2 illustrations | No | Referenced | Missing source asset; placeholder |
| All `assets/videos/*.mp4` (15 in catalog; roll has no video path) | BTP section 8.2 one-minute videos | No | Referenced | Missing source asset; placeholder; no player |
| Template-1 tutorial video (BTP Image 24) | BTP section 8.2 | No | — | Missing source asset |
| Fonts Inter, Playfair Display | Figma (code/README) | Yes | Yes | COMPLETE |
| Standalone UI screenshots | Audit / visual QA | No files in repo | — | Cannot verify; images exist only inside the PDFs |

Tutorial: if an mp4 were added, `TutorialPage` still does not play it (`_TutorialSlot`: player not wired).

---

## 10. Test audit

Command run during this audit:

```
cd artisanal_lens
flutter test
```

**Result:** 77 tests, 77 passed, 0 failed, 0 skipped, 0 errors.

### What the suite actually covers

| File | Tests | What it proves |
|---|---|---|
| `test/capture_guidance_service_test.dart` | 17 | Live prompt priority (Ready, darkness first, overexposure, backlight on/off for sheer fabrics, move closer, move further, centre). Angle guidance for eye-level versus overhead. Accelerometer pitch at 0° and 90°. `FrameAnalyzer` luminance, backlight, row-stride padding, empty plane. |
| `test/catalog_coverage_test.dart` | 26 | Every category can reach the camera for Process, Product, Detail, and Lifestyle. Product and Lifestyle have at least one fold style in every category. Style-skipping types carry a fallback technique. Preset image paths start with `assets/images/presets/` (prefix only; does not prove the file exists on disk). |
| `test/preset_audit_test.dart` | 17 | The 16 Step 2 fold names are unchanged. Photography templates are not extra folds. Full Saree Display uses rule of thirds. Texture and Weave uses centre focus. Draped Look uses leading lines. Embroidery and Border uses detail frame plus leading lines. Folded Stack uses horizontal plus diagonal. Weave does not use the generic Detail technique. Border does not use the generic Detail technique. Weave and Border differ. Motif is Pattern close-up, not a Saree template. Loom and Dyeing keep the process grid. Pallu and Box share template grid data without being those templates. Worn drape and Roll display are not Full Saree Display. Hero and Styled inherit the chosen fold technique. |
| `test/shot_set_test.dart` | 17 | Complete set is 7 photographs. Slot captions: Loom setup, Dyeing, Border, Weave, Motif. Progress, finished state, next-slot order (Product first, then Detail), `nextSlotFor`, cover shot, gallery All versus category filter. |

**Not covered by automated tests**

- Widget or navigation tests (Home through Use Photo)
- Camera integration on emulator or device
- SQLite on device
- Gallery permission and write
- Missing assets at runtime
- Localization
- Tutorial video playback

**Known gap in an existing test:** `catalog_coverage_test` “every preset image is referenced from a real asset path” only checks the path prefix. `saree_roll_display.png` can be missing on disk and that test still passes.

---

## 11. Android audit

| Check | Result |
|---|---|
| Device during this audit session | `adb devices` showed none |
| Build/launch during this audit session | Not run (no device) |
| Automated UI tests in the project | None |
| Unit tests | Automated verified: 77 passed |
| Full New Project → Pallu drape → Camera → Use Photo | Not verifiable this session |

- **Automated verified:** unit tests listed in section 10.
- **Manually verified:** nothing this session.
- **Code inspection only:** flow, catalog, camera wiring, persistence, assets.
- **Unable to verify:** live camera, gallery write, overlay outdoors, screenshot pixel match.

---

## 12. Files currently implementing each major feature

**UI flow:** `lib/app/router.dart` (`AppRoute`, `createRouter`); `lib/features/instruction/instruction_flow.dart` (`beginCaptureForSlot`, `returnToPhotoList`)

**Home / setup / list:** `lib/features/home/presentation/home_page.dart`; `lib/features/checklist/presentation/product_setup_page.dart`; `lib/features/checklist/presentation/photo_list_page.dart`

**Style:** `lib/features/shot_type/presentation/shot_and_style_page.dart`

**Instruction:** `lib/features/instruction/presentation/lighting_setup_page.dart`; `lib/features/instruction/presentation/tutorial_page.dart`; `lib/features/instruction/presentation/alignment_page.dart`; `lib/domain/entities/lighting_advisory.dart`

**Preset catalog:** `lib/data/datasources/preset_catalog.dart` (`BundledCatalogDataSource`); `lib/domain/entities/fold_preset.dart`; `lib/data/repositories/catalog_repository_impl.dart`

**Photography templates / Content and Needs:** `lib/domain/entities/photography_template.dart`; `lib/domain/entities/shot_guidance.dart`; `lib/domain/entities/fabric_property.dart`; `lib/features/capture/capture_session_controller.dart` (`sessionGuidanceProvider`, `sessionTechniqueProvider`)

**Camera:** `lib/features/capture/presentation/capture_page.dart`; `lib/features/capture/camera_controller.dart` (`GuidedCameraController`); `lib/features/capture/presentation/widgets/guide_overlay.dart`; `lib/domain/services/frame_analyzer.dart`; `lib/domain/services/capture_guidance_service.dart`; `lib/domain/entities/capture_feedback.dart`

**Review / save:** `lib/features/review/presentation/review_page.dart`; `lib/data/datasources/photo_storage_io.dart`; `lib/features/review/photo_saver.dart`

**Checklist / persistence:** `lib/domain/entities/shot_set.dart`; `lib/features/home/shot_sets_controller.dart`; `lib/data/datasources/app_database.dart`; `lib/data/repositories/shot_set_repository_impl.dart`

**Gallery / share:** `lib/features/gallery/presentation/gallery_page.dart`; `lib/features/gallery/presentation/product_viewer_page.dart`

**Locale:** `lib/app/locale_controller.dart`; `lib/features/settings/presentation/settings_page.dart`; `lib/main.dart`

**Completion:** `lib/features/completion/presentation/completion_page.dart`

---

## 13. Critical gaps

Ranked only where the PDFs or the Figma-cited checklist require it.

### P0 — blocks the documented core after user testing

- BTP section 8.2: real one-minute local-language tutorial videos are the instruction medium. Screens are placeholders. No video files. No player. Static diagrams already failed in testing (section 8.1).
- BTP sections 7.5 and 8.1 and deck pages 8–10: UI in the artisan’s language. Picker exists. No Assamese or Hindi strings.

### P1 — important, source-supported

- All setup illustration PNGs missing (BTP sections 7.5 and 8.2 Screen 3).
- `saree_roll_display.png` missing (deck Roll display).
- BTP section 7.5 Home All / Finished / Pending.
- BTP section 7.5 material then type then category (silk/cotton, eri/muga, gamcha) versus deck’s four categories — both are in source; app implements only the deck.
- Deck page 3 shot-type step versus Photo List slots (Figma).
- Deck page 9 Pallu rule of thirds versus BTP Preset 3 / code leading lines.
- Saree templates applied to non-Saree Border and Weave (not in BTP).
- No UI to retake an accepted photo (deck Review and Retake is about the review step; BTP to-do list does not say replace).
- Fake sync copy (deck page 10).
- Hazy/cloudy advisory not actually evaluated (BTP section 8.2).
- Section 8.1 high: indoor/outdoor overlay toggle; pulse alignment; first-user demo video.

### P2 — polish / lower priority in source

- Voiceover / tap-to-play audio (BTP section 8.1 medium/low).
- Peer-learning cue (BTP section 8.1 medium).
- Good versus bad lighting samples in onboarding (BTP section 8.1 medium).
- Orphan `saree_hanger.png`.
- Opening sequence not described in the two PDFs (Figma-only if at all).

---

## 14. Next steps

Only items the documents support, in dependency order. Not implemented in this audit.

1. Resolve source conflicts in writing before more code: deck four categories versus BTP material/type/gamcha; deck shot-type page versus Figma 7-slot Photo List; deck Pallu = rule of thirds versus BTP Draped Look = leading lines; whether Saree section 7.3 templates apply to Shawl, Stole, and Cushion Detail slots.
2. Supply source assets: one-minute videos per template (BTP section 8.2), setup/alignment illustrations, Roll display photo.
3. Play those videos on Tutorial (fullscreen plus transcript) once files exist.
4. Assamese (then Hindi) strings for screens and catalog (BTP section 8.1, deck vernacular). Native speaker, as the README already notes.
5. Lighting and Setup illustrations plus weather copy that matches section 8.2 (including cloudy/hazy if detection is possible; time-of-day already exists).
6. Home status filters All / Finished / Pending (BTP pages 32–33), if that screen is still required.
7. If deck page 3 wins: restore a one-decision shot type screen before fold.
8. If BTP section 7.5 wins: add material/type filters before category.
9. Overlay outdoor contrast / indoor-outdoor toggle / pulse (BTP section 8.1) without replacing `FrameAnalyzer` unless camera work is explicitly reopened.
10. Voiceover in Assamese (deck plus BTP medium) after strings exist.
11. Real offline queue, or remove “will sync when connected” so it matches deck page 10.
12. Do not invent a 5-versus-7 checklist change unless Figma versus BTP is decided. Both appear in the project materials. BTP calls the five Saree items a non-exhaustive template list, not a slot count.

---

## Closing

The documents require a split product: the deck (category, folds, live capture, vernacular, offline), the BTP report (guidelines, five Saree templates, lighting/video/alignment, live prompts, Assamese, gallery save), and Figma (seven named shots — file not in repo).

The code is a working English, category-first, 7-slot capture app with instruction screens, live analysis code, and a complete fold-name catalog.

The running app was not observed during this audit. No device was attached. Unit tests passed: 77 of 77.
