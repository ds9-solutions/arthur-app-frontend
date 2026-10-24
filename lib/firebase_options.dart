// ARQUIVO PROVISÓRIO — será substituído pelo `flutterfire configure`.
//
// Mantém o projeto compilando enquanto o Firebase não está configurado.
// Rode na raiz do projeto:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --platforms=android,ios,web
//
// O comando gera este arquivo com as chaves reais de cada plataforma.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase ainda não configurado: rode `flutterfire configure` para gerar '
      'lib/firebase_options.dart.',
    );
  }
}
