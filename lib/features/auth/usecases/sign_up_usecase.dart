import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/models/params/sign_up_params.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/services/consent_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/features/auth/validators/auth_validators.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Cria a conta com e-mail e senha e grava o aceite (RN15).
///
/// Se a gravação do aceite falhar, a conta continua criada: o `AuthGate`
/// encontra `users/{uid}` ausente e mostra de novo a caixa de aceite (C2).
class SignUpUsecase {
  final AuthService _authService;
  final ConsentService _consentService;

  SignUpUsecase({required AuthService authService, required ConsentService consentService})
    : _authService = authService,
      _consentService = consentService;

  TaskEither<Failure, AuthUserEntity> call(SignUpParams params) {
    if (!params.acceptedLegalDocs) {
      return TaskEither.left(
        const ValidateFailure('Aceite os Termos de Uso e a Política de Privacidade'),
      );
    }
    final name = params.name.trim();
    final email = AuthValidators.normalizeEmail(params.email);

    return _authService
        .createUserWithEmailAndPassword(name: name, email: email, password: params.password)
        .mapLeft(mapAuthFailure)
        .flatMap(
          (user) => _consentService
              .recordConsent(uid: user.id, name: name, email: email)
              .map((_) => user)
              .orElse<Failure>((_) => TaskEither.right(user)),
        );
  }
}
