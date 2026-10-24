import 'package:arthur/core/tokens/tokens.dart';
import 'package:arthur/features/auth/views/widgets/login_form.dart';
import 'package:arthur/shared/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                  SizedBox(height: context.spacing.extraLarge),
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
