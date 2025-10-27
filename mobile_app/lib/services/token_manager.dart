import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final _storage = const FlutterSecureStorage();
  Completer<String>? _refreshCompleter;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    _refreshCompleter = null;
  }

  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  bool isTokenExpiringSoon(String token, {Duration threshold = const Duration(minutes: 1)}) {
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      final now = DateTime.now();
      return expiryDate.difference(now) < threshold;
    } catch (e) {
      return true;
    }
  }

  Future<String> getOrRefreshToken(Future<String> Function() refreshCallback) async {
    // ถ้ามีการ refresh อยู่แล้ว ให้รอให้มันเสร็จ
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      try {
        return await _refreshCompleter!.future;
      } catch (e) {
        // ถ้า refresh ล้มเหลว ให้ลองใหม่
        _refreshCompleter = null;
        rethrow;
      }
    }

    final token = await getAccessToken();
    
    if (token == null) {
      throw Exception('No access token found');
    }

    // ถ้า token ยังใช้ได้ดี ให้คืนเลย
    if (!isTokenExpiringSoon(token)) {
      return token;
    }

    // ถ้าถึงตรงนี้แสดงว่าต้อง refresh
    _refreshCompleter = Completer<String>();
    
    try {
      final newToken = await refreshCallback();
      _refreshCompleter!.complete(newToken);
      return newToken;
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      // ล้าง completer หลังเสร็จ (ไม่ว่าจะสำเร็จหรือไม่)
      Future.delayed(const Duration(seconds: 1), () {
        _refreshCompleter = null;
      });
    }
  }

  Future<bool> isRefreshTokenExpired() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return true;
    return isTokenExpired(refreshToken);
  }
}