import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/services/auth_service.dart';

class WatchAuthStateUsecase {
  final AuthService _authService;

  WatchAuthStateUsecase({required AuthService authService}) : _authService = authService;

  /// `userChanges` (e não `authStateChanges`) para refletir nome e
  /// verificação de e-mail sem novo login.
  Stream<AuthUserEntity?> call() => _authService.userChanges;
}
