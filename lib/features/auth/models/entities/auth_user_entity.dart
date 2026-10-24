class AuthUserEntity {
  final String id;
  final String? email;
  final String? displayName;

  /// Controla a faixa "Confirme seu e-mail" na Home (RN11, RN19).
  final bool emailVerified;

  const AuthUserEntity({
    required this.id,
    this.email,
    this.displayName,
    this.emailVerified = false,
  });
}
