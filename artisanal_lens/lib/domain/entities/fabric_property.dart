import 'photography_guideline.dart';

/// A single actionable technique for capturing a fabric property, together with
/// the guidelines ([PhotographyGuideline]) that justify it.
class CaptureTechnique {
  const CaptureTechnique({
    required this.instruction,
    required this.guidelines,
  });

  final String instruction;
  final List<PhotographyGuideline> guidelines;
}

/// The fabric properties buyers use to judge a handloom product online.
///
/// Source: BTP Report §7.2 "How to use developed photography guidelines?".
/// [isHardToPerceive] encodes the research finding (§5.2) that colour,
/// material, quality and flimsiness are difficult to judge from photographs,
/// while texture, thickness and transparency are comparatively easy — the app
/// prioritises guidance for the difficult ones.
enum FabricProperty {
  colour(label: 'Colour', isHardToPerceive: true),
  material(label: 'Material', isHardToPerceive: true),
  quality(label: 'Quality', isHardToPerceive: true),
  flimsiness(label: 'Flimsiness', isHardToPerceive: true),
  texture(label: 'Texture', isHardToPerceive: false),
  thickness(label: 'Thickness', isHardToPerceive: false),
  transparency(label: 'Transparency', isHardToPerceive: false),
  pattern(label: 'Pattern', isHardToPerceive: false),
  sheen(label: 'Sheen / Gloss', isHardToPerceive: false),
  embroidery(label: 'Embroidery', isHardToPerceive: false);

  const FabricProperty({required this.label, required this.isHardToPerceive});

  final String label;

  /// True for properties users consistently misjudged from photographs alone.
  final bool isHardToPerceive;

