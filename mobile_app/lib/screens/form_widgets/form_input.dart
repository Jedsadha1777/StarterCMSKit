import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInput extends StatelessWidget {
  final String name;
  final String type;
  final String? value;
  final String? placeholder;
  final String? pattern;
  final bool required;
  final bool readonly;
  final bool disabled;
  final bool snapMode;
  final bool showValidation;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const FormInput({
    super.key,
    required this.name,
    this.type = 'text',
    this.value,
    this.placeholder,
    this.pattern,
    this.required = false,
    this.readonly = false,
    this.disabled = false,
    this.snapMode = false,
    this.showValidation = false,
    this.controller,
    this.onChanged,
  });

  factory FormInput.fromJson(Map<String, dynamic> json, {
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
  }) {
    return FormInput(
      name: json['name'] as String? ?? '',
      type: json['inputType'] as String? ?? json['type'] as String? ?? 'text',
      value: json['value'] as String?,
      placeholder: json['placeholder'] as String?,
      pattern: json['pattern'] as String?,
      required: json['required'] == true,
      readonly: json['readonly'] == true,
      disabled: json['disabled'] == true,
      controller: controller,
      onChanged: onChanged,
    );
  }

  static const _keyboardMap = {
    'text': TextInputType.text,
    'email': TextInputType.emailAddress,
    'tel': TextInputType.phone,
    'number': TextInputType.number,
  };

  @override
  Widget build(BuildContext context) {
    final ctrl = controller ?? TextEditingController(text: value);

    if (snapMode) {
      return TextField(
        controller: ctrl,
        keyboardType: _keyboardMap[type] ?? TextInputType.text,
        readOnly: true,
        enabled: !disabled,
        inputFormatters: _buildFormatters(),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        ),
      );
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: ctrl,
      builder: (context, val, _) {
        final highlight = required && val.text.trim().isEmpty && showValidation;
        return TextField(
          controller: ctrl,
          keyboardType: _keyboardMap[type] ?? TextInputType.text,
          readOnly: readonly || disabled,
          enabled: !disabled,
          onChanged: onChanged,
          inputFormatters: _buildFormatters(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintText: placeholder,
            filled: highlight,
            fillColor: highlight ? const Color.fromARGB(136, 255, 235, 59) : null,
          ),
        );
      },
    );
  }

  List<TextInputFormatter>? _buildFormatters() {
    if (pattern != null) {
      return [FilteringTextInputFormatter.allow(RegExp(pattern!))];
    }
    if (type == 'number') {
      return [FilteringTextInputFormatter.allow(RegExp(r'[\d.\-]'))];
    }
    if (type == 'tel') {
      return [FilteringTextInputFormatter.allow(RegExp(r'[\d\-+() ]'))];
    }
    return null;
  }
}
