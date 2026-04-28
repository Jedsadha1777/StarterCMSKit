import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'preview_shell.dart';
import 'form_widgets/form_widgets.dart';

// CSS Color Module Level 4 named colors (147). ARGB int values; matches the
// list in style-parser.js _CSS_NAMED_HEX so JSON output and Flutter render
// stay in sync.
const Map<String, int> _cssNamedColors = {
  'aliceblue':            0xFFF0F8FF, 'antiquewhite':         0xFFFAEBD7,
  'aqua':                 0xFF00FFFF, 'aquamarine':           0xFF7FFFD4,
  'azure':                0xFFF0FFFF, 'beige':                0xFFF5F5DC,
  'bisque':               0xFFFFE4C4, 'black':                0xFF000000,
  'blanchedalmond':       0xFFFFEBCD, 'blue':                 0xFF0000FF,
  'blueviolet':           0xFF8A2BE2, 'brown':                0xFFA52A2A,
  'burlywood':            0xFFDEB887, 'cadetblue':            0xFF5F9EA0,
  'chartreuse':           0xFF7FFF00, 'chocolate':            0xFFD2691E,
  'coral':                0xFFFF7F50, 'cornflowerblue':       0xFF6495ED,
  'cornsilk':             0xFFFFF8DC, 'crimson':              0xFFDC143C,
  'cyan':                 0xFF00FFFF, 'darkblue':             0xFF00008B,
  'darkcyan':             0xFF008B8B, 'darkgoldenrod':        0xFFB8860B,
  'darkgray':             0xFFA9A9A9, 'darkgreen':            0xFF006400,
  'darkgrey':             0xFFA9A9A9, 'darkkhaki':            0xFFBDB76B,
  'darkmagenta':          0xFF8B008B, 'darkolivegreen':       0xFF556B2F,
  'darkorange':           0xFFFF8C00, 'darkorchid':           0xFF9932CC,
  'darkred':              0xFF8B0000, 'darksalmon':           0xFFE9967A,
  'darkseagreen':         0xFF8FBC8F, 'darkslateblue':        0xFF483D8B,
  'darkslategray':        0xFF2F4F4F, 'darkslategrey':        0xFF2F4F4F,
  'darkturquoise':        0xFF00CED1, 'darkviolet':           0xFF9400D3,
  'deeppink':             0xFFFF1493, 'deepskyblue':          0xFF00BFFF,
  'dimgray':              0xFF696969, 'dimgrey':              0xFF696969,
  'dodgerblue':           0xFF1E90FF, 'firebrick':            0xFFB22222,
  'floralwhite':          0xFFFFFAF0, 'forestgreen':          0xFF228B22,
  'fuchsia':              0xFFFF00FF, 'gainsboro':            0xFFDCDCDC,
  'ghostwhite':           0xFFF8F8FF, 'gold':                 0xFFFFD700,
  'goldenrod':            0xFFDAA520, 'gray':                 0xFF808080,
  'green':                0xFF008000, 'greenyellow':          0xFFADFF2F,
  'grey':                 0xFF808080, 'honeydew':             0xFFF0FFF0,
  'hotpink':              0xFFFF69B4, 'indianred':            0xFFCD5C5C,
  'indigo':               0xFF4B0082, 'ivory':                0xFFFFFFF0,
  'khaki':                0xFFF0E68C, 'lavender':             0xFFE6E6FA,
  'lavenderblush':        0xFFFFF0F5, 'lawngreen':            0xFF7CFC00,
  'lemonchiffon':         0xFFFFFACD, 'lightblue':            0xFFADD8E6,
  'lightcoral':           0xFFF08080, 'lightcyan':            0xFFE0FFFF,
  'lightgoldenrodyellow': 0xFFFAFAD2, 'lightgray':            0xFFD3D3D3,
  'lightgreen':           0xFF90EE90, 'lightgrey':            0xFFD3D3D3,
  'lightpink':            0xFFFFB6C1, 'lightsalmon':          0xFFFFA07A,
  'lightseagreen':        0xFF20B2AA, 'lightskyblue':         0xFF87CEFA,
  'lightslategray':       0xFF778899, 'lightslategrey':       0xFF778899,
  'lightsteelblue':       0xFFB0C4DE, 'lightyellow':          0xFFFFFFE0,
  'lime':                 0xFF00FF00, 'limegreen':            0xFF32CD32,
  'linen':                0xFFFAF0E6, 'magenta':              0xFFFF00FF,
  'maroon':               0xFF800000, 'mediumaquamarine':     0xFF66CDAA,
  'mediumblue':           0xFF0000CD, 'mediumorchid':         0xFFBA55D3,
  'mediumpurple':         0xFF9370DB, 'mediumseagreen':       0xFF3CB371,
  'mediumslateblue':      0xFF7B68EE, 'mediumspringgreen':    0xFF00FA9A,
  'mediumturquoise':      0xFF48D1CC, 'mediumvioletred':      0xFFC71585,
  'midnightblue':         0xFF191970, 'mintcream':            0xFFF5FFFA,
  'mistyrose':            0xFFFFE4E1, 'moccasin':             0xFFFFE4B5,
  'navajowhite':          0xFFFFDEAD, 'navy':                 0xFF000080,
  'oldlace':              0xFFFDF5E6, 'olive':                0xFF808000,
  'olivedrab':            0xFF6B8E23, 'orange':               0xFFFFA500,
  'orangered':            0xFFFF4500, 'orchid':               0xFFDA70D6,
  'palegoldenrod':        0xFFEEE8AA, 'palegreen':            0xFF98FB98,
  'paleturquoise':        0xFFAFEEEE, 'palevioletred':        0xFFDB7093,
  'papayawhip':           0xFFFFEFD5, 'peachpuff':            0xFFFFDAB9,
  'peru':                 0xFFCD853F, 'pink':                 0xFFFFC0CB,
  'plum':                 0xFFDDA0DD, 'powderblue':           0xFFB0E0E6,
  'purple':               0xFF800080, 'rebeccapurple':        0xFF663399,
  'red':                  0xFFFF0000, 'rosybrown':            0xFFBC8F8F,
  'royalblue':            0xFF4169E1, 'saddlebrown':          0xFF8B4513,
  'salmon':               0xFFFA8072, 'sandybrown':           0xFFF4A460,
  'seagreen':             0xFF2E8B57, 'seashell':             0xFFFFF5EE,
  'sienna':               0xFFA0522D, 'silver':               0xFFC0C0C0,
  'skyblue':              0xFF87CEEB, 'slateblue':            0xFF6A5ACD,
  'slategray':            0xFF708090, 'slategrey':            0xFF708090,
  'snow':                 0xFFFFFAFA, 'springgreen':          0xFF00FF7F,
  'steelblue':            0xFF4682B4, 'tan':                  0xFFD2B48C,
  'teal':                 0xFF008080, 'thistle':              0xFFD8BFD8,
  'tomato':               0xFFFF6347, 'transparent':          0x00000000,
  'turquoise':            0xFF40E0D0, 'violet':               0xFFEE82EE,
  'wheat':                0xFFF5DEB3, 'white':                0xFFFFFFFF,
  'whitesmoke':           0xFFF5F5F5, 'yellow':               0xFFFFFF00,
  'yellowgreen':          0xFF9ACD32,
};

