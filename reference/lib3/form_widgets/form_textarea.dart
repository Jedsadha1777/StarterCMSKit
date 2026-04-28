import 'package:flutter/material.dart';

class FormTextarea extends StatelessWidget {
  final String name;
  final String? value;
  final String? placeholder;
  final int rows;
  final double? maxWidth;
  final double? maxHeight;
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
    this.maxWidth,
    this.maxHeight,
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
      maxWidth: (json['maxWidth'] as num?)?.toDouble(),
      maxHeight: (json['maxHeight'] as num?)?.toDouble(),
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

    final decoration = InputDecoration(
      border: const OutlineInputBorder(),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      hintText: placeholder,
      filled: required,
      fillColor: required ? Colors.yellow.shade50 : null,
    );

    // 4 render strategies:
    //  (1) bounded cell + no max          → expands:true, fills cell
    //  (2) bounded cell + max-height      → SizedBox(height: maxHeight) + expands:true
    //  (3) unbounded parent + max-height  → SizedBox(height: maxHeight) + expands:true
    //  (4) unbounded parent + no max      → maxLines: rows (safe fallback, no crash)
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final bounded = constraints.hasBoundedHeight;
        final hasMaxH = maxHeight != null;

        Widget tf;
        if (hasMaxH || bounded) {
          tf = TextField(
            controller: ctrl,
            maxLines: null, minLines: null, expands: true,
            textAlignVertical: TextAlignVertical.top,
            readOnly: readonly || disabled,
            enabled: !disabled,
            onChanged: onChanged,
            decoration: decoration,
          );
        } else {
          // unbounded fallback — rows-capped, safe in any parent
          tf = TextField(
            controller: ctrl,
            maxLines: rows,
            readOnly: readonly || disabled,
            enabled: !disabled,
            onChanged: onChanged,
            decoration: decoration,
          );
        }

        if (maxWidth != null || hasMaxH) {
          tf = SizedBox(
            width: maxWidth,
            height: hasMaxH ? maxHeight : null,
            child: tf,
          );
          // Prevent the cell's fill constraints from stretching the SizedBox
          tf = Align(alignment: Alignment.topLeft, child: tf);
        }

        return tf;
      },
    );
  }
}
