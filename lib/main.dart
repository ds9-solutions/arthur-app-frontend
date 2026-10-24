import 'package:arthur/core/theme/app_theme.dart';
import 'package:arthur/features/auth/providers/auth_provider.dart';
import 'package:arthur/features/auth/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Descomente ao configurar o Firebase (ver features/auth/services/auth_service.dart):
// import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bypass temporário: sem credenciais do Firebase ainda. Rode
  // `flutterfire configure` para gerar lib/firebase_options.dart, descomente
  // o import acima e a linha abaixo, e reative a implementação real em
  // AuthService.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner : false,
        title: 'Arthur',
        theme: AppTheme.dark,
        home: const AuthGate(),
      ),
    );
  }
}

/// Decide a tela inicial a partir do estado de autenticação.
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
      case AuthStatus.authenticated:
        return Scaffold(
          appBar: AppBar(
            title: Text(auth.user?.email ?? 'Arthur'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<AuthProvider>().logout(),
              ),
            ],
          ),
          body: const Center(child: Text('Logado com sucesso')),
        );
    }
  }
}
