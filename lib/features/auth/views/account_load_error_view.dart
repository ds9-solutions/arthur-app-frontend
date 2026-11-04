import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/features/auth/views/widgets/auth_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Autenticado, mas não foi possível ler o aceite em `users/{uid}`
/// (ex.: sem internet). Não libera a Home sem confirmar o aceite.
class AccountLoadErrorView extends StatelessWidget {
  const AccountLoadErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      body: AuthCard(
        title: 'Não foi possível carregar sua conta',
        subtitle: connectivityMessage,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: auth.retryConsentCheck,
              child: const Text('Tentar de novo'),
            ),
            SizedBox(height: context.spacing.base),
            TextButton(onPressed: auth.logout, child: const Text('Sair')),
          ],
        ),
      ),
    );
  }
}
