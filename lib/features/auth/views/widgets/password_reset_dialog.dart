import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:arthur/features/auth/validators/auth_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Diálogo "Recuperar senha" (A7). Mostra sempre a mesma mensagem depois
/// do envio, com ou sem cadastro (RN10).
class PasswordResetDialog extends StatefulWidget {
  final String initialEmail;

  const PasswordResetDialog({super.key, this.initialEmail = ''});

  static Future<void> show(BuildContext context, {String initialEmail = ''}) {
    return showDialog<void>(
      context: context,
      builder: (_) => PasswordResetDialog(initialEmail: initialEmail),
    );
  }

  @override
  State<PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _sending = false;
  bool _sent = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending || !_formKey.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    final failure = await context.read<AuthProvider>().sendPasswordReset(_emailController.text);
    if (!mounted) return;
    setState(() {
      _sending = false;
      _sent = failure == null;
      _error = failure?.getInterMsg();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) {
      return AlertDialog(
        title: const Text('Recuperar senha'),
        content: Text(
          'Se o e-mail estiver cadastrado, enviamos um link para redefinir a senha.',
          style: context.typography.body,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Recuperar senha'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => _send(),
              style: context.typography.body,
              decoration: const InputDecoration(hintText: 'E-mail'),
              validator: AuthValidators.email,
            ),
            if (_error != null) ...[
              SizedBox(height: context.spacing.small),
              Text(_error!, style: TextStyle(color: context.colors.error)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        TextButton(
          onPressed: _sending ? null : _send,
          child: _sending
              ? SizedBox(
                  width: context.spacing.base,
                  height: context.spacing.base,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Enviar link'),
        ),
      ],
    );
  }
}
