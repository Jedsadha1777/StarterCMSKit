import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Paper orientation.
enum PageOrientation { portrait, landscape }

// ═══════════════════════════════════════════════════════════════════════════════
// PreviewShell — PDF-reader-style preview
// ═══════════════════════════════════════════════════════════════════════════════

class PreviewShell extends StatefulWidget {
  final List<Widget> pages;

  /// portrait (794×1123) or landscape (1123×794) at 96 DPI.
  final PageOrientation orientation;

  /// Gap between pages.
  /// - null          → default 24 px for every gap
  /// - [20]          → 20 px for every gap
  /// - [10, 30, 20]  → per-page gaps; last value repeats if pages > list
  final List<double>? pageGaps;

  /// Inner padding on the white paper (printable-area margins).
  final EdgeInsets pagePadding;

  /// When true, if content exceeds page height it scales down to fit.
  final bool fitHeight;

  /// Optional back callback — shown as a back button in the AppBar.
  final VoidCallback? onBack;

  const PreviewShell({
    super.key,
    required this.pages,
    this.orientation = PageOrientation.portrait,
    this.pageGaps,
    this.pagePadding = const EdgeInsets.all(48),
    this.fitHeight = true,
    this.onBack,
  });

  @override
  State<PreviewShell> createState() => _PreviewShellState();
}

class _PreviewShellState extends State<PreviewShell> {
  static const _a4Short = 794.0;
  static const _a4Long = 1123.0;
  static const _defaultGap = 24.0;
  static const _shellPad = 24.0;
  static const _red = Color(0xFFAD193C);
  static const _scrollSpeed = 3.0;

  final _transformCtrl = TransformationController();
  final _scaleNotifier = ValueNotifier<double>(1.0);
  final _bodyKey = GlobalKey();
  bool _didAutoFit = false;
  bool _ready = false;

  double get _paperW => widget.orientation == PageOrientation.portrait
      ? _a4Short
      : _a4Long;
  double get _paperH => widget.orientation == PageOrientation.portrait
      ? _a4Long
      : _a4Short;

  double _autoFitScale(double viewportWidth) =>
      (viewportWidth / (_paperW + _shellPad * 2)).clamp(0.1, 1.0);

  double _gapAfter(int index) {
    if (index >= widget.pages.length - 1) return 0;
    final gaps = widget.pageGaps;
    if (gaps == null || gaps.isEmpty) return _defaultGap;
    if (gaps.length == 1) return gaps[0];
    return index < gaps.length ? gaps[index] : gaps.last;
  }

  Size _bodySize() {
    final rb = _bodyKey.currentContext?.findRenderObject() as RenderBox?;
    return rb?.size ?? const Size(800, 600);
  }

  Size _contentSize(Size vp) {
    final cw = (_paperW + _shellPad * 2).clamp(vp.width, double.infinity);
    final n = widget.pages.length;
    double totalGaps = 0;
    for (int i = 0; i < n; i++) {
      totalGaps += _gapAfter(i) + _shellPad;
    }
    final ch = _shellPad + n * _paperH + totalGaps;
    return Size(cw, ch);
  }

  double _clampTx(double t, double scaledContent, double viewport) {
    if (scaledContent <= viewport) {
      return (viewport - scaledContent) / 2;
    }
    return t.clamp(viewport - scaledContent, 0.0);
  }

  void _zoomTo(double newScale) {
    final vp = _bodySize();
    final minS = _autoFitScale(vp.width);
    final s = newScale.clamp(minS, 5.0);
    final oldScale = _transformCtrl.value.getMaxScaleOnAxis();
    final cx = vp.width / 2;
    final cy = vp.height / 2;
    final oldTx = _transformCtrl.value.getTranslation();
    final contentX = (cx - oldTx.x) / oldScale;
    final contentY = (cy - oldTx.y) / oldScale;
    var nx = cx - contentX * s;
    var ny = cy - contentY * s;
    // Clamp translation so content stays within viewport bounds
    final cSize = _contentSize(vp);
    nx = _clampTx(nx, cSize.width * s, vp.width);
    ny = _clampTx(ny, cSize.height * s, vp.height);
    // ignore: deprecated_member_use
    _transformCtrl.value = Matrix4.identity()..translate(nx, ny)..scale(s, s);
    _scaleNotifier.value = s;
  }

