import 'package:flutter/material.dart';
import 'package:mayekawa/pages/report_page.dart';
import '../utils/database_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool hideHint;
  final String hintText;
  final bool filled;
  final Function(String address) onCustomerSelected;

  const CustomerSearchWidget({
    Key? key,
    required this.controller,
    required this.hideHint,
    required this.hintText,
    required this.onCustomerSelected,
    this.filled = false,
  }) : super(key: key);

  @override
  _CustomerSearchWidgetState createState() => _CustomerSearchWidgetState();
}

class _CustomerSearchWidgetState extends State<CustomerSearchWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  void _searchCustomers(String query) async {
    if (query.isEmpty) {
      setState(() {});
      _removeOverlay();
      return;
    }

    List<Map<String, dynamic>> results = await _dbHelper.searchCustomers(query);
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
        width: MediaQuery.of(context).size.width * 0.7,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(-10.w, 30.h),
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
                  final customer = results[index];
                  return ListTile(
                    title: Text(
                      "${customer['code']}  ${customer['name']}",
                      style: TextStyle(fontSize: 7.5.sp),
                    ),
                    onTap: () {
                      setState(() {
                        widget.controller.text = customer['name'];
                      });

                      //调用毁掉函数，将地址和其他字段传递回去
                      final address = customer['address'] ?? '';

                      widget.onCustomerSelected(
                        address,
                      );

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
        foregroundPainter: DashedUnderlinePainter(),
        child: TextField(
          controller: widget.controller,
          onChanged: _searchCustomers,

          textAlignVertical: TextAlignVertical.center, // 使文字垂直居中
          style: TextStyle(
            fontSize: 6.sp, // 设置输入文字的字体大小
          ),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                vertical: 1.h, horizontal: 2.w), // 调整内边距以确保文字居中
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
