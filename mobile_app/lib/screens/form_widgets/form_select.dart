import 'package:flutter/material.dart';

class FormSelect extends StatefulWidget {
  final String name;
  final List<String> options;
  final String? value;
  final bool firstAsLabel;
  final bool required;
  final bool disabled;
  final ValueChanged<String?>? onChanged;

  const FormSelect({
    super.key,
    required this.name,
    required this.options,
    this.value,
    this.firstAsLabel = false,
    this.required = false,
    this.disabled = false,
    this.onChanged,
  });

  factory FormSelect.fromJson(Map<String, dynamic> json, {
    ValueChanged<String?>? onChanged,
  }) {
    final rawOptions = json['options'];
    List<String> options;
    if (rawOptions is List) {
      options = rawOptions.map((e) {
        if (e is Map) return (e['value'] ?? e['label'] ?? '').toString();
        return e.toString();
      }).toList();
    } else {
      options = [];
    }

    return FormSelect(
      name: json['name'] as String? ?? '',
      options: options,
      value: json['value'] as String?,
      firstAsLabel: json['firstAsLabel'] == true,
      required: json['required'] == true,
      disabled: json['disabled'] == true,
      onChanged: onChanged,
    );
  }

  @override
  State<FormSelect> createState() => _FormSelectState();
}

class _FormSelectState extends State<FormSelect> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final startIndex = widget.firstAsLabel ? 1 : 0;
    final hint = widget.firstAsLabel && widget.options.isNotEmpty
        ? widget.options.first
        : 'เลือก...';

    final items = widget.options.sublist(startIndex).map((opt) {
      return DropdownMenuItem<String>(value: opt, child: Text(opt));
    }).toList();

    return DropdownButtonFormField<String>(
      value: _selected,
      hint: Text(hint),
      items: items,
      onChanged: widget.disabled
          ? null
          : (v) {
              setState(() => _selected = v);
              widget.onChanged?.call(v);
            },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        filled: widget.required,
        fillColor: widget.required ? Colors.yellow.shade50 : null,
      ),
    );
  }
}
