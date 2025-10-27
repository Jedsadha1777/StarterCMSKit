import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../exceptions/api_exceptions.dart';
import '../token_manager.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final TokenManager _tokenManager = TokenManager();

  static Completer<void>? _refreshLock;
  static DateTime? _lastRefreshAttempt;
  static const Duration _refreshCooldown = Duration(seconds: 5);

  // ==================== Helper Methods ====================

  Future<Map<String, String>> getHeaders({bool needsAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};

    if (needsAuth) {
      final token = await _tokenManager.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Map<String, dynamic> safeJsonDecode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw const FormatException('Response is not a JSON object');
    } catch (e) {
      throw ApiException('Invalid response format from server');
    }
  }

  String extractErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    }

    final errorStr = error.toString();

    if (errorStr.startsWith('Exception: ')) {
      return errorStr.substring('Exception: '.length);
    }
    if (errorStr.startsWith('NetworkException: ')) {
      return errorStr.substring('NetworkException: '.length);
    }

    return errorStr;
  }

  int safeParseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    if (value is double) return value.toInt();
    return defaultValue;
  }

  /// Generic response handler
  T handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic> data) parser, {
    String? errorMessage,
    Map<int, String>? statusMessages,
  }) {
    if (response.statusCode == 200) {
      final data = safeJsonDecode(response.body);
      return parser(data);
    } else {
      String errorMsg = errorMessage ?? 'Request failed';

      if (statusMessages != null &&
          statusMessages.containsKey(response.statusCode)) {
        errorMsg = statusMessages[response.statusCode]!;
      } else {
        try {
          final error = safeJsonDecode(response.body);
          errorMsg = error['message'] ?? errorMsg;
        } catch (_) {
          if (response.statusCode == 401) {
            errorMsg = 'Unauthorized';
          } else if (response.statusCode == 404) {
            errorMsg = 'Not found';
          } else if (response.statusCode >= 500) {
            errorMsg = 'Server error. Please try again later.';
          }
        }
      }

      throw ApiException(errorMsg, statusCode: response.statusCode);
    }
  }

  // ==================== HTTP Methods ====================

  /// Generic GET request
  Future<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic> data) parser, {
    Map<String, String>? queryParams,
    bool needsAuth = true,
    String? errorMessage,
    Map<int, String>? statusMessages,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final uri = queryParams != null
        ? Uri.parse('${ApiConfig.baseUrl}$endpoint')
            .replace(queryParameters: queryParams)
        : Uri.parse('${ApiConfig.baseUrl}$endpoint');

    final response = await makeRequest(
      () async => await http
          .get(uri, headers: await getHeaders(needsAuth: needsAuth))
          .timeout(timeout),
      needsAuth: needsAuth,
    );

    return handleResponse(response, parser,
        errorMessage: errorMessage, statusMessages: statusMessages);
  }

  /// Generic POST request
  Future<T> post<T>(
    String endpoint,
    T Function(Map<String, dynamic> data) parser, {
    Map<String, dynamic>? body,
    bool needsAuth = true,
    String? errorMessage,
    Map<int, String>? statusMessages,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final response = await makeRequest(
      () async => await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: await getHeaders(needsAuth: needsAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout),
      needsAuth: needsAuth,
    );

    return handleResponse(response, parser,
        errorMessage: errorMessage, statusMessages: statusMessages);
  }

  /// Generic PUT request
  Future<T> put<T>(
    String endpoint,
    T Function(Map<String, dynamic> data) parser, {
    Map<String, dynamic>? body,
    bool needsAuth = true,
    String? errorMessage,
    Map<int, String>? statusMessages,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final response = await makeRequest(
      () async => await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: await getHeaders(needsAuth: needsAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout),
      needsAuth: needsAuth,
    );

    return handleResponse(response, parser,
        errorMessage: errorMessage, statusMessages: statusMessages);
  }

  /// Generic DELETE request
  Future<T> delete<T>(
    String endpoint,
    T Function(Map<String, dynamic> data) parser, {
    bool needsAuth = true,
    String? errorMessage,
    Map<int, String>? statusMessages,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final response = await makeRequest(
      () async => await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: await getHeaders(needsAuth: needsAuth),
          )
          .timeout(timeout),
      needsAuth: needsAuth,
    );

    return handleResponse(response, parser,
        errorMessage: errorMessage, statusMessages: statusMessages);
  }

  /// For requests that return void (no body)
  Future<void> requestVoid(
    String endpoint,
    String method, {
    Map<String, dynamic>? body,
    bool needsAuth = true,
    String? errorMessage,
    Map<int, String>? statusMessages,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    http.Response response;

    final request = () async {
      switch (method.toUpperCase()) {
        case 'POST':
          return await http
              .post(
                Uri.parse('${ApiConfig.baseUrl}$endpoint'),
                headers: await getHeaders(needsAuth: needsAuth),
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
        case 'PUT':
          return await http
              .put(
                Uri.parse('${ApiConfig.baseUrl}$endpoint'),
                headers: await getHeaders(needsAuth: needsAuth),
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
        case 'DELETE':
          return await http
              .delete(
                Uri.parse('${ApiConfig.baseUrl}$endpoint'),
                headers: await getHeaders(needsAuth: needsAuth),
              )
              .timeout(timeout);
        default:
          throw ArgumentError('Unsupported method: $method');
      }
    };

    response = await makeRequest(request, needsAuth: needsAuth);

    if (response.statusCode != 200 && response.statusCode != 204) {
      String errorMsg = errorMessage ?? 'Request failed';

      if (statusMessages != null &&
          statusMessages.containsKey(response.statusCode)) {
        errorMsg = statusMessages[response.statusCode]!;
      } else {
        try {
          final error = safeJsonDecode(response.body);
          errorMsg = error['message'] ?? errorMsg;
        } catch (_) {
          if (response.statusCode == 401) {
            errorMsg = 'Unauthorized';
          } else if (response.statusCode >= 500) {
            errorMsg = 'Server error. Please try again later.';
          }
        }
      }

      throw ApiException(errorMsg, statusCode: response.statusCode);
    }
  }

  // ==================== Token Refresh Logic ====================

  Future<String> refreshToken() async {
    if (_lastRefreshAttempt != null) {
      final timeSinceLastRefresh =
          DateTime.now().difference(_lastRefreshAttempt!);
      if (timeSinceLastRefresh < _refreshCooldown) {
        if (_refreshLock != null && !_refreshLock!.isCompleted) {
          try {
            await _refreshLock!.future;
          } catch (_) {}
        }
        final token = await _tokenManager.getAccessToken();
        if (token != null && !_tokenManager.isTokenExpired(token)) {
          return token;
        }
      }
    }

    if (_refreshLock != null && !_refreshLock!.isCompleted) {
      try {
        await _refreshLock!.future;
      } catch (_) {}
      final token = await _tokenManager.getAccessToken();
      if (token != null) return token;
    }

    _refreshLock = Completer<void>();

    try {
      _lastRefreshAttempt = DateTime.now();

      final refreshToken = await _tokenManager.getRefreshToken();

      if (refreshToken == null) {
        throw RefreshTokenExpiredException('No refresh token found');
      }

      if (_tokenManager.isTokenExpired(refreshToken)) {
        await _tokenManager.clearTokens();
        throw RefreshTokenExpiredException('Refresh token has expired');
      }

      // ส่ง refresh token ใน Authorization header
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
        // ไม่ต้องส่ง body หรือส่งแบบนี้ก็ได้
        // body: jsonEncode({'refresh_token': refreshToken}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Refresh token request timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = safeJsonDecode(response.body);
        final newAccessToken = data['access_token'];
        final newRefreshToken = data['refresh_token'];

        if (newAccessToken == null) {
          throw ApiException('Invalid refresh response: missing access_token');
        }

        // บันทึก token ใหม่ทั้งคู่ (rotating refresh token)
        await _tokenManager.saveTokens(newAccessToken,
            newRefreshToken ?? refreshToken // ถ้าไม่มีใหม่ ใช้เก่า
            );

        try {
          _refreshLock?.complete();
        } catch (_) {}

        Future.microtask(() => _refreshLock = null);

        return newAccessToken;
      } else if (response.statusCode == 401) {
        await _tokenManager.clearTokens();

        String errorMsg = 'Refresh token is invalid or expired';
        try {
          final errorData = safeJsonDecode(response.body);
          errorMsg = errorData['message'] ?? errorMsg;
        } catch (_) {}

        try {
          _refreshLock?.completeError(RefreshTokenExpiredException(errorMsg));
        } catch (_) {}
        throw RefreshTokenExpiredException(errorMsg);
      } else {
        await _tokenManager.clearTokens();

        String errorMsg = 'Failed to refresh token';
        try {
          final errorData = safeJsonDecode(response.body);
          errorMsg = errorData['message'] ?? errorMsg;
        } catch (_) {}

        try {
          _refreshLock?.completeError(SessionExpiredException(errorMsg));
        } catch (_) {}
        throw SessionExpiredException(errorMsg);
      }
    } catch (e) {
      try {
        if (_refreshLock != null && !_refreshLock!.isCompleted) {
          _refreshLock!.completeError(e);
        }
      } catch (_) {}

      if (e is RefreshTokenExpiredException || e is SessionExpiredException) {
        await _tokenManager.clearTokens();
        rethrow;
      }

      if (e is TimeoutException) {
        await _tokenManager.clearTokens();
        throw NetworkException('Token refresh timed out');
      }

      await _tokenManager.clearTokens();
      throw NetworkException('Token refresh failed: ${extractErrorMessage(e)}');
    } finally {
      try {
        if (_refreshLock != null && !_refreshLock!.isCompleted) {
          _refreshLock!.complete();
        }
      } catch (_) {}

      Future.delayed(const Duration(milliseconds: 100), () {
        _refreshLock = null;
      });
    }
  }

  Future<http.Response> makeRequest(
    Future<http.Response> Function() request, {
    bool needsAuth = true,
    int retryCount = 0,
    int maxRetries = 2,
  }) async {
    try {
      if (needsAuth) {
        await _tokenManager.getOrRefreshToken(refreshToken);
      }

      var response = await request();

      if (response.statusCode == 401 && needsAuth && retryCount == 0) {
        try {
          await refreshToken();
          return await makeRequest(
            request,
            needsAuth: needsAuth,
            retryCount: 1,
            maxRetries: maxRetries,
          );
        } on RefreshTokenExpiredException {
          rethrow;
        } on SessionExpiredException {
          rethrow;
        }
      }

      return response;
    } on TimeoutException catch (e) {
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(milliseconds: 500 * (retryCount + 1)));
        return await makeRequest(
          request,
          needsAuth: needsAuth,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      }
      throw NetworkException('Request timed out after $maxRetries retries');
    } on RefreshTokenExpiredException {
      rethrow;
    } on SessionExpiredException {
      rethrow;
    } catch (e) {
      if (e is ApiException) rethrow;

      if (retryCount < maxRetries &&
          (e.toString().contains('SocketException') ||
              e.toString().contains('Connection'))) {
        await Future.delayed(Duration(milliseconds: 500 * (retryCount + 1)));
        return await makeRequest(
          request,
          needsAuth: needsAuth,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      }

      throw NetworkException(extractErrorMessage(e));
    }
  }

  void clearState() {
    _refreshLock = null;
    _lastRefreshAttempt = null;
  }
}
