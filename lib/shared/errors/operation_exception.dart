import 'package:arthur/shared/enums/enums.dart';

/// Detalhes de uma falha originada em uma chamada HTTP.
class OperationHttpType {
  int statusCode;
  Object body;
  Object response;
  Object exception;
  Uri endpoint;
  Object headers;
  StackTrace stackTrace;

  OperationHttpType({
    required this.statusCode,
    required this.exception,
    required this.response,
    required this.body,
    required this.endpoint,
    required this.headers,
    required this.stackTrace,
  });

  factory OperationHttpType.fromJson(Map<String, dynamic> map) {
    return OperationHttpType(
      statusCode: map['statusCode'],
      body: map['body'],
      response: map['response'],
      exception: map['exception'],
      endpoint: map['endpoint'],
      headers: map['headers'],
      stackTrace: map['stackTrace'],
    );
  }
}

/// Detalhes de uma falha originada em regra de negócio.
class OperationLogicType {
  Object content;
  Object exception;
  String message;

  OperationLogicType({
    required this.content,
    required this.exception,
    required this.message,
  });

  factory OperationLogicType.fromJson(Map<String, dynamic> map) {
    return OperationLogicType(
      content: map['content'],
      exception: map['exception'],
      message: map['message'],
    );
  }
}

class OperationException implements Exception {
  final OperationExceptionType type;
  Object? except;

  OperationException({required this.type});

  factory OperationException.http({
    required int statusCode,
    required Object bodySent,
    required Object exception,
    required Object response,
    required Uri endpoint,
    required Object headers,
    StackTrace? stackTrace,
  }) {
    final operation = OperationException(type: OperationExceptionType.http);
    operation.except = OperationHttpType.fromJson({
      'statusCode': statusCode,
      'body': bodySent,
      'exception': exception,
      'response': response,
      'endpoint': endpoint,
      'headers': headers,
      'stackTrace': stackTrace ?? StackTrace.current,
    });
    return operation;
  }

  factory OperationException.logic({
    required Object content,
    required String message,
    required Object exception,
  }) {
    final operation = OperationException(type: OperationExceptionType.logic);
    operation.except = OperationLogicType.fromJson({
      'content': content,
      'message': message,
      'exception': exception,
    });
    return operation;
  }
}
