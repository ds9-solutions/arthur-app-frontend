import 'package:arthur/features/auth/constants/auth_constants.dart';
import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Entra (ou cria a conta) com Google. Devolve `Right(null)` quando o
/// responsável fecha a janela do Google: não é erro (RN20).
class SignInWithGoogleUsecase {
  final AuthService _authService;

  SignInWithGoogleUsecase({required AuthService authService}) : _authService = authService;

  TaskEither<Failure, AuthUserEntity?> call() {
    return _authService
        .signInWithGoogle()
        .map<AuthUserEntity?>((user) => user)
        .orElse(
          (error) => AuthErrorCodes.googleCancelled.contains(error.code)
              ? TaskEither.right(null)
              : TaskEither.left(mapAuthFailure(error)),
        );
  }
}
