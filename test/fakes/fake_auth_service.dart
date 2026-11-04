import 'dart:async';

import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:fpdart/fpdart.dart';

/// [AuthService] em memória para testes. Guarda contas por e-mail e permite
/// forçar erros com os mesmos códigos do Firebase.
class FakeAuthService implements AuthService {
  final _controller = StreamController<AuthUserEntity?>.broadcast();
  final Map<String, ({String password, AuthUserEntity user})> _accounts = {};
  AuthUserEntity? _currentUser;
  int _nextId = 1;

  /// Próximo erro de qualquer operação (consumido uma vez).
  String? nextErrorCode;

  /// Conta devolvida pelo próximo login com Google.
  AuthUserEntity googleAccount = const AuthUserEntity(
    id: 'google-user',
    email: 'responsavel@gmail.com',
    displayName: 'Responsável Google',
    emailVerified: true,
  );

  int createCalls = 0;
  int verificationEmailsSent = 0;
  final List<String> resetEmailsSentTo = [];

  /// Atraso das operações, para testar o carregamento.
  Duration delay = Duration.zero;

  FakeAuthService() {
    _controller.onListen = () => _controller.add(_currentUser);
  }

  void addAccount({required String email, required String password, String? name}) {
    final user = AuthUserEntity(id: 'user-${_nextId++}', email: email, displayName: name);
    _accounts[email] = (password: password, user: user);
  }

  @override
  Stream<AuthUserEntity?> get userChanges => _controller.stream;

  @override
  AuthUserEntity? get currentUser => _currentUser;

  TaskEither<AuthServiceException, T> _run<T>(T Function() action) {
    return TaskEither.tryCatch(() async {
      if (delay > Duration.zero) await Future<void>.delayed(delay);
      final code = nextErrorCode;
      if (code != null) {
        nextErrorCode = null;
        throw AuthServiceException(code: code);
      }
      return action();
    }, (error, _) => error is AuthServiceException ? error : AuthServiceException(code: '$error'));
  }

  void _setUser(AuthUserEntity? user) {
    _currentUser = user;
    _controller.add(user);
  }

  @override
  TaskEither<AuthServiceException, AuthUserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _run(() {
      final account = _accounts[email];
      if (account == null || account.password != password) {
        throw const AuthServiceException(code: 'invalid-credential');
      }
      _setUser(account.user);
      return account.user;
    });
  }

  @override
  TaskEither<AuthServiceException, AuthUserEntity> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return _run(() {
      createCalls++;
      if (_accounts.containsKey(email)) {
        throw const AuthServiceException(code: 'email-already-in-use');
      }
      final user = AuthUserEntity(id: 'user-${_nextId++}', email: email, displayName: name);
      _accounts[email] = (password: password, user: user);
      verificationEmailsSent++;
      _setUser(user);
      return user;
    });
  }

  @override
  TaskEither<AuthServiceException, AuthUserEntity> signInWithGoogle() {
    return _run(() {
      _setUser(googleAccount);
      return googleAccount;
    });
  }

  @override
  TaskEither<AuthServiceException, Unit> sendPasswordResetEmail(String email) {
    return _run(() {
      if (!_accounts.containsKey(email)) {
        throw const AuthServiceException(code: 'user-not-found');
      }
      resetEmailsSentTo.add(email);
      return unit;
    });
  }

  @override
  TaskEither<AuthServiceException, Unit> sendEmailVerification() {
    return _run(() {
      verificationEmailsSent++;
      return unit;
    });
  }

  @override
  TaskEither<AuthServiceException, Unit> updateDisplayName(String name) {
    return _run(() {
      final user = _currentUser!;
      _setUser(
        AuthUserEntity(
          id: user.id,
          email: user.email,
          displayName: name,
          emailVerified: user.emailVerified,
        ),
      );
      return unit;
    });
  }

  @override
  TaskEither<AuthServiceException, Unit> reloadUser() => _run(() => unit);

  @override
  TaskEither<AuthServiceException, Unit> signOut() {
    return _run(() {
      _setUser(null);
      return unit;
    });
  }
}
