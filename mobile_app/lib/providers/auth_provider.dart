import 'package:flutter/foundation.dart';
import '../services/api/auth_api.dart';
import '../services/token_manager.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final TokenManager _tokenManager = TokenManager();
  
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  /// Check if user is authenticated on app start
  Future<void> checkAuth() async {
    try {
      // เช็คว่ามี access token หรือไม่
      final accessToken = await _tokenManager.getAccessToken();
      
      if (accessToken == null) {
        _isAuthenticated = false;
        _user = null;
        notifyListeners();
        return;
      }

      // เช็คว่า token หมดอายุหรือยัง
      if (_tokenManager.isTokenExpired(accessToken)) {
        // ลอง refresh token
        final refreshToken = await _tokenManager.getRefreshToken();
        
        if (refreshToken == null || _tokenManager.isTokenExpired(refreshToken)) {
          // Refresh token หมดอายุด้วย ต้อง login ใหม่
          await _authApi.logout();
          _isAuthenticated = false;
          _user = null;
          notifyListeners();
          return;
        }
        
        // Refresh token ยังใช้ได้ แต่ไม่ต้อง refresh ตอนนี้
        // ให้ ApiClient จัดการเอง
      }

      // โหลด profile เพื่อยืนยันว่า token ใช้งานได้จริง
      _user = await _authApi.getProfile();
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      // ถ้า error ใดๆ ให้ logout
      await _authApi.logout();
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final data = await _authApi.login(email, password);
    
    // ถ้า backend ส่ง user มาด้วย
    if (data['user'] != null) {
      _user = User.fromJson(data['user']);
    } else {
      // ถ้าไม่มี ให้โหลด profile
      _user = await _authApi.getProfile();
    }
    
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authApi.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    try {
      _user = await _authApi.getProfile();
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _authApi.changePassword(oldPassword, newPassword);
  }
}