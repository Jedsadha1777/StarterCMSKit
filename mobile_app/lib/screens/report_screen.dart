import 'package:flutter/material.dart';
import 'report_content2.dart';
import 'preview_shell.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
      onSaveDraft: () => _contentKey.currentState?.onSave(),
      onConfirmSend: () => _contentKey.currentState?.onSend(),
      onReset: () => _contentKey.currentState?.onReset(),
      onModeChanged: (review) => _contentKey.currentState?.setSnapMode(review),
      onBeforePreview: () async => await _contentKey.currentState?.validateForPreview() ?? true,
    );
  }
}
