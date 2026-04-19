import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:mayekawa/models/job_info.dart';
import 'package:mayekawa/pages/rc_2stage.dart';
import 'login_page.dart';
// import 'service_report.dart';
// import 'calibration_cert.dart';
// import 'delivery_order.dart';

import '../widgets/customer_code_search_widget.dart';

import 'sc_single.dart';
import 'sc_2stage.dart';
import 'rc_single.dart';

import 'past_reports.dart';
import 'saved_reports.dart';

import 'package:provider/provider.dart';
import 'package:mayekawa/user_provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  OverlayEntry? _overlayEntry; //定义悬浮提示框
  bool _hideHint = false;

  List<TextEditingController> controllers =
      List.generate(5, (index) => TextEditingController());

  final List<bool> _isValids = List.generate(5, (index) => true);

  late List<Map<String, dynamic>> loadedReports;

  late bool _ifNoDuplicated;
  late String _duplicatedNo;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _hideHint = false;
    final currentYear = DateTime.now().year.toString().substring(2);
    controllers[1].text = 'ZHR';
    controllers[3].text = currentYear;
    controllers[4].text = userProvider.userName!;

    _ifNoDuplicated = false;
    _duplicatedNo = '';

    loadedReports = [];
    _loadReportsFormHive();

    for (int i in [0, 2, 3, 4]) {
      controllers[i].addListener(() {
        setState(() {
          _isValids[i] = controllers[i].text.trim().isNotEmpty;
        });
      });
    }

    for (int i in [0, 1, 2, 3]) {
      controllers[i].addListener(() {
        final rawString = controllers[0].text +
            controllers[1].text +
            controllers[2].text +
            controllers[3].text;
        setState(() {
          _ifNoDuplicated = false;
          _duplicatedNo = '';
        });

        for (Map loadedReport in loadedReports) {
          if (loadedReport['key'] == rawString) {
            setState(() {
              _ifNoDuplicated = true;
              _duplicatedNo = loadedReport['job'];
            });
            break;
          }
        }
      });
    }

    controllers[4].addListener(() {
      userProvider.setUserName(controllers[4].text);
    });
  }

  Future<void> _loadReportsFormHive() async {
    final box = await Hive.openBox('reports');

    for (var key in box.keys) {
      final value = box.get(key);
      if (value is Map && value.containsKey('createDt')) {
        loadedReports.add({
          'key': key.toString(),
          'job': value['decoratedJobNo'], //cleanJobNo
        });
      }
    }
  }

  Future<void> _showDuplicatedTip() async {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        elevation: 24,
        title: Text(
          'Duplicated Job No. $_duplicatedNo Detected!',
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFAD193C),
          ),
        ),
        content: Text(
          '$_duplicatedNo has existed on this device! Please take one of the following options for the next step:\n\n----Use another Job No.\nor\n----Delete $_duplicatedNo from the Saved Reports page first.',
          style: TextStyle(
            fontSize: 8.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 关闭对话框
            },
            child: Text(
              'Close',
              style: TextStyle(fontSize: 8.sp),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      for (int i in [0, 2, 3, 4]) {
        if (controllers[i].text.trim().isEmpty) {
          _isValids[i] = false;
          isValid = false;
        } else {
          _isValids[i] = true;
        }
      }
    });

    if (!isValid) {
      _showAutoDismissDialog();
    }

    return isValid;
  }

