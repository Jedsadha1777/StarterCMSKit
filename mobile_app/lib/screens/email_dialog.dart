import 'package:flutter/material.dart';

Future<List<String>?> showEmailDialog(BuildContext context) async {
  return showDialog<List<String>>(
    context: context,
    builder: (ctx) => const _EmailDialog(),
  );
}

class _EmailDialog extends StatefulWidget {
  const _EmailDialog();

  @override
  State<_EmailDialog> createState() => _EmailDialogState();
}

class _EmailDialogState extends State<_EmailDialog> {
  final List<TextEditingController> _controllers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addField() {
    setState(() => _controllers.add(TextEditingController()));
  }

  void _removeField(int index) {
    if (_controllers.length <= 1) return;
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null; // empty is ok, we filter later
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) return 'Invalid email';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final emails = _controllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (emails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one email')),
      );
      return;
    }

    Navigator.pop(context, emails);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send Report'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recipient emails:'),
                const SizedBox(height: 8),
                ...List.generate(_controllers.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controllers[i],
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'email${i + 1}@example.com',
                            isDense: true,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                          validator: _validateEmail,
                        ),
                      ),
                      if (_controllers.length > 1)
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red, size: 20),
                          onPressed: () => _removeField(i),
                        ),
                    ],
                  ),
                )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add email'),
                    onPressed: _addField,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Send')),
      ],
    );
  }
}
