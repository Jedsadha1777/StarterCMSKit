import 'package:flutter/material.dart';
import 'report_content.dart';
import 'preview_shell.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final machineModel = args?['machineModel'] as Map<String, dynamic>?;
    final draftData = args?['draftData'] as Map<String, dynamic>?;

    final contentKey = GlobalKey<ReportContentWidgetState>();

    return PreviewShell(
      pagePadding: const EdgeInsets.all(5),
      pages: [
        ReportContentWidget(
          key: contentKey,
          machineModel: machineModel,
          draftData: draftData,
        ),
      ],
      onBack: () => Navigator.of(context).pop(),
      bottomBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('Save', Icons.save, Colors.green, () {
                contentKey.currentState?.onSave();
              }),
              _buildButton('Send', Icons.send, const Color(0xFFAD193C), () {
                contentKey.currentState?.onSend();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