//输入不完整对话框
  Future<void> _showAutoDismissDialog() async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    // 创建 OverlayEntry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.37,
          left: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.5,
          height: 70.h,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(top: 13.h, left: 3.w, right: 3.w),
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
                  Text(
                    "Warning:",
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "There are some items that have not been filled in!",
                    style: TextStyle(
                      fontSize: 7.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // 显示 Overlay
    Overlay.of(context).insert(_overlayEntry!);

    // 3秒后移除 Overlay
    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  //向全局变量录入job no.
  void _setGlobalJobNo() {
    JobInfo().jobNo =
        '${controllers[0].text.trim()}/${controllers[1].text}${controllers[2].text.trim()}/${controllers[3].text.trim()}';
    JobInfo().endUserCode = controllers[0].text.trim();
  }

  @override
  void dispose() {
    for (int i = 0; i < 5; i++) {
      controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Image.asset(
                    'assets/mayekawa_logo.png',
                    width: 150.w,
                  ),
                ),
                SizedBox(height: 20.h),
                //Banner部分
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
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r), // 圆角
                              side:
                                  const BorderSide(color: Colors.white), // 白色边框
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
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
                SizedBox(height: 25.h),
                // <Job No.> 文本
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 35.w,
                  ),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Job No.',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      _ifNoDuplicated
                          ? Text(
                              '$_duplicatedNo has existed on this device! Please change another Job No.!',
                              style: TextStyle(
                                fontSize: 6.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //1.曖昧検索
                    Container(
                      width: 60.w,
                      height: 34.h,
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: CustomerCodeSearchWidget(
                        controller: controllers[0],
                        hideHint: _hideHint,
                        color: _isValids[0]
                            ? Colors.white
                            : const Color.fromARGB(255, 219, 159, 155),
                      ),
                    ),
                    SizedBox(width: 10.w),

                    //2.下拉框
                    Container(
                      width: 80.w,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(5.w),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controllers[1].text.isNotEmpty
                              ? controllers[1].text
                              : null,
                          isExpanded: true,
                          alignment: Alignment.center,
                          dropdownColor: Colors.white,
                          elevation: 24, //最终下拉菜单阴影
                          items: [
                            'ZHR',
                            'ZHS',
                            'ZHRT',
                            'ZHST',
                            'VHR',
                            'VHS',
                            'VHRT',
                            'VHST'
                          ]
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  alignment: Alignment.center,
                                  child: Text(
                                    e,
                                    textAlign: TextAlign.center,
                                  )))
                              .toList(),
                          onChanged: (val) {
                            setState(() => controllers[1].text = val!);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),

                    //3.普通输入框
                    Container(
                      width: 80.w,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: _isValids[2]
                            ? Colors.white
                            : const Color.fromARGB(255, 219, 159, 155),
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: TextField(
                        controller: controllers[2],
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // 4. 普通输入框
                    Container(
                      width: 60.w,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                          color: _isValids[3]
                              ? Colors.white
                              : const Color.fromARGB(255, 219, 159, 155),
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(5.w)),
                      child: TextField(
                        controller: controllers[3],
                        textAlign: TextAlign.center,
                        enabled: true,
                        style: const TextStyle(color: Colors.black),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 35.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Staff Name',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //姓名输入框
                      Container(
                        width: 170.w,
                        height: 34.h,
                        margin: EdgeInsets.only(left: 13.w, right: 10.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 0.h),
                        decoration: BoxDecoration(
                            color: _isValids[4]
                                ? Colors.white
                                : const Color.fromARGB(255, 219, 159, 155),
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(5.w)),
                        child: TextField(
                          controller: controllers[4],
                          textAlign: TextAlign.start,
                          enabled: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8.sp,
                          ),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),
                //按钮部分
                Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 上半部分：4 个红按钮（2x2）
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildRedButton('Overhaul Report\nSC Single',
                            onPressed: () {
                          if (_ifNoDuplicated) {
                            _showDuplicatedTip();
                            return;
                          }

                          if (_validateInputs()) {
                            _setGlobalJobNo();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScSingle()),
                            );
                          }
                        }),
                        _buildRedButton('Overhaul Report\nSC 2 Stage',
                            onPressed: () {
                          if (_ifNoDuplicated) {
                            _showDuplicatedTip();
                            return;
                          }

                          if (_validateInputs()) {
                            _setGlobalJobNo();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sc2stage()),
                            );
                          }
                        }),
                        _buildRedButton('Overhaul Report\nRC Single',
                            onPressed: () {
                          if (_ifNoDuplicated) {
                            _showDuplicatedTip();
                            return;
                          }

                          if (_validateInputs()) {
                            _setGlobalJobNo();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RcSingle()),
                            );
                          }
                        }),
                        _buildRedButton('Overhaul Report\nRC 2 Stage',
                            onPressed: () {
                          if (_ifNoDuplicated) {
                            _showDuplicatedTip();
                            return;
                          }

                          if (_validateInputs()) {
                            _setGlobalJobNo();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Rc2stage()),
                            );
                          }
                        }),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // 下半部分：2个浅红按钮
                    _buildLightRedButton('Viewing Past Reports', onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PastReports()),
                      );
                    }),
                    SizedBox(height: 12.h),
                    _buildLightRedButton('Saved Reports', onPressed: () async {
                      List<Map<String, dynamic>> res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SavedReports()));

                      setState(() {
                        loadedReports = [];
                        for (Map each in res) {
                          loadedReports.add({
                            'key': each['key'],
                            'job': each['job'],
                          }); //cleanJobNo)
                        }
                      });

                      for (int i in [0, 1, 2, 3]) {
                        //故意触发0号到4号控制器的监听函数
                        String str = controllers[i].text;
                        controllers[i].text = 'temp';
                        controllers[i].text = str;
                      }
                    }),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRedButton(String text, {required VoidCallback onPressed}) {
    return SizedBox(
      width: 160.w,
      height: 60.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFAD193C), // 深红色
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildLightRedButton(String text, {required VoidCallback onPressed}) {
    return SizedBox(
      width: 200.w,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDF737F), // 浅红色
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