  void _fitWidth(double viewportWidth, {bool keepVertical = false, Size? viewport}) {
    final s = _autoFitScale(viewportWidth);
    final contentW = _paperW + _shellPad * 2;
    final actualW = contentW.clamp(viewportWidth, double.infinity);
    final tx = (viewportWidth - actualW * s) / 2;
    final vp = viewport ?? _bodySize();
    final cSize = _contentSize(vp);
    double ty;
    if (keepVertical) {
      final oldTy = _transformCtrl.value.getTranslation().y;
      final oldS = _transformCtrl.value.getMaxScaleOnAxis();
      final cy = vp.height / 2;
      final contentY = oldS != 0 ? (cy - oldTy) / oldS : 0.0;
      ty = cy - contentY * s;
      ty = _clampTx(ty, cSize.height * s, vp.height);
    } else {
      ty = 0.0;
    }
    // ignore: deprecated_member_use
    _transformCtrl.value = Matrix4.identity()..translate(tx, ty)..scale(s, s);
    _scaleNotifier.value = s;
  }

  void _onPointerScroll(PointerScrollEvent e) {
    final dy = e.scrollDelta.dy * _scrollSpeed;
    final dx = e.scrollDelta.dx * _scrollSpeed;
    if (dy == 0 && dx == 0) return;
    final old = _transformCtrl.value.clone();
    final t = old.getTranslation();
    final s = old.getMaxScaleOnAxis();
    final vp = _bodySize();
    final cSize = _contentSize(vp);
    // Only clamp the axis that has scroll delta — don't touch the other
    final newX = dx != 0
        ? _clampTx(t.x - dx, cSize.width * s, vp.width)
        : t.x;
    final newY = dy != 0
        ? _clampTx(t.y - dy, cSize.height * s, vp.height)
        : t.y;
    // ignore: deprecated_member_use
    _transformCtrl.value = Matrix4.identity()..translate(newX, newY)..scale(s, s);
  }

  @override
  void didUpdateWidget(covariant PreviewShell old) {
    super.didUpdateWidget(old);
    if (old.orientation != widget.orientation) {
      _didAutoFit = false;
      _ready = false;
    }
  }

