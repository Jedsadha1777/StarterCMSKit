import 'package:flutter/material.dart';
import '../services/local_db.dart';

class ModelSelectionScreen extends StatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  State<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _models = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadModels();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadModels() async {
    final models = await LocalDb().getMachineModels();
    if (mounted) {
      setState(() {
        _models = models;
        _loading = false;
      });
    }
  }

  // Same matching style as FormSearch (toLowerCase + contains across name/code).
  List<Map<String, dynamic>> _filtered() {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _models;
    return _models.where((m) {
      final name = (m['model_name'] as String? ?? '').toLowerCase();
      final code = (m['model_code'] as String? ?? '').toLowerCase();
      return name.contains(q) || code.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final targetRoute = (args?['target'] as String?) ?? '/report';
    final filtered = _filtered();
    return Scaffold(
      appBar: AppBar(title: const Text('Select Model')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _models.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No machine models available.\nPlease sync data first.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search model name or code',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchCtrl.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () => _searchCtrl.clear(),
                                ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text(
                                'No models match.',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final model = filtered[index];
                                final items = model['inspection_items'] as List? ?? [];
                                return ListTile(
                                  leading: const Icon(Icons.precision_manufacturing),
                                  title: Text(model['model_name'] ?? ''),
                                  subtitle: Text(
                                    '${model['model_code']} - ${items.length} inspection items',
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      targetRoute,
                                      arguments: {'machineModel': model},
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
