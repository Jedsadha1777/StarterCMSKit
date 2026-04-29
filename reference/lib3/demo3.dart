// ─────────────────────────────────────────────────────────────────────────
// FORM SUFFIX: "1"
//   Classes in this file: FormWidget1, FormWidgetState1
//
// หากต้องการ integrate หลายฟอร์มในโปรเจ็กต์เดียวกัน — rename ใน IDE:
//   FormWidget1  →  FormWidget2 (หรือชื่ออื่น)
//   FormWidgetState1  →  FormWidgetState2
// VS Code: F2 บน class name | JetBrains: Shift+F6
// ─────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:typed_data';
import 'form_widgets/form_widgets.dart';
import 'preview_shell.dart';

void main() => runApp(const FormWidget1());

class FormWidget1 extends StatefulWidget {
  const FormWidget1({super.key});
  @override
  State<FormWidget1> createState() => FormWidgetState1();
}

class FormWidgetState1 extends State<FormWidget1> {

  // ============ CONTROLLERS ============
  final _customerTelController = TextEditingController();
  final _serialNoController = TextEditingController();
  final _detailOfServiceController = TextEditingController();
  final _conditionController = TextEditingController();
  final _partNo1Controller = TextEditingController();
  final _partCode1Controller = TextEditingController();
  final _partQty1Controller = TextEditingController();
  final _unitPrice1Controller = TextEditingController();
  final _partTotal1Controller = TextEditingController();
  final _partNo2Controller = TextEditingController();
  final _partCode2Controller = TextEditingController();
  final _partQty2Controller = TextEditingController();
  final _unitPrice2Controller = TextEditingController();
  final _partTotal2Controller = TextEditingController();
  final _partNo3Controller = TextEditingController();
  final _partCode3Controller = TextEditingController();
  final _partQty3Controller = TextEditingController();
  final _unitPrice3Controller = TextEditingController();
  final _partTotal3Controller = TextEditingController();
  final _partNo4Controller = TextEditingController();
  final _partCode4Controller = TextEditingController();
  final _partQty4Controller = TextEditingController();
  final _unitPrice4Controller = TextEditingController();
  final _partTotal4Controller = TextEditingController();
  final _partNo5Controller = TextEditingController();
  final _partCode5Controller = TextEditingController();
  final _partQty5Controller = TextEditingController();
  final _unitPrice5Controller = TextEditingController();
  final _partTotal5Controller = TextEditingController();
  final _partNo6Controller = TextEditingController();
  final _partCode6Controller = TextEditingController();
  final _partQty6Controller = TextEditingController();
  final _unitPrice6Controller = TextEditingController();
  final _partTotal6Controller = TextEditingController();
  final _partNo7Controller = TextEditingController();
  final _partCode7Controller = TextEditingController();
  final _partQty7Controller = TextEditingController();
  final _unitPrice7Controller = TextEditingController();
  final _partTotal7Controller = TextEditingController();
  final _partNo8Controller = TextEditingController();
  final _partCode8Controller = TextEditingController();
  final _partQty8Controller = TextEditingController();
  final _unitPrice8Controller = TextEditingController();
  final _partTotal8Controller = TextEditingController();
  final _partNo9Controller = TextEditingController();
  final _partCode9Controller = TextEditingController();
  final _partQty9Controller = TextEditingController();
  final _unitPrice9Controller = TextEditingController();
  final _partTotal9Controller = TextEditingController();
  final _partNo10Controller = TextEditingController();
  final _partCode10Controller = TextEditingController();
  final _partQty10Controller = TextEditingController();
  final _unitPrice10Controller = TextEditingController();
  final _partTotal10Controller = TextEditingController();
  final _partNo11Controller = TextEditingController();
  final _partCode11Controller = TextEditingController();
  final _partQty11Controller = TextEditingController();
  final _unitPrice11Controller = TextEditingController();
  final _partTotal11Controller = TextEditingController();
  final _partNo12Controller = TextEditingController();
  final _partCode12Controller = TextEditingController();
  final _partQty12Controller = TextEditingController();
  final _unitPrice12Controller = TextEditingController();
  final _partTotal12Controller = TextEditingController();
  final _partNo13Controller = TextEditingController();
  final _partCode13Controller = TextEditingController();
  final _partQty13Controller = TextEditingController();
  final _unitPrice13Controller = TextEditingController();
  final _partTotal13Controller = TextEditingController();
  final _partNo14Controller = TextEditingController();
  final _partCode14Controller = TextEditingController();
  final _partQty14Controller = TextEditingController();
  final _unitPrice14Controller = TextEditingController();
  final _partTotal14Controller = TextEditingController();
  final _partNo15Controller = TextEditingController();
  final _partCode15Controller = TextEditingController();
  final _partQty15Controller = TextEditingController();
  final _unitPrice15Controller = TextEditingController();
  final _partTotal15Controller = TextEditingController();
  final _partSubTotalController = TextEditingController();
  final _chargeRateController = TextEditingController();
  final _chargeHrsController = TextEditingController();
  final _partFeeTotalController = TextEditingController();
  final _partGrandTotalController = TextEditingController();
  final _customerSignNameController = TextEditingController();
  final _staffSignNameController = TextEditingController();

  Map<String, TextEditingController> get _controllerMap => {
    'customerTel': _customerTelController,
    'serialNo': _serialNoController,
    'detailOfService': _detailOfServiceController,
    'condition': _conditionController,
    'partNo1': _partNo1Controller,
    'partCode1': _partCode1Controller,
    'partQty1': _partQty1Controller,
    'unitPrice1': _unitPrice1Controller,
    'partTotal1': _partTotal1Controller,
    'partNo2': _partNo2Controller,
    'partCode2': _partCode2Controller,
    'partQty2': _partQty2Controller,
    'unitPrice2': _unitPrice2Controller,
    'partTotal2': _partTotal2Controller,
    'partNo3': _partNo3Controller,
    'partCode3': _partCode3Controller,
    'partQty3': _partQty3Controller,
    'unitPrice3': _unitPrice3Controller,
    'partTotal3': _partTotal3Controller,
    'partNo4': _partNo4Controller,
    'partCode4': _partCode4Controller,
    'partQty4': _partQty4Controller,
    'unitPrice4': _unitPrice4Controller,
    'partTotal4': _partTotal4Controller,
    'partNo5': _partNo5Controller,
    'partCode5': _partCode5Controller,
    'partQty5': _partQty5Controller,
    'unitPrice5': _unitPrice5Controller,
    'partTotal5': _partTotal5Controller,
    'partNo6': _partNo6Controller,
    'partCode6': _partCode6Controller,
    'partQty6': _partQty6Controller,
    'unitPrice6': _unitPrice6Controller,
    'partTotal6': _partTotal6Controller,
    'partNo7': _partNo7Controller,
    'partCode7': _partCode7Controller,
    'partQty7': _partQty7Controller,
    'unitPrice7': _unitPrice7Controller,
    'partTotal7': _partTotal7Controller,
    'partNo8': _partNo8Controller,
    'partCode8': _partCode8Controller,
    'partQty8': _partQty8Controller,
    'unitPrice8': _unitPrice8Controller,
    'partTotal8': _partTotal8Controller,
    'partNo9': _partNo9Controller,
    'partCode9': _partCode9Controller,
    'partQty9': _partQty9Controller,
    'unitPrice9': _unitPrice9Controller,
    'partTotal9': _partTotal9Controller,
    'partNo10': _partNo10Controller,
    'partCode10': _partCode10Controller,
    'partQty10': _partQty10Controller,
    'unitPrice10': _unitPrice10Controller,
    'partTotal10': _partTotal10Controller,
    'partNo11': _partNo11Controller,
    'partCode11': _partCode11Controller,
    'partQty11': _partQty11Controller,
    'unitPrice11': _unitPrice11Controller,
    'partTotal11': _partTotal11Controller,
    'partNo12': _partNo12Controller,
    'partCode12': _partCode12Controller,
    'partQty12': _partQty12Controller,
    'unitPrice12': _unitPrice12Controller,
    'partTotal12': _partTotal12Controller,
    'partNo13': _partNo13Controller,
    'partCode13': _partCode13Controller,
    'partQty13': _partQty13Controller,
    'unitPrice13': _unitPrice13Controller,
    'partTotal13': _partTotal13Controller,
    'partNo14': _partNo14Controller,
    'partCode14': _partCode14Controller,
    'partQty14': _partQty14Controller,
    'unitPrice14': _unitPrice14Controller,
    'partTotal14': _partTotal14Controller,
    'partNo15': _partNo15Controller,
    'partCode15': _partCode15Controller,
    'partQty15': _partQty15Controller,
    'unitPrice15': _unitPrice15Controller,
    'partTotal15': _partTotal15Controller,
    'partSubTotal': _partSubTotalController,
    'chargeRate': _chargeRateController,
    'chargeHrs': _chargeHrsController,
    'partFeeTotal': _partFeeTotalController,
    'partGrandTotal': _partGrandTotalController,
    'customerSignName': _customerSignNameController,
    'staffSignName': _staffSignNameController,
  };

  @override
  void dispose() {
    for (final c in _controllerMap.values) { c.dispose(); }
    super.dispose();
  }


  // ============ STATE VARIABLES ============
  bool _snapMode = false;
  final GlobalKey _captureKey = GlobalKey();

  String? _visitDate;
  String? _finishDate;
  String? _timeIn;
  String? _timeOut;
  String? _customerName;
  String? _modelName;
  String? _partName1;
  String? _partName2;
  String? _partName3;
  String? _partName4;
  String? _partName5;
  String? _partName6;
  String? _partName7;
  String? _partName8;
  String? _partName9;
  String? _partName10;
  String? _partName11;
  String? _partName12;
  String? _partName13;
  String? _partName14;
  String? _partName15;
  Uint8List? _customerSignBytes;
  Uint8List? _staffSignBytes;
  bool _typeOfService = false;

