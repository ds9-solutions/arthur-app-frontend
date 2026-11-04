import 'package:arthur/features/auth/services/consent_service.dart';
import 'package:fpdart/fpdart.dart';

/// [ConsentService] em memória: guarda o aceite por `uid`.
class FakeConsentService implements ConsentService {
  final Map<String, ({String name, String email})> records = {};

  /// Força erro na próxima leitura / gravação (consumido uma vez).
  String? nextReadErrorCode;
  String? nextWriteErrorCode;

  @override
  TaskEither<ConsentServiceException, bool> hasConsent(String uid) {
    return TaskEither.tryCatch(() async {
      final code = nextReadErrorCode;
      if (code != null) {
        nextReadErrorCode = null;
        throw ConsentServiceException(code: code);
      }
      return records.containsKey(uid);
    }, (error, _) => error as ConsentServiceException);
  }

  @override
  TaskEither<ConsentServiceException, Unit> recordConsent({
    required String uid,
    required String name,
    required String email,
  }) {
    return TaskEither.tryCatch(() async {
      final code = nextWriteErrorCode;
      if (code != null) {
        nextWriteErrorCode = null;
        throw ConsentServiceException(code: code);
      }
      records[uid] = (name: name, email: email);
      return unit;
    }, (error, _) => error as ConsentServiceException);
  }
}
