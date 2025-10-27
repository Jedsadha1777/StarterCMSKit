import '../../models/user.dart';
import 'api_client.dart';

class ProfileApi {
  final ApiClient _client = ApiClient();

  Future<User> getProfile() async {
    return await _client.get(
      '/profile',
      (data) => User.fromJson(data),
      errorMessage: 'Failed to load profile',
    );
  }

  Future<void> updateProfile(String name, String email) async {
    await _client.requestVoid(
      '/profile',
      'PUT',
      body: {'name': name, 'email': email},
      errorMessage: 'Failed to update profile',
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _client.requestVoid(
      '/profile/change-password',
      'PUT',
      body: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
      errorMessage: 'Failed to change password',
      statusMessages: {
        401: 'Current password is incorrect',
      },
    );
  }
}