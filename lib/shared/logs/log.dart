import 'dart:developer';

import 'package:arthur/shared/enums/enums.dart';

abstract class BufferLevel {
  String get name;
  int get code;
}

class Critical extends BufferLevel {
  @override
  String get name => 'Critical';
  @override
  int get code => 1000;
}

class Error extends BufferLevel {
  @override
  String get name => 'Error';
  @override
  int get code => 500;
}

class Warning extends BufferLevel {
  @override
  String get name => 'Warning';
  @override
  int get code => 400;
}

class Info extends BufferLevel {
  @override
  String get name => 'Info';
  @override
  int get code => 300;
}

class Debug extends BufferLevel {
  @override
  String get name => 'Debug';
  @override
  int get code => 200;
}

class ErrorMap {
  final String origin;
  final String? message;
  final String? httpEndpoint;
  final HttpMethods? httpMethod;
  final int? httpStatus;
  final Map<String, String>? httpQueryParams;
  final Map<String, String>? httpHeaders;
  final Object? httpBody;

  const ErrorMap({
    required this.origin,
    this.message,
    this.httpEndpoint,
    this.httpMethod,
    this.httpStatus,
    this.httpQueryParams,
    this.httpHeaders,
    this.httpBody,
  });
}

class Log {
  static final Map<Type, BufferLevel Function()> _registry = {
    Critical: () => Critical(),
    Error: () => Error(),
    Warning: () => Warning(),
    Info: () => Info(),
    Debug: () => Debug(),
  };

  static StringBuffer _buffering(BufferLevel level, ErrorMap error) {
    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln('┌──────────────────────────────');
    buffer.writeln('│ [${level.name.toUpperCase()}]');
    buffer.writeln('│ message: ${error.message ?? 'not in use'}');
    buffer.writeln('│ origin: ${error.origin}');
    buffer.writeln('│ http_endpoint: ${error.httpEndpoint ?? 'not in use'}');
    buffer.writeln('│ http_status: ${error.httpStatus ?? 'not in use'}');
    buffer.writeln('│ http_method: ${error.httpMethod?.name ?? 'not in use'}');
    buffer.writeln('│ http_headers: ${error.httpHeaders ?? 'not in use'}');
    buffer.writeln('│ http_query: ${error.httpQueryParams ?? 'not in use'}');
    buffer.writeln('│ http_body: ${error.httpBody ?? 'not in use'}');
    buffer.writeln('└──────────────────────────────');
    return buffer;
  }

  static void print<T extends BufferLevel>({
    String? message,
    Object? error,
    StackTrace? stack,
    required String origin,
    required String method,
    String? httpEndpoint,
    Map<String, String>? httpQueryParams,
    Map<String, String>? httpHeaders,
    Object? httpBody,
    int? httpStatus,
    HttpMethods? httpMethod,
  }) {
    final level = _registry.containsKey(T) ? _registry[T]!() : Error();

    final mapping = ErrorMap(
      origin: '[${level.name}] ${origin}_$method',
      message: message,
      httpEndpoint: httpEndpoint,
      httpQueryParams: httpQueryParams,
      httpHeaders: httpHeaders,
      httpBody: httpBody,
      httpMethod: httpMethod,
      httpStatus: httpStatus,
    );

    log(
      _buffering(level, mapping).toString(),
      level: level.code,
      time: DateTime.now(),
      error: error,
      stackTrace: stack,
    );
  }
}
