import 'package:arthur/features/auth/views/widgets/auth_card.dart';
import 'package:arthur/features/auth/views/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AuthCard(child: LoginForm()));
  }
}
