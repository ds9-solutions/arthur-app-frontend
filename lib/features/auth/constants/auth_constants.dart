/// Regras e valores únicos da feature de autenticação (especificação B2).
class AuthConstants {
  const AuthConstants._();

  static const int passwordMinLength = 8; // RN04
  static const int nameMinLength = 2; // RN06
  static const int nameMaxLength = 60; // RN06

  /// Versão dos Termos de Uso e da Política de Privacidade aceitos (RN15).
  /// Muda a cada nova versão publicada dos documentos.
  static const String legalDocsVersion = '2026-10';

  /// Idioma dos e-mails enviados pelo Firebase (verificação e redefinição).
  static const String emailLanguageCode = 'pt';

  /// Coleção do Firestore com o registro do aceite (B3).
  static const String usersCollection = 'users';

  /// Papel do dono da conta nesta fase.
  static const String guardianRole = 'guardian';
}

/// Códigos de `FirebaseAuthException` tratados pelo app.
abstract final class AuthErrorCodes {
  static const invalidCredential = 'invalid-credential';
  static const userNotFound = 'user-not-found';
  static const wrongPassword = 'wrong-password';
  static const userDisabled = 'user-disabled';
  static const emailAlreadyInUse = 'email-already-in-use';
  static const invalidEmail = 'invalid-email';
  static const weakPassword = 'weak-password';
  static const operationNotAllowed = 'operation-not-allowed';
  static const tooManyRequests = 'too-many-requests';
  static const networkRequestFailed = 'network-request-failed';

  // Login com Google
  static const popupClosedByUser = 'popup-closed-by-user';
  static const cancelledPopupRequest = 'cancelled-popup-request';
  static const webContextCanceled = 'web-context-canceled';
  static const webContextCancelled = 'web-context-cancelled';
  static const canceled = 'canceled';
  static const popupBlocked = 'popup-blocked';
  static const accountExistsWithDifferentCredential = 'account-exists-with-different-credential';

  /// Códigos que significam "o usuário fechou a janela do Google" (RN20).
  static const Set<String> googleCancelled = {
    popupClosedByUser,
    cancelledPopupRequest,
    webContextCanceled,
    webContextCancelled,
    canceled,
  };
}
