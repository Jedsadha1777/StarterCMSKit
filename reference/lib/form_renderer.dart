import 'dart:convert';
import 'package:flutter/material.dart';
import 'preview_shell.dart';
import 'form_widgets/form_widgets.dart';

class FormRenderer extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(Map<String, dynamic> values)? onSubmit;
  final void Function(String fieldName, dynamic value)? onChanged;

  const FormRenderer({
    super.key,
    required this.schema,
    this.onSubmit,
    this.onChanged,
  });

  @override
  State<FormRenderer> createState() => _FormRendererState();
}

class _FormRendererState extends State<FormRenderer> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _dropdownValues = {};
  final Map<String, bool> _checkboxValues = {};

  String? _currentWhiteSpace;
  String? _currentTextAlign;
  String? _currentTextTransform;

  List<dynamic> get _pages => widget.schema['pages'] as List? ?? [];
  List<dynamic> get _fields => widget.schema['fields'] as List? ?? [];

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
      _initFields();
    }
  }

  void _initFields() {
    for (final f in _fields) {
      final name = f['name'] as String? ?? '';
      final type = f['fieldType'] as String? ?? '';
      if (type == 'select') {
        final options = f['options'] as List? ?? [];
        _dropdownValues[name] = options.isNotEmpty
            ? (options.first['value'] as String? ?? '')
            : null;
      } else if (type == 'checkbox') {
        _checkboxValues[name] = false;
      } else {
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

    final pageWidgets = _pages.map((p) => _buildNode(p)).toList();

    return Form(
      key: _formKey,
      child: PreviewShell(pages: pageWidgets),
    );
  }

  Widget _buildNode(dynamic node) {
    if (node == null) return const SizedBox.shrink();
    if (node is! Map<String, dynamic>) return const SizedBox.shrink();

    final type = node['type'] as String? ?? '';
    switch (type) {
      case 'column':
        return _buildColumn(node);
      case 'container':
        return _buildContainer(node);
      case 'text':
        return _buildText(node);
      case 'richtext':
        return _buildRichText(node);
      case 'table':
        return _buildTable(node);
      case 'input':
        return FormInput.fromJson(node);
      case 'select':
        return FormSelect.fromJson(node);
      case 'textarea':
        return FormTextarea.fromJson(node);
      case 'date-picker':
        return FormDate.fromJson(node);
      case 'signature':
        return FormSignature.fromJson(node);
      case 'image-upload':
        return FormImageUpload.fromJson(node);
      case 'checkbox':
        return FormCheckbox.fromJson(node);
      case 'radio':
        return FormRadio.fromJson(node);
      case 'file':
        return FormFile.fromJson(node);
      case 'search':
        return FormSearch.fromJson(node);
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

    double? width;
    final widthVal = style['width'];
    if (widthVal == 'infinity') {
      width = double.infinity;
    } else {
      width = _dim(widthVal);
    }

    final border = _parseContainerBorder(style['border'] as Map<String, dynamic>?);
    final borderLeft = _parseSingleBorder(style['borderLeft'] as Map<String, dynamic>?);

    Border? finalBorder = border;
    if (borderLeft != null && finalBorder == null) {
      finalBorder = Border(left: borderLeft);
    }

    Widget result = Container(
      width: width,
      height: _dim(style['height']),
      padding: _edgeInsets(style['padding']),
      margin: _edgeInsets(style['margin']),
      decoration: BoxDecoration(
        color: _color(style['backgroundColor']),
        border: finalBorder,
        borderRadius: style['borderRadius'] != null
            ? BorderRadius.circular((style['borderRadius'] as num).toDouble())
            : null,
      ),
      child: child,
    );

    final rotate = style['rotateAngle'];
    if (rotate != null && rotate != 0) {
      final radians = (rotate as num).toDouble() * 3.14159265 / 180;
      result = Transform.rotate(angle: radians, child: result);
    }

    return result;
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
      final cellBorder = _parseCellBorder(cellStyle['cellBorder'] as Map<String, dynamic>?);
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

      _currentWhiteSpace = cellStyle['whiteSpace'] as String?;
      _currentTextAlign = cellStyle['textAlign'] as String?;
      _currentTextTransform = cellStyle['textTransform'] as String?;

      Widget content = pMap['child'] != null
          ? _buildNode(pMap['child'])
          : const SizedBox.shrink();

      _currentWhiteSpace = null;
      _currentTextAlign = null;
      _currentTextTransform = null;

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

  /// Parse structured cell border JSON into Flutter Border
  Border? _parseCellBorder(Map<String, dynamic>? data) {
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
    if (src.startsWith('http')) {
      return Image.network(src, width: w, height: h, fit: BoxFit.contain);
    }
    if (src.startsWith('assets/')) {
      return Image.asset(src, width: w, height: h, fit: BoxFit.contain);
    }
    return Placeholder(fallbackWidth: w ?? 100, fallbackHeight: h ?? 100);
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
    if (v is String) {
      final m = RegExp(r'^([\d.]+)').firstMatch(v);
      if (m != null) return double.tryParse(m.group(1)!);
    }
    return null;
  }

  Color? _color(dynamic v) {
    if (v == null) return null;
    if (v is String) {
      final s = v.trim();
      if (s.startsWith('#')) {
        var hex = s.substring(1);
        if (hex.length == 3) hex = hex.split('').map((c) => '$c$c').join();
        if (hex.length == 6) return Color(int.parse('FF$hex', radix: 16));
      }
      final m = RegExp(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)').firstMatch(s);
      if (m != null) {
        return Color.fromARGB(255, int.parse(m.group(1)!), int.parse(m.group(2)!), int.parse(m.group(3)!));
      }
      const named = <String, Color>{
        'white': Colors.white, 'black': Colors.black, 'red': Colors.red,
        'blue': Colors.blue, 'green': Colors.green, 'grey': Colors.grey,
        'gray': Colors.grey, 'yellow': Colors.yellow, 'orange': Colors.orange,
      };
      final c = named[s.toLowerCase()];
      if (c != null) return c;
    }
    return null;
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
    final s = v.toString();
    if (s == 'bold' || s == '700') return FontWeight.bold;
    if (s == '600') return FontWeight.w600;
    if (s == '500') return FontWeight.w500;
    if (s == '300') return FontWeight.w300;
    if (s == '100') return FontWeight.w100;
    return null;
  }

  TextDecoration? _textDecoration(dynamic v) {
    if (v == null) return null;
    if (v == 'underline') return TextDecoration.underline;
    if (v == 'lineThrough') return TextDecoration.lineThrough;
    return null;
  }

  TextAlign? _textAlign(dynamic v) {
    if (v == null) return null;
    switch (v) {
      case 'center': return TextAlign.center;
      case 'right': case 'end': return TextAlign.right;
      case 'justify': return TextAlign.justify;
      case 'left': case 'start': return TextAlign.left;
      default: return TextAlign.left;
    }
  }

  Alignment _alignment(String? hAlign, String? vAlign) {
    double x = -1, y = 0;
    if (hAlign == 'center') x = 0;
    if (hAlign == 'right' || hAlign == 'end') x = 1;
    if (vAlign == 'top') y = -1;
    if (vAlign == 'bottom') y = 1;
    return Alignment(x, y);
  }

  EdgeInsets? _edgeInsets(dynamic v) {
    if (v == null) return null;
    if (v is Map<String, dynamic>) {
      return EdgeInsets.fromLTRB(
        (v['left'] as num?)?.toDouble() ?? 0,
        (v['top'] as num?)?.toDouble() ?? 0,
        (v['right'] as num?)?.toDouble() ?? 0,
        (v['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
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

class FormRendererFromJson extends StatelessWidget {
  final String jsonString;
  final void Function(Map<String, dynamic> values)? onSubmit;
  final void Function(String fieldName, dynamic value)? onChanged;

  const FormRendererFromJson({
    super.key,
    required this.jsonString,
    this.onSubmit,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final schema = jsonDecode(jsonString) as Map<String, dynamic>;
      return FormRenderer(schema: schema, onSubmit: onSubmit, onChanged: onChanged);
    } catch (e) {
      return Center(child: Text('Error parsing JSON: $e'));
    }
  }
}
