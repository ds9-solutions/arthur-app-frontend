class SignUpParams {
  final String name;
  final String email;
  final String password;
  final bool acceptedLegalDocs;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.acceptedLegalDocs,
  });
}
