import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/features/auth/models/params/sign_up_params.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:arthur/features/auth/validators/auth_validators.dart';
import 'package:arthur/features/auth/views/widgets/google_sign_in_button.dart';
import 'package:arthur/features/auth/views/widgets/legal_consent_checkbox.dart';
import 'package:arthur/features/auth/views/widgets/password_field.dart';
import 'package:arthur/features/auth/views/widgets/password_reset_dialog.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _accepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_accepted || !_formKey.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    final created = await context.read<AuthProvider>().signUp(
      SignUpParams(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        acceptedLegalDocs: _accepted,
      ),
    );
    // O AuthGate já mostra a Home por baixo; tira o formulário da pilha.
    if (created) navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final failure = auth.failure;

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.next,
              style: context.typography.body,
              decoration: const InputDecoration(hintText: 'Nome'),
              validator: AuthValidators.name,
            ),
            SizedBox(height: context.spacing.base),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              autocorrect: false,
              style: context.typography.body,
              decoration: const InputDecoration(hintText: 'E-mail'),
              validator: AuthValidators.email,
            ),
            SizedBox(height: context.spacing.base),
            PasswordField(
              controller: _passwordController,
              helperText: 'Mínimo de 8 caracteres, com letras e números',
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
              validator: AuthValidators.newPassword,
            ),
            SizedBox(height: context.spacing.base),
            PasswordField(
              controller: _confirmController,
              hintText: 'Confirmar senha',
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) =>
                  AuthValidators.confirmPassword(value, _passwordController.text),
              onFieldSubmitted: (_) => _submit(),
            ),
            SizedBox(height: context.spacing.base),
            LegalConsentCheckbox(
              value: _accepted,
              onChanged: (value) => setState(() => _accepted = value),
            ),
            if (failure != null) ...[
              SizedBox(height: context.spacing.small),
              Text(failure.getInterMsg(), style: TextStyle(color: context.colors.error)),
              if (failure is EmailAlreadyInUseFailure)
                Wrap(
                  spacing: context.spacing.base,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Entrar'),
                    ),
                    TextButton(
                      onPressed: () =>
                          PasswordResetDialog.show(context, initialEmail: _emailController.text),
                      child: const Text('Recuperar senha'),
                    ),
                  ],
                ),
            ],
            SizedBox(height: context.spacing.base),
            ElevatedButton(
              // RN07: só habilita com o aceite marcado.
              onPressed: (!_accepted || auth.isBusy) ? null : _submit,
              child: auth.isLoading
                  ? SizedBox(
                      width: context.spacing.base,
                      height: context.spacing.base,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Criar conta'),
            ),
            const AuthOrDivider(),
            const GoogleSignInButton(),
            SizedBox(height: context.spacing.large),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Já tem conta? ',
                  style: context.typography.caption.copyWith(color: context.colors.text.secondary),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Entrar',
                    style: context.typography.caption.copyWith(fontWeight: TypographyTokens.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
