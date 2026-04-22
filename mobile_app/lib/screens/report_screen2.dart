import 'package:flutter/material.dart';
import 'report_content2.dart';
import 'preview_shell.dart';

class ReportScreen2 extends StatefulWidget {
  const ReportScreen2({super.key});

  @override
  State<ReportScreen2> createState() => _ReportScreen2State();
}

class _ReportScreen2State extends State<ReportScreen2> {
  final _contentKey = GlobalKey<ReportContentWidgetState2>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final machineModel = args?['machineModel'] as Map<String, dynamic>?;
    final draftData = args?['draftData'] as Map<String, dynamic>?;

    return PreviewShell(
      pagePadding: const EdgeInsets.all(5),
      pages: [
        ReportContentWidget2(
          key: _contentKey,
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
                _contentKey.currentState?.onSave();
              }),
              _buildButton('Send', Icons.send, const Color(0xFFAD193C), () {
                _contentKey.currentState?.onSend();
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
