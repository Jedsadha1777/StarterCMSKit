import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class FormSignature extends StatefulWidget {
  final String name;
  final double? width;
  final double? height;
  final String? value;
  final Uint8List? initialData;
  final bool snapMode;
  final ValueChanged<Uint8List?>? onSigned;

  const FormSignature({
    super.key,
    required this.name,
    this.width,
    this.height,
    this.value,
    this.initialData,
    this.snapMode = false,
    this.onSigned,
  });

  factory FormSignature.fromJson(Map<String, dynamic> json, {
    ValueChanged<Uint8List?>? onSigned,
  }) {
    return FormSignature(
      name: json['name'] as String? ?? '',
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      value: json['value'] as String?,
      onSigned: onSigned,
    );
  }

  @override
  State<FormSignature> createState() => _FormSignatureState();
}

class _FormSignatureState extends State<FormSignature> {
  Uint8List? _signatureBytes;
  bool _hasSigned = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _signatureBytes = widget.initialData;
      _hasSigned = true;
    }
  }

  @override
  void didUpdateWidget(covariant FormSignature oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData && widget.initialData != null) {
      setState(() {
        _signatureBytes = widget.initialData;
        _hasSigned = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      decoration: widget.snapMode
          ? null
          : BoxDecoration(
              border: Border.all(color: _hasSigned ? Colors.green : Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.shade50,
            ),
      child: _hasSigned && _signatureBytes != null
          ? (widget.snapMode
              ? Center(child: Image.memory(_signatureBytes!, fit: BoxFit.contain))
              : Stack(
                  children: [
                    Center(child: Image.memory(_signatureBytes!, fit: BoxFit.contain)),
                    Positioned(
                      top: 2, right: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _signatureBytes = null;
                            _hasSigned = false;
                          });
                          widget.onSigned?.call(null);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          color: Colors.black54,
                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ))
          : (widget.snapMode
              ? const SizedBox.shrink()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.draw_outlined, size: 24, color: Colors.grey.shade400),
                    const SizedBox(height: 4),
                    Text('Tap to sign', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                  ],
                )),
    );

    if (widget.snapMode) return container;
    return GestureDetector(
      onTap: () => _openSignaturePage(context),
      child: container,
    );
  }

  Future<void> _openSignaturePage(BuildContext context) async {
    final result = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(builder: (_) => _SignaturePage(name: widget.name)),
    );
    if (result != null) {
      setState(() {
        _signatureBytes = result;
        _hasSigned = true;
      });
      widget.onSigned?.call(result);
    }
  }
}

class _SignaturePage extends StatefulWidget {
  final String name;
  const _SignaturePage({required this.name});

  @override
  State<_SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<_SignaturePage> {
  final _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFAD193C),
        title: Text('Signature: ${widget.name}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Signature(
                  controller: _controller,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.clear(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Clear', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      final bytes = await _controller.toPngBytes();
                      if (bytes != null && mounted) {
                        Navigator.pop(context, bytes);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAD193C)),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
