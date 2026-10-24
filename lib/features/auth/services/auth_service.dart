import 'package:arthur/features/auth/models/entities/auth_user_entity.dart';
import 'package:fpdart/fpdart.dart';

/// Erro genérico de autenticação. Espelha os `code`/`message` que o
/// `FirebaseAuthException` expõe, para os usecases não dependerem do Firebase.
class AuthServiceException implements Exception {
  final String code;
  final String? message;

  const AuthServiceException({required this.code, this.message});

  @override
  String toString() => 'AuthServiceException($code)';
}

/// Contrato da autenticação. A implementação real é o `FirebaseAuthService`;
/// os testes usam um fake em `test/fakes/`.
abstract interface class AuthService {
  /// Emite o usuário atual ao escutar e a cada login, logout ou mudança de
  /// perfil (nome, verificação de e-mail).
  Stream<AuthUserEntity?> get userChanges;

  AuthUserEntity? get currentUser;

  TaskEither<AuthServiceException, AuthUserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Cria a conta, grava o nome e dispara o e-mail de verificação sem esperar.
  TaskEither<AuthServiceException, AuthUserEntity> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  /// Web: pop-up; Android/iOS: fluxo do provedor do próprio Firebase.
  TaskEither<AuthServiceException, AuthUserEntity> signInWithGoogle();

  TaskEither<AuthServiceException, Unit> sendPasswordResetEmail(String email);

  TaskEither<AuthServiceException, Unit> sendEmailVerification();

  TaskEither<AuthServiceException, Unit> updateDisplayName(String name);

  /// Recarrega o usuário do servidor (ex.: depois de confirmar o e-mail).
  TaskEither<AuthServiceException, Unit> reloadUser();

  TaskEither<AuthServiceException, Unit> signOut();
}