class FormRenderer extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String fieldName, dynamic value)? onChanged;

  const FormRenderer({
    super.key,
    required this.schema,
    this.onChanged,
  });

  @override
  State<FormRenderer> createState() => FormRendererState();
}

class FormRendererState extends State<FormRenderer> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _captureKey = GlobalKey();
  bool _snapMode = false;

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _dropdownValues = {};
  final Map<String, bool> _checkboxValues = {};
  // Non-controller widgets (FormDate/FormSearch/FormSignature/FormImageUpload/FormFile/FormRadio)
  final Map<String, String?> _dateValues = {};
  final Map<String, String?> _timeValues = {};
  final Map<String, String?> _searchValues = {};
  final Map<String, Uint8List?> _signatureBytes = {};
  final Map<String, dynamic> _otherValues = {};

  String? _currentWhiteSpace;
  String? _currentTextAlign;
  String? _currentTextTransform;

  List<dynamic> get _pages => widget.schema['pages'] as List? ?? [];
  List<dynamic> get _fields => widget.schema['fields'] as List? ?? [];

  GlobalKey get captureKey => _captureKey;
  bool get snapMode => _snapMode;

  /// Toggle snap mode (hides input borders for screenshot capture)
  void setSnapMode(bool value) {
    if (_snapMode != value) setState(() => _snapMode = value);
  }

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  @override
  void didUpdateWidget(FormRenderer old) {
    super.didUpdateWidget(old);
    if (old.schema != widget.schema) {
      _controllers.forEach((_, c) => c.dispose());
      _controllers.clear();
      _dropdownValues.clear();
      _checkboxValues.clear();
      _dateValues.clear();
      _timeValues.clear();
      _searchValues.clear();
      _signatureBytes.clear();
      _otherValues.clear();
      _initFields();
    }
  }

  void _initFields() {
    for (final f in _fields) {
      final name = f['name'] as String? ?? '';
      final type = f['fieldType'] as String? ?? '';
      switch (type) {
        case 'select':
          final options = f['options'] as List? ?? [];
          _dropdownValues[name] = options.isNotEmpty
              ? (options.first['value'] as String? ?? '')
              : null;
          break;
        case 'checkbox':
          _checkboxValues[name] = false;
          break;
        case 'date-picker':
          _dateValues[name] = null;
          break;
        case 'time-picker':
          _timeValues[name] = null;
          break;
        case 'search':
          _searchValues[name] = null;
          break;
        case 'signature':
          _signatureBytes[name] = null;
          break;
        case 'radio':
        case 'image-upload':
        case 'file':
          _otherValues[name] = null;
          break;
        default:
          _controllers[name] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  Map<String, dynamic> collectValues() {
    final values = <String, dynamic>{};
    _controllers.forEach((k, c) => values[k] = c.text);
    _dropdownValues.forEach((k, v) => values[k] = v);
    _checkboxValues.forEach((k, v) => values[k] = v);
    _dateValues.forEach((k, v) => values[k] = v);
    _timeValues.forEach((k, v) => values[k] = v);
    _searchValues.forEach((k, v) => values[k] = v);
    _signatureBytes.forEach((k, v) => values[k] = v != null ? base64Encode(v) : null);
    _otherValues.forEach((k, v) => values[k] = v);
    return values;
  }

  void _onFieldChanged(String name, dynamic value) {
    widget.onChanged?.call(name, value);
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      return const Center(child: Text('No pages in schema'));
    }

    // _captureKey only on the first page — GlobalKeys must be unique in the
    // tree, and screenshot capture targets the first page anyway.
    final pageWidgets = <Widget>[];
    for (var i = 0; i < _pages.length; i++) {
      pageWidgets.add(RepaintBoundary(
        key: i == 0 ? _captureKey : ValueKey('page_$i'),
        child: _buildNode(_pages[i]),
      ));
    }

    return Form(
      key: _formKey,
      child: PreviewShell(pages: pageWidgets),
    );
  }

  Widget _buildNode(dynamic node) {
    if (node == null) return const SizedBox.shrink();
    if (node is! Map<String, dynamic>) return const SizedBox.shrink();

    final type = node['type'] as String? ?? '';
    final name = node['name'] as String? ?? '';

    switch (type) {
      case 'column':
        return _buildColumn(node);
      case 'container':
        return _buildContainer(node);
      case 'stack':
        return _buildStack(node);
      case 'text':
        return _buildText(node);
      case 'richtext':
        return _buildRichText(node);
      case 'table':
        return _buildTable(node);
      case 'input':
        return FormInput.fromJson(
          node,
          controller: _controllers[name],
          onChanged: (v) => _onFieldChanged(name, v),
        );
      case 'select':
        return FormSelect.fromJson(
          node,
          onChanged: (v) {
            setState(() => _dropdownValues[name] = v);
            _onFieldChanged(name, v);
          },
        );
      case 'textarea':
        return FormTextarea.fromJson(
          node,
          controller: _controllers[name],
          onChanged: (v) => _onFieldChanged(name, v),
        );
      case 'date-picker':
        return FormDate.fromJson(
          node,
          onChanged: (v) {
            setState(() => _dateValues[name] = v);
            _onFieldChanged(name, v);
          },
        );
      case 'time-picker':
        return FormTime.fromJson(
          node,
          onChanged: (v) {
            setState(() => _timeValues[name] = v);
            _onFieldChanged(name, v);
          },
        );
      case 'signature':
        return FormSignature.fromJson(
          node,
          onSigned: (v) {
            setState(() => _signatureBytes[name] = v);
            _onFieldChanged(name, v);
          },
        );
      case 'image-upload':
        return FormImageUpload.fromJson(
          node,
          onPicked: (v) {
            setState(() => _otherValues[name] = v);
            _onFieldChanged(name, v);
          },
        );
      case 'checkbox':
        return FormCheckbox.fromJson(
          node,
          onChanged: (v) {
            if (v is bool) {
              setState(() => _checkboxValues[name] = v);
            } else {
              setState(() => _otherValues[name] = v);
            }
            _onFieldChanged(name, v);
          },
        );
      case 'radio':
        return FormRadio.fromJson(
          node,
          onChanged: (v) {
            setState(() => _otherValues[name] = v);
            _onFieldChanged(name, v);
          },
        );
      case 'file':
        return FormFile.fromJson(
          node,
          onPicked: (v) {
            setState(() => _otherValues[name] = v);
            _onFieldChanged(name, v);
          },
        );
      case 'search':
        return FormSearch.fromJson(
          node,
          onSelected: (v) {
            setState(() => _searchValues[name] = v != null ? (v['name'] as String? ?? v.values.first?.toString()) : null);
            _onFieldChanged(name, v);
          },
        );
      case 'spacer':
        return SizedBox(height: (node['height'] as num?)?.toDouble() ?? 8);
      case 'divider':
        return const Divider();
      case 'image':
        return _buildImage(node);
      case 'list':
        return _buildList(node);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildColumn(Map<String, dynamic> node) {
    final children = node['children'] as List? ?? [];
    final stretch = node['stretch'] == true;
    return Column(
      crossAxisAlignment: stretch ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children.map((c) => _buildNode(c)).toList(),
    );
  }

  Widget _buildContainer(Map<String, dynamic> node) {
    final style = node['style'] as Map<String, dynamic>? ?? {};
    Widget child = _buildNode(node['child']);

    final textStyle = _cellTextStyle(style);
    if (textStyle != null) {
      child = DefaultTextStyle.merge(style: textStyle, child: child);
    }

    final widthVal = style['width'];
    final heightVal = style['height'];

    final border = _parseContainerBorder(style['border'] as Map<String, dynamic>?);
    final borderLeft = _parseSingleBorder(style['borderLeft'] as Map<String, dynamic>?);

    Border? finalBorder = border;
    if (borderLeft != null && finalBorder == null) {
      finalBorder = Border(left: borderLeft);
    }

    final paddingRaw = style['padding'] as Map<String, dynamic>?;
    final marginRaw = style['margin'] as Map<String, dynamic>?;
    final hAlign = _marginHAlign(marginRaw);
    final needsLB = _edgeInsetsIsResponsive(paddingRaw) || _edgeInsetsIsResponsive(marginRaw)
        || _isResponsiveSide(widthVal) || _isResponsiveSide(heightVal);

    double? resolveSize(dynamic v, double parentW, double vpW, double vpH) {
      if (v == 'infinity') return double.infinity;
      if (v is Map) return _resolveSide(v, parentW, vpW, vpH);
      return _dim(v);
    }

    Widget build(double parentW, double vpW, double vpH) {
      Widget result = Container(
        width: resolveSize(widthVal, parentW, vpW, vpH),
        height: resolveSize(heightVal, parentW, vpW, vpH),
        padding: paddingRaw != null ? _resolveEdgeInsets(paddingRaw, parentW, vpW, vpH) : null,
        margin: marginRaw != null ? _resolveEdgeInsets(marginRaw, parentW, vpW, vpH) : null,
        decoration: BoxDecoration(
          color: _color(style['backgroundColor']),
          border: finalBorder,
          borderRadius: style['borderRadius'] != null
              ? BorderRadius.circular((style['borderRadius'] as num).toDouble())
              : null,
        ),
        child: child,
      );

      if (hAlign != null) {
        result = Align(alignment: hAlign, child: result);
      }

      final rotate = style['rotateAngle'];
      if (rotate != null && rotate != 0) {
        final radians = (rotate as num).toDouble() * 3.14159265 / 180;
        result = Transform.rotate(angle: radians, child: result);
      }

      return result;
    }

    if (needsLB) {
      return LayoutBuilder(
        builder: (ctx, constraints) {
          final vp = MediaQuery.of(ctx).size;
          final parentW = constraints.maxWidth.isFinite ? constraints.maxWidth : vp.width;
          return build(parentW, vp.width, vp.height);
        },
      );
    }

    return build(0, 0, 0);
  }

  Widget _buildStack(Map<String, dynamic> node) {
    final rawChildren = (node['children'] as List?) ?? const [];
    final children = <Widget>[];
    for (final c in rawChildren) {
      if (c is! Map<String, dynamic>) continue;
      if (c['type'] == 'positioned') {
        final built = _buildPositioned(c);
        if (built != null) children.add(built);
      } else {
        children.add(_buildNode(c));
      }
    }
    return Stack(children: children);
  }

  // Over-constrained resolution: if left+right+width all given, drop right
  // (matches CSS LTR behavior and avoids Flutter's Positioned assertion).
  Widget? _buildPositioned(Map<String, dynamic> node) {
    final child = _buildNode(node['child']);
    double? left   = (node['left']   as num?)?.toDouble();
    double? top    = (node['top']    as num?)?.toDouble();
    double? right  = (node['right']  as num?)?.toDouble();
    double? bottom = (node['bottom'] as num?)?.toDouble();
    final width   = (node['width']  as num?)?.toDouble();
    final height  = (node['height'] as num?)?.toDouble();

    if (left != null && right != null && width != null) right = null;
    if (top != null && bottom != null && height != null) bottom = null;

    final stretched = left == 0 && right == 0 && top == 0 && bottom == 0
        && width == null && height == null;
    if (stretched) {
      return Positioned.fill(child: child);
    }

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }

  Border? _parseContainerBorder(Map<String, dynamic>? data) {
    if (data == null) return null;
    BorderSide side(Map<String, dynamic> s) => BorderSide(
      color: _color(s['color']) ?? Colors.black,
      width: (s['width'] as num?)?.toDouble() ?? 1,
    );
    return Border(
      top: data['top'] is Map<String, dynamic> ? side(data['top']) : BorderSide.none,
      bottom: data['bottom'] is Map<String, dynamic> ? side(data['bottom']) : BorderSide.none,
      left: data['left'] is Map<String, dynamic> ? side(data['left']) : BorderSide.none,
      right: data['right'] is Map<String, dynamic> ? side(data['right']) : BorderSide.none,
    );
  }

  BorderSide? _parseSingleBorder(Map<String, dynamic>? data) {
    if (data == null) return null;
    return BorderSide(
      color: _color(data['color']) ?? Colors.black,
      width: (data['width'] as num?)?.toDouble() ?? 1,
    );
  }

  String _applyTextTransform(String text) {
    if (_currentTextTransform == 'uppercase') return text.toUpperCase();
    if (_currentTextTransform == 'lowercase') return text.toLowerCase();
    return text;
  }

  Widget _buildText(Map<String, dynamic> node) {
    final content = _applyTextTransform(node['content'] as String? ?? '');
    final style = node['style'] as Map<String, dynamic>?;
    final isNowrap = _currentWhiteSpace == 'nowrap';
    final align = _textAlign(style?['textAlign']) ?? _textAlign(_currentTextAlign);
    return Text(
      content,
      textAlign: align,
      style: style != null ? _textStyle(style) : null,
      softWrap: !isNowrap,
      overflow: isNowrap ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }

  Widget _buildRichText(Map<String, dynamic> node) {
    final spans = node['spans'] as List? ?? [];
    if (spans.isEmpty) return const SizedBox.shrink();

    final textSpans = spans.map<InlineSpan>((s) {
      final spanMap = s as Map<String, dynamic>;
      final text = _applyTextTransform(spanMap['text'] as String? ?? '');
      final style = spanMap['style'] as Map<String, dynamic>?;
      return TextSpan(
        text: text,
        style: style != null ? _textStyle(style) : null,
      );
    }).toList();

    final isNowrap = _currentWhiteSpace == 'nowrap';
    final align = _textAlign(_currentTextAlign) ?? TextAlign.start;
    return RichText(
      softWrap: !isNowrap,
      overflow: isNowrap ? TextOverflow.ellipsis : TextOverflow.clip,
      textAlign: align,
      text: TextSpan(children: textSpans),
    );
  }

  Widget _buildTable(Map<String, dynamic> node) {
    final placementsList = node['placements'] as List?;
    final colSpecList = node['columnSpecs'] as List? ?? [];
    final rowHeightList = node['rowHeights'] as List? ?? [];
    final borderWidth = (node['borderWidth'] as num?)?.toDouble() ?? 0;
    final matrixRaw = node['matrixData'] as List? ?? [];
    final numRows = (node['numRows'] as int?) ?? 0;
    final numCols = (node['numCols'] as int?) ?? 0;

    if (numRows == 0 || numCols == 0 || placementsList == null) {
      return const SizedBox.shrink();
    }

    final rowHeights = rowHeightList.map((v) => (v as num).toDouble()).toList();
    final matrixData = matrixRaw
        .map((row) => (row as List).map((v) => (v as int)).toList())
        .toList();

    final fixedWidth = _dim(node['fixedWidth']);

    Widget layoutBuilder = LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = fixedWidth != null
            ? fixedWidth.clamp(0.0, constraints.maxWidth)
            : constraints.maxWidth;

        double totalFixed = 0, totalPercent = 0;
        int flexCount = 0;
        for (final spec in colSpecList) {
          if (spec is Map<String, dynamic>) {
            final type = spec['type'] as String?;
            if (type == 'fixed' || type == 'shrink') {
              totalFixed += (spec['value'] as num?)?.toDouble() ?? 0;
            } else if (type == 'percent') {
              totalPercent += (spec['value'] as num?)?.toDouble() ?? 0;
            } else {
              flexCount++;
            }
          } else {
            flexCount++;
          }
        }
        final pctUnit = availableWidth.isInfinite ? 0.0 : availableWidth / 100;
        final double flexSpace = availableWidth.isInfinite
            ? 0.0
            : (availableWidth - totalFixed - pctUnit * totalPercent).clamp(0.0, double.maxFinite);
        final double flexUnit = availableWidth.isInfinite ? 200.0 : (flexCount > 0 ? flexSpace / flexCount : 0.0);

        final colWidths = <double>[];
        for (final spec in colSpecList) {
          if (spec is Map<String, dynamic>) {
            final type = spec['type'] as String?;
            final value = (spec['value'] as num?)?.toDouble() ?? 0;
            if (type == 'fixed' || type == 'shrink') {
              colWidths.add(value);
            } else if (type == 'percent') {
              colWidths.add(pctUnit * value);
            } else {
              colWidths.add(flexUnit);
            }
          } else {
            colWidths.add(flexUnit);
          }
        }

        final colStarts = <double>[0];
        for (final w in colWidths) {
          colStarts.add(colStarts.last + w);
        }
        final rowStarts = <double>[0];
        for (final h in rowHeights) {
          rowStarts.add(rowStarts.last + h);
        }

        final totalWidth = colStarts.last;
        final totalHeight = rowStarts.last;

        final children = <Widget>[];

        for (final p in placementsList) {
      final pMap = p as Map<String, dynamic>;
      final col = (pMap['col'] as int?) ?? 0;
      final row = (pMap['row'] as int?) ?? 0;
      final colEnd = (pMap['colEnd'] as int?) ?? (col + 1);
      final rowEnd = (pMap['rowEnd'] as int?) ?? (row + 1);

      if (col >= colStarts.length - 1 || row >= rowStarts.length - 1) continue;

      final left = colStarts[col];
      final top = rowStarts[row];
      final safeColEnd = colEnd.clamp(0, colStarts.length - 1);
      final safeRowEnd = rowEnd.clamp(0, rowStarts.length - 1);
      final width = colStarts[safeColEnd] - left;
      final height = rowStarts[safeRowEnd] - top;

      if (width <= 0 || height <= 0) continue;

      final cellStyle = pMap['style'] as Map<String, dynamic>? ?? {};
      final padMap = pMap['padding'] as Map<String, dynamic>?;

      final bg = _color(cellStyle['backgroundColor']);
      final borderDashData = cellStyle['borderDash'] as Map<String, dynamic>?;
      final dashSides = <_DashSide>[];
      final dashSkipSides = <String>{};
      if (borderDashData != null) {
        for (final side in const ['top', 'right', 'bottom', 'left']) {
          final entry = borderDashData[side];
          if (entry is Map<String, dynamic>) {
            final cssStyle = (entry['cssStyle'] as String?) ?? 'solid';
            final w = (entry['width'] as num?)?.toDouble() ?? 1.0;
            final c = _color(entry['color']) ?? Colors.black;
            final dotted = cssStyle == 'dotted';
            final doubled = cssStyle == 'double';
            switch (side) {
              case 'top':    dashSides.add(_DashSide.top(color: c, width: w, dotted: dotted, doubled: doubled)); break;
              case 'right':  dashSides.add(_DashSide.right(color: c, width: w, dotted: dotted, doubled: doubled)); break;
              case 'bottom': dashSides.add(_DashSide.bottom(color: c, width: w, dotted: dotted, doubled: doubled)); break;
              case 'left':   dashSides.add(_DashSide.left(color: c, width: w, dotted: dotted, doubled: doubled)); break;
            }
            dashSkipSides.add(side);
          }
        }
      }
      final cellBorder = _parseCellBorder(
        cellStyle['cellBorder'] as Map<String, dynamic>?,
        skipSides: dashSkipSides.isEmpty ? null : dashSkipSides,
      );
      final gradientData = cellStyle['gradient'] as Map<String, dynamic>?;

      final pad = padMap != null
          ? EdgeInsets.fromLTRB(
              (padMap['left'] as num?)?.toDouble() ?? 0,
              (padMap['top'] as num?)?.toDouble() ?? 0,
              (padMap['right'] as num?)?.toDouble() ?? 0,
              (padMap['bottom'] as num?)?.toDouble() ?? 0,
            )
          : EdgeInsets.zero;

      final align = _alignment(
        cellStyle['textAlign'] as String?,
        cellStyle['verticalAlign'] as String?,
      );

      // Save/restore so nested table cells don't clobber the outer cell's
      // text state. try/finally guards against widget-build exceptions.
      final prevWS = _currentWhiteSpace;
      final prevTA = _currentTextAlign;
      final prevTT = _currentTextTransform;
      _currentWhiteSpace = cellStyle['whiteSpace'] as String?;
      _currentTextAlign = cellStyle['textAlign'] as String?;
      _currentTextTransform = cellStyle['textTransform'] as String?;

      Widget content;
      try {
        content = pMap['child'] != null
            ? _buildNode(pMap['child'])
            : const SizedBox.shrink();
      } finally {
        _currentWhiteSpace = prevWS;
        _currentTextAlign = prevTA;
        _currentTextTransform = prevTT;
      }

      final ts = _cellTextStyle(cellStyle);
      if (ts != null) {
        content = DefaultTextStyle.merge(style: ts, child: content);
      }

      Decoration? decoration;
      if (gradientData != null) {
        final gColor = _color(gradientData['color'] as String?) ?? Colors.blue;
        final percent = ((gradientData['percent'] as num?)?.toDouble() ?? 50) / 100;
        final dir = gradientData['direction'] as String? ?? 'right';
        final begin = dir == 'left' ? Alignment.centerRight
            : dir == 'top' ? Alignment.bottomCenter
            : dir == 'bottom' ? Alignment.topCenter
            : Alignment.centerLeft;
        final end = dir == 'left' ? Alignment.centerLeft
            : dir == 'top' ? Alignment.topCenter
            : dir == 'bottom' ? Alignment.bottomCenter
            : Alignment.centerRight;
        decoration = BoxDecoration(
          gradient: LinearGradient(begin: begin, end: end, colors: [gColor, Colors.transparent], stops: [percent, percent]),
          border: cellBorder,
        );
      } else if (bg != null || cellBorder != null) {
        decoration = BoxDecoration(color: bg, border: cellBorder);
      }

      Widget cellWidget = Container(
        decoration: decoration,
        padding: pad,
        alignment: align,
        child: content,
      );

      if (dashSides.isNotEmpty) {
        cellWidget = Stack(children: [
          cellWidget,
          Positioned.fill(child: IgnorePointer(
            child: CustomPaint(painter: _DashedBorderPainter(sides: dashSides)),
          )),
        ]);
      }

      final rotateAngle = cellStyle['rotateAngle'];
      if (rotateAngle != null && rotateAngle != 0) {
        final radians = (rotateAngle as num).toDouble() * 3.14159265 / 180;
        cellWidget = Transform.rotate(angle: radians, child: cellWidget);
      }

      final diagLines = pMap['diagonalLines'] as List?;
      if (diagLines != null && diagLines.isNotEmpty) {
        final diag = diagLines.first as Map<String, dynamic>;
        final tlbr = diag['topLeftToBottomRight'] == true;
        final bltr = diag['bottomLeftToTopRight'] == true;
        final diagColor = _color(diag['color'] as String?) ?? Colors.black;
        final diagStroke = (diag['width'] as num?)?.toDouble() ?? 1;
        cellWidget = Stack(children: [
          cellWidget,
          Positioned.fill(child: IgnorePointer(
            child: CustomPaint(painter: _DiagonalBorderPainter(
              color: diagColor, strokeWidth: diagStroke,
              topLeftToBottomRight: tlbr, bottomLeftToTopRight: bltr,
            )),
          )),
        ]);
      }

      final comment = pMap['comment'] as String?;
      if (comment != null) {
        cellWidget = Tooltip(message: comment, child: cellWidget);
      }

      children.add(Positioned(
        left: left, top: top, width: width, height: height,
        child: cellWidget,
      ));
    }

        if (borderWidth > 0) {
          children.add(Positioned.fill(
            child: IgnorePointer(child: CustomPaint(
              painter: _TableGridPainter(
                colStarts: colStarts,
                rowStarts: rowStarts,
                borderColor: Colors.black,
                borderWidth: borderWidth,
                matrixData: matrixData,
                numRows: numRows,
                numCols: numCols,
              ),
            )),
          ));
        }

        Widget table = SizedBox(
          width: totalWidth,
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: children,
          ),
        );

        return table;
      },
    );

    final tableStyle = node['tableStyle'] as Map<String, dynamic>?;
    if (tableStyle != null) {
      final tBorder = _parseCellBorder(tableStyle['border'] as Map<String, dynamic>?);
      final tRadius = _dim(tableStyle['borderRadius']);
      final tMargin = _edgeInsets(tableStyle['margin']);
      final tPadding = _edgeInsets(tableStyle['padding']);
      final tBg = _color(tableStyle['backgroundColor']);
      final hasDecor = tBorder != null || tRadius != null || tBg != null;
      layoutBuilder = Container(
        margin: tMargin,
        padding: tPadding,
        clipBehavior: tRadius != null ? Clip.antiAlias : Clip.none,
        decoration: hasDecor ? BoxDecoration(
          border: tBorder,
          borderRadius: tRadius != null ? BorderRadius.circular(tRadius) : null,
          color: tBg,
        ) : null,
        child: layoutBuilder,
      );
    }

    return layoutBuilder;
  }

  /// Parse structured cell border JSON into Flutter Border.
  /// [skipSides] — sides listed here are rendered as dashed/dotted/double overlay elsewhere,
  /// so skip them here to avoid drawing a solid line on top of the overlay.
  Border? _parseCellBorder(Map<String, dynamic>? data, {Set<String>? skipSides}) {
    if (data == null) return null;
    BorderSide side(Map<String, dynamic> s) => BorderSide(
      color: _color(s['color']) ?? Colors.black,
      width: (s['width'] as num?)?.toDouble() ?? 1,
    );
    BorderSide resolve(String key) {
      if (skipSides != null && skipSides.contains(key)) return BorderSide.none;
      final v = data[key];
      return v is Map<String, dynamic> ? side(v) : BorderSide.none;
    }
    return Border(
      top: resolve('top'),
      bottom: resolve('bottom'),
      left: resolve('left'),
      right: resolve('right'),
    );
  }

  /// Build a TextStyle from cell-level style properties
  TextStyle? _cellTextStyle(Map<String, dynamic> style) {
    final fontSize = _dim(style['fontSize']);
    final fontWeight = _fontWeight(style['fontWeight']);
    final color = _color(style['color']);
    final fontFamily = style['fontFamily'] as String?;
    final fontStyle = style['fontStyle'] == 'italic' ? FontStyle.italic : null;
    final decoration = _textDecoration(style['textDecoration']);
    final lineHeight = _dim(style['lineHeight']);

    if (fontSize == null && fontWeight == null && color == null &&
        fontFamily == null && fontStyle == null && decoration == null &&
        lineHeight == null) {
      return null;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      decoration: decoration,
      height: lineHeight,
    );
  }

  Widget _buildImage(Map<String, dynamic> node) {
    final src = node['src'] as String? ?? '';
    final w = _dim(node['width']);
    final h = _dim(node['height']);
    final alt = node['alt'] as String?;
    final fit = _parseBoxFit(node['objectFit'] as String?);

    Widget fallback() => Container(
      width: w ?? 100,
      height: h ?? 100,
      color: const Color(0xFFEEEEEE),
      alignment: Alignment.center,
      child: (alt != null && alt.isNotEmpty)
          ? Text(alt, style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)), textAlign: TextAlign.center)
          : const Icon(Icons.broken_image, size: 32, color: Color(0xFF9E9E9E)),
    );

    if (src.startsWith('http')) {
      return Image.network(src, width: w, height: h, fit: fit,
        errorBuilder: (ctx, err, stack) => fallback());
    }
    if (src.startsWith('assets/')) {
      return Image.asset(src, width: w, height: h, fit: fit,
        errorBuilder: (ctx, err, stack) => fallback());
    }
    if (src.startsWith('data:')) {
      final comma = src.indexOf(',');
      if (comma >= 0) {
        try {
          final bytes = base64Decode(src.substring(comma + 1));
          return Image.memory(bytes, width: w, height: h, fit: fit,
            errorBuilder: (ctx, err, stack) => fallback());
        } catch (_) {
          return fallback();
        }
      }
    }
    return fallback();
  }

  BoxFit _parseBoxFit(String? v) {
    switch (v) {
      case 'cover':     return BoxFit.cover;
      case 'fill':      return BoxFit.fill;
      case 'none':      return BoxFit.none;
      case 'scaleDown': return BoxFit.scaleDown;
      case 'contain':
      default:          return BoxFit.contain;
    }
  }

  Widget _buildList(Map<String, dynamic> node) {
    final ordered = node['ordered'] == true;
    final items = node['items'] as List? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((e) {
        final prefix = ordered ? '${e.key + 1}. ' : '\u2022 ';
        final item = e.value;
        if (item is String) {
          return Text('$prefix$item');
        }
        if (item is Map<String, dynamic>) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prefix),
              Expanded(child: _buildNode(item)),
            ],
          );
        }
        return Text('$prefix$item');
      }).toList(),
    );
  }

  double? _dim(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is Map) {
      // Tagged unit ({unit, value}) — only resolvable in LayoutBuilder context.
      // Non-LB callers see null and fall back to defaults.
      return null;
    }
    if (v is String) {
      final m = RegExp(r'^(\d+(?:\.\d+)?)').firstMatch(v);
      if (m != null) return double.tryParse(m.group(1)!);
    }
    return null;
  }

  Color? _color(dynamic v) {
    if (v == null) return null;
    if (v is! String) return null;
    final s = v.trim();
    if (s.isEmpty) return null;

    if (s.startsWith('#')) return _parseHex(s.substring(1));

    final lower = s.toLowerCase();
    if (lower.endsWith(')')) {
      if (lower.startsWith('rgb('))  return _parseRgb(s.substring(4, s.length - 1), false);
      if (lower.startsWith('rgba(')) return _parseRgb(s.substring(5, s.length - 1), true);
      if (lower.startsWith('hsl('))  return _parseHsl(s.substring(4, s.length - 1));
      if (lower.startsWith('hsla(')) return _parseHsl(s.substring(5, s.length - 1));
    }

    final named = _cssNamedColors[lower];
    if (named != null) return Color(named);
    return null;
  }

  Color? _parseHex(String hex) {
    if (hex.isEmpty) return null;
    for (final c in hex.codeUnits) {
      final isDigit = c >= 0x30 && c <= 0x39;
      final isLower = c >= 0x61 && c <= 0x66;
      final isUpper = c >= 0x41 && c <= 0x46;
      if (!isDigit && !isLower && !isUpper) return null;
    }
    var h = hex;
    if (h.length == 3 || h.length == 4) {
      h = h.split('').map((c) => '$c$c').join();
    }
    if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
    // CSS #RRGGBBAA → Flutter ARGB (0xAARRGGBB)
    if (h.length == 8) {
      return Color(int.parse(h.substring(6, 8) + h.substring(0, 6), radix: 16));
    }
    return null;
  }

  // Tokenize body into (number, isPercent) pairs.
  // Separators (`,` `whitespace` `/`) accepted between values; CSS engines are
  // lenient here, and json-generator never emits non-canonical forms anyway.
  List<List<num>>? _tokenizeColorArgs(String body) {
    final out = <List<num>>[];
    int i = 0;
    final n = body.length;
    while (i < n) {
      final c = body.codeUnitAt(i);
      // skip separators / whitespace
      if (c == 0x20 || c == 0x09 || c == 0x0A || c == 0x0D || c == 0x2C || c == 0x2F) { i++; continue; }
      // sign
      final start = i;
      if (c == 0x2B || c == 0x2D) i++;
      bool sawDigit = false;
      while (i < n) {
        final cc = body.codeUnitAt(i);
        if (cc < 0x30 || cc > 0x39) break;
        sawDigit = true;
        i++;
      }
      if (i < n && body.codeUnitAt(i) == 0x2E) {
        i++;
        while (i < n) {
          final cc = body.codeUnitAt(i);
          if (cc < 0x30 || cc > 0x39) break;
        sawDigit = true;
        i++;
        }
      }
      if (!sawDigit) return null;
      final value = double.tryParse(body.substring(start, i));
      if (value == null) return null;
      var pct = 0;
      if (i < n && body.codeUnitAt(i) == 0x25) { pct = 1; i++; }
      out.add([value, pct]);
    }
    return out;
  }

  Color? _parseRgb(String body, bool isRgba) {
    final tokens = _tokenizeColorArgs(body);
    if (tokens == null) return null;
    if (tokens.length < 3 || tokens.length > 4) return null;
    int chan(List<num> t) {
      final isPct = t[1] == 1;
      final px = isPct ? t[0] * 255 / 100 : t[0];
      return px.round().clamp(0, 255);
    }
    final r = chan(tokens[0]);
    final g = chan(tokens[1]);
    final b = chan(tokens[2]);
    final double a = tokens.length == 4
        ? (tokens[3][1] == 1 ? tokens[3][0] / 100 : tokens[3][0]).toDouble().clamp(0.0, 1.0)
        : 1.0;
    return Color.fromRGBO(r, g, b, a);
  }

  Color? _parseHsl(String body) {
    final tokens = _tokenizeColorArgs(body);
    if (tokens == null) return null;
    if (tokens.length < 3 || tokens.length > 4) return null;
    final h = tokens[0][0].toDouble() % 360;
    // saturation/lightness must be percent in CSS spec; accept bare numbers as %.
    final sat = (tokens[1][0].toDouble() / 100).clamp(0.0, 1.0);
    final lig = (tokens[2][0].toDouble() / 100).clamp(0.0, 1.0);
    final double a = tokens.length == 4
        ? (tokens[3][1] == 1 ? tokens[3][0] / 100 : tokens[3][0]).toDouble().clamp(0.0, 1.0)
        : 1.0;
    return HSLColor.fromAHSL(a, h, sat, lig).toColor();
  }

  TextStyle _textStyle(Map<String, dynamic> style) {
    return TextStyle(
      fontSize: _dim(style['fontSize']),
      fontWeight: _fontWeight(style['fontWeight']),
      fontStyle: style['fontStyle'] == 'italic' ? FontStyle.italic : null,
      color: _color(style['color']),
      backgroundColor: _color(style['backgroundColor']),
      decoration: _textDecoration(style['decoration']),
      fontFamily: style['fontFamily'] as String?,
    );
  }

  FontWeight? _fontWeight(dynamic v) {
    if (v == null) return null;
    final s = v.toString().toLowerCase();
    if (s == 'normal') return FontWeight.normal;
    if (s == 'bold' || s == 'bolder') return FontWeight.bold;
    if (s == 'lighter') return FontWeight.w300;
    switch (s) {
      case '100': return FontWeight.w100;
      case '200': return FontWeight.w200;
      case '300': return FontWeight.w300;
      case '400': return FontWeight.normal;
      case '500': return FontWeight.w500;
      case '600': return FontWeight.w600;
      case '700': return FontWeight.bold;
      case '800': return FontWeight.w800;
      case '900': return FontWeight.w900;
    }
    return null;
  }

  TextDecoration? _textDecoration(dynamic v) {
    if (v == null) return null;
    if (v == 'underline') return TextDecoration.underline;
    if (v == 'lineThrough') return TextDecoration.lineThrough;
    if (v == 'overline') return TextDecoration.overline;
    return null;
  }

  TextAlign? _textAlign(dynamic v) {
    if (v == null) return null;
    switch (v.toString().toLowerCase()) {
      case 'center': return TextAlign.center;
      case 'right': case 'end': return TextAlign.right;
      case 'justify': return TextAlign.justify;
      case 'left': case 'start': return TextAlign.left;
      default: return null;
    }
  }

  Alignment _alignment(String? hAlign, String? vAlign) {
    final h = (hAlign ?? '').toLowerCase();
    final v = (vAlign ?? '').toLowerCase();
    double x = -1, y = 0;
    if (h == 'center') x = 0;
    if (h == 'right' || h == 'end') x = 1;
    if (v == 'top') y = -1;
    if (v == 'bottom') y = 1;
    return Alignment(x, y);
  }

  EdgeInsets? _edgeInsets(dynamic v) {
    if (v == null) return null;
    if (v is Map<String, dynamic>) {
      return EdgeInsets.fromLTRB(
        _sideToPx(v['left']),
        _sideToPx(v['top']),
        _sideToPx(v['right']),
        _sideToPx(v['bottom']),
      );
    }
    return null;
  }

  // Non-responsive side resolver. Numbers pass through as px; tagged values
  // (pct/vh/vw/auto) degrade to 0 because this path has no parent-size context.
  double _sideToPx(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return 0;
  }

  bool _isResponsiveSide(dynamic v) =>
      v is Map && (v['t'] == 'pct' || v['t'] == 'vh' || v['t'] == 'vw');

  bool _isAutoSide(dynamic v) => v is Map && v['t'] == 'auto';

  bool _edgeInsetsIsResponsive(Map<String, dynamic>? m) {
    if (m == null) return false;
    return _isResponsiveSide(m['top']) || _isResponsiveSide(m['right']) ||
           _isResponsiveSide(m['bottom']) || _isResponsiveSide(m['left']);
  }

  double _resolveSide(dynamic v, double parentW, double viewportW, double viewportH) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is Map) {
      final t = v['t'];
      final val = (v['v'] as num?)?.toDouble() ?? 0;
      if (t == 'pct') return parentW * val / 100;
      if (t == 'vw')  return viewportW * val / 100;
      if (t == 'vh')  return viewportH * val / 100;
    }
    return 0;
  }

  EdgeInsets _resolveEdgeInsets(Map<String, dynamic>? m, double parentW, double viewportW, double viewportH) {
    if (m == null) return EdgeInsets.zero;
    return EdgeInsets.fromLTRB(
      _resolveSide(m['left'],   parentW, viewportW, viewportH),
      _resolveSide(m['top'],    parentW, viewportW, viewportH),
      _resolveSide(m['right'],  parentW, viewportW, viewportH),
      _resolveSide(m['bottom'], parentW, viewportW, viewportH),
    );
  }

  AlignmentGeometry? _marginHAlign(Map<String, dynamic>? m) {
    if (m == null) return null;
    final l = _isAutoSide(m['left']);
    final r = _isAutoSide(m['right']);
    if (l && r) return Alignment.topCenter;
    if (l && !r) return Alignment.topRight;
    if (!l && r) return Alignment.topLeft;
    return null;
  }
}

