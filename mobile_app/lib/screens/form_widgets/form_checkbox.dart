import 'package:flutter/material.dart';

class FormCheckbox extends StatefulWidget {
  final String name;
  final String? label;
  final List<String> options;
  final bool hasOther;
  final dynamic value;
  final bool disabled;
  final ValueChanged<dynamic>? onChanged;

  const FormCheckbox({
    super.key,
    required this.name,
    this.label,
    this.options = const [],
    this.hasOther = false,
    this.value,
    this.disabled = false,
    this.onChanged,
  });

  factory FormCheckbox.fromJson(Map<String, dynamic> json, {
    ValueChanged<dynamic>? onChanged,
  }) {
    final rawOptions = json['options'];
    List<String> options;
    if (rawOptions is List) {
      options = rawOptions.map((e) => e.toString()).toList();
    } else {
      options = [];
    }

    return FormCheckbox(
      name: json['name'] as String? ?? '',
      label: json['label'] as String?,
      options: options,
      hasOther: json['other'] == true,
      value: json['value'],
      disabled: json['disabled'] == true,
      onChanged: onChanged,
    );
  }

  bool get isGroup => options.isNotEmpty;

  @override
  State<FormCheckbox> createState() => _FormCheckboxState();
}

class _FormCheckboxState extends State<FormCheckbox> {
  bool _singleValue = false;
  final Set<String> _selected = {};
  final TextEditingController _otherCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isGroup) {
      if (widget.value is Map) {
        final sel = widget.value['selected'];
        if (sel is List) _selected.addAll(sel.cast<String>());
        _otherCtrl.text = (widget.value['other_text'] ?? '').toString();
      }
    } else {
      _singleValue = widget.value == true;
    }
  }

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  void _emitGroup() {
    widget.onChanged?.call({
      'selected': _selected.toList(),
      'other_text': _otherCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isGroup) return _buildGroup();
    return _buildSingle();
  }

  Widget _buildSingle() {
    final checkbox = Checkbox(
      value: _singleValue,
      onChanged: widget.disabled
          ? null
          : (v) {
              setState(() => _singleValue = v ?? false);
              widget.onChanged?.call(_singleValue);
            },
    );

    if (widget.label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [checkbox, Flexible(child: Text(widget.label!))],
      );
    }
    return checkbox;
  }

  Widget _buildGroup() {
    final children = <Widget>[];

    for (final opt in widget.options) {
      children.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _selected.contains(opt),
            onChanged: widget.disabled
                ? null
                : (v) {
                    setState(() {
                      if (v == true) {
                        _selected.add(opt);
                      } else {
                        _selected.remove(opt);
                      }
                    });
                    _emitGroup();
                  },
          ),
          Flexible(child: Text(opt)),
        ],
      ));
    }

    if (widget.hasOther) {
      children.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _selected.contains('Other'),
            onChanged: widget.disabled
                ? null
                : (v) {
                    setState(() {
                      if (v == true) {
                        _selected.add('Other');
                      } else {
                        _selected.remove('Other');
                      }
                    });
                    _emitGroup();
                  },
          ),
          const Text('Other: '),
          SizedBox(
            width: 120,
            child: TextField(
              controller: _otherCtrl,
              enabled: !widget.disabled && _selected.contains('Other'),
              onChanged: (_) => _emitGroup(),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ));
    }

    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}
