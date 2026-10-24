import 'package:arthur/features/auth/views/widgets/auth_card.dart';
import 'package:arthur/features/auth/views/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';

/// Tela Criar conta (A7), aberta pelo link "Criar conta" do login.
class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: const AuthCard(
        title: 'Criar conta',
        subtitle: 'Para responsáveis maiores de 18 anos',
        child: SignUpForm(),
      ),
    );
  }
}
