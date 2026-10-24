import 'dart:convert';

import 'package:arthur/shared/enums/enums.dart';
import 'package:arthur/shared/errors/http_exception.dart';
import 'package:arthur/shared/errors/operation_exception.dart';
import 'package:arthur/shared/logs/log.dart' as app_log;
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

// Descomente ao reativar o Firebase Auth (ver features/auth/services/auth_service.dart):
// import 'package:firebase_auth/firebase_auth.dart';

/// Conexão com a API: GET, POST, PUT e DELETE, encapsulados em [TaskEither]
/// para composição funcional (fpdart) e mapeamento de erros em [HttpException].
class HttpServices {
  final http.Client client;

  HttpServices({http.Client? client}) : client = client ?? http.Client();

  /// Host da API. Sobrescreva em build/run com --dart-define=API_HOST=...
  static const String _host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'https://api.example.com',
  );

  bool _isOkStatus(int statusCode) => statusCode >= 200 && statusCode < 300;

  Future<Map<String, String>> _getHeaders({bool noAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    // Bypass temporário: sem Firebase configurado, as chamadas saem sem
    // token de autenticação. Descomente ao reativar o Firebase Auth.
    // if (!noAuth) {
    //   final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    //   if (token != null) headers['Authorization'] = 'Bearer $token';
    // }
    return headers;
  }

  Uri _buildUri(String path, Map<String, dynamic>? query) {
    return Uri.parse(_host).replace(
      path: path,
      queryParameters: query?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  String _encodeBody(Object? body) => body == null ? '{}' : jsonEncode(body);

  TaskEither<HttpException, http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    bool noAuth = false,
  }) {
    return TaskEither.tryCatch(() async {
      final uri = _buildUri(path, query);
      final headers = await _getHeaders(noAuth: noAuth);
      final response = await client.get(uri, headers: headers);
      if (!_isOkStatus(response.statusCode)) {
        throw OperationException.http(
          statusCode: response.statusCode,
          bodySent: {},
          endpoint: uri,
          headers: headers,
          exception: {},
          response: response,
        );
      }
      return response;
    }, (error, stack) => _mapError(error, stack, method: HttpMethods.get));
  }

  TaskEither<HttpException, http.Response> post(
    String path,
    Object? body, {
    Map<String, dynamic>? query,
    bool noAuth = false,
  }) {
    return TaskEither.tryCatch(() async {
      final uri = _buildUri(path, query);
      final headers = await _getHeaders(noAuth: noAuth);
      final response = await client.post(uri, headers: headers, body: _encodeBody(body));
      if (!_isOkStatus(response.statusCode)) {
        throw OperationException.http(
          statusCode: response.statusCode,
          bodySent: body ?? {},
          endpoint: uri,
          headers: headers,
          exception: {},
          response: response,
        );
      }
      return response;
    }, (error, stack) => _mapError(error, stack, method: HttpMethods.post));
  }

  TaskEither<HttpException, http.Response> put(
    String path,
    Object? body, {
    Map<String, dynamic>? query,
    bool noAuth = false,
  }) {
    return TaskEither.tryCatch(() async {
      final uri = _buildUri(path, query);
      final headers = await _getHeaders(noAuth: noAuth);
      final response = await client.put(uri, headers: headers, body: _encodeBody(body));
      if (!_isOkStatus(response.statusCode)) {
        throw OperationException.http(
          statusCode: response.statusCode,
          bodySent: body ?? {},
          endpoint: uri,
          headers: headers,
          exception: {},
          response: response,
        );
      }
      return response;
    }, (error, stack) => _mapError(error, stack, method: HttpMethods.put));
  }

  TaskEither<HttpException, http.Response> delete(
    String path, {
    Map<String, dynamic>? query,
    bool noAuth = false,
  }) {
    return TaskEither.tryCatch(() async {
      final uri = _buildUri(path, query);
      final headers = await _getHeaders(noAuth: noAuth);
      final response = await client.delete(uri, headers: headers);
      if (!_isOkStatus(response.statusCode)) {
        throw OperationException.http(
          statusCode: response.statusCode,
          bodySent: {},
          endpoint: uri,
          headers: headers,
          exception: {},
          response: response,
        );
      }
      return response;
    }, (error, stack) => _mapError(error, stack, method: HttpMethods.delete));
  }

  HttpException _mapError(Object error, StackTrace stack, {required HttpMethods method}) {
    if (error is OperationException && error.type == OperationExceptionType.http) {
      final httpError = error.except as OperationHttpType;
      final res = httpError.response;
      if (res is http.Response) {
        return HttpException(
          statusCode: httpError.statusCode,
          stack: stack,
          error: res.body.isNotEmpty ? res.body : 'HTTP ${httpError.statusCode}',
          httpResponse: res,
        );
      }
      return HttpException(statusCode: httpError.statusCode, stack: stack, error: httpError.exception);
    }
    app_log.Log.print<app_log.Error>(
      message: 'Erro durante serviço http [${method.name}]',
      origin: 'HttpServices',
      method: method.name,
      httpMethod: method,
      stack: StackTrace.current,
    );
    return HttpException(statusCode: 500, stack: stack, error: error);
  }
}
