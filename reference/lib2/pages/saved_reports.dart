import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive/hive.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'login_page.dart';

import 'report_page.dart';

class SavedReports extends StatefulWidget {
  const SavedReports({super.key});

  @override
  State<SavedReports> createState() => _SavedReportsState();
}

class _SavedReportsState extends State<SavedReports> {
  final ScrollController _scrollController = ScrollController();

  // final List<Map<String, String>> reports = List.generate(30, (index) {
  //   return {
  //     'date': '11-Nov-2024',
  //     'job': 'XYZZHR00${(index + 1).toString().padLeft(4, '0')}25',
  //   };
  // });

  List<Map<String, dynamic>> reports = [];
  Map<String, String> _downloadedPaths = {};



  String? _sortField; //"date" or "job"
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadReportsFormHive();
    _loadDownloadedPaths();
  }

   Future<void> _loadDownloadedPaths() async {
     final box = await Hive.openBox('downloaded_pdfs');
    Map<String, String> valid = {};
    List<String> toRemove = [];
    for (var key in box.keys) {
      final path = box.get(key);
      if (path is String && File(path).existsSync()) {
        valid[key as String] = path;
      } else {
        toRemove.add(key as String);
      }
    }
    for (var key in toRemove) {
      await box.delete(key);
    }
     setState(() {
      _downloadedPaths = valid;
     });
   }

  Future<void> _loadReportsFormHive() async {
    final box = await Hive.openBox('reports');

    List<Map<String, dynamic>> loadedReports = [];

    for (var key in box.keys) {
      final value = box.get(key);
      if (value is Map && value.containsKey('createDt')) {
        loadedReports.add({
          'key': key.toString(),
          'date': _monthString(value['createDt']),
          'job': value['decoratedJobNo'], //cleanJobNo
          'model_id': value['model_id'],
          'timestamp': value['timestamp'] ?? 0, //添加用于排序,并且设置默认时间戳为0
        });
      }
    }

    loadedReports
        .sort((a, b) => b['timestamp'].compareTo(a['timestamp'])); //最新的排在前面

    setState(() {
      reports = loadedReports;
    });
  }

  // 月份转换函数
  String _monthString(String inputDt) {
    List<String> parts = inputDt.split('-');
    int month = int.parse(parts[1]);

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return "${parts[0]}-${months[month - 1]}-${parts[2]}";
  }

  //排序函数
  void _sortReports(String field) {
    setState(() {
      if (_sortField == field) {
        // 同一个字段重复点击： 升序-降序-取消排序
        if (_isAscending) {
          _isAscending = false;
        } else {
          //取消排序，恢复初始顺序
          _sortField = null;
          return;
        }
      } else {
        //点击新字段，默认升序
        _sortField = field;
        _isAscending = true;
      }

      // 排序实现
      reports.sort((a, b) {
        final aValue = a[_sortField];
        final bValue = b[_sortField];
        if (aValue is Comparable && bValue is Comparable) {
          return _isAscending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }
        return 0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Image.asset(
                'assets/mayekawa_logo.png',
                width: 150.w,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              color: const Color(0xFFAD193C),
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              width: double.infinity,
              height: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Service Report Tool',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all<Size>(
                        Size(80.w, 28.w), // 设置按钮的宽度为无限制，高度为30.w
                      ),
                      backgroundColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFF82132D); // 按下时背景变蓝
                        }
                        return const Color(0xFFAD193C); // 默认与Banner颜色一致
                      }),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r), // 圆角
                          side: const BorderSide(color: Colors.white), // 白色边框
                        ),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                      ),
                    ),
                    onPressed: () {
                      // 点击事件处理
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // 标题
                  Text(
                    'Saved Reports',
                    style:
                        TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  const Divider(thickness: 2, color: Colors.black),

                  // 表头
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _tableHeader('Date', flex: 3, sortKey: 'date'),
                        _tableHeader('Job Number', flex: 4, sortKey: 'job'),
                        _tableHeader('PDF', flex: 2),
                        _tableHeader('Check', flex: 2),
                        _tableHeader('Operation', flex: 2),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  // 表格内容区域（固定高度 + 可滚动 + 上下边框 + 行分隔线）
                  Container(
                    height: 440.h,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade400, width: 1),
                        bottom:
                            BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 7,
                      radius: Radius.circular(6.r),
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: reports.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.shade300,
                          thickness: 0.8,
                          height: 0, // 避免额外空隙
                        ),
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              12.w,
                              index == 0 ? 0.h : 8.h, // ✅ 第一行垂直间距缩小
                              12.w,
                              8.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 日期
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Text(
                                      report['date']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 8.sp),
                                    ),
                                  ),
                                ),

                                // 工号
                                Expanded(
                                  flex: 4,
                                  child: Center(
                                    child: Text(
                                      report['job']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 8.sp),
                                    ),
                                  ),
                                ),


                                // Download PDF
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReportPage(
                                              model_id: report['model_id'],
                                              jobKey: report['job'],
                                              downloadOnly: true,
                                            ),
                                          ),
                                        );
                                        if (result != null && result is String) {
                                          final dlBox = await Hive.openBox('downloaded_pdfs');
                                          await dlBox.put(report['key'], result);

                                          setState(() {
                                            _downloadedPaths[report['key']] = result;
                                          });
                                          if (mounted) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.w),
                                                ),
                                                title: Row(
                                                  children: [
                                                    
                                                    Text('Success', style: TextStyle(fontSize: 9.5.sp)),
                                                  ],
                                                ),
                                                content: Text(
                                                  'PDF saved to Documents.',
                                                  style: TextStyle(fontSize: 8.sp),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text('OK', style: TextStyle(fontSize: 8.sp)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: _downloadedPaths.containsKey(report['key'])
                                          ? Icon(Icons.check_circle, size: 16.sp, color: Colors.green)
                                          : Icon(Icons.download, size: 16.sp, color: const Color(0xFF1565C0)),
                                    ),
                                  ),
                                ),


                                // 编辑按钮
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final shouldRefresh =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReportPage(
                                              model_id: report['model_id'],
                                              jobKey: report['job'],
                                            ),
                                          ),
                                        );

                                        if (shouldRefresh == true) {
                                          _loadReportsFormHive();
                                        }
                                      },
                                      child: Text(
                                        'Edit',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xff02B051),
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              const Color(0xff02B051),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // 删除按钮
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final confirmed =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.w),
                                            ),
                                            elevation: 24,
                                            title: Text(
                                              'Delete Report',
                                              style:
                                                  TextStyle(fontSize: 9.5.sp),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete the report of ${report['job']}?',
                                              style: TextStyle(fontSize: 8.sp),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false); // 关闭对话框
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style:
                                                      TextStyle(fontSize: 8.sp),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true); // 关闭对话框
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style:
                                                      TextStyle(fontSize: 8.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmed == true) {
                                          final box =
                                              await Hive.openBox('reports');
                                          final deleteKey = report['key'];
                                          await box.delete(deleteKey);

                                          //删除签名和照片文件
                                          final dir =
                                              await getApplicationSupportDirectory();
                                          final baseName = deleteKey;

                                          List<String> suffixes = [
                                            '_1.jpg',
                                            '_2.jpg',
                                            '_staff_sign.png',
                                            '_customer_sign.png',
                                          ];

                                          for (var suffix in suffixes) {
                                            final file = File(
                                                '${dir.path}/$baseName$suffix');
                                            if (await file.exists()) {
                                              await file.delete();
                                            }
                                          }

                                          setState(() {
                                            reports.removeAt(index);
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Delete',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFFAD193C),
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              const Color(0xFFAD193C),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  //返回按钮
                  SizedBox(
                    width: 120.w,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, reports); // 返回
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color(0xFF8B102D); // 按下时颜色（深一点）
                          }
                          return const Color(0xFFAD193C); // 默认颜色
                        }),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        elevation:
                            WidgetStateProperty.resolveWith<double>((states) {
                          return states.contains(WidgetState.pressed) ? 1 : 3;
                        }),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String title, {required int flex, String? sortKey}) {
    Icon? sortIcon;

    if (sortKey != null && _sortField == sortKey) {
      sortIcon = Icon(
        _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
        size: 12.sp,
        color: const Color(0xFFAD193C), // 默认颜色
      );
    } else if (sortKey != null && _sortField != sortKey) {
      sortIcon = Icon(
        Icons.sort_sharp,
        size: 12.sp,
        color: Colors.green,
      );
    }

    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: sortKey != null ? () => _sortReports(sortKey) : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold),
            ),
            if (sortIcon != null) ...[
              SizedBox(width: 4.w),
              sortIcon,
            ],
          ],
        ),
      ),
    );
  }
}
