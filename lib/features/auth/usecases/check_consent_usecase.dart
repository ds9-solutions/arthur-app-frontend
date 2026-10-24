import 'package:arthur/features/auth/services/consent_service.dart';
import 'package:arthur/features/auth/usecases/auth_failure_mapper.dart';
import 'package:arthur/shared/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// `true` quando o responsável já aceitou os Termos e a Política.
class CheckConsentUsecase {
  final ConsentService _consentService;

  CheckConsentUsecase({required ConsentService consentService})
    : _consentService = consentService;

  TaskEither<Failure, bool> call(String uid) {
    return _consentService.hasConsent(uid).mapLeft(mapConsentFailure);
  }
}
