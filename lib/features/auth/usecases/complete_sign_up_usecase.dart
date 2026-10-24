import 'package:arthur/features/auth/models/params/complete_sign_up_params.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/services/consent_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Tela Concluir cadastro: atualiza o nome, se mudou, e grava o aceite (RN17).
class CompleteSignUpUsecase {
  final AuthService _authService;
  final ConsentService _consentService;

  CompleteSignUpUsecase({required AuthService authService, required ConsentService consentService})
    : _authService = authService,
      _consentService = consentService;

  TaskEither<Failure, Unit> call(CompleteSignUpParams params) {
    final user = _authService.currentUser;
    if (user == null) return TaskEither.left(const AuthFailure(genericMessage));
    if (!params.acceptedLegalDocs) {
      return TaskEither.left(
        const ValidateFailure('Aceite os Termos de Uso e a Política de Privacidade'),
      );
    }
    final name = params.name.trim();

    final updateName = name == user.displayName
        ? TaskEither<Failure, Unit>.right(unit)
        : _authService.updateDisplayName(name).mapLeft(mapAuthFailure);

    return updateName.flatMap(
      (_) => _consentService
          .recordConsent(uid: user.id, name: name, email: user.email ?? '')
          .mapLeft(mapConsentFailure),
    );
  }
}
