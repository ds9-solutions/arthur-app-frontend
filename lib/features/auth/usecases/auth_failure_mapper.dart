import 'package:arthur/features/auth/constants/auth_constants.dart';
import 'package:arthur/features/auth/services/auth_service.dart';
import 'package:arthur/features/auth/services/consent_service.dart';
import 'package:arthur/shared/errors/failures.dart';

/// Converte erros do Firebase Auth nas falhas exibidas na UI
/// (tabela "Mapa de erros" da especificação B5).
Failure mapAuthFailure(AuthServiceException error) {
  switch (error.code) {
    case AuthErrorCodes.invalidCredential:
    case AuthErrorCodes.userNotFound:
    case AuthErrorCodes.wrongPassword:
      return const InvalidCredentialsFailure('E-mail ou senha incorretos');
    case AuthErrorCodes.userDisabled:
      return const UserDisabledFailure();
    case AuthErrorCodes.emailAlreadyInUse:
      return const EmailAlreadyInUseFailure();
    case AuthErrorCodes.invalidEmail:
      return const InvalidEmailFailure();
    case AuthErrorCodes.weakPassword:
      return const WeakPasswordFailure();
    case AuthErrorCodes.tooManyRequests:
      return const TooManyRequestsFailure();
    case AuthErrorCodes.networkRequestFailed:
      return const ConnectivityFailure(connectivityMessage);
    case AuthErrorCodes.popupBlocked:
      return const AuthFailure('Permita pop-ups deste site para entrar com o Google');
    case AuthErrorCodes.accountExistsWithDifferentCredential:
      return const AuthFailure('Este e-mail já tem conta. Entre com e-mail e senha');
    default:
      return const AuthFailure(genericMessage);
  }
}

/// Erros do Firestore ao ler ou gravar o aceite.
Failure mapConsentFailure(ConsentServiceException error) {
  if (error.code == 'unavailable') return const ConnectivityFailure(connectivityMessage);
  return const LoadDataFailure('Não foi possível carregar sua conta. Tente de novo');
}

const String connectivityMessage = 'Sem conexão. Verifique sua internet e tente de novo';
const String genericMessage = 'Não foi possível concluir. Tente de novo';