  /// The techniques that communicate this property, mapped to guidelines.
  List<CaptureTechnique> get techniques => switch (this) {
        FabricProperty.colour => const [
            CaptureTechnique(
              instruction:
                  'Use natural daylight or diffused artificial light to capture '
                  'the true colour.',
              guidelines: [PhotographyGuideline.diverseLighting],
            ),
            CaptureTechnique(
              instruction:
                  'Use a neutral or contrasting background to make the colour '
                  'pop.',
              guidelines: [PhotographyGuideline.complementaryBackgrounds],
            ),
            CaptureTechnique(
              instruction:
                  'Take multiple shots from different angles to see how the '
                  'colour appears under various lighting conditions.',
              guidelines: [PhotographyGuideline.variousAngles],
            ),
          ],
        FabricProperty.material => const [
            CaptureTechnique(
              instruction:
                  'Capture close-up shots to highlight fabric weave or fibre '
                  'structure.',
              guidelines: [PhotographyGuideline.closeUpShots],
            ),
            CaptureTechnique(
              instruction:
                  'Show different folds or drapes to emphasise material '
                  'behaviour.',
              guidelines: [PhotographyGuideline.weightAndFlow],
            ),
            CaptureTechnique(
              instruction: 'Show natural creases of the material.',
              guidelines: [PhotographyGuideline.naturalCreases],
            ),
            CaptureTechnique(
              instruction:
                  'Use side lighting to create soft shadows that define the '
                  'texture of the fabric.',
              guidelines: [PhotographyGuideline.diverseLighting],
            ),
            CaptureTechnique(
              instruction:
                  'Use props along with the fabric such as natural dyes, '
                  'material yarn etc.',
              guidelines: [PhotographyGuideline.tellAStory],
            ),
          ],
        FabricProperty.quality => const [
            CaptureTechnique(
              instruction:
                  'Take a macro shot of stitching, embroidery, or fabric weave '
                  'to showcase craftsmanship.',
              guidelines: [PhotographyGuideline.closeUpShots],
            ),
            CaptureTechnique(
              instruction: 'Show the edges of the fabric.',
              guidelines: [PhotographyGuideline.highlightFabricEdges],
            ),
            CaptureTechnique(
              instruction:
                  'Capture the product in flow (e.g. a saree being draped or a '
                  'curtain hanging naturally).',
              guidelines: [PhotographyGuideline.weightAndFlow],
            ),
            CaptureTechnique(
              instruction:
                  'Include the hand of the artisan touching the fabric to '
                  'suggest quality perception.',
              guidelines: [PhotographyGuideline.tellAStory],
            ),
          ],
        FabricProperty.flimsiness => const [
            CaptureTechnique(
              instruction:
                  'Hold the fabric up and let it fall naturally to show its '
                  'structure.',
              guidelines: [PhotographyGuideline.weightAndFlow],
            ),
            CaptureTechnique(
              instruction:
                  'Use side lighting to show how light passes through folds.',
              guidelines: [PhotographyGuideline.variousAngles],
            ),
          ],
        FabricProperty.texture => const [
            CaptureTechnique(
              instruction:
                  'Use extreme close-ups to show fine details of the fabric '
                  'surface.',
              guidelines: [PhotographyGuideline.closeUpShots],
            ),
            CaptureTechnique(
              instruction:
                  'Side lighting works best to emphasise shadows and depth.',
              guidelines: [PhotographyGuideline.variousAngles],
            ),
            CaptureTechnique(
              instruction:
                  'Have a hand gently scrunching the fabric to highlight its '
                  'texture.',
              guidelines: [PhotographyGuideline.tellAStory],
            ),
            CaptureTechnique(
              instruction:
                  'Use a contrasting smooth background to make the texture more '
                  'visible.',
              guidelines: [PhotographyGuideline.complementaryBackgrounds],
            ),
          ],
        FabricProperty.thickness => const [
            CaptureTechnique(
              instruction:
                  'Fold multiple layers together and capture the thickness from '
                  'the side.',
              guidelines: [PhotographyGuideline.weightAndFlow],
            ),
            CaptureTechnique(
              instruction:
                  'Shoot from an edge perspective to highlight stacked fabric '
                  'depth.',
              guidelines: [PhotographyGuideline.highlightFabricEdges],
            ),
            CaptureTechnique(
              instruction:
                  'Place an object behind the fabric to demonstrate visibility '
                  'through it.',
              guidelines: [
                PhotographyGuideline.complementaryBackgrounds,
                PhotographyGuideline.weightAndFlow,
              ],
            ),
          ],
        FabricProperty.transparency => const [
            CaptureTechnique(
              instruction:
                  'Hold the fabric against a light source to show how much '
                  'light passes through.',
              guidelines: [PhotographyGuideline.diverseLighting],
            ),
            CaptureTechnique(
              instruction:
                  'Place an object behind the fabric to demonstrate visibility '
                  'through it.',
              guidelines: [
                PhotographyGuideline.complementaryBackgrounds,
                PhotographyGuideline.weightAndFlow,
              ],
            ),
            CaptureTechnique(
              instruction:
                  'Capture a shot with layered fabric to show varying '
                  'transparency levels.',
              guidelines: [PhotographyGuideline.weightAndFlow],
            ),
          ],
        FabricProperty.pattern => const [
            CaptureTechnique(
              instruction:
                  'Take flat-lay shots to display the full pattern without '
                  'distortion.',
              guidelines: [PhotographyGuideline.variousAngles],
            ),
            CaptureTechnique(
              instruction:
                  'Use close-ups to showcase intricate designs or weaving '
                  'details.',
              guidelines: [PhotographyGuideline.closeUpShots],
            ),
            CaptureTechnique(
              instruction:
                  'Take a shot of the fabric draped or worn to show pattern '
                  'placement.',
              guidelines: [PhotographyGuideline.weightAndFlow],
            ),
          ],
        FabricProperty.sheen => const [
            CaptureTechnique(
              instruction:
                  'Use angled lighting to highlight the shine or matte finish.',
              guidelines: [PhotographyGuideline.diverseLighting],
            ),
            CaptureTechnique(
              instruction:
                  'Capture a shot from multiple angles to show reflective '
                  'properties.',
              guidelines: [PhotographyGuideline.variousAngles],
            ),
            CaptureTechnique(
              instruction:
                  'Use dark backgrounds to enhance the contrast of the sheen.',
              guidelines: [PhotographyGuideline.complementaryBackgrounds],
            ),
          ],
        FabricProperty.embroidery => const [
            CaptureTechnique(
              instruction:
                  'Use close-up shots to capture embroidery threads, beads, or '
                  'embellishments.',
              guidelines: [PhotographyGuideline.closeUpShots],
            ),
            CaptureTechnique(
              instruction:
                  'Side lighting helps in casting shadows that highlight '
                  'embroidery depth.',
              guidelines: [PhotographyGuideline.diverseLighting],
            ),
            CaptureTechnique(
              instruction:
                  'Capture hands working on embroidery to add authenticity and '
                  'craftsmanship.',
              guidelines: [PhotographyGuideline.tellAStory],
            ),
          ],
      };
}
