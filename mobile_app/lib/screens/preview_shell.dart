import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Paper orientation.
enum PageOrientation { portrait, landscape }

// ═══════════════════════════════════════════════════════════════════════════════
// PreviewShell — PDF-reader-style preview with Edit ↔ Review modes
//
// Edit mode    : paper covers viewport, form is interactive, footer shows
//                [Reset] ... [Save Draft] [Preview].
// Review mode  : paper sits centered with margins, form is read-only, footer
//                shows [Confirm & Send]; AppBar leading flips to "Edit".
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

  /// Inner padding on the white paper (printable-area margins, applied in
  /// Review mode only — Edit mode strips it so paper covers the viewport).
  final EdgeInsets pagePadding;

  /// When true, if content exceeds page height it scales down to fit.
  final bool fitHeight;

  /// AppBar back button. Shown only in Edit mode.
  final VoidCallback? onBack;

  /// Save-draft action shown in Edit mode footer. Pass null to disable.
  final VoidCallback? onSaveDraft;

  /// Confirm & send action shown in Review mode footer. Pass null to disable.
  final VoidCallback? onConfirmSend;

  /// Reset action shown in Edit mode footer. If null, Reset button is hidden.
  final VoidCallback? onReset;

  /// AppBar title.
  final String title;

  const PreviewShell({
    super.key,
    required this.pages,
    this.orientation = PageOrientation.portrait,
    this.pageGaps,
    this.pagePadding = const EdgeInsets.all(48),
    this.fitHeight = true,
    this.onBack,
    this.onSaveDraft,
    this.onConfirmSend,
    this.onReset,
    this.title = 'Report',
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

  final _editCtrl = TransformationController();
  final _reviewCtrl = TransformationController();
  final _scaleNotifier = ValueNotifier<double>(1.0);
  final _bodyKey = GlobalKey();
  bool _didAutoFit = false;
  bool _ready = false;
  int _resetCounter = 0;
  bool _reviewMode = false;

  TransformationController get _ctrl => _reviewMode ? _reviewCtrl : _editCtrl;

  EdgeInsets get _effectivePagePadding =>
      _reviewMode ? widget.pagePadding : EdgeInsets.zero;

  double get _shellPadForMode => _reviewMode ? _shellPad : 0.0;

  double get _paperW => widget.orientation == PageOrientation.portrait
      ? _a4Short
      : _a4Long;
  double get _paperH => widget.orientation == PageOrientation.portrait
      ? _a4Long
      : _a4Short;

  // Edit: cover the viewport — pick whichever scale fills the smaller-axis,
  // so neither width nor height shows gray. The opposite axis spills past the
  // viewport, where user pans to access.
  double _editFitScale(Size viewport) {
    final sw = viewport.width / _paperW;
    final sh = viewport.height / _paperH;
    return (sw > sh ? sw : sh).clamp(0.1, 5.0);
  }

  double _reviewFitScale(Size viewport) {
    final cs = _contentSize(viewport, reviewOverride: true);
    final sw = viewport.width / cs.width;
    final sh = viewport.height / cs.height;
    return (sw < sh ? sw : sh).clamp(0.1, 5.0);
  }

  double _modeFitScale(Size viewport) =>
      _reviewMode ? _reviewFitScale(viewport) : _editFitScale(viewport);

  double _minScaleForMode(Size viewport) =>
      _reviewMode ? _reviewFitScale(viewport) : _editFitScale(viewport);
  double _maxScaleForMode(Size viewport) => 5.0;

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

  // reviewOverride lets _initMode/_toggleMode compute the TARGET mode's cSize
  // before _reviewMode flips. Without it, switching mode reads stale _reviewMode.
  Size _contentSize(Size vp, {bool? reviewOverride}) {
    final review = reviewOverride ?? _reviewMode;
    final pad = review ? _shellPad : 0.0;
    final n = widget.pages.length;
    double totalGaps = 0;
    for (int i = 0; i < n; i++) {
      totalGaps += _gapAfter(i) + pad;
    }
    final naturalCw = _paperW + pad * 2;
    final naturalCh = pad + n * _paperH + totalGaps;

    if (!review) return Size(naturalCw, naturalCh);

    if (vp.width <= 0 || vp.height <= 0) return Size(naturalCw, naturalCh);
    final vpAspect = vp.width / vp.height;
    final natAspect = naturalCw / naturalCh;
    if (natAspect < vpAspect) {
      return Size(naturalCh * vpAspect, naturalCh);
    } else {
      return Size(naturalCw, naturalCw / vpAspect);
    }
  }

  double _clampTx(double t, double scaledContent, double viewport) {
    if (scaledContent <= viewport) {
      return (viewport - scaledContent) / 2;
    }
    return t.clamp(viewport - scaledContent, 0.0);
  }

  void _zoomTo(double newScale) {
    final vp = _bodySize();
    final s = newScale.clamp(_minScaleForMode(vp), _maxScaleForMode(vp));
    final oldScale = _ctrl.value.getMaxScaleOnAxis();
    final cx = vp.width / 2;
    final cy = vp.height / 2;
    final oldTx = _ctrl.value.getTranslation();
    final contentX = (cx - oldTx.x) / oldScale;
    final contentY = (cy - oldTx.y) / oldScale;
    var nx = cx - contentX * s;
    var ny = cy - contentY * s;
    final cSize = _contentSize(vp);
    nx = _clampTx(nx, cSize.width * s, vp.width);
    ny = _clampTx(ny, cSize.height * s, vp.height);
    // ignore: deprecated_member_use
    _ctrl.value = Matrix4.identity()..translate(nx, ny)..scale(s, s);
    _scaleNotifier.value = s;
  }

  void _fitWidth(double viewportWidth, {bool keepVertical = false, Size? viewport}) {
    final vp = viewport ?? _bodySize();
    final s = _modeFitScale(vp);
    final cSize = _contentSize(vp);
    final tx = (viewportWidth - cSize.width * s) / 2;
    double ty;
    if (keepVertical) {
      final oldTy = _ctrl.value.getTranslation().y;
      final oldS = _ctrl.value.getMaxScaleOnAxis();
      final cy = vp.height / 2;
      final contentY = oldS != 0 ? (cy - oldTy) / oldS : 0.0;
      ty = cy - contentY * s;
      ty = _clampTx(ty, cSize.height * s, vp.height);
    } else {
      ty = _reviewMode
          ? _clampTx((vp.height - cSize.height * s) / 2, cSize.height * s, vp.height)
          : 0.0;
    }
    // ignore: deprecated_member_use
    _ctrl.value = Matrix4.identity()..translate(tx, ty)..scale(s, s);
    _scaleNotifier.value = s;
  }

  void _onPointerScroll(PointerScrollEvent e) {
    final dy = e.scrollDelta.dy * _scrollSpeed;
    final dx = e.scrollDelta.dx * _scrollSpeed;
    if (dy == 0 && dx == 0) return;
    final old = _ctrl.value.clone();
    final t = old.getTranslation();
    final s = old.getMaxScaleOnAxis();
    final vp = _bodySize();
    final cSize = _contentSize(vp);
    final newX = dx != 0
        ? _clampTx(t.x - dx, cSize.width * s, vp.width)
        : t.x;
    final newY = dy != 0
        ? _clampTx(t.y - dy, cSize.height * s, vp.height)
        : t.y;
    // ignore: deprecated_member_use
    _ctrl.value = Matrix4.identity()..translate(newX, newY)..scale(s, s);
  }

  void _initMode(bool review, Size vp) {
    if (vp.width <= 0) return;
    final ctrl = review ? _reviewCtrl : _editCtrl;
    final s = review ? _reviewFitScale(vp) : _editFitScale(vp);
    final cSize = _contentSize(vp, reviewOverride: review);
    final tx = (vp.width - cSize.width * s) / 2;
    double ty;
    if (review) {
      ty = (vp.height - cSize.height * s) / 2;
      if (cSize.height * s > vp.height) {
        ty = ty.clamp(vp.height - cSize.height * s, 0.0);
      }
    } else {
      ty = 0.0;
    }
    // ignore: deprecated_member_use
    ctrl.value = Matrix4.identity()..translate(tx, ty)..scale(s, s);
    if ((review && _reviewMode) || (!review && !_reviewMode)) {
      _scaleNotifier.value = s;
    }
  }

  void _toggleMode(bool review) {
    if (_reviewMode == review) return;
    final vp = _bodySize();
    _initMode(review, vp);
    setState(() {
      _reviewMode = review;
      _scaleNotifier.value = review ? _reviewFitScale(vp) : _editFitScale(vp);
    });
  }

  Widget _modeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(_reviewMode ? 0.08 : -0.08, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: _modeTransition,
          child: Row(
            key: ValueKey('footer-${_reviewMode ? "review" : "edit"}'),
            children: _reviewMode
                ? [
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: widget.onConfirmSend,
                      icon: const Icon(Icons.send, size: 18, color: Colors.white),
                      label: const Text('Confirm & Send', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _red,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ]
                : [
                    if (widget.onReset != null)
                      TextButton.icon(
                        onPressed: _onResetPressed,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reset'),
                        style: TextButton.styleFrom(
                          foregroundColor: _red,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    const Spacer(),
                    if (widget.onSaveDraft != null) ...[
                      OutlinedButton.icon(
                        onPressed: widget.onSaveDraft,
                        icon: const Icon(Icons.save_outlined, size: 18),
                        label: const Text('Save Draft'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _red,
                          side: const BorderSide(color: _red),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    ElevatedButton.icon(
                      onPressed: () => _toggleMode(true),
                      icon: const Icon(Icons.visibility_outlined, size: 18, color: Colors.white),
                      label: const Text('Preview', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _red,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Future<void> _onResetPressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text('Warning'),
          ],
        ),
        content: const Text('Are you sure to reset all of value to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: _red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      widget.onReset?.call();
      setState(() => _resetCounter++);
    }
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
    _editCtrl.dispose();
    _reviewCtrl.dispose();
    _scaleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFE0E0E0),
        bottomNavigationBar: _buildFooter(),
        appBar: AppBar(
          leadingWidth: 96,
          centerTitle: true,
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: _modeTransition,
            child: _reviewMode
                ? TextButton.icon(
                    key: const ValueKey('leading-edit'),
                    onPressed: () => _toggleMode(false),
                    icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                    label: const Text('Edit', style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  )
                : (widget.onBack != null
                    ? TextButton.icon(
                        key: const ValueKey('leading-back'),
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                        label: const Text('Back', style: TextStyle(color: Colors.white)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('leading-empty'))),
          ),
          backgroundColor: _red,
          title: Text(widget.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          actions: [
            IconButton(
              tooltip: 'Zoom out',
              icon: const Icon(Icons.zoom_out, color: Colors.white),
              onPressed: () => _zoomTo(_scaleNotifier.value - 0.2),
            ),
            GestureDetector(
              onTap: () => _fitWidth(_bodySize().width, keepVertical: true),
              child: SizedBox(
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
            ),
            IconButton(
              tooltip: 'Zoom in',
              icon: const Icon(Icons.zoom_in, color: Colors.white),
              onPressed: () => _zoomTo(_scaleNotifier.value + 0.2),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _reviewMode ? const Color(0xFFD8DEE3) : const Color(0xFFE0E0E0),
          child: LayoutBuilder(
            key: _bodyKey,
            builder: (context, constraints) {
              final vp = Size(constraints.maxWidth, constraints.maxHeight);
              final minS = _minScaleForMode(vp);
              if (!_didAutoFit && constraints.maxWidth > 0) {
                _didAutoFit = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _initMode(_reviewMode, vp);
                    setState(() => _ready = true);
                  }
                });
              } else if (_scaleNotifier.value < minS - 0.001) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _initMode(_reviewMode, vp);
                });
              }

              final naturalCw = _paperW + _shellPadForMode * 2;
              final cSize = _contentSize(vp);

              return Opacity(
                opacity: _ready ? 1.0 : 0.0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  layoutBuilder: (current, previous) => Stack(
                    children: [
                      ...previous,
                      if (current != null) current,
                    ],
                  ),
                  transitionBuilder: (child, animation) {
                    final isIncoming = (child.key as ValueKey?)?.value == _reviewMode;
                    final Offset begin;
                    if (isIncoming) {
                      begin = _reviewMode ? const Offset(1, 0) : const Offset(-1, 0);
                    } else {
                      begin = _reviewMode ? const Offset(-1, 0) : const Offset(1, 0);
                    }
                    return SlideTransition(
                      position: Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
                      child: child,
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(_reviewMode),
                    child: Listener(
                      onPointerSignal: (e) {
                        if (e is PointerScrollEvent) _onPointerScroll(e);
                      },
                      child: InteractiveViewer(
                        transformationController: _ctrl,
                        constrained: false,
                        minScale: _minScaleForMode(vp),
                        maxScale: _maxScaleForMode(vp),
                        boundaryMargin: EdgeInsets.zero,
                        onInteractionUpdate: (_) {
                          final s = _ctrl.value.getMaxScaleOnAxis();
                          if ((s - _scaleNotifier.value).abs() > 0.001) {
                            _scaleNotifier.value = s;
                          }
                        },
                        child: SizedBox(
                          width: cSize.width,
                          height: cSize.height,
                          child: Center(
                            child: SizedBox(
                              width: naturalCw,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: _shellPadForMode),
                                  for (int i = 0; i < widget.pages.length; i++)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: _gapAfter(i) + _shellPadForMode,
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
                                            child: IgnorePointer(
                                              ignoring: _reviewMode,
                                              child: _ScaledContent(
                                                key: ValueKey('$_resetCounter-$i'),
                                                content: widget.pages[i],
                                                paperWidth: _paperW,
                                                paperHeight: _paperH,
                                                pagePadding: _effectivePagePadding,
                                                fitHeight: widget.fitHeight,
                                              ),
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
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
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
