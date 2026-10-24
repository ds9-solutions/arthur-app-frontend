// Testes de widget: sobem o app real (MyApp) com AuthService e
// ConsentService falsos, sem tocar o Firebase, e cobrem login, criação de
// conta, login com Google, Concluir cadastro e logout.

import 'package:arthur/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_auth_service.dart';
import 'fakes/fake_consent_service.dart';

void main() {
  late FakeAuthService auth;
  late FakeConsentService consent;

  setUp(() {
    auth = FakeAuthService();
    consent = FakeConsentService();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MyApp(authService: auth, consentService: consent));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Finder field(String hint) => find.widgetWithText(TextFormField, hint);

  testWidgets('login com e-mail e senha abre a Home e o logout volta ao Login', (tester) async {
    auth.addAccount(email: 'user@example.com', password: 'abcdefg1', name: 'Mariana');
    consent.records['user-1'] = (name: 'Mariana', email: 'user@example.com');
    await pumpApp(tester);

    expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
    await tester.enterText(field('E-mail'), ' User@Example.com ');
    await tester.enterText(field('Senha'), 'abcdefg1');
    await tap(tester, find.widgetWithText(ElevatedButton, 'Entrar'));

    expect(find.text('Logado com sucesso'), findsOneWidget);
    expect(find.text('Mariana'), findsOneWidget);

    await tap(tester, find.byIcon(Icons.logout));
    expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
  });

  testWidgets('senha errada mostra a mensagem da RN09', (tester) async {
    auth.addAccount(email: 'user@example.com', password: 'abcdefg1');
    await pumpApp(tester);

    await tester.enterText(field('E-mail'), 'user@example.com');
    await tester.enterText(field('Senha'), 'errada123');
    await tap(tester, find.widgetWithText(ElevatedButton, 'Entrar'));

    expect(find.text('E-mail ou senha incorretos'), findsOneWidget);
  });

  testWidgets('e-mail inválido não é enviado', (tester) async {
    await pumpApp(tester);

    await tester.enterText(field('E-mail'), 'user');
    await tester.enterText(field('Senha'), 'abcdefg1');
    await tap(tester, find.widgetWithText(ElevatedButton, 'Entrar'));

    expect(find.text('E-mail inválido'), findsOneWidget);
  });

  group('Criar conta', () {
    Future<void> openSignUp(WidgetTester tester) async {
      await pumpApp(tester);
      await tap(tester, find.widgetWithText(TextButton, 'Criar conta'));
      expect(find.text('Para responsáveis maiores de 18 anos'), findsOneWidget);
    }

    Future<void> fillForm(WidgetTester tester, {String confirm = 'abcdefg1'}) async {
      await tester.enterText(field('Nome'), 'Mariana Souza');
      await tester.enterText(field('E-mail'), 'mariana@exemplo.com');
      await tester.enterText(field('Senha'), 'abcdefg1');
      await tester.enterText(field('Confirmar senha'), confirm);
    }

    Finder createButton() => find.widgetWithText(ElevatedButton, 'Criar conta');

    testWidgets('botão desabilitado até marcar o aceite (RN07)', (tester) async {
      await openSignUp(tester);
      await fillForm(tester);

      expect(tester.widget<ElevatedButton>(createButton()).onPressed, isNull);
      await tap(tester, find.byType(Checkbox));
      expect(tester.widget<ElevatedButton>(createButton()).onPressed, isNotNull);
    });

    testWidgets('cria a conta, grava o aceite e volta à raiz na Home', (tester) async {
      await openSignUp(tester);
      await fillForm(tester);
      await tap(tester, find.byType(Checkbox));
      await tap(tester, createButton());

      expect(find.text('Logado com sucesso'), findsOneWidget);
      expect(find.textContaining('Confirme seu e-mail'), findsOneWidget);
      expect(consent.records.values.single.email, 'mariana@exemplo.com');
      expect(auth.verificationEmailsSent, 1);
      // A pilha voltou à raiz: não há botão de voltar para o formulário.
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('senhas diferentes não criam a conta (RN05)', (tester) async {
      await openSignUp(tester);
      await fillForm(tester, confirm: 'abcdefg2');
      await tap(tester, find.byType(Checkbox));
      await tap(tester, createButton());

      expect(find.text('As senhas não conferem'), findsOneWidget);
      expect(auth.createCalls, 0);
    });

    testWidgets('e-mail já cadastrado oferece Entrar e Recuperar senha (RN08)', (tester) async {
      auth.addAccount(email: 'mariana@exemplo.com', password: 'outra123');
      await openSignUp(tester);
      await fillForm(tester);
      await tap(tester, find.byType(Checkbox));
      await tap(tester, createButton());

      expect(find.text('Este e-mail já tem conta'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Recuperar senha'), findsOneWidget);

      // Voltar ao login não leva o erro do cadastro junto.
      await tap(tester, find.widgetWithText(TextButton, 'Entrar').first);
      expect(find.text('Este e-mail já tem conta'), findsNothing);
      expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
    });

    testWidgets('falha ao gravar o aceite leva a Concluir cadastro', (tester) async {
      consent.nextWriteErrorCode = 'unavailable';
      await openSignUp(tester);
      await fillForm(tester);
      await tap(tester, find.byType(Checkbox));
      await tap(tester, createButton());

      expect(find.text('Concluir cadastro'), findsOneWidget);
    });
  });

  group('Login com Google', () {
    testWidgets('conta nova passa por Concluir cadastro antes da Home (RN17)', (tester) async {
      await pumpApp(tester);
      await tap(tester, find.text('Continuar com Google'));

      expect(find.text('Concluir cadastro'), findsOneWidget);
      final continueButton = find.widgetWithText(ElevatedButton, 'Continuar');
      expect(tester.widget<ElevatedButton>(continueButton).onPressed, isNull);

      await tap(tester, find.byType(Checkbox));
      await tap(tester, continueButton);

      expect(find.text('Logado com sucesso'), findsOneWidget);
      expect(consent.records.containsKey('google-user'), isTrue);
      // Conta Google já chega verificada (RN19).
      expect(find.textContaining('Confirme seu e-mail'), findsNothing);
    });

    testWidgets('conta Google já cadastrada entra direto', (tester) async {
      consent.records['google-user'] = (name: 'R', email: 'responsavel@gmail.com');
      await pumpApp(tester);
      await tap(tester, find.text('Continuar com Google'));

      expect(find.text('Logado com sucesso'), findsOneWidget);
    });

    testWidgets('fechar a janela do Google não mostra erro (RN20)', (tester) async {
      auth.nextErrorCode = 'popup-closed-by-user';
      await pumpApp(tester);
      await tap(tester, find.text('Continuar com Google'));

      expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
      expect(find.textContaining('Não foi possível'), findsNothing);
    });

    testWidgets('Sair em Concluir cadastro volta ao Login', (tester) async {
      await pumpApp(tester);
      await tap(tester, find.text('Continuar com Google'));
      await tap(tester, find.widgetWithText(TextButton, 'Sair'));

      expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
    });
  });

  testWidgets('recuperar senha mostra a mesma mensagem sem cadastro (RN10)', (tester) async {
    await pumpApp(tester);
    await tester.enterText(field('E-mail'), 'ninguem@exemplo.com');
    await tap(tester, find.text('Esqueci minha senha'));
    await tap(tester, find.text('Enviar link'));

    expect(
      find.text('Se o e-mail estiver cadastrado, enviamos um link para redefinir a senha.'),
      findsOneWidget,
    );
  });

  testWidgets('erro ao ler o aceite não libera a Home', (tester) async {
    auth.addAccount(email: 'user@example.com', password: 'abcdefg1');
    consent.records['user-1'] = (name: 'U', email: 'user@example.com');
    consent.nextReadErrorCode = 'unavailable';
    await pumpApp(tester);

    await tester.enterText(field('E-mail'), 'user@example.com');
    await tester.enterText(field('Senha'), 'abcdefg1');
    await tap(tester, find.widgetWithText(ElevatedButton, 'Entrar'));

    expect(find.text('Não foi possível carregar sua conta'), findsOneWidget);
    await tap(tester, find.text('Tentar de novo'));
    expect(find.text('Logado com sucesso'), findsOneWidget);
  });
}
