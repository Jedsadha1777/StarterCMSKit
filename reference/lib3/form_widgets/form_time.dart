import 'package:flutter/material.dart';

class FormTime extends StatefulWidget {
  final String name;
  final String? value;
  final String? placeholder;
  final String? min;
  final String? max;
  final int? step;
  final bool required;
  final bool readonly;
  final ValueChanged<String?>? onChanged;

  const FormTime({
    super.key,
    required this.name,
    this.value,
    this.placeholder,
    this.min,
    this.max,
    this.step,
    this.required = false,
    this.readonly = false,
    this.onChanged,
  });

  factory FormTime.fromJson(Map<String, dynamic> json, {
    ValueChanged<String?>? onChanged,
  }) {
    return FormTime(
      name: json['name'] as String? ?? '',
      value: json['value'] as String?,
      placeholder: json['placeholder'] as String?,
      min: json['min'] as String?,
      max: json['max'] as String?,
      step: (json['step'] as num?)?.toInt(),
      required: json['required'] == true,
      readonly: json['readonly'] == true,
      onChanged: onChanged,
    );
  }

  @override
  State<FormTime> createState() => _FormTimeState();
}

class _FormTimeState extends State<FormTime> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  TimeOfDay? _parseTime(String? s) {
    if (s == null || s.isEmpty) return null;
    final parts = s.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    if (h < 0 || h > 23 || m < 0 || m > 59) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  String _format(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _pickTime() async {
    if (widget.readonly) return;

    final initial = _parseTime(_selected) ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked == null) return;

    final minT = _parseTime(widget.min);
    final maxT = _parseTime(widget.max);
    var result = picked;
    if (minT != null && _toMinutes(result) < _toMinutes(minT)) result = minT;
    if (maxT != null && _toMinutes(result) > _toMinutes(maxT)) result = maxT;

    final formatted = _format(result);
    setState(() => _selected = formatted);
    widget.onChanged?.call(formatted);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: _selected ?? ''),
      readOnly: true,
      onTap: widget.readonly ? null : _pickTime,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: widget.placeholder ?? 'เลือกเวลา',
        suffixIcon: const Icon(Icons.access_time, size: 18),
        filled: widget.required,
        fillColor: widget.required ? Colors.yellow.shade50 : null,
      ),
    );
  }
}