  InputDecoration get _inputDecoration => _snapMode
      ? const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0))
      : const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0));

  @override
  Widget build(BuildContext context) => PreviewShell(pages: [
      _page1(),
      _page2(),
  ]);

  Widget _page1() => RepaintBoundary(key: _captureKey, child: UnconstrainedBox(
  alignment: Alignment.topLeft,
  child: LayoutBuilder(
  builder: (context, constraints) {
    final availableWidth = constraints.maxWidth;

    final fixedTotal = 966.0;
    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal).clamp(0.0, double.infinity);
    final flexUnit = availableWidth.isInfinite ? 200.0 : flexSpace / 0.001000;
    final colWidths = <double>[
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
    ];

    final rowHeights = <double>[24.0, 20.0, 20.0, 20.0, 20.0, 29.0, 24.0, 24.0, 24.0, 24.0, 24.0, 20.0, 27.0, 20.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 24.0, 20.0];

    final cs = <double>[0.0];
    for (final w in colWidths) { cs.add(cs.last + w); }
    final rs = <double>[0.0];
    for (final h in rowHeights) { rs.add(rs.last + h); }

    final totalWidth = cs.last;
    final totalHeight = rs.last;

    Positioned cell(int c, int r, int ce, int re,
        {Border? border, Color? bg, EdgeInsets pad = EdgeInsets.zero,
        Alignment align = Alignment.centerLeft, required Widget child}) =>
      Positioned(left: cs[c], top: rs[r], width: cs[ce] - cs[c], height: rs[re] - rs[r],
          child: Container(
              decoration: (border != null || bg != null) ? BoxDecoration(border: border, color: bg) : null,
              padding: pad, alignment: align, child: child));

    final matrixData = <List<int>>[
      <int>[0, 1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 19],
      <int>[20, 1, 1, 1, 1, 1, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 37],
      <int>[38, 1, 1, 1, 1, 1, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 56],
      <int>[57, 1, 1, 1, 1, 1, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 75],
      <int>[76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121],
      <int>[122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 141, 141, 141, 141, 141, 141, 141, 141, 142, 143, 144, 145, 145, 145, 145, 145, 145, 151, 151, 151, 151, 151, 151, 151, 152, 153],
      <int>[154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199],
      <int>[200, 201, 201, 201, 201, 201, 202, 202, 202, 202, 202, 202, 202, 202, 202, 202, 202, 203, 204, 205, 206, 207, 208, 208, 208, 208, 208, 209, 209, 209, 209, 209, 209, 209, 209, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219],
      <int>[220, 221, 221, 221, 221, 221, 222, 222, 222, 222, 222, 222, 222, 222, 222, 222, 222, 223, 224, 225, 226, 227, 228, 228, 228, 228, 228, 229, 229, 229, 229, 229, 229, 229, 229, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239],
      <int>[240, 241, 241, 241, 241, 241, 241, 241, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 243, 243, 243, 243, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 245],
      <int>[246, 247, 247, 247, 247, 247, 247, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 249, 249, 249, 249, 249, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 251],
      <int>[252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297],
      <int>[298, 299, 300, 300, 300, 300, 300, 300, 300, 300, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 301, 302, 303, 304, 305, 306, 307, 308, 309],
      <int>[310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355],
      <int>[356, 357, 357, 357, 357, 357, 357, 357, 357, 357, 357, 357, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401],
      <int>[402, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 404],
      <int>[405, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 406],
      <int>[407, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 408],
      <int>[409, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 410],
      <int>[411, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 412],
      <int>[413, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 414],
      <int>[415, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 416],
      <int>[417, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 403, 418],
      <int>[419, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 420, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464],
      <int>[465, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 467],
      <int>[468, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 469],
      <int>[470, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 471],
      <int>[472, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 473],
      <int>[474, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 466, 475],
      <int>[476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521],
      <int>[522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522, 522],
      <int>[523, 524, 524, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 525, 526, 526, 526, 526, 526, 527, 527, 527, 527, 528, 528, 528, 528, 528, 528, 529, 529, 529, 529, 529, 529, 529, 529, 529, 530],
      <int>[531, 532, 532, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 533, 534, 534, 534, 534, 534, 535, 535, 535, 535, 536, 536, 536, 536, 536, 536, 537, 537, 537, 537, 537, 537, 537, 537, 537, 538],
      <int>[539, 540, 540, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 541, 542, 542, 542, 542, 542, 543, 543, 543, 543, 544, 544, 544, 544, 544, 544, 545, 545, 545, 545, 545, 545, 545, 545, 545, 546],
      <int>[547, 548, 548, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 549, 550, 550, 550, 550, 550, 551, 551, 551, 551, 552, 552, 552, 552, 552, 552, 553, 553, 553, 553, 553, 553, 553, 553, 553, 554],
      <int>[555, 556, 556, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 557, 558, 558, 558, 558, 558, 559, 559, 559, 559, 560, 560, 560, 560, 560, 560, 561, 561, 561, 561, 561, 561, 561, 561, 561, 562],
      <int>[563, 564, 564, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 565, 566, 566, 566, 566, 566, 567, 567, 567, 567, 568, 568, 568, 568, 568, 568, 569, 569, 569, 569, 569, 569, 569, 569, 569, 570],
      <int>[571, 572, 572, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 574, 574, 574, 574, 574, 575, 575, 575, 575, 576, 576, 576, 576, 576, 576, 577, 577, 577, 577, 577, 577, 577, 577, 577, 578],
      <int>[579, 580, 580, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 581, 582, 582, 582, 582, 582, 583, 583, 583, 583, 584, 584, 584, 584, 584, 584, 585, 585, 585, 585, 585, 585, 585, 585, 585, 586],
      <int>[587, 588, 588, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 589, 590, 590, 590, 590, 590, 591, 591, 591, 591, 592, 592, 592, 592, 592, 592, 593, 593, 593, 593, 593, 593, 593, 593, 593, 594],
      <int>[595, 596, 596, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 597, 598, 598, 598, 598, 598, 599, 599, 599, 599, 600, 600, 600, 600, 600, 600, 601, 601, 601, 601, 601, 601, 601, 601, 601, 602],
      <int>[603, 604, 604, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 605, 606, 606, 606, 606, 606, 607, 607, 607, 607, 608, 608, 608, 608, 608, 608, 609, 609, 609, 609, 609, 609, 609, 609, 609, 610],
      <int>[611, 612, 612, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 613, 614, 614, 614, 614, 614, 615, 615, 615, 615, 616, 616, 616, 616, 616, 616, 617, 617, 617, 617, 617, 617, 617, 617, 617, 618],
      <int>[619, 620, 620, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 621, 622, 622, 622, 622, 622, 623, 623, 623, 623, 624, 624, 624, 624, 624, 624, 625, 625, 625, 625, 625, 625, 625, 625, 625, 626],
      <int>[627, 628, 628, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 629, 630, 630, 630, 630, 630, 631, 631, 631, 631, 632, 632, 632, 632, 632, 632, 633, 633, 633, 633, 633, 633, 633, 633, 633, 634],
      <int>[635, 636, 636, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 637, 638, 638, 638, 638, 638, 639, 639, 639, 639, 640, 640, 640, 640, 640, 640, 641, 641, 641, 641, 641, 641, 641, 641, 641, 642],
      <int>[643, 644, 644, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 645, 646, 646, 646, 646, 646, 647, 647, 647, 647, 648, 648, 648, 648, 648, 648, 649, 649, 649, 649, 649, 649, 649, 649, 649, 650],
      <int>[651, 652, 652, 652, 652, 652, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 682, 682, 682, 682, 682, 682, 682, 682, 683],
      <int>[684, 685, 685, 685, 685, 685, 685, 685, 685, 686, 686, 686, 686, 687, 688, 688, 688, 688, 689, 689, 689, 692, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 707, 707, 707, 707, 707, 707, 707, 707, 708],
      <int>[709, 710, 710, 710, 710, 710, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 740, 740, 740, 740, 740, 740, 740, 740, 741],
      <int>[742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787],
    ];

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(left: cs[0], top: rs[0], width: cs[1] - cs[0], height: rs[1] - rs[0], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[0], width: cs[6] - cs[1], height: rs[4] - rs[0], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(top: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 13.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('Company Logo', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
















          cell(22, 0, 45, 2, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.bottomRight, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 18.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('Akagane (Thailand) Co., Ltd.', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.right),
              )),

          Positioned(left: cs[0], top: rs[1], width: cs[1] - cs[0], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

















          Positioned(left: cs[0], top: rs[2], width: cs[1] - cs[0], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
















          cell(22, 2, 45, 3, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topRight, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Calibri', fontSize: 10.6, color: Color(0xFF000000)),
                  children: [
                    TextSpan(text: '16 Compomax Building, 5th Floor, Room No. 502', style: TextStyle(color: Color(0xFF000000), fontSize: 10.6, fontFamily: 'Calibri')),
                  ],
                ),
              )),

          Positioned(left: cs[0], top: rs[3], width: cs[1] - cs[0], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
















          cell(22, 3, 45, 4, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topRight, child: _t('Soi Ekamai 4, Sukhumvit 63 Rd., Prakanongnua, Vadhana, Bangkok 10110', sz: 10.6, color: Color(0xFF000000), ff: 'Calibri', align: TextAlign.right)),


































































          cell(19, 5, 28, 6, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 23.9, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('SERVICE REPORT', softWrap: false, overflow: TextOverflow.visible),
              )),



          cell(31, 5, 37, 6, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.bottomLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Service Report No.', softWrap: false, overflow: TextOverflow.visible),
              )),
          Positioned(left: cs[37], top: rs[5], width: cs[44] - cs[37], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[1], top: rs[6], width: cs[2] - cs[1], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[6], width: cs[3] - cs[2], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[6], width: cs[4] - cs[3], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[6], width: cs[5] - cs[4], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[6], width: cs[6] - cs[5], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[6], width: cs[7] - cs[6], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[6], width: cs[8] - cs[7], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[6], width: cs[9] - cs[8], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[6], width: cs[10] - cs[9], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[6], width: cs[11] - cs[10], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[6], width: cs[12] - cs[11], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[6], width: cs[13] - cs[12], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[6], width: cs[14] - cs[13], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[6], width: cs[15] - cs[14], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[6], width: cs[16] - cs[15], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[6], width: cs[17] - cs[16], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[6], width: cs[18] - cs[17], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[6], width: cs[19] - cs[18], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[6], width: cs[20] - cs[19], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[6], width: cs[21] - cs[20], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[6], width: cs[22] - cs[21], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[6], width: cs[23] - cs[22], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[6], width: cs[24] - cs[23], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[6], width: cs[25] - cs[24], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[6], width: cs[26] - cs[25], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[6], width: cs[27] - cs[26], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[6], width: cs[28] - cs[27], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[6], width: cs[29] - cs[28], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[6], width: cs[30] - cs[29], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[6], width: cs[31] - cs[30], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[6], width: cs[32] - cs[31], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[6], width: cs[33] - cs[32], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[6], width: cs[34] - cs[33], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[6], width: cs[35] - cs[34], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[6], width: cs[36] - cs[35], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[6], width: cs[37] - cs[36], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[6], width: cs[38] - cs[37], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[6], width: cs[39] - cs[38], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[6], width: cs[40] - cs[39], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[6], width: cs[41] - cs[40], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[6], width: cs[42] - cs[41], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[6], width: cs[43] - cs[42], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[6], width: cs[44] - cs[43], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[6], width: cs[45] - cs[44], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[7], width: cs[1] - cs[0], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[7], width: cs[6] - cs[1], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('VISIT DATE:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[6], top: rs[7], width: cs[17] - cs[6], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'visit_date', required: true, snapMode: _snapMode, value: _visitDate, onChanged: (v) => setState(() => _visitDate = v)))),
          Positioned(left: cs[17], top: rs[7], width: cs[18] - cs[17], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[7], width: cs[19] - cs[18], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[7], width: cs[20] - cs[19], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[7], width: cs[21] - cs[20], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[7], width: cs[22] - cs[21], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[7], width: cs[27] - cs[22], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TIME IN:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[27], top: rs[7], width: cs[36] - cs[27], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormTime(name: 'time_in', required: true, snapMode: _snapMode, value: _timeIn, onChanged: (v) => setState(() => _timeIn = v)))),
          Positioned(left: cs[36], top: rs[7], width: cs[37] - cs[36], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[7], width: cs[38] - cs[37], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[7], width: cs[39] - cs[38], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[7], width: cs[40] - cs[39], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[7], width: cs[41] - cs[40], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[7], width: cs[42] - cs[41], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[7], width: cs[43] - cs[42], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[7], width: cs[44] - cs[43], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[7], width: cs[45] - cs[44], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[8], width: cs[1] - cs[0], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[8], width: cs[6] - cs[1], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('FINISH DATE:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[6], top: rs[8], width: cs[17] - cs[6], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'finish_date', required: true, snapMode: _snapMode, value: _finishDate, onChanged: (v) => setState(() => _finishDate = v)))),
          Positioned(left: cs[17], top: rs[8], width: cs[18] - cs[17], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[8], width: cs[19] - cs[18], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[8], width: cs[20] - cs[19], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[8], width: cs[21] - cs[20], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[8], width: cs[22] - cs[21], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[8], width: cs[27] - cs[22], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TIME OUT:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[27], top: rs[8], width: cs[36] - cs[27], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormTime(name: 'time_out', required: true, snapMode: _snapMode, value: _timeOut, onChanged: (v) => setState(() => _timeOut = v)))),
          Positioned(left: cs[36], top: rs[8], width: cs[37] - cs[36], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[8], width: cs[38] - cs[37], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[8], width: cs[39] - cs[38], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[8], width: cs[40] - cs[39], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[8], width: cs[41] - cs[40], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[8], width: cs[42] - cs[41], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[8], width: cs[43] - cs[42], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[8], width: cs[44] - cs[43], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[8], width: cs[45] - cs[44], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[9], width: cs[1] - cs[0], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[9], width: cs[8] - cs[1], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('CUSTOMER NAME:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[8], top: rs[9], width: cs[29] - cs[8], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'customer_name', source: 'customers', displayFields: 'customer_id,name,tel', fields: 'customer_name,customer_tel', required: true, snapMode: _snapMode, value: _customerName, onSelected: (v) => setState(() => _customerName = v?['customer_name,customer_tel'] as String?)))),
          Positioned(left: cs[29], top: rs[9], width: cs[33] - cs[29], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('CONTACT:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[33], top: rs[9], width: cs[45] - cs[33], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _customerTelController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[10], width: cs[1] - cs[0], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[10], width: cs[7] - cs[1], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('MODEL NAME:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[7], top: rs[10], width: cs[20] - cs[7], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'model_name', source: 'machine_models', displayFields: 'model_code,model_name', fields: 'model_name', required: true, snapMode: _snapMode, value: _modelName, onSelected: (v) => setState(() => _modelName = v?['model_name'] as String?)))),
          Positioned(left: cs[20], top: rs[10], width: cs[25] - cs[20], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('SERIAL NO.:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[25], top: rs[10], width: cs[45] - cs[25], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _serialNoController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),








          cell(7, 11, 8, 12, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.bottomLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('.', softWrap: false, overflow: TextOverflow.visible),
              )),








































          cell(2, 12, 10, 13, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('TYPE OF SERVICE*', softWrap: false, overflow: TextOverflow.visible),
              )),
          cell(10, 12, 38, 13, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: FormCheckbox(name: 'type_of_service', options: ['WARRANTY', 'MAINTENANCE', 'REPAIR'])),























































          Positioned(left: cs[1], top: rs[14], width: cs[12] - cs[1], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('DETAILS OF SERVICE:*', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[12], top: rs[14], width: cs[13] - cs[12], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[14], width: cs[14] - cs[13], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[14], width: cs[15] - cs[14], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[14], width: cs[16] - cs[15], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[14], width: cs[17] - cs[16], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[14], width: cs[18] - cs[17], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[14], width: cs[19] - cs[18], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[14], width: cs[20] - cs[19], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[14], width: cs[21] - cs[20], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[14], width: cs[22] - cs[21], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[14], width: cs[23] - cs[22], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[14], width: cs[24] - cs[23], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[14], width: cs[25] - cs[24], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[14], width: cs[26] - cs[25], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[14], width: cs[27] - cs[26], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[14], width: cs[28] - cs[27], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[14], width: cs[29] - cs[28], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[14], width: cs[30] - cs[29], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[14], width: cs[31] - cs[30], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[14], width: cs[32] - cs[31], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[14], width: cs[33] - cs[32], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[14], width: cs[34] - cs[33], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[14], width: cs[35] - cs[34], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[14], width: cs[36] - cs[35], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[14], width: cs[37] - cs[36], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[14], width: cs[38] - cs[37], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[14], width: cs[39] - cs[38], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[14], width: cs[40] - cs[39], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[14], width: cs[41] - cs[40], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[14], width: cs[42] - cs[41], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[14], width: cs[43] - cs[42], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[14], width: cs[44] - cs[43], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[14], width: cs[45] - cs[44], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[15], width: cs[1] - cs[0], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[15], width: cs[45] - cs[1], height: rs[23] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _detailOfServiceController, maxLines: null, minLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(fontFamily: 'Calibri', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[16], width: cs[1] - cs[0], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[17], width: cs[1] - cs[0], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[18], width: cs[1] - cs[0], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[19], width: cs[1] - cs[0], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[20], width: cs[1] - cs[0], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[21], width: cs[1] - cs[0], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[22], width: cs[1] - cs[0], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),


          Positioned(left: cs[1], top: rs[23], width: cs[20] - cs[1], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('MANCHINE CONDITION / RECOMMENDATIONS:', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[20], top: rs[23], width: cs[21] - cs[20], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[23], width: cs[22] - cs[21], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[23], width: cs[23] - cs[22], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[23], width: cs[24] - cs[23], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[23], width: cs[25] - cs[24], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[23], width: cs[26] - cs[25], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[23], width: cs[27] - cs[26], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[23], width: cs[28] - cs[27], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[23], width: cs[29] - cs[28], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[23], width: cs[30] - cs[29], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[23], width: cs[31] - cs[30], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[23], width: cs[32] - cs[31], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[23], width: cs[33] - cs[32], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[23], width: cs[34] - cs[33], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[23], width: cs[35] - cs[34], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[23], width: cs[36] - cs[35], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[23], width: cs[37] - cs[36], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[23], width: cs[38] - cs[37], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[23], width: cs[39] - cs[38], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[23], width: cs[40] - cs[39], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[23], width: cs[41] - cs[40], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[23], width: cs[42] - cs[41], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[23], width: cs[43] - cs[42], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[23], width: cs[44] - cs[43], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[23], width: cs[45] - cs[44], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[24], width: cs[1] - cs[0], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[24], width: cs[45] - cs[1], height: rs[29] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _conditionController, maxLines: null, minLines: null, expands: true, textAlignVertical: TextAlignVertical.top, style: const TextStyle(fontFamily: 'Calibri', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[25], width: cs[1] - cs[0], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[26], width: cs[1] - cs[0], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[27], width: cs[1] - cs[0], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[28], width: cs[1] - cs[0], height: rs[29] - rs[28], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),















































          Positioned(left: cs[0], top: rs[30], width: cs[46] - cs[0], height: rs[31] - rs[30], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('PARTS / MATERIALS', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[0], top: rs[31], width: cs[1] - cs[0], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[31], width: cs[3] - cs[1], height: rs[32] - rs[31], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('#', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[3], top: rs[31], width: cs[21] - cs[3], height: rs[32] - rs[31], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Parts Name', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[21], top: rs[31], width: cs[26] - cs[21], height: rs[32] - rs[31], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('PART No.', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[26], top: rs[31], width: cs[30] - cs[26], height: rs[32] - rs[31], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('QTR.', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[30], top: rs[31], width: cs[36] - cs[30], height: rs[32] - rs[31], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('UNIT PRICE', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),
          Positioned(left: cs[36], top: rs[31], width: cs[45] - cs[36], height: rs[32] - rs[31], child: Stack(children: [Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TOTAL', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )), Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _DashedBorderPainter(sides: [_DashSide.bottom(color: Color(0xFF000000), width: 3, doubled: true)]))))])),

          Positioned(left: cs[0], top: rs[32], width: cs[1] - cs[0], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[32], width: cs[3] - cs[1], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partNo1Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[32], width: cs[21] - cs[3], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_1', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_1,part_code1,unit_price1', required: true, snapMode: _snapMode, value: _partName1, onSelected: (v) => setState(() => _partName1 = v?['part_name_1,part_code1,unit_price1'] as String?)))),
          Positioned(left: cs[21], top: rs[32], width: cs[26] - cs[21], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partCode1Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[32], width: cs[30] - cs[26], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty1Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[32], width: cs[36] - cs[30], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice1Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[32], width: cs[45] - cs[36], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal1Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 16), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[33], width: cs[1] - cs[0], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[33], width: cs[3] - cs[1], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo2Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[33], width: cs[21] - cs[3], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_2', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_2,part_code2,unit_price2', required: true, snapMode: _snapMode, value: _partName2, onSelected: (v) => setState(() => _partName2 = v?['part_name_2,part_code2,unit_price2'] as String?)))),
          Positioned(left: cs[21], top: rs[33], width: cs[26] - cs[21], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode2Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[33], width: cs[30] - cs[26], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty2Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 16), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[33], width: cs[36] - cs[30], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice2Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[33], width: cs[45] - cs[36], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal2Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[34], width: cs[1] - cs[0], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[34], width: cs[3] - cs[1], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo3Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[34], width: cs[21] - cs[3], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_3', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_3,part_code3,unit_price3', required: true, snapMode: _snapMode, value: _partName3, onSelected: (v) => setState(() => _partName3 = v?['part_name_3,part_code3,unit_price3'] as String?)))),
          Positioned(left: cs[21], top: rs[34], width: cs[26] - cs[21], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode3Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[34], width: cs[30] - cs[26], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty3Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[34], width: cs[36] - cs[30], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice3Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[34], width: cs[45] - cs[36], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal3Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[35], width: cs[1] - cs[0], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[35], width: cs[3] - cs[1], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo4Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[35], width: cs[21] - cs[3], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_4', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_4,part_code4,unit_price4', required: true, snapMode: _snapMode, value: _partName4, onSelected: (v) => setState(() => _partName4 = v?['part_name_4,part_code4,unit_price4'] as String?)))),
          Positioned(left: cs[21], top: rs[35], width: cs[26] - cs[21], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode4Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[35], width: cs[30] - cs[26], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty4Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[35], width: cs[36] - cs[30], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice4Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[35], width: cs[45] - cs[36], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal4Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[36], width: cs[1] - cs[0], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[36], width: cs[3] - cs[1], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo5Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[36], width: cs[21] - cs[3], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_5', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_5,part_code5,unit_price5', required: true, snapMode: _snapMode, value: _partName5, onSelected: (v) => setState(() => _partName5 = v?['part_name_5,part_code5,unit_price5'] as String?)))),
          Positioned(left: cs[21], top: rs[36], width: cs[26] - cs[21], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode5Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[36], width: cs[30] - cs[26], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty5Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[36], width: cs[36] - cs[30], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice5Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[36], width: cs[45] - cs[36], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal5Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[37], width: cs[1] - cs[0], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[37], width: cs[3] - cs[1], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo6Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[37], width: cs[21] - cs[3], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_6', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_6,part_code6,unit_price6', required: true, snapMode: _snapMode, value: _partName6, onSelected: (v) => setState(() => _partName6 = v?['part_name_6,part_code6,unit_price6'] as String?)))),
          Positioned(left: cs[21], top: rs[37], width: cs[26] - cs[21], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode6Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[37], width: cs[30] - cs[26], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty6Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[37], width: cs[36] - cs[30], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice6Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[37], width: cs[45] - cs[36], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal6Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[38], width: cs[1] - cs[0], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[38], width: cs[3] - cs[1], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo7Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[38], width: cs[21] - cs[3], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_7', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_7,part_code7,unit_price7', required: true, snapMode: _snapMode, value: _partName7, onSelected: (v) => setState(() => _partName7 = v?['part_name_7,part_code7,unit_price7'] as String?)))),
          Positioned(left: cs[21], top: rs[38], width: cs[26] - cs[21], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode7Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[38], width: cs[30] - cs[26], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty7Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[38], width: cs[36] - cs[30], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice7Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[38], width: cs[45] - cs[36], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal7Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[39], width: cs[1] - cs[0], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[39], width: cs[3] - cs[1], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo8Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[39], width: cs[21] - cs[3], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_8', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_8,part_code8,unit_price8', required: true, snapMode: _snapMode, value: _partName8, onSelected: (v) => setState(() => _partName8 = v?['part_name_8,part_code8,unit_price8'] as String?)))),
          Positioned(left: cs[21], top: rs[39], width: cs[26] - cs[21], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode8Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[39], width: cs[30] - cs[26], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty8Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[39], width: cs[36] - cs[30], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice8Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[39], width: cs[45] - cs[36], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal8Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[40], width: cs[1] - cs[0], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[40], width: cs[3] - cs[1], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo9Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[40], width: cs[21] - cs[3], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_9', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_9,part_code9,unit_price9', required: true, snapMode: _snapMode, value: _partName9, onSelected: (v) => setState(() => _partName9 = v?['part_name_9,part_code9,unit_price9'] as String?)))),
          Positioned(left: cs[21], top: rs[40], width: cs[26] - cs[21], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode9Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[40], width: cs[30] - cs[26], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty9Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[40], width: cs[36] - cs[30], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice9Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[40], width: cs[45] - cs[36], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal9Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[41], width: cs[1] - cs[0], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[41], width: cs[3] - cs[1], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo10Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[41], width: cs[21] - cs[3], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_10', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_10,part_code10,unit_price10', required: true, snapMode: _snapMode, value: _partName10, onSelected: (v) => setState(() => _partName10 = v?['part_name_10,part_code10,unit_price10'] as String?)))),
          Positioned(left: cs[21], top: rs[41], width: cs[26] - cs[21], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode10Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[41], width: cs[30] - cs[26], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty10Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[41], width: cs[36] - cs[30], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice10Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[41], width: cs[45] - cs[36], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal10Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[42], width: cs[1] - cs[0], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[42], width: cs[3] - cs[1], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo11Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[42], width: cs[21] - cs[3], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_11', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_11,part_code11,unit_price11', required: true, snapMode: _snapMode, value: _partName11, onSelected: (v) => setState(() => _partName11 = v?['part_name_11,part_code11,unit_price11'] as String?)))),
          Positioned(left: cs[21], top: rs[42], width: cs[26] - cs[21], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode11Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[42], width: cs[30] - cs[26], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty11Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[42], width: cs[36] - cs[30], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice11Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[42], width: cs[45] - cs[36], height: rs[43] - rs[42], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal11Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[43], width: cs[1] - cs[0], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[43], width: cs[3] - cs[1], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo12Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[43], width: cs[21] - cs[3], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_12', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_12,part_code12,unit_price12', required: true, snapMode: _snapMode, value: _partName12, onSelected: (v) => setState(() => _partName12 = v?['part_name_12,part_code12,unit_price12'] as String?)))),
          Positioned(left: cs[21], top: rs[43], width: cs[26] - cs[21], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode12Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[43], width: cs[30] - cs[26], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty12Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[43], width: cs[36] - cs[30], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice12Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[43], width: cs[45] - cs[36], height: rs[44] - rs[43], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal12Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[44], width: cs[1] - cs[0], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[44], width: cs[3] - cs[1], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo13Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[44], width: cs[21] - cs[3], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_13', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_13,part_code13,unit_price13', required: true, snapMode: _snapMode, value: _partName13, onSelected: (v) => setState(() => _partName13 = v?['part_name_13,part_code13,unit_price13'] as String?)))),
          Positioned(left: cs[21], top: rs[44], width: cs[26] - cs[21], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode13Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[44], width: cs[30] - cs[26], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty13Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[44], width: cs[36] - cs[30], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice13Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[44], width: cs[45] - cs[36], height: rs[45] - rs[44], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal13Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[45], width: cs[1] - cs[0], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[45], width: cs[3] - cs[1], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo14Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[45], width: cs[21] - cs[3], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_14', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_14,part_code14,unit_price14', required: true, snapMode: _snapMode, value: _partName14, onSelected: (v) => setState(() => _partName14 = v?['part_name_14,part_code14,unit_price14'] as String?)))),
          Positioned(left: cs[21], top: rs[45], width: cs[26] - cs[21], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode14Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[45], width: cs[30] - cs[26], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty14Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[45], width: cs[36] - cs[30], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice14Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[45], width: cs[45] - cs[36], height: rs[46] - rs[45], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal14Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[46], width: cs[1] - cs[0], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[46], width: cs[3] - cs[1], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partNo15Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[3], top: rs[46], width: cs[21] - cs[3], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'part_name_15', source: 'parts', displayFields: 'parts_code,parts_name,unit_price', fields: 'part_name_15,part_code15,unit_price15', required: true, snapMode: _snapMode, value: _partName15, onSelected: (v) => setState(() => _partName15 = v?['part_name_15,part_code15,unit_price15'] as String?)))),
          Positioned(left: cs[21], top: rs[46], width: cs[26] - cs[21], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: TextField(controller: _partCode15Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[26], top: rs[46], width: cs[30] - cs[26], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partQty15Controller, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[30], top: rs[46], width: cs[36] - cs[30], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _unitPrice15Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[36], top: rs[46], width: cs[45] - cs[36], height: rs[47] - rs[46], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partTotal15Controller, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[47], width: cs[1] - cs[0], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[47], width: cs[7] - cs[1], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('PARTS TOTAL', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[7], top: rs[47], width: cs[8] - cs[7], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[47], width: cs[9] - cs[8], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[47], width: cs[10] - cs[9], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[47], width: cs[11] - cs[10], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[47], width: cs[12] - cs[11], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[47], width: cs[13] - cs[12], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[47], width: cs[14] - cs[13], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[47], width: cs[15] - cs[14], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[47], width: cs[16] - cs[15], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[47], width: cs[17] - cs[16], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[47], width: cs[18] - cs[17], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[47], width: cs[19] - cs[18], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[47], width: cs[20] - cs[19], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[47], width: cs[21] - cs[20], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[47], width: cs[22] - cs[21], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[47], width: cs[23] - cs[22], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[47], width: cs[24] - cs[23], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[47], width: cs[25] - cs[24], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[47], width: cs[26] - cs[25], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[47], width: cs[27] - cs[26], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[47], width: cs[28] - cs[27], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[47], width: cs[29] - cs[28], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[47], width: cs[30] - cs[29], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[47], width: cs[31] - cs[30], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[47], width: cs[32] - cs[31], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[47], width: cs[33] - cs[32], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[47], width: cs[34] - cs[33], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[47], width: cs[35] - cs[34], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[47], width: cs[36] - cs[35], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[47], width: cs[45] - cs[36], height: rs[48] - rs[47], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partSubTotalController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[48], width: cs[1] - cs[0], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[48], width: cs[9] - cs[1], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('SERVICE CHARGE:', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[9], top: rs[48], width: cs[13] - cs[9], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _chargeRateController, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Arial', fontSize: 17.3), decoration: _inputDecoration))),
          Positioned(left: cs[13], top: rs[48], width: cs[14] - cs[13], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Arial', fontSize: 14.6, color: Color.fromRGBO(0, 0, 0, 1)),
                child: Text('X', softWrap: false, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[14], top: rs[48], width: cs[18] - cs[14], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _chargeHrsController, keyboardType: TextInputType.number, style: const TextStyle(fontFamily: 'Arial', fontSize: 14.6), decoration: _inputDecoration))),
          Positioned(left: cs[18], top: rs[48], width: cs[21] - cs[18], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Arial', fontSize: 14.6, color: Color.fromRGBO(0, 0, 0, 1)),
                child: Text('HRS.', softWrap: false, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[21], top: rs[48], width: cs[22] - cs[21], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[48], width: cs[23] - cs[22], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[48], width: cs[24] - cs[23], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[48], width: cs[25] - cs[24], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[48], width: cs[26] - cs[25], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[48], width: cs[27] - cs[26], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[48], width: cs[28] - cs[27], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[48], width: cs[29] - cs[28], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[48], width: cs[30] - cs[29], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[48], width: cs[31] - cs[30], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[48], width: cs[32] - cs[31], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[48], width: cs[33] - cs[32], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[48], width: cs[34] - cs[33], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[48], width: cs[35] - cs[34], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[48], width: cs[36] - cs[35], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[48], width: cs[45] - cs[36], height: rs[49] - rs[48], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partFeeTotalController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[49], width: cs[1] - cs[0], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[49], width: cs[7] - cs[1], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('GRAND TOTAL', softWrap: false, overflow: TextOverflow.visible),
              ))),
          Positioned(left: cs[7], top: rs[49], width: cs[8] - cs[7], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[49], width: cs[9] - cs[8], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[49], width: cs[10] - cs[9], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[49], width: cs[11] - cs[10], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[49], width: cs[12] - cs[11], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[49], width: cs[13] - cs[12], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[49], width: cs[14] - cs[13], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[49], width: cs[15] - cs[14], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[49], width: cs[16] - cs[15], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[49], width: cs[17] - cs[16], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[49], width: cs[18] - cs[17], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[49], width: cs[19] - cs[18], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[49], width: cs[20] - cs[19], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[49], width: cs[21] - cs[20], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[49], width: cs[22] - cs[21], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[49], width: cs[23] - cs[22], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[49], width: cs[24] - cs[23], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[49], width: cs[25] - cs[24], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[49], width: cs[26] - cs[25], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[49], width: cs[27] - cs[26], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[49], width: cs[28] - cs[27], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[49], width: cs[29] - cs[28], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[49], width: cs[30] - cs[29], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[49], width: cs[31] - cs[30], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[49], width: cs[32] - cs[31], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[49], width: cs[33] - cs[32], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[49], width: cs[34] - cs[33], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[49], width: cs[35] - cs[34], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[49], width: cs[36] - cs[35], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[49], width: cs[45] - cs[36], height: rs[50] - rs[49], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _partGrandTotalController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),















































          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(
              painter: _TableGridPainter(
                colStarts: cs,
                rowStarts: rs,
                borderColor: Colors.black,
                borderWidth: 0.0,
                matrixData: matrixData,
                numRows: 51,
                numCols: 46,
              ),
            )),
          ),
        ],
      ),
    );
  },
),
));

  Widget _page2() => UnconstrainedBox(
  alignment: Alignment.topLeft,
  child: LayoutBuilder(
  builder: (context, constraints) {
    final availableWidth = constraints.maxWidth;

    final fixedTotal = 966.0;
    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal).clamp(0.0, double.infinity);
    final flexUnit = availableWidth.isInfinite ? 200.0 : flexSpace / 0.001000;
    final colWidths = <double>[
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
      21.0,
    ];

    final rowHeights = <double>[24.0, 20.0, 20.0, 20.0, 20.0, 29.0, 24.0, 24.0, 24.0, 24.0, 24.0, 20.0, 20.0, 24.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 27.0, 24.0, 20.0];

    final cs = <double>[0.0];
    for (final w in colWidths) { cs.add(cs.last + w); }
    final rs = <double>[0.0];
    for (final h in rowHeights) { rs.add(rs.last + h); }

    final totalWidth = cs.last;
    final totalHeight = rs.last;

    Positioned cell(int c, int r, int ce, int re,
        {Border? border, Color? bg, EdgeInsets pad = EdgeInsets.zero,
        Alignment align = Alignment.centerLeft, required Widget child}) =>
      Positioned(left: cs[c], top: rs[r], width: cs[ce] - cs[c], height: rs[re] - rs[r],
          child: Container(
              decoration: (border != null || bg != null) ? BoxDecoration(border: border, color: bg) : null,
              padding: pad, alignment: align, child: child));

    final matrixData = <List<int>>[
      <int>[0, 1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 19],
      <int>[20, 1, 1, 1, 1, 1, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 37],
      <int>[38, 1, 1, 1, 1, 1, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 56],
      <int>[57, 1, 1, 1, 1, 1, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 75],
      <int>[76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121],
      <int>[122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 141, 141, 141, 141, 141, 141, 141, 141, 142, 143, 144, 145, 145, 145, 145, 145, 145, 151, 151, 151, 151, 151, 151, 151, 152, 153],
      <int>[154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199],
      <int>[200, 201, 201, 201, 201, 201, 202, 202, 202, 202, 202, 202, 202, 202, 202, 202, 202, 203, 204, 205, 206, 207, 208, 208, 208, 208, 208, 209, 209, 209, 209, 209, 209, 209, 209, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219],
      <int>[220, 221, 221, 221, 221, 221, 222, 222, 222, 222, 222, 222, 222, 222, 222, 222, 222, 223, 224, 225, 226, 227, 228, 228, 228, 228, 228, 229, 229, 229, 229, 229, 229, 229, 229, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239],
      <int>[240, 241, 241, 241, 241, 241, 241, 241, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 243, 243, 243, 243, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 245],
      <int>[246, 247, 247, 247, 247, 247, 247, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 249, 249, 249, 249, 249, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 251],
      <int>[252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297],
      <int>[298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343],
      <int>[344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 365, 365, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386],
      <int>[387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432],
      <int>[433, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 435, 436, 437, 438, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 440, 441, 442, 443, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 445],
      <int>[446, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 447, 448, 449, 450, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 451, 452, 453, 454, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 455],
      <int>[456, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 457, 458, 459, 460, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 461, 462, 463, 464, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 465],
      <int>[466, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 467, 468, 469, 470, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 471, 472, 473, 474, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 475],
      <int>[476, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 477, 478, 479, 480, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 481, 482, 483, 484, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 485],
      <int>[486, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 487, 488, 489, 490, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 491, 492, 493, 494, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 495],
      <int>[496, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 497, 498, 499, 500, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 501, 502, 503, 504, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 505],
      <int>[506, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 434, 507, 508, 509, 510, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 439, 511, 512, 513, 514, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 444, 515],
      <int>[516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561],
      <int>[562, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 564, 565, 566, 567, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 569, 570, 571, 572, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 574],
      <int>[575, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 576, 577, 578, 579, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 580, 581, 582, 583, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 584],
      <int>[585, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 586, 587, 588, 589, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 590, 591, 592, 593, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 594],
      <int>[595, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 596, 597, 598, 599, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 600, 601, 602, 603, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 604],
      <int>[605, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 606, 607, 608, 609, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 610, 611, 612, 613, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 614],
      <int>[615, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 616, 617, 618, 619, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 620, 621, 622, 623, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 624],
      <int>[625, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 626, 627, 628, 629, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 630, 631, 632, 633, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 634],
      <int>[635, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 563, 636, 637, 638, 639, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 568, 640, 641, 642, 643, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 573, 644],
      <int>[645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690],
      <int>[691, 692, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736],
      <int>[737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 747, 747, 747, 747, 747, 747, 747, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 768, 768, 768, 768, 768, 768, 768, 768, 768, 768, 779, 780, 781, 782],
      <int>[783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828],
      <int>[829, 830, 831, 832, 833, 834, 835, 835, 835, 835, 835, 835, 835, 835, 835, 835, 835, 835, 835, 836, 837, 838, 839, 840, 841, 842, 843, 844, 844, 844, 844, 844, 844, 844, 844, 844, 844, 844, 844, 844, 845, 846, 847, 848, 849, 850],
      <int>[851, 852, 853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883, 884, 885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896],
      <int>[897, 898, 899, 900, 901, 902, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 913, 914, 915, 916, 917, 918],
      <int>[919, 920, 921, 922, 923, 924, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 925, 926, 927, 928, 929, 930, 931, 932, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 933, 934, 935, 936, 937, 938],
      <int>[939, 940, 941, 942, 943, 944, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 945, 946, 947, 948, 949, 950, 951, 952, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 953, 954, 955, 956, 957, 958],
      <int>[959, 960, 961, 962, 963, 964, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 903, 965, 966, 967, 968, 969, 970, 971, 972, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 912, 973, 974, 975, 976, 977, 978],
      <int>[979, 980, 981, 982, 983, 984, 985, 986, 987, 988, 989, 990, 990, 990, 990, 990, 995, 996, 997, 998, 999, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1011, 1011, 1011, 1011, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024],
      <int>[1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1042, 1043, 1044, 1045, 1046, 1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070],
      <int>[1071, 1072, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116],
      <int>[1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 1133, 1134, 1135, 1136, 1137, 1138, 1139, 1140, 1141, 1142, 1143, 1144, 1145, 1146, 1147, 1148, 1149, 1150, 1151, 1152, 1153, 1154, 1155, 1156, 1157, 1158, 1159, 1160, 1161, 1162],
      <int>[1163, 1164, 1165, 1166, 1167, 1168, 1169, 1170, 1171, 1172, 1173, 1174, 1175, 1176, 1177, 1178, 1179, 1180, 1181, 1182, 1183, 1184, 1185, 1186, 1187, 1188, 1189, 1190, 1191, 1192, 1193, 1194, 1195, 1196, 1197, 1198, 1199, 1200, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208],
      <int>[1209, 1210, 1211, 1212, 1213, 1214, 1215, 1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223, 1224, 1225, 1226, 1227, 1228, 1229, 1230, 1231, 1232, 1233, 1234, 1235, 1236, 1237, 1238, 1239, 1240, 1241, 1242, 1243, 1244, 1245, 1246, 1247, 1248, 1249, 1250, 1251, 1252, 1253, 1254],
      <int>[1255, 1256, 1257, 1258, 1259, 1260, 1261, 1262, 1263, 1264, 1265, 1266, 1267, 1268, 1269, 1270, 1271, 1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279, 1280, 1281, 1282, 1283, 1284, 1285, 1286, 1287, 1288, 1289, 1290, 1291, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300],
      <int>[1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1311, 1312, 1313, 1314, 1315, 1316, 1317, 1318, 1319, 1320, 1321, 1322, 1323, 1324, 1325, 1326, 1327, 1328, 1329, 1330, 1331, 1332, 1333, 1334, 1335, 1336, 1337, 1338, 1339, 1340, 1341, 1342, 1343, 1344, 1345, 1346],
      <int>[1347, 1348, 1349, 1350, 1351, 1352, 1353, 1354, 1355, 1356, 1357, 1358, 1359, 1360, 1361, 1362, 1363, 1364, 1365, 1366, 1367, 1368, 1369, 1370, 1371, 1372, 1373, 1374, 1375, 1376, 1377, 1378, 1379, 1380, 1381, 1382, 1383, 1384, 1385, 1386, 1387, 1388, 1389, 1390, 1391, 1392],
    ];

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(left: cs[0], top: rs[0], width: cs[1] - cs[0], height: rs[1] - rs[0], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[0], width: cs[6] - cs[1], height: rs[4] - rs[0], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(top: BorderSide(color: Color(0xFF000000), width: 1), right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 13.3, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('Company Logo', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
















          cell(22, 0, 45, 2, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.bottomRight, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 18.6, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('Akagane (Thailand) Co., Ltd.', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.right),
              )),

          Positioned(left: cs[0], top: rs[1], width: cs[1] - cs[0], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

















          Positioned(left: cs[0], top: rs[2], width: cs[1] - cs[0], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
















          cell(22, 2, 45, 3, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topRight, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Calibri', fontSize: 10.6, color: Color(0xFF000000)),
                  children: [
                    TextSpan(text: '16 Compomax Building, 5th Floor, Room No. 502', style: TextStyle(color: Color(0xFF000000), fontSize: 10.6, fontFamily: 'Calibri')),
                  ],
                ),
              )),

          Positioned(left: cs[0], top: rs[3], width: cs[1] - cs[0], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
















          cell(22, 3, 45, 4, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.topRight, child: _t('Soi Ekamai 4, Sukhumvit 63 Rd., Prakanongnua, Vadhana, Bangkok 10110', sz: 10.6, color: Color(0xFF000000), ff: 'Calibri', align: TextAlign.right)),


































































          cell(19, 5, 28, 6, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 23.9, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                child: Text('SERVICE REPORT', softWrap: false, overflow: TextOverflow.visible),
              )),



          cell(31, 5, 37, 6, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.bottomLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Service Report No.', softWrap: false, overflow: TextOverflow.visible),
              )),
          Positioned(left: cs[37], top: rs[5], width: cs[44] - cs[37], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[1], top: rs[6], width: cs[2] - cs[1], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[6], width: cs[3] - cs[2], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[6], width: cs[4] - cs[3], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[6], width: cs[5] - cs[4], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[6], width: cs[6] - cs[5], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[6], width: cs[7] - cs[6], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[6], width: cs[8] - cs[7], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[6], width: cs[9] - cs[8], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[6], width: cs[10] - cs[9], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[6], width: cs[11] - cs[10], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[6], width: cs[12] - cs[11], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[6], width: cs[13] - cs[12], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[6], width: cs[14] - cs[13], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[6], width: cs[15] - cs[14], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[6], width: cs[16] - cs[15], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[6], width: cs[17] - cs[16], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[6], width: cs[18] - cs[17], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[6], width: cs[19] - cs[18], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[6], width: cs[20] - cs[19], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[6], width: cs[21] - cs[20], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[6], width: cs[22] - cs[21], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[6], width: cs[23] - cs[22], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[6], width: cs[24] - cs[23], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[6], width: cs[25] - cs[24], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[6], width: cs[26] - cs[25], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[6], width: cs[27] - cs[26], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[6], width: cs[28] - cs[27], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[6], width: cs[29] - cs[28], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[6], width: cs[30] - cs[29], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[6], width: cs[31] - cs[30], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[6], width: cs[32] - cs[31], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[6], width: cs[33] - cs[32], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[6], width: cs[34] - cs[33], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[6], width: cs[35] - cs[34], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[6], width: cs[36] - cs[35], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[6], width: cs[37] - cs[36], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[6], width: cs[38] - cs[37], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[6], width: cs[39] - cs[38], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[6], width: cs[40] - cs[39], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[6], width: cs[41] - cs[40], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[6], width: cs[42] - cs[41], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[6], width: cs[43] - cs[42], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[6], width: cs[44] - cs[43], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[6], width: cs[45] - cs[44], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[7], width: cs[1] - cs[0], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[7], width: cs[6] - cs[1], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('VISIT DATE:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[6], top: rs[7], width: cs[17] - cs[6], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'visit_date', required: true, snapMode: _snapMode, value: _visitDate, onChanged: (v) => setState(() => _visitDate = v)))),
          Positioned(left: cs[17], top: rs[7], width: cs[18] - cs[17], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[7], width: cs[19] - cs[18], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[7], width: cs[20] - cs[19], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[7], width: cs[21] - cs[20], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[7], width: cs[22] - cs[21], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[7], width: cs[27] - cs[22], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TIME IN:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[27], top: rs[7], width: cs[36] - cs[27], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormTime(name: 'time_in', required: true, snapMode: _snapMode, value: _timeIn, onChanged: (v) => setState(() => _timeIn = v)))),
          Positioned(left: cs[36], top: rs[7], width: cs[37] - cs[36], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[7], width: cs[38] - cs[37], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[7], width: cs[39] - cs[38], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[7], width: cs[40] - cs[39], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[7], width: cs[41] - cs[40], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[7], width: cs[42] - cs[41], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[7], width: cs[43] - cs[42], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[7], width: cs[44] - cs[43], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[7], width: cs[45] - cs[44], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[8], width: cs[1] - cs[0], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[8], width: cs[6] - cs[1], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('FINISH DATE:', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[6], top: rs[8], width: cs[17] - cs[6], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormDate(name: 'finish_date', required: true, snapMode: _snapMode, value: _finishDate, onChanged: (v) => setState(() => _finishDate = v)))),
          Positioned(left: cs[17], top: rs[8], width: cs[18] - cs[17], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[8], width: cs[19] - cs[18], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[8], width: cs[20] - cs[19], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[8], width: cs[21] - cs[20], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[8], width: cs[22] - cs[21], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[8], width: cs[27] - cs[22], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('TIME OUT:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[27], top: rs[8], width: cs[36] - cs[27], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormTime(name: 'time_out', required: true, snapMode: _snapMode, value: _timeOut, onChanged: (v) => setState(() => _timeOut = v)))),
          Positioned(left: cs[36], top: rs[8], width: cs[37] - cs[36], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[8], width: cs[38] - cs[37], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[8], width: cs[39] - cs[38], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[8], width: cs[40] - cs[39], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[8], width: cs[41] - cs[40], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[8], width: cs[42] - cs[41], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[8], width: cs[43] - cs[42], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[8], width: cs[44] - cs[43], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[8], width: cs[45] - cs[44], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[9], width: cs[1] - cs[0], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[9], width: cs[8] - cs[1], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('CUSTOMER NAME:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[8], top: rs[9], width: cs[29] - cs[8], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'customer_name', source: 'customers', displayFields: 'customer_id,name,tel', fields: 'customer_name,customer_tel', required: true, snapMode: _snapMode, value: _customerName, onSelected: (v) => setState(() => _customerName = v?['customer_name,customer_tel'] as String?)))),
          Positioned(left: cs[29], top: rs[9], width: cs[33] - cs[29], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('CONTACT:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[33], top: rs[9], width: cs[45] - cs[33], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _customerTelController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),

          Positioned(left: cs[0], top: rs[10], width: cs[1] - cs[0], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[10], width: cs[7] - cs[1], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('MODEL NAME:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[7], top: rs[10], width: cs[20] - cs[7], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSearch(name: 'model_name', source: 'machine_models', displayFields: 'model_code,model_name', fields: 'model_name', required: true, snapMode: _snapMode, value: _modelName, onSelected: (v) => setState(() => _modelName = v?['model_name'] as String?)))),
          Positioned(left: cs[20], top: rs[10], width: cs[25] - cs[20], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('SERIAL NO.:*', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              ))),
          Positioned(left: cs[25], top: rs[10], width: cs[45] - cs[25], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _serialNoController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 14.6), decoration: _inputDecoration))),


















































































































          cell(21, 13, 25, 14, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.center, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 18.6, color: Color(0xFF000000)),
                child: Text('Photos', softWrap: false, overflow: TextOverflow.visible, textAlign: TextAlign.center),
              )),






















          Positioned(left: cs[1], top: rs[14], width: cs[2] - cs[1], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[14], width: cs[3] - cs[2], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[14], width: cs[4] - cs[3], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[14], width: cs[5] - cs[4], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[14], width: cs[6] - cs[5], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[14], width: cs[7] - cs[6], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[14], width: cs[8] - cs[7], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[14], width: cs[9] - cs[8], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[14], width: cs[10] - cs[9], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[14], width: cs[11] - cs[10], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[14], width: cs[12] - cs[11], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[14], width: cs[13] - cs[12], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),




          Positioned(left: cs[17], top: rs[14], width: cs[18] - cs[17], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[14], width: cs[19] - cs[18], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[14], width: cs[20] - cs[19], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[14], width: cs[21] - cs[20], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[14], width: cs[22] - cs[21], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[14], width: cs[23] - cs[22], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[14], width: cs[24] - cs[23], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[14], width: cs[25] - cs[24], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[14], width: cs[26] - cs[25], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[14], width: cs[27] - cs[26], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[14], width: cs[28] - cs[27], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[14], width: cs[29] - cs[28], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),




          Positioned(left: cs[33], top: rs[14], width: cs[34] - cs[33], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[14], width: cs[35] - cs[34], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[14], width: cs[36] - cs[35], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[14], width: cs[37] - cs[36], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[14], width: cs[38] - cs[37], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[14], width: cs[39] - cs[38], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[14], width: cs[40] - cs[39], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[14], width: cs[41] - cs[40], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[14], width: cs[42] - cs[41], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[14], width: cs[43] - cs[42], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[14], width: cs[44] - cs[43], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[14], width: cs[45] - cs[44], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[15], width: cs[1] - cs[0], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[15], width: cs[13] - cs[1], height: rs[23] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'pic1'))),



          Positioned(left: cs[16], top: rs[15], width: cs[17] - cs[16], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[15], width: cs[29] - cs[17], height: rs[23] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'pic2'))),



          Positioned(left: cs[32], top: rs[15], width: cs[33] - cs[32], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[15], width: cs[45] - cs[33], height: rs[23] - rs[15], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'pic3'))),

          Positioned(left: cs[0], top: rs[16], width: cs[1] - cs[0], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[16], width: cs[17] - cs[16], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[16], width: cs[33] - cs[32], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[17], width: cs[1] - cs[0], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[17], width: cs[17] - cs[16], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[17], width: cs[33] - cs[32], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[18], width: cs[1] - cs[0], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[18], width: cs[17] - cs[16], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[18], width: cs[33] - cs[32], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[19], width: cs[1] - cs[0], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[19], width: cs[17] - cs[16], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[19], width: cs[33] - cs[32], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[20], width: cs[1] - cs[0], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[20], width: cs[17] - cs[16], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[20], width: cs[33] - cs[32], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[21], width: cs[1] - cs[0], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[21], width: cs[17] - cs[16], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[21], width: cs[33] - cs[32], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[22], width: cs[1] - cs[0], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[22], width: cs[17] - cs[16], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[22], width: cs[33] - cs[32], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),


          Positioned(left: cs[1], top: rs[23], width: cs[2] - cs[1], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[23], width: cs[3] - cs[2], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[23], width: cs[4] - cs[3], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[23], width: cs[5] - cs[4], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[23], width: cs[6] - cs[5], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[23], width: cs[7] - cs[6], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[23], width: cs[8] - cs[7], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[23], width: cs[9] - cs[8], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[23], width: cs[10] - cs[9], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[23], width: cs[11] - cs[10], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomCenter, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[23], width: cs[12] - cs[11], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[23], width: cs[13] - cs[12], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),




          Positioned(left: cs[17], top: rs[23], width: cs[18] - cs[17], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[23], width: cs[19] - cs[18], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[19], top: rs[23], width: cs[20] - cs[19], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[20], top: rs[23], width: cs[21] - cs[20], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[21], top: rs[23], width: cs[22] - cs[21], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[22], top: rs[23], width: cs[23] - cs[22], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[23], top: rs[23], width: cs[24] - cs[23], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[24], top: rs[23], width: cs[25] - cs[24], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[25], top: rs[23], width: cs[26] - cs[25], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[26], top: rs[23], width: cs[27] - cs[26], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[23], width: cs[28] - cs[27], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[23], width: cs[29] - cs[28], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),




          Positioned(left: cs[33], top: rs[23], width: cs[34] - cs[33], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[23], width: cs[35] - cs[34], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[23], width: cs[36] - cs[35], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[23], width: cs[37] - cs[36], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[23], width: cs[38] - cs[37], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[23], width: cs[39] - cs[38], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[23], width: cs[40] - cs[39], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[40], top: rs[23], width: cs[41] - cs[40], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[41], top: rs[23], width: cs[42] - cs[41], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[42], top: rs[23], width: cs[43] - cs[42], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[43], top: rs[23], width: cs[44] - cs[43], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[44], top: rs[23], width: cs[45] - cs[44], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[24], width: cs[1] - cs[0], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[24], width: cs[13] - cs[1], height: rs[32] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'pic4'))),



          Positioned(left: cs[16], top: rs[24], width: cs[17] - cs[16], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[24], width: cs[29] - cs[17], height: rs[32] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'pic5'))),



          Positioned(left: cs[32], top: rs[24], width: cs[33] - cs[32], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[24], width: cs[45] - cs[33], height: rs[32] - rs[24], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1), bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormImageUpload(name: 'pic6'))),

          Positioned(left: cs[0], top: rs[25], width: cs[1] - cs[0], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[25], width: cs[17] - cs[16], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[25], width: cs[33] - cs[32], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[26], width: cs[1] - cs[0], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[26], width: cs[17] - cs[16], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[26], width: cs[33] - cs[32], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[27], width: cs[1] - cs[0], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[27], width: cs[17] - cs[16], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[27], width: cs[33] - cs[32], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[28], width: cs[1] - cs[0], height: rs[29] - rs[28], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[28], width: cs[17] - cs[16], height: rs[29] - rs[28], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[28], width: cs[33] - cs[32], height: rs[29] - rs[28], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[29], width: cs[1] - cs[0], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[29], width: cs[17] - cs[16], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[29], width: cs[33] - cs[32], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[30], width: cs[1] - cs[0], height: rs[31] - rs[30], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[30], width: cs[17] - cs[16], height: rs[31] - rs[30], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[30], width: cs[33] - cs[32], height: rs[31] - rs[30], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),

          Positioned(left: cs[0], top: rs[31], width: cs[1] - cs[0], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),



          Positioned(left: cs[16], top: rs[31], width: cs[17] - cs[16], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: const SizedBox.shrink())),



          Positioned(left: cs[32], top: rs[31], width: cs[33] - cs[32], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),







































































































          cell(10, 34, 18, 35, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.bottomLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Customer name:*', softWrap: false, overflow: TextOverflow.visible),
              )),













          cell(31, 34, 42, 35, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), align: Alignment.bottomLeft, child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Service staff name:*', softWrap: false, overflow: TextOverflow.visible),
              )),
























































          Positioned(left: cs[6], top: rs[36], width: cs[19] - cs[6], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _customerSignNameController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 16), decoration: _inputDecoration))),








          Positioned(left: cs[27], top: rs[36], width: cs[40] - cs[27], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: TextField(controller: _staffSignNameController, style: const TextStyle(fontFamily: 'Calibri', fontSize: 16), decoration: _inputDecoration))),












          Positioned(left: cs[6], top: rs[37], width: cs[7] - cs[6], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[37], width: cs[8] - cs[7], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[8], top: rs[37], width: cs[9] - cs[8], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[9], top: rs[37], width: cs[10] - cs[9], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[10], top: rs[37], width: cs[11] - cs[10], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[11], top: rs[37], width: cs[12] - cs[11], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[12], top: rs[37], width: cs[13] - cs[12], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[13], top: rs[37], width: cs[14] - cs[13], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[14], top: rs[37], width: cs[15] - cs[14], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[15], top: rs[37], width: cs[16] - cs[15], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[16], top: rs[37], width: cs[17] - cs[16], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[17], top: rs[37], width: cs[18] - cs[17], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[18], top: rs[37], width: cs[19] - cs[18], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),








          Positioned(left: cs[27], top: rs[37], width: cs[28] - cs[27], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[28], top: rs[37], width: cs[29] - cs[28], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[29], top: rs[37], width: cs[30] - cs[29], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[30], top: rs[37], width: cs[31] - cs[30], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[31], top: rs[37], width: cs[32] - cs[31], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[32], top: rs[37], width: cs[33] - cs[32], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[33], top: rs[37], width: cs[34] - cs[33], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[34], top: rs[37], width: cs[35] - cs[34], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[35], top: rs[37], width: cs[36] - cs[35], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[36], top: rs[37], width: cs[37] - cs[36], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[37], top: rs[37], width: cs[38] - cs[37], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[38], top: rs[37], width: cs[39] - cs[38], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[39], top: rs[37], width: cs[40] - cs[39], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),











          Positioned(left: cs[5], top: rs[38], width: cs[6] - cs[5], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[38], width: cs[19] - cs[6], height: rs[42] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'customer_sign', label: 'Customer Signature', onSigned: (v) => setState(() => _customerSignBytes = v)))),







          Positioned(left: cs[26], top: rs[38], width: cs[27] - cs[26], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[27], top: rs[38], width: cs[40] - cs[27], height: rs[42] - rs[38], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2), bottom: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'staff_sign', label: 'Service Staff Signature', onSigned: (v) => setState(() => _staffSignBytes = v)))),











          Positioned(left: cs[5], top: rs[39], width: cs[6] - cs[5], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),







          Positioned(left: cs[26], top: rs[39], width: cs[27] - cs[26], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),











          Positioned(left: cs[5], top: rs[40], width: cs[6] - cs[5], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),







          Positioned(left: cs[26], top: rs[40], width: cs[27] - cs[26], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),











          Positioned(left: cs[5], top: rs[41], width: cs[6] - cs[5], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.bottomLeft, child: const SizedBox.shrink())),







          Positioned(left: cs[26], top: rs[41], width: cs[27] - cs[26], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(right: BorderSide(color: Color(0xFF000000), width: 2))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),

















          cell(11, 42, 16, 43, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Signature', softWrap: false, overflow: TextOverflow.visible),
              )),
















          cell(32, 42, 37, 43, pad: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), child: DefaultTextStyle.merge(
                style: TextStyle(fontFamily: 'Calibri', fontSize: 14.6, color: Color(0xFF000000)),
                child: Text('Signature', softWrap: false, overflow: TextOverflow.visible),
              )),

























































































































































































































































































































































































          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(
              painter: _TableGridPainter(
                colStarts: cs,
                rowStarts: rs,
                borderColor: Colors.black,
                borderWidth: 0.0,
                matrixData: matrixData,
                numRows: 51,
                numCols: 46,
              ),
            )),
          ),
        ],
      ),
    );
  },
),
);
}

