import 'package:flutter/material.dart';

import 'colors.dart';

extension BuildContextTypography on BuildContext {
  AppTypography get typography => AppTypography._(this);
}

class AppTypography {
  AppTypography._(this._context);
  final BuildContext _context;

  /// Títulos de destaque máximo
  TextStyle get display =>
      TypographyTokens.display.copyWith(color: _context.colors.text.base);

  /// Cabeçalhos de seção
  TextStyle get h1 => TypographyTokens.h1.copyWith(color: _context.colors.text.base);

  /// Sub-cabeçalhos
  TextStyle get h2 => TypographyTokens.h2.copyWith(color: _context.colors.text.base);

  /// Texto corrido
  TextStyle get body => TypographyTokens.body.copyWith(color: _context.colors.text.base);

  /// Labels, metadados, legenda
  TextStyle get caption =>
      TypographyTokens.caption.copyWith(color: _context.colors.text.secondary);
}

/// Escala tipográfica da marca Arthur. Família base: Inter (400–900).
///
/// Fonte "Inter" precisa ser adicionada em pubspec.yaml (assets de fonte ou
/// pacote google_fonts) para renderizar de fato — enquanto isso o Flutter
/// cai no fallback da plataforma.
class TypographyTokens {
  TypographyTokens._();

  static const String fontFamily = 'Inter';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: extrabold,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: bold,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: semibold,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: regular,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: regular,
  );
}
