import 'package:flutter/material.dart';

class FormCheckbox extends StatefulWidget {
  final String name;
  final String? label;
  final List<String> options;
  final bool hasOther;
  final dynamic value;
  final bool disabled;
  final bool required;
  final bool snapMode;
  final bool showValidation;
  /// When true, group options spread across the row with spaceEvenly.
  /// When false (default), options pack together with Wrap (line-break on overflow).
  final bool rowLayout;
  final ValueChanged<dynamic>? onChanged;

  const FormCheckbox({
    super.key,
    required this.name,
    this.label,
    this.options = const [],
    this.hasOther = false,
    this.value,
    this.disabled = false,
    this.required = false,
    this.snapMode = false,
    this.showValidation = false,
    this.rowLayout = false,
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
      required: json['required'] == true,
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
    _syncFromWidgetValue();
  }

  @override
  void didUpdateWidget(covariant FormCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _syncFromWidgetValue();
    }
  }

  void _syncFromWidgetValue() {
    if (widget.isGroup) {
      _selected.clear();
      if (widget.value is Map) {
        final sel = widget.value['selected'];
        if (sel is List) _selected.addAll(sel.cast<String>());
        final newOther = (widget.value['other_text'] ?? '').toString();
        if (_otherCtrl.text != newOther) _otherCtrl.text = newOther;
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

  bool get _isEmpty => widget.isGroup ? _selected.isEmpty : !_singleValue;

  bool get _highlight =>
      widget.required && _isEmpty && !widget.snapMode && widget.showValidation;

  Widget _wrap(Widget checkbox) => _highlight
      ? ColoredBox(color: const Color.fromARGB(136, 255, 235, 59), child: checkbox)
      : checkbox;

  @override
  Widget build(BuildContext context) {
    if (widget.isGroup) return _buildGroup();
    return _buildSingle();
  }

  Widget _buildSingle() {
    final checkbox = _wrap(Checkbox(
      fillColor: const WidgetStatePropertyAll(Colors.white),
      checkColor: Colors.black,
      side: WidgetStateBorderSide.resolveWith((_) => const BorderSide(color: Colors.black, width: 1)),
      value: _singleValue,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      onChanged: widget.disabled
          ? null
          : (v) {
              setState(() => _singleValue = v ?? false);
              widget.onChanged?.call(_singleValue);
            },
    ));

    if (widget.label != null) {
      return InkWell(
        onTap: widget.disabled
            ? null
            : () {
                setState(() => _singleValue = !_singleValue);
                widget.onChanged?.call(_singleValue);
              },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [checkbox, Flexible(child: Text(widget.label!))],
        ),
      );
    }
    return checkbox;
  }

  Widget _buildGroup() {
    final children = <Widget>[];

    for (final opt in widget.options) {
      children.add(InkWell(
        onTap: widget.disabled
            ? null
            : () {
                setState(() {
                  if (_selected.contains(opt)) {
                    _selected.remove(opt);
                  } else {
                    _selected.add(opt);
                  }
                });
                _emitGroup();
              },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _wrap(Checkbox(
              fillColor: const WidgetStatePropertyAll(Colors.white),
              checkColor: Colors.black,
              side: WidgetStateBorderSide.resolveWith((_) => const BorderSide(color: Colors.black, width: 1)),
              value: _selected.contains(opt),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
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
            )),
            Flexible(child: Text(opt)),
          ],
        ),
      ));
    }

    if (widget.hasOther) {
      void toggleOther() {
        setState(() {
          if (_selected.contains('Other')) {
            _selected.remove('Other');
          } else {
            _selected.add('Other');
          }
        });
        _emitGroup();
      }
      children.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: widget.disabled ? null : toggleOther,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _wrap(Checkbox(
                  fillColor: const WidgetStatePropertyAll(Colors.white),
                  checkColor: Colors.black,
                  side: WidgetStateBorderSide.resolveWith((_) => const BorderSide(color: Colors.black, width: 1)),
                  value: _selected.contains('Other'),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  onChanged: widget.disabled ? null : (_) => toggleOther(),
                )),
                const Text('Other: '),
              ],
            ),
          ),
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

    if (widget.rowLayout) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );
    }
    return Wrap(spacing: 8, runSpacing: 4, children: children);
  }
}