  @override
  void dispose() {
    _transformCtrl.dispose();
    _scaleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFE0E0E0),
        appBar: AppBar(
          leading: widget.onBack != null ? IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: widget.onBack) : null,
          backgroundColor: _red,
          title: const Text('Preview',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          actions: [
            IconButton(
              tooltip: 'Zoom out',
              icon: const Icon(Icons.zoom_out, color: Colors.white),
              onPressed: () => _zoomTo(_scaleNotifier.value - 0.2),
            ),
            SizedBox(
              width: 48,
              child: Center(
                child: ValueListenableBuilder<double>(
                  valueListenable: _scaleNotifier,
                  builder: (_, scale, __) => Text(
                    '${(scale * 100).toInt()}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Zoom in',
              icon: const Icon(Icons.zoom_in, color: Colors.white),
              onPressed: () => _zoomTo(_scaleNotifier.value + 0.2),
            ),
            IconButton(
              tooltip: 'Fit width',
              icon: const Icon(Icons.fit_screen, color: Colors.white),
              onPressed: () => _fitWidth(_bodySize().width, keepVertical: true),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: LayoutBuilder(
          key: _bodyKey,
          builder: (context, constraints) {
            final vp = Size(constraints.maxWidth, constraints.maxHeight);
            final minS = _autoFitScale(constraints.maxWidth);
            if (!_didAutoFit && constraints.maxWidth > 0) {
              _didAutoFit = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _fitWidth(constraints.maxWidth, viewport: vp);
                  setState(() => _ready = true);
                }
              });
            } else if (_scaleNotifier.value < minS - 0.001) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _fitWidth(constraints.maxWidth, keepVertical: true, viewport: vp);
                }
              });
            }

            final contentWidth = _paperW + _shellPad * 2;

            return Opacity(
              opacity: _ready ? 1.0 : 0.0,
              child: Listener(
              onPointerSignal: (e) {
                if (e is PointerScrollEvent) _onPointerScroll(e);
              },
              child: InteractiveViewer(
                transformationController: _transformCtrl,
                constrained: false,
                minScale: _autoFitScale(constraints.maxWidth),
                maxScale: 5.0,
                boundaryMargin: EdgeInsets.zero,
                onInteractionUpdate: (_) {
                  final s = _transformCtrl.value.getMaxScaleOnAxis();
                  if ((s - _scaleNotifier.value).abs() > 0.001) {
                    _scaleNotifier.value = s;
                  }
                },
                child: SizedBox(
                  width: contentWidth.clamp(
                      constraints.maxWidth, double.infinity),
                  child: Column(
                    children: [
                      const SizedBox(height: _shellPad),
                      for (int i = 0; i < widget.pages.length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: _gapAfter(i) + _shellPad,
                          ),
                          child: Center(
                            child: Container(
                              width: _paperW,
                              height: _paperH,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x40000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 4)),
                                ],
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: RepaintBoundary(
                                child: _ScaledContent(
                                  key: ValueKey(i),
                                  content: widget.pages[i],
                                  paperWidth: _paperW,
                                  paperHeight: _paperH,
                                  pagePadding: widget.pagePadding,
                                  fitHeight: widget.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            );
          },
        ),
      ),
    );
  }
}

// ── _ScaledContent ───────────────────────────────────────────────────────────
class _ScaledContent extends StatefulWidget {
  final Widget content;
  final double paperWidth;
  final double paperHeight;
  final EdgeInsets pagePadding;
  final bool fitHeight;

  const _ScaledContent({
    super.key,
    required this.content,
    required this.paperWidth,
    required this.paperHeight,
    required this.pagePadding,
    this.fitHeight = true,
  });

  @override
  State<_ScaledContent> createState() => _ScaledContentState();
}

class _ScaledContentState extends State<_ScaledContent> {
  final _measureKey = GlobalKey();
  Size? _natural;

  @override
  void initState() {
    super.initState();
    _scheduleMeasure();
  }

  @override
  void didUpdateWidget(covariant _ScaledContent old) {
    super.didUpdateWidget(old);
    if (old.content != widget.content) {
      _natural = null;
      _scheduleMeasure();
    }
  }

  void _scheduleMeasure() {
    WidgetsBinding.instance.addPostFrameCallback(_measure);
  }

  void _measure(_) {
    if (!mounted) return;
    final rb =
        _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb != null && rb.hasSize && rb.size != _natural) {
      setState(() => _natural = rb.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = widget.pagePadding;
    final nat = _natural;
    final contentW = widget.paperWidth - pad.left - pad.right;
    final contentH = widget.paperHeight - pad.top - pad.bottom;
    double scale;
    if (nat == null || nat.width <= 0) {
      scale = 1.0;
    } else {
      final scaleW = contentW / nat.width;
      scale = (widget.fitHeight && nat.height > 0)
          ? scaleW.clamp(0, contentH / nat.height)
          : scaleW;
    }
    final measured = nat != null;

    final scaledW = (nat != null) ? nat.width * scale : contentW;
    final scaledH = (nat != null) ? nat.height * scale : contentH;

    return Visibility(
      visible: measured,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Padding(
        padding: pad,
        child: ClipRect(
          child: SizedBox(
            width: contentW,
            height: contentH,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: scaledW,
                height: scaledH,
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: nat?.width,
                    height: nat?.height,
                    child: Container(
                      key: _measureKey,
                      child: widget.content,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
