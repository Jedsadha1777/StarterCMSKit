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

  Future<List<Map<String, dynamic>>> _fetchSource() async {
    switch (widget.source) {
      case 'customers':
        return await LocalDb().getCustomers();
      case 'machine_models':
        return await LocalDb().getMachineModels();
      default:
        // Unknown source (e.g. 'parts' — no local cache table). Return empty
        // so the field still works as a free-text input but the dropdown
        // stays hidden instead of throwing.
        return const [];
    }
  }

  bool _matchesQuery(Map<String, dynamic> row, String q) {
    switch (widget.source) {
      case 'customers':
        return ((row['name'] as String? ?? '').toLowerCase().contains(q)) ||
               ((row['customer_id'] as String? ?? '').toLowerCase().contains(q));
      case 'machine_models':
        return ((row['model_name'] as String? ?? '').toLowerCase().contains(q)) ||
               ((row['model_code'] as String? ?? '').toLowerCase().contains(q));
      default:
        return false;
    }
  }

  String _rowDisplay(Map<String, dynamic> row) {
    switch (widget.source) {
      case 'customers':
        return '${row['customer_id'] ?? ''}  ${row['name'] ?? ''}';
      case 'machine_models':
        return '${row['model_code'] ?? ''}  ${row['model_name'] ?? ''}';
      default:
        return row.values.where((v) => v != null).take(2).join('  ');
    }
  }

  String _rowTextValue(Map<String, dynamic> row) {
    switch (widget.source) {
      case 'customers':
        return row['name'] as String? ?? '';
      case 'machine_models':
        return row['model_name'] as String? ?? '';
      default:
        // Best-effort: pick the first string value as the field text.
        for (final v in row.values) {
          if (v is String && v.isNotEmpty) return v;
        }
        return '';
    }
  }

  void _search(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }
    final all = await _fetchSource();
    if (all.isEmpty) {
      _removeOverlay();
      return;
    }
    final q = query.toLowerCase();
    final results = all.where((r) => _matchesQuery(r, q)).take(20).toList();

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
                  final row = results[index];
                  return ListTile(
                    dense: true,
                    title: Text(_rowDisplay(row), style: const TextStyle(fontSize: 12)),
                    onTap: () {
                      _ctrl.text = _rowTextValue(row);
                      widget.onSelected?.call(row);
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
      child: LayoutBuilder(
        // Drop the search icon when the cell is too tight (same threshold as
        // FormTime / FormDate) so the field behaves like a plain text input
        // in dense layouts.
        builder: (ctx, c) {
          final showIcon = !c.maxHeight.isFinite || c.maxHeight >= 36;
          return ValueListenableBuilder<TextEditingValue>(
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
                  suffixIcon: showIcon ? const Icon(Icons.search, size: 18) : null,
                  filled: highlight,
                  fillColor: highlight ? const Color.fromARGB(136, 255, 235, 59) : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
