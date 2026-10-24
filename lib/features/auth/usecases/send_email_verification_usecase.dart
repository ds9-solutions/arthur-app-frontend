import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Reenvia o e-mail de verificação (ação 7 do catálogo).
class SendEmailVerificationUsecase {
  final AuthService _authService;

  SendEmailVerificationUsecase({required AuthService authService})
    : _authService = authService;

  TaskEither<Failure, Unit> call() {
    return _authService.sendEmailVerification().mapLeft(mapAuthFailure);
  }
}
