import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

import 'login_page.dart';

import 'dart:convert';
import 'package:mayekawa/config.dart';
import 'package:http/http.dart' as http;

import 'package:mayekawa/config.dart' as prefix;

import 'view_pdf.dart';

class PastReports extends StatefulWidget {
  const PastReports({super.key});

  @override
  State<PastReports> createState() => _PastReportsState();
}

class _PastReportsState extends State<PastReports> {
  final ScrollController _scrollController = ScrollController();

  // final List<Map<String, String>> reports = List.generate(30, (index) {
  //   return {
  //     'date': '11-Nov-2024',
  //     'job': 'XYZZHR00${(index + 1).toString().padLeft(4, '0')}25',
  //   };
  // });

  List<Map<String, dynamic>> reports = [];

  String? _sortField; //"date" or "job"
  bool _isAscending = true;

  bool isLoading = true; //加载状态

  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _checkNetworkTimeout();
    _fetchTableData();
  }

  //检查网络超时
  void _checkNetworkTimeout() async {
    await Future.delayed(const Duration(seconds: 6));
    if (isLoading) {
      //如果数据还没有加载，弹出对话框
      if (mounted) {
        _showNetworkErrorDialog();
      }
    }
  }

  //显示网络错误对话框
  Future<void> _showNetworkErrorDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Network Error"),
          content: const Text("Please check your network connection"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); //关闭对话框
                  Navigator.of(context).pop(); //返回上一页
                },
                child: const Text("OK")),
          ],
        );
      },
    );
  }

  //从flask后段获取数据
  Future<void> _fetchTableData() async {
    String apiUrl = "${Config.apiBaseUrl}/fetch-report-list";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        //解析json数据
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          //将jason数据转为 List<Map<String,String>>
          reports = jsonData
              .map((item) => Map<String, String>.from(item))
              .toList()
              .reversed
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      setState(() {
        isLoading = false;
        _showNetworkErrorDialog();
      });
    }
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

  Future<File> downloadAndSavePDF(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/downloaded_temp_report.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download PDF: ${response.statusCode}');
    }
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
      body: isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Loading report list...',
                  style: TextStyle(fontSize: 10.sp, color: Colors.blueGrey),
                ),
              ],
            ))
          : SingleChildScrollView(
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
                                WidgetStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color(0xFF82132D); // 按下时背景变蓝
                              }
                              return const Color(0xFFAD193C); // 默认与Banner颜色一致
                            }),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r), // 圆角
                                side: const BorderSide(
                                    color: Colors.white), // 白色边框
                              ),
                            ),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 8.h),
                            ),
                          ),
                          onPressed: () {
                            // 点击事件处理
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
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
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      children: [
                        // 标题
                        Text(
                          'Viewing Past Reports',
                          style: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.bold),
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
                              _tableHeader('Date', sortKey: 'date'),
                              _tableHeader('Job Number', sortKey: 'job'),
                              _tableHeader('Check'),
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
                              top: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
                              bottom: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // 日期
                                      Expanded(
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
                                        child: Center(
                                          child: Text(
                                            report['job']!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8.sp),
                                          ),
                                        ),
                                      ),

                                      // 查看按钮
                                      Expanded(
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () async {
                                              // print(
                                              //     "${prefix.Config.apiBaseUrl}/download-pdf/${report['pdf_name']}");
                                              setState(
                                                  () => _isDownloading = true);

                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) => const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      ));
                                              try {
                                                File pdfFile =
                                                    await downloadAndSavePDF(
                                                        "${prefix.Config.apiBaseUrl}/download-pdf/${report['pdf_name']}");

                                                //print(pdfFile.path);
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewPdf(
                                                        pdfPath: pdfFile.path,
                                                        jobNo: report['job'],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Error downloading PDF: $e")),
                                                  );
                                                }
                                              } finally {
                                                if (mounted) {
                                                  setState(() =>
                                                      _isDownloading = false);
                                                }
                                              }
                                            },
                                            child: Text(
                                              'View',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.blue,
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
                              Navigator.pop(context); // 返回
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (states) {
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
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              elevation:
                                  WidgetStateProperty.resolveWith<double>(
                                      (states) {
                                return states.contains(WidgetState.pressed)
                                    ? 1
                                    : 3;
                              }),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.white),
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

  Widget _tableHeader(String title, {String? sortKey}) {
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