// ============ HELPER CLASSES ============
// ── Text helpers ──────────────────────────────────────────────────────────────

Widget _t(String s, {double sz = 16, bool bold = false, bool italic = false, Color? color, String ff = 'Browallia New', TextAlign? align}) =>
    Text(s, style: TextStyle(fontFamily: ff, fontSize: sz, fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontStyle: italic ? FontStyle.italic : FontStyle.normal, color: color), softWrap: true, overflow: TextOverflow.clip, textAlign: align);

Widget _rt(List<(String, bool)> spans, {double sz = 16, String ff = 'Browallia New', TextAlign align = TextAlign.start}) =>
    RichText(softWrap: true, overflow: TextOverflow.clip, textAlign: align,
        text: TextSpan(style: TextStyle(fontFamily: ff, fontSize: sz),
            children: [for (final (t, b) in spans) TextSpan(text: t, style: b ? const TextStyle(fontWeight: FontWeight.bold) : null)]));

// ── Border helpers ────────────────────────────────────────────────────────────

const _bk = Colors.black;

class _TableGridPainter extends CustomPainter {
  final List<double> colStarts;
  final List<double> rowStarts;
  final Color borderColor;
  final double borderWidth;
  final List<List<int>> matrixData;
  final int numRows;
  final int numCols;

