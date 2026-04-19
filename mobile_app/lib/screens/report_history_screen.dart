import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/api/report_api.dart';
import '../services/local_db.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  final ReportApi _reportApi = ReportApi();
  List<Map<String, dynamic>> _reports = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _reportApi.getReportHistory();
      final reports = (data['reports'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [];
      if (mounted) setState(() { _reports = reports; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _retryEmail(String reportId, int index) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      final updated = await _reportApi.retryEmail(reportId);
      if (mounted) {
        Navigator.pop(context); // close loading
        setState(() => _reports[index] = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email sent successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }

  Future<void> _retryUpload(String reportId, int index) async {
    final draft = await LocalDb().getDraftByReportId(reportId);
    if (draft == null || draft['pdf_data'] == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF data not found locally. Cannot retry.')),
        );
      }
      return;
    }
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      final pdfData = draft['pdf_data'] as Uint8List;
      final updated = await _reportApi.uploadPdf(reportId, pdfData);
      // Clear pdf_data after successful upload
      final draftId = draft['draft_id'] as String?;
      if (draftId != null) await LocalDb().clearPdfData(draftId);
      if (mounted) {
        Navigator.pop(context);
        setState(() => _reports[index] = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF uploaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'sent': return Colors.green;
      case 'email_failed': return Colors.red;
      case 'submitted': return Colors.orange;
      case 'pending_pdf': return Colors.deepOrange;
      case 'reviewed': return Colors.blue;
      case 'approved': return Colors.teal;
      case 'rejected': return Colors.grey;
      default: return Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report History'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadHistory),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _reports.isEmpty
                  ? const Center(child: Text('No reports submitted yet.', style: TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _reports.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final report = _reports[index];
                        final status = report['status'] as String? ?? '';
                        return ListTile(
                          leading: Icon(Icons.description, color: _statusColor(status)),
                          title: Text(report['report_no'] ?? ''),
                          subtitle: Text('${report['created_at'] ?? ''}\nStatus: $status'),
                          isThreeLine: true,
                          trailing: status == 'email_failed'
                              ? TextButton.icon(
                                  icon: const Icon(Icons.send, size: 16),
                                  label: const Text('Retry Email'),
                                  onPressed: () => _retryEmail(report['id'] as String, index),
                                )
                              : status == 'pending_pdf'
                              ? TextButton.icon(
                                  icon: const Icon(Icons.upload, size: 16),
                                  label: const Text('Retry Upload'),
                                  onPressed: () => _retryUpload(report['id'] as String, index),
                                )
                              : null,
                        );
                      },
                    ),
    );
  }
}
