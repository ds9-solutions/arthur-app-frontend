import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/shared/widgets/app_logo.dart';
import 'package:flutter/material.dart';

/// Cartão das telas de autenticação: logo, wordmark, tagline e o conteúdo.
/// Usado por Login, Criar conta e Concluir cadastro (A7).
class AuthCard extends StatelessWidget {
  final Widget child;

  /// Título opcional abaixo da tagline (ex.: "Criar conta").
  final String? title;
  final String? subtitle;

  const AuthCard({super.key, required this.child, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing.large),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Container(
            padding: EdgeInsets.all(context.spacing.extraLarge),
            decoration: BoxDecoration(
              color: context.colors.background.surface,
              borderRadius: BorderRadius.circular(context.borderRadius.lg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLogoMark(size: context.spacing.tripleExtraLarge + context.spacing.large),
                AppLogoWordmark(
                  style: context.typography.display.copyWith(fontSize: 54, fontWeight: FontWeight.bold),
                ),
                const AppTagline(),
                if (title != null) ...[
                  SizedBox(height: context.spacing.large),
                  Text(title!, style: context.typography.h2, textAlign: TextAlign.center),
                ],
                if (subtitle != null) ...[
                  SizedBox(height: context.spacing.extraSmall),
                  Text(subtitle!, style: context.typography.caption, textAlign: TextAlign.center),
                ],
                SizedBox(height: context.spacing.extraLarge),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
