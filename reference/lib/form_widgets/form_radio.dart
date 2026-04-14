import 'package:flutter/material.dart';

class FormRadio extends StatefulWidget {
  final String name;
  final List<String> options;
  final String? value;
  final bool required;
  final bool disabled;
  final ValueChanged<String?>? onChanged;

  const FormRadio({
    super.key,
    required this.name,
    required this.options,
    this.value,
    this.required = false,
    this.disabled = false,
    this.onChanged,
  });

  factory FormRadio.fromJson(Map<String, dynamic> json, {
    ValueChanged<String?>? onChanged,
  }) {
    final rawOptions = json['options'];
    List<String> options;
    if (rawOptions is List) {
      options = rawOptions.map((e) => e.toString()).toList();
    } else {
      options = [];
    }

    return FormRadio(
      name: json['name'] as String? ?? '',
      options: options,
      value: json['value'] as String?,
      required: json['required'] == true,
      disabled: json['disabled'] == true,
      onChanged: onChanged,
    );
  }

  @override
  State<FormRadio> createState() => _FormRadioState();
}

class _FormRadioState extends State<FormRadio> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      groupValue: _selected ?? '',
      onChanged: widget.disabled
          ? (v) {}
          : (v) {
              setState(() => _selected = v);
              widget.onChanged?.call(v);
            },
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: widget.options.map((opt) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(value: opt),
              Text(opt),
            ],
          );
        }).toList(),
      ),
    );
  }
}
