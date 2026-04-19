import 'package:flutter/material.dart';
import '../services/local_db.dart';

class ModelSelectionScreen extends StatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  State<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
  List<Map<String, dynamic>> _models = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadModels();
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

  @override
  Widget build(BuildContext context) {
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
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _models.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final model = _models[index];
                    final items = model['inspection_items'] as List? ?? [];
                    return ListTile(
                      leading: const Icon(Icons.precision_manufacturing),
                      title: Text(model['model_name'] ?? ''),
                      subtitle: Text(
                        '${model['model_code']} - ${items.length} inspection items',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/report',
                          arguments: {'machineModel': model},
                        );
                      },
                    );
                  },
                ),
    );
  }
}
