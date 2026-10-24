import 'package:arthur/core/tokens/tokens.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ColorsTokens.primaryDefault,
      brightness: Brightness.dark,
      primary: ColorsTokens.primaryDefault,
      secondary: ColorsTokens.secondaryDefault,
      error: ColorsTokens.errorDefault,
      surface: ColorsTokens.backgroundSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: TypographyTokens.fontFamily,
      scaffoldBackgroundColor: ColorsTokens.backgroundDefault,
      primaryColor: ColorsTokens.primaryDefault,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsTokens.backgroundSurface,
        foregroundColor: ColorsTokens.textDefault,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsTokens.primaryDefault,
          foregroundColor: ColorsTokens.textDefault,
          disabledBackgroundColor: ColorsTokens.primaryDisabled,
          padding: const EdgeInsets.symmetric(vertical: AppSpacingTokens.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadiusTokens.pill),
          ),
          textStyle: TypographyTokens.body.copyWith(fontWeight: TypographyTokens.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ColorsTokens.primaryDefault),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorsTokens.backgroundElevated,
        hintStyle: const TextStyle(color: ColorsTokens.textSecondary),
        labelStyle: const TextStyle(color: ColorsTokens.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacingTokens.md,
          vertical: AppSpacingTokens.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadiusTokens.md),
          borderSide: const BorderSide(color: ColorsTokens.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadiusTokens.md),
          borderSide: const BorderSide(color: ColorsTokens.primaryDefault),
        ),
      ),
    );
  }
}
