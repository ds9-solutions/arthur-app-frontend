class AuthUserEntity {
  final String id;
  final String? email;
  final String? displayName;

  const AuthUserEntity({required this.id, this.email, this.displayName});

  // Descomente ao reativar o Firebase Auth em services/auth_service.dart:
  // factory AuthUserEntity.fromFirebaseUser(firebase_auth.User user) {
  //   return AuthUserEntity(id: user.uid, email: user.email, displayName: user.displayName);
  // }
}
