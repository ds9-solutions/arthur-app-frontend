import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/features/auth/models/params/login_params.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:arthur/features/auth/validators/auth_validators.dart';
import 'package:arthur/features/auth/views/sign_up_view.dart';
import 'package:arthur/features/auth/views/widgets/google_sign_in_button.dart';
import 'package:arthur/features/auth/views/widgets/password_field.dart';
import 'package:arthur/features/auth/views/widgets/password_reset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<AuthProvider>().login(
      LoginParams(email: _emailController.text, password: _passwordController.text),
    );
  }

  Future<void> _openSignUp() async {
    final auth = context.read<AuthProvider>();
    auth.clearFailure();
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SignUpView()));
    auth.clearFailure();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              validator: AuthValidators.loginPassword,
              onFieldSubmitted: (_) => _submit(),
            ),
            if (auth.failure != null) ...[
              SizedBox(height: context.spacing.small),
              Text(auth.failure!.getInterMsg(), style: TextStyle(color: context.colors.error)),
            ],
            SizedBox(height: context.spacing.small),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    PasswordResetDialog.show(context, initialEmail: _emailController.text),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Esqueci minha senha', style: context.typography.caption),
              ),
            ),
            SizedBox(height: context.spacing.base),
            ElevatedButton(
              onPressed: auth.isBusy ? null : _submit,
              child: auth.isLoading
                  ? SizedBox(
                      width: context.spacing.base,
                      height: context.spacing.base,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Entrar'),
            ),
            const AuthOrDivider(),
            const GoogleSignInButton(),
            SizedBox(height: context.spacing.large),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'É novo por aqui? ',
                  style: context.typography.caption.copyWith(color: context.colors.text.secondary),
                ),
                TextButton(
                  onPressed: auth.isBusy ? null : _openSignUp,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Criar conta',
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
