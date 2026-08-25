/// Spacing and radius tokens measured from the Figma file.
abstract final class AppDimens {
  // Radii observed in the design: 4, 6, 8, 12 and fully rounded pills.
  static const double radiusXs = 4;
  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusPill = 9999;

  // Spacing scale.
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;

  /// Horizontal page padding used across the screens.
  static const double pagePadding = 20;

  /// Height of the top app bar in the design.
  static const double appBarHeight = 56;

  /// Height of the bottom navigation shell.
  static const double bottomNavHeight = 80;

  /// Minimum tap target — the design brief calls for large targets because the
  /// audience has low digital literacy.
  static const double minTapTarget = 48;
}
