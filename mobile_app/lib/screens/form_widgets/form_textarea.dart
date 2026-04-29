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
  final bool snapMode;
  final bool showValidation;
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
    this.snapMode = false,
    this.showValidation = false,
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

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final bounded = constraints.hasBoundedHeight;
        final hasMaxH = maxHeight != null;

        Widget buildTf(InputDecoration decoration) {
          if (hasMaxH || bounded) {
            return TextField(
              controller: ctrl,
              maxLines: null, minLines: null, expands: true,
              textAlignVertical: TextAlignVertical.top,
              readOnly: readonly || disabled || snapMode,
              enabled: !disabled,
              onChanged: snapMode ? null : onChanged,
              decoration: decoration,
            );
          }
          return TextField(
            controller: ctrl,
            maxLines: rows,
            readOnly: readonly || disabled || snapMode,
            enabled: !disabled,
            onChanged: snapMode ? null : onChanged,
            decoration: decoration,
          );
        }

        Widget tf;
        if (snapMode) {
          tf = buildTf(const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          ));
        } else {
          tf = ValueListenableBuilder<TextEditingValue>(
            valueListenable: ctrl,
            builder: (_, val, __) {
              final highlight = required && val.text.trim().isEmpty && showValidation;
              return buildTf(InputDecoration(
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                hintText: placeholder,
                filled: highlight,
                fillColor: highlight ? const Color.fromARGB(136, 255, 235, 59) : null,
              ));
            },
          );
        }

        if (maxWidth != null || hasMaxH) {
          tf = SizedBox(
            width: maxWidth,
            height: hasMaxH ? maxHeight : null,
            child: tf,
          );
          tf = Align(alignment: Alignment.topLeft, child: tf);
        }

        return tf;
      },
    );
  }
}
