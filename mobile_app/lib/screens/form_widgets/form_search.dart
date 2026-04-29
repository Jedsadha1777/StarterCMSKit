import 'package:flutter/material.dart';
import '../../services/local_db.dart';

class FormSearch extends StatefulWidget {
  final String name;
  final String source;
  final String? displayFields;
  final String? valueField;
  final String? fields;
  final String? placeholder;
  final String? value;
  final bool required;
  final bool snapMode;
  final bool showValidation;
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
    this.snapMode = false,
    this.showValidation = false,
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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _ctrl.text = widget.value ?? '';
  }

  @override
  void didUpdateWidget(covariant FormSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _ctrl.text) {
      _ctrl.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _ctrl.dispose();
    super.dispose();
  }

  void _search(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }
    final customers = await LocalDb().getCustomers();
    final q = query.toLowerCase();
    final results = customers.where((c) =>
      (c['name'] as String? ?? '').toLowerCase().contains(q) ||
      (c['customer_id'] as String? ?? '').toLowerCase().contains(q)
    ).take(20).toList();

    if (results.isEmpty) {
      _removeOverlay();
    } else {
      _showOverlay(results);
    }
  }

  void _showOverlay(List<Map<String, dynamic>> results) {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 36),
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final c = results[index];
                  return ListTile(
                    dense: true,
                    title: Text('${c['customer_id']}  ${c['name']}', style: const TextStyle(fontSize: 12)),
                    onTap: () {
                      _ctrl.text = c['name'] as String? ?? '';
                      widget.onSelected?.call(c);
                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snapMode) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          controller: _ctrl,
          readOnly: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          ),
        ),
      );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _ctrl,
        builder: (_, val, __) {
          final highlight = widget.required && val.text.trim().isEmpty && widget.showValidation;
          return TextField(
            controller: _ctrl,
            onChanged: _search,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              hintText: widget.placeholder ?? 'Search...',
              suffixIcon: const Icon(Icons.search, size: 18),
              filled: highlight,
              fillColor: highlight ? const Color.fromARGB(136, 255, 235, 59) : null,
            ),
          );
        },
      ),
    );
  }
}
