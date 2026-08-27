import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type tokens extracted from the Figma file.
///
/// The design uses exactly two families: Playfair Display for display/serif
/// headings and Inter for everything else. Sizes, weights, letter spacing and
/// line heights below are the values measured in the file.
abstract final class AppTypography {
  static const String serif = 'PlayfairDisplay';
  static const String sans = 'Inter';

  /// Hindi (Devanagari) and Assamese (Bengali script) are not in Inter or
  /// Playfair. Flutter falls through this list to the phone's system fonts.
  static const List<String> scriptFallback = [
    'Noto Sans Devanagari',
    'Noto Sans Bengali',
    'Noto Sans',
    'sans-serif',
  ];

  // ------------------------------------------------------- serif / display
  /// Playfair Display 700 · 30/36 — screen headlines such as
  /// "What are you photographing today?".
  static const TextStyle displayLarge = TextStyle(
    fontFamily: serif,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w700,
    fontSize: 30,
    height: 36 / 30,
    color: AppColors.textPrimary,
  );

  /// Playfair Display 600 · 24/32 — section headings and app-bar titles.
  static const TextStyle displayMedium = TextStyle(
    fontFamily: serif,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 32 / 24,
    color: AppColors.textPrimary,
  );

  /// Playfair Display 700 · 24/32 — emphasised serif, e.g. reference preset
  /// names on the review screen.
  static const TextStyle displaySmall = TextStyle(
    fontFamily: serif,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 32 / 24,
    color: AppColors.textPrimary,
  );

  /// Playfair Display 400 · 20/30 — light serif accents.
  static const TextStyle serifBody = TextStyle(
    fontFamily: serif,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 30 / 20,
    color: AppColors.textPrimary,
  );

  // ------------------------------------------------------------ sans / UI
  /// Inter 400 · 18/28 — subtitles, e.g. the splash tagline.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 28 / 18,
    color: AppColors.textSecondary,
  );

  /// Inter 400 · 16/24 — standard body copy and list titles.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
    color: AppColors.textSecondary,
  );

  /// Inter 600 · 14/20 · +0.28 — buttons and emphasised labels.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.28,
    color: AppColors.textPrimary,
  );

  /// Inter 700 · 14/20 · +0.28 — strongest inline emphasis.
  static const TextStyle labelLargeBold = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.28,
    color: AppColors.textPrimary,
  );

  /// Inter 600 · 14/20 · +0.7 — uppercase section headers such as
  /// "CONTINUE PHOTOGRAPHY" and "RECENT PRODUCTS".
  static const TextStyle sectionHeader = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.7,
    color: AppColors.textSecondary,
  );

  /// Inter 500 · 12/16 — the most common style in the file: captions,
  /// counters, chip text and helper copy.
  static const TextStyle labelSmall = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );

  /// Inter 500 · 12/16 · +1.2 — wide-tracked micro labels such as
  /// "REFERENCE PRESET".
  static const TextStyle overline = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 1.2,
    color: AppColors.textSecondary,
  );

  /// Inter 500 · 10/15 · +0.25 — bottom-navigation labels.
  static const TextStyle navLabel = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: scriptFallback,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 15 / 10,
    letterSpacing: 0.25,
    color: AppColors.textSecondary,
  );
}
