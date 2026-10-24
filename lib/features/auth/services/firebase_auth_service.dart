import 'package:arthur/features/auth/constants/auth_constants.dart';
import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fpdart/fpdart.dart';

/// Implementação real do [AuthService]. Único arquivo do app que importa
/// `firebase_auth`.
class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    // E-mails de verificação e de redefinição em português.
    _firebaseAuth.setLanguageCode(AuthConstants.emailLanguageCode).ignore();
  }

  @override
  Stream<AuthUserEntity?> get userChanges =>
      _firebaseAuth.userChanges().map((user) => user == null ? null : _toEntity(user));

  @override
  AuthUserEntity? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : _toEntity(user);
  }

  @override
  TaskEither<AuthServiceException, AuthUserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(() async {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toEntity(credential.user!);
    }, _mapException);
  }

  @override
  TaskEither<AuthServiceException, AuthUserEntity> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(() async {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(name);
      // Não bloqueia: falha no envio não desfaz a conta (B1).
      user.sendEmailVerification().ignore();
      await user.reload(); // faz userChanges() emitir com o displayName
      return _toEntity(_firebaseAuth.currentUser ?? user);
    }, _mapException);
  }

  @override
  TaskEither<AuthServiceException, AuthUserEntity> signInWithGoogle() {
    return TaskEither.tryCatch(() async {
      final provider = GoogleAuthProvider();
      final credential = kIsWeb
          ? await _firebaseAuth.signInWithPopup(provider)
          : await _firebaseAuth.signInWithProvider(provider);
      return _toEntity(credential.user!);
    }, _mapException);
  }

  @override
  TaskEither<AuthServiceException, Unit> sendPasswordResetEmail(String email) {
    return TaskEither.tryCatch(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return unit;
    }, _mapException);
  }

  @override
  TaskEither<AuthServiceException, Unit> sendEmailVerification() {
    return TaskEither.tryCatch(() async {
      await _requireUser().sendEmailVerification();
      return unit;
    }, _mapException);
  }

  @override
  TaskEither<AuthServiceException, Unit> updateDisplayName(String name) {
    return TaskEither.tryCatch(() async {
      final user = _requireUser();
      await user.updateDisplayName(name);
      await user.reload();
      return unit;
    }, _mapException);
  }

  @override
  TaskEither<AuthServiceException, Unit> reloadUser() {
    return TaskEither.tryCatch(() async {
      await _requireUser().reload();
      return unit;
    }, _mapException);
  }

  @override
  TaskEither<AuthServiceException, Unit> signOut() {
    return TaskEither.tryCatch(() async {
      await _firebaseAuth.signOut();
      return unit;
    }, _mapException);
  }

  User _requireUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthServiceException(code: 'no-current-user');
    }
    return user;
  }

  static AuthUserEntity _toEntity(User user) {
    return AuthUserEntity(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
    );
  }

  static AuthServiceException _mapException(Object error, StackTrace stack) {
    if (error is AuthServiceException) return error;
    if (error is FirebaseAuthException) {
      return AuthServiceException(code: error.code, message: error.message);
    }
    return AuthServiceException(code: 'unknown', message: error.toString());
  }
}
