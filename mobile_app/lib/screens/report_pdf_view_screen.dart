import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../services/api/report_api.dart';

class ReportPdfViewScreen extends StatefulWidget {
  final String reportId;
  final String reportNo;
  const ReportPdfViewScreen({super.key, required this.reportId, required this.reportNo});

  @override
  State<ReportPdfViewScreen> createState() => _ReportPdfViewScreenState();
}

class _ReportPdfViewScreenState extends State<ReportPdfViewScreen> {
  static const _red = Color(0xFFAD193C);
  static const _bgGrey = Color(0xFFD8DEE3);
  static const _scrollSpeed = 3.0;
  static const _maxScale = 5.0;
  static const _zoomStep = 0.2;
  // Match preview_shell review mode: _defaultGap (24) + _shellPad (24)
  // → between-pages gap = 48, top/bottom pad = 24.
  static const _shellPad = 24.0;
  static const _gapBetween = 48.0;
  static const _sideMargin = 20.0;     // breathing room around paper at fit (preview_shell._kReviewFitMargin)

  final ReportApi _reportApi = ReportApi();
  final TransformationController _ctrl = TransformationController();
  final ValueNotifier<double> _scaleNotifier = ValueNotifier<double>(1.0);
  final GlobalKey _bodyKey = GlobalKey();

