import 'package:flutter/material.dart';

class FormTextarea extends StatelessWidget {
  final String name;
  final String? value;
  final String? placeholder;
  final int rows;
  final bool required;
  final bool readonly;
  final bool disabled;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const FormTextarea({
    super.key,
    required this.name,
    this.value,
    this.placeholder,
    this.rows = 3,
    this.required = false,
    this.readonly = false,
    this.disabled = false,
    this.controller,
    this.onChanged,
  });

  factory FormTextarea.fromJson(Map<String, dynamic> json, {
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
  }) {
    return FormTextarea(
      name: json['name'] as String? ?? '',
      value: json['value'] as String?,
      placeholder: json['placeholder'] as String?,
      rows: (json['rows'] as num?)?.toInt() ?? 3,
      required: json['required'] == true,
      readonly: json['readonly'] == true,
      disabled: json['disabled'] == true,
      controller: controller,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = controller ?? TextEditingController(text: value);

    return TextField(
      controller: ctrl,
      maxLines: rows,
      readOnly: readonly || disabled,
      enabled: !disabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: placeholder,
        filled: required,
        fillColor: required ? Colors.yellow.shade50 : null,
      ),
    );
  }
}
