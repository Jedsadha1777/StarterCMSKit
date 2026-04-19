import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mayekawa/user_provider.dart';
import 'package:mayekawa/utils/csv_import_helper.dart';
import 'package:provider/provider.dart';
import 'index_page.dart'; // 导入主页
import 'register_page.dart'; //导入注册页

import 'package:http/http.dart' as http;
import 'package:mayekawa/config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleLogin(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    const String apiUrl = "${Config.apiBaseUrl}/app-login";

    // const String apiUrl =
    //     "http://54.151.164.106/api/app-login"; //暂时借用另一个服务器，之后删除

    if (username.isEmpty || password.isEmpty) {
      _showDialog(context, 'Please enter both username and password');
      return;
    }

    _showLoadingDialog(context);

    try {
      final response = await http
          .post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'username': username, 'password': password}),
      )
          .timeout(const Duration(seconds: 8), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out. Please try again.');
      });

      Navigator.pop(context); // 关闭加载框
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);

          userProvider.setUserId(responseData['user_id']);
          userProvider.setUserName(responseData['user_name']);
          userProvider.setEmail(responseData['email']);

          await importCsvToDatabase();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IndexPage()),
          );
        } else {
          _showDialog(context, 'Invalid username or password');
        }
      } else {
        _showDialog(context, 'Login failed: ${responseData['message']}');
      }
    } on TimeoutException catch (_) {
      Navigator.pop(context);
      _showDialog(context,
          'Login request timed out. Please check your network and try again.');
    } catch (e) {
      Navigator.pop(context);
      _showDialog(context, 'Network error');
      print(e);
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
              padding: EdgeInsets.only(left: 10.w),
              width: double.infinity,
              height: 40.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Service Report Tool',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.h),
            Center(
              child: Text(
                'Please login...',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'User Name or User ID',
                      labelStyle: TextStyle(
                        fontSize: 11.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // 设置圆角
                        borderSide: const BorderSide(
                          color:
                              Color.fromARGB(255, 227, 227, 227), // 设置边框颜色为灰色
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // 设置圆角
                        borderSide: const BorderSide(
                          color:
                              Color.fromARGB(255, 227, 227, 227), // 设置边框颜色为灰色
                          width: 3.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // 设置圆角
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 81, 11, 27), // 当焦点在输入框时，边框颜色变为蓝色
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 10.w),
                    ),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 45.h),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 11.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // 设置圆角
                        borderSide: const BorderSide(
                          color:
                              Color.fromARGB(255, 227, 227, 227), // 设置边框颜色为灰色
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // 设置圆角
                        borderSide: const BorderSide(
                          color:
                              Color.fromARGB(255, 227, 227, 227), // 设置边框颜色为灰色
                          width: 3.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r), // 设置圆角
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 81, 11, 27), // 当焦点在输入框时，边框颜色变为蓝色
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 10.w),
                    ),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  ElevatedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const IndexPage()),
                      // );

                      await _handleLogin(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFF82132D); // 按下时的背景色
                        }
                        return const Color(0xFFAD193C); // 默认背景色
                      }),
                      minimumSize: WidgetStateProperty.all<Size>(
                        Size(200.w, 50.h),
                      ), // 设置按钮的宽和高
                      // backgroundColor: Color(0xFF213B92), // 设置按钮的背景颜色
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                      ), // 内边距
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r), // 设置按钮圆角
                        ),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                      if (result != null && result is String) {
                        setState(() {
                          usernameController.text = result;
                        });
                      } else {
                        setState(() {
                          usernameController.text = '';
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFF82132D); // 按下时的背景色
                        }
                        return const Color(0xFFAD193C); // 默认背景色
                      }),
                      minimumSize: WidgetStateProperty.all<Size>(
                        Size(200.w, 50.h),
                      ), // 设置按钮的宽和高
                      // backgroundColor: Color(0xFF213B92), // 设置按钮的背景颜色
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                      ), // 内边距
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r), // 设置按钮圆角
                        ),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 35.h),
            SizedBox(
              width: double.infinity,
              height: 20.h,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Ver.1.0.2 (Developed in 2025)',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
