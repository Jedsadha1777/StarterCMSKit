import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FormFile extends StatefulWidget {
  final String name;
  final String? accept;
  final bool multiple;
  final int? maxSizeMb;
  final dynamic value;
  final bool required;
  final ValueChanged<List<PlatformFile>?>? onPicked;

  const FormFile({
    super.key,
    required this.name,
    this.accept,
    this.multiple = false,
    this.maxSizeMb,
    this.value,
    this.required = false,
    this.onPicked,
  });

  factory FormFile.fromJson(Map<String, dynamic> json, {
    ValueChanged<List<PlatformFile>?>? onPicked,
  }) {
    return FormFile(
      name: json['name'] as String? ?? '',
      accept: json['accept'] as String?,
      multiple: json['multiple'] == true,
      maxSizeMb: (json['maxSize'] as num?)?.toInt(),
      value: json['value'],
      required: json['required'] == true,
      onPicked: onPicked,
    );
  }

  @override
  State<FormFile> createState() => _FormFileState();
}

class _FormFileState extends State<FormFile> {
  List<PlatformFile> _files = [];

  List<String>? get _allowedExtensions {
    if (widget.accept == null) return null;
    return widget.accept!
        .split(',')
        .map((e) => e.trim().replaceAll('.', ''))
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.multiple,
      type: _allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: _allowedExtensions,
    );

    if (result != null && result.files.isNotEmpty) {
      final validFiles = widget.maxSizeMb != null
          ? result.files.where((f) => (f.size / 1024 / 1024) <= widget.maxSizeMb!).toList()
          : result.files;

      setState(() => _files = validFiles);
      widget.onPicked?.call(validFiles);
    }
  }

  void _clear() {
    setState(() => _files = []);
    widget.onPicked?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    if (_files.isNotEmpty) {
      return _buildFileList();
    }
    return _buildPickButton();
  }

  Widget _buildPickButton() {
    return GestureDetector(
      onTap: _pickFiles,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.required ? Colors.orange.shade300 : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload_file, size: 20, color: Colors.grey.shade400),
            const SizedBox(width: 8),
            Text(
              'Choose file${widget.multiple ? 's' : ''}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            if (widget.accept != null) ...[
              const SizedBox(width: 8),
              Text('(${widget.accept})',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFileList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.green.shade50,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_file, size: 16, color: Colors.green),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              _files.map((f) => f.name).join(', '),
              style: const TextStyle(fontSize: 12, color: Colors.green),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _clear,
            child: const Icon(Icons.close, size: 14, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
