/// The eight product-photography guidelines derived from the research phase.
///
/// Source: BTP Report §6.3 "Guidelines for Product Photography". These are
/// referenced throughout the app as G1–G8 and are the rationale behind every
/// technique preset; see [FabricProperty] for the property→guideline mapping.
enum PhotographyGuideline {
  /// G1 — Capture fine details, textures and craftsmanship of the fabric.
  closeUpShots(
    code: 'G1',
    title: 'Use Close-Up Shots',
    description:
        'Capture fine details, textures, and craftsmanship of the fabric.',
  ),

  /// G2 — Capture the edge of the fabric, covering 2/3 of the image with fabric.
  highlightFabricEdges(
    code: 'G2',
    title: 'Highlight Fabric Edges',
    description:
        'Capture the edge of the fabric, covering 2/3 of the image with fabric.',
  ),

  /// G3 — Showcase the product from multiple perspectives.
  variousAngles(
    code: 'G3',
    title: 'Shoot from Various Angles',
    description:
        'Showcase the product from multiple perspectives to highlight its '
        'design and structure.',
  ),

  /// G4 — Natural and artificial, indoor and outdoor, front and side lighting.
  diverseLighting(
    code: 'G4',
    title: 'Experiment with Diverse Lighting',
    description:
        'Utilise natural and artificial lighting, indoor and outdoor lighting, '
        'front and side lighting, to bring out the true colours and depth of '
        'the fabric.',
  ),

  /// G5 — Backgrounds that enhance the fabric without overpowering it.
  complementaryBackgrounds(
    code: 'G5',
    title: 'Choose Complementary Backgrounds',
    description:
        "Use backgrounds that enhance the fabric's beauty without "
        'overpowering it.',
  ),

  /// G6 — Photograph the fabric in its raw, unironed state.
  naturalCreases(
    code: 'G6',
    title: 'Embrace Natural Creases',
    description:
        'Photograph the fabric in its raw, unironed state to give a clear idea '
        'of material.',
  ),

  /// G7 — Capture how the fabric drapes, folds and flows.
  weightAndFlow(
    code: 'G7',
    title: 'Represent Weight and Flow',
    description:
        'Capture how the fabric drapes, folds, and flows to convey its weight '
        'and feel.',
  ),

  /// G8 — Connect the fabric to its heritage, artisans and intended use.
  tellAStory(
    code: 'G8',
    title: 'Tell a Story',
    description:
        'Frame shots in a way that connects the fabric to its cultural '
        'heritage, artisans, and intended use.',
  );

  const PhotographyGuideline({
    required this.code,
    required this.title,
    required this.description,
  });

  /// Short reference code shown in the UI, e.g. `G1`.
  final String code;
  final String title;
  final String description;

  static PhotographyGuideline? fromCode(String code) {
    final normalised = code.trim().toUpperCase();
    for (final guideline in PhotographyGuideline.values) {
      if (guideline.code == normalised) return guideline;
    }
    return null;
  }
}
