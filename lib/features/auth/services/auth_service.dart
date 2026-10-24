import 'dart:async';

import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:fpdart/fpdart.dart';

/// Erro genérico de autenticação. Espelha os `code`/`message` que o
/// [FirebaseAuthException] real expõe, para os usecases não mudarem quando
/// o Firebase for reativado.
class AuthServiceException implements Exception {
  final String code;
  final String? message;

  const AuthServiceException({required this.code, this.message});
}

// ============================================================================
// BYPASS TEMPORÁRIO — sem credenciais do Firebase configuradas ainda.
// Implementação em memória só para validar layout e a integração entre
// views -> provider -> usecases -> service. Substitua pelo bloco comentado
// mais abaixo assim que o Firebase estiver configurado.
// ============================================================================
class AuthService {
  final _authStateController = StreamController<AuthUserEntity?>.broadcast();
  AuthUserEntity? _currentUser;

  AuthService() {
    // authStateChanges emite o estado atual assim que alguém escuta.
    _authStateController.onListen = () => _authStateController.add(_currentUser);
  }

  Stream<AuthUserEntity?> get authStateChanges => _authStateController.stream;

  AuthUserEntity? get currentUser => _currentUser;

  TaskEither<AuthServiceException, AuthUserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      final user = AuthUserEntity(
        id: 'mock-user-id',
        email: email,
        displayName: email.split('@').first,
      );
      _currentUser = user;
      _authStateController.add(_currentUser);
      return user;
    }, (error, stack) => AuthServiceException(code: 'unknown', message: error.toString()));
  }

  TaskEither<AuthServiceException, Unit> signOut() {
    return TaskEither.tryCatch(() async {
      _currentUser = null;
      _authStateController.add(null);
      return unit;
    }, (error, stack) => AuthServiceException(code: 'unknown', message: error.toString()));
  }
}

// ============================================================================
// IMPLEMENTAÇÃO REAL COM FIREBASE AUTH
// Descomente este bloco, apague a classe AuthService acima e adicione o
// import de firebase_auth quando as credenciais do projeto Firebase
// estiverem configuradas (flutterfire configure).
// ============================================================================
//
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   final FirebaseAuth _firebaseAuth;
//
//   AuthService({FirebaseAuth? firebaseAuth})
//     : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
//
//   Stream<AuthUserEntity?> get authStateChanges => _firebaseAuth
//       .authStateChanges()
//       .map((user) => user == null ? null : AuthUserEntity.fromFirebaseUser(user));
//
//   AuthUserEntity? get currentUser {
//     final user = _firebaseAuth.currentUser;
//     return user == null ? null : AuthUserEntity.fromFirebaseUser(user);
//   }
//
//   TaskEither<AuthServiceException, AuthUserEntity> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) {
//     return TaskEither.tryCatch(() async {
//       final credential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return AuthUserEntity.fromFirebaseUser(credential.user!);
//     }, _mapException);
//   }
//
//   TaskEither<AuthServiceException, Unit> signOut() {
//     return TaskEither.tryCatch(() async {
//       await _firebaseAuth.signOut();
//       return unit;
//     }, _mapException);
//   }
//
//   AuthServiceException _mapException(Object error, StackTrace stack) {
//     if (error is FirebaseAuthException) {
//       return AuthServiceException(code: error.code, message: error.message);
//     }
//     return AuthServiceException(code: 'unknown', message: error.toString());
//   }
// }
