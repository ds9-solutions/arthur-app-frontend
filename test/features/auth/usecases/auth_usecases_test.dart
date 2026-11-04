import 'package:arthur/features/auth/models/params/complete_sign_up_params.dart';
import 'package:arthur/features/auth/models/params/sign_up_params.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/features/auth/usecases/complete_sign_up_usecase.dart';
import 'package:arthur/features/auth/usecases/send_password_reset_usecase.dart';
import 'package:arthur/features/auth/usecases/sign_in_with_google_usecase.dart';
import 'package:arthur/features/auth/usecases/sign_up_usecase.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_auth_service.dart';
import '../../../fakes/fake_consent_service.dart';

void main() {
  group('mapAuthFailure (B5)', () {
    final cases = <String, Type>{
      'invalid-credential': InvalidCredentialsFailure,
      'user-not-found': InvalidCredentialsFailure,
      'wrong-password': InvalidCredentialsFailure,
      'user-disabled': UserDisabledFailure,
      'email-already-in-use': EmailAlreadyInUseFailure,
      'invalid-email': InvalidEmailFailure,
      'weak-password': WeakPasswordFailure,
      'too-many-requests': TooManyRequestsFailure,
      'network-request-failed': ConnectivityFailure,
      'operation-not-allowed': AuthFailure,
      'popup-blocked': AuthFailure,
      'account-exists-with-different-credential': AuthFailure,
      'qualquer-outro': AuthFailure,
    };

    cases.forEach((code, type) {
      test('$code → $type', () {
        expect(mapAuthFailure(AuthServiceException(code: code)).runtimeType, type);
      });
    });

    test('mensagens da RN09 e de conexão', () {
      expect(
        mapAuthFailure(const AuthServiceException(code: 'invalid-credential')).getInterMsg(),
        'E-mail ou senha incorretos',
      );
      expect(
        mapAuthFailure(const AuthServiceException(code: 'network-request-failed')).getInterMsg(),
        'Sem conexão. Verifique sua internet e tente de novo',
      );
    });
  });

  group('SignUpUsecase', () {
    late FakeAuthService auth;
    late FakeConsentService consent;
    late SignUpUsecase usecase;

    setUp(() {
      auth = FakeAuthService();
      consent = FakeConsentService();
      usecase = SignUpUsecase(authService: auth, consentService: consent);
    });

    SignUpParams params({bool accepted = true}) => SignUpParams(
      name: '  Mariana Souza ',
      email: ' Mariana@Exemplo.com ',
      password: 'abcdefg1',
      acceptedLegalDocs: accepted,
    );

    test('cria a conta normalizada e grava o aceite', () async {
      final result = await usecase(params()).run();

      final user = result.getOrElse((f) => fail(f.message));
      expect(user.email, 'mariana@exemplo.com');
      expect(user.displayName, 'Mariana Souza');
      expect(consent.records[user.id], (name: 'Mariana Souza', email: 'mariana@exemplo.com'));
    });

    test('sem aceite não chama o Firebase', () async {
      final result = await usecase(params(accepted: false)).run();

      expect(result.isLeft(), isTrue);
      expect(auth.createCalls, 0);
    });

    test('e-mail já cadastrado vira EmailAlreadyInUseFailure', () async {
      auth.addAccount(email: 'mariana@exemplo.com', password: 'abcdefg1');

      final result = await usecase(params()).run();

      expect(result.getLeft().toNullable(), isA<EmailAlreadyInUseFailure>());
    });

    test('falha ao gravar o aceite não desfaz a conta', () async {
      consent.nextWriteErrorCode = 'unavailable';

      final result = await usecase(params()).run();

      expect(result.isRight(), isTrue);
      expect(consent.records, isEmpty);
    });
  });

  group('SendPasswordResetUsecase (RN10)', () {
    test('e-mail sem cadastro também é sucesso', () async {
      final auth = FakeAuthService();
      final result = await SendPasswordResetUsecase(authService: auth)('ninguem@exemplo.com').run();

      expect(result.isRight(), isTrue);
      expect(auth.resetEmailsSentTo, isEmpty);
    });

    test('envia para e-mail cadastrado, normalizado', () async {
      final auth = FakeAuthService()..addAccount(email: 'mariana@exemplo.com', password: 'x');
      final result = await SendPasswordResetUsecase(authService: auth)(' Mariana@Exemplo.com ').run();

      expect(result.isRight(), isTrue);
      expect(auth.resetEmailsSentTo, ['mariana@exemplo.com']);
    });

    test('muitas tentativas continua sendo erro', () async {
      final auth = FakeAuthService()..nextErrorCode = 'too-many-requests';
      final result = await SendPasswordResetUsecase(authService: auth)('a@b.co').run();

      expect(result.getLeft().toNullable(), isA<TooManyRequestsFailure>());
    });
  });

  group('SignInWithGoogleUsecase (RN20)', () {
    for (final code in ['popup-closed-by-user', 'web-context-canceled', 'canceled']) {
      test('$code é cancelamento, não erro', () async {
        final auth = FakeAuthService()..nextErrorCode = code;
        final result = await SignInWithGoogleUsecase(authService: auth)().run();

        expect(result.getOrElse((_) => fail('não deveria falhar')), isNull);
      });
    }

    test('pop-up bloqueado vira mensagem', () async {
      final auth = FakeAuthService()..nextErrorCode = 'popup-blocked';
      final result = await SignInWithGoogleUsecase(authService: auth)().run();

      expect(
        result.getLeft().toNullable()?.getInterMsg(),
        'Permita pop-ups deste site para entrar com o Google',
      );
    });
  });

  group('CompleteSignUpUsecase (RN17)', () {
    test('atualiza o nome e grava o aceite', () async {
      final auth = FakeAuthService();
      final consent = FakeConsentService();
      await auth.signInWithGoogle().run();

      final result = await CompleteSignUpUsecase(authService: auth, consentService: consent)(
        const CompleteSignUpParams(name: 'Mariana', acceptedLegalDocs: true),
      ).run();

      expect(result.isRight(), isTrue);
      expect(auth.currentUser?.displayName, 'Mariana');
      expect(consent.records['google-user']?.name, 'Mariana');
    });

    test('sem aceite não grava', () async {
      final auth = FakeAuthService();
      final consent = FakeConsentService();
      await auth.signInWithGoogle().run();

      final result = await CompleteSignUpUsecase(authService: auth, consentService: consent)(
        const CompleteSignUpParams(name: 'Mariana', acceptedLegalDocs: false),
      ).run();

      expect(result.isLeft(), isTrue);
      expect(consent.records, isEmpty);
    });
  });
}
