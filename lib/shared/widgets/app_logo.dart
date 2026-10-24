import 'package:arthur/core/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Mascote circular da marca Arthur (assets/images/logo.svg).
class AppLogoMark extends StatelessWidget {
  final double size;

  const AppLogoMark({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/images/logo.svg', width: size, height: size);
  }
}

/// Wordmark "Arthur." com o ponto final na cor primária da marca.
class AppLogoWordmark extends StatelessWidget {
  final TextStyle? style;

  const AppLogoWordmark({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final base = style ?? context.typography.h1;
    return RichText(
      text: TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'Arthur'),
          TextSpan(text: '.', style: base.copyWith(color: context.colors.primary)),
        ],
      ),
    );
  }
}

/// Tagline "Seu tutor. Sempre." — primeira parte em laranja, segunda em branco.
class AppTagline extends StatelessWidget {
  const AppTagline({super.key});

  @override
  Widget build(BuildContext context) {
    final base = context.typography.body.copyWith(fontWeight: TypographyTokens.bold);
    return RichText(
      text: TextSpan(
        style: base,
        children: [
          TextSpan(text: 'Seu tutor. ', style: TextStyle(color: context.colors.primary)),
          TextSpan(text: 'Sempre.', style: TextStyle(color: context.colors.text.base)),
        ],
      ),
    );
  }
}
