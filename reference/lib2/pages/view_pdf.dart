import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:mayekawa/config.dart'; //之后联网要用

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart' hide Config;

import 'package:printing/printing.dart';

import 'dart:ui' as ui;

// ignore: must_be_immutable
class ViewPdf extends StatefulWidget {
  final String pdfPath; // PDF 文件路径
  final String jobNo;

  const ViewPdf({
    Key? key,
    required this.pdfPath,
    required this.jobNo,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  OverlayEntry? _overlayEntry; //定义悬浮提示框

  bool _isLoading = true;
  late PDFDocument _document;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    _document = await PDFDocument.fromAsset(widget.pdfPath);
    setState(() {
      _isLoading = false;
    });
  }

  // 显示错误对话框
  Future<void> _showErrorDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  //Ref No.重复报警对话框
  Future<bool?> _showDuplicatedKeyDialog(
      BuildContext context, String message) async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    //创建Completer, 用于等待用户点击ok
    final Completer<bool?> completer = Completer<bool?>();

    //创建 OverlayEntry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            //半透明背景层，拦截触摸事件
            Positioned.fill(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.37,
              left: MediaQuery.of(context).size.width * 0.25,
              width: MediaQuery.of(context).size.width * 0.65,
              height: 200.h,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(top: 13.h, left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10.w,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50.w,
                        color: const Color(0xFFAD193C), // 默认颜色
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 9.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                  Size(90.w, 15.h)),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return const Color(0xFF8B102D); // 按下时颜色（深一点）
                                }
                                return const Color(0xFFAD193C); // 默认颜色
                              }),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 8.h),
                              ),
                            ),
                            onPressed: () {
                              // 移除对话框
                              _overlayEntry?.remove();
                              _overlayEntry = null;

                              completer.complete(true);
                            },
                            child: Text(
                              'Upload Anyway',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                  Size(90.w, 15.h)),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return const Color(0xFF8B102D); // 按下时颜色（深一点）
                                }
                                return const Color(0xFFAD193C); // 默认颜色
                              }),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              padding:
                                  WidgetStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 8.h),
                              ),
                            ),
                            onPressed: () {
                              // 移除对话框
                              _overlayEntry?.remove();
                              _overlayEntry = null;

                              completer.complete(false);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    // 显示Overlay
    Overlay.of(context).insert(_overlayEntry!);

    //等待用户点击ok
    return completer.future;
  }

  // 保存或发送pdf
  Future<void> _handleSendPdf(BuildContext context) async {
    //获取多个收件人邮箱
    final List<String>? recipientEmails = await _showEmailDialog(context);

    if (recipientEmails == null || recipientEmails.isEmpty) return;

    //弹出对话框，允许用户输入收件人邮箱地址

    //在这里显示加载正在发送的提示框
    _showLoadingDialog(context, "Sending email...");

    //在这里写发送邮件逻辑
    final smtpServer = gmail(Config.smtpServer, Config.smtpPass);

    final jobNo = widget.jobNo;
    final message = Message()
      ..from = const Address(Config.smtpServer, Config.smtpSender)
      ..recipients.addAll(recipientEmails) //使用刚才输入的邮箱地址
      ..ccRecipients.add('Service_All@mth.co.th') //CC对象
      ..subject = 'Mayekawa Service Report - $jobNo'
      ..text = 'Please find the attached service report file for No.: $jobNo'
      ..attachments.add(FileAttachment(File(widget.pdfPath)));

    try {
      final sendReport = await send(message, smtpServer);

      //关闭正在发送的提示框
      Navigator.pop(context);

      //弹出发送成功的对话框并暂停程序
      await _sentOutDialog(context, "Mail sent: $sendReport");

      //接着发送表单数据到后端
      //await _makeChangesToBackend(context);  //暂时关闭此功能
    } catch (e) {
      //关闭正在发送的提示框
      Navigator.pop(context);
      //发送失败
      await _sentFailedDialog(context, "Failed to send email: $e");
    }
  }

  //显示输入电子邮箱地址的对话框
  Future<List<String>?> _showEmailDialog(BuildContext context) async {
    return await showDialog<List<String>>(
      context: context,
      builder: (context) {
        String emailErrorTxt = "";
        final emailControllers = List<TextEditingController>.generate(
            5, (_) => TextEditingController());
        return StatefulBuilder(
          builder: (context, setState) {
            void clearError() {
              if (emailErrorTxt.isNotEmpty) {
                setState(() => emailErrorTxt = "");
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.w), // 圆角对话框
              ),
              child: Container(
                width:
                    MediaQuery.of(context).size.width * 0.8, // 设置对话框宽度为屏幕宽度的80%
                padding: EdgeInsets.only(
                    top: 15.h, left: 35.w, right: 35.w, bottom: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 根据内容动态调整高度
                  children: [
                    // 顶部电子邮件图标
                    Icon(
                      Icons.email_outlined,
                      size: 50.w,
                      color: const Color(0xFFAD193C), // 默认颜色
                    ),
                    SizedBox(height: 5.h),

                    // 标题
                    Text(
                      "Send Email",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // 提示文字
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter recipient email address:",
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // 输入框0
                    TextField(
                      controller: emailControllers[0],
                      decoration: InputDecoration(
                        hintText: "example@example.com",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 3.h,
                          horizontal: 10.w,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onTap: clearError,
                      onChanged: (_) => clearError(),
                    ),

                    SizedBox(height: 15.h),

                    // 输入框1
                    TextField(
                      controller: emailControllers[1],
                      decoration: InputDecoration(
                        hintText: "optional 2",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 3.h,
                          horizontal: 10.w,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onTap: clearError,
                      onChanged: (_) => clearError(),
                    ),
                    SizedBox(height: 15.h),

                    // 输入框2
                    TextField(
                      controller: emailControllers[2],
                      decoration: InputDecoration(
                        hintText: "optional 3",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 3.h,
                          horizontal: 10.w,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onTap: clearError,
                      onChanged: (_) => clearError(),
                    ),
                    SizedBox(height: 15.h),

                    // 输入框3
                    TextField(
                      controller: emailControllers[3],
                      decoration: InputDecoration(
                        hintText: "optional 4",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 3.h,
                          horizontal: 10.w,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onTap: clearError,
                      onChanged: (_) => clearError(),
                    ),
                    SizedBox(height: 15.h),

                    // 输入框4
                    TextField(
                      controller: emailControllers[4],
                      decoration: InputDecoration(
                        hintText: "optional 5",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 3.h,
                          horizontal: 10.w,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onTap: clearError,
                      onChanged: (_) => clearError(),
                    ),

                    SizedBox(height: 10.h),

                    // 邮箱格式错误提示文字
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        emailErrorTxt,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFAD193D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // 按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 返回 null 表示取消
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // 取消按钮颜色

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final raw = emailControllers
                                .map((c) => c.text.trim())
                                .toList();

                            // 第一个必填
                            if (raw[0].isEmpty) {
                              setState(() {
                                emailErrorTxt = "Recipient 1 is required!";
                              });
                              return;
                            }

                            //校验第一个email格式
                            if (!_isValidEmail(raw[0])) {
                              setState(() {
                                emailErrorTxt =
                                    "Recipient 1 is not a valid email!";
                              });
                              return;
                            }

                            //校验后四个（如果填写）
                            for (int i = 1; i < 5; i++) {
                              if (raw[i].isNotEmpty && !_isValidEmail(raw[i])) {
                                setState(() {
                                  emailErrorTxt =
                                      "Recipient ${i + 1} is not a valid email!";
                                });
                                return;
                              }
                            }

                            final emails = <String>{};
                            for (final e in raw) {
                              if (e.isNotEmpty) emails.add(e);
                            }

                            Navigator.of(context)
                                .pop(emails.toList()); // 返回输入的邮箱地址
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFAD193C), // 默认颜色 // 确定按钮颜色
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                          ),
                          child: Text(
                            "Send",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  //发送工程中的对话框
  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // 禁止点击背景关闭对话框
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // 禁止使用后退按钮关闭对话框
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                SizedBox(width: 6.w),
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }

  //正常发送结束时对话框
  Future<void> _sentOutDialog(BuildContext context, String message) async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    //创建Completer, 用于等待用户点击ok
    final Completer<void> completer = Completer<void>();

    // 创建 OverlayEntry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            //半透明背景层，拦截触摸事件
            Positioned.fill(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              height: 400.h,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10.w,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi,
                        size: 50.w,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 9.sp,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize:
                              WidgetStateProperty.all<Size>(Size(90.w, 15.h)),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.pressed)) {
                              return const Color(0xFF8B102D); // 按下时颜色（深一点）
                            }
                            return const Color(0xFFAD193C); // 默认颜色
                          }),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 8.h),
                          ),
                        ),
                        onPressed: () {
                          // 移除对话框
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                          //完成completer
                          completer.complete();
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    // 显示 Overlay
    Overlay.of(context).insert(_overlayEntry!);

    //等待用户点击ok
    return completer.future;
  }

  //没网络发送不了时的对话框
  Future<void> _sentFailedDialog(BuildContext context, String message) async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    // 创建 OverlayEntry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            //半透明背景层，拦截触摸事件
            Positioned.fill(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              height: 400.h,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10.w,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 50.w,
                        color: const Color(0xFFFF0000),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 9.sp,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize:
                              WidgetStateProperty.all<Size>(Size(90.w, 15.h)),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.pressed)) {
                              return const Color(0xFFA30000);
                            }
                            return const Color(0xFFFF0000);
                          }),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 8.h),
                          ),
                        ),
                        onPressed: () {
                          // 移除对话框
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    // 显示 Overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Report Reviewing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: ui.FontWeight.bold,
            fontSize: 11.sp,
            fontFamily: 'NotoSansThai',
          ),
        ),
        backgroundColor: const Color(0xFFAD193C),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 滑动缩放区域
          Expanded(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              boundaryMargin: EdgeInsets.zero, //无边界限制
              //minScale: 0.5,
              maxScale: 6,

              //child: SizedBox(
              //height: 1000.h,
              //height: MediaQuery.of(context).size.height / 1.2, //改为动态高度
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : PDFViewer(
                      document: _document,
                      scrollDirection: Axis.horizontal, //垂直滚动PDF
                      lazyLoad: false, //禁用延迟加载，确保所有页面预加载
                      pickerButtonColor: Colors.blue,
                      //pickerIconColor: Colors.yellow,
                      showIndicator: true,
                      indicatorPosition: IndicatorPosition.topRight,
                      showPicker: true,
                      //zoomSteps: 3,
                      onPageChanged: (currentPage) {
                        debugPrint("Current page: $currentPage");
                      },
                    ),
              //),
            ),
          ),

          // 底部的按钮
          Padding(
            //padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            padding: EdgeInsets.only(
                left: 30.w, right: 30.w, top: 10.h, bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //SizedBox(height: 10.h),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:
                        WidgetStateProperty.all<Size>(Size(90.w, 40.h)),
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF8B102D); // 按下时颜色（深一点）
                      }
                      return const Color(0xFFAD193C); // 默认颜色
                    }),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:
                        WidgetStateProperty.all<Size>(Size(90.w, 40.h)),
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF8B102D); // 按下时颜色（深一点）
                      }
                      return const Color(0xFFAD193C); // 默认颜色
                    }),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    ),
                  ),
                  onPressed: () async {
                    // 调用打印预览功能
                    await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async {
                      // 将当前的pdf数据返回给打印
                      final pdfBytes = await File(widget.pdfPath).readAsBytes();
                      return pdfBytes;
                    });
                  },
                  child: Text(
                    'Print',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:
                        WidgetStateProperty.all<Size>(Size(90.w, 40.h)),
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF8B102D); // 按下时颜色（深一点）
                      }
                      return const Color(0xFFAD193C); // 默认颜色
                    }),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    ),
                  ),
                  onPressed: () async {
                    _handleSendPdf(context);
                    //await _makeChangesToBackend(context);
                  },
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
