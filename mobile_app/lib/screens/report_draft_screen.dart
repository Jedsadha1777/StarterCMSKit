import 'package:flutter/material.dart';
import '../services/local_db.dart';

class ReportDraftScreen extends StatefulWidget {
  const ReportDraftScreen({super.key});

  @override
  State<ReportDraftScreen> createState() => _ReportDraftScreenState();
}

class _ReportDraftScreenState extends State<ReportDraftScreen> {
  List<Map<String, dynamic>> _drafts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    final drafts = await LocalDb().listDrafts();
    if (mounted) {
      setState(() {
        _drafts = drafts;
        _loading = false;
      });
    }
  }

  Future<void> _deleteDraft(String draftId, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Draft'),
        content: const Text('Are you sure you want to delete this draft?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      await LocalDb().deleteDraft(draftId);
      setState(() => _drafts.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Drafts')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _drafts.isEmpty
              ? const Center(
                  child: Text('No drafts saved.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _drafts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final draft = _drafts[index];
                    return ListTile(
                      leading: const Icon(Icons.edit_document, color: Colors.orange),
                      title: Text('Draft ${index + 1}'),
                      subtitle: Text('Updated: ${draft['updated_at'] ?? ''}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteDraft(draft['draft_id'] as String, index),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () async {
                        final modelId = draft['machine_model_id'] as String? ?? '';
                        if (modelId.isEmpty) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Draft has no machine model. Please delete and create new.')),
                            );
                          }
                          return;
                        }
                        final model = await LocalDb().getMachineModelDetail(modelId);
                        if (model == null) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Machine model not found. Please resync data.')),
                            );
                          }
                          return;
                        }
                        final result = await Navigator.pushNamed(
                          context,
                          '/report',
                          arguments: {'draftData': draft, 'machineModel': model},
                        );
                        if (result == true) _loadDrafts();
                      },
                    );
                  },
                ),
    );
  }
}
