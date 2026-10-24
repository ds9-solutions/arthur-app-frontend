import 'package:arthur/features/auth/constants/auth_constants.dart';

/// Validações dos formulários de autenticação (especificação B4).
/// Funções puras: recebem o texto do campo e devolvem a mensagem de erro,
/// ou `null` quando o valor é válido.
abstract final class AuthValidators {
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _letter = RegExp(r'[A-Za-zÀ-ÖØ-öø-ÿ]');
  static final RegExp _digit = RegExp(r'\d');

  /// RN03: e-mail sem espaços nas pontas e em minúsculas.
  static String normalizeEmail(String value) => value.trim().toLowerCase();

  static String? email(String? value) {
    final email = normalizeEmail(value ?? '');
    if (email.isEmpty) return 'Informe seu e-mail';
    if (!_email.hasMatch(email)) return 'E-mail inválido';
    return null;
  }

  /// RN06
  static String? name(String? value) {
    final name = (value ?? '').trim();
    if (name.isEmpty) return 'Informe seu nome';
    if (name.length < AuthConstants.nameMinLength || name.length > AuthConstants.nameMaxLength) {
      return 'Use de ${AuthConstants.nameMinLength} a ${AuthConstants.nameMaxLength} caracteres';
    }
    return null;
  }

  /// RN04: senha nova (criação de conta).
  static String? newPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Informe uma senha';
    if (password.length < AuthConstants.passwordMinLength) {
      return 'Use ao menos ${AuthConstants.passwordMinLength} caracteres';
    }
    if (!_letter.hasMatch(password) || !_digit.hasMatch(password)) {
      return 'Use letras e números';
    }
    return null;
  }

  /// RN05
  static String? confirmPassword(String? value, String password) {
    final confirmation = value ?? '';
    if (confirmation.isEmpty) return 'Confirme a senha';
    if (confirmation != password) return 'As senhas não conferem';
    return null;
  }

  /// Senha no login: só exige preenchimento (a regra vale para senhas novas).
  static String? loginPassword(String? value) =>
      (value == null || value.isEmpty) ? 'Informe sua senha' : null;
}
