import 'package:flutter/material.dart';

class FormDate extends StatefulWidget {
  final String name;
  final String? value;
  final String? placeholder;
  final String? min;
  final String? max;
  final bool required;
  final bool readonly;
  final ValueChanged<String?>? onChanged;

  const FormDate({
    super.key,
    required this.name,
    this.value,
    this.placeholder,
    this.min,
    this.max,
    this.required = false,
    this.readonly = false,
    this.onChanged,
  });

  factory FormDate.fromJson(Map<String, dynamic> json, {
    ValueChanged<String?>? onChanged,
  }) {
    return FormDate(
      name: json['name'] as String? ?? '',
      value: json['value'] as String?,
      placeholder: json['placeholder'] as String?,
      min: json['min'] as String?,
      max: json['max'] as String?,
      required: json['required'] == true,
      readonly: json['readonly'] == true,
      onChanged: onChanged,
    );
  }

  @override
  State<FormDate> createState() => _FormDateState();
}

class _FormDateState extends State<FormDate> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  DateTime? _parseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  Future<void> _pickDate() async {
    if (widget.readonly) return;

    final now = DateTime.now();
    final first = _parseDate(widget.min) ?? DateTime(2000);
    final last = _parseDate(widget.max) ?? DateTime(2100);
    final initial = _parseDate(_selected) ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : (initial.isAfter(last) ? last : initial),
      firstDate: first,
      lastDate: last,
    );

    if (picked != null) {
      final formatted = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() => _selected = formatted);
      widget.onChanged?.call(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: _selected ?? ''),
      readOnly: true,
      onTap: widget.readonly ? null : _pickDate,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: widget.placeholder ?? 'เลือกวันที่',
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        filled: widget.required,
        fillColor: widget.required ? Colors.yellow.shade50 : null,
      ),
    );
  }
}
