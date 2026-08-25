import 'package:flutter/material.dart';

/// Colour tokens extracted directly from the Figma file "Artisans lens".
///
/// Every value here was read out of the design's fills and strokes rather than
/// eyeballed, so the app matches the source of truth exactly. Do not introduce
/// a colour that is not in this list.
abstract final class AppColors {
  // ----------------------------------------------------------------- brand
  /// Primary brand terracotta — serif titles, primary buttons, active states.
  static const Color primary = Color(0xFF92331D);

  /// Lighter terracotta used for large filled surfaces such as the
  /// "New Product" card and the capture shutter.
  static const Color primaryLight = Color(0xFFB24A32);

  // ------------------------------------------------------------ background
  /// App background.
  static const Color background = Color(0xFFFFF8F5);

  /// Slightly warmer background used behind app bars and grouped sections.
  static const Color backgroundAlt = Color(0xFFFBF2ED);

  // --------------------------------------------------------------- surface
  /// Default card surface.
  static const Color surface = Color(0xFFF5ECE7);

  /// Raised / selected card surface.
  static const Color surfaceSelected = Color(0xFFFFE7E2);

  /// Neutral surface for inactive icon tiles.
  static const Color surfaceMuted = Color(0xFFE9E1DC);

  /// Pale sand used by the pro-tip banner.
  static const Color surfaceSand = Color(0xFFF5F0E6);

  static const Color white = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------- border
  /// Default card and input border.
  static const Color border = Color(0xFFDDC0BA);

  /// Subtle divider between sections.
  static const Color divider = Color(0xFFE9E1DC);

  static const Color borderLight = Color(0xFFE1D8D4);

  // ------------------------------------------------------------------ text
  /// Headings — near-black.
  static const Color textPrimary = Color(0xFF1E1B18);

  /// Body copy — warm brown, the most used colour in the file.
  static const Color textSecondary = Color(0xFF57423D);

  /// Muted captions.
  static const Color textMuted = Color(0xFF55534B);

  static const Color textOnPrimary = Color(0xFFFFF8F5);

  // --------------------------------------------------------------- support
  /// Sage green for the "Angle: OK" chip and success states.
  static const Color success = Color(0xFF596245);

  /// Light sage border used with [success].
  static const Color successBorder = Color(0xFFDDE7C2);

  /// Amber used by the live "Light" warning chip on the capture screen.
  static const Color warning = Color(0xFFD79A2B);

  // --------------------------------------------------------- camera overlay
  /// Scrim behind the capture screen chrome.
  static const Color cameraScrim = Color(0xCC1E1B18);

  /// Ghost-frame guide stroke.
  static const Color guideStroke = Color(0xB3FFFFFF);
}
