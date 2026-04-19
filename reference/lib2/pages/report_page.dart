import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:mayekawa/pages/index_page.dart';
import 'package:mayekawa/utils/database_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;
import 'package:mayekawa/config.dart';

import 'job_sign.dart';
import 'report_pdf.dart';

import 'package:mayekawa/models/job_info.dart';

import 'package:flutter/services.dart' as sv;

import '../widgets/customer_search_widget.dart';
import '../widgets/model_search_report_page.dart';

class ReportPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int model_id;

  final String? jobKey; //可空类型

  final bool downloadOnly;  

  const ReportPage({super.key, required this.model_id, this.jobKey, this.downloadOnly = false});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  OverlayEntry? _overlayEntry; //定义悬浮提示框
  Timer? _warningTimer;

  late bool ifThisPageSaved;

  late String currentJobNo;
  late String cleanJobNo;

  late String endUserCode;

  late List<TextEditingController> controllers;
  late List<bool> _isValids;
  late bool _isValidQty;
  late bool _isValidOther;
  late List<bool> _isValidSigns;

  late List<TextEditingController> partsNoControllers; //  ADDED
  late List<TextEditingController> partsCodeControllers; //  ADDED
  late List<TextEditingController> partsNameControllers; //  ADDED
  late List<TextEditingController> qtyControllers;
  late List<FocusNode> qtyFocusNodes;

  late List<String> _controllerVals;
  late List<String> _partsNoControllerVals;
  late List<String> _partsCodeControllerVals;
  late List<String> _partsNameControllerVals;
  late List<String> _qtyControllerVals;

  late List<bool> _ifChangeControllers;
  late List<bool> _ifChangePartsNoControllers;
  late List<bool> _ifChangePartsCodeControllers;
  late List<bool> _ifChangePartsNameControllers;
  late List<bool> _ifChangeQtyControllers;

  late List<bool> applicationValues;
  late List<bool> oldAppicationValues;

  final GlobalKey _captureKey = GlobalKey();
  final GlobalKey _captureKey2 = GlobalKey();

  final List<String> labels = [
    'COLD STORAGE (FROZEN)',
    'COLD STORAGE (CHILLED)',
    'LOADING AREA',
    'AIR CONDITION',
    'FREEZER (BELT)',
    'AIR BLAST',
    'CHILLER (WATER, BRINE)',
    'ICE MAKING',
    'OTHER',
  ];

  List<Map<String, dynamic>?> leftData = [];
  List<Map<String, dynamic>?> rightData = [];
  List<Map<String, dynamic>> rawPartsData = [];

  String? _staffSignaturePath;
  String? _customerSignaturePath;


  late double bottomSpacerHeight = 100.h;
  String hintText = 'Please input...';
  String dtHintText = 'Click to select...';
  bool showUploadBtns = true;
  bool showClearButton = true;

  XFile? photo1;
  XFile? photo2;
  final ImagePicker _picker = ImagePicker();

  late bool photo1Changed;
  late bool photo2Changed;

  late bool sign1Changed;
  late bool sign2Changed;

  bool isLoading = true; //加载状态
  bool _downloadTriggered = false;


  late Box box;

  late String lastValidHrs;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<int> mandatoriesControllerNos = [
    0,
    2,
    3,
    4,
    //5,
    6,
    7,
    8,
    9,
    10,
    //11,
    12,
    16,
  ];

  bool applicationChecked = true;

  bool isPageModified = false;

  @override
  void initState() {
    super.initState();

    ifThisPageSaved = false;

    if (widget.jobKey != null) {
      currentJobNo = widget.jobKey!;
    } else {
      currentJobNo = JobInfo().jobNo;
      endUserCode = JobInfo().endUserCode;
    }

    _resetSignatures();
    cleanJobNo = currentJobNo.replaceAll('/', '');

    controllers = List.generate(17, (_) => TextEditingController());
    _controllerVals = List.generate(17, (_) => '');
    _ifChangeControllers = List.generate(17, (_) => false);

    _isValids = List.generate(17, (_) => true);
    _isValidQty = true;
    _isValidOther = true;
    _isValidSigns = [true, true];

    partsNoControllers =
        List.generate(80, (_) => TextEditingController()); //  ADDED
    partsCodeControllers =
        List.generate(80, (_) => TextEditingController()); //  ADDED
    partsNameControllers =
        List.generate(80, (_) => TextEditingController()); //  ADDED
    qtyControllers = List.generate(80, (_) => TextEditingController());
    qtyFocusNodes = List.generate(80, (_) => FocusNode());

    _partsNoControllerVals = List.generate(80, (_) => '');
    _partsCodeControllerVals = List.generate(80, (_) => '');
    _partsNameControllerVals = List.generate(80, (_) => '');
    _qtyControllerVals = List.generate(80, (_) => '');

    _ifChangePartsNoControllers = List.generate(80, (_) => false);
    _ifChangePartsCodeControllers = List.generate(80, (_) => false);
    _ifChangePartsNameControllers = List.generate(80, (_) => false);
    _ifChangeQtyControllers = List.generate(80, (_) => false);

    for (int i = 0; i < 17; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text != _controllerVals[i]) {
          setState(() {
            _ifChangeControllers[i] = true;
          });
        } else {
          setState(() {
            _ifChangeControllers[i] = false;
          });
        }
      });
    }

    for (int i = 0; i < 80; i++) {
      partsNoControllers[i].addListener(() {
        if (partsNoControllers[i].text != _partsNoControllerVals[i]) {
          setState(() {
            _ifChangePartsNoControllers[i] = true;
          });
        } else {
          setState(() {
            _ifChangePartsNoControllers[i] = false;
          });
        }
      });

      partsCodeControllers[i].addListener(() {
        if (partsCodeControllers[i].text != _partsCodeControllerVals[i]) {
          setState(() {
            _ifChangePartsCodeControllers[i] = true;
          });
        } else {
          setState(() {
            _ifChangePartsCodeControllers[i] = false;
          });
        }
      });

      partsNameControllers[i].addListener(() {
        if (partsNameControllers[i].text != _partsNameControllerVals[i]) {
          setState(() {
            _ifChangePartsNameControllers[i] = true;
          });
        } else {
          setState(() {
            _ifChangePartsNameControllers[i] = false;
          });
        }
      });

      qtyControllers[i].addListener(() {
        if (qtyControllers[i].text != _qtyControllerVals[i]) {
          setState(() {
            _ifChangeQtyControllers[i] = true;
          });
        } else {
          setState(() {
            _ifChangeQtyControllers[i] = false;
          });
        }
      });
    }

    for (int i = 0; i < qtyFocusNodes.length; i++) {
      qtyFocusNodes[i].addListener(() {
        if (!qtyFocusNodes[i].hasFocus) {
          final text = qtyControllers[i].text;
          final parsed = int.tryParse(text);
          qtyControllers[i].text = parsed?.toString() ?? '';
        }
      });
    }
    applicationValues = List.generate(9, (index) => false);
    oldAppicationValues = List.generate(9, (index) => false);

    photo1Changed = false;
    photo2Changed = false;

    sign1Changed = false;
    sign2Changed = false;

    lastValidHrs = controllers[10].text;
    controllers[10].addListener(_hoursInputListener);

    for (int i in mandatoriesControllerNos) {
      controllers[i].addListener(() {
        setState(() {
          _isValids[i] = controllers[i].text.trim().isNotEmpty;
        });
      });
    }

    controllers[13].addListener(() {
      if (applicationValues[8] == true) {
        if (controllers[13].text.trim().isNotEmpty) {
          setState(() {
            _isValidOther = true;
          });
        } else {
          setState(() {
            _isValidOther = false;
          });
        }
      } else {
        _isValidOther = true;
      }
    });

    _checkNetworkTimeout();

    _fetchPartsData();

    _initializeHive();
  }

  void _hoursInputListener() {
    final current = controllers[10].text;
    final isValid = RegExp(r'^(0|[1-9][0-9]*)(\.[0-9]*)?$').hasMatch(current) ||
        current.isEmpty;

    if (isValid) {
      lastValidHrs = current;
    } else {
      controllers[10].value = TextEditingValue(
        text: lastValidHrs,
        selection: TextSelection.collapsed(offset: lastValidHrs.length),
      );
    }
  }

  

  //检查必须输入框是否为空
  bool _checkInputStatus() {
    bool allValid = true;

    for (int i in mandatoriesControllerNos) {
      final isValid = controllers[i].text.trim().isNotEmpty;
      setState(() {
        _isValids[i] = isValid;
      });

      if (!isValid) {
        allValid = false;
      }
    }
    // setState(() {
    //   final List<TextEditingController> cutQtyControllers =
    //       qtyControllers.sublist(0, rawPartsData.length);
    //   _isValidQty = cutQtyControllers
    //       .any((controller) => controller.text.trim().isNotEmpty);
    // });

    if (!_isValidQty) {
      allValid = false;
    }

    setState(() {
      applicationChecked = applicationValues.any((e) => e);
    });

    if (!applicationChecked) {
      allValid = false;
    }

    if (applicationValues[8] == true) {
      if (controllers[13].text.trim().isNotEmpty) {
        setState(() {
          _isValidOther = true;
        });
      } else {
        setState(() {
          _isValidOther = false;
        });
      }
    } else {
      _isValidOther = true;
    }

    if (!_isValidOther) {
      allValid = false;
    }

    return allValid;
  }

  bool compareCheckboxVals(List<bool> oldVals, List<bool> newVals) {
    if (identical(oldVals, newVals)) return true;
    if (oldVals.length != newVals.length) return false;
    for (int i = 0; i < oldVals.length; i++) {
      if (oldVals[i] != newVals[i]) return false;
    }
    return true;
  }

  List<String> _checkIsPageModified() {
    bool isControllerModified = _ifChangeControllers.any((e) => e);
    bool isPartsNoModified = _ifChangePartsNoControllers.any((e) => e);
    bool isPartsCodeModified = _ifChangePartsCodeControllers.any((e) => e);
    bool isPartsNameModified = _ifChangePartsNameControllers.any((e) => e);
    bool isQtyModified = _ifChangeQtyControllers.any((e) => e);

    bool isCheckboxModified =
        !compareCheckboxVals(oldAppicationValues, applicationValues);

    bool isPhotoModified = photo1Changed || photo2Changed;
    bool isSignModified = sign1Changed || sign2Changed;

    return [
      isControllerModified ? '\n----Basic information changed' : '',
      isPartsNoModified ? '\n----Parts # changed' : '',
      isPartsCodeModified ? '\n----Parts code changed' : '',
      isPartsNameModified ? '\n----Parts name changed' : '',
      isQtyModified ? '\n----Parts qty changed' : '',
      isCheckboxModified ? '\n----Application checkbox-status changed' : '',
      isPhotoModified ? '\n----At least one photo has been replaced' : '',
      isSignModified ? '\n----Staff or customer signature changed' : '',
    ];
  }

  //退出前对话框 Dialog box
  Future<int> _backConfirm(List<String> changedInfoList) async {
    String changedInfoString = '';
    for (String each in changedInfoList) {
      changedInfoString += each;
    }

    int? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        elevation: 24,
        title: Text(
          'Tip message:',
          style: TextStyle(fontSize: 9.5.sp),
        ),
        content: Text(
          'The report has been modified with the content below:\n$changedInfoString\n\nSave changes as report "${currentJobNo}" to the Saved Report list before leaving?',
          style: TextStyle(fontSize: 8.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(1); // 关闭对话框
            },
            child: Text(
              'Save and go back to the Top Page',
              style: TextStyle(fontSize: 8.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(2); // 关闭对话框
            },
            child: Text(
              'Back without saving',
              style: TextStyle(fontSize: 8.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(3); // 关闭对话框
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 8.sp),
            ),
          ),
        ],
      ),
    );

    return result ?? 3;
  }

  //检查是否签名
  Future<List<bool>> _checkSignStatus() async {
    final completer1 = Completer<bool>();
    final completer2 = Completer<bool>();

    if (_staffSignaturePath == null || _staffSignaturePath!.isEmpty) {
      setState(() {
        _isValidSigns[0] = false;
      });
    } else {
      final staffSignImage = Image.file(File(_staffSignaturePath!));

      final ImageStream stream1 =
          staffSignImage.image.resolve(const ImageConfiguration());
      final listener1 =
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
        completer1.complete(true);
      }, onError: (dynamic exception, StackTrace) {
        completer1.complete(false);
      });

      stream1.addListener(listener1);
      bool isOk1 = await completer1.future;
      setState(() {
        _isValidSigns[0] = isOk1;
      });

      stream1.removeListener(listener1);
    }

    if (_customerSignaturePath == null || _customerSignaturePath!.isEmpty) {
      setState(() {
        _isValidSigns[1] = false;
      });
    } else {
      final customerSignImage = Image.file(File(_customerSignaturePath!));

      final ImageStream stream2 =
          customerSignImage.image.resolve(const ImageConfiguration());
      final listener2 =
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
        completer2.complete(true);
      }, onError: (dynamic exception, StackTrace) {
        completer2.complete(false);
      });

      stream2.addListener(listener2);
      bool isOk2 = await completer2.future;
      setState(() {
        _isValidSigns[1] = isOk2;
      });

      stream2.removeListener(listener2);
    }

    return _isValidSigns;
  }

  //输入不完整对话框
  Future<void> _showIncompletedDialog(
      {String textContents =
          "There are some items that have not been filled in!"}) async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    //如果已有定时器，则取消重新计时
    _warningTimer?.cancel();

    // 创建 OverlayEntry
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.37,
          left: MediaQuery.of(context).size.width * 0.15,
          width: MediaQuery.of(context).size.width * 0.7,
          height: 100.h,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(top: 13.h, left: 6.w, right: 6.w),
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
                  SizedBox(height: 10.h),
                  Text(
                    textContents,
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
    _warningTimer = Timer(const Duration(milliseconds: 2500), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _warningTimer = null;
    });

    // Future.delayed(const Duration(seconds: 3), () {
    //   _overlayEntry?.remove();
    //   _overlayEntry = null;
    // });
  }

  // 重置签名方法
  void _resetSignatures() {
    setState(() {
      _staffSignaturePath = null;
      _customerSignaturePath = null;
    });
  }

  Future<void> _initializeHive() async {
    box = await Hive.openBox('reports');

    if (widget.jobKey != null) {
      _loadData();
    } else {
      //controllers[0].text = endUserCode;
      final customerQueryResult = await _getCustomerByCode(endUserCode);
      _controllerVals[1] = endUserCode;
      controllers[1].text = endUserCode;
      if (customerQueryResult != null) {
        _controllerVals[0] = customerQueryResult['name'];
        _controllerVals[2] = customerQueryResult['address'];
        controllers[0].text = customerQueryResult['name'];
        controllers[2].text = customerQueryResult['address'];
      }
    }
  }

  //Load data from Hive
  void _loadData() {
    if (box.containsKey(cleanJobNo)) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(box.get(cleanJobNo));

      // 1. 恢复 controllers 的文本
      List<String> controllerTexts = List<String>.from(data['controllerTexts']);
      for (int i = 0;
          i < controllers.length && i < controllerTexts.length;
          i++) {
        _controllerVals[i] = controllerTexts[i];
        controllers[i].text = controllerTexts[i];
      }

      // 2. 重建 leftData 和 rightData，绑定已有 qtyControllers[i]
      List<dynamic> rawLeft = List<dynamic>.from(data['leftData']);
      List<dynamic> rawRight = List<dynamic>.from(data['rightData']);

      List<Map<String, dynamic>?> newLeft = [];
      List<Map<String, dynamic>?> newRight = [];

      for (int i = 0; i < 40; i++) {
        final item = i < rawLeft.length ? rawLeft[i] : null;
        if (item == null) {
          newLeft.add(null);
        } else {
          final map = Map<String, dynamic>.from(item);

          _qtyControllerVals[i] = map['qtyControllerText'] ?? '';
          _partsNoControllerVals[i] = map['partsNoControllerText'] ?? '';
          _partsCodeControllerVals[i] = map['partsCodeControllerText'] ?? '';
          _partsNameControllerVals[i] = map['partsNameControllerText'] ?? '';

          qtyControllers[i].text = map['qtyControllerText'] ?? '';
          partsNoControllers[i].text = map['partsNoControllerText'] ?? '';
          partsCodeControllers[i].text = map['partsCodeControllerText'] ?? '';
          partsNameControllers[i].text = map['partsNameControllerText'] ?? '';

          map['qtyController'] = qtyControllers[i];
          map['parts_no_controller'] = partsNoControllers[i];
          map['parts_code_controller'] = partsCodeControllers[i];
          map['parts_name_controller'] = partsNameControllers[i];
          newLeft.add(map);
        }
      }

      for (int i = 0; i < 40; i++) {
        final item = i < rawRight.length ? rawRight[i] : null;
        if (item == null) {
          newRight.add(null);
        } else {
          final map = Map<String, dynamic>.from(item);

          _qtyControllerVals[i + 40] = map['qtyControllerText'] ?? '';
          _partsNoControllerVals[i + 40] = map['partsNoControllerText'] ?? '';
          _partsCodeControllerVals[i + 40] =
              map['partsCodeControllerText'] ?? '';
          _partsNameControllerVals[i + 40] =
              map['partsNameControllerText'] ?? '';

          qtyControllers[i + 40].text = map['qtyControllerText'] ?? '';
          partsNoControllers[i + 40].text = map['partsNoControllerText'] ?? '';
          partsCodeControllers[i + 40].text =
              map['partsCodeControllerText'] ?? '';
          partsNameControllers[i + 40].text =
              map['partsNameControllerText'] ?? '';

          map['qtyController'] = qtyControllers[i + 40];
          map['parts_no_controller'] = partsNoControllers[i + 40];
          map['parts_code_controller'] = partsCodeControllers[i + 40];
          map['parts_name_controller'] = partsNameControllers[i + 40];
          newRight.add(map);
        }
      }

      leftData = newLeft;
      rightData = newRight;

      // 3. 恢复图片路径和签名路径
      _staffSignaturePath = data['staffSignaturePath'];
      _customerSignaturePath = data['customerSignaturePath'];

      if (data['photoPath1'] != null) {
        photo1 = XFile(data['photoPath1']);
      }
      if (data['photoPath2'] != null) {
        photo2 = XFile(data['photoPath2']);
      }

      // 4. 恢复 applicationValues 状态
      if (data.containsKey('applicationValues')) {
        List<dynamic> savedAppValues = data['applicationValues'];
        for (int i = 0;
            i < applicationValues.length && i < savedAppValues.length;
            i++) {
          oldAppicationValues[i] = savedAppValues[i] == true;
          applicationValues[i] = savedAppValues[i] == true;
        }
      }

      setState(() {});
    }
  }

  //Save data from Hive
  Future<Map<String, dynamic>> _saveData() async {
    String createDt = DateTime.now()
        .toLocal()
        .toString()
        .split(' ')[0]
        .split('-')
        .reversed
        .join('-');

    String? photoPath1;
    String? photoPath2;

    if (photo1 != null) {
      photoPath1 = await saveImageLocally(photo1!, '1');
    } else {
      photoPath1 = null;
    }

    if (photo2 != null) {
      photoPath2 = await saveImageLocally(photo2!, '2');
    } else {
      photoPath2 = null;
    }

    List<String> controllerTexts =
        controllers.map((controller) => controller.text).toList();

    Map<String, dynamic> data = {
      "controllerTexts": controllerTexts,
      "leftData": leftData.map((item) {
        if (item == null) return null;
        final newItem = Map<String, dynamic>.from(item);
        newItem['qtyControllerText'] = newItem['qtyController'].text;
        newItem.remove('qtyController'); //去除控制器本身避免hive报错
        newItem['partsNoControllerText'] = newItem['parts_no_controller'].text;
        newItem.remove('parts_no_controller');
        newItem['partsCodeControllerText'] =
            newItem['parts_code_controller'].text;
        newItem.remove('parts_code_controller');
        newItem['partsNameControllerText'] =
            newItem['parts_name_controller'].text;
        newItem.remove('parts_name_controller');
        return newItem;
      }).toList(),
      "rightData": rightData.map((item) {
        if (item == null) return null;
        final newItem = Map<String, dynamic>.from(item);
        newItem['qtyControllerText'] = newItem['qtyController'].text;
        newItem.remove('qtyController');
        newItem['partsNoControllerText'] = newItem['parts_no_controller'].text;
        newItem.remove('parts_no_controller');
        newItem['partsCodeControllerText'] =
            newItem['parts_code_controller'].text;
        newItem.remove('parts_code_controller');
        newItem['partsNameControllerText'] =
            newItem['parts_name_controller'].text;
        newItem.remove('parts_name_controller');
        return newItem;
      }).toList(),
      "applicationValues": applicationValues,
      "photoPath1": photoPath1,
      "photoPath2": photoPath2,
      "staffSignaturePath": _staffSignaturePath,
      "customerSignaturePath": _customerSignaturePath,
      "model_id": widget.model_id,
      "createDt": createDt,
      "timestamp": DateTime.now().microsecondsSinceEpoch,
      "cleanJobNo": cleanJobNo,
      "decoratedJobNo": currentJobNo,
    };

    await box.put(cleanJobNo, data);

    for (int i = 0; i < controllers.length; i++) {
      _controllerVals[i] = controllers[i].text;
      final currentVal = controllers[i].text;
      controllers[i].text = 'temp';
      controllers[i].text = currentVal;
    }

    for (int i = 0; i < 80; i++) {
      _partsNoControllerVals[i] = partsNoControllers[i].text;
      _partsCodeControllerVals[i] = partsCodeControllers[i].text;
      _partsNameControllerVals[i] = partsNameControllers[i].text;
      _qtyControllerVals[i] = qtyControllers[i].text;

      //下面的意思是，以上给参考变量赋值成功后，手动触发每一个控制器的每一个监听函数，以更新每个控制器是否有变动的布尔列表
      final currentNoVal = partsNoControllers[i].text;
      partsNoControllers[i].text = 'temp';
      partsNoControllers[i].text = currentNoVal;

      final currentCodeVal = partsCodeControllers[i].text;
      partsCodeControllers[i].text = 'temp';
      partsCodeControllers[i].text = currentCodeVal;

      final currentNameVal = partsNameControllers[i].text;
      partsNameControllers[i].text = 'temp';
      partsNameControllers[i].text = currentNameVal;

      final currentQtyVal = qtyControllers[i].text;

      qtyControllers[i].text =
          'middle_temp'; //由于qtyControllers加过node监听器，因此必须加入中间赋值，才能保证触发控制器监听函数
      qtyControllers[i].text = currentQtyVal;
    }

    oldAppicationValues = List.from(applicationValues); //深拷贝

    photo1Changed = false;
    photo2Changed = false;

    sign1Changed = false;
    sign2Changed = false;

    ifThisPageSaved = true;

    return data;
  }

  Future<String?> saveImageLocally(XFile xfile, String mode) async {
    final sourceFile = File(xfile.path);

    if (!(await sourceFile.exists())) {
      return null;
    }

    final dir = await getApplicationSupportDirectory();
    final targetPath = '${dir.path}/${cleanJobNo}_$mode.jpg';
    try {
      await xfile.saveTo(targetPath);
      return targetPath;
    } catch (e) {
      return null;
    }
  }

  Future<void> _fetchPartsData() async {
    String apiUrl = "${Config.apiBaseUrl}/get-replacement-parts";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'model_id': widget.model_id}),
      );

      if (response.statusCode == 200) {
        //解析返回的json数据
        final List<dynamic> jsonList = jsonDecode(response.body);

        rawPartsData =
            jsonList.asMap().entries.take(80).map<Map<String, dynamic>>(
          (entry) {
            int i = entry.key;
            var item = entry.value;

            _partsNoControllerVals[i] = item['parts_no'] ?? '';
            _partsCodeControllerVals[i] = item['parts_code'] ?? '';
            _partsNameControllerVals[i] = item['parts_name'] ?? '';

            partsNoControllers[i].text = item['parts_no'] ?? '';
            partsCodeControllers[i].text = item['parts_code'] ?? '';
            partsNameControllers[i].text = item['parts_name'] ?? '';

            return {
              'index': (i + 1).toString(),
              'parts_no': item['parts_no'],
              'parts_code': item['parts_code'],
              'parts_name': item['parts_name'],
              'qtyController': qtyControllers[i],
              'parts_no_controller': partsNoControllers[i],
              'parts_code_controller': partsCodeControllers[i],
              'parts_name_controller': partsNameControllers[i],
            };
          },
        ).toList();

        //补全80行
        final List<Map<String, dynamic>?> fullPartsData =
            List<Map<String, dynamic>?>.from(rawPartsData);

        var starter = fullPartsData.length - 1;
        while (fullPartsData.length < 80) {
          starter += 1;
          fullPartsData.add({
            'index': (starter).toString(),
            'qtyController': qtyControllers[starter],
            'parts_no_controller': partsNoControllers[starter],
            'parts_code_controller': partsCodeControllers[starter],
            'parts_name_controller': partsNameControllers[starter],
          });
        }

        //切分
        setState(() {
          leftData = fullPartsData.sublist(0, 40);
          rightData = fullPartsData.sublist(40, 80);
          isLoading = false;
        });

        if (widget.downloadOnly && !_downloadTriggered) {
          _downloadTriggered = true;
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (mounted) _downloadPdfOnly();
          });
        }
       
      } else {
        //请求失败
        debugPrint('Request failed, statusCode: ${response.statusCode}');
        setState(() {
          isLoading = false;
          _showNetworkErrorDialog();
        });
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }

    //注意：这里嵌入了给数量控制器加监听函数的代码
    // for (int i = 0; i < rawPartsData.length; i++) {
    //   qtyControllers[i].addListener(() {
    //     bool anyNotEmpty = qtyControllers
    //         .sublist(0, rawPartsData.length)
    //         .any((controller) => controller.text.trim().isNotEmpty);

    //     setState(() {
    //       _isValidQty = anyNotEmpty;
    //     });
    //   });
    // }
  }

  //检查网络超时
  void _checkNetworkTimeout() async {
    await Future.delayed(const Duration(seconds: 6));
    if (isLoading) {
      //如果数据还没有加载，弹出报错对话框
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

  //保存时对话框
  Future<void> _showSavingDialog() async {
    // 如果已有 OverlayEntry，先移除
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
                    "Status:",
                    style: TextStyle(
                      fontSize: 8.sp,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Changes saved!",
                    style: TextStyle(
                      fontSize: 7.sp,
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

  // 导航到签字页面并接收返回结果
  Future<void> _navigateToSignaturePage(jobNo) async {
    String? previousStaffPath = _staffSignaturePath;
    String? previousCustomerPath = _customerSignaturePath;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => JobSign(
                jobNumber: jobNo,
                existingStaffSignaturePath: _staffSignaturePath,
                existingCustomerSignaturePath: _customerSignaturePath,
              )),
    );
    if (result != null) {
      setState(() {
        _staffSignaturePath = result['staffSignaturePath'];
        _customerSignaturePath = result['customerSignaturePath'];
      });
    }

    if (_staffSignaturePath == previousStaffPath) {
      sign1Changed = false;
    } else {
      sign1Changed = true;
    }
    if (_customerSignaturePath == previousCustomerPath) {
      sign2Changed = false;
    } else {
      sign2Changed = true;
    }
  }

  //pdf Capture 2 pages
  Future<Map<String, dynamic>> _captureWidgetAsImage() async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 500));

    // Capture page 1
    RenderRepaintBoundary boundary1 =
        _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image1 = await boundary1.toImage(pixelRatio: 3.0);
    ByteData? byteData1 =
        await image1.toByteData(format: ui.ImageByteFormat.png);

    // Capture page 2
    RenderRepaintBoundary boundary2 = _captureKey2.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image2 = await boundary2.toImage(pixelRatio: 3.0);
    ByteData? byteData2 =
        await image2.toByteData(format: ui.ImageByteFormat.png);

    return {
      "byte1": byteData1!.buffer.asUint8List(),
      "byte2": byteData2!.buffer.asUint8List(),
    };
  }

  //pdf转换模块的函数2
  Future<void> _generatePdfAndNavigate(
      bool autoSubmit, dynamic previousCleanJobNo) async {
    //显示加载框
    showDialog(
      context: context,
      barrierDismissible: false, //禁止点击外部关闭
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), //圆形旋转加载图标
        );
      },
    );

    try {
      setState(() {
        bottomSpacerHeight = 10.h;
        hintText = '';
        dtHintText = '';
        showUploadBtns = false;
        showClearButton = false;
      });
      final imageByteMap = await _captureWidgetAsImage();
      setState(() {
        bottomSpacerHeight = 100.h;
        hintText = 'Please input...';
        dtHintText = 'Click to select...';
        showUploadBtns = true;
        showClearButton = true;
      });

      final imageBytes1 = imageByteMap["byte1"];
      final imageBytes2 = imageByteMap["byte2"];

      final dir = await getTemporaryDirectory();
      final pdfPath = '${dir.path}/report_page.pdf';
      final pdfFile = File(pdfPath);
      final pdf = pw.Document();

      const double margin_w = 30.0;
      const double margin_h = 10.0;

      // Page 1
      final decodedImage1 = await decodeImageFromList(imageBytes1);
      final aspectRatio1 = decodedImage1.width / decodedImage1.height;
      final dynamicHeight1 =
          (PdfPageFormat.a4.width - 2 * margin_w) / aspectRatio1;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(PdfPageFormat.a4.width, dynamicHeight1),
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: margin_w, vertical: margin_h),
              child: pw.Center(
                child: pw.Image(pw.MemoryImage(imageBytes1),
                    fit: pw.BoxFit.contain),
              ),
            );
          },
        ),
      );

      // Page 2
      final decodedImage2 = await decodeImageFromList(imageBytes2);
      final aspectRatio2 = decodedImage2.width / decodedImage2.height;
      final dynamicHeight2 =
          (PdfPageFormat.a4.width - 2 * margin_w) / aspectRatio2;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(PdfPageFormat.a4.width, dynamicHeight2),
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: margin_w, vertical: margin_h),
              child: pw.Center(
                child: pw.Image(pw.MemoryImage(imageBytes2),
                    fit: pw.BoxFit.contain),
              ),
            );
          },
        ),
      );

      await pdfFile.writeAsBytes(await pdf.save());

      // //构建表单数据
      final formData = await _saveData();

      //关闭加载框
      Navigator.pop(context);

      //导航到pdf页面
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportPdf(
            pdfPath: pdfPath,
            formData: formData,
            jobNo: currentJobNo,
            cleanJobNo: cleanJobNo,
            previousCleanJobNo: previousCleanJobNo,
            staffSignaturePath: _staffSignaturePath,
            customerSignaturePath: _customerSignaturePath,
            autoSubmit: autoSubmit,
          ),
        ),
      );

      //如果返回了数据（pdf页面反馈回来的新的job no）
      if (result != null && result is Map<String, dynamic>) {
        final String previousCleanJobNo = cleanJobNo;
        setState(() {
          cleanJobNo = result['cleanJobNo'];
          currentJobNo = result['currentJobNo'];
        });

        //重新转到pdf页面
        await _generatePdfAndNavigate(true, previousCleanJobNo);
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Future<void> _downloadPdfOnly() async {
    try {
      setState(() {
        bottomSpacerHeight = 10.h;
        hintText = '';
        dtHintText = '';
        showUploadBtns = false;
        showClearButton = false;
      });

      await Future.delayed(const Duration(milliseconds: 500));
      final imageByteMap = await _captureWidgetAsImage();

      setState(() {
        bottomSpacerHeight = 100.h;
        hintText = 'Please input...';
        dtHintText = 'Click to select...';
        showUploadBtns = true;
        showClearButton = true;
      });

      final imageBytes1 = imageByteMap["byte1"];
      final imageBytes2 = imageByteMap["byte2"];

      final dir = await getApplicationSupportDirectory();
      final safeName = currentJobNo.replaceAll('/', '_');
      final pdfPath = '${dir.path}/${safeName}_report.pdf';
      final pdfFile = File(pdfPath);
      final pdf = pw.Document();

      const double marginW = 30.0;
      const double marginH = 10.0;

      final decodedImage1 = await decodeImageFromList(imageBytes1);
      final aspectRatio1 = decodedImage1.width / decodedImage1.height;
      final dynamicHeight1 =
          (PdfPageFormat.a4.width - 2 * marginW) / aspectRatio1;

      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(PdfPageFormat.a4.width, dynamicHeight1),
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: marginW, vertical: marginH),
            child: pw.Center(
              child: pw.Image(pw.MemoryImage(imageBytes1),
                  fit: pw.BoxFit.contain),
            ),
          );
        },
      ));

      final decodedImage2 = await decodeImageFromList(imageBytes2);
      final aspectRatio2 = decodedImage2.width / decodedImage2.height;
      final dynamicHeight2 =
          (PdfPageFormat.a4.width - 2 * marginW) / aspectRatio2;

      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(PdfPageFormat.a4.width, dynamicHeight2),
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: marginW, vertical: marginH),
            child: pw.Center(
              child: pw.Image(pw.MemoryImage(imageBytes2),
                  fit: pw.BoxFit.contain),
            ),
          );
        },
      ));

      await pdfFile.writeAsBytes(await pdf.save());

      if (mounted) Navigator.pop(context, pdfPath);
    } catch (e) {
      debugPrint('Download PDF error: $e');
      if (mounted) Navigator.pop(context, null);
    }
  }

  Future<void> _deleteSavedReport(cleanJobNo) async {
    final box = await Hive.openBox('reports');
    final deleteKey = cleanJobNo;
    await box.delete(deleteKey);

    //删除签名和照片文件
    final dir = await getApplicationSupportDirectory();
    final baseName = deleteKey;

    List<String> suffixes = [
      '_1.jpg',
      '_2.jpg',
      '_staff_sign.png',
      '_customer_sign.png',
    ];

    for (var suffix in suffixes) {
      final file = File('${dir.path}/$baseName$suffix');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<Map<String, dynamic>?> _getCustomerByCode(String code) async {
    if (code.isEmpty) {
      return null;
    }

    Map<String, dynamic>? results = await _dbHelper.exactSearchCustomers(code);

    if (results == null) {
      return null;
    } else {
      return results;
    }
  }

  @override
  void dispose() {
    // 移除 overlayEntry
    _overlayEntry?.remove();
    _overlayEntry = null;

    controllers[10].removeListener(_hoursInputListener);

    for (var controller in controllers) {
      controller.dispose();
    }

    for (int i = 0; i < 80; i++) {
      qtyControllers[i].dispose();
      partsNoControllers[i].dispose();
      partsCodeControllers[i].dispose();
      partsNameControllers[i].dispose();
    }
    for (var node in qtyFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, //必须开启
      appBar: AppBar(
        title: Text(
          'Overhaul Report Form',
          style: TextStyle(
            color: Colors.white,
            fontWeight: ui.FontWeight.bold,
            fontSize: 11.sp,
            fontFamily: 'NotoSansThai',
          ),
        ),
        backgroundColor: const Color(0xFFAD193C),
      ),
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
                  'Loading the parts list...',
                  style: TextStyle(fontSize: 10.sp, color: Colors.blueGrey),
                ),
              ],
            ))
          : Stack(
              children: [
                SafeArea(
                  child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(2),
                    minScale: 0.5,
                    maxScale: 3.0,
                    panEnabled: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          RepaintBoundary(
                            key: _captureKey,
                            child: Container(
                              width: 800.w,
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  //表头部分
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 70.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'MAYEKAWA(THAILAND)CO.,LTD.',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'NotoSansThai',
                                            ),
                                          ),
                                          //SizedBox(height: 2.h),
                                          Text(
                                            'MYCOM COMPRESSOR OVERHAUL SERVICE REPORT',
                                            style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'NotoSansThai',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        'assets/report_logo.png', // 替换为你的实际路径
                                        width: 70.w,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 12,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'END USER/ชื่อลูกค้า:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              // child: _buildTextFiled(
                                              //     controller: controllers[0])
                                              child: CustomerSearchWidget(
                                                controller: controllers[0],
                                                hideHint: false,
                                                hintText: hintText,
                                                filled: !_isValids[0],
                                                onCustomerSelected: (address) {
                                                  controllers[2].text = address;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 4.w), // 分隔左右两组

                                      // 右侧占1/4
                                      Expanded(
                                        flex: 5,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'JOB NO.:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: CustomPaint(
                                                painter:
                                                    DashedUnderlinePainter(),
                                                child: Text(
                                                  currentJobNo,
                                                  style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontFamily:
                                                          'NotoSansThai'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 1.h,
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'ADDRESS/ที่อยู่:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: _buildTextFiled(
                                                controller: controllers[2],
                                                fontSize: 5.4.sp,
                                                filled: !_isValids[2],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 1.h),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'START DATE/วันที่เริ่มต้น:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            //SizedBox(width: 4.w),
                                            Expanded(
                                              child: _buildDatePickerField(
                                                context: context,
                                                controller: controllers[3],
                                                filled: !_isValids[3],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //SizedBox(width: 4.w), // 分隔左右两组

                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'FINISH DATE/วันที่เสร็จสิ้น:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            //SizedBox(width: 4.w),
                                            Expanded(
                                              child: _buildDatePickerField(
                                                context: context,
                                                controller: controllers[4],
                                                filled: !_isValids[4],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //SizedBox(width: 4.w), // 分隔左右两组

                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'PRODUCT MONTH/เดือนที่ผลิต:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            //SizedBox(width: 4.w),
                                            Expanded(
                                              child: _buildMonthPickerField(
                                                context: context,
                                                controller: controllers[5],
                                                filled: !_isValids[5],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 1.h,
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'CONTACT PERSON/ชื่อผู้ติดต่อ:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: _buildTextFiled(
                                                  controller: controllers[6],
                                                  filled: !_isValids[6]),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 4.w), // 分隔左右两组

                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'MODEL/รุ่น:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                                child:
                                                    // _buildTextFiled(
                                                    //     controller: controllers[7]),
                                                    ModelSearchReportPage(
                                              controller: controllers[7],
                                              hideHint: false,
                                              hintText: hintText,
                                              filled: !_isValids[7],
                                            )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 1.h),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'COMPRESSOR NO.:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            Expanded(
                                              child: _buildTextFiled(
                                                controller: controllers[8],
                                                filled: !_isValids[8],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 4.w), // 分隔左右两组

                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'SERIAL NO.:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            Expanded(
                                              child: _buildTextFiled(
                                                controller: controllers[9],
                                                filled: !_isValids[9],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'OPERATING HOURS/ชั่วโมงการเดินเครื่อง:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            Expanded(
                                              child: _buildNumberTextField(
                                                controller: controllers[10],
                                                filled: !_isValids[10],
                                              ),
                                            ),
                                            Text(
                                              'hr.',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'OIL PUMP MODEL/รุ่นปั๊มน้ำมัน:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            Expanded(
                                              child: _buildTextFiled(
                                                controller: controllers[11],
                                                filled: !_isValids[11],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 4.w), // 分隔左右两组

                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'OIL BRAND/ยี่ห้อน้ำมัน:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            Expanded(
                                              child: _buildTextFiled(
                                                controller: controllers[12],
                                                filled: !_isValids[12],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 2.h),

                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 左边文字
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 2.h),
                                          child: Text(
                                            'APPLICATION/การใช้งาน:',
                                            style: TextStyle(
                                                fontSize: 6.sp,
                                                fontFamily: 'NotoSansThai'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      // 右边多选区
                                      Expanded(
                                        flex: 4,
                                        child: Wrap(
                                          spacing: 2.w, // 缩小组之间的横向间距
                                          runSpacing: 0.h, // 缩小行与行之间的间距
                                          children: List.generate(4, (index) {
                                            final checkbox = Transform.scale(
                                              scale: 0.75,
                                              child: Container(
                                                color: applicationChecked
                                                    ? Colors.white
                                                    : Colors.yellow,
                                                child: Checkbox(
                                                  value:
                                                      applicationValues[index],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      applicationValues[index] =
                                                          value ?? false;
                                                      applicationChecked =
                                                          applicationValues
                                                              .any((e) => e);
                                                    });
                                                  },
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: -4,
                                                          vertical:
                                                              -4), // 缩小多余间距
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap, // 移除额外 padding
                                                ),
                                              ),
                                            );

                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                checkbox,
                                                Text(labels[index],
                                                    style: TextStyle(
                                                        fontSize: 5.5.sp)),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Wrap(
                                          spacing: 2.w, // 缩小组之间的横向间距
                                          runSpacing: 0.h, // 缩小行与行之间的间距
                                          children: List.generate(5, (index) {
                                            index = index + 4;
                                            final checkbox = Transform.scale(
                                              scale: 0.75,
                                              child: Container(
                                                color: applicationChecked
                                                    ? Colors.white
                                                    : Colors.yellow,
                                                child: Checkbox(
                                                  value:
                                                      applicationValues[index],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      applicationValues[index] =
                                                          value ?? false;
                                                      applicationChecked =
                                                          applicationValues
                                                              .any((e) => e);
                                                    });

                                                    if (index == 8) {
                                                      if (applicationValues[
                                                              8] ==
                                                          true) {
                                                        if (controllers[13]
                                                            .text
                                                            .trim()
                                                            .isNotEmpty) {
                                                          setState(() {
                                                            _isValidOther =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _isValidOther =
                                                                false;
                                                          });
                                                        }
                                                      } else {
                                                        _isValidOther = true;
                                                      }
                                                    }
                                                  },
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: -4,
                                                          vertical:
                                                              -4), // 缩小多余间距
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap, // 移除额外 padding
                                                ),
                                              ),
                                            );

                                            if (labels[index] == 'OTHER') {
                                              return Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  checkbox,
                                                  Text('OTHER',
                                                      style: TextStyle(
                                                          fontSize: 5.5.sp)),
                                                  SizedBox(width: 2.w),
                                                  SizedBox(
                                                    width: 93.w,
                                                    height: 15.h,
                                                    child: TextField(
                                                      controller:
                                                          controllers[13],
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      style: TextStyle(
                                                          fontSize: 5.5.sp),
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        fillColor: const ui
                                                            .Color.fromARGB(
                                                            136, 255, 235, 59),
                                                        filled: !_isValidOther,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.h,
                                                                    horizontal:
                                                                        2.w),
                                                        border:
                                                            const OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }

                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                checkbox,
                                                Text(labels[index],
                                                    style: TextStyle(
                                                        fontSize: 5.5.sp)),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // ⬆️ APPLICATION 区域结束

                                  SizedBox(height: 1.h),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'SYMPTOM/อาการ:',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontFamily: 'NotoSansThai'),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                                child: _buildTextFiled(
                                                    controller:
                                                        controllers[14])),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 2.h),

                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildTextFiled(
                                              controller: controllers[15],
                                              hint: '')),
                                    ],
                                  ),

                                  SizedBox(height: 5.h),

                                  Text(
                                    'REPLACEMENT PARTS',
                                    style: TextStyle(
                                        fontSize: 6.sp,
                                        fontFamily: 'NotoSansThai'),
                                  ),

                                  Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    border: TableBorder.all(),
                                    columnWidths: {
                                      0: FixedColumnWidth(screenWidth * 0.035),
                                      1: FixedColumnWidth(screenWidth * 0.05),
                                      2: FixedColumnWidth(screenWidth * 0.12),
                                      3: FixedColumnWidth(screenWidth * 0.21),
                                      4: FixedColumnWidth(screenWidth * 0.059),
                                      5: FixedColumnWidth(screenWidth * 0.035),
                                      6: FixedColumnWidth(screenWidth * 0.05),
                                      7: FixedColumnWidth(screenWidth * 0.12),
                                      8: FixedColumnWidth(screenWidth * 0.21),
                                      9: FixedColumnWidth(screenWidth * 0.059),
                                    },
                                    children: [
                                      // 表头行
                                      TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300]),
                                        children: [
                                          buildCell('', 10),
                                          buildCell('#', 20),
                                          buildCell('PARTS CODE', 100),
                                          buildCell('PARTS NAME', 160),
                                          buildCell('QTY', 60),
                                          buildCell('', 10),
                                          buildCell('#', 20),
                                          buildCell('PARTS CODE', 100),
                                          buildCell('PARTS NAME', 160),
                                          buildCell('QTY', 60),
                                        ],
                                      ),
                                      //40行数据
                                      for (int i = 0; i < 40; i++)
                                        TableRow(children: [
                                          // 左边行
                                          if (i < leftData.length &&
                                              leftData[i]!
                                                  .containsKey('parts_no')) ...[
                                            buildCell(
                                                leftData[i]?['index'] ?? '', 5),
                                            buildCell(
                                                leftData[i]?[
                                                            'parts_no_controller']
                                                        .text ??
                                                    '',
                                                5),
                                            buildCell(
                                                leftData[i]?[
                                                            'parts_code_controller']
                                                        .text ??
                                                    '',
                                                100,
                                                aligment: Alignment.centerLeft,
                                                textAlign: TextAlign.left),
                                            buildCell(
                                                leftData[i]?[
                                                            'parts_name_controller']
                                                        .text ??
                                                    '',
                                                160,
                                                aligment: Alignment.centerLeft,
                                                textAlign: TextAlign.left),
                                            buildQtyCell(
                                              leftData[i]!['qtyController'],
                                              qtyFocusNodes[i],
                                              60,
                                              filled: (leftData[i]?[
                                                          'parts_code_controller']
                                                      is TextEditingController &&
                                                  leftData[i]?[
                                                              'parts_code_controller']
                                                          ?.text
                                                          .trim()
                                                          .isNotEmpty ==
                                                      true &&
                                                  !_isValidQty),
                                            ),
                                          ] else ...[
                                            buildCell('${i + 1}', 10),
                                            buildEditableCell(
                                                leftData[i]
                                                    ?['parts_no_controller'],
                                                20),
                                            buildEditableCellKeepCapital(
                                                leftData[i]
                                                    ?['parts_code_controller'],
                                                100,
                                                aligment: Alignment.centerLeft,
                                                textAlign: TextAlign.left),
                                            buildEditableCellKeepCapital(
                                                leftData[i]
                                                    ?['parts_name_controller'],
                                                160,
                                                aligment: Alignment.centerLeft,
                                                textAlign: TextAlign.left),
                                            buildQtyCell(
                                              leftData[i]!['qtyController'],
                                              qtyFocusNodes[i],
                                              60,
                                              filled: (leftData[i]?[
                                                          'parts_code_controller']
                                                      is TextEditingController &&
                                                  leftData[i]?[
                                                              'parts_code_controller']
                                                          ?.text
                                                          .trim()
                                                          .isNotEmpty ==
                                                      true &&
                                                  !_isValidQty),
                                            ),
                                          ],
                                          // 右边行
                                          if (i < rightData.length &&
                                              rightData[i]!
                                                  .containsKey('parts_no')) ...[
                                            buildCell(
                                                rightData[i]?['index'] ?? '',
                                                10),
                                            buildCell(
                                                rightData[i]?[
                                                            'parts_no_controller']
                                                        .text ??
                                                    '',
                                                20),
                                            buildCell(
                                                rightData[i]?[
                                                            'parts_code_controller']
                                                        .text ??
                                                    '',
                                                100,
                                                aligment: Alignment.centerLeft,
                                                textAlign: TextAlign.left),
                                            buildCell(
                                                rightData[i]?[
                                                            'parts_name_controller']
                                                        .text ??
                                                    '',
                                                160,
                                                aligment: Alignment.centerLeft,
                                                textAlign: TextAlign.left),
                                            buildQtyCell(
                                              rightData[i]!['qtyController'],
                                              qtyFocusNodes[i + 40],
                                              60,
                                              filled: (rightData[i]?[
                                                          'parts_code_controller']
                                                      is TextEditingController &&
                                                  rightData[i]?[
                                                              'parts_code_controller']
                                                          ?.text
                                                          .trim()
                                                          .isNotEmpty ==
                                                      true &&
                                                  !_isValidQty),
                                            ),
                                          ] else ...[
                                            buildCell('${i + 41}', 10),
                                            buildEditableCell(
                                                rightData[i]
                                                    ?['parts_no_controller'],
                                                20),
                                            buildEditableCellKeepCapital(
                                                rightData[i]
                                                    ?['parts_code_controller'],
                                                100,
                                                aligment: Alignment.centerLeft,
                                                textAlign: TextAlign.left),
                                            buildEditableCellKeepCapital(
                                                rightData[i]
                                                    ?['parts_name_controller'],
                                                160,
                                                aligment: Alignment.centerLeft,
                                                textAlign: TextAlign.left),
                                            buildQtyCell(
                                              rightData[i]!['qtyController'],
                                              qtyFocusNodes[i + 40],
                                              60,
                                              filled: (rightData[i]?[
                                                          'parts_code_controller']
                                                      is TextEditingController &&
                                                  rightData[i]?[
                                                              'parts_code_controller']
                                                          ?.text
                                                          .trim()
                                                          .isNotEmpty ==
                                                      true &&
                                                  !_isValidQty),
                                            ),
                                          ],
                                        ]),
                                    ],
                                  ), // ← ปิด Table (2175)

                                  // === FOOTER หน้า 1 ===
                                  SizedBox(height: 10.h),
                                  Text(
                                    '2/3 Moo 14, 4Th Floor, Bangna Tower,Tower A, Bangna-Trad Road, Bangkaew,Bangplee, Samutprakarn 10540',
                                    style: TextStyle(
                                      fontSize: 6.sp,
                                      fontFamily: 'NotoSansThai',
                                    ),
                                  ),
                                ], // Column children 1
                              ), // Column 1
                            ), //  Container  1
                          ), //  RepaintBoundary  1

                          // ============ Page 2 ============
                          RepaintBoundary(
                            key: _captureKey2,
                            child: Container(
                              width: 800.w,
                              height: 920.h, 
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h),

                                  //headerpage 2
                                  _buildPage2Header(),

                                  Text(
                                    'RESULT & RECOMMEND/ผลการตรวจสอบและข้อแนะนำ',
                                    style: TextStyle(
                                      fontSize: 6.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NotoSansThai',
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      child: TextField(
                                        controller: controllers[16], // 自定义控制器
                                        maxLines: null,
                                        expands: true,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: hintText,
                                          hintStyle: TextStyle(
                                            fontSize: 6.sp,
                                            color: Colors.grey,
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(top: 4.h),
                                          fillColor: const ui.Color.fromARGB(
                                              136, 255, 235, 59),
                                          filled: !_isValids[16],
                                        ),
                                        style: TextStyle(
                                            fontSize: 5.5.sp, height: 1.4),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  // 结果+图片上传区域
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 中间 Photo1
                                      Expanded(
                                        flex: 1,
                                        child: _buildUploadBox(
                                          'Photo1',
                                          photo1,
                                          () async {
                                            final picked =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (picked != null) {
                                              setState(() {
                                                photo1 = picked;
                                                photo1Changed = true;
                                              });
                                            }
                                          },
                                          () async {
                                            final picked =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (picked != null) {
                                              setState(() {
                                                photo1 = picked;
                                                photo1Changed = true;
                                              });
                                            }
                                          },
                                          () {
                                            setState(() {
                                              photo1 = null;
                                              photo1Changed = true;
                                            });
                                          },
                                          showClearButton: showClearButton,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      //右侧 Photo2
                                      Expanded(
                                        flex: 1,
                                        child: _buildUploadBox(
                                          'Photo2',
                                          photo2,
                                          () async {
                                            final picked =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (picked != null) {
                                              setState(() {
                                                photo2 = picked;
                                                photo2Changed = true;
                                              });
                                            }
                                          },
                                          () async {
                                            final picked =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (picked != null) {
                                              setState(() {
                                                photo2 = picked;
                                                photo2Changed = true;
                                              });
                                            }
                                          },
                                          () {
                                            setState(() {
                                              photo2 = null;
                                              photo2Changed = true;
                                            });
                                          },
                                          showClearButton: showClearButton,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  // 三栏签名区域
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 左侧 MAYEKAWA STAFF
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'MAYEKAWA STAFF /เจ้าหน้าที่มาเยคาว่า',
                                              style: TextStyle(
                                                fontSize: 6.sp,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'NotoSansThai',
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 3.w),
                                              width: 110.w,
                                              decoration: BoxDecoration(
                                                border: const Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        Colors.black, // 设置边框颜色
                                                    width: 1.0, // 设置边框宽度
                                                  ),
                                                ),
                                                color: _isValidSigns[0]
                                                    ? Colors.white
                                                    : const ui.Color.fromARGB(
                                                        136, 255, 235, 59),
                                              ),
                                              height: 55.h,
                                              padding: EdgeInsets.all(3.w),
                                              child: _staffSignaturePath != null
                                                  ? FutureBuilder<Uint8List>(
                                                      future: File(
                                                              _staffSignaturePath!)
                                                          .readAsBytes(), // 读取文件字节流
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator()); // 加载中
                                                        } else if (snapshot
                                                                .hasError ||
                                                            snapshot.data ==
                                                                null) {
                                                          return const Center(
                                                              child: Text(
                                                                  'Error loading image')); // 加载错误
                                                        }
                                                        return Image.memory(
                                                          snapshot.data!,
                                                          fit: BoxFit.contain,
                                                          key: ValueKey(
                                                              _staffSignaturePath), // 强制刷新
                                                        );
                                                      },
                                                    )
                                                  : const Center(
                                                      child: Text(
                                                          'Not signed yet')),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      // 中间 CUSTOMER
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'CUSTOMER/ชื่อลูกค้า',
                                              style: TextStyle(
                                                fontSize: 6.sp,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'NotoSansThai',
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 3.w),
                                              width: 110.w,
                                              decoration: BoxDecoration(
                                                border: const Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        Colors.black, // 设置边框颜色
                                                    width: 1.0, // 设置边框宽度
                                                  ),
                                                ),
                                                color: _isValidSigns[1]
                                                    ? Colors.white
                                                    : const ui.Color.fromARGB(
                                                        136, 255, 235, 59),
                                              ),
                                              height: 55.h,
                                              padding: EdgeInsets.all(3.w),
                                              child: _customerSignaturePath !=
                                                      null
                                                  ? FutureBuilder<Uint8List>(
                                                      future: File(
                                                              _customerSignaturePath!)
                                                          .readAsBytes(), // 读取文件字节流
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator()); // 加载中
                                                        } else if (snapshot
                                                                .hasError ||
                                                            snapshot.data ==
                                                                null) {
                                                          return const Center(
                                                              child: Text(
                                                                  'Error loading image')); // 加载错误
                                                        }
                                                        return Image.memory(
                                                          snapshot.data!,
                                                          fit: BoxFit.contain,
                                                          key: ValueKey(
                                                              _customerSignaturePath), // 强制刷新
                                                        );
                                                      },
                                                    )
                                                  : const Center(
                                                      child: Text(
                                                          'Not signed yet')),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      // 右侧 MANAGER
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'MAYEKAWA MANAGER/เจ้าหน้าที่มาเยคาว่า',
                                              style: TextStyle(
                                                fontSize: 5.2.sp,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'NotoSansThai',
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Container(
                                              height: 56.2.h,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        Colors.black, // 设置边框颜色
                                                    width: 1.0, // 设置边框宽度
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    '2/3 Moo 14, 4Th Floor, Bangna Tower,Tower A, Bangna-Trad Road, Bangkaew,Bangplee, Samutprakarn 10540',
                                    style: TextStyle(
                                      fontSize: 6.sp,
                                      //fontWeight: FontWeight.bold,
                                      fontFamily: 'NotoSansThai',
                                    ),
                                  ),

                                  // 预留空间避免被按钮遮住
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: bottomSpacerHeight),
                        ], // children Column wrapper
                      ), // Column wrapper
                    ), // SingleChildScrollView
                  ), // InteractiveViewer
                ), // SafeArea
                // 固定底部按钮
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBottomButton('Back', onPressed: () async {
                          final List<String> checkResults =
                              _checkIsPageModified();

                          bool allEmpty = checkResults.every((e) => e == '');

                          if (!allEmpty) {
                            int buttonClickRes =
                                await _backConfirm(checkResults);

                            if (buttonClickRes == 1) {
                              await _saveData();
                            } else if (buttonClickRes == 2) {
                            } else if (buttonClickRes == 3) {
                              return;
                            }
                          }

                          if (ifThisPageSaved) {
                            if (widget.jobKey != null) {
                              Navigator.pop(context, true);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const IndexPage()));
                            }
                          } else {
                            if (widget.jobKey != null) {
                              Navigator.pop(context, true);
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        }),
                        _buildBottomButton('Save', onPressed: () async {
                          _saveData();
                          //_showSaveDialog();
                          await _showSavingDialog();
                        }),
                        _buildBottomButton('Sign', onPressed: () async {
                          bool checkInput = _checkInputStatus();
                          if (checkInput) {
                            await _navigateToSignaturePage(currentJobNo);
                            await _checkSignStatus();
                          } else {
                            await _showIncompletedDialog();
                          }
                        }),
                        //进入pdf页面按钮
                        IconButton(
                          icon: const Icon(Icons.send_sharp),
                          iconSize: 25.w,
                          color: const Color(0xFFAD193C), // 默认颜色
                          onPressed: () async {
                            bool checkInput = _checkInputStatus();
                            List<bool> checkSigns = await _checkSignStatus();

                            if (checkInput) {
                              if (checkSigns[0] == false &&
                                  checkSigns[1] == false) {
                                await _showIncompletedDialog(
                                    textContents:
                                        "No staff signature and customer signature!");
                              } else if (checkSigns[0] == true &&
                                  checkSigns[1] == false) {
                                await _showIncompletedDialog(
                                    textContents: "No customer signature!");
                              } else if (checkSigns[0] == false &&
                                  checkSigns[1] == true) {
                                await _showIncompletedDialog(
                                    textContents: "No staff signature!");
                              } else if (checkSigns[0] == true &&
                                  checkSigns[1] == true) {
                                _generatePdfAndNavigate(false, null);
                              }
                            } else {
                              if (checkSigns[0] == false &&
                                  checkSigns[1] == false) {
                                await _showIncompletedDialog(
                                    textContents:
                                        "There are some items that have not been filled in!\nNo staff signature and customer signature!");
                              } else if (checkSigns[0] == true &&
                                  checkSigns[1] == false) {
                                await _showIncompletedDialog(
                                    textContents:
                                        "There are some items that have not been filled in!\nNo customer signature!");
                              } else if (checkSigns[0] == false &&
                                  checkSigns[1] == true) {
                                await _showIncompletedDialog(
                                    textContents:
                                        "There are some items that have not been filled in!\nNo staff signature!");
                              } else if (checkSigns[0] == true &&
                                  checkSigns[1] == true) {
                                await _showIncompletedDialog();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              if (widget.downloadOnly)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(height: 30.h),
                            Text('Generating PDF...',
                                style: TextStyle(
                                    fontSize: 10.sp, color: Colors.blueGrey)),
                          ],
                        ),
                      ),
                    ),
                  ),


              ],
            ),
    );
  }

  Widget buildCell(String text, double width,
      {Alignment? aligment, TextAlign? textAlign}) {
    return Container(
      width: width.w,
      height: 16.h,
      alignment: aligment ?? Alignment.center,
      padding: EdgeInsets.only(left: 1.w, right: 1.w),
      child: Text(
        text,
        style: TextStyle(fontSize: 4.sp, height: 1.1),
        textAlign: textAlign ?? TextAlign.center,
      ),
    );
  }

  Widget buildEditableCell(TextEditingController controller, double width,
      {Alignment? aligment, TextAlign? textAlign}) {
    return Container(
      width: width.w,
      height: 16.h,
      alignment: aligment ?? Alignment.center,
      padding: EdgeInsets.only(left: 1.w, right: 1.w),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 4.sp, height: 1.1),
        textAlign: textAlign ?? TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
        ),
      ),
    );
  }

  Widget buildEditableCellKeepCapital(
      TextEditingController controller, double width,
      {Alignment? aligment, TextAlign? textAlign}) {
    return Container(
      width: width.w,
      height: 16.h,
      alignment: aligment ?? Alignment.center,
      padding: EdgeInsets.only(left: 1.w, right: 1.w),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 4.sp, height: 1.1),
        textAlign: textAlign ?? TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
        ),
        onChanged: (value) {
          final uppercased =
              value.replaceAllMapped(RegExp(r'[a-zA-Z]'), (match) {
            return match.group(0)!.toUpperCase();
          });

          if (uppercased != value) {
            final cursorPos = controller.selection;
            controller.value = TextEditingValue(
              text: uppercased,
              selection: cursorPos,
            );
          }
        },
      ),
    );
  }

  Widget buildQtyCell(
      TextEditingController controller, FocusNode focusNode, double width,
      {bool filled = false}) {
    return Container(
      width: width.w,
      padding: EdgeInsets.all(0.w),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          //border: OutlineInputBorder(),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
          filled: filled,
          fillColor: const ui.Color.fromARGB(136, 255, 235, 59),
        ),
        style: TextStyle(fontSize: 4.5.sp),
        keyboardType: TextInputType.number,
        inputFormatters: [
          sv.FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  // === Read-only value with dashed underline (for page 2 header) ===
  Widget _buildReadOnlyVal(String text, {double? fontSize}) {
    return CustomPaint(
      foregroundPainter: DashedUnderlinePainter(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize ?? 6.sp),
        ),
      ),
    );
  }

  // === Page 2 Header (read-only copy of page 1 header) ===
  Widget _buildPage2Header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo + Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 70.w),
            Column(children: [
              Text('MAYEKAWA(THAILAND)CO.,LTD.',
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'NotoSansThai')),
              Text('MYCOM COMPRESSOR OVERHAUL SERVICE REPORT',
                  style: TextStyle(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'NotoSansThai')),
            ]),
            Image.asset('assets/report_logo.png',
                width: 70.w, fit: BoxFit.contain),
          ],
        ),
        SizedBox(height: 10.h),

        // END USER + JOB NO
        Row(children: [
          Expanded(
              flex: 12,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('END USER/ชื่อลูกค้า:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                SizedBox(width: 4.w),
                Expanded(child: _buildReadOnlyVal(controllers[0].text)),
              ])),
          SizedBox(width: 4.w),
          Expanded(
              flex: 5,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('JOB NO.:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                SizedBox(width: 4.w),
                Expanded(child: _buildReadOnlyVal(currentJobNo)),
              ])),
        ]),
        SizedBox(height: 1.h),

        // ADDRESS
        Row(children: [
          Expanded(
              flex: 3,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('ADDRESS/ที่อยู่:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                SizedBox(width: 4.w),
                Expanded(
                    child: _buildReadOnlyVal(controllers[2].text,
                        fontSize: 5.4.sp)),
              ])),
        ]),
        SizedBox(height: 1.h),

        // START DATE + FINISH DATE + PRODUCT MONTH
        Row(children: [
          Expanded(
              flex: 1,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('START DATE/วันที่เริ่มต้น:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                Expanded(child: _buildReadOnlyVal(controllers[3].text)),
              ])),
          Expanded(
              flex: 1,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('FINISH DATE/วันที่เสร็จสิ้น:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                Expanded(child: _buildReadOnlyVal(controllers[4].text)),
              ])),
          Expanded(
              flex: 1,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('PRODUCT MONTH/เดือนที่ผลิต:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                Expanded(child: _buildReadOnlyVal(controllers[5].text)),
              ])),
        ]),
        SizedBox(height: 1.h),

        // CONTACT PERSON + MODEL
        Row(children: [
          Expanded(
              flex: 1,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('CONTACT PERSON/ชื่อผู้ติดต่อ:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                SizedBox(width: 4.w),
                Expanded(child: _buildReadOnlyVal(controllers[6].text)),
              ])),
          SizedBox(width: 4.w),
          Expanded(
              flex: 1,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('MODEL/รุ่น:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                SizedBox(width: 4.w),
                Expanded(child: _buildReadOnlyVal(controllers[7].text)),
              ])),
        ]),
        SizedBox(height: 1.h),

        // COMPRESSOR NO + SERIAL NO + OPERATING HOURS
        Row(children: [
          Expanded(
              flex: 2,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('COMPRESSOR NO.:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                Expanded(child: _buildReadOnlyVal(controllers[8].text)),
              ])),
          SizedBox(width: 4.w),
          Expanded(
              flex: 2,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('SERIAL NO.:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                Expanded(child: _buildReadOnlyVal(controllers[9].text)),
              ])),
          SizedBox(width: 4.w),
          Expanded(
              flex: 3,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('OPERATING HOURS/ชั่วโมงการเดินเครื่อง:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                Expanded(child: _buildReadOnlyVal(controllers[10].text)),
                Text('hr.',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
              ])),
        ]),
        SizedBox(height: 1.h),

        // OIL PUMP MODEL + OIL BRAND
        Row(children: [
          Expanded(
              flex: 1,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('OIL PUMP MODEL/รุ่นปั๊มน้ำมัน:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                Expanded(child: _buildReadOnlyVal(controllers[11].text)),
              ])),
          SizedBox(width: 4.w),
          Expanded(
              flex: 1,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('OIL BRAND/ยี่ห้อน้ำมัน:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                Expanded(child: _buildReadOnlyVal(controllers[12].text)),
              ])),
        ]),
        SizedBox(height: 2.h),

        // APPLICATION (read-only)
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text('APPLICATION/การใช้งาน:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
              )),
          SizedBox(width: 1.w),
          Expanded(
              flex: 4,
              child: Wrap(
                spacing: 2.w,
                runSpacing: 0.h,
                children: List.generate(9, (index) {
                  return Row(mainAxisSize: MainAxisSize.min, children: [
                    Transform.scale(
                      scale: 0.75,
                      child: Checkbox(
                        value: applicationValues[index],
                        onChanged: null, // read-only
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    Text(
                      index == 8
                          ? 'OTHER: ${controllers[13].text}'
                          : labels[index],
                      style: TextStyle(fontSize: 5.5.sp),
                    ),
                  ]);
                }),
              )),
        ]),
        SizedBox(height: 1.h),

        // SYMPTOM
        Row(children: [
          Expanded(
              flex: 3,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('SYMPTOM/อาการ:',
                    style:
                        TextStyle(fontSize: 6.sp, fontFamily: 'NotoSansThai')),
                SizedBox(width: 4.w),
                Expanded(child: _buildReadOnlyVal(controllers[14].text)),
              ])),
        ]),
        SizedBox(height: 2.h),

        // Extra line (controllers[15])
        Row(children: [
          Expanded(child: _buildReadOnlyVal(controllers[15].text)),
        ]),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildUploadBox(
      String label,
      XFile? file,
      VoidCallback onSelectFromGallery,
      VoidCallback onTakePhoto,
      VoidCallback onClear,
      {bool showClearButton = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 6.sp)),
        SizedBox(height: 1.h),
        Container(
          width: 240.w,
          height: 150.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),
          child: file == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    showUploadBtns
                        ? TextButton(
                            onPressed: onSelectFromGallery,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue.shade100, // 设置背景颜色
                              side: const BorderSide(
                                  color: Colors.grey, width: 1), // 边框（可选）
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            child: Text('Select a local photo',
                                style: TextStyle(fontSize: 6.sp)),
                          )
                        : Center(
                            child: Text(
                              'No Photo',
                              style:
                                  TextStyle(fontSize: 6.sp, color: Colors.grey),
                            ),
                          ),
                    showUploadBtns
                        ? TextButton(
                            onPressed: onTakePhoto,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue.shade100, // 设置背景颜色
                              side: const BorderSide(
                                  color: Colors.grey, width: 1), // 边框（可选）
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            child: Text('Turn on the camera',
                                style: TextStyle(fontSize: 6.sp)),
                          )
                        : Center(
                            child: Text(
                              '',
                              style:
                                  TextStyle(fontSize: 6.sp, color: Colors.grey),
                            ),
                          ),
                  ],
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(file.path),
                      fit: BoxFit.contain,
                    ),
                    if (showClearButton)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: onClear,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            color: Colors.black54,
                            child: Icon(
                              Icons.close,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(String text, {required VoidCallback onPressed}) {
    return SizedBox(
      width: 90.w,
      height: 40.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
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
          elevation: WidgetStateProperty.resolveWith<double>((states) {
            return states.contains(WidgetState.pressed) ? 1 : 3;
          }),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextFiled({
    required TextEditingController controller,
    String? hint,
    double? fontSize,
    bool filled = false,
  }) {
    return CustomPaint(
      foregroundPainter: DashedUnderlinePainter(),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          //border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
          hintText: hint ?? hintText,
          hintStyle: TextStyle(fontSize: 6.sp, color: Colors.grey),
          filled: filled,
          fillColor: const ui.Color.fromARGB(136, 255, 235, 59),
        ),
        style: TextStyle(fontSize: fontSize ?? 6.sp),
      ),
    );
  }

  Widget _buildNumberTextField({
    required TextEditingController controller,
    String? hint,
    bool filled = false,
  }) {
    return CustomPaint(
      painter: DashedUnderlinePainter(),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
          hintText: hint ?? hintText,
          hintStyle: TextStyle(fontSize: 6.sp, color: Colors.grey),
          filled: filled,
          fillColor: const ui.Color.fromARGB(136, 255, 235, 59),
        ),
        style: TextStyle(fontSize: 6.sp),
      ),
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required TextEditingController controller,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          helpText: 'Please select the date',
          cancelText: 'Cancel',
          confirmText: 'OK',
        );

        if (picked != null) {
          controller.text =
              "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
        }
      },
      child: AbsorbPointer(
        child: CustomPaint(
          foregroundPainter: DashedUnderlinePainter(),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              hintText: dtHintText,
              hintStyle: TextStyle(fontSize: 6.sp, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 1.w,
              ),
              filled: filled,
              fillColor: const ui.Color.fromARGB(136, 255, 235, 59),
            ),
            style: TextStyle(fontSize: 6.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthPickerField({
    required BuildContext context,
    required TextEditingController controller,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
          helpText: 'Please select the date',
          cancelText: 'Cancel',
          confirmText: 'OK',
        );

        if (picked != null) {
          controller.text =
              "${picked.month.toString().padLeft(2, '0')}-${picked.year}";
        }
      },
      child: AbsorbPointer(
        child: CustomPaint(
          painter: DashedUnderlinePainter(),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              hintText: dtHintText,
              hintStyle: TextStyle(fontSize: 6.sp, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 1.w,
              ),
              filled: filled,
              fillColor: const ui.Color.fromARGB(136, 255, 235, 59),
            ),
            style: TextStyle(fontSize: 6.sp),
          ),
        ),
      ),
    );
  }
}

class DashedUnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4.0;
    const dashSpace = 2.0;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    double startX = 0;
    final y = size.height - 1;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
