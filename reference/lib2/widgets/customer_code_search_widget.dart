import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/database_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerCodeSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool hideHint;
  final Color color;

  const CustomerCodeSearchWidget({
    super.key,
    required this.controller,
    required this.color,
    required this.hideHint,
  });

  @override
  _CustomerCodeSearchWidgetState createState() =>
      _CustomerCodeSearchWidgetState();
}

class _CustomerCodeSearchWidgetState extends State<CustomerCodeSearchWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  void _searchCustomerCodes(String query) async {
    //将英文字母转大些，其他字符不变
    final uppercased = query.replaceAllMapped(RegExp(r'[a-zA-Z]'), (match) {
      return match.group(0)!.toUpperCase();
    });

    // 避免无限循环更新：只有值真的改变时再更新
    if (uppercased != query) {
      final cursorPos = widget.controller.selection;
      widget.controller.value = TextEditingValue(
        text: uppercased,
        selection: cursorPos, //保持光标位置
      );
    }

    if (query.isEmpty) {
      setState(() {});
      _removeOverlay();
      return;
    }

    List<Map<String, dynamic>> results =
        await _dbHelper.searchCustomerCodes(query);
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
        width: MediaQuery.of(context).size.width * 0.2,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0.w, 30.h),
          child: Material(
            elevation: 4.0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 250.h,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final line = results[index];
                  return ListTile(
                    title: Text(
                      line['code']!,
                      style: TextStyle(fontSize: 7.5.sp),
                    ),
                    onTap: () {
                      setState(() {
                        widget.controller.text = line['code'];
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
      child: Container(
        height: 30.h, // 设置固定高度，保证和不可编辑单元格一致d
        decoration: BoxDecoration(
          color: widget.color,
          //border: Border.all(color: Colors.blueGrey), // 为单元格添加边框
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: TextField(
          controller: widget.controller,
          onChanged: _searchCustomerCodes,

          textAlignVertical: TextAlignVertical.center, // 使文字垂直居中
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 7.sp, // 设置输入文字的字体大小
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 11.h, horizontal: 2.w), // 调整内边距以确保文字居中
            border: InputBorder.none,
            fillColor: widget.color,
            hintText: '',
            hintStyle: TextStyle(
              fontSize: 6.sp, // 设置 hintText 的字体大小
              color: widget.hideHint ? Colors.transparent : Colors.grey,
            ),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
          ],
        ),
      ),
    );
  }
}
