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
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
    _ctrl = TextEditingController(text: _selected ?? '');
  }

  @override
  void didUpdateWidget(covariant FormDate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _selected) {
      _selected = widget.value;
      _ctrl.text = _selected ?? '';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
      setState(() {
        _selected = formatted;
        _ctrl.text = formatted;
      });
      widget.onChanged?.call(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      readOnly: true,
      onTap: widget.readonly ? null : _pickDate,
      style: const TextStyle(fontFamily: 'Browallia New', fontSize: 16),
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
