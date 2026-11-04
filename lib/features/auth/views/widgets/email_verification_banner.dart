import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Faixa "Confirme seu e-mail" na Home enquanto `emailVerified` for falso
/// (A7, ação 7). Não bloqueia o uso nesta fase (RN11).
class EmailVerificationBanner extends StatefulWidget {
  const EmailVerificationBanner({super.key});

  @override
  State<EmailVerificationBanner> createState() => _EmailVerificationBannerState();
}

class _EmailVerificationBannerState extends State<EmailVerificationBanner> {
  bool _busy = false;

  Future<void> _run(Future<String?> Function() action) async {
    if (_busy) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final message = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    if (message != null) messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    if (user == null || user.emailVerified) return const SizedBox.shrink();

    return MaterialBanner(
      backgroundColor: context.colors.background.elevated,
      content: Text(
        'Confirme seu e-mail pelo link que enviamos para ${user.email ?? 'você'}.',
        style: context.typography.caption.copyWith(color: context.colors.text.base),
      ),
      actions: [
        TextButton(
          onPressed: _busy
              ? null
              : () => _run(() async {
                  final failure = await auth.resendVerification();
                  return failure?.getInterMsg() ?? 'E-mail reenviado';
                }),
          child: const Text('Reenviar'),
        ),
        TextButton(
          onPressed: _busy
              ? null
              : () => _run(() async {
                  final failure = await auth.refreshUser();
                  return failure?.getInterMsg();
                }),
          child: const Text('Já confirmei'),
        ),
      ],
    );
  }
}
