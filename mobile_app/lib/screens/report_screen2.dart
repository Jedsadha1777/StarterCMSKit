// ─────────────────────────────────────────────────────────────────────────
// FORM SUFFIX: "1"
//   Classes in this file: FormWidget1, FormWidgetState1
//
// หากต้องการ integrate หลายฟอร์มในโปรเจ็กต์เดียวกัน — rename ใน IDE:
//   FormWidget1  →  FormWidget2 (หรือชื่ออื่น)
//   FormWidgetState1  →  FormWidgetState2
// VS Code: F2 บน class name | JetBrains: Shift+F6
// ─────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:uuid/uuid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'form_widgets/form_widgets.dart';
import 'preview_shell.dart';
import '../services/local_db.dart';
import '../services/api/report_api.dart';
import '../services/connectivity_service.dart';
import 'email_dialog.dart';

void main() => runApp(const ReportScreen2());

class ReportScreen2 extends StatefulWidget {
  const ReportScreen2({super.key});
  @override
  State<ReportScreen2> createState() => ReportScreen2State();
}

class ReportScreen2State extends State<ReportScreen2> {

  // ============ CONTROLLERS ============
  final _timeinController = TextEditingController();
  final _timeoutController = TextEditingController();
  final _customerContactController = TextEditingController();
  final _modelNameController = TextEditingController();
  final _serialNoController = TextEditingController();
  final _detailsOfServiceController = TextEditingController();
  final _recommendationsController = TextEditingController();
  final _partId1Controller = TextEditingController();
  final _partName1Controller = TextEditingController();
  final _partNo1Controller = TextEditingController();
  final _partQtr1Controller = TextEditingController();
  final _partUnitPrice1Controller = TextEditingController();
  final _partTotal1Controller = TextEditingController();
  final _partId2Controller = TextEditingController();
  final _partName2Controller = TextEditingController();
  final _partNo2Controller = TextEditingController();
  final _partQtr2Controller = TextEditingController();
  final _partUnitPrice2Controller = TextEditingController();
  final _partTotal2Controller = TextEditingController();
  final _partId3Controller = TextEditingController();
  final _partName3Controller = TextEditingController();
  final _partNo3Controller = TextEditingController();
  final _partQtr3Controller = TextEditingController();
  final _partUnitPrice3Controller = TextEditingController();
  final _partTotal3Controller = TextEditingController();
  final _partId4Controller = TextEditingController();
  final _partName4Controller = TextEditingController();
  final _partNo4Controller = TextEditingController();
  final _partQtr4Controller = TextEditingController();
  final _partUnitPrice4Controller = TextEditingController();
  final _partTotal4Controller = TextEditingController();
  final _partId5Controller = TextEditingController();
  final _partName5Controller = TextEditingController();
  final _partNo5Controller = TextEditingController();
  final _partQtr5Controller = TextEditingController();
  final _partUnitPrice5Controller = TextEditingController();
  final _partTotal5Controller = TextEditingController();
  final _partId6Controller = TextEditingController();
  final _partName6Controller = TextEditingController();
  final _partNo6Controller = TextEditingController();
  final _partQtr6Controller = TextEditingController();
  final _partUnitPrice6Controller = TextEditingController();
  final _partTotal6Controller = TextEditingController();
  final _partId7Controller = TextEditingController();
  final _partName7Controller = TextEditingController();
  final _partNo7Controller = TextEditingController();
  final _partQtr7Controller = TextEditingController();
  final _partUnitPrice7Controller = TextEditingController();
  final _partTotal7Controller = TextEditingController();
  final _partId8Controller = TextEditingController();
  final _partName8Controller = TextEditingController();
  final _partNo8Controller = TextEditingController();
  final _partQtr8Controller = TextEditingController();
  final _partUnitPrice8Controller = TextEditingController();
  final _partTotal8Controller = TextEditingController();
  final _partId9Controller = TextEditingController();
  final _partName9Controller = TextEditingController();
  final _partNo9Controller = TextEditingController();
  final _partQtr9Controller = TextEditingController();
  final _partUnitPrice9Controller = TextEditingController();
  final _partTotal9Controller = TextEditingController();
  final _partId10Controller = TextEditingController();
  final _partName10Controller = TextEditingController();
  final _partNo10Controller = TextEditingController();
  final _partQtr10Controller = TextEditingController();
  final _partUnitPrice10Controller = TextEditingController();
  final _partTotal10Controller = TextEditingController();
  final _partId11Controller = TextEditingController();
  final _partName11Controller = TextEditingController();
  final _partNo11Controller = TextEditingController();
  final _partQtr11Controller = TextEditingController();
  final _partUnitPrice11Controller = TextEditingController();
  final _partTotal11Controller = TextEditingController();
  final _partId12Controller = TextEditingController();
  final _partName12Controller = TextEditingController();
  final _partNo12Controller = TextEditingController();
  final _partQtr12Controller = TextEditingController();
  final _partUnitPrice12Controller = TextEditingController();
  final _partTotal12Controller = TextEditingController();
  final _partId13Controller = TextEditingController();
  final _partName13Controller = TextEditingController();
  final _partNo13Controller = TextEditingController();
  final _partQtr13Controller = TextEditingController();
  final _partUnitPrice13Controller = TextEditingController();
  final _partTotal13Controller = TextEditingController();
  final _partId14Controller = TextEditingController();
  final _partName14Controller = TextEditingController();
  final _partNo14Controller = TextEditingController();
  final _partQtr14Controller = TextEditingController();
  final _partUnitPrice14Controller = TextEditingController();
  final _partTotal14Controller = TextEditingController();
  final _partId15Controller = TextEditingController();
  final _partName15Controller = TextEditingController();
  final _partNo15Controller = TextEditingController();
  final _partQtr15Controller = TextEditingController();
  final _partUnitPrice15Controller = TextEditingController();
  final _partTotal15Controller = TextEditingController();
  final _partSumTotalController = TextEditingController();
  final _serviceChargeRateController = TextEditingController();
  final _serviceChargeHourController = TextEditingController();
  final _partServiceChargeController = TextEditingController();
  final _partGrandTotalController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _serviceStaffNameController = TextEditingController();

  Map<String, TextEditingController> get _controllerMap => {
    'timein': _timeinController,
    'timeout': _timeoutController,
    'customerContact': _customerContactController,
    'modelName': _modelNameController,
    'serialNo': _serialNoController,
    'detailsOfService': _detailsOfServiceController,
    'recommendations': _recommendationsController,
    'partId1': _partId1Controller,
    'partName1': _partName1Controller,
    'partNo1': _partNo1Controller,
    'partQtr1': _partQtr1Controller,
    'partUnitPrice1': _partUnitPrice1Controller,
    'partTotal1': _partTotal1Controller,
    'partId2': _partId2Controller,
    'partName2': _partName2Controller,
    'partNo2': _partNo2Controller,
    'partQtr2': _partQtr2Controller,
    'partUnitPrice2': _partUnitPrice2Controller,
    'partTotal2': _partTotal2Controller,
    'partId3': _partId3Controller,
    'partName3': _partName3Controller,
    'partNo3': _partNo3Controller,
    'partQtr3': _partQtr3Controller,
    'partUnitPrice3': _partUnitPrice3Controller,
    'partTotal3': _partTotal3Controller,
    'partId4': _partId4Controller,
    'partName4': _partName4Controller,
    'partNo4': _partNo4Controller,
    'partQtr4': _partQtr4Controller,
    'partUnitPrice4': _partUnitPrice4Controller,
    'partTotal4': _partTotal4Controller,
    'partId5': _partId5Controller,
    'partName5': _partName5Controller,
    'partNo5': _partNo5Controller,
    'partQtr5': _partQtr5Controller,
    'partUnitPrice5': _partUnitPrice5Controller,
    'partTotal5': _partTotal5Controller,
    'partId6': _partId6Controller,
    'partName6': _partName6Controller,
    'partNo6': _partNo6Controller,
    'partQtr6': _partQtr6Controller,
    'partUnitPrice6': _partUnitPrice6Controller,
    'partTotal6': _partTotal6Controller,
    'partId7': _partId7Controller,
    'partName7': _partName7Controller,
    'partNo7': _partNo7Controller,
    'partQtr7': _partQtr7Controller,
    'partUnitPrice7': _partUnitPrice7Controller,
    'partTotal7': _partTotal7Controller,
    'partId8': _partId8Controller,
    'partName8': _partName8Controller,
    'partNo8': _partNo8Controller,
    'partQtr8': _partQtr8Controller,
    'partUnitPrice8': _partUnitPrice8Controller,
    'partTotal8': _partTotal8Controller,
    'partId9': _partId9Controller,
    'partName9': _partName9Controller,
    'partNo9': _partNo9Controller,
    'partQtr9': _partQtr9Controller,
    'partUnitPrice9': _partUnitPrice9Controller,
    'partTotal9': _partTotal9Controller,
    'partId10': _partId10Controller,
    'partName10': _partName10Controller,
    'partNo10': _partNo10Controller,
    'partQtr10': _partQtr10Controller,
    'partUnitPrice10': _partUnitPrice10Controller,
    'partTotal10': _partTotal10Controller,
    'partId11': _partId11Controller,
    'partName11': _partName11Controller,
    'partNo11': _partNo11Controller,
    'partQtr11': _partQtr11Controller,
    'partUnitPrice11': _partUnitPrice11Controller,
    'partTotal11': _partTotal11Controller,
    'partId12': _partId12Controller,
    'partName12': _partName12Controller,
    'partNo12': _partNo12Controller,
    'partQtr12': _partQtr12Controller,
    'partUnitPrice12': _partUnitPrice12Controller,
    'partTotal12': _partTotal12Controller,
    'partId13': _partId13Controller,
    'partName13': _partName13Controller,
    'partNo13': _partNo13Controller,
    'partQtr13': _partQtr13Controller,
    'partUnitPrice13': _partUnitPrice13Controller,
    'partTotal13': _partTotal13Controller,
    'partId14': _partId14Controller,
    'partName14': _partName14Controller,
    'partNo14': _partNo14Controller,
    'partQtr14': _partQtr14Controller,
    'partUnitPrice14': _partUnitPrice14Controller,
    'partTotal14': _partTotal14Controller,
    'partId15': _partId15Controller,
    'partName15': _partName15Controller,
    'partNo15': _partNo15Controller,
    'partQtr15': _partQtr15Controller,
    'partUnitPrice15': _partUnitPrice15Controller,
    'partTotal15': _partTotal15Controller,
    'partSumTotal': _partSumTotalController,
    'serviceChargeRate': _serviceChargeRateController,
    'serviceChargeHour': _serviceChargeHourController,
    'partServiceCharge': _partServiceChargeController,
    'partGrandTotal': _partGrandTotalController,
    'customerName': _customerNameController,
    'serviceStaffName': _serviceStaffNameController,
  };

  @override
  void dispose() {
    for (final c in _controllerMap.values) { c.dispose(); }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsLoaded) return;
    _argsLoaded = true;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _machineModel = args?['machineModel'] as Map<String, dynamic>?;
    _draftData = args?['draftData'] as Map<String, dynamic>?;
    if (_draftData != null) {
      _draftId = _draftData!['draft_id'] as String?;
      final formData = _draftData!['form_data'];
      if (formData is Map<String, dynamic>) {
        _restoreData(formData).then((_) { if (mounted) setState(() {}); });
      }
    } else {
      _draftId = const Uuid().v4();
    }
  }

  /// Handle image pick: copy to app-docs/uploads/, update state with absolute path.
  /// Pass xfile=null to clear.
  Future<void> _onImagePicked(String name, XFile? xfile) async {
    if (xfile == null) {
      if (mounted) setState(() => _imageUploadFiles.remove(name));
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    final upDir = Directory('${dir.path}/uploads');
    if (!await upDir.exists()) await upDir.create(recursive: true);
    final srcPath = xfile.path;
    final ext = srcPath.contains('.') ? srcPath.substring(srcPath.lastIndexOf('.')) : '.jpg';
    final filename = '${_draftId}_$name$ext';
    final absPath = '${upDir.path}/$filename';
    await File(srcPath).copy(absPath);
    if (mounted) setState(() => _imageUploadFiles[name] = absPath);
  }

  Future<Map<String, dynamic>> _collectData() async {
    final data = <String, dynamic>{};
    for (final entry in _controllerMap.entries) {
      data[entry.key] = entry.value.text;
    }
    data['visitDate'] = _visitDate;
    data['finishDate'] = _finishDate;
    data['customerNameSearch'] = _customerName;
    data['typeOfService'] = _typeOfService;
    // ลายเซ็น: เก็บ base64 ใน form_data ตรงๆ (ไฟล์เล็ก)
    data['signatureCustomer'] = _signatureCustomerBytes != null ? base64Encode(_signatureCustomerBytes!) : null;
    data['signatureServiceStaff'] = _signatureServiceStaffBytes != null ? base64Encode(_signatureServiceStaffBytes!) : null;
    // Image uploads: เก็บแค่ filename (resolve abs path → filename)
    for (final e in _imageUploadFiles.entries) {
      final p = e.value;
      data[e.key] = p.substring(p.lastIndexOf('/') + 1);
    }
    return data;
  }

  Future<void> _restoreData(Map<String, dynamic> formData) async {
    for (final entry in formData.entries) {
      final ctrl = _controllerMap[entry.key];
      if (ctrl != null && entry.value is String) {
        ctrl.text = entry.value;
        continue;
      }
      switch (entry.key) {
        case 'visitDate': _visitDate = entry.value as String?;
        case 'finishDate': _finishDate = entry.value as String?;
        case 'customerNameSearch': _customerName = entry.value as String?;
        case 'typeOfService': _typeOfService = entry.value as bool? ?? false;
        case 'signatureCustomer':
          if (entry.value is String) _signatureCustomerBytes = base64Decode(entry.value);
        case 'signatureServiceStaff':
          if (entry.value is String) _signatureServiceStaffBytes = base64Decode(entry.value);
        default:
          if (entry.key.startsWith('image-upload-') && entry.value is String) {
            final dir = await getApplicationDocumentsDirectory();
            final absPath = '${dir.path}/uploads/${entry.value}';
            if (await File(absPath).exists()) {
              _imageUploadFiles[entry.key] = absPath;
            }
          }
      }
    }
  }

  Future<void> onSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      await LocalDb().saveDraft(
        draftId: _draftId!,
        machineModelId: _machineModel?['id'] ?? '',
        formData: await _collectData(),
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

  Future<Uint8List?> _captureScreenshot(GlobalKey key) async {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<Uint8List> _imagesToPdf(List<Uint8List> pngList) async {
    final pdf = pw.Document();
    for (final png in pngList) {
      final image = pw.MemoryImage(png);
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (ctx) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      ));
    }
    return pdf.save();
  }

  Future<void> onSend() async {
    if (_isSending) return;

    // Always persist current form state before anything else — so data survives
    // validation failures, email-dialog cancel, or network errors.
    final collected = await _collectData();
    await LocalDb().saveDraft(
      draftId: _draftId!,
      machineModelId: _machineModel?['id'] ?? '',
      formData: collected,
    );

    if (!ConnectivityService().isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please save as draft.')),
      );
      return;
    }

    final missing = <String>[];
    if (_customerNameController.text.trim().isEmpty) missing.add('Customer Name');
    if (_serialNoController.text.trim().isEmpty) missing.add('Serial No');
    if (_visitDate == null || _visitDate!.isEmpty) missing.add('Visit Date');
    if (_serviceStaffNameController.text.trim().isEmpty) missing.add('Service Staff Name');
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

    if (_signatureCustomerBytes == null || _signatureServiceStaffBytes == null) {
      if (mounted) {
        final missingSigns = <String>[];
        if (_signatureCustomerBytes == null) missingSigns.add('Customer signature');
        if (_signatureServiceStaffBytes == null) missingSigns.add('Service staff signature');
        showDialog(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Signature Required'),
          content: Text('Missing:\n${missingSigns.join('\n')}'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ));
      }
      return;
    }

    final emails = await showEmailDialog(context);
    if (emails == null || emails.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Send cancelled (no recipient email).')),
        );
      }
      return;
    }

    setState(() => _isSending = true);
    try {
      String? reportNo;
      String? reportId;

      final existingDraft = await LocalDb().loadDraft(_draftId!);
      final existingReportId = existingDraft?['report_public_id'] as String?;
      if (existingReportId != null && existingReportId.isNotEmpty) {
        reportId = existingReportId;
        reportNo = existingDraft?['report_no'] as String?;
      }

      if (reportId == null) {
        // image uploads ส่งเป็น multipart attachments แยก — strip ออกจาก JSON
        final jsonData = Map<String, dynamic>.from(collected);
        for (final key in _imageUploadFiles.keys) {
          jsonData.remove(key);
        }
        final result = await ReportApi().submitReport(
          formData: jsonData,
          recipientEmails: emails,
          machineModelId: _machineModel?['id'] ?? '',
          serialNo: _serialNoController.text,
          inspectorName: _serviceStaffNameController.text,
          inspectedAt: _visitDate,
          imageAttachments: _imageUploadFiles.isEmpty ? null : _imageUploadFiles,
        );
        reportNo = result['report_no'] as String?;
        reportId = result['id'] as String?;
        if (_draftId != null && reportId != null) {
          await LocalDb().updateDraftStatus(_draftId!, 'sent', reportNo: reportNo, reportPublicId: reportId);
        }
      }

      setState(() => _snapMode = true);
      await Future.delayed(const Duration(milliseconds: 200));

      final pages = <Uint8List>[];
      for (final key in [_captureKey, _captureKey2]) {
        Uint8List? png = await _captureScreenshot(key);
        if (png == null) {
          await Future.delayed(const Duration(milliseconds: 300));
          png = await _captureScreenshot(key);
        }
        if (png != null) pages.add(png);
      }

      setState(() => _snapMode = false);

      if (pages.isEmpty || reportId == null) {
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

      final pdfBytes = await _imagesToPdf(pages);
      if (_draftId != null) {
        await LocalDb().savePdfData(_draftId!, pdfBytes);
      }

      final uploadResult = await ReportApi().uploadPdf(reportId, pdfBytes);

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


  // ============ STATE VARIABLES ============
  bool _snapMode = false;
  final GlobalKey _captureKey = GlobalKey();
  final GlobalKey _captureKey2 = GlobalKey();

  String? _draftId;
  bool _isSaving = false;
  bool _isSending = false;
  bool _argsLoaded = false;
  Map<String, dynamic>? _machineModel;
  Map<String, dynamic>? _draftData;

  String? _visitDate;
  String? _finishDate;
  String? _customerName;
  Uint8List? _signatureCustomerBytes;
  Uint8List? _signatureServiceStaffBytes;
  bool _typeOfService = false;

  // Map<fieldName, absolute-path> (file lives under app-docs/uploads/)
  final Map<String, String> _imageUploadFiles = {};

  InputDecoration get _inputDecoration => _snapMode
      ? const InputDecoration(border: InputBorder.none, isCollapsed: true)
      : const InputDecoration(border: OutlineInputBorder(), isCollapsed: true);

  @override
  Widget build(BuildContext context) => PreviewShell(
    pages: [
      _page1(),
      _page2(),
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
            ElevatedButton.icon(
              onPressed: _isSaving ? null : onSave,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _isSending ? null : onSend,
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Send'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAD193C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _page1() => RepaintBoundary(key: _captureKey, child: UnconstrainedBox(
  alignment: Alignment.topLeft,
  child: LayoutBuilder(
  builder: (context, constraints) {
    final availableWidth = constraints.maxWidth;

    final fixedTotal = 1012.0;
    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal).clamp(0.0, double.infinity);
    final flexUnit = availableWidth.isInfinite ? 200.0 : flexSpace / 0.001000;
    final colWidths = <double>[
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
    ];

    final rowHeights = <double>[112.0, 20.0, 20.0, 20.0, 40.0, 24.0, 28.0, 28.0, 28.0, 28.0, 20.0, 28.0, 20.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 28.0, 31.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 29.0, 28.0, 29.0, 20.0, 20.0, 20.0, 20.0];

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
      <int>[0, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 23],
      <int>[24, 1, 1, 1, 1, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 45],
      <int>[46, 1, 1, 1, 1, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 67],
      <int>[68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113],
      <int>[114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 134, 135, 135, 135, 135, 135, 135, 141, 141, 141, 141, 141, 141, 141, 142, 143],
      <int>[144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189],
      <int>[190, 191, 191, 191, 191, 191, 192, 192, 192, 192, 192, 192, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 202, 202, 202, 202, 203, 203, 203, 203, 203, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216],
      <int>[217, 218, 218, 218, 218, 218, 219, 219, 219, 219, 219, 219, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 229, 229, 229, 229, 230, 230, 230, 230, 230, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243],
      <int>[244, 245, 245, 245, 245, 245, 245, 245, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 247, 247, 247, 247, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 249],
      <int>[250, 251, 251, 251, 251, 251, 251, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 253, 253, 253, 253, 253, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 255],
      <int>[256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301],
      <int>[302, 303, 304, 304, 304, 304, 304, 304, 304, 304, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 312, 313, 314, 315, 316, 317, 318, 319, 320],
      <int>[321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366],
      <int>[367, 368, 368, 368, 368, 368, 368, 368, 368, 368, 368, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412],
      <int>[413, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 415],
      <int>[416, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 417],
      <int>[418, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 419],
      <int>[420, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 421],
      <int>[422, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 423],
      <int>[424, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 425],
      <int>[426, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 427],
      <int>[428, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 414, 429],
      <int>[430, 431, 431, 431, 431, 431, 431, 431, 431, 431, 431, 431, 431, 431, 431, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461],
      <int>[462, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 464],
      <int>[465, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 466],
      <int>[467, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 468],
      <int>[469, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 470],
      <int>[471, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 463, 472],
      <int>[473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518],
      <int>[519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564],
      <int>[565, 566, 566, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 568, 568, 568, 568, 568, 569, 569, 569, 569, 570, 570, 570, 570, 570, 570, 571, 571, 571, 571, 571, 571, 571, 571, 571, 572],
      <int>[573, 574, 574, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 575, 576, 576, 576, 576, 576, 577, 577, 577, 577, 578, 578, 578, 578, 578, 578, 579, 579, 579, 579, 579, 579, 579, 579, 579, 580],
      <int>[581, 582, 582, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 583, 584, 584, 584, 584, 584, 585, 585, 585, 585, 586, 586, 586, 586, 586, 586, 587, 587, 587, 587, 587, 587, 587, 587, 587, 588],
      <int>[589, 590, 590, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 591, 592, 592, 592, 592, 592, 593, 593, 593, 593, 594, 594, 594, 594, 594, 594, 595, 595, 595, 595, 595, 595, 595, 595, 595, 596],
      <int>[597, 598, 598, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 599, 600, 600, 600, 600, 600, 601, 601, 601, 601, 602, 602, 602, 602, 602, 602, 603, 603, 603, 603, 603, 603, 603, 603, 603, 604],
      <int>[605, 606, 606, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 607, 608, 608, 608, 608, 608, 609, 609, 609, 609, 610, 610, 610, 610, 610, 610, 611, 611, 611, 611, 611, 611, 611, 611, 611, 612],
      <int>[613, 614, 614, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 615, 616, 616, 616, 616, 616, 617, 617, 617, 617, 618, 618, 618, 618, 618, 618, 619, 619, 619, 619, 619, 619, 619, 619, 619, 620],
      <int>[621, 622, 622, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 623, 624, 624, 624, 624, 624, 625, 625, 625, 625, 626, 626, 626, 626, 626, 626, 627, 627, 627, 627, 627, 627, 627, 627, 627, 628],
      <int>[629, 630, 630, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 631, 632, 632, 632, 632, 632, 633, 633, 633, 633, 634, 634, 634, 634, 634, 634, 635, 635, 635, 635, 635, 635, 635, 635, 635, 636],
      <int>[637, 638, 638, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 639, 640, 640, 640, 640, 640, 641, 641, 641, 641, 642, 642, 642, 642, 642, 642, 643, 643, 643, 643, 643, 643, 643, 643, 643, 644],
      <int>[645, 646, 646, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 647, 648, 648, 648, 648, 648, 649, 649, 649, 649, 650, 650, 650, 650, 650, 650, 651, 651, 651, 651, 651, 651, 651, 651, 651, 652],
      <int>[653, 654, 654, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 655, 656, 656, 656, 656, 656, 657, 657, 657, 657, 658, 658, 658, 658, 658, 658, 659, 659, 659, 659, 659, 659, 659, 659, 659, 660],
      <int>[661, 662, 662, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 663, 664, 664, 664, 664, 664, 665, 665, 665, 665, 666, 666, 666, 666, 666, 666, 667, 667, 667, 667, 667, 667, 667, 667, 667, 668],
      <int>[669, 670, 670, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 671, 672, 672, 672, 672, 672, 673, 673, 673, 673, 674, 674, 674, 674, 674, 674, 675, 675, 675, 675, 675, 675, 675, 675, 675, 676],
      <int>[677, 678, 678, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 679, 680, 680, 680, 680, 680, 681, 681, 681, 681, 682, 682, 682, 682, 682, 682, 683, 683, 683, 683, 683, 683, 683, 683, 683, 684],
      <int>[685, 686, 686, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 687, 688, 688, 688, 688, 688, 689, 689, 689, 689, 690, 690, 690, 690, 690, 690, 691, 691, 691, 691, 691, 691, 691, 691, 691, 692],
      <int>[693, 694, 694, 694, 694, 694, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 724, 724, 724, 724, 724, 724, 724, 724, 725],
      <int>[726, 727, 727, 727, 727, 727, 727, 728, 728, 729, 730, 730, 731, 731, 731, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 753, 754, 755, 755, 755, 755, 755, 755, 755, 755, 755, 756],
      <int>[757, 758, 758, 758, 758, 758, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 788, 788, 788, 788, 788, 788, 788, 788, 789],
      <int>[790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835],
      <int>[836, 837, 838, 839, 840, 841, 842, 843, 844, 845, 846, 847, 848, 849, 850, 851, 852, 853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881],
      <int>[882, 883, 884, 885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922, 923, 924, 925, 926, 927],
      <int>[928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 947, 948, 949, 950, 951, 952, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973],
    ];

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(left: cs[0], top: rs[0], width: cs[1] - cs[0], height: rs[1] - rs[0], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[0], width: cs[8] - cs[1], height: rs[2] - rs[0], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(top: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 13.3, fontWeight: FontWeight.bold),
                child: Text('Company Logo', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),




















          cell(25, 0, 45, 3, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.centerRight, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Calibri', fontSize: 23.9, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'A (Thailand) Co., Ltd.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.9, fontFamily: 'Calibri')),
                    TextSpan(text: '1/1 Rama IX Rd, Khwaeng Suan Luang, Khet Suan Luang, Bangkok 10250', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.3, fontFamily: 'Calibri')),
                  ],
                ),
              )),

          Positioned(left: cs[0], top: rs[1], width: cs[1] - cs[0], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),





















          Positioned(left: cs[0], top: rs[2], width: cs[1] - cs[0], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),





















































































          cell(18, 4, 29, 5, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 23.9, fontWeight: FontWeight.bold),
                child: Text('SERVICE REPORT', softWrap: false, overflow: TextOverflow.visible),
              )),


          cell(31, 4, 37, 5, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Service Report No.', softWrap: false, overflow: TextOverflow.visible),
              )),
          Positioned(left: cs[37], top: rs[4], width: cs[44] - cs[37], height: rs[5] - rs[4], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[1], top: rs[5], width: cs[2] - cs[1], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[5], width: cs[3] - cs[2], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[5], width: cs[4] - cs[3], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[5], width: cs[5] - cs[4], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[5], width: cs[6] - cs[5], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[5], width: cs[7] - cs[6], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[5], width: cs[8] - cs[7], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[5], width: cs[9] - cs[8], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[5], width: cs[10] - cs[9], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[5], width: cs[11] - cs[10], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[5], width: cs[12] - cs[11], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[5], width: cs[13] - cs[12], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[5], width: cs[14] - cs[13], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[5], width: cs[15] - cs[14], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[5], width: cs[16] - cs[15], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[5], width: cs[17] - cs[16], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[5], width: cs[18] - cs[17], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[5], width: cs[19] - cs[18], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[5], width: cs[20] - cs[19], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[5], width: cs[21] - cs[20], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[5], width: cs[22] - cs[21], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[5], width: cs[23] - cs[22], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[5], width: cs[24] - cs[23], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[5], width: cs[25] - cs[24], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[5], width: cs[26] - cs[25], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[5], width: cs[27] - cs[26], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[5], width: cs[28] - cs[27], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[5], width: cs[29] - cs[28], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[5], width: cs[30] - cs[29], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[5], width: cs[31] - cs[30], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[5], width: cs[32] - cs[31], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[5], width: cs[33] - cs[32], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[5], width: cs[34] - cs[33], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[5], width: cs[35] - cs[34], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[5], width: cs[36] - cs[35], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[5], width: cs[37] - cs[36], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[5], width: cs[38] - cs[37], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[5], width: cs[39] - cs[38], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[5], width: cs[40] - cs[39], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[5], width: cs[41] - cs[40], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[5], width: cs[42] - cs[41], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[5], width: cs[43] - cs[42], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[5], width: cs[44] - cs[43], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[5], width: cs[45] - cs[44], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[6], width: cs[1] - cs[0], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[6], width: cs[6] - cs[1], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('VISIT DATE:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[6], top: rs[6], width: cs[13] - cs[6], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'visit-date', required: true, snapMode: _snapMode, value: _visitDate, onChanged: (v) => setState(() => _visitDate = v)))),
          Positioned(left: cs[13], top: rs[6], width: cs[14] - cs[13], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[6], width: cs[15] - cs[14], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[6], width: cs[16] - cs[15], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[6], width: cs[17] - cs[16], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[6], width: cs[18] - cs[17], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[6], width: cs[19] - cs[18], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[6], width: cs[20] - cs[19], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[6], width: cs[21] - cs[20], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[6], width: cs[22] - cs[21], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[6], width: cs[27] - cs[22], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TIME IN:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[27], top: rs[6], width: cs[33] - cs[27], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _timeinController, maxLines: null, minLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[33], top: rs[6], width: cs[34] - cs[33], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[6], width: cs[35] - cs[34], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[6], width: cs[36] - cs[35], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[6], width: cs[37] - cs[36], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[6], width: cs[38] - cs[37], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[6], width: cs[39] - cs[38], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[6], width: cs[40] - cs[39], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[6], width: cs[41] - cs[40], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[6], width: cs[42] - cs[41], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[6], width: cs[43] - cs[42], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[6], width: cs[44] - cs[43], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[6], width: cs[45] - cs[44], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[7], width: cs[1] - cs[0], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[7], width: cs[6] - cs[1], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('FINISH DATE:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[6], top: rs[7], width: cs[13] - cs[6], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'finish-date', required: true, snapMode: _snapMode, value: _finishDate, onChanged: (v) => setState(() => _finishDate = v)))),
          Positioned(left: cs[13], top: rs[7], width: cs[14] - cs[13], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[7], width: cs[15] - cs[14], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[7], width: cs[16] - cs[15], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[7], width: cs[17] - cs[16], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[7], width: cs[18] - cs[17], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[7], width: cs[19] - cs[18], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[7], width: cs[20] - cs[19], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[7], width: cs[21] - cs[20], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[7], width: cs[22] - cs[21], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[7], width: cs[27] - cs[22], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TIME OUT:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[27], top: rs[7], width: cs[33] - cs[27], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _timeoutController, maxLines: null, minLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[33], top: rs[7], width: cs[34] - cs[33], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[7], width: cs[35] - cs[34], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[7], width: cs[36] - cs[35], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[7], width: cs[37] - cs[36], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[7], width: cs[38] - cs[37], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[7], width: cs[39] - cs[38], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[7], width: cs[40] - cs[39], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[7], width: cs[41] - cs[40], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[7], width: cs[42] - cs[41], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[7], width: cs[43] - cs[42], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[7], width: cs[44] - cs[43], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[7], width: cs[45] - cs[44], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[8], width: cs[1] - cs[0], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[8], width: cs[8] - cs[1], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('CUSTOMER NAME:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[8], top: rs[8], width: cs[29] - cs[8], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'customer-name', source: 'customers', displayFields: 'name,contact', fields: 'customer-name,customer-contact', required: true, snapMode: _snapMode, value: _customerName, onSelected: (v) => setState(() => _customerName = v?['customer-name,customer-contact'] as String?)))),
          Positioned(left: cs[29], top: rs[8], width: cs[33] - cs[29], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('CONTACT:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[33], top: rs[8], width: cs[45] - cs[33], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _customerContactController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[9], width: cs[1] - cs[0], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[9], width: cs[7] - cs[1], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('MODEL NAME:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[7], top: rs[9], width: cs[20] - cs[7], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _modelNameController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[20], top: rs[9], width: cs[25] - cs[20], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('SERIAL NO.:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[25], top: rs[9], width: cs[45] - cs[25], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _serialNoController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

















































          cell(2, 11, 10, 12, pad: EdgeInsets.only(top: 3.0, bottom: 1.0, left: 4.0, right: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF000000), height: 1.0, leadingDistribution: TextLeadingDistribution.even),
                child: Text('TYPE OF SERVICE*', softWrap: false, overflow: TextOverflow.visible),
              )),
          cell(10, 11, 38, 12, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 16.0, fontWeight: FontWeight.normal, color: Color(0xFF000000), height: 1.0, leadingDistribution: TextLeadingDistribution.even),
                child: FormCheckbox(name: 'type-of-service', options: ['WARRANTY', 'MAINTENANCE', 'REPAIR']),
              )),























































          Positioned(left: cs[1], top: rs[13], width: cs[11] - cs[1], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('DETAILS OF SERVICE:*', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[11], top: rs[13], width: cs[12] - cs[11], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[13], width: cs[13] - cs[12], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[13], width: cs[14] - cs[13], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[13], width: cs[15] - cs[14], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[13], width: cs[16] - cs[15], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[13], width: cs[17] - cs[16], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[13], width: cs[18] - cs[17], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[13], width: cs[19] - cs[18], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[13], width: cs[20] - cs[19], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[13], width: cs[21] - cs[20], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[13], width: cs[22] - cs[21], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[13], width: cs[23] - cs[22], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[13], width: cs[24] - cs[23], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[13], width: cs[25] - cs[24], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[13], width: cs[26] - cs[25], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[13], width: cs[27] - cs[26], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[13], width: cs[28] - cs[27], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[13], width: cs[29] - cs[28], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[13], width: cs[30] - cs[29], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[13], width: cs[31] - cs[30], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[13], width: cs[32] - cs[31], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[13], width: cs[33] - cs[32], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[13], width: cs[34] - cs[33], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[13], width: cs[35] - cs[34], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[13], width: cs[36] - cs[35], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[13], width: cs[37] - cs[36], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[13], width: cs[38] - cs[37], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[13], width: cs[39] - cs[38], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[13], width: cs[40] - cs[39], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[13], width: cs[41] - cs[40], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[13], width: cs[42] - cs[41], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[13], width: cs[43] - cs[42], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[13], width: cs[44] - cs[43], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[13], width: cs[45] - cs[44], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[14], width: cs[1] - cs[0], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[14], width: cs[45] - cs[1], height: rs[22] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _detailsOfServiceController, maxLines: null, minLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[15], width: cs[1] - cs[0], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[16], width: cs[1] - cs[0], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[17], width: cs[1] - cs[0], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[18], width: cs[1] - cs[0], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[19], width: cs[1] - cs[0], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[20], width: cs[1] - cs[0], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[21], width: cs[1] - cs[0], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),


          Positioned(left: cs[1], top: rs[22], width: cs[16] - cs[1], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('MANCHINE CONDITION / RECOMMENDATIONS:', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[16], top: rs[22], width: cs[17] - cs[16], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[22], width: cs[18] - cs[17], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[22], width: cs[19] - cs[18], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[22], width: cs[20] - cs[19], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[22], width: cs[21] - cs[20], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[22], width: cs[22] - cs[21], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[22], width: cs[23] - cs[22], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[22], width: cs[24] - cs[23], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[22], width: cs[25] - cs[24], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[22], width: cs[26] - cs[25], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[22], width: cs[27] - cs[26], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[22], width: cs[28] - cs[27], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[22], width: cs[29] - cs[28], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[22], width: cs[30] - cs[29], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[22], width: cs[31] - cs[30], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[22], width: cs[32] - cs[31], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[22], width: cs[33] - cs[32], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[22], width: cs[34] - cs[33], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[22], width: cs[35] - cs[34], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[22], width: cs[36] - cs[35], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[22], width: cs[37] - cs[36], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[22], width: cs[38] - cs[37], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[22], width: cs[39] - cs[38], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[22], width: cs[40] - cs[39], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[22], width: cs[41] - cs[40], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[22], width: cs[42] - cs[41], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[22], width: cs[43] - cs[42], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[22], width: cs[44] - cs[43], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[22], width: cs[45] - cs[44], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[23], width: cs[1] - cs[0], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[23], width: cs[45] - cs[1], height: rs[28] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _recommendationsController, maxLines: null, minLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[24], width: cs[1] - cs[0], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[25], width: cs[1] - cs[0], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[26], width: cs[1] - cs[0], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[27], width: cs[1] - cs[0], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
















































          Positioned(left: cs[1], top: rs[29], width: cs[2] - cs[1], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[29], width: cs[3] - cs[2], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[29], width: cs[4] - cs[3], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[29], width: cs[5] - cs[4], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[29], width: cs[6] - cs[5], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[29], width: cs[7] - cs[6], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[29], width: cs[8] - cs[7], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[29], width: cs[9] - cs[8], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[29], width: cs[10] - cs[9], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[29], width: cs[11] - cs[10], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[29], width: cs[12] - cs[11], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[29], width: cs[13] - cs[12], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[29], width: cs[14] - cs[13], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[29], width: cs[15] - cs[14], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[29], width: cs[16] - cs[15], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[29], width: cs[17] - cs[16], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[29], width: cs[18] - cs[17], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[29], width: cs[19] - cs[18], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[29], width: cs[20] - cs[19], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[29], width: cs[21] - cs[20], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[29], width: cs[22] - cs[21], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[29], width: cs[33] - cs[22], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('PARTS / MATERIALS', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[33], top: rs[29], width: cs[34] - cs[33], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[29], width: cs[35] - cs[34], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[29], width: cs[36] - cs[35], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[29], width: cs[37] - cs[36], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[29], width: cs[38] - cs[37], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[29], width: cs[39] - cs[38], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[29], width: cs[40] - cs[39], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[29], width: cs[41] - cs[40], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[29], width: cs[42] - cs[41], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[29], width: cs[43] - cs[42], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[29], width: cs[44] - cs[43], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[29], width: cs[45] - cs[44], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[30], width: cs[1] - cs[0], height: rs[31] - rs[30], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[30], width: cs[3] - cs[1], height: rs[31] - rs[30], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('#', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[3], top: rs[30], width: cs[21] - cs[3], height: rs[31] - rs[30], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Parts Name', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[21], top: rs[30], width: cs[26] - cs[21], height: rs[31] - rs[30], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('PART No.', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[26], top: rs[30], width: cs[30] - cs[26], height: rs[31] - rs[30], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('QTR.', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[30], top: rs[30], width: cs[36] - cs[30], height: rs[31] - rs[30], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('UNIT PRICE', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[36], top: rs[30], width: cs[45] - cs[36], height: rs[31] - rs[30], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TOTAL', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),

          Positioned(left: cs[0], top: rs[31], width: cs[1] - cs[0], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[31], width: cs[3] - cs[1], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId1Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[31], width: cs[21] - cs[3], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName1Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[31], width: cs[26] - cs[21], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo1Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[31], width: cs[30] - cs[26], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr1Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[31], width: cs[36] - cs[30], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice1Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[31], width: cs[45] - cs[36], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal1Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[32], width: cs[1] - cs[0], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[32], width: cs[3] - cs[1], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId2Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[32], width: cs[21] - cs[3], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName2Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[32], width: cs[26] - cs[21], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo2Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[32], width: cs[30] - cs[26], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr2Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[32], width: cs[36] - cs[30], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice2Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[32], width: cs[45] - cs[36], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal2Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[33], width: cs[1] - cs[0], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[33], width: cs[3] - cs[1], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId3Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[33], width: cs[21] - cs[3], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName3Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[33], width: cs[26] - cs[21], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo3Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[33], width: cs[30] - cs[26], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr3Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[33], width: cs[36] - cs[30], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice3Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[33], width: cs[45] - cs[36], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal3Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[34], width: cs[1] - cs[0], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[34], width: cs[3] - cs[1], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId4Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[34], width: cs[21] - cs[3], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName4Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[34], width: cs[26] - cs[21], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo4Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[34], width: cs[30] - cs[26], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr4Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[34], width: cs[36] - cs[30], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice4Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[34], width: cs[45] - cs[36], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal4Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[35], width: cs[1] - cs[0], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[35], width: cs[3] - cs[1], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId5Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[35], width: cs[21] - cs[3], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName5Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[35], width: cs[26] - cs[21], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo5Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[35], width: cs[30] - cs[26], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr5Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[35], width: cs[36] - cs[30], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice5Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[35], width: cs[45] - cs[36], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal5Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[36], width: cs[1] - cs[0], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[36], width: cs[3] - cs[1], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId6Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[36], width: cs[21] - cs[3], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName6Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[36], width: cs[26] - cs[21], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo6Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[36], width: cs[30] - cs[26], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr6Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[36], width: cs[36] - cs[30], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice6Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[36], width: cs[45] - cs[36], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal6Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[37], width: cs[1] - cs[0], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[37], width: cs[3] - cs[1], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId7Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[37], width: cs[21] - cs[3], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName7Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[37], width: cs[26] - cs[21], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo7Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[37], width: cs[30] - cs[26], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr7Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[37], width: cs[36] - cs[30], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice7Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[37], width: cs[45] - cs[36], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal7Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[38], width: cs[1] - cs[0], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[38], width: cs[3] - cs[1], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId8Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[38], width: cs[21] - cs[3], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName8Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[38], width: cs[26] - cs[21], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo8Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[38], width: cs[30] - cs[26], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr8Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[38], width: cs[36] - cs[30], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice8Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[38], width: cs[45] - cs[36], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal8Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[39], width: cs[1] - cs[0], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[39], width: cs[3] - cs[1], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId9Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[39], width: cs[21] - cs[3], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName9Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[39], width: cs[26] - cs[21], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo9Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[39], width: cs[30] - cs[26], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr9Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[39], width: cs[36] - cs[30], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice9Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[39], width: cs[45] - cs[36], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal9Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[40], width: cs[1] - cs[0], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[40], width: cs[3] - cs[1], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId10Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[40], width: cs[21] - cs[3], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName10Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[40], width: cs[26] - cs[21], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo10Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[40], width: cs[30] - cs[26], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr10Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[40], width: cs[36] - cs[30], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice10Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[40], width: cs[45] - cs[36], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal10Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[41], width: cs[1] - cs[0], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[41], width: cs[3] - cs[1], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId11Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[41], width: cs[21] - cs[3], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName11Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[41], width: cs[26] - cs[21], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo11Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[41], width: cs[30] - cs[26], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr11Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[41], width: cs[36] - cs[30], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice11Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[41], width: cs[45] - cs[36], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal11Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[42], width: cs[1] - cs[0], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[42], width: cs[3] - cs[1], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId12Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[42], width: cs[21] - cs[3], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName12Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[42], width: cs[26] - cs[21], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo12Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[42], width: cs[30] - cs[26], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr12Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[42], width: cs[36] - cs[30], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice12Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[42], width: cs[45] - cs[36], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal12Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[43], width: cs[1] - cs[0], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[43], width: cs[3] - cs[1], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId13Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[43], width: cs[21] - cs[3], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName13Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[43], width: cs[26] - cs[21], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo13Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[43], width: cs[30] - cs[26], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr13Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[43], width: cs[36] - cs[30], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice13Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[43], width: cs[45] - cs[36], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal13Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[44], width: cs[1] - cs[0], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[44], width: cs[3] - cs[1], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId14Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[44], width: cs[21] - cs[3], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName14Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[44], width: cs[26] - cs[21], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo14Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[44], width: cs[30] - cs[26], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr14Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[44], width: cs[36] - cs[30], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice14Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[44], width: cs[45] - cs[36], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal14Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[45], width: cs[1] - cs[0], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[45], width: cs[3] - cs[1], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partId15Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[45], width: cs[21] - cs[3], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partName15Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[21], top: rs[45], width: cs[26] - cs[21], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo15Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[45], width: cs[30] - cs[26], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQtr15Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[45], width: cs[36] - cs[30], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partUnitPrice15Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[45], width: cs[45] - cs[36], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal15Controller, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[46], width: cs[1] - cs[0], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[46], width: cs[7] - cs[1], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6),
                child: Text('PARTS TOTAL', softWrap: false, overflow: TextOverflow.ellipsis),
              ))),
          Positioned(left: cs[7], top: rs[46], width: cs[8] - cs[7], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[46], width: cs[9] - cs[8], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[46], width: cs[10] - cs[9], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[46], width: cs[11] - cs[10], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[46], width: cs[12] - cs[11], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[46], width: cs[13] - cs[12], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[46], width: cs[14] - cs[13], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[46], width: cs[15] - cs[14], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[46], width: cs[16] - cs[15], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[46], width: cs[17] - cs[16], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[46], width: cs[18] - cs[17], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[46], width: cs[19] - cs[18], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[46], width: cs[20] - cs[19], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[46], width: cs[21] - cs[20], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[46], width: cs[22] - cs[21], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[46], width: cs[23] - cs[22], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[46], width: cs[24] - cs[23], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[46], width: cs[25] - cs[24], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[46], width: cs[26] - cs[25], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[46], width: cs[27] - cs[26], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[46], width: cs[28] - cs[27], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[46], width: cs[29] - cs[28], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[46], width: cs[30] - cs[29], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[46], width: cs[31] - cs[30], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[46], width: cs[32] - cs[31], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[46], width: cs[33] - cs[32], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[46], width: cs[34] - cs[33], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[46], width: cs[35] - cs[34], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[46], width: cs[36] - cs[35], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[46], width: cs[45] - cs[36], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partSumTotalController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[47], width: cs[1] - cs[0], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[47], width: cs[7] - cs[1], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6),
                child: Text('SERVICE CHARGE:', softWrap: false, overflow: TextOverflow.ellipsis),
              ))),
          Positioned(left: cs[7], top: rs[47], width: cs[9] - cs[7], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _serviceChargeRateController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[9], top: rs[47], width: cs[10] - cs[9], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('X', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[10], top: rs[47], width: cs[12] - cs[10], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _serviceChargeHourController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[12], top: rs[47], width: cs[15] - cs[12], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('HRS.', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[15], top: rs[47], width: cs[16] - cs[15], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[47], width: cs[17] - cs[16], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[47], width: cs[18] - cs[17], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[47], width: cs[19] - cs[18], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[47], width: cs[20] - cs[19], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[47], width: cs[21] - cs[20], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[47], width: cs[22] - cs[21], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[47], width: cs[23] - cs[22], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[47], width: cs[24] - cs[23], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[47], width: cs[25] - cs[24], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[47], width: cs[26] - cs[25], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[47], width: cs[27] - cs[26], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[47], width: cs[28] - cs[27], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[47], width: cs[29] - cs[28], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[47], width: cs[30] - cs[29], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[47], width: cs[31] - cs[30], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[47], width: cs[32] - cs[31], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[47], width: cs[33] - cs[32], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[47], width: cs[34] - cs[33], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[47], width: cs[35] - cs[34], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[47], width: cs[36] - cs[35], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[47], width: cs[45] - cs[36], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partServiceChargeController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[48], width: cs[1] - cs[0], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[48], width: cs[7] - cs[1], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6),
                child: Text('GRAND TOTAL', softWrap: false, overflow: TextOverflow.ellipsis),
              ))),
          Positioned(left: cs[7], top: rs[48], width: cs[8] - cs[7], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[48], width: cs[9] - cs[8], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[48], width: cs[10] - cs[9], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[48], width: cs[11] - cs[10], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[48], width: cs[12] - cs[11], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[48], width: cs[13] - cs[12], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[48], width: cs[14] - cs[13], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[48], width: cs[15] - cs[14], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[48], width: cs[16] - cs[15], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[48], width: cs[17] - cs[16], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[48], width: cs[18] - cs[17], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[48], width: cs[19] - cs[18], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[48], width: cs[20] - cs[19], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[48], width: cs[21] - cs[20], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[48], width: cs[22] - cs[21], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[48], width: cs[23] - cs[22], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[48], width: cs[24] - cs[23], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[48], width: cs[25] - cs[24], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[48], width: cs[26] - cs[25], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[48], width: cs[27] - cs[26], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[48], width: cs[28] - cs[27], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[48], width: cs[29] - cs[28], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[48], width: cs[30] - cs[29], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[48], width: cs[31] - cs[30], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[48], width: cs[32] - cs[31], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[48], width: cs[33] - cs[32], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[48], width: cs[34] - cs[33], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[48], width: cs[35] - cs[34], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[48], width: cs[36] - cs[35], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[48], width: cs[45] - cs[36], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partGrandTotalController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

























































































































































































          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(
              painter: _TableGridPainter(
                colStarts: cs,
                rowStarts: rs,
                borderColor: Colors.black,
                borderWidth: 0.0,
                matrixData: matrixData,
                numRows: 53,
                numCols: 46,
              ),
            )),
          ),
        ],
      ),
    );
  },
),
));

  Widget _page2() => RepaintBoundary(key: _captureKey2, child: UnconstrainedBox(
  alignment: Alignment.topLeft,
  child: LayoutBuilder(
  builder: (context, constraints) {
    final availableWidth = constraints.maxWidth;

    final fixedTotal = 1012.0;
    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal).clamp(0.0, double.infinity);
    final flexUnit = availableWidth.isInfinite ? 200.0 : flexSpace / 0.001000;
    final colWidths = <double>[
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
      22.0,
    ];

    final rowHeights = <double>[112.0, 20.0, 20.0, 20.0, 40.0, 24.0, 28.0, 28.0, 28.0, 28.0, 27.0, 32.0, 27.0, 27.0, 27.0, 27.0, 27.0, 20.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 23.0, 38.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0];

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
      <int>[0, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 23],
      <int>[24, 1, 1, 1, 1, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 45],
      <int>[46, 1, 1, 1, 1, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 67],
      <int>[68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113],
      <int>[114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 145, 145, 145, 145, 145, 145, 145, 145, 145, 154, 155, 156, 157, 158, 159],
      <int>[160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205],
      <int>[206, 207, 207, 207, 207, 207, 208, 208, 208, 208, 208, 208, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 218, 218, 218, 218, 219, 219, 219, 219, 219, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232],
      <int>[233, 234, 234, 234, 234, 234, 235, 235, 235, 235, 235, 235, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 245, 245, 245, 245, 246, 246, 246, 246, 246, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259],
      <int>[260, 261, 261, 261, 261, 261, 261, 261, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 262, 263, 263, 263, 263, 264, 264, 264, 264, 264, 264, 264, 264, 264, 264, 264, 264, 265],
      <int>[266, 267, 267, 267, 267, 267, 267, 268, 268, 268, 268, 268, 268, 268, 268, 268, 268, 268, 268, 268, 269, 269, 269, 269, 269, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 270, 271],
      <int>[272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317],
      <int>[318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 339, 339, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360],
      <int>[361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406],
      <int>[407, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 409, 410, 411, 412, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 414, 415, 416, 417, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 419],
      <int>[420, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 421, 422, 423, 424, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 425, 426, 427, 428, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 429],
      <int>[430, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 431, 432, 433, 434, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 435, 436, 437, 438, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 439],
      <int>[440, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 441, 442, 443, 444, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 445, 446, 447, 448, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 449],
      <int>[450, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 451, 452, 453, 454, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 455, 456, 457, 458, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 459],
      <int>[460, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 461, 462, 463, 464, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 465, 466, 467, 468, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 469],
      <int>[470, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 471, 472, 473, 474, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 475, 476, 477, 478, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 479],
      <int>[480, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 408, 481, 482, 483, 484, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 413, 485, 486, 487, 488, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 418, 489],
      <int>[490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535],
      <int>[536, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 538, 539, 540, 541, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 543, 544, 545, 546, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 548],
      <int>[549, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 550, 551, 552, 553, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 554, 555, 556, 557, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 558],
      <int>[559, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 560, 561, 562, 563, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 564, 565, 566, 567, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 568],
      <int>[569, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 570, 571, 572, 573, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 574, 575, 576, 577, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 578],
      <int>[579, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 580, 581, 582, 583, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 584, 585, 586, 587, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 588],
      <int>[589, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 590, 591, 592, 593, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 594, 595, 596, 597, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 598],
      <int>[599, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 600, 601, 602, 603, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 604, 605, 606, 607, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 608],
      <int>[609, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 537, 610, 611, 612, 613, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 542, 614, 615, 616, 617, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 547, 618],
      <int>[619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664],
      <int>[665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 691, 692, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710],
      <int>[711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 721, 721, 721, 721, 721, 721, 721, 729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 742, 742, 742, 742, 742, 742, 742, 742, 742, 752, 753, 754, 755, 756],
      <int>[757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 800, 801, 802],
      <int>[803, 804, 805, 806, 807, 808, 809, 809, 809, 809, 809, 809, 809, 809, 809, 809, 809, 809, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 819, 820, 821, 822, 823, 824],
      <int>[825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835, 836, 837, 838, 839, 840, 841, 842, 843, 844, 845, 846, 847, 848, 849, 850, 851, 852, 853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870],
      <int>[871, 872, 873, 874, 875, 876, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 878, 879, 880, 881, 882, 883, 884, 885, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 887, 888, 889, 890, 891, 892],
      <int>[893, 894, 895, 896, 897, 898, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 899, 900, 901, 902, 903, 904, 905, 906, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 907, 908, 909, 910, 911, 912],
      <int>[913, 914, 915, 916, 917, 918, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 919, 920, 921, 922, 923, 924, 925, 926, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 927, 928, 929, 930, 931, 932],
      <int>[933, 934, 935, 936, 937, 938, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 877, 939, 940, 941, 942, 943, 944, 945, 946, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 886, 947, 948, 949, 950, 951, 952],
      <int>[953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 964, 964, 964, 964, 969, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 985, 985, 985, 985, 990, 991, 992, 993, 994, 995, 996, 997, 998],
      <int>[999, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1042, 1043, 1044],
      <int>[1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1072, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089, 1090],
      <int>[1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 1133, 1134, 1135, 1136],
    ];

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(left: cs[0], top: rs[0], width: cs[1] - cs[0], height: rs[1] - rs[0], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[0], width: cs[8] - cs[1], height: rs[2] - rs[0], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(top: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 13.3, fontWeight: FontWeight.bold),
                child: Text('Company Logo', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),




















          cell(25, 0, 45, 3, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.centerRight, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Calibri', fontSize: 23.9, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'A (Thailand) Co., Ltd.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.9, fontFamily: 'Calibri')),
                    TextSpan(text: '1/1 Rama IX Rd, Khwaeng Suan Luang, Khet Suan Luang, Bangkok 10250', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.3, fontFamily: 'Calibri')),
                  ],
                ),
              )),

          Positioned(left: cs[0], top: rs[1], width: cs[1] - cs[0], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),





















          Positioned(left: cs[0], top: rs[2], width: cs[1] - cs[0], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),






















































































          cell(19, 4, 31, 5, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 23.9, fontWeight: FontWeight.bold),
                child: Text('SERVICE REPORT', softWrap: false, overflow: TextOverflow.visible),
              )),
          cell(31, 4, 40, 5, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Service Report No.', softWrap: false, overflow: TextOverflow.visible),
              )),
          Positioned(left: cs[40], top: rs[4], width: cs[41] - cs[40], height: rs[5] - rs[4], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[4], width: cs[42] - cs[41], height: rs[5] - rs[4], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[4], width: cs[43] - cs[42], height: rs[5] - rs[4], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[4], width: cs[44] - cs[43], height: rs[5] - rs[4], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[1], top: rs[5], width: cs[2] - cs[1], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[5], width: cs[3] - cs[2], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[5], width: cs[4] - cs[3], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[5], width: cs[5] - cs[4], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[5], width: cs[6] - cs[5], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[5], width: cs[7] - cs[6], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[5], width: cs[8] - cs[7], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[5], width: cs[9] - cs[8], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[5], width: cs[10] - cs[9], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[5], width: cs[11] - cs[10], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[5], width: cs[12] - cs[11], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[5], width: cs[13] - cs[12], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[5], width: cs[14] - cs[13], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[5], width: cs[15] - cs[14], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[5], width: cs[16] - cs[15], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[5], width: cs[17] - cs[16], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[5], width: cs[18] - cs[17], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[5], width: cs[19] - cs[18], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[5], width: cs[20] - cs[19], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[5], width: cs[21] - cs[20], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[5], width: cs[22] - cs[21], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[5], width: cs[23] - cs[22], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[5], width: cs[24] - cs[23], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[5], width: cs[25] - cs[24], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[5], width: cs[26] - cs[25], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[5], width: cs[27] - cs[26], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[5], width: cs[28] - cs[27], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[5], width: cs[29] - cs[28], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[5], width: cs[30] - cs[29], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[5], width: cs[31] - cs[30], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[5], width: cs[32] - cs[31], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[5], width: cs[33] - cs[32], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[5], width: cs[34] - cs[33], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[5], width: cs[35] - cs[34], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[5], width: cs[36] - cs[35], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[5], width: cs[37] - cs[36], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[5], width: cs[38] - cs[37], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[5], width: cs[39] - cs[38], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[5], width: cs[40] - cs[39], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[5], width: cs[41] - cs[40], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[5], width: cs[42] - cs[41], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[5], width: cs[43] - cs[42], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[5], width: cs[44] - cs[43], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[5], width: cs[45] - cs[44], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[6], width: cs[1] - cs[0], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[6], width: cs[6] - cs[1], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('VISIT DATE:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[6], top: rs[6], width: cs[13] - cs[6], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'visit-date', required: true, snapMode: _snapMode, value: _visitDate, onChanged: (v) => setState(() => _visitDate = v)))),
          Positioned(left: cs[13], top: rs[6], width: cs[14] - cs[13], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[6], width: cs[15] - cs[14], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[6], width: cs[16] - cs[15], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[6], width: cs[17] - cs[16], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[6], width: cs[18] - cs[17], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[6], width: cs[19] - cs[18], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[6], width: cs[20] - cs[19], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[6], width: cs[21] - cs[20], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[6], width: cs[22] - cs[21], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[6], width: cs[27] - cs[22], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TIME IN:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[27], top: rs[6], width: cs[33] - cs[27], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _timeinController, maxLines: null, minLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[33], top: rs[6], width: cs[34] - cs[33], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[6], width: cs[35] - cs[34], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[6], width: cs[36] - cs[35], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[6], width: cs[37] - cs[36], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[6], width: cs[38] - cs[37], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[6], width: cs[39] - cs[38], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[6], width: cs[40] - cs[39], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[6], width: cs[41] - cs[40], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[6], width: cs[42] - cs[41], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[6], width: cs[43] - cs[42], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[6], width: cs[44] - cs[43], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[6], width: cs[45] - cs[44], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[7], width: cs[1] - cs[0], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[7], width: cs[6] - cs[1], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('FINISH DATE:', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[6], top: rs[7], width: cs[13] - cs[6], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'finish-date', required: true, snapMode: _snapMode, value: _finishDate, onChanged: (v) => setState(() => _finishDate = v)))),
          Positioned(left: cs[13], top: rs[7], width: cs[14] - cs[13], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[7], width: cs[15] - cs[14], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[7], width: cs[16] - cs[15], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[7], width: cs[17] - cs[16], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[7], width: cs[18] - cs[17], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[7], width: cs[19] - cs[18], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[7], width: cs[20] - cs[19], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[7], width: cs[21] - cs[20], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[7], width: cs[22] - cs[21], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[7], width: cs[27] - cs[22], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TIME OUT:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[27], top: rs[7], width: cs[33] - cs[27], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _timeoutController, maxLines: null, minLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[33], top: rs[7], width: cs[34] - cs[33], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[7], width: cs[35] - cs[34], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[7], width: cs[36] - cs[35], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[7], width: cs[37] - cs[36], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[7], width: cs[38] - cs[37], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[7], width: cs[39] - cs[38], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[7], width: cs[40] - cs[39], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[7], width: cs[41] - cs[40], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[7], width: cs[42] - cs[41], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[7], width: cs[43] - cs[42], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[7], width: cs[44] - cs[43], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[7], width: cs[45] - cs[44], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[8], width: cs[1] - cs[0], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[8], width: cs[8] - cs[1], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('CUSTOMER NAME:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[8], top: rs[8], width: cs[29] - cs[8], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'customer-name', source: 'customers', displayFields: 'name,contact', fields: 'customer-name,customer-contact', required: true, snapMode: _snapMode, value: _customerName, onSelected: (v) => setState(() => _customerName = v?['customer-name,customer-contact'] as String?)))),
          Positioned(left: cs[29], top: rs[8], width: cs[33] - cs[29], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('CONTACT:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[33], top: rs[8], width: cs[45] - cs[33], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _customerContactController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[9], width: cs[1] - cs[0], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[9], width: cs[7] - cs[1], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('MODEL NAME:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[7], top: rs[9], width: cs[20] - cs[7], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _modelNameController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[20], top: rs[9], width: cs[25] - cs[20], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('SERIAL NO.:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[25], top: rs[9], width: cs[45] - cs[25], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _serialNoController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),




































































          cell(21, 11, 25, 12, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 18.6, color: Color(0xFF000000)),
                child: Text('Photos', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )),






















          Positioned(left: cs[1], top: rs[12], width: cs[2] - cs[1], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[12], width: cs[3] - cs[2], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[12], width: cs[4] - cs[3], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[12], width: cs[5] - cs[4], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[12], width: cs[6] - cs[5], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[12], width: cs[7] - cs[6], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[12], width: cs[8] - cs[7], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[12], width: cs[9] - cs[8], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[12], width: cs[10] - cs[9], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[12], width: cs[11] - cs[10], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[12], width: cs[12] - cs[11], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[12], width: cs[13] - cs[12], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),




          Positioned(left: cs[17], top: rs[12], width: cs[18] - cs[17], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[12], width: cs[19] - cs[18], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[12], width: cs[20] - cs[19], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[12], width: cs[21] - cs[20], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[12], width: cs[22] - cs[21], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[12], width: cs[23] - cs[22], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[12], width: cs[24] - cs[23], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[12], width: cs[25] - cs[24], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[12], width: cs[26] - cs[25], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[12], width: cs[27] - cs[26], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[12], width: cs[28] - cs[27], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[12], width: cs[29] - cs[28], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),




          Positioned(left: cs[33], top: rs[12], width: cs[34] - cs[33], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[12], width: cs[35] - cs[34], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[12], width: cs[36] - cs[35], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[12], width: cs[37] - cs[36], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[12], width: cs[38] - cs[37], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[12], width: cs[39] - cs[38], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[12], width: cs[40] - cs[39], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[12], width: cs[41] - cs[40], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[12], width: cs[42] - cs[41], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[12], width: cs[43] - cs[42], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[12], width: cs[44] - cs[43], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[12], width: cs[45] - cs[44], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[13], width: cs[1] - cs[0], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[13], width: cs[13] - cs[1], height: rs[21] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'image-upload-1', value: _imageUploadFiles['image-upload-1'], onPicked: (f) => _onImagePicked('image-upload-1', f)))),



          Positioned(left: cs[16], top: rs[13], width: cs[17] - cs[16], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[13], width: cs[29] - cs[17], height: rs[21] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'image-upload-2', value: _imageUploadFiles['image-upload-2'], onPicked: (f) => _onImagePicked('image-upload-2', f)))),



          Positioned(left: cs[32], top: rs[13], width: cs[33] - cs[32], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[13], width: cs[45] - cs[33], height: rs[21] - rs[13], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'image-upload-3', value: _imageUploadFiles['image-upload-3'], onPicked: (f) => _onImagePicked('image-upload-3', f)))),

          Positioned(left: cs[0], top: rs[14], width: cs[1] - cs[0], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[14], width: cs[17] - cs[16], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[14], width: cs[33] - cs[32], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[15], width: cs[1] - cs[0], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[15], width: cs[17] - cs[16], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[15], width: cs[33] - cs[32], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[16], width: cs[1] - cs[0], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[16], width: cs[17] - cs[16], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[16], width: cs[33] - cs[32], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[17], width: cs[1] - cs[0], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[17], width: cs[17] - cs[16], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[17], width: cs[33] - cs[32], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[18], width: cs[1] - cs[0], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[18], width: cs[17] - cs[16], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[18], width: cs[33] - cs[32], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[19], width: cs[1] - cs[0], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[19], width: cs[17] - cs[16], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[19], width: cs[33] - cs[32], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[20], width: cs[1] - cs[0], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[20], width: cs[17] - cs[16], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[20], width: cs[33] - cs[32], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),


          Positioned(left: cs[1], top: rs[21], width: cs[2] - cs[1], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[21], width: cs[3] - cs[2], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[21], width: cs[4] - cs[3], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[21], width: cs[5] - cs[4], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[21], width: cs[6] - cs[5], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[21], width: cs[7] - cs[6], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[21], width: cs[8] - cs[7], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[21], width: cs[9] - cs[8], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[21], width: cs[10] - cs[9], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[21], width: cs[11] - cs[10], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[21], width: cs[12] - cs[11], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[21], width: cs[13] - cs[12], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),




          Positioned(left: cs[17], top: rs[21], width: cs[18] - cs[17], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[21], width: cs[19] - cs[18], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[21], width: cs[20] - cs[19], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[21], width: cs[21] - cs[20], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[21], width: cs[22] - cs[21], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[21], width: cs[23] - cs[22], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[21], width: cs[24] - cs[23], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[21], width: cs[25] - cs[24], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[21], width: cs[26] - cs[25], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[21], width: cs[27] - cs[26], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[21], width: cs[28] - cs[27], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[21], width: cs[29] - cs[28], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),




          Positioned(left: cs[33], top: rs[21], width: cs[34] - cs[33], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[21], width: cs[35] - cs[34], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[21], width: cs[36] - cs[35], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[21], width: cs[37] - cs[36], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[21], width: cs[38] - cs[37], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[21], width: cs[39] - cs[38], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[21], width: cs[40] - cs[39], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[21], width: cs[41] - cs[40], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[21], width: cs[42] - cs[41], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[21], width: cs[43] - cs[42], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[21], width: cs[44] - cs[43], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[21], width: cs[45] - cs[44], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[22], width: cs[1] - cs[0], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[22], width: cs[13] - cs[1], height: rs[30] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'image-upload-4', value: _imageUploadFiles['image-upload-4'], onPicked: (f) => _onImagePicked('image-upload-4', f)))),



          Positioned(left: cs[16], top: rs[22], width: cs[17] - cs[16], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[22], width: cs[29] - cs[17], height: rs[30] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'image-upload-5', value: _imageUploadFiles['image-upload-5'], onPicked: (f) => _onImagePicked('image-upload-5', f)))),



          Positioned(left: cs[32], top: rs[22], width: cs[33] - cs[32], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[22], width: cs[45] - cs[33], height: rs[30] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'image-upload-6', value: _imageUploadFiles['image-upload-6'], onPicked: (f) => _onImagePicked('image-upload-6', f)))),

          Positioned(left: cs[0], top: rs[23], width: cs[1] - cs[0], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[23], width: cs[17] - cs[16], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[23], width: cs[33] - cs[32], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[24], width: cs[1] - cs[0], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[24], width: cs[17] - cs[16], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[24], width: cs[33] - cs[32], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[25], width: cs[1] - cs[0], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[25], width: cs[17] - cs[16], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[25], width: cs[33] - cs[32], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[26], width: cs[1] - cs[0], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[26], width: cs[17] - cs[16], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[26], width: cs[33] - cs[32], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[27], width: cs[1] - cs[0], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[27], width: cs[17] - cs[16], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[27], width: cs[33] - cs[32], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[28], width: cs[1] - cs[0], height: rs[29] - rs[28], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[28], width: cs[17] - cs[16], height: rs[29] - rs[28], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[28], width: cs[33] - cs[32], height: rs[29] - rs[28], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[29], width: cs[1] - cs[0], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[29], width: cs[17] - cs[16], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[29], width: cs[33] - cs[32], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),







































































































          cell(10, 32, 18, 33, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Customer name:*', softWrap: false, overflow: TextOverflow.visible),
              )),













          cell(31, 32, 41, 33, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Service staff name:*', softWrap: false, overflow: TextOverflow.visible),
              )),

























































          Positioned(left: cs[6], top: rs[34], width: cs[19] - cs[6], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _customerNameController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),








          Positioned(left: cs[27], top: rs[34], width: cs[40] - cs[27], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _serviceStaffNameController, style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16), decoration: _inputDecoration))),












          Positioned(left: cs[6], top: rs[35], width: cs[7] - cs[6], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[35], width: cs[8] - cs[7], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[35], width: cs[9] - cs[8], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[35], width: cs[10] - cs[9], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[35], width: cs[11] - cs[10], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[35], width: cs[12] - cs[11], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[35], width: cs[13] - cs[12], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[35], width: cs[14] - cs[13], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[35], width: cs[15] - cs[14], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[35], width: cs[16] - cs[15], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[35], width: cs[17] - cs[16], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[35], width: cs[18] - cs[17], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[35], width: cs[19] - cs[18], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),








          Positioned(left: cs[27], top: rs[35], width: cs[28] - cs[27], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[35], width: cs[29] - cs[28], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[35], width: cs[30] - cs[29], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[35], width: cs[31] - cs[30], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[35], width: cs[32] - cs[31], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[35], width: cs[33] - cs[32], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[35], width: cs[34] - cs[33], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[35], width: cs[35] - cs[34], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[35], width: cs[36] - cs[35], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[35], width: cs[37] - cs[36], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[35], width: cs[38] - cs[37], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[35], width: cs[39] - cs[38], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[35], width: cs[40] - cs[39], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),











          Positioned(left: cs[5], top: rs[36], width: cs[6] - cs[5], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[36], width: cs[19] - cs[6], height: rs[40] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'signature-customer', initialData: _signatureCustomerBytes, onSigned: (v) => setState(() => _signatureCustomerBytes = v)))),







          Positioned(left: cs[26], top: rs[36], width: cs[27] - cs[26], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[36], width: cs[40] - cs[27], height: rs[40] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'signature-service-staff', initialData: _signatureServiceStaffBytes, onSigned: (v) => setState(() => _signatureServiceStaffBytes = v)))),











          Positioned(left: cs[5], top: rs[37], width: cs[6] - cs[5], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),







          Positioned(left: cs[26], top: rs[37], width: cs[27] - cs[26], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),











          Positioned(left: cs[5], top: rs[38], width: cs[6] - cs[5], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),







          Positioned(left: cs[26], top: rs[38], width: cs[27] - cs[26], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),











          Positioned(left: cs[5], top: rs[39], width: cs[6] - cs[5], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),







          Positioned(left: cs[26], top: rs[39], width: cs[27] - cs[26], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

















          cell(11, 40, 16, 41, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Signature', softWrap: false, overflow: TextOverflow.visible),
              )),
















          cell(32, 40, 37, 41, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Signature', softWrap: false, overflow: TextOverflow.visible),
              )),



















































































































































          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(
              painter: _TableGridPainter(
                colStarts: cs,
                rowStarts: rs,
                borderColor: Colors.black,
                borderWidth: 0.0,
                matrixData: matrixData,
                numRows: 44,
                numCols: 46,
              ),
            )),
          ),
        ],
      ),
    );
  },
),
));
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
  final bool doubled;
  final String side;
  const _DashSide._(this.side, {required this.color, required this.width, this.dotted = false, this.doubled = false});
  const _DashSide.top({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('top', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.right({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('right', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.bottom({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('bottom', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.left({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('left', color: color, width: width, dotted: dotted, doubled: doubled);
}

class _DashedBorderPainter extends CustomPainter {
  final List<_DashSide> sides;
  const _DashedBorderPainter({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sides) {
      if (s.doubled) {
        _drawDouble(canvas, s, size);
        continue;
      }
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

  // CSS "double": two parallel solid lines of thickness W/3 with a W/3 gap, drawn inside
  // the cell so total visual span equals the specified width W.
  void _drawDouble(Canvas canvas, _DashSide s, Size size) {
    final lineW = s.width / 3.0;
    final paint = Paint()
      ..color = s.color
      ..strokeWidth = lineW
      ..style = PaintingStyle.stroke;
    final outer = lineW / 2.0;         // stroke centerline of the outer line, from the edge
    final inner = s.width - lineW / 2.0; // stroke centerline of the inner line, from the edge
    switch (s.side) {
      case 'top':
        canvas.drawLine(Offset(0, outer), Offset(size.width, outer), paint);
        canvas.drawLine(Offset(0, inner), Offset(size.width, inner), paint);
        break;
      case 'bottom':
        canvas.drawLine(Offset(0, size.height - outer), Offset(size.width, size.height - outer), paint);
        canvas.drawLine(Offset(0, size.height - inner), Offset(size.width, size.height - inner), paint);
        break;
      case 'left':
        canvas.drawLine(Offset(outer, 0), Offset(outer, size.height), paint);
        canvas.drawLine(Offset(inner, 0), Offset(inner, size.height), paint);
        break;
      case 'right':
        canvas.drawLine(Offset(size.width - outer, 0), Offset(size.width - outer, size.height), paint);
        canvas.drawLine(Offset(size.width - inner, 0), Offset(size.width - inner, size.height), paint);
        break;
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