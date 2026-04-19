// register_page.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:mayekawa/config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// 轻量的结果对象，代替原来的 AuthResult 类（内联写在本文件）
class _SignUpResult {
  final bool success;
  final String? message;
  final String? token;
  const _SignUpResult({required this.success, this.message, this.token});

  factory _SignUpResult.ok({String? token}) =>
      _SignUpResult(success: true, token: token);

  factory _SignUpResult.err(String msg) =>
      _SignUpResult(success: false, message: msg);
}

class _RegisterPageState extends State<RegisterPage> {
  OverlayEntry? _overlayEntry;

  final _formKey = GlobalKey<FormState>();

  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showNoMatchText = false;
  String _noMatchText = 'The two passwords do not match!';

  bool _obscurePwd = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validateId(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'User ID is required';
    return null;
  }

  String? _validateName(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'User Name is required';
    return null;
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    if (!ok) return 'Email address format is no correct';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // ==== 内联：原 auth_api.dart 的 signUp 功能 ====
  Future<_SignUpResult> _signUp({
    required String id,
    required String name,
    required String email,
    required String password,
  }) async {
    final uri =
        Uri.parse('${Config.apiBaseUrl}/register-account'); // 对应你的 Flask 路由
    try {
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
              {'id': id, 'name': name, 'email': email, 'password': password},
            ),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200 || res.statusCode == 201) {
        // 成功时后端可返回 token
        final body = jsonDecode(res.body);
        return _SignUpResult.ok(token: body['access_token'] as String?);
      }

      if (res.statusCode == 409) {
        setState(() {
          _noMatchText = 'The ID has been registered already!';
          _showNoMatchText = true;
        });
        return _SignUpResult.err('The ID has been registered already!');
      }

      if (res.statusCode == 410) {
        _noMatchText = 'The username has been registered already!';
        _showNoMatchText = true;
        return _SignUpResult.err('The username has been registered already!');
      }

      if (res.statusCode == 411) {
        _noMatchText = 'The mail address has been registered already!';
        _showNoMatchText = true;
        return _SignUpResult.err(
            'The mail address has been registered already!');
      }

      // 其它错误：尽量解析 message
      try {
        final body = jsonDecode(res.body);
        final msg = body['message']?.toString();
        return _SignUpResult.err(
            msg ?? 'Registeration failed! ${res.statusCode}');
      } catch (_) {
        return _SignUpResult.err('Registration failed! ${res.statusCode}');
      }
    } on TimeoutException {
      return _SignUpResult.err('Request timed out, please check the network!');
    } catch (e) {
      return _SignUpResult.err('Network error: $e');
    }
  }

  Future<void> _submit() async {
    setState(() {
      _showNoMatchText = false;
    });
    // 表单校验
    if (!_formKey.currentState!.validate()) return;

    if (_passwordCtrl.text != _confirmCtrl.text) {
      setState(() {
        _noMatchText = 'The two passwords do not match!';
        _showNoMatchText = true;
      });
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await _signUp(
      id: _idCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result.success) {
      // 注册成功：可选择直接返回登录页，或者携带 token 进入首页
      await _registrationResultDialog(
          context,
          'New account has been registered successfully, welcome, ${_nameCtrl.text.trim()}!',
          true);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text(
      //           'New account has been registered successfully, welcome, ${_nameCtrl.text.trim()}!')),
      // );

      // 方案A：返回登录页
      Navigator.pop(context, _idCtrl.text.trim());

      // 方案B：直达首页（如需的话）
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const IndexPage()),
      // );
    } else {
      await _registrationResultDialog(
          context, result.message ?? 'Registration failed!', false);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(result.message ?? 'Registration failed!')),
      // );
    }
  }

  //注册结果弹出框
  Future<void> _registrationResultDialog(
      BuildContext context, String message, bool ifSuccess) async {
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
              top: MediaQuery.of(context).size.height * 0.20,
              left: MediaQuery.of(context).size.width * 0.12,
              width: MediaQuery.of(context).size.width * 0.76,
              height: 300.h,
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
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: ifSuccess
                                ? Icon(
                                    Icons.account_circle,
                                    size: 50.w,
                                    color: Colors.blue,
                                  )
                                : Icon(
                                    Icons.no_accounts,
                                    size: 50.w,
                                    color: const Color(0xFFAD193C),
                                  ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 30.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ElevatedButton(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAD193D),
        iconTheme: const IconThemeData(
          color: Colors.white, // 左侧返回箭头改成白色
        ),
        title: const Text(
          'Register New Mayekawa Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(26.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 56.h),
                TextFormField(
                  controller: _idCtrl,
                  decoration: InputDecoration(
                    labelText: 'User ID (Unique Identifier)',
                    errorStyle: TextStyle(
                        fontSize: 7.sp,
                        color: const Color(0xFFAD193D)), // 改错误提示文字
                    floatingLabelStyle: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFF6750A4)),
                    labelStyle: TextStyle(
                        fontSize: 10.sp,
                        color: const Color.fromARGB(255, 42, 42, 42)),
                  ),
                  style: TextStyle(fontSize: 9.sp),
                  textInputAction: TextInputAction.next,
                  validator: _validateId,
                ),
                SizedBox(height: 22.h),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    errorStyle: TextStyle(
                        fontSize: 7.sp,
                        color: const Color(0xFFAD193D)), // 改错误提示文字
                    floatingLabelStyle: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFF6750A4)),
                    labelStyle: TextStyle(
                        fontSize: 10.sp,
                        color: const Color.fromARGB(255, 42, 42, 42)),
                  ),
                  style: TextStyle(fontSize: 9.sp),
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                SizedBox(height: 22.h),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    labelText: 'Mail Address',
                    errorStyle: TextStyle(
                        fontSize: 7.sp,
                        color: const Color(0xFFAD193D)), // 改错误提示文字
                    floatingLabelStyle: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFF6750A4)),
                    labelStyle: TextStyle(
                        fontSize: 10.sp,
                        color: const Color.fromARGB(255, 42, 42, 42)),
                  ),
                  style: TextStyle(fontSize: 9.sp),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                SizedBox(height: 22.h),
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorStyle: TextStyle(
                        fontSize: 7.sp,
                        color: const Color(0xFFAD193D)), // 改错误提示文字
                    floatingLabelStyle: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFF6750A4)),
                    labelStyle: TextStyle(
                        fontSize: 10.sp,
                        color: const Color.fromARGB(255, 42, 42, 42)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePwd
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscurePwd = !_obscurePwd),
                    ),
                  ),
                  style: TextStyle(fontSize: 9.sp),
                  obscureText: _obscurePwd,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                ),
                SizedBox(height: 22.h),
                TextFormField(
                  controller: _confirmCtrl,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorStyle: TextStyle(
                        fontSize: 7.sp,
                        color: const Color(0xFFAD193D)), // 改错误提示文字
                    floatingLabelStyle: TextStyle(
                        fontSize: 10.sp, color: const Color(0xFF6750A4)),
                    labelStyle: TextStyle(
                        fontSize: 10.sp,
                        color: const Color.fromARGB(255, 42, 42, 42)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  style: TextStyle(fontSize: 9.sp),
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _validatePassword,
                ),
                SizedBox(height: 10.h),
                _showNoMatchText
                    ? Text(
                        _noMatchText,
                        style: TextStyle(
                          fontSize: 7.sp,
                          color: const Color(0xFFAD193D),
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: 104.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFF82132D); // 按下颜色
                        }
                        return const Color(0xFFAD193C); // 默认颜色
                      }),
                      minimumSize:
                          WidgetStateProperty.all<Size>(Size(200.w, 50.h)),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                      ),
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Create Mayekawa Account',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text(
                    'Already have an account? Click here to log in',
                    style: TextStyle(
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
