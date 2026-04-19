import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'login_page.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:signature/signature.dart';

// ignore: must_be_immutable
class JobSign extends StatefulWidget {
  final String jobNumber;
  late String? existingStaffSignaturePath;
  late String? existingCustomerSignaturePath;

  JobSign({
    super.key,
    required this.jobNumber,
    this.existingStaffSignaturePath,
    this.existingCustomerSignaturePath,
  });

  @override
  // ignore: library_private_types_in_public_api
  _JobSignState createState() => _JobSignState();
}

class _JobSignState extends State<JobSign> {
  // 创建SignatureController来控制签名板
  final SignatureController _staffController = SignatureController(
    penStrokeWidth: 3.w, // 使用屏幕适配的笔触宽度
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _customerController = SignatureController(
    penStrokeWidth: 3.w, // 使用屏幕适配的笔触宽度
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // 保存 Ishida Staff 签名
  Future<String?> _saveStaffSignature() async {
    if (_staffController.isNotEmpty) {
      final signature = await _staffController.toPngBytes();
      if (signature != null) {
        return await _saveSignatureLocally(
            signature, '${widget.jobNumber.replaceAll('/', '')}_staff_sign');
      }
    }
    return null;
  }

  // 保存 Customer 签名
  Future<String?> _saveCustomerSignature() async {
    if (_customerController.isNotEmpty) {
      final signature = await _customerController.toPngBytes();
      if (signature != null) {
        return await _saveSignatureLocally(
            signature, '${widget.jobNumber.replaceAll('/', '')}_customer_sign');
      }
    }
    return null;
  }

  // 将签名保存到本地的方法
  Future<String?> _saveSignatureLocally(
      Uint8List signature, String fileName) async {
    try {
      final directory = await getApplicationSupportDirectory();
      final path = '${directory.path}/$fileName.png';
      final file = File(path);

      await file.writeAsBytes(signature, flush: true);
      //print("Signature saved at $path"); // 调试用
      return path;
    } catch (e) {
      //print("Error saving signature: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _staffController.dispose();
    _customerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 10.h),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 20.w),
                    //   child: Image.asset(
                    //     'assets/mayekawa_logo.png',
                    //     width: 150.w,
                    //   ),
                    // ),
                    //SizedBox(height: 20.h),
                    //Banner部分
                    Container(
                      color: const Color(0xFFAD193C),
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        bottom: 5.h,
                      ),
                      width: double.infinity,
                      height: 54.h,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Report Signatures',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                            fontFamily: 'NotoSansThai',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    //Service Report Ref. No.文字
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w), // 控制左右间距
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, // 控制内容靠右
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30.h,
                            child: Text(
                              'Job Number:',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: screenWidth * 0.4, // 控制输入框的宽度

                            height: 30.h,
                            child: Text(
                              widget.jobNumber,
                              textAlign: TextAlign.left,

                              style: TextStyle(
                                fontSize: 10.sp, // 设置输入文本的字体大小
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              // decoration: InputDecoration(
                              //   filled: true,
                              //   fillColor: Colors.white, // 设置背景为白色
                              //   border: const OutlineInputBorder(),
                              //   contentPadding: EdgeInsets.symmetric(
                              //       vertical: 5.h, horizontal: 8.w), // 控制输入框内边距
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    //Staff Signature文本
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Staff Signature',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _staffController.clear(); // 清空签名
                              setState(() {
                                widget.existingStaffSignaturePath = null;
                              });
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
                              minimumSize: WidgetStateProperty.all<Size>(
                                  Size(150.w, 18.w)),
                            ),
                            child: Text(
                              'Clear and sign again',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                              ),
                            ), // 适配字体大小
                          ),
                        ],
                      ),
                    ),

                    //签名板1
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        width: screenWidth * 0.9,
                        height: 220.h,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            //border: Border.all(color: Colors.black), // 可选：添加边框
                            ),
                        child: widget.existingStaffSignaturePath != null
                            ? FutureBuilder<Uint8List>(
                                future: File(widget.existingStaffSignaturePath!)
                                    .readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError ||
                                      snapshot.data == false) {
                                    //签名图片加载失败的话，就显示签名板
                                    return Signature(
                                      controller: _staffController,
                                      backgroundColor: Colors.grey[200]!,
                                      //height: 200.h, // 适配屏幕高度
                                    );
                                  } else {
                                    //文件存在，显示图片
                                    return Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.none,
                                    );
                                  }
                                },
                              )
                            : Signature(
                                controller: _staffController,
                                backgroundColor: Colors.grey[200]!,
                                //height: 200.h, // 适配屏幕高度
                              ),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    //Customer Signature文本
                    SizedBox(
                      height: 40.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Customer Signature',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _customerController.clear(); // 清空签名
                              setState(() {
                                widget.existingCustomerSignaturePath = null;
                              });
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
                              minimumSize: WidgetStateProperty.all<Size>(
                                  Size(150.w, 18.w)),
                            ),
                            child: Text(
                              'Clear and sign again',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                              ),
                            ), // 适配字体大小
                          ),
                        ],
                      ),
                    ),

                    //签名板2
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: screenWidth * 0.9,
                        height: 220.h,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            //border: Border.all(color: Colors.black), // 可选：添加边框
                            ),
                        child: widget.existingCustomerSignaturePath != null
                            ? FutureBuilder<Uint8List>(
                                future:
                                    File(widget.existingCustomerSignaturePath!)
                                        .readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError ||
                                      snapshot.data == false) {
                                    return Signature(
                                      controller: _customerController,
                                      backgroundColor: Colors.grey[200]!,
                                    );
                                  } else {
                                    return Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.none,
                                    );
                                  }
                                },
                              )
                            : Signature(
                                controller: _customerController,
                                backgroundColor: Colors.grey[200]!,
                                //height: 300.h, // 适配屏幕高度
                              ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // 底部的按钮
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                  Size(140.w, 35.h)),
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
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(
                                  Size(140.w, 35.h)),
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
                            onPressed: () async {
                              dynamic staffSignaturePath;
                              dynamic customerSignaturePath;
                              if (_staffController.isNotEmpty) {
                                staffSignaturePath =
                                    await _saveStaffSignature();
                              }

                              if (_customerController.isNotEmpty) {
                                customerSignaturePath =
                                    await _saveCustomerSignature();
                              }

                              // ignore: use_build_context_synchronously
                              Navigator.pop(context, {
                                'staffSignaturePath': staffSignaturePath ??
                                    widget.existingStaffSignaturePath,
                                'customerSignaturePath':
                                    customerSignaturePath ??
                                        widget.existingCustomerSignaturePath,
                              });
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
