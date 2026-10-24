import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/features/auth/models/params/complete_sign_up_params.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:arthur/features/auth/validators/auth_validators.dart';
import 'package:arthur/features/auth/views/widgets/auth_card.dart';
import 'package:arthur/features/auth/views/widgets/legal_consent_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Concluir cadastro (A7): mostrada pelo AuthGate quando o usuário está
/// autenticado mas ainda não aceitou os Termos (primeiro acesso com Google,
/// ou aceite que falhou ao gravar).
class CompleteSignUpView extends StatefulWidget {
  const CompleteSignUpView({super.key});

  @override
  State<CompleteSignUpView> createState() => _CompleteSignUpViewState();
}

class _CompleteSignUpViewState extends State<CompleteSignUpView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _accepted = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_accepted || !_formKey.currentState!.validate()) return;
    await context.read<AuthProvider>().completeSignUp(
      CompleteSignUpParams(name: _nameController.text, acceptedLegalDocs: _accepted),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: AuthCard(
        title: 'Concluir cadastro',
        subtitle: auth.user?.email,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                style: context.typography.body,
                decoration: const InputDecoration(hintText: 'Nome'),
                validator: AuthValidators.name,
              ),
              SizedBox(height: context.spacing.base),
              LegalConsentCheckbox(
                value: _accepted,
                onChanged: (value) => setState(() => _accepted = value),
              ),
              if (auth.failure != null) ...[
                SizedBox(height: context.spacing.small),
                Text(auth.failure!.getInterMsg(), style: TextStyle(color: context.colors.error)),
              ],
              SizedBox(height: context.spacing.base),
              ElevatedButton(
                onPressed: (!_accepted || auth.isBusy) ? null : _submit,
                child: auth.isLoading
                    ? SizedBox(
                        width: context.spacing.base,
                        height: context.spacing.base,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continuar'),
              ),
              SizedBox(height: context.spacing.base),
              TextButton(
                onPressed: auth.isBusy ? null : () => context.read<AuthProvider>().logout(),
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
