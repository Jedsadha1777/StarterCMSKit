import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class FormSignature extends StatefulWidget {
  final String name;
  final String? label;
  final double? width;
  final double? height;
  final String? value;
  final ValueChanged<Uint8List?>? onSigned;

  const FormSignature({
    super.key,
    required this.name,
    this.label,
    this.width,
    this.height,
    this.value,
    this.onSigned,
  });

  factory FormSignature.fromJson(Map<String, dynamic> json, {
    ValueChanged<Uint8List?>? onSigned,
  }) {
    return FormSignature(
      name: json['name'] as String? ?? '',
      label: json['label'] as String?,
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSignaturePage(context),
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: _hasSigned ? Colors.green : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey.shade50,
        ),
        child: _hasSigned && _signatureBytes != null
            ? Stack(
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
              )
            : LayoutBuilder(
                builder: (context, c) {
                  final h = c.maxHeight.isFinite ? c.maxHeight : 100.0;
                  if (h < 24) {
                    return const SizedBox.shrink();
                  }
                  if (h < 44) {
                    return Center(
                      child: Icon(Icons.draw_outlined,
                          size: (h - 4).clamp(12.0, 24.0),
                          color: Colors.grey.shade400),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.draw_outlined, size: 24, color: Colors.grey.shade400),
                      const SizedBox(height: 4),
                      Text('Tap to sign', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Future<void> _openSignaturePage(BuildContext context) async {
    final result = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(builder: (_) => _SignaturePage(name: widget.name, label: widget.label)),
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
  final String? label;
  const _SignaturePage({required this.name, this.label});

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
        title: Text(
          (widget.label != null && widget.label!.isNotEmpty)
            ? widget.label!
            : 'Signature: ${widget.name}',
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
