import 'package:flutter/foundation.dart';
import '../services/api/auth_api.dart';
import '../services/token_manager.dart';
import '../services/connectivity_service.dart';
import '../models/user.dart';
import '../exceptions/api_exceptions.dart';

class AuthProvider with ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final TokenManager _tokenManager = TokenManager();
  final ConnectivityService _connectivity = ConnectivityService();

  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  /// ตรวจสอบ auth state ตอนเปิด app
  Future<void> checkAuth() async {
    try {
      final accessToken = await _tokenManager.getAccessToken();
      if (accessToken == null) {
        _setUnauthenticated();
        return;
      }

      // ถ้า refresh token หมดอายุแล้ว → ต้อง login ใหม่ (ทั้ง online/offline)
      final refreshExpired = await _tokenManager.isRefreshTokenExpired();
      if (refreshExpired) {
        await _tokenManager.clearTokens();
        await _tokenManager.clearUserData();
        _setUnauthenticated();
        return;
      }

      // ถ้า offline → ใช้ profile ที่ cache ไว้
      if (!_connectivity.isOnline) {
        await _restoreFromCache();
        return;
      }

      // Online → ยืนยันกับ API และอัปเดต cache
      _user = await _authApi.getProfile();
      await _tokenManager.saveUserProfile(_user!.toJson());
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      // NetworkException  = ไม่มีเน็ต
      // SessionExpiredException = server 5xx ระหว่าง refresh (server พัง ไม่ใช่ token ผิด)
      // ทั้งสองกรณีลอง offline fallback ก่อน ไม่ logout ทันที
      if (e is NetworkException || e is SessionExpiredException) {
        await _restoreFromCache();
        return;
      }
      _setUnauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    if (!_connectivity.isOnline) {
      await _loginOffline(email, password);
      return;
    }

    final data = await _authApi.login(email, password);

    if (data['user'] != null) {
      _user = User.fromJson(data['user'] as Map<String, dynamic>);
    } else {
      _user = await _authApi.getProfile();
    }

    // Cache profile + credential hash สำหรับ offline ครั้งถัดไป
    await _tokenManager.saveUserProfile(_user!.toJson());
    await _tokenManager.saveCredentialHash(email, password);

    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
      // server call failed (offline, 5xx) — clear local session regardless
    }
    await _tokenManager.clearUserData();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    try {
      _user = await _authApi.getProfile();
      await _tokenManager.saveUserProfile(_user!.toJson());
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      if (e is NetworkException) {
        // offline — restore cached profile instead of logging out
        await _restoreFromCache();
        return;
      }
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    // _authApi.changePassword already clears tokens (access + refresh) via TokenManager
    await _authApi.changePassword(oldPassword, newPassword);
    await _tokenManager.clearUserData();
    _setUnauthenticated(); // clear _user state and notify listeners
  }

  // ==================== Private ====================

  Future<void> _loginOffline(String email, String password) async {
    final hasCredentials = await _tokenManager.hasOfflineCredentials();
    if (!hasCredentials) {
      throw ApiException(
        'ไม่พบ session ที่บันทึกไว้ กรุณาเชื่อมต่ออินเทอร์เน็ตแล้ว login ก่อน',
      );
    }

    final valid = await _tokenManager.verifyCredential(email, password);
    if (!valid) {
      throw ApiException('อีเมลหรือรหัสผ่านไม่ถูกต้อง');
    }

    final refreshExpired = await _tokenManager.isRefreshTokenExpired();
    if (refreshExpired) {
      throw ApiException(
        'Session หมดอายุแล้ว กรุณาเชื่อมต่ออินเทอร์เน็ตเพื่อต่ออายุ session',
      );
    }

    final cachedProfile = await _tokenManager.getUserProfile();
    if (cachedProfile == null) {
      throw ApiException(
        'ไม่พบข้อมูลที่บันทึกไว้ กรุณาเชื่อมต่ออินเทอร์เน็ตแล้ว login ก่อน',
      );
    }

    _user = User.fromJson(cachedProfile);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> _restoreFromCache() async {
    final cachedProfile = await _tokenManager.getUserProfile();
    if (cachedProfile != null) {
      _user = User.fromJson(cachedProfile);
      _isAuthenticated = true;
      notifyListeners();
    } else {
      _setUnauthenticated();
    }
  }

  void _setUnauthenticated() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
