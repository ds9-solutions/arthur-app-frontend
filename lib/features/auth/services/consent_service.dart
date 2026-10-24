import 'package:arthur/features/auth/constants/auth_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

class ConsentServiceException implements Exception {
  final String code;
  final String? message;

  const ConsentServiceException({required this.code, this.message});

  @override
  String toString() => 'ConsentServiceException($code)';
}

/// Registro do aceite dos Termos de Uso e da Política de Privacidade (RN15),
/// em `users/{uid}` no Firestore (B3).
abstract interface class ConsentService {
  /// `true` quando `users/{uid}` existe, isto é, o aceite já foi gravado.
  TaskEither<ConsentServiceException, bool> hasConsent(String uid);

  TaskEither<ConsentServiceException, Unit> recordConsent({
    required String uid,
    required String name,
    required String email,
  });
}

/// Implementação real. Único arquivo do app que importa `cloud_firestore`.
class FirestoreConsentService implements ConsentService {
  final FirebaseFirestore _firestore;

  FirestoreConsentService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(AuthConstants.usersCollection);

  @override
  TaskEither<ConsentServiceException, bool> hasConsent(String uid) {
    return TaskEither.tryCatch(() async {
      final snapshot = await _users.doc(uid).get();
      return snapshot.exists;
    }, _mapException);
  }

  @override
  TaskEither<ConsentServiceException, Unit> recordConsent({
    required String uid,
    required String name,
    required String email,
  }) {
    return TaskEither.tryCatch(() async {
      // Os campos precisam bater com as regras em firestore.rules.
      await _users.doc(uid).set({
        'name': name,
        'email': email.toLowerCase(),
        'role': AuthConstants.guardianRole,
        'legal_docs_version': AuthConstants.legalDocsVersion,
        'consent_accepted_at': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
        'platform': currentPlatform,
      });
      return unit;
    }, _mapException);
  }

  /// `web`, `android` ou `ios`.
  @visibleForTesting
  static String get currentPlatform {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      final other => other.name.toLowerCase(),
    };
  }

  static ConsentServiceException _mapException(Object error, StackTrace stack) {
    if (error is FirebaseException) {
      return ConsentServiceException(code: error.code, message: error.message);
    }
    return ConsentServiceException(code: 'unknown', message: error.toString());
  }
}
