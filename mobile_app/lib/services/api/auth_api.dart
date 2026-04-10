import '../../models/user.dart';
import 'api_client.dart';
import '../token_manager.dart';
import '../../exceptions/api_exceptions.dart';

class AuthApi {
  final ApiClient _client = ApiClient();
  final TokenManager _tokenManager = TokenManager();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _client.post(
      '/login',
      (data) => data, // คืน data ทั้งหมดก่อน
      body: {'email': email, 'password': password},
      needsAuth: false,
      errorMessage: 'Login failed',
      statusMessages: {
        401: 'Invalid email or password',
        500: 'Server error. Please try again later.',
      },
    );

    // Validate และบันทึก tokens
    if (result['access_token'] == null || result['refresh_token'] == null) {
      throw ApiException('Invalid login response: missing tokens');
    }

    await _tokenManager.saveTokens(
      result['access_token'],
      result['refresh_token'],
    );

    return result;
  }

  Future<void> logout() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      await _client.requestVoid(
        '/logout',
        'POST',
        body: {
          if (refreshToken != null) 'refresh_token': refreshToken,
        },
        errorMessage: 'Logout failed',
      );
    } catch (e) {
      // logout error ignored — tokens cleared regardless
    } finally {
      await _tokenManager.clearTokens();
      _client.clearState();
    }
  }

  Future<User> getProfile() async {
    return await _client.get(
      '/profile',
      (data) => User.fromJson(data),
      errorMessage: 'Failed to load profile',
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final refreshToken = await _tokenManager.getRefreshToken();
    await _client.requestVoid(
      '/profile/change-password',
      'PUT',
      body: {
        'old_password': oldPassword,
        'new_password': newPassword,
        if (refreshToken != null) 'refresh_token': refreshToken,
      },
      errorMessage: 'Failed to change password',
      statusMessages: {
        401: 'Current password is incorrect',
      },
    );
    await _tokenManager.clearTokens();
    _client.clearState();
  }
}
