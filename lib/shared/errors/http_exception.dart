import 'package:http/http.dart' as http;

/// Deve ser usada apenas dentro da camada de services.
sealed class GeneralException implements Exception {
  final int statusCode;
  final StackTrace stack;
  final Object error;

  GeneralException({required this.statusCode, required this.stack, required this.error});
}

class HttpException extends GeneralException {
  /// Presente quando o servidor retornou um corpo (ex.: 4xx/5xx vindo do [HttpServices]).
  final http.Response? httpResponse;

  HttpException({
    required super.statusCode,
    required super.stack,
    required super.error,
    this.httpResponse,
  });
}

class StorageException extends GeneralException {
  StorageException({required super.statusCode, required super.stack, required super.error});
}

class PlatformException extends GeneralException {
  PlatformException({
    required super.stack,
    required super.error,
    super.statusCode = 500,
  });
}

class ConnectivityException extends GeneralException {
  ConnectivityException({
    required super.stack,
    required super.error,
    super.statusCode = 500,
  });
}
