import 'package:flutter/material.dart';

class FormSearch extends StatefulWidget {
  final String name;
  final String source;
  final String? displayFields;
  final String? valueField;
  final String? fields;
  final String? placeholder;
  final String? value;
  final bool required;
  final ValueChanged<Map<String, dynamic>?>? onSelected;

  const FormSearch({
    super.key,
    required this.name,
    required this.source,
    this.displayFields,
    this.valueField,
    this.fields,
    this.placeholder,
    this.value,
    this.required = false,
    this.onSelected,
  });

  factory FormSearch.fromJson(Map<String, dynamic> json, {
    ValueChanged<Map<String, dynamic>?>? onSelected,
  }) {
    return FormSearch(
      name: json['name'] as String? ?? '',
      source: json['source'] as String? ?? '',
      displayFields: json['display'] as String?,
      valueField: json['valueField'] as String?,
      fields: json['fields'] as String?,
      placeholder: json['placeholder'] as String?,
      value: json['value'] as String?,
      required: json['required'] == true,
      onSelected: onSelected,
    );
  }

  @override
  State<FormSearch> createState() => _FormSearchState();
}

class _FormSearchState extends State<FormSearch> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl.text = widget.value ?? '';
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: widget.placeholder ?? 'Search ${widget.source}...',
        suffixIcon: const Icon(Icons.search, size: 18),
        filled: widget.required,
        fillColor: widget.required ? Colors.yellow.shade50 : null,
      ),
      onChanged: (query) {
        // TODO: implement fuzzy search against source data
        // and call widget.onSelected with matched record
      },
    );
  }
}