class _TableGridPainter extends CustomPainter {
  final List<double> colStarts;
  final List<double> rowStarts;
  final Color borderColor;
  final double borderWidth;
  final List<List<int>> matrixData;
  final int numRows;
  final int numCols;

  const _TableGridPainter({
    required this.colStarts,
    required this.rowStarts,
    required this.borderColor,
    required this.borderWidth,
    required this.matrixData,
    required this.numRows,
    required this.numCols,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth == 0) return;
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        if (c >= colStarts.length - 1 || r >= rowStarts.length - 1) continue;
        final idx = (r < matrixData.length && c < matrixData[r].length)
            ? matrixData[r][c] : -1;
        if (idx < 0) continue;
        final sameAsLeft = c > 0 && matrixData[r][c - 1] == idx;
        final sameAsAbove = r > 0 && matrixData[r - 1][c] == idx;
        if (sameAsLeft || sameAsAbove) continue;
        int endC = c + 1;
        while (endC < numCols && endC < matrixData[r].length && matrixData[r][endC] == idx) { endC++; }
        int endR = r + 1;
        while (endR < numRows && endR < matrixData.length && matrixData[endR][c] == idx) { endR++; }
        final right = endC < colStarts.length ? colStarts[endC] : colStarts.last;
        final bottom = endR < rowStarts.length ? rowStarts[endR] : rowStarts.last;
        canvas.drawRect(Rect.fromLTRB(colStarts[c], rowStarts[r], right, bottom), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TableGridPainter old) =>
      old.borderColor != borderColor || old.borderWidth != borderWidth;
}

class _DiagonalBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool topLeftToBottomRight;
  final bool bottomLeftToTopRight;

