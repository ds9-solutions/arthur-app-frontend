import 'package:arthur/features/auth/services/consent_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = DisabledConsentService();

  test('considera todo usuário com aceite', () async {
    final result = await service.hasConsent('qualquer-uid').run();

    expect(result.getOrElse((_) => false), isTrue);
  });

  test('gravar o aceite não faz nada e não falha', () async {
    final result = await service.recordConsent(uid: 'u', name: 'N', email: 'e@x.co').run();

    expect(result.isRight(), isTrue);
  });
}
