import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../exceptions/api_exceptions.dart';

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
      throw RefreshTokenExpiredException('No access token found');
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
      // microtask runs after the current event loop turn — safe and immediate
      Future.microtask(() => _refreshCompleter = null);
    }
  }

  Future<bool> isRefreshTokenExpired() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return true;
    return isTokenExpired(refreshToken);
  }

  // ==================== Offline Auth ====================

  static const String _userProfileKey = 'cached_user_profile';
  static const String _credHashKey = 'offline_cred_hash';
  static const String _credSaltKey = 'offline_cred_salt';
  static const String _credEmailKey = 'offline_cred_email';

  /// บันทึก user profile ไว้ใช้ตอน offline
  Future<void> saveUserProfile(Map<String, dynamic> userJson) async {
    await _storage.write(key: _userProfileKey, value: jsonEncode(userJson));
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final raw = await _storage.read(key: _userProfileKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// บันทึก credential hash สำหรับ login ขณะ offline
  Future<void> saveCredentialHash(String email, String password) async {
    final salt = base64Url.encode(
      List<int>.generate(16, (_) => Random.secure().nextInt(256)),
    );
    final hash = _hmacHash(email, password, salt);
    await _storage.write(key: _credEmailKey, value: email);
    await _storage.write(key: _credSaltKey, value: salt);
    await _storage.write(key: _credHashKey, value: hash);
  }

  /// ตรวจสอบ credential กับ hash ที่เก็บไว้
  Future<bool> verifyCredential(String email, String password) async {
    final storedEmail = await _storage.read(key: _credEmailKey);
    final storedSalt = await _storage.read(key: _credSaltKey);
    final storedHash = await _storage.read(key: _credHashKey);

    if (storedEmail == null || storedSalt == null || storedHash == null) {
      return false;
    }
    if (storedEmail != email) return false;

    return _hmacHash(email, password, storedSalt) == storedHash;
  }

  Future<bool> hasOfflineCredentials() async {
    final email = await _storage.read(key: _credEmailKey);
    final hash = await _storage.read(key: _credHashKey);
    return email != null && hash != null;
  }

  /// ล้างข้อมูล offline cache ทั้งหมด (เรียกตอน logout)
  Future<void> clearUserData() async {
    await _storage.delete(key: _userProfileKey);
    await _storage.delete(key: _credHashKey);
    await _storage.delete(key: _credSaltKey);
    await _storage.delete(key: _credEmailKey);
  }

  String _hmacHash(String email, String password, String salt) {
    final key = utf8.encode(salt);
    final msg = utf8.encode('$email:$password');
    return Hmac(sha256, key).convert(msg).toString();
  }
}