import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:uuid/uuid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'form_widgets/form_widgets.dart';
import 'preview_shell.dart';
import '../services/local_db.dart';
import '../services/api/report_api.dart';
import '../services/connectivity_service.dart';
import 'email_dialog.dart';

void main() => runApp(PreviewShell(
  pages: [ReportContentWidget2()],
  pagePadding: EdgeInsets.all(5),
));

class ReportContentWidget2 extends StatefulWidget {
  final Map<String, dynamic>? machineModel;
  final Map<String, dynamic>? draftData;

  const ReportContentWidget2({super.key, this.machineModel, this.draftData});

  @override
  State<ReportContentWidget2> createState() => ReportContentWidgetState2();
}

class ReportContentWidgetState2 extends State<ReportContentWidget2> {

  String? _draftId;
  bool _isSaving = false;
  bool _isSending = false;
  bool _snapMode = false;
  final GlobalKey _captureKey = GlobalKey();

  // ============ NON-CONTROLLER STATE (FormDate, FormSearch, FormSignature) ============
  String? _formDate;
  String? _machineModelSearch;
  String? _installDate;
  String? _inspectionDate;
  String? _dateCustomerSign;
  String? _dateEngineerSign;
  Uint8List? _customerSignBytes;
  Uint8List? _engineerSignBytes;

  // ============ CONTROLLERS ============
  final _formNoController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _serialNoController = TextEditingController();
  final _installFreeController = TextEditingController();
  final _inspectorByController = TextEditingController();
  final _checkItem1Controller = TextEditingController();
  final _afterAdj1Controller = TextEditingController();
  final _checkItem2Controller = TextEditingController();
  final _afterAdj2Controller = TextEditingController();
  final _checkItem3Controller = TextEditingController();
  final _afterAdj3Controller = TextEditingController();
  final _checkItem4Controller = TextEditingController();
  final _afterAdj4Controller = TextEditingController();
  final _checkItem5Controller = TextEditingController();
  final _afterAdj5Controller = TextEditingController();
  final _checkItem6Controller = TextEditingController();
  final _afterAdj6Controller = TextEditingController();
  final _checkItem7Controller = TextEditingController();
  final _afterAdj7Controller = TextEditingController();
  final _checkItem8Controller = TextEditingController();
  final _afterAdj8Controller = TextEditingController();
  final _checkItem9Controller = TextEditingController();
  final _afterAdj9Controller = TextEditingController();
  final _checkItem10Controller = TextEditingController();
  final _afterAdj10Controller = TextEditingController();
  final _inputResultOkController = TextEditingController();
  final _inputResultNgController = TextEditingController();
  final _inputResultOtherController = TextEditingController();
  final _inputOtherCommentController = TextEditingController();
  final _textareaHandlingController = TextEditingController();
  final _remarkController = TextEditingController();

  // ============ CONTROLLER MAP ============
  // เปลี่ยนชื่อ/เพิ่ม/ลด controller ที่นี่ที่เดียว — save/load/send ทำงานอัตโนมัติ
  Map<String, TextEditingController> get _controllerMap => {
    'formNo': _formNoController,
    'customerName': _customerNameController,
    'serialNo': _serialNoController,
    'installFree': _installFreeController,
    'inspectorBy': _inspectorByController,
    'checkItem1': _checkItem1Controller,
    'afterAdj1': _afterAdj1Controller,
    'checkItem2': _checkItem2Controller,
    'afterAdj2': _afterAdj2Controller,
    'checkItem3': _checkItem3Controller,
    'afterAdj3': _afterAdj3Controller,
    'checkItem4': _checkItem4Controller,
    'afterAdj4': _afterAdj4Controller,
    'checkItem5': _checkItem5Controller,
    'afterAdj5': _afterAdj5Controller,
    'checkItem6': _checkItem6Controller,
    'afterAdj6': _afterAdj6Controller,
    'checkItem7': _checkItem7Controller,
    'afterAdj7': _afterAdj7Controller,
    'checkItem8': _checkItem8Controller,
    'afterAdj8': _afterAdj8Controller,
    'checkItem9': _checkItem9Controller,
    'afterAdj9': _afterAdj9Controller,
    'checkItem10': _checkItem10Controller,
    'afterAdj10': _afterAdj10Controller,
    'inputResultOk': _inputResultOkController,
    'inputResultNg': _inputResultNgController,
    'inputResultOther': _inputResultOtherController,
    'inputOtherComment': _inputOtherCommentController,
    'textareaHandling': _textareaHandlingController,
    'remark': _remarkController,
  };

