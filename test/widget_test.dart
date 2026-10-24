// Smoke test: sobe o app real (MyApp), sem tocar Firebase, e valida a
// integração AuthGate -> LoginView -> LoginForm -> AuthProvider -> mock
// AuthService, do login até o estado autenticado.

import 'package:arthur/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mostra a tela de login e autentica com o AuthService mock', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Entrar'), findsWidgets);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.enterText(find.widgetWithText(TextFormField, 'Usuário'), 'user@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Senha'), '123456');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Logado com sucesso'), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Entrar'), findsWidgets);
  });
}
