import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/models/params/login_params.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class LoginUsecase {
  final AuthService _authService;

  LoginUsecase({AuthService? authService}) : _authService = authService ?? AuthService();

  TaskEither<Failure, AuthUserEntity> call(LoginParams params) {
    return _authService
        .signInWithEmailAndPassword(email: params.email, password: params.password)
        .mapLeft(_mapFailure);
  }

  Failure _mapFailure(AuthServiceException error) {
    switch (error.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const InvalidCredentialsFailure();
      default:
        return AuthFailure(error.message ?? 'Falha na autenticação');
    }
  }
}
