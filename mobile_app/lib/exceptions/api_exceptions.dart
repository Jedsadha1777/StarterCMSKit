class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized'])
      : super(message, statusCode: 401);
}

class SessionExpiredException extends ApiException {
  SessionExpiredException([String message = 'Session expired. Please login again.'])
      : super(message, statusCode: 401);
}

class RefreshTokenExpiredException extends ApiException {
  RefreshTokenExpiredException([String message = 'Your session has expired. Please login again.'])
      : super(message, statusCode: 401);
}

class NetworkException extends ApiException {
  NetworkException([String message = 'Network error occurred'])
      : super(message);
}