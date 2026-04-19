import 'package:flutter/material.dart';
import 'package:mayekawa/pages/report_page.dart';
import '../utils/database_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModelSearchReportPage extends StatefulWidget {
  final TextEditingController controller;
  final bool hideHint;
  final String hintText;
  final bool filled;

  const ModelSearchReportPage({
    Key? key,
    required this.controller,
    required this.hideHint,
    required this.hintText,
    this.filled = false,
  }) : super(key: key);

  @override
  _ModelSearchReportPageState createState() => _ModelSearchReportPageState();
}

class _ModelSearchReportPageState extends State<ModelSearchReportPage> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  void _searchModels(String query) async {
    if (query.isEmpty) {
      setState(() {});
      _removeOverlay();
      return;
    }

    List<Map<String, dynamic>> results = await _dbHelper.searchModels(query);
    setState(() {});

    if (results.isEmpty) {
      _removeOverlay();
    } else {
      _showOverlay(results);
    }
  }

  void _showOverlay(List<Map<String, dynamic>> results) {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.3,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0.w, 30.h),
          child: Material(
            elevation: 4.0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 500.h,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final model = results[index];
                  return ListTile(
                    title: Text(
                      model['model']!,
                      style: TextStyle(fontSize: 7.5.sp),
                    ),
                    onTap: () {
                      setState(() {
                        widget.controller.text = model['model'];
                      });

                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: CustomPaint(
        painter: DashedUnderlinePainter(),
        child: TextField(
          controller: widget.controller,
          onChanged: _searchModels,

          textAlignVertical: TextAlignVertical.center, // 使文字垂直居中
          style: TextStyle(
            fontSize: 6.sp, // 设置输入文字的字体大小
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
                vertical: 0, horizontal: 2.w), // 调整内边距以确保文字居中
            border: InputBorder.none,
            fillColor: const Color.fromARGB(136, 255, 235, 59),
            filled: widget.filled,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 6.sp, // 设置 hintText 的字体大小
              color: widget.hideHint ? Colors.transparent : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
