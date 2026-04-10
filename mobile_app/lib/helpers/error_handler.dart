import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../exceptions/api_exceptions.dart';

Future<void> handleAuthException(
  BuildContext context,
  Object error, {
  void Function(String message)? onApiError,
}) async {
  if (!context.mounted) return;

  if (error is RefreshTokenExpiredException) {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 5),
      ),
    );
  } else if (error is SessionExpiredException) {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.message)),
    );
  } else if (error is ApiException) {
    if (onApiError != null) {
      onApiError(error.message);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message), backgroundColor: Colors.red),
      );
    }
  } else {
    if (onApiError != null) {
      onApiError('An unexpected error occurred');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
