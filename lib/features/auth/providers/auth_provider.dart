import 'dart:async';

import 'package:arthur/features/auth/constants/auth_constants.dart';
import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/models/params/complete_sign_up_params.dart';
import 'package:arthur/features/auth/models/params/login_params.dart';
import 'package:arthur/features/auth/models/params/sign_up_params.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/services/consent_service.dart';
import 'package:arthur/features/auth/services/firebase_auth_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/features/auth/usecases/check_consent_usecase.dart';
import 'package:arthur/features/auth/usecases/complete_sign_up_usecase.dart';
import 'package:arthur/features/auth/usecases/login_usecase.dart';
import 'package:arthur/features/auth/usecases/logout_usecase.dart';
import 'package:arthur/features/auth/usecases/send_email_verification_usecase.dart';
import 'package:arthur/features/auth/usecases/send_password_reset_usecase.dart';
import 'package:arthur/features/auth/usecases/sign_in_with_google_usecase.dart';
import 'package:arthur/features/auth/usecases/sign_up_usecase.dart';
import 'package:arthur/features/auth/usecases/watch_auth_state_usecase.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus {
  /// Ainda lendo a sessão ou o aceite.
  unknown,
  unauthenticated,

  /// Autenticado, mas sem `users/{uid}`: mostra Concluir cadastro (RN17).
  needsConsent,

  /// Autenticado, mas não deu para ler o aceite (ex.: sem internet).
  consentCheckFailed,
  authenticated,
}

class AuthProvider extends ChangeNotifier {
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final SignUpUsecase _signUpUsecase;
  late final SignInWithGoogleUsecase _signInWithGoogleUsecase;
  late final CompleteSignUpUsecase _completeSignUpUsecase;
  late final CheckConsentUsecase _checkConsentUsecase;
  late final SendPasswordResetUsecase _sendPasswordResetUsecase;
  late final SendEmailVerificationUsecase _sendEmailVerificationUsecase;
  late final AuthService _authService;
  late final StreamSubscription<AuthUserEntity?> _userSubscription;

  AuthStatus status = AuthStatus.unknown;
  AuthUserEntity? user;
  Failure? failure;

  /// Envio de e-mail e senha (Entrar, Criar conta, Continuar).
  bool isLoading = false;

  /// Login com Google em andamento.
  bool isGoogleLoading = false;

  /// Enquanto uma criação de conta grava o aceite, as emissões do stream não
  /// disparam a checagem do aceite (evita mostrar Concluir cadastro à toa).
  bool _writingConsent = false;

  /// `uid` cujo aceite já foi confirmado nesta sessão.
  String? _consentConfirmedFor;

  /// Usa o Firebase por padrão; os testes passam fakes.
  AuthProvider({AuthService? authService, ConsentService? consentService}) {
    final auth = authService ?? FirebaseAuthService();
    final consent =
        consentService ??
        (AuthConstants.consentEnabled
            ? FirestoreConsentService()
            : const DisabledConsentService());
    _authService = auth;
    _loginUsecase = LoginUsecase(authService: auth);
    _logoutUsecase = LogoutUsecase(authService: auth);
    _signUpUsecase = SignUpUsecase(authService: auth, consentService: consent);
    _signInWithGoogleUsecase = SignInWithGoogleUsecase(authService: auth);
    _completeSignUpUsecase = CompleteSignUpUsecase(authService: auth, consentService: consent);
    _checkConsentUsecase = CheckConsentUsecase(consentService: consent);
    _sendPasswordResetUsecase = SendPasswordResetUsecase(authService: auth);
    _sendEmailVerificationUsecase = SendEmailVerificationUsecase(authService: auth);
    _userSubscription = WatchAuthStateUsecase(authService: auth)().listen(_onUserChanged);
  }

  bool get isBusy => isLoading || isGoogleLoading;

  void _onUserChanged(AuthUserEntity? authUser) {
    user = authUser;
    if (_writingConsent) {
      notifyListeners();
      return;
    }
    _resolveStatus();
  }

  Future<void> _resolveStatus() async {
    final current = user;
    if (current == null) {
      _consentConfirmedFor = null;
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    if (_consentConfirmedFor == current.id) {
      status = AuthStatus.authenticated;
      notifyListeners();
      return;
    }

    final result = await _checkConsentUsecase(current.id).run();
    if (user?.id != current.id || _writingConsent) return; // mudou no meio

    result.match((_) => status = AuthStatus.consentCheckFailed, (hasConsent) {
      if (hasConsent) {
        _consentConfirmedFor = current.id;
        status = AuthStatus.authenticated;
      } else {
        status = AuthStatus.needsConsent;
      }
    });
    notifyListeners();
  }

  void clearFailure() {
    if (failure == null) return;
    failure = null;
    notifyListeners();
  }

  Future<void> login(LoginParams params) async {
    if (isBusy) return; // RN13
    _start();
    final result = await _loginUsecase(params).run();
    result.match((f) => failure = f, (authUser) => user = authUser);
    _finish();
  }

  /// `true` quando a conta foi criada.
  Future<bool> signUp(SignUpParams params) async {
    if (isBusy) return false; // RN13
    _start();
    _writingConsent = true;
    final result = await _signUpUsecase(params).run();
    _writingConsent = false;
    final created = result.match((f) {
      failure = f;
      return false;
    }, (authUser) {
      user = authUser;
      return true;
    });
    _finish();
    if (created) await _resolveStatus();
    return created;
  }

  /// `true` quando entrou; `false` em erro ou se a janela foi fechada.
  Future<bool> signInWithGoogle() async {
    if (isBusy) return false;
    failure = null;
    isGoogleLoading = true;
    notifyListeners();
    final result = await _signInWithGoogleUsecase().run();
    final signedIn = result.match((f) {
      failure = f;
      return false;
    }, (authUser) => authUser != null);
    isGoogleLoading = false;
    notifyListeners();
    return signedIn;
  }

  /// Grava o aceite do primeiro acesso com Google. `true` em sucesso.
  Future<bool> completeSignUp(CompleteSignUpParams params) async {
    if (isBusy) return false;
    _start();
    _writingConsent = true;
    final result = await _completeSignUpUsecase(params).run();
    _writingConsent = false;
    final done = result.match((f) {
      failure = f;
      return false;
    }, (_) => true);
    if (done) {
      _consentConfirmedFor = user?.id;
      status = AuthStatus.authenticated;
    }
    _finish();
    return done;
  }

  Future<void> retryConsentCheck() async {
    status = AuthStatus.unknown;
    notifyListeners();
    await _resolveStatus();
  }

  /// `null` em sucesso. Não usa o [failure] compartilhado: o erro aparece
  /// no próprio diálogo de recuperação.
  Future<Failure?> sendPasswordReset(String email) async {
    final result = await _sendPasswordResetUsecase(email).run();
    return result.match((f) => f, (_) => null);
  }

  /// `null` em sucesso.
  Future<Failure?> resendVerification() async {
    final result = await _sendEmailVerificationUsecase().run();
    return result.match((f) => f, (_) => null);
  }

  /// Busca o `emailVerified` atualizado depois que o link foi aberto.
  Future<Failure?> refreshUser() async {
    final result = await _authService.reloadUser().mapLeft(mapAuthFailure).run();
    return result.match((f) => f, (_) => null);
  }

  Future<void> logout() async {
    failure = null;
    await _logoutUsecase().run();
  }

  void _start() {
    isLoading = true;
    failure = null;
    notifyListeners();
  }

  void _finish() {
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
