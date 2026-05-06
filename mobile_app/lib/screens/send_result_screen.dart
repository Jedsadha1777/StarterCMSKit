import 'package:flutter/material.dart';

/// Send-result popup shown after submit/upload/email completes.
/// Icons copied from reference/lib2/pages/report_pdf.dart:
///   _sentOutDialog    → Icons.wifi (blue)
///   _sentFailedDialog → Icons.wifi_off (red 0xFFFF0000)
class SendResultDialog extends StatelessWidget {
  final bool success;
  final String title;
  final String message;
  const SendResultDialog({
    super.key,
    required this.success,
    required this.title,
    required this.message,
  });

  static const _red = Color(0xFFAD193C);
  static const _failRed = Color(0xFFFF0000);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.wifi : Icons.wifi_off,
              size: 64,
              color: success ? Colors.blue : _failRed,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
