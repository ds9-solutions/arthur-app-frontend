import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/models/params/login_params.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/features/auth/validators/auth_validators.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class LoginUsecase {
  final AuthService _authService;

  LoginUsecase({required AuthService authService}) : _authService = authService;

  TaskEither<Failure, AuthUserEntity> call(LoginParams params) {
    return _authService
        .signInWithEmailAndPassword(
          email: AuthValidators.normalizeEmail(params.email),
          password: params.password,
        )
        .mapLeft(mapAuthFailure);
  }
}