  // ============ SNAP MODE HELPER ============
  InputDecoration get _inputDecoration => _snapMode
      ? const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4))
      : const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8));

  // ============ INSPECTION ITEMS HELPER ============
  List<Map<String, dynamic>> get _inspectionItems =>
    (widget.machineModel?['inspection_items'] as List?)
        ?.cast<Map<String, dynamic>>() ?? [];

  String _itemName(int index) =>
    index < _inspectionItems.length ? (_inspectionItems[index]['item_name'] ?? '') : '';

  String _itemSpec(int index) =>
    index < _inspectionItems.length ? (_inspectionItems[index]['spec'] ?? '') : '';

  // ============ SIGNATURE HELPERS ============
  void _onCustomerSigned(Uint8List? bytes) {
    setState(() => _customerSignBytes = bytes);
  }

  void _onEngineerSigned(Uint8List? bytes) {
    setState(() => _engineerSignBytes = bytes);
  }

  Map<String, dynamic> _collectData() {
    final data = <String, dynamic>{};
    for (final entry in _controllerMap.entries) {
      data[entry.key] = entry.value.text;
    }
    data['formDate'] = _formDate;
    data['installDate'] = _installDate;
    data['inspectionDate'] = _inspectionDate;
    data['dateCustomerSign'] = _dateCustomerSign;
    data['dateEngineerSign'] = _dateEngineerSign;
    data['machineModelSearch'] = _machineModelSearch;
    // ลายเซ็น: เก็บ base64 ใน form_data ตรงๆ
    data['customerSign'] = _customerSignBytes != null ? base64Encode(_customerSignBytes!) : null;
    data['engineerSign'] = _engineerSignBytes != null ? base64Encode(_engineerSignBytes!) : null;
    for (int i = 0; i < _inspectionItems.length && i < 10; i++) {
      data['itemName${i + 1}'] = _inspectionItems[i]['item_name'] ?? '';
      data['itemSpec${i + 1}'] = _inspectionItems[i]['spec'] ?? '';
    }
    return data;
  }

  void _restoreData(Map<String, dynamic> formData) {
    for (final entry in formData.entries) {
      final ctrl = _controllerMap[entry.key];
      if (ctrl != null && entry.value is String) {
        ctrl.text = entry.value;
        continue;
      }
      switch (entry.key) {
        case 'formDate': _formDate = entry.value as String?;
        case 'installDate': _installDate = entry.value as String?;
        case 'inspectionDate': _inspectionDate = entry.value as String?;
        case 'dateCustomerSign': _dateCustomerSign = entry.value as String?;
        case 'dateEngineerSign': _dateEngineerSign = entry.value as String?;
        case 'machineModelSearch': _machineModelSearch = entry.value as String?;
        case 'customerSign':
          if (entry.value is String) _customerSignBytes = base64Decode(entry.value);
        case 'engineerSign':
          if (entry.value is String) _engineerSignBytes = base64Decode(entry.value);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.draftData != null) {
      _draftId = widget.draftData!['draft_id'] as String?;
      final formData = widget.draftData!['form_data'];
      if (formData is Map<String, dynamic>) {
        _restoreData(formData); // restore ทันทีก่อน build แรก
      }
    } else {
      _draftId = const Uuid().v4();
    }
  }

  @override
  void dispose() {
    for (final ctrl in _controllerMap.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> onSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      await LocalDb().saveDraft(
        draftId: _draftId!,
        machineModelId: widget.machineModel?['id'] ?? '',
        formData: _collectData(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft saved!'), duration: Duration(seconds: 1)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<Uint8List?> _captureScreenshot() async {
    final boundary = _captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<Uint8List> _imageToPdf(Uint8List pngBytes) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(pngBytes);
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (ctx) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
    ));
    return pdf.save();
  }

  Future<void> onSend() async {
    if (_isSending) return;
    if (!ConnectivityService().isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please save as draft.')),
      );
      return;
    }

    // Validate mandatory fields
    final missing = <String>[];
    if (_customerNameController.text.trim().isEmpty) missing.add('Customer Name');
    if (_serialNoController.text.trim().isEmpty) missing.add('Serial No');
    if (_inspectionDate == null || _inspectionDate!.isEmpty) missing.add('Inspection Date');
    if (_inspectorByController.text.trim().isEmpty) missing.add('Inspector');

    if (missing.isNotEmpty) {
      if (mounted) {
        showDialog(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Incomplete'),
          content: Text('Please fill in:\n${missing.join('\n')}'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ));
      }
      return;
    }

    // Validate signatures
    if (_customerSignBytes == null || _engineerSignBytes == null) {
      if (mounted) {
        final missingSigns = <String>[];
        if (_customerSignBytes == null) missingSigns.add('Customer signature');
        if (_engineerSignBytes == null) missingSigns.add('Engineer signature');
        showDialog(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Signature Required'),
          content: Text('Missing:\n${missingSigns.join('\n')}'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ));
      }
      return;
    }

    final emails = await showEmailDialog(context);
    if (emails == null || emails.isEmpty) return;

    setState(() => _isSending = true);
    try {
      String? reportNo;
      String? reportId;

      // Check if we already have a report_public_id (retry after capture fail)
      if (_draftId != null) {
        final existingDraft = await LocalDb().loadDraft(_draftId!);
        final existingReportId = existingDraft?['report_public_id'] as String?;
        if (existingReportId != null && existingReportId.isNotEmpty) {
          // Skip submit — report already created, just need capture + upload
          reportId = existingReportId;
          reportNo = existingDraft?['report_no'] as String?;
        }
      }

      // Step 1: Submit report → get report_no (status=pending_pdf) — skip if already submitted
      if (reportId == null) {
        final result = await ReportApi().submitReport(
          formData: _collectData(),
          recipientEmails: emails,
          machineModelId: widget.machineModel?['id'] ?? '',
          serialNo: _serialNoController.text,
          inspectorName: _inspectorByController.text,
        );
        reportNo = result['report_no'] as String?;
        reportId = result['id'] as String?;

        // Save report_public_id to draft
        if (_draftId != null && reportId != null) {
          await LocalDb().updateDraftStatus(_draftId!, 'sent', reportNo: reportNo, reportPublicId: reportId);
        }
      }

      // Step 2: Fill report_no in form
      if (reportNo != null) _formNoController.text = reportNo;

      // Step 3: Snap mode — show overlay, hide input borders, capture screenshot
      setState(() => _snapMode = true);
      await Future.delayed(const Duration(milliseconds: 200)); // wait for rebuild

      Uint8List? pngBytes = await _captureScreenshot();
      // Retry once if capture failed
      if (pngBytes == null) {
        await Future.delayed(const Duration(milliseconds: 300));
        pngBytes = await _captureScreenshot();
      }

      setState(() => _snapMode = false);

      if (pngBytes == null || reportId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Screenshot failed. Press Send again to retry (report no. is saved).'),
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // Step 4: Convert PNG → PDF
      final pdfBytes = await _imageToPdf(pngBytes);

      // Save PDF to draft (for retry if upload fails)
      if (_draftId != null) {
        await LocalDb().savePdfData(_draftId!, pdfBytes);
      }

      // Step 5: Upload PDF
      final uploadResult = await ReportApi().uploadPdf(reportId, pdfBytes);

      // Clear PDF data from draft after successful upload
      if (_draftId != null) {
        await LocalDb().clearPdfData(_draftId!);
      }

      final status = uploadResult['status'] as String?;
      if (mounted) {
        if (status == 'email_failed') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report saved but email failed. You can retry from Report History.'),
              duration: Duration(seconds: 4),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Success'),
              content: Text('Report submitted.\nReport No: $reportNo'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context, true);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Send failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() { _isSending = false; _snapMode = false; });
    }
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
      key: _captureKey,
      child: UnconstrainedBox(
  alignment: Alignment.topLeft,
  child: LayoutBuilder(
  builder: (context, constraints) {
    final availableWidth = constraints.maxWidth;

    final fixedTotal = 1012.0;
    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal).clamp(0.0, double.infinity);
    final flexUnit = availableWidth.isInfinite ? 200.0 : flexSpace / 0.001000;
    final colWidths = <double>[
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
      23.0,
    ];

    final rowHeights = <double>[28.0, 28.0, 36.0, 36.0, 56.0, 26.0, 26.0, 50.0, 50.0, 50.0, 50.0, 28.0, 46.0, 62.0, 34.0, 59.0, 59.0, 59.0, 59.0, 59.0, 59.0, 59.0, 59.0, 59.0, 59.0, 44.0, 40.0, 24.0, 26.0, 26.0, 26.0, 45.0, 24.0, 26.0, 26.0, 26.0, 28.0, 36.0, 28.0, 28.0, 28.0, 28.0, 28.0, 36.0, 28.0, 28.0];

    final cs = <double>[0.0];
    for (final w in colWidths) { cs.add(cs.last + w); }
    final rs = <double>[0.0];
    for (final h in rowHeights) { rs.add(rs.last + h); }

    final totalWidth = cs.last;
    final totalHeight = rs.last;

    Positioned cell(int c, int r, int ce, int re,
        {Border? border, Color? bg, EdgeInsets pad = EdgeInsets.zero,
        Alignment align = Alignment.centerLeft, required Widget child}) =>
      Positioned(left: cs[c], top: rs[r], width: cs[ce] - cs[c], height: rs[re] - rs[r],
          child: Container(
              decoration: (border != null || bg != null) ? BoxDecoration(border: border, color: bg) : null,
              padding: pad, alignment: align, child: child));

    final matrixData = <List<int>>[
      <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43],
      <int>[44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87],
      <int>[88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 118, 119, 119, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120],
      <int>[121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 150, 151, 152, 152, 153, 153, 153, 153, 153, 153, 153, 153, 153, 153],
      <int>[154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154],
      <int>[154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154],
      <int>[154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154, 154],
      <int>[155, 155, 155, 155, 155, 155, 155, 155, 155, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156, 156],
      <int>[157, 157, 157, 157, 157, 157, 157, 157, 157, 158, 158, 158, 158, 158, 158, 158, 158, 158, 158, 158, 158, 158, 159, 159, 159, 159, 159, 159, 159, 160, 160, 160, 160, 160, 160, 160, 160, 160, 160, 160, 160, 160, 160, 160],
      <int>[161, 161, 161, 161, 161, 161, 161, 161, 161, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 163, 163, 163, 163, 163, 163, 163, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164],
      <int>[165, 165, 165, 165, 165, 165, 165, 165, 165, 166, 166, 166, 166, 166, 166, 166, 166, 166, 166, 166, 166, 166, 167, 167, 167, 167, 167, 167, 167, 168, 168, 168, 168, 168, 168, 168, 168, 168, 168, 168, 168, 168, 168, 168],
      <int>[169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212],
      <int>[213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213],
      <int>[214, 214, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 216, 216, 216, 216, 216, 217, 217, 217, 217, 217, 217, 217, 217, 217, 217, 217, 217, 217, 217],
      <int>[214, 214, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 216, 216, 216, 216, 216, 218, 218, 218, 218, 218, 218, 218, 219, 219, 219, 219, 219, 219, 219],
      <int>[220, 220, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 221, 222, 222, 222, 222, 222, 223, 223, 223, 223, 223, 223, 223, 224, 224, 224, 224, 224, 224, 224],
      <int>[225, 225, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 227, 227, 227, 227, 227, 228, 228, 228, 228, 228, 228, 228, 229, 229, 229, 229, 229, 229, 229],
      <int>[230, 230, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 232, 232, 232, 232, 232, 233, 233, 233, 233, 233, 233, 233, 234, 234, 234, 234, 234, 234, 234],
      <int>[235, 235, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 237, 237, 237, 237, 237, 238, 238, 238, 238, 238, 238, 238, 239, 239, 239, 239, 239, 239, 239],
      <int>[240, 240, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 241, 242, 242, 242, 242, 242, 243, 243, 243, 243, 243, 243, 243, 244, 244, 244, 244, 244, 244, 244],
      <int>[245, 245, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 247, 247, 247, 247, 247, 248, 248, 248, 248, 248, 248, 248, 249, 249, 249, 249, 249, 249, 249],
      <int>[250, 250, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 251, 252, 252, 252, 252, 252, 253, 253, 253, 253, 253, 253, 253, 254, 254, 254, 254, 254, 254, 254],
      <int>[255, 255, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 256, 257, 257, 257, 257, 257, 258, 258, 258, 258, 258, 258, 258, 259, 259, 259, 259, 259, 259, 259],
      <int>[260, 260, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 261, 262, 262, 262, 262, 262, 263, 263, 263, 263, 263, 263, 263, 264, 264, 264, 264, 264, 264, 264],
      <int>[265, 265, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 266, 267, 267, 267, 267, 267, 268, 268, 268, 268, 268, 268, 268, 269, 269, 269, 269, 269, 269, 269],
      <int>[270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 295, 296, 296, 297, 297, 298, 298, 299, 299, 300, 300, 301, 301, 301, 301, 301, 301, 301],
      <int>[302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302, 302],
      <int>[303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303],
      <int>[303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303],
      <int>[303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303],
      <int>[303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303, 303],
      <int>[304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304, 304],
      <int>[305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305],
      <int>[305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305],
      <int>[305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305],
      <int>[305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305, 305],
      <int>[306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349],
      <int>[350, 351, 352, 353, 353, 355, 355, 355, 355, 355, 355, 355, 355, 355, 355, 355, 355, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 364, 366, 366, 366, 366, 366, 366, 366, 366, 366, 366, 366, 366, 366, 367, 368, 369],
      <int>[370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413],
      <int>[414, 415, 416, 417, 418, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 431, 432, 433],
      <int>[434, 435, 436, 437, 438, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 449, 450, 451],
      <int>[452, 453, 454, 455, 456, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 467, 468, 469],
      <int>[470, 471, 472, 473, 474, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 419, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 430, 485, 486, 487],
      <int>[488, 489, 490, 491, 492, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 493, 516, 516, 516, 516, 516, 516, 516, 516, 516, 516, 516, 516, 516, 516, 516, 516],
      <int>[532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575],
      <int>[576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619],
    ];

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          cell(0, 0, 1, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 0, 2, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 0, 3, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 0, 4, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(4, 0, 5, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(5, 0, 6, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(6, 0, 7, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(7, 0, 8, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(8, 0, 9, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(9, 0, 10, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(10, 0, 11, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(11, 0, 12, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(12, 0, 13, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(13, 0, 14, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(14, 0, 15, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(15, 0, 16, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(16, 0, 17, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(17, 0, 18, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(18, 0, 19, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 0, 20, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 0, 21, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 0, 22, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 0, 23, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 0, 24, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 0, 25, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 0, 26, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 0, 27, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(27, 0, 28, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(28, 0, 29, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(29, 0, 30, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(30, 0, 31, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(31, 0, 32, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(32, 0, 33, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(33, 0, 34, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(34, 0, 35, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(35, 0, 36, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(36, 0, 37, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(37, 0, 38, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(38, 0, 39, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(39, 0, 40, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(40, 0, 41, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(41, 0, 42, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 0, 43, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 0, 44, 1, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(0, 1, 1, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 1, 2, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 1, 3, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 1, 4, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(4, 1, 5, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(5, 1, 6, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(6, 1, 7, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(7, 1, 8, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(8, 1, 9, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(9, 1, 10, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(10, 1, 11, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(11, 1, 12, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(12, 1, 13, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(13, 1, 14, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(14, 1, 15, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(15, 1, 16, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(16, 1, 17, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(17, 1, 18, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(18, 1, 19, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 1, 20, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 1, 21, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 1, 22, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 1, 23, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 1, 24, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 1, 25, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 1, 26, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 1, 27, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(27, 1, 28, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(28, 1, 29, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(29, 1, 30, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(30, 1, 31, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(31, 1, 32, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(32, 1, 33, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(33, 1, 34, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(34, 1, 35, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(35, 1, 36, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(36, 1, 37, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(37, 1, 38, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(38, 1, 39, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(39, 1, 40, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(40, 1, 41, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(41, 1, 42, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 1, 43, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 1, 44, 2, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(0, 2, 1, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 2, 2, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 2, 3, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 2, 4, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(4, 2, 5, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(5, 2, 6, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(6, 2, 7, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(7, 2, 8, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(8, 2, 9, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(9, 2, 10, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.centerRight, child: const SizedBox.shrink()),
          cell(10, 2, 11, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(11, 2, 12, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(12, 2, 13, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(13, 2, 14, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(14, 2, 15, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(15, 2, 16, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(16, 2, 17, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(17, 2, 18, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(18, 2, 19, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 2, 20, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 2, 21, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 2, 22, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 2, 23, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 2, 24, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 2, 25, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 2, 26, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 2, 27, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(27, 2, 28, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(28, 2, 29, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(29, 2, 30, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(30, 2, 32, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.center, child: const SizedBox.shrink()),
          cell(32, 2, 34, 3, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('No.', softWrap: false, overflow: TextOverflow.visible),
              )),
          Positioned(left: cs[34], top: rs[2], width: cs[44] - cs[34], height: rs[3] - rs[2], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _formNoController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration)), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          cell(0, 3, 1, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 3, 2, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 3, 3, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 3, 4, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(4, 3, 5, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(5, 3, 6, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(6, 3, 7, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(7, 3, 8, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(8, 3, 9, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(9, 3, 10, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(10, 3, 11, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(11, 3, 12, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(12, 3, 13, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(13, 3, 14, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(14, 3, 15, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(15, 3, 16, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(16, 3, 17, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(17, 3, 18, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(18, 3, 19, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 3, 20, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 3, 21, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 3, 22, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 3, 23, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 3, 24, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 3, 25, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 3, 26, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 3, 27, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(27, 3, 28, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(28, 3, 29, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(29, 3, 31, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.center, child: const SizedBox.shrink()),
          cell(31, 3, 32, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.center, child: const SizedBox.shrink()),
          cell(32, 3, 34, 4, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('Date.', softWrap: false, overflow: TextOverflow.visible),
              )),
          Positioned(left: cs[34], top: rs[3], width: cs[44] - cs[34], height: rs[4] - rs[3], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'form-date', readonly: true, snapMode: _snapMode, value: _formDate, onChanged: (v) => setState(() => _formDate = v))), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[0], top: rs[4], width: cs[44] - cs[0], height: rs[7] - rs[4], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 34.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('MACHINE INSPECTION REPORT', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[0], top: rs[7], width: cs[9] - cs[0], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('CUSTOMER NAME', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[9], top: rs[7], width: cs[44] - cs[9], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'customer_name', source: 'customers', displayFields: 'customer_id,name', fields: 'customer_name', required: true, snapMode: _snapMode, value: _customerNameController.text, onSelected: (v) { if (v != null) { _customerNameController.text = v['name'] as String? ?? ''; setState(() {}); } }))),
          Positioned(left: cs[0], top: rs[8], width: cs[9] - cs[0], height: rs[9] - rs[8], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), left: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('MACHINE MODEL', softWrap: false, overflow: TextOverflow.visible),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.top(color: Color(0xFF000000), width: 1, dotted: true), _DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[9], top: rs[8], width: cs[22] - cs[9], height: rs[9] - rs[8], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'machine_model', source: 'machines', displayFields: 'code,name', fields: 'machine_model', required: true, snapMode: _snapMode, value: _machineModelSearch, onSelected: (v) => _machineModelSearch = v?['machine_model'] as String?)), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[22], top: rs[8], width: cs[29] - cs[22], height: rs[9] - rs[8], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('SERIAL NUMBER', softWrap: false, overflow: TextOverflow.visible),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[29], top: rs[8], width: cs[44] - cs[29], height: rs[9] - rs[8], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _serialNoController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration)), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[0], top: rs[9], width: cs[9] - cs[0], height: rs[10] - rs[9], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), left: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('DATE OF INSTALLATION', softWrap: false, overflow: TextOverflow.visible),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[9], top: rs[9], width: cs[22] - cs[9], height: rs[10] - rs[9], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'install-date', required: true, snapMode: _snapMode, value: _installDate, onChanged: (v) => setState(() => _installDate = v))), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[22], top: rs[9], width: cs[29] - cs[22], height: rs[10] - rs[9], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('*******(Free)', softWrap: false, overflow: TextOverflow.visible),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[29], top: rs[9], width: cs[44] - cs[29], height: rs[10] - rs[9], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _installFreeController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration)), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 1, dotted: true)]))))])),
          Positioned(left: cs[0], top: rs[10], width: cs[9] - cs[0], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('INSPECTION DATE', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[9], top: rs[10], width: cs[22] - cs[9], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'inspection-date', required: true, snapMode: _snapMode, value: _inspectionDate, onChanged: (v) => setState(() => _inspectionDate = v)))),
          Positioned(left: cs[22], top: rs[10], width: cs[29] - cs[22], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('INSPECTOR BY', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[29], top: rs[10], width: cs[44] - cs[29], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _inspectorByController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[11], width: cs[1] - cs[0], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[11], width: cs[2] - cs[1], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[11], width: cs[3] - cs[2], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[11], width: cs[4] - cs[3], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[11], width: cs[5] - cs[4], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[11], width: cs[6] - cs[5], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[11], width: cs[7] - cs[6], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[11], width: cs[8] - cs[7], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[11], width: cs[9] - cs[8], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[11], width: cs[10] - cs[9], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[11], width: cs[11] - cs[10], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[11], width: cs[12] - cs[11], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[11], width: cs[13] - cs[12], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[11], width: cs[14] - cs[13], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[11], width: cs[15] - cs[14], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[11], width: cs[16] - cs[15], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[11], width: cs[17] - cs[16], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[11], width: cs[18] - cs[17], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[11], width: cs[19] - cs[18], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[11], width: cs[20] - cs[19], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[11], width: cs[21] - cs[20], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[11], width: cs[22] - cs[21], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[11], width: cs[23] - cs[22], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[11], width: cs[24] - cs[23], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[11], width: cs[25] - cs[24], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[11], width: cs[26] - cs[25], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[11], width: cs[27] - cs[26], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[11], width: cs[28] - cs[27], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[11], width: cs[29] - cs[28], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[11], width: cs[30] - cs[29], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[11], width: cs[31] - cs[30], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[11], width: cs[32] - cs[31], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[11], width: cs[33] - cs[32], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[11], width: cs[34] - cs[33], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[11], width: cs[35] - cs[34], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[11], width: cs[36] - cs[35], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[11], width: cs[37] - cs[36], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[11], width: cs[38] - cs[37], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[11], width: cs[39] - cs[38], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[11], width: cs[40] - cs[39], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[11], width: cs[41] - cs[40], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[11], width: cs[42] - cs[41], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[11], width: cs[43] - cs[42], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[11], width: cs[44] - cs[43], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[12], width: cs[44] - cs[0], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 26.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('INSPECTION RESULT', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[0], top: rs[13], width: cs[2] - cs[0], height: rs[15] - rs[13], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 18.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('ITEM', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[13], width: cs[25] - cs[2], height: rs[15] - rs[13], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 18.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('INSPECTION ITEMS', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[25], top: rs[13], width: cs[30] - cs[25], height: rs[15] - rs[13], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Cordia New', fontSize: 18.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                  children: [
                    TextSpan(text: 'STANDARD TOLERANCE', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF000000), fontSize: 18.6, fontFamily: 'Cordia New')),
                  ],
                ),
              ))),
          Positioned(left: cs[30], top: rs[13], width: cs[44] - cs[30], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Result', sz: 18.6, bold: true, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[14], width: cs[37] - cs[30], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 18.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('CHECKED', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[37], top: rs[14], width: cs[44] - cs[37], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 18.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('AFTER ADJUST', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[0], top: rs[15], width: cs[2] - cs[0], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('1', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[15], width: cs[25] - cs[2], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(0), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[15], width: cs[30] - cs[25], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(0), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[15], width: cs[37] - cs[30], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem1Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[15], width: cs[44] - cs[37], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj1Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[16], width: cs[2] - cs[0], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('2', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[16], width: cs[25] - cs[2], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(1), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[16], width: cs[30] - cs[25], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(1), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[16], width: cs[37] - cs[30], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem2Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[16], width: cs[44] - cs[37], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj2Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[17], width: cs[2] - cs[0], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('3', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[17], width: cs[25] - cs[2], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(2), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[17], width: cs[30] - cs[25], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(2), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[17], width: cs[37] - cs[30], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem3Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[17], width: cs[44] - cs[37], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj3Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[18], width: cs[2] - cs[0], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('4', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[18], width: cs[25] - cs[2], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(3), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[18], width: cs[30] - cs[25], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(3), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[18], width: cs[37] - cs[30], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem4Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[18], width: cs[44] - cs[37], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj4Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[19], width: cs[2] - cs[0], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('5', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[19], width: cs[25] - cs[2], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(4), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[19], width: cs[30] - cs[25], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(4), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[19], width: cs[37] - cs[30], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem5Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[19], width: cs[44] - cs[37], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj5Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[20], width: cs[2] - cs[0], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('6', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[20], width: cs[25] - cs[2], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(5), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[20], width: cs[30] - cs[25], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(5), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[20], width: cs[37] - cs[30], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem6Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[20], width: cs[44] - cs[37], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj6Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[21], width: cs[2] - cs[0], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('7', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[21], width: cs[25] - cs[2], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(6), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[21], width: cs[30] - cs[25], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(6), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[21], width: cs[37] - cs[30], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem7Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[21], width: cs[44] - cs[37], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj7Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[22], width: cs[2] - cs[0], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('8', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[22], width: cs[25] - cs[2], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(7), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[22], width: cs[30] - cs[25], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(7), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[22], width: cs[37] - cs[30], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem8Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[22], width: cs[44] - cs[37], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj8Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[23], width: cs[2] - cs[0], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('9', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[23], width: cs[25] - cs[2], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(8), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[23], width: cs[30] - cs[25], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(8), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[23], width: cs[37] - cs[30], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem9Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[23], width: cs[44] - cs[37], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj9Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[24], width: cs[2] - cs[0], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('10', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[2], top: rs[24], width: cs[25] - cs[2], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text(_itemName(9), softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[25], top: rs[24], width: cs[30] - cs[25], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t(_itemSpec(9), sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New', align: TextAlign.center))),
          Positioned(left: cs[30], top: rs[24], width: cs[37] - cs[30], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _checkItem10Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[37], top: rs[24], width: cs[44] - cs[37], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _afterAdj10Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[25], width: cs[12] - cs[0], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('INSPECTION RESULT', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[12], top: rs[25], width: cs[13] - cs[12], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[25], width: cs[14] - cs[13], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[25], width: cs[15] - cs[14], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[25], width: cs[16] - cs[15], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[25], width: cs[17] - cs[16], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[25], width: cs[18] - cs[17], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[25], width: cs[19] - cs[18], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[25], width: cs[20] - cs[19], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[25], width: cs[21] - cs[20], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[25], width: cs[22] - cs[21], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[25], width: cs[23] - cs[22], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[25], width: cs[24] - cs[23], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[25], width: cs[25] - cs[24], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[25], width: cs[27] - cs[25], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _inputResultOkController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[27], top: rs[25], width: cs[29] - cs[27], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('OK', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[29], top: rs[25], width: cs[31] - cs[29], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _inputResultNgController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[31], top: rs[25], width: cs[33] - cs[31], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3),
                child: Text('NG', softWrap: false, overflow: TextOverflow.ellipsis),
              ))),
          Positioned(left: cs[33], top: rs[25], width: cs[35] - cs[33], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _inputResultOtherController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[35], top: rs[25], width: cs[37] - cs[35], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Other', sz: 21.3, color: Color(0xFF000000), ff: 'Cordia New'))),
          Positioned(left: cs[37], top: rs[25], width: cs[44] - cs[37], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _inputOtherCommentController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[26], width: cs[44] - cs[0], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.topLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('INSPECTION HANDLING:', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[0], top: rs[27], width: cs[44] - cs[0], height: rs[31] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _textareaHandlingController, maxLines: 3, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[0], top: rs[31], width: cs[44] - cs[0], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.topLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('REMARK:', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[0], top: rs[32], width: cs[44] - cs[0], height: rs[36] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(left: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _remarkController, maxLines: 3, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          cell(0, 36, 1, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(1, 36, 2, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(2, 36, 3, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(3, 36, 4, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(4, 36, 5, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(5, 36, 6, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(6, 36, 7, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(7, 36, 8, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(8, 36, 9, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(9, 36, 10, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(10, 36, 11, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(11, 36, 12, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(12, 36, 13, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(13, 36, 14, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(14, 36, 15, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(15, 36, 16, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(16, 36, 17, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(17, 36, 18, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(18, 36, 19, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(19, 36, 20, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(20, 36, 21, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(21, 36, 22, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(22, 36, 23, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(23, 36, 24, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(24, 36, 25, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(25, 36, 26, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(26, 36, 27, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(27, 36, 28, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(28, 36, 29, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(29, 36, 30, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(30, 36, 31, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(31, 36, 32, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(32, 36, 33, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(33, 36, 34, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(34, 36, 35, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(35, 36, 36, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(36, 36, 37, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(37, 36, 38, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(38, 36, 39, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(39, 36, 40, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(40, 36, 41, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(41, 36, 42, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(42, 36, 43, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(43, 36, 44, 37, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(0, 37, 1, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(1, 37, 2, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.center, child: const SizedBox.shrink()),
          cell(2, 37, 3, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.center, child: const SizedBox.shrink()),
          cell(3, 37, 5, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('Date', softWrap: false, overflow: TextOverflow.visible),
              )),
          Positioned(left: cs[5], top: rs[37], width: cs[18] - cs[5], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'date-customer-sign', required: true, snapMode: _snapMode, value: _dateCustomerSign, onChanged: (v) => setState(() => _dateCustomerSign = v)))),
          cell(18, 37, 19, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 37, 20, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 37, 21, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 37, 22, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 37, 23, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 37, 24, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 37, 25, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 37, 26, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 37, 28, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('Date', softWrap: false, overflow: TextOverflow.visible),
              )),
          Positioned(left: cs[28], top: rs[37], width: cs[41] - cs[28], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'date-engineer-sign', required: true, snapMode: _snapMode, value: _dateEngineerSign, onChanged: (v) => setState(() => _dateEngineerSign = v)))),
          cell(41, 37, 42, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 37, 43, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 37, 44, 38, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(0, 38, 1, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(1, 38, 2, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 38, 3, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 38, 4, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(4, 38, 5, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[5], top: rs[38], width: cs[6] - cs[5], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[38], width: cs[7] - cs[6], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[38], width: cs[8] - cs[7], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[38], width: cs[9] - cs[8], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[38], width: cs[10] - cs[9], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[38], width: cs[11] - cs[10], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[38], width: cs[12] - cs[11], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[38], width: cs[13] - cs[12], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[38], width: cs[14] - cs[13], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[38], width: cs[15] - cs[14], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[38], width: cs[16] - cs[15], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[38], width: cs[17] - cs[16], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[38], width: cs[18] - cs[17], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          cell(18, 38, 19, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 38, 20, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 38, 21, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 38, 22, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 38, 23, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 38, 24, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 38, 25, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 38, 26, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 38, 27, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(27, 38, 28, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[28], top: rs[38], width: cs[29] - cs[28], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[38], width: cs[30] - cs[29], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[38], width: cs[31] - cs[30], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[38], width: cs[32] - cs[31], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[38], width: cs[33] - cs[32], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[38], width: cs[34] - cs[33], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[38], width: cs[35] - cs[34], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[38], width: cs[36] - cs[35], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[38], width: cs[37] - cs[36], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[38], width: cs[38] - cs[37], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[38], width: cs[39] - cs[38], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[38], width: cs[40] - cs[39], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[38], width: cs[41] - cs[40], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          cell(41, 38, 42, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 38, 43, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 38, 44, 39, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topLeft, child: const SizedBox.shrink()),
          cell(0, 39, 1, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 39, 2, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 39, 3, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 39, 4, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[4], top: rs[39], width: cs[5] - cs[4], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[39], width: cs[18] - cs[5], height: rs[43] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'customer-sign', snapMode: _snapMode, initialData: _customerSignBytes, onSigned: (v) => _onCustomerSigned(v)))),
          cell(18, 39, 19, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 39, 20, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 39, 21, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 39, 22, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 39, 23, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 39, 24, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 39, 25, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 39, 26, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 39, 27, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[27], top: rs[39], width: cs[28] - cs[27], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[39], width: cs[41] - cs[28], height: rs[43] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'engineer-sign', snapMode: _snapMode, initialData: _engineerSignBytes, onSigned: (v) => _onEngineerSigned(v)))),
          cell(41, 39, 42, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 39, 43, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 39, 44, 40, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(0, 40, 1, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 40, 2, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 40, 3, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 40, 4, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[4], top: rs[40], width: cs[5] - cs[4], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          cell(18, 40, 19, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 40, 20, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 40, 21, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 40, 22, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 40, 23, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 40, 24, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 40, 25, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 40, 26, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 40, 27, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[27], top: rs[40], width: cs[28] - cs[27], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          cell(41, 40, 42, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 40, 43, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 40, 44, 41, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(0, 41, 1, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 41, 2, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 41, 3, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 41, 4, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[4], top: rs[41], width: cs[5] - cs[4], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          cell(18, 41, 19, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 41, 20, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 41, 21, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 41, 22, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 41, 23, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 41, 24, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 41, 25, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 41, 26, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 41, 27, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[27], top: rs[41], width: cs[28] - cs[27], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          cell(41, 41, 42, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 41, 43, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 41, 44, 42, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(0, 42, 1, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 42, 2, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 42, 3, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 42, 4, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[4], top: rs[42], width: cs[5] - cs[4], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          cell(18, 42, 19, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 42, 20, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 42, 21, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 42, 22, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 42, 23, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 42, 24, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 42, 25, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 42, 26, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 42, 27, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned(left: cs[27], top: rs[42], width: cs[28] - cs[27], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          cell(41, 42, 42, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 42, 43, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 42, 44, 43, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(0, 43, 1, 44, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 43, 2, 44, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 43, 3, 44, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.centerRight, child: const SizedBox.shrink()),
          cell(3, 43, 4, 44, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(4, 43, 5, 44, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(5, 43, 28, 44, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('ลายเซ็นลูกค้า Customers authorized signature', softWrap: false, overflow: TextOverflow.visible),
              )),
          cell(28, 43, 44, 44, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Cordia New', fontSize: 21.3, color: Color(0xFF000000)),
                child: Text('ลายเซ็นวิศวกร Service Engineer signature', softWrap: false, overflow: TextOverflow.visible),
              )),
          cell(0, 44, 1, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 44, 2, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 44, 3, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 44, 4, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(4, 44, 5, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(5, 44, 6, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(6, 44, 7, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(7, 44, 8, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(8, 44, 9, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(9, 44, 10, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(10, 44, 11, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(11, 44, 12, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(12, 44, 13, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(13, 44, 14, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(14, 44, 15, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(15, 44, 16, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(16, 44, 17, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(17, 44, 18, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(18, 44, 19, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 44, 20, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 44, 21, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 44, 22, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 44, 23, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 44, 24, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 44, 25, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 44, 26, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 44, 27, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(27, 44, 28, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(28, 44, 29, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(29, 44, 30, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(30, 44, 31, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(31, 44, 32, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(32, 44, 33, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(33, 44, 34, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(34, 44, 35, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(35, 44, 36, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(36, 44, 37, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(37, 44, 38, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(38, 44, 39, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(39, 44, 40, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(40, 44, 41, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(41, 44, 42, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 44, 43, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 44, 44, 45, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(0, 45, 1, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(1, 45, 2, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(2, 45, 3, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(3, 45, 4, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(4, 45, 5, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(5, 45, 6, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(6, 45, 7, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(7, 45, 8, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(8, 45, 9, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(9, 45, 10, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(10, 45, 11, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(11, 45, 12, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(12, 45, 13, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(13, 45, 14, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(14, 45, 15, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(15, 45, 16, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(16, 45, 17, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(17, 45, 18, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(18, 45, 19, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(19, 45, 20, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(20, 45, 21, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(21, 45, 22, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(22, 45, 23, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(23, 45, 24, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(24, 45, 25, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(25, 45, 26, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(26, 45, 27, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(27, 45, 28, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(28, 45, 29, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(29, 45, 30, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(30, 45, 31, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(31, 45, 32, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(32, 45, 33, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(33, 45, 34, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(34, 45, 35, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(35, 45, 36, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(36, 45, 37, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(37, 45, 38, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(38, 45, 39, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(39, 45, 40, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(40, 45, 41, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(41, 45, 42, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(42, 45, 43, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          cell(43, 45, 44, 46, bg: Color(0xFFFFFFFF), pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: const SizedBox.shrink()),
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(
              painter: _TableGridPainter(
                colStarts: cs,
                rowStarts: rs,
                borderColor: Colors.black,
                borderWidth: 0.0,
                matrixData: matrixData,
                numRows: 46,
                numCols: 44,
              ),
            )),
          ),
        ],
      ),
    );
  },
),
),  // end UnconstrainedBox
  );  // end RepaintBoundary
}

// ============ HELPER CLASSES ============
// ── Text helpers ──────────────────────────────────────────────────────────────

Widget _t(String s, {double sz = 16, bool bold = false, Color? color, String ff = 'Browallia New', TextAlign? align}) =>
    Text(s, style: TextStyle(fontFamily: ff, fontSize: sz, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: color), softWrap: true, overflow: TextOverflow.clip, textAlign: align);

Widget _rt(List<(String, bool)> spans, {double sz = 16, String ff = 'Browallia New', TextAlign align = TextAlign.start}) =>
    RichText(softWrap: true, overflow: TextOverflow.clip, textAlign: align,
        text: TextSpan(style: TextStyle(fontFamily: ff, fontSize: sz),
            children: [for (final (t, b) in spans) TextSpan(text: t, style: b ? const TextStyle(fontWeight: FontWeight.bold) : null)]));

// ── Border helpers ────────────────────────────────────────────────────────────

const _bk = Colors.black;

class _TableGridPainter extends CustomPainter {
  final List<double> colStarts;
  final List<double> rowStarts;
  final Color borderColor;
  final double borderWidth;
  final List<List<int>> matrixData;
  final int numRows;
  final int numCols;

  const _TableGridPainter({
    required this.colStarts,
    required this.rowStarts,
    required this.borderColor,
    required this.borderWidth,
    required this.matrixData,
    required this.numRows,
    required this.numCols,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth == 0) return;
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        if (c >= colStarts.length - 1 || r >= rowStarts.length - 1) continue;
        final idx = (r < matrixData.length && c < matrixData[r].length)
            ? matrixData[r][c]
            : -1;
        if (idx < 0) continue;
        final sameAsLeft  = c > 0 && matrixData[r][c - 1] == idx;
        final sameAsAbove = r > 0 && matrixData[r - 1][c] == idx;
        if (sameAsLeft || sameAsAbove) continue;
        int endC = c + 1;
        while (endC < numCols && endC < matrixData[r].length && matrixData[r][endC] == idx) endC++;
        int endR = r + 1;
        while (endR < numRows && endR < matrixData.length && matrixData[endR][c] == idx) endR++;
        final right  = endC < colStarts.length ? colStarts[endC] : colStarts.last;
        final bottom = endR < rowStarts.length ? rowStarts[endR] : rowStarts.last;
        canvas.drawRect(Rect.fromLTRB(colStarts[c], rowStarts[r], right, bottom), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TableGridPainter old) =>
      old.borderColor != borderColor || old.borderWidth != borderWidth;
}

class _DashSide {
  final Color color;
  final double width;
  final bool dotted;
  final String side;
  const _DashSide._(this.side, {required this.color, required this.width, this.dotted = false});
  const _DashSide.top({required Color color, required double width, bool dotted = false}) : this._('top', color: color, width: width, dotted: dotted);
  const _DashSide.right({required Color color, required double width, bool dotted = false}) : this._('right', color: color, width: width, dotted: dotted);
  const _DashSide.bottom({required Color color, required double width, bool dotted = false}) : this._('bottom', color: color, width: width, dotted: dotted);
  const _DashSide.left({required Color color, required double width, bool dotted = false}) : this._('left', color: color, width: width, dotted: dotted);
}

class _DashedBorderPainter extends CustomPainter {
  final List<_DashSide> sides;
  const _DashedBorderPainter({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sides) {
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = s.width
        ..style = PaintingStyle.stroke;
      final dashLen = s.dotted ? s.width : s.width * 3;
      final gapLen = s.dotted ? s.width * 2 : s.width * 3;
      switch (s.side) {
        case 'top':    _drawDash(canvas, paint, Offset.zero, Offset(size.width, 0), dashLen, gapLen); break;
        case 'bottom': _drawDash(canvas, paint, Offset(0, size.height), Offset(size.width, size.height), dashLen, gapLen); break;
        case 'left':   _drawDash(canvas, paint, Offset.zero, Offset(0, size.height), dashLen, gapLen); break;
        case 'right':  _drawDash(canvas, paint, Offset(size.width, 0), Offset(size.width, size.height), dashLen, gapLen); break;
      }
    }
  }

  void _drawDash(Canvas canvas, Paint paint, Offset start, Offset end, double dashLen, double gapLen) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final totalLen = math.sqrt(dx * dx + dy * dy);
    if (totalLen == 0) return;
    final ux = dx / totalLen;
    final uy = dy / totalLen;
    double pos = 0;
    bool draw = true;
    while (pos < totalLen) {
      final double seg = draw ? dashLen : gapLen;
      final double segEnd = (pos + seg).clamp(0.0, totalLen);
      if (draw) {
        canvas.drawLine(
          Offset(start.dx + ux * pos, start.dy + uy * pos),
          Offset(start.dx + ux * segEnd, start.dy + uy * segEnd),
          paint,
        );
      }
      pos = segEnd;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => true;
}