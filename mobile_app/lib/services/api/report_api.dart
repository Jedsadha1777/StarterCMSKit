import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../token_manager.dart';
import 'api_client.dart';

class ReportApi {
  final ApiClient _api = ApiClient();
  final TokenManager _tokenManager = TokenManager();

  /// Submit report.
  /// - If [imageAttachments] is null/empty → JSON POST (backward-compatible).
  /// - If [imageAttachments] provided ({fieldName → absolutePath}) → multipart POST:
  ///   text fields for metadata, file fields for each image. Backend must
  ///   parse multipart at `POST /reports` when Content-Type is multipart/form-data.
  Future<Map<String, dynamic>> submitReport({
    required Map<String, dynamic> formData,
    required List<String> recipientEmails,
    required String machineModelId,
    String? customerId,
    String? serialNo,
    String? inspectorName,
    String? inspectedAt,
    Map<String, String>? imageAttachments,
  }) async {
    if (imageAttachments == null || imageAttachments.isEmpty) {
      final body = <String, dynamic>{
        'form_data': formData,
        'recipient_emails': recipientEmails,
        'machine_model_id': machineModelId,
      };
      if (customerId != null) body['customer_id'] = customerId;
      if (serialNo != null) body['serial_no'] = serialNo;
      if (inspectorName != null) body['inspector_name'] = inspectorName;
      if (inspectedAt != null) body['inspected_at'] = inspectedAt;

      return await _api.post<Map<String, dynamic>>(
        '/reports',
        (json) => json,
        body: body,
      );
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/reports');
    final response = await _sendMultipart(
      uri,
      timeout: const Duration(seconds: 60),
      build: (req) async {
        req.fields['form_data'] = jsonEncode(formData);
        req.fields['recipient_emails'] = jsonEncode(recipientEmails);
        req.fields['machine_model_id'] = machineModelId;
        if (customerId != null) req.fields['customer_id'] = customerId;
        if (serialNo != null) req.fields['serial_no'] = serialNo;
        if (inspectorName != null) req.fields['inspector_name'] = inspectorName;
        if (inspectedAt != null) req.fields['inspected_at'] = inspectedAt;

        for (final e in imageAttachments.entries) {
          req.files.add(await http.MultipartFile.fromPath(e.key, e.value));
        }
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return _api.safeJsonDecode(response.body);
    } else {
      final decoded = _api.safeJsonDecode(response.body);
      final msg = decoded['message'] ?? 'Submit failed (${response.statusCode})';
      throw Exception(msg);
    }
  }

  Future<Map<String, dynamic>> uploadPdf(String reportPublicId, Uint8List pdfBytes) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/reports/$reportPublicId/upload-pdf');
    final response = await _sendMultipart(
      uri,
      timeout: const Duration(seconds: 30),
      build: (req) async {
        req.files.add(http.MultipartFile.fromBytes('file', pdfBytes, filename: '$reportPublicId.pdf'));
      },
    );

    if (response.statusCode == 200) {
      return _api.safeJsonDecode(response.body);
    } else {
      final msg = _api.safeJsonDecode(response.body)['message'] ?? 'Upload failed';
      throw Exception(msg);
    }
  }

  /// Multipart POST with the same token-refresh-on-401 retry as ApiClient.makeRequest.
  /// `build` populates fields/files; it's invoked again on retry because
  /// MultipartRequest/MultipartFile streams are single-use.
  Future<http.Response> _sendMultipart(
    Uri uri, {
    required Future<void> Function(http.MultipartRequest req) build,
    required Duration timeout,
  }) async {
    Future<http.Response> attempt() async {
      final token = await _tokenManager.getAccessToken();
      final req = http.MultipartRequest('POST', uri);
      if (token != null) req.headers['Authorization'] = 'Bearer $token';
      await build(req);
      final streamed = await req.send().timeout(timeout);
      return http.Response.fromStream(streamed);
    }

    await _tokenManager.getOrRefreshToken(_api.refreshToken);
    var response = await attempt();
    if (response.statusCode == 401) {
      await _api.refreshToken();
      response = await attempt();
    }
    return response;
  }

  Future<Map<String, dynamic>> getReportHistory({int page = 1, int perPage = 20}) async {
    return await _api.get<Map<String, dynamic>>(
      '/reports',
      (json) => json,
      queryParams: {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
  }

  Future<Map<String, dynamic>> retryEmail(String reportPublicId) async {
    return await _api.post<Map<String, dynamic>>(
      '/reports/$reportPublicId/retry-email',
      (json) => json,
    );
  }

  /// Download the report's PDF as bytes for printing/sharing.
  /// Backend serves it via GET /reports/<id>/pdf when status >= sent.
  Future<Uint8List> getReportPdf(String reportPublicId) async {
    Future<http.Response> attempt() async {
      final token = await _tokenManager.getAccessToken();
      final uri = Uri.parse('${ApiConfig.baseUrl}/reports/$reportPublicId/pdf');
      return http.get(
        uri,
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ).timeout(const Duration(seconds: 30));
    }

    await _tokenManager.getOrRefreshToken(_api.refreshToken);
    var response = await attempt();
    if (response.statusCode == 401) {
      await _api.refreshToken();
      response = await attempt();
    }
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    final msg = _api.safeJsonDecode(response.body)['message'] ?? 'PDF not available';
    throw Exception(msg);
  }
}
