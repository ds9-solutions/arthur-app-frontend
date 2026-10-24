import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/services/auth_service.dart';

class WatchAuthStateUsecase {
  final AuthService _authService;

  WatchAuthStateUsecase({AuthService? authService}) : _authService = authService ?? AuthService();

  Stream<AuthUserEntity?> call() => _authService.authStateChanges;
}
