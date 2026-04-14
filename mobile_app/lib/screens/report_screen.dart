import 'package:flutter/material.dart';
import 'report_content.dart' as report_content;
import 'preview_shell.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreviewShell(
      pages: [report_content.content()],
      onBack: () => Navigator.of(context).pop(),
    );
  }
}