  Uint8List? _pdfBytes;
  List<_PageImage>? _pages;
  String? _error;
  bool _didFit = false;
  bool _ready = false;
  Size? _lastVp;     // last laid-out viewport — re-centre matrix when iPad split-view/rotate changes it

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scaleNotifier.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final bytes = await _reportApi.getReportPdf(widget.reportId);
      // Rasterise at print-quality DPI so zoom-in stays crisp.
      final pages = <_PageImage>[];
      await for (final raster in Printing.raster(bytes, dpi: 200)) {
        pages.add(_PageImage(
          png: await raster.toPng(),
          width: raster.width.toDouble(),
          height: raster.height.toDouble(),
        ));
      }
      if (mounted) {
        setState(() {
          _pdfBytes = bytes;
          _pages = pages;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _print() async {
    final bytes = _pdfBytes;
    if (bytes == null) return;
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: widget.reportNo,
    );
  }

  Size _bodySize() {
    final rb = _bodyKey.currentContext?.findRenderObject() as RenderBox?;
    return rb?.size ?? const Size(800, 600);
  }

  // Natural paper width at scale=1 (max page width across all pages).
  double _naturalPaperW() {
    final pages = _pages;
    if (pages == null || pages.isEmpty) return 1.0;
    double w = 0;
    for (final p in pages) {
      if (p.width > w) w = p.width;
    }
    return w;
  }

  // Total height of all pages stacked with gaps at scale=1, plus top/bottom shellPad.
  double _naturalContentH() {
    final pages = _pages;
    if (pages == null || pages.isEmpty) return 1.0;
    double h = _shellPad; // top
    for (int i = 0; i < pages.length; i++) {
      h += pages[i].height;
      if (i < pages.length - 1) h += _gapBetween;
    }
    h += _shellPad; // bottom
    return h;
  }

  // Width-fit scale: paper width fills viewport minus side margin.
  double _fitScale(Size vp) {
    final paperW = _naturalPaperW();
    if (paperW <= 0 || vp.width <= 0) return 1.0;
    final s = (vp.width - _sideMargin * 2) / paperW;
    return s.clamp(0.05, _maxScale);
  }

  // Content-box size: width is padded so at fit scale the content fills the
  // viewport horizontally (kills side-pan when paper alone is narrower than
  // viewport / fitScale). Height is the natural stack — taller content scrolls.
  Size _contentSize(Size vp) {
    final naturalW = _naturalPaperW();
    final naturalH = _naturalContentH();
    if (vp.width <= 0) return Size(naturalW, naturalH);
    final fit = _fitScale(vp);
    final neededW = vp.width / fit;
    final w = naturalW > neededW ? naturalW : neededW;
    return Size(w, naturalH);
  }

  double _clampTx(double t, double scaledContent, double viewport) {
    if (scaledContent <= viewport) return (viewport - scaledContent) / 2;
    return t.clamp(viewport - scaledContent, 0.0);
  }

  void _zoomTo(double newScale) {
    final vp = _bodySize();
    // Lock min zoom to fit scale — going below makes content narrower than the
    // viewport and InteractiveViewer snaps it left (looks broken).
    final s = newScale.clamp(_fitScale(vp), _maxScale);
    final oldScale = _ctrl.value.getMaxScaleOnAxis();
    final cx = vp.width / 2;
    final cy = vp.height / 2;
    final oldT = _ctrl.value.getTranslation();
    final contentX = (cx - oldT.x) / oldScale;
    final contentY = (cy - oldT.y) / oldScale;
    var nx = cx - contentX * s;
    var ny = cy - contentY * s;
    final cs = _contentSize(vp);
    nx = _clampTx(nx, cs.width * s, vp.width);
    ny = _clampTx(ny, cs.height * s, vp.height);
    // ignore: deprecated_member_use
    _ctrl.value = Matrix4.identity()..translate(nx, ny)..scale(s, s);
    _scaleNotifier.value = s;
  }

  void _fitWidth({bool keepVertical = false}) {
    final vp = _bodySize();
    final s = _fitScale(vp);
    final cs = _contentSize(vp);
    final tx = (vp.width - cs.width * s) / 2;
    double ty;
    if (keepVertical) {
      final oldS = _ctrl.value.getMaxScaleOnAxis();
      final oldTy = _ctrl.value.getTranslation().y;
      final cy = vp.height / 2;
      final contentY = oldS != 0 ? (cy - oldTy) / oldS : 0.0;
      ty = cy - contentY * s;
      ty = _clampTx(ty, cs.height * s, vp.height);
    } else {
      // Top of content for fresh fit — multi-page docs need the user to scroll
      // down to reach pages 2..N, so we don't centre vertically.
      ty = cs.height * s > vp.height ? 0.0 : (vp.height - cs.height * s) / 2;
    }
    // ignore: deprecated_member_use
    _ctrl.value = Matrix4.identity()..translate(tx, ty)..scale(s, s);
    _scaleNotifier.value = s;
  }

  // Viewport changed (iPad split-view, rotation): recompute matrix so content
  // stays horizontally centred and vertically anchored. Without this, the old
  // tx (based on the old vp.width) leaves the page off-centre after the system
  // shrinks the view.
  void _reanchorOnViewport(Size vp) {
    final fit = _fitScale(vp);
    final oldS = _ctrl.value.getMaxScaleOnAxis();
    final s = oldS < fit ? fit : oldS.clamp(fit, _maxScale);
    final cs = _contentSize(vp);
    final tx = (vp.width - cs.width * s) / 2;
    double ty;
    final oldTy = _ctrl.value.getTranslation().y;
    if (oldS > 0 && _lastVp != null) {
      // Preserve the content y currently sitting at the old vertical centre.
      final oldCy = _lastVp!.height / 2;
      final contentY = (oldCy - oldTy) / oldS;
      ty = vp.height / 2 - contentY * s;
    } else {
      ty = cs.height * s > vp.height ? 0.0 : (vp.height - cs.height * s) / 2;
    }
    ty = _clampTx(ty, cs.height * s, vp.height);
    // ignore: deprecated_member_use
    _ctrl.value = Matrix4.identity()..translate(tx, ty)..scale(s, s);
    _scaleNotifier.value = s;
  }

  void _onPointerScroll(PointerScrollEvent e) {
    final dy = e.scrollDelta.dy * _scrollSpeed;
    final dx = e.scrollDelta.dx * _scrollSpeed;
    if (dy == 0 && dx == 0) return;
    final m = _ctrl.value.clone();
    final t = m.getTranslation();
    final s = m.getMaxScaleOnAxis();
    final vp = _bodySize();
    final cs = _contentSize(vp);
    final newX = dx != 0 ? _clampTx(t.x - dx, cs.width * s, vp.width) : t.x;
    final newY = dy != 0 ? _clampTx(t.y - dy, cs.height * s, vp.height) : t.y;
    // ignore: deprecated_member_use
    _ctrl.value = Matrix4.identity()..translate(newX, newY)..scale(s, s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      appBar: AppBar(
        backgroundColor: _red,
        title: Text(widget.reportNo, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Print',
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: _pdfBytes == null ? null : _print,
          ),
          IconButton(
            tooltip: 'Zoom out',
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: _pages == null ? null : () => _zoomTo(_scaleNotifier.value - _zoomStep),
          ),
          GestureDetector(
            onTap: _pages == null ? null : () => _fitWidth(keepVertical: true),
            child: SizedBox(
              width: 56,
              child: Center(
                child: ValueListenableBuilder<double>(
                  valueListenable: _scaleNotifier,
                  builder: (_, scale, __) => Text(
                    '${(scale * 100).toInt()}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Zoom in',
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: _pages == null ? null : () => _zoomTo(_scaleNotifier.value + _zoomStep),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _error != null
          ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(_error!, style: const TextStyle(color: Colors.red))))
          : _pages == null
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  key: _bodyKey,
                  builder: (context, constraints) {
                    final vp = Size(constraints.maxWidth, constraints.maxHeight);
                    if (!_didFit && vp.width > 0) {
                      _didFit = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _fitWidth();
                          _lastVp = vp;
                          setState(() => _ready = true);
                        }
                      });
                    } else if (_lastVp != null && vp.width > 0 &&
                        (vp.width != _lastVp!.width || vp.height != _lastVp!.height)) {
                      // iPad split-view / rotation shrunk or reshaped the viewport.
                      // Re-anchor on the new vp so content stays centred.
                      final prev = _lastVp!;
                      _lastVp = vp;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _lastVp = prev; // restore so _reanchorOnViewport sees the OLD vp
                          _reanchorOnViewport(vp);
                          _lastVp = vp;
                        }
                      });
                    }
                    final cs = _contentSize(vp);
                    final paperW = _naturalPaperW();
                    return Opacity(
                      opacity: _ready ? 1.0 : 0.0,
                      child: Listener(
                        onPointerSignal: (e) {
                          if (e is PointerScrollEvent) _onPointerScroll(e);
                        },
                        child: InteractiveViewer(
                          transformationController: _ctrl,
                          constrained: false,
                          minScale: _fitScale(vp),
                          maxScale: _maxScale,
                          boundaryMargin: EdgeInsets.zero,
                          onInteractionUpdate: (_) {
                            final s = _ctrl.value.getMaxScaleOnAxis();
                            if ((s - _scaleNotifier.value).abs() > 0.001) {
                              _scaleNotifier.value = s;
                            }
                          },
                          child: SizedBox(
                            width: cs.width,
                            height: cs.height,
                            child: Center(
                              child: SizedBox(
                                width: paperW,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: _shellPad),
                                    for (int i = 0; i < _pages!.length; i++) ...[
                                      // Each page = white image on grey body.
                                      // Shadow makes the paper edge pop on grey.
                                      DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x40000000),
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Image.memory(
                                          _pages![i].png,
                                          width: _pages![i].width,
                                          height: _pages![i].height,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(height: i < _pages!.length - 1 ? _gapBetween : _shellPad),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _PageImage {
  final Uint8List png;
  final double width;
  final double height;
  const _PageImage({required this.png, required this.width, required this.height});
}
