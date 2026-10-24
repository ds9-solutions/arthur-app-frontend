import 'dart:async';

import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/models/params/login_params.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/usecases/login_usecase.dart';
import 'package:arthur/features/auth/usecases/logout_usecase.dart';
import 'package:arthur/features/auth/usecases/watch_auth_state_usecase.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final StreamSubscription<AuthUserEntity?> _authStateSubscription;

  AuthStatus status = AuthStatus.unknown;
  AuthUserEntity? user;
  Failure? failure;
  bool isLoading = false;

  AuthProvider({
    AuthService? authService,
    LoginUsecase? loginUsecase,
    LogoutUsecase? logoutUsecase,
    WatchAuthStateUsecase? watchAuthStateUsecase,
  }) {
    // Todos os usecases compartilham a mesma instância de AuthService: com o
    // Firebase real isso é indiferente (FirebaseAuth.instance já é único),
    // mas o AuthService mock guarda estado em memória e precisa ser o mesmo
    // objeto para o login refletir no stream de authStateChanges.
    final service = authService ?? AuthService();
    _loginUsecase = loginUsecase ?? LoginUsecase(authService: service);
    _logoutUsecase = logoutUsecase ?? LogoutUsecase(authService: service);
    _authStateSubscription = (watchAuthStateUsecase ?? WatchAuthStateUsecase(authService: service))()
        .listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(AuthUserEntity? authUser) {
    user = authUser;
    status = authUser == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> login(LoginParams params) async {
    isLoading = true;
    failure = null;
    notifyListeners();

    final result = await _loginUsecase(params).run();
    result.match((f) => failure = f, (authUser) => user = authUser);

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _logoutUsecase().run();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}
