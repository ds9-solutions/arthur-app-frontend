import 'package:flutter/material.dart';

export 'colors.dart';
export 'elevation.dart';
export 'typography.dart';

/// Spacing tokens — escala fixa de 4px da marca Arthur.
extension BuildContextSpacing on BuildContext {
  AppSpacing get spacing => const AppSpacing();
}

class AppSpacing {
  const AppSpacing();

  double get extraSmall => AppSpacingTokens.xs;
  double get small => AppSpacingTokens.sm;
  double get base => AppSpacingTokens.md;
  double get large => AppSpacingTokens.lg;
  double get extraLarge => AppSpacingTokens.xl;
  double get doubleExtraLarge => AppSpacingTokens.xxl;
  double get tripleExtraLarge => AppSpacingTokens.xxxl;
}

class AppSpacingTokens {
  AppSpacingTokens._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

/// Border radius tokens
extension BuildContextBorderRadius on BuildContext {
  AppBorderRadius get borderRadius => const AppBorderRadius();
}

class AppBorderRadius {
  const AppBorderRadius();

  double get sm => AppBorderRadiusTokens.sm;
  double get md => AppBorderRadiusTokens.md;
  double get lg => AppBorderRadiusTokens.lg;
  double get pill => AppBorderRadiusTokens.pill;
}

class AppBorderRadiusTokens {
  AppBorderRadiusTokens._();

  static const double sm = 4;
  static const double md = 8;
  static const double lg = 16;
  static const double pill = 999;
}
