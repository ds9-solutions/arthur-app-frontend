import 'package:arthur/features/auth/validators/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('email (RN03)', () {
    test('normaliza espaços e maiúsculas', () {
      expect(AuthValidators.normalizeEmail('  Maria@Exemplo.COM '), 'maria@exemplo.com');
    });

    test('aceita e-mail válido com espaços nas pontas', () {
      expect(AuthValidators.email(' maria@exemplo.com '), isNull);
    });

    test('recusa vazio e formatos inválidos', () {
      expect(AuthValidators.email(''), 'Informe seu e-mail');
      expect(AuthValidators.email(null), 'Informe seu e-mail');
      expect(AuthValidators.email('maria'), 'E-mail inválido');
      expect(AuthValidators.email('maria@exemplo'), 'E-mail inválido');
      expect(AuthValidators.email('ma ria@exemplo.com'), 'E-mail inválido');
    });
  });

  group('nome (RN06)', () {
    test('aceita de 2 a 60 caracteres sem contar as pontas', () {
      expect(AuthValidators.name('  Al '), isNull);
      expect(AuthValidators.name('a' * 60), isNull);
    });

    test('recusa vazio, 1 caractere e mais de 60', () {
      expect(AuthValidators.name('   '), 'Informe seu nome');
      expect(AuthValidators.name('A'), 'Use de 2 a 60 caracteres');
      expect(AuthValidators.name('a' * 61), 'Use de 2 a 60 caracteres');
    });
  });

  group('senha nova (RN04)', () {
    test('aceita 8 caracteres com letra e número', () {
      expect(AuthValidators.newPassword('abcdefg1'), isNull);
      expect(AuthValidators.newPassword('çãoéabc1'), isNull);
    });

    test('recusa 7 caracteres', () {
      expect(AuthValidators.newPassword('abcdef1'), 'Use ao menos 8 caracteres');
    });

    test('recusa sem número ou sem letra', () {
      expect(AuthValidators.newPassword('abcdefgh'), 'Use letras e números');
      expect(AuthValidators.newPassword('12345678'), 'Use letras e números');
    });

    test('recusa vazia', () {
      expect(AuthValidators.newPassword(''), 'Informe uma senha');
    });
  });

  group('confirmar senha (RN05)', () {
    test('aceita igual e recusa diferente', () {
      expect(AuthValidators.confirmPassword('abcdefg1', 'abcdefg1'), isNull);
      expect(AuthValidators.confirmPassword('abcdefg2', 'abcdefg1'), 'As senhas não conferem');
      expect(AuthValidators.confirmPassword('', 'abcdefg1'), 'Confirme a senha');
    });
  });

  test('senha do login só exige preenchimento', () {
    expect(AuthValidators.loginPassword('1'), isNull);
    expect(AuthValidators.loginPassword(''), 'Informe sua senha');
  });
}
