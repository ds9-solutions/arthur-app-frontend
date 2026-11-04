import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Botão "Continuar com Google", usado no Login e no Criar conta (A7).
///
/// O logo "G" ainda não está no app: baixe o asset oficial no kit de marca
/// do Google Sign-In e passe-o em [leading] (ver Parte C4 da especificação).
class GoogleSignInButton extends StatelessWidget {
  final Widget? leading;

  const GoogleSignInButton({super.key, this.leading});

  Future<void> _signIn(BuildContext context) async {
    final navigator = Navigator.of(context);
    final signedIn = await context.read<AuthProvider>().signInWithGoogle();
    // O AuthGate já trocou a raiz; tira telas empilhadas (ex.: Criar conta).
    if (signedIn) navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return OutlinedButton(
      onPressed: auth.isBusy ? null : () => _signIn(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.colors.text.base,
        side: BorderSide(color: context.colors.border.base),
        padding: EdgeInsets.symmetric(vertical: context.spacing.base),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.borderRadius.pill),
        ),
        textStyle: context.typography.body.copyWith(fontWeight: TypographyTokens.semibold),
      ),
      child: auth.isGoogleLoading
          ? SizedBox(
              width: context.spacing.base,
              height: context.spacing.base,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  SizedBox.square(dimension: context.spacing.large, child: leading),
                  SizedBox(width: context.spacing.small),
                ],
                const Flexible(
                  child: Text('Continuar com Google', textAlign: TextAlign.center),
                ),
              ],
            ),
    );
  }
}

/// Separador "ou" entre o botão principal e o do Google.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(child: Divider(color: context.colors.border.base));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.base),
      child: Row(
        children: [
          line,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.small),
            child: Text('ou', style: context.typography.caption),
          ),
          line,
        ],
      ),
    );
  }
}