  const _DiagonalBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.topLeftToBottomRight,
    required this.bottomLeftToTopRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    if (topLeftToBottomRight) {
      canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    }
    if (bottomLeftToTopRight) {
      canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_DiagonalBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.topLeftToBottomRight != topLeftToBottomRight ||
      old.bottomLeftToTopRight != bottomLeftToTopRight;
}

// ── Dashed/Dotted/Double border overlay painter ──────────────────────────────
class _DashSide {
  final Color color;
  final double width;
  final bool dotted;
  final bool doubled;
  final String side;
  const _DashSide._(this.side, {required this.color, required this.width, this.dotted = false, this.doubled = false});
  const _DashSide.top({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('top', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.right({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('right', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.bottom({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('bottom', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.left({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('left', color: color, width: width, dotted: dotted, doubled: doubled);
}

class _DashedBorderPainter extends CustomPainter {
  final List<_DashSide> sides;
  const _DashedBorderPainter({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sides) {
      if (s.doubled) {
        _drawDouble(canvas, s, size);
        continue;
      }
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = s.width
        ..style = PaintingStyle.stroke;
      final dashLen = s.dotted ? s.width : s.width * 3;
      final gapLen = s.dotted ? s.width * 2 : s.width * 3;
      switch (s.side) {
        case 'top':    _drawDash(canvas, paint, Offset.zero, Offset(size.width, 0), dashLen, gapLen); break;
        case 'bottom': _drawDash(canvas, paint, Offset(0, size.height), Offset(size.width, size.height), dashLen, gapLen); break;
        case 'left':   _drawDash(canvas, paint, Offset.zero, Offset(0, size.height), dashLen, gapLen); break;
        case 'right':  _drawDash(canvas, paint, Offset(size.width, 0), Offset(size.width, size.height), dashLen, gapLen); break;
      }
    }
  }

  void _drawDash(Canvas canvas, Paint paint, Offset start, Offset end, double dashLen, double gapLen) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final totalLen = math.sqrt(dx * dx + dy * dy);
    if (totalLen == 0) return;
    final ux = dx / totalLen;
    final uy = dy / totalLen;
    double pos = 0;
    bool draw = true;
    while (pos < totalLen) {
      final double seg = draw ? dashLen : gapLen;
      final double segEnd = (pos + seg).clamp(0.0, totalLen);
      if (draw) {
        canvas.drawLine(
          Offset(start.dx + ux * pos, start.dy + uy * pos),
          Offset(start.dx + ux * segEnd, start.dy + uy * segEnd),
          paint,
        );
      }
      pos = segEnd;
      draw = !draw;
    }
  }

  // CSS "double": two parallel solid lines of thickness W/3 with a W/3 gap
  void _drawDouble(Canvas canvas, _DashSide s, Size size) {
    final lineW = s.width / 3.0;
    final paint = Paint()
      ..color = s.color
      ..strokeWidth = lineW
      ..style = PaintingStyle.stroke;
    final outer = lineW / 2.0;
    final inner = s.width - lineW / 2.0;
    switch (s.side) {
      case 'top':
        canvas.drawLine(Offset(0, outer), Offset(size.width, outer), paint);
        canvas.drawLine(Offset(0, inner), Offset(size.width, inner), paint);
        break;
      case 'bottom':
        canvas.drawLine(Offset(0, size.height - outer), Offset(size.width, size.height - outer), paint);
        canvas.drawLine(Offset(0, size.height - inner), Offset(size.width, size.height - inner), paint);
        break;
      case 'left':
        canvas.drawLine(Offset(outer, 0), Offset(outer, size.height), paint);
        canvas.drawLine(Offset(inner, 0), Offset(inner, size.height), paint);
        break;
      case 'right':
        canvas.drawLine(Offset(size.width - outer, 0), Offset(size.width - outer, size.height), paint);
        canvas.drawLine(Offset(size.width - inner, 0), Offset(size.width - inner, size.height), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => true;
}

class FormRendererFromJson extends StatelessWidget {
  final String jsonString;
  final void Function(String fieldName, dynamic value)? onChanged;

  const FormRendererFromJson({
    super.key,
    required this.jsonString,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final schema = jsonDecode(jsonString) as Map<String, dynamic>;
      return FormRenderer(schema: schema, onChanged: onChanged);
    } catch (e) {
      return Center(child: Text('Error parsing JSON: $e'));
    }
  }
}