  const _TableGridPainter({
    required this.colStarts,
    required this.rowStarts,
    required this.borderColor,
    required this.borderWidth,
    required this.matrixData,
    required this.numRows,
    required this.numCols,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth == 0) return;
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        if (c >= colStarts.length - 1 || r >= rowStarts.length - 1) continue;
        final idx = (r < matrixData.length && c < matrixData[r].length)
            ? matrixData[r][c]
            : -1;
        if (idx < 0) continue;
        final sameAsLeft  = c > 0 && matrixData[r][c - 1] == idx;
        final sameAsAbove = r > 0 && matrixData[r - 1][c] == idx;
        if (sameAsLeft || sameAsAbove) continue;
        int endC = c + 1;
        while (endC < numCols && endC < matrixData[r].length && matrixData[r][endC] == idx) endC++;
        int endR = r + 1;
        while (endR < numRows && endR < matrixData.length && matrixData[endR][c] == idx) endR++;
        final right  = endC < colStarts.length ? colStarts[endC] : colStarts.last;
        final bottom = endR < rowStarts.length ? rowStarts[endR] : rowStarts.last;
        canvas.drawRect(Rect.fromLTRB(colStarts[c], rowStarts[r], right, bottom), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TableGridPainter old) =>
      old.borderColor != borderColor || old.borderWidth != borderWidth;
}

class _DashSide {
  final Color color;
  final double width;
  final bool dotted;
  final bool doubled;
  final String side;
  const _DashSide._(this.side, {required this.color, required this.width, this.dotted = false, this.doubled = false});
  const _DashSide.top({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('top', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.right({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('right', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.bottom({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('bottom', color: color, width: width, dotted: dotted, doubled: doubled);
  const _DashSide.left({required Color color, required double width, bool dotted = false, bool doubled = false}) : this._('left', color: color, width: width, dotted: dotted, doubled: doubled);
}

class _DashedBorderPainter extends CustomPainter {
  final List<_DashSide> sides;
  const _DashedBorderPainter({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sides) {
      if (s.doubled) {
        _drawDouble(canvas, s, size);
        continue;
      }
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = s.width
        ..style = PaintingStyle.stroke;
      final dashLen = s.dotted ? s.width : s.width * 3;
      final gapLen = s.dotted ? s.width * 2 : s.width * 3;
      switch (s.side) {
        case 'top':    _drawDash(canvas, paint, Offset.zero, Offset(size.width, 0), dashLen, gapLen); break;
        case 'bottom': _drawDash(canvas, paint, Offset(0, size.height), Offset(size.width, size.height), dashLen, gapLen); break;
        case 'left':   _drawDash(canvas, paint, Offset.zero, Offset(0, size.height), dashLen, gapLen); break;
        case 'right':  _drawDash(canvas, paint, Offset(size.width, 0), Offset(size.width, size.height), dashLen, gapLen); break;
      }
    }
  }

  // CSS "double": two parallel solid lines of thickness W/3 with a W/3 gap, drawn inside
  // the cell so total visual span equals the specified width W.
  void _drawDouble(Canvas canvas, _DashSide s, Size size) {
    final lineW = s.width / 3.0;
    final paint = Paint()
      ..color = s.color
      ..strokeWidth = lineW
      ..style = PaintingStyle.stroke;
    final outer = lineW / 2.0;         // stroke centerline of the outer line, from the edge
    final inner = s.width - lineW / 2.0; // stroke centerline of the inner line, from the edge
    switch (s.side) {
      case 'top':
        canvas.drawLine(Offset(0, outer), Offset(size.width, outer), paint);
        canvas.drawLine(Offset(0, inner), Offset(size.width, inner), paint);
        break;
      case 'bottom':
        canvas.drawLine(Offset(0, size.height - outer), Offset(size.width, size.height - outer), paint);
        canvas.drawLine(Offset(0, size.height - inner), Offset(size.width, size.height - inner), paint);
        break;
      case 'left':
        canvas.drawLine(Offset(outer, 0), Offset(outer, size.height), paint);
        canvas.drawLine(Offset(inner, 0), Offset(inner, size.height), paint);
        break;
      case 'right':
        canvas.drawLine(Offset(size.width - outer, 0), Offset(size.width - outer, size.height), paint);
        canvas.drawLine(Offset(size.width - inner, 0), Offset(size.width - inner, size.height), paint);
        break;
    }
  }

  void _drawDash(Canvas canvas, Paint paint, Offset start, Offset end, double dashLen, double gapLen) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final totalLen = math.sqrt(dx * dx + dy * dy);
    if (totalLen == 0) return;
    final ux = dx / totalLen;
    final uy = dy / totalLen;
    double pos = 0;
    bool draw = true;
    while (pos < totalLen) {
      final double seg = draw ? dashLen : gapLen;
      final double segEnd = (pos + seg).clamp(0.0, totalLen);
      if (draw) {
        canvas.drawLine(
          Offset(start.dx + ux * pos, start.dy + uy * pos),
          Offset(start.dx + ux * segEnd, start.dy + uy * segEnd),
          paint,
        );
      }
      pos = segEnd;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => true;
}