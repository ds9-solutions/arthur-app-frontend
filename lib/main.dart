import 'package:arthur/core/theme/app_theme.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/services/consent_service.dart';
import 'package:arthur/features/auth/views/account_load_error_view.dart';
import 'package:arthur/features/auth/views/complete_sign_up_view.dart';
import 'package:arthur/features/auth/views/login_view.dart';
import 'package:arthur/features/auth/views/widgets/email_verification_banner.dart';
import 'package:arthur/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  /// Os testes passam fakes; no app, o [AuthProvider] usa o Firebase.
  final AuthService? authService;
  final ConsentService? consentService;

  const MyApp({super.key, this.authService, this.consentService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService, consentService: consentService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Arthur',
        theme: AppTheme.dark,
        home: const AuthGate(),
      ),
    );
  }
}

/// Decide a tela inicial a partir do estado de autenticação. É a única fonte
/// de navegação entre Login e Home: as telas só autenticam (B1).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.unauthenticated:
        return const LoginView();
      case AuthStatus.needsConsent:
        return const CompleteSignUpView();
      case AuthStatus.consentCheckFailed:
        return const AccountLoadErrorView();
      case AuthStatus.authenticated:
        final user = auth.user;
        return Scaffold(
          appBar: AppBar(
            title: Text(user?.displayName ?? user?.email ?? 'Arthur'),
            actions: [
              IconButton(
                tooltip: 'Sair',
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<AuthProvider>().logout(),
              ),
            ],
          ),
          body: const Column(
            children: [
              EmailVerificationBanner(),
              Expanded(child: Center(child: Text('Logado com sucesso'))),
            ],
          ),
        );
    }
  }
}
