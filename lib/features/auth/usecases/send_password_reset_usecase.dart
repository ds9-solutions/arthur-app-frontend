import 'package:arthur/features/auth/constants/auth_constants.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/features/auth/validators/auth_validators.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Envia o e-mail de redefinição. `user-not-found` conta como sucesso, para
/// a mensagem ser a mesma com ou sem cadastro (RN10).
class SendPasswordResetUsecase {
  final AuthService _authService;

  SendPasswordResetUsecase({required AuthService authService}) : _authService = authService;

  TaskEither<Failure, Unit> call(String email) {
    return _authService
        .sendPasswordResetEmail(AuthValidators.normalizeEmail(email))
        .orElse(
          (error) => error.code == AuthErrorCodes.userNotFound
              ? TaskEither.right(unit)
              : TaskEither.left(mapAuthFailure(error)),
        );
  }
}
