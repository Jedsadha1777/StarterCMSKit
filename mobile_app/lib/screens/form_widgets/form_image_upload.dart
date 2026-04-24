import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormImageUpload extends StatefulWidget {
  final String name;
  final String source; // 'upload', 'camera', 'both'
  final double? width;
  final double? height;
  final String? value;
  final bool required;
  final ValueChanged<XFile?>? onPicked;

  const FormImageUpload({
    super.key,
    required this.name,
    this.source = 'both',
    this.width,
    this.height,
    this.value,
    this.required = false,
    this.onPicked,
  });

  factory FormImageUpload.fromJson(Map<String, dynamic> json, {
    ValueChanged<XFile?>? onPicked,
  }) {
    return FormImageUpload(
      name: json['name'] as String? ?? '',
      source: json['source'] as String? ?? 'both',
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      value: json['value'] as String?,
      required: json['required'] == true,
      onPicked: onPicked,
    );
  }

  @override
  State<FormImageUpload> createState() => _FormImageUploadState();
}

class _FormImageUploadState extends State<FormImageUpload> {
  final _picker = ImagePicker();
  XFile? _pickedFile;
  String? _initialPath;

  @override
  void initState() {
    super.initState();
    _initialPath = widget.value;
  }

  @override
  void didUpdateWidget(covariant FormImageUpload oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && _pickedFile == null) {
      _initialPath = widget.value;
    }
  }

  bool get _hasImage => _pickedFile != null || (_initialPath != null && _initialPath!.isNotEmpty);
  String get _displayPath => _pickedFile?.path ?? _initialPath!;
  bool get _showUpload => widget.source == 'upload' || widget.source == 'both';
  bool get _showCamera => widget.source == 'camera' || widget.source == 'both';

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() { _pickedFile = picked; _initialPath = null; });
      widget.onPicked?.call(picked);
    }
  }

  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() { _pickedFile = picked; _initialPath = null; });
      widget.onPicked?.call(picked);
    }
  }

  void _clear() {
    setState(() { _pickedFile = null; _initialPath = null; });
    widget.onPicked?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? 150;
    final h = widget.height ?? 150;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.required && !_hasImage ? Colors.orange.shade300 : Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.shade50,
      ),
      child: _hasImage ? _buildPreview() : _buildButtons(),
    );
  }

  Widget _buildPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        kIsWeb
            ? Image.network(_displayPath, fit: BoxFit.contain)
            : Image.file(File(_displayPath), fit: BoxFit.contain),
        Positioned(
          top: 2, right: 2,
          child: GestureDetector(
            onTap: _clear,
            child: Container(
              padding: const EdgeInsets.all(2),
              color: Colors.black54,
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_showUpload)
          TextButton.icon(
            onPressed: _pickFromGallery,
            icon: const Icon(Icons.photo_library, size: 16),
            label: const Text('Gallery', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              side: const BorderSide(color: Colors.grey, width: 0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          ),
        if (_showUpload && _showCamera) const SizedBox(height: 6),
        if (_showCamera)
          TextButton.icon(
            onPressed: _pickFromCamera,
            icon: const Icon(Icons.camera_alt, size: 16),
            label: const Text('Camera', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              side: const BorderSide(color: Colors.grey, width: 0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          ),
      ],
    );
  }
}
