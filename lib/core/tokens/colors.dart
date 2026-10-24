import 'package:flutter/material.dart';

extension BuildContextColors on BuildContext {
  AppColors get colors => AppColors._(this);
}

class AppColors {
  AppColors._(this._context);
  final BuildContext _context;
  ThemeData get theme => Theme.of(_context);

  Color get primary => ColorsTokens.primaryDefault;
  Color get primaryHover => ColorsTokens.primaryHover;
  Color get primaryPressed => ColorsTokens.primaryPressed;
  Color get primaryDisabled => ColorsTokens.primaryDisabled;
  Color get secondary => ColorsTokens.secondaryDefault;

  AppTextColors get text => const AppTextColors();
  AppBackgroundColors get background => const AppBackgroundColors();
  AppBorderColors get border => const AppBorderColors();

  Color get error => ColorsTokens.errorDefault;
  Color get success => ColorsTokens.successDefault;
  Color get info => ColorsTokens.primaryDefault;
  Color get disabled => ColorsTokens.textDisabled;
  Color get placeholder => ColorsTokens.textSecondary;
  Color get hint => ColorsTokens.textSecondary;
}

class AppTextColors {
  const AppTextColors();
  Color get base => ColorsTokens.textDefault;
  Color get secondary => ColorsTokens.textSecondary;
  Color get disabled => ColorsTokens.textDisabled;
}

class AppBackgroundColors {
  const AppBackgroundColors();
  Color get base => ColorsTokens.backgroundDefault;
  Color get surface => ColorsTokens.backgroundSurface;
  Color get elevated => ColorsTokens.backgroundElevated;
}

class AppBorderColors {
  const AppBorderColors();
  Color get base => ColorsTokens.borderDefault;
}

/// Paleta bruta da marca Arthur. Não usar diretamente em componentes —
/// sempre usar [ColorsTokens].
class ColorPrimitives {
  ColorPrimitives._();

  static const Color neutral900 = Color(0xFF121212);
  static const Color neutral800 = Color(0xFF1E1E1E);
  static const Color neutral700 = Color(0xFF2A2A2A);
  static const Color neutral600 = Color(0xFF3A3A3A);
  static const Color neutral400 = Color(0xFF6B6B6B);
  static const Color neutral200 = Color(0xFFB3B3B3);
  static const Color neutral0 = Color(0xFFFFFFFF);

  static const Color orange300 = Color(0xFFFF8A3D);
  static const Color orange500 = Color(0xFFFF6B00);
  static const Color orange600 = Color(0xFFE86000);
  static const Color orange700 = Color(0xFFCC5500);
  static const Color orange900 = Color(0xFF5A3D2A);

  static const Color yellow300 = Color(0xFFFFD54F);
  static const Color yellow500 = Color(0xFFFFC107);
  static const Color yellow700 = Color(0xFFC79100);

  static const Color green300 = Color(0xFF6EE7A0);
  static const Color green500 = Color(0xFF2ECC71);
  static const Color green700 = Color(0xFF229954);

  static const Color pink300 = Color(0xFFFF9BAA);
  static const Color pink500 = Color(0xFFFF6B81);
  static const Color pink700 = Color(0xFFE14D63);
}

/// Tokens semânticos do design system Arthur (modo dark). Referenciam
/// [ColorPrimitives] — são estes que os componentes devem consumir.
class ColorsTokens {
  ColorsTokens._();

  static const Color backgroundDefault = ColorPrimitives.neutral900;
  static const Color backgroundSurface = ColorPrimitives.neutral800;
  static const Color backgroundElevated = ColorPrimitives.neutral700;

  static const Color borderDefault = ColorPrimitives.neutral600;

  static const Color textDefault = ColorPrimitives.neutral0;
  static const Color textSecondary = ColorPrimitives.neutral200;
  static const Color textDisabled = ColorPrimitives.neutral400;

  static const Color primaryDefault = ColorPrimitives.orange500;
  static const Color primaryHover = ColorPrimitives.orange300;
  static const Color primaryPressed = ColorPrimitives.orange600;
  static const Color primaryDisabled = ColorPrimitives.orange900;

  static const Color secondaryDefault = ColorPrimitives.yellow500;

  static const Color successDefault = ColorPrimitives.green500;

  static const Color errorDefault = ColorPrimitives.pink500;
}
