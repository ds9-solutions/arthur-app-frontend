import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUsecase {
  final AuthService _authService;

  LogoutUsecase({AuthService? authService}) : _authService = authService ?? AuthService();

  TaskEither<Failure, Unit> call() {
    return _authService.signOut().mapLeft(
      (error) => AuthFailure(error.message ?? 'Falha ao sair'),
    );
  }
}
