import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login_page.dart';
import 'report_page.dart';

class RcSingleFreon extends StatelessWidget {
  const RcSingleFreon({super.key});

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
            SizedBox(height: 30.h),
            Center(
              child: Column(
                children: [
                  //Label文字（禁用按钮）
                  SizedBox(
                    width: 250.w,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAD193C),
                        disabledBackgroundColor: const Color(0xFFAD193C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: Text(
                        'Overhaul Report RC Single',
                        style: TextStyle(fontSize: 13.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: 90.w,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAD193C),
                        disabledBackgroundColor: const Color(0xFFAD193C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: Text(
                        'Freon',
                        style: TextStyle(fontSize: 13.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  //中间按钮网格
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildOutLineButton('A,WA', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReportPage(model_id: 32)),
                        );
                      }),
                      _buildOutLineButton('M,MII,MIIL', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReportPage(model_id: 35)),
                        );
                      }),
                      _buildOutLineButton('B,WB', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReportPage(model_id: 33)),
                        );
                      }),
                      _buildOutLineButton('K,KII', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReportPage(model_id: 37)),
                        );
                      }),
                      _buildOutLineButton('WBH,WBHE', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReportPage(model_id: 34)),
                        );
                      }),
                      _buildOutLineButton('L,LII', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReportPage(model_id: 38)),
                        );
                      }),
                      SizedBox(width: 150.w, height: 40.h),
                    ],
                  ),
                  SizedBox(height: 40.h),

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

  Widget _buildOutLineButton(String text, {required VoidCallback onPressed}) {
    return SizedBox(
      width: 150.w,
      height: 40.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFAD193C), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          foregroundColor: const Color(0xFFAD193C),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }
}
