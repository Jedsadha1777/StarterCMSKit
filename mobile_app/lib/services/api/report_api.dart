import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../token_manager.dart';
import 'api_client.dart';

class ReportApi {
  final ApiClient _api = ApiClient();
  final TokenManager _tokenManager = TokenManager();

  Future<Map<String, dynamic>> submitReport({
    required Map<String, dynamic> formData,
    required List<String> recipientEmails,
    required String machineModelId,
    String? customerId,
    String? serialNo,
    String? inspectorName,
    String? inspectedAt,
  }) async {
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

  Future<Map<String, dynamic>> uploadPdf(String reportPublicId, Uint8List pdfBytes) async {
    final token = await _tokenManager.getAccessToken();
    final uri = Uri.parse('${ApiConfig.baseUrl}/reports/$reportPublicId/upload-pdf');
    final request = http.MultipartRequest('POST', uri);
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes('file', pdfBytes, filename: '$reportPublicId.pdf'));

    final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return _api.safeJsonDecode(response.body);
    } else {
      final msg = _api.safeJsonDecode(response.body)['message'] ?? 'Upload failed';
      throw Exception(msg);
    }
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
}
