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
import 'dart:typed_data';
import 'form_widgets/form_widgets.dart';
import 'preview_shell.dart';

void main() => runApp(PreviewShell(pages: [FormWidget1()]));

class FormWidget1 extends StatefulWidget {
  const FormWidget1({super.key});
  @override
  State<FormWidget1> createState() => FormWidgetState1();
}

class FormWidgetState1 extends State<FormWidget1> {


  // ============ STATE VARIABLES ============
  bool _snapMode = false;
  final GlobalKey _captureKey = GlobalKey();

  Uint8List? _signatureFieldA70Bytes;
  Uint8List? _signatureFieldC70Bytes;
  Uint8List? _signatureFieldE70Bytes;
  Uint8List? _signatureFieldG70Bytes;

  InputDecoration get _inputDecoration => _snapMode
      ? const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4))
      : const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8));

  @override
  Widget build(BuildContext context) => RepaintBoundary(key: _captureKey, child: UnconstrainedBox(
  alignment: Alignment.topLeft,
  child: LayoutBuilder(
  builder: (context, constraints) {
    final availableWidth = constraints.maxWidth;

    final fixedTotal = 1030.0;
    final flexSpace = availableWidth.isInfinite ? 0.0 : (availableWidth - fixedTotal).clamp(0.0, double.infinity);
    final flexUnit = availableWidth.isInfinite ? 200.0 : flexSpace / 0.001000;
    final colWidths = <double>[
      84.0,
      190.0,
      174.0,
      94.0,
      94.0,
      126.0,
      110.0,
      158.0,
    ];

    final rowHeights = <double>[53.0, 24.0, 32.0, 20.0, 24.0, 32.0, 45.0, 32.0, 40.0, 24.0, 32.0, 32.0, 32.0, 32.0, 48.0, 48.0, 24.0, 45.0, 32.0, 32.0, 24.0, 27.0, 32.0, 32.0, 32.0, 32.0, 32.0, 32.0, 24.0, 32.0, 32.0, 32.0, 40.0, 24.0, 32.0, 64.0, 24.0, 24.0, 48.0, 24.0, 20.0, 27.0];

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
      <int>[0, 0, 0, 0, 0, 0, 0, 0],
      <int>[1, 2, 3, 4, 5, 6, 7, 8],
      <int>[9, 10, 11, 12, 13, 14, 15, 16],
      <int>[17, 18, 19, 20, 21, 22, 23, 24],
      <int>[25, 25, 25, 25, 25, 25, 25, 25],
      <int>[26, 27, 28, 29, 30, 31, 32, 33],
      <int>[34, 35, 35, 35, 36, 37, 37, 37],
      <int>[38, 39, 39, 39, 40, 41, 41, 41],
      <int>[42, 43, 43, 43, 43, 43, 43, 43],
      <int>[44, 44, 44, 44, 44, 44, 44, 44],
      <int>[45, 46, 46, 46, 47, 48, 48, 48],
      <int>[49, 50, 50, 50, 51, 52, 52, 52],
      <int>[53, 54, 55, 56, 56, 57, 58, 58],
      <int>[59, 60, 60, 60, 61, 62, 62, 62],
      <int>[63, 64, 64, 64, 64, 64, 64, 64],
      <int>[65, 66, 66, 66, 66, 66, 66, 66],
      <int>[67, 67, 67, 67, 67, 67, 67, 67],
      <int>[68, 69, 70, 71, 72, 73, 74, 75],
      <int>[76, 77, 77, 77, 78, 79, 79, 79],
      <int>[80, 81, 81, 81, 81, 81, 81, 81],
      <int>[82, 82, 82, 82, 82, 82, 82, 82],
      <int>[83, 84, 85, 86, 87, 88, 89, 90],
      <int>[91, 92, 93, 94, 95, 96, 97, 98],
      <int>[99, 100, 101, 102, 103, 104, 105, 106],
      <int>[107, 108, 109, 110, 111, 112, 113, 114],
      <int>[115, 116, 117, 118, 119, 120, 121, 122],
      <int>[123, 124, 125, 126, 127, 128, 129, 130],
      <int>[131, 132, 133, 134, 135, 136, 137, 138],
      <int>[139, 139, 139, 139, 139, 139, 139, 139],
      <int>[140, 141, 141, 141, 141, 141, 141, 141],
      <int>[142, 143, 143, 143, 143, 143, 143, 143],
      <int>[144, 145, 145, 145, 145, 145, 145, 145],
      <int>[146, 147, 147, 147, 147, 147, 147, 147],
      <int>[148, 148, 148, 148, 148, 148, 148, 148],
      <int>[149, 150, 150, 150, 150, 150, 150, 150],
      <int>[151, 152, 152, 152, 152, 152, 152, 152],
      <int>[153, 153, 153, 153, 153, 153, 153, 153],
      <int>[154, 154, 155, 155, 156, 156, 157, 157],
      <int>[158, 158, 159, 159, 160, 160, 161, 161],
      <int>[162, 162, 163, 163, 164, 164, 165, 165],
      <int>[166, 167, 168, 169, 170, 171, 172, 173],
      <int>[174, 174, 174, 174, 174, 174, 174, 174],
    ];

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(left: cs[0], top: rs[0], width: cs[8] - cs[0], height: rs[1] - rs[0], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(top: BorderSide(color: Color(0xFFCCCCCC), width: 1), right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('PROTOTYPE REQUEST', bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[1], width: cs[1] - cs[0], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Document No.', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[1], width: cs[2] - cs[1], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('PTR-XXXXXX', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[2], top: rs[1], width: cs[3] - cs[2], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Version', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[3], top: rs[1], width: cs[4] - cs[3], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Rev.01', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[4], top: rs[1], width: cs[5] - cs[4], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Issue Date', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[5], top: rs[1], width: cs[6] - cs[5], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[6], top: rs[1], width: cs[7] - cs[6], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Dept.', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[7], top: rs[1], width: cs[8] - cs[7], height: rs[2] - rs[1], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('R&D → Manufacturing', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[2], width: cs[1] - cs[0], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Prepared by', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[2], width: cs[2] - cs[1], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Name / Signature', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[2], top: rs[2], width: cs[3] - cs[2], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Reviewed by', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[3], top: rs[2], width: cs[4] - cs[3], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Name / Signature', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[4], top: rs[2], width: cs[5] - cs[4], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Approved by', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[5], top: rs[2], width: cs[6] - cs[5], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Name / Signature', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[6], top: rs[2], width: cs[7] - cs[6], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Status', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[7], top: rs[2], width: cs[8] - cs[7], height: rs[3] - rs[2], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, color: Color(0xFF64748B)),
                  children: [
                    TextSpan(text: 'Draft / Under Review /'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Approved'),
                  ],
                ),
              ))),
          Positioned(left: cs[0], top: rs[3], width: cs[1] - cs[0], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[3], width: cs[2] - cs[1], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[3], width: cs[3] - cs[2], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[3], width: cs[4] - cs[3], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[3], width: cs[5] - cs[4], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[3], width: cs[6] - cs[5], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[3], width: cs[7] - cs[6], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[3], width: cs[8] - cs[7], height: rs[4] - rs[3], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[4], width: cs[8] - cs[0], height: rs[5] - rs[4], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('1. REQUEST INFORMATION', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[5], width: cs[1] - cs[0], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Request No.', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[5], width: cs[2] - cs[1], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('PTR-XXXXXX', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[2], top: rs[5], width: cs[3] - cs[2], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Request Date', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[3], top: rs[5], width: cs[4] - cs[3], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[4], top: rs[5], width: cs[5] - cs[4], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Required'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Completion'),
                  ],
                ),
              ))),
          Positioned(left: cs[5], top: rs[5], width: cs[6] - cs[5], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[6], top: rs[5], width: cs[7] - cs[6], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Priority', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[7], top: rs[5], width: cs[8] - cs[7], height: rs[6] - rs[5], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('□ Normal □ Urgent □ Critical', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[6], width: cs[1] - cs[0], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Project / Model'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Name'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[6], width: cs[4] - cs[1], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[6], width: cs[5] - cs[4], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Ref. Prototype'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Report No.'),
                  ],
                ),
              ))),
          Positioned(left: cs[5], top: rs[6], width: cs[8] - cs[5], height: rs[7] - rs[6], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('PTR-RPT-XXXXXX', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[7], width: cs[1] - cs[0], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Requested by'),
                    TextSpan(text: '\n'),
                    TextSpan(text: '(R&D)'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[7], width: cs[4] - cs[1], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[7], width: cs[5] - cs[4], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Manufacturing'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Line / Area'),
                  ],
                ),
              ))),
          Positioned(left: cs[5], top: rs[7], width: cs[8] - cs[5], height: rs[8] - rs[7], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[8], width: cs[1] - cs[0], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Prototype'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Purpose'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[8], width: cs[8] - cs[1], height: rs[9] - rs[8], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('□ Design Verification □ Functional Test □ Dimensional Check □ Customer Sample □ Durability Test □ Other: ___', sz: 10.6, color: Color(0xFF1E293B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[9], width: cs[8] - cs[0], height: rs[10] - rs[9], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('2. PROTOTYPE SPECIFICATION', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[10], width: cs[1] - cs[0], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Part Name', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[10], width: cs[4] - cs[1], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[10], width: cs[5] - cs[4], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Part No. /'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Drawing No.'),
                  ],
                ),
              ))),
          Positioned(left: cs[5], top: rs[10], width: cs[8] - cs[5], height: rs[11] - rs[10], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[11], width: cs[1] - cs[0], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Material', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[11], width: cs[4] - cs[1], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('e.g. SUS304, A6061-T6, Nylon PA66', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[4], top: rs[11], width: cs[5] - cs[4], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Surface'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Treatment'),
                  ],
                ),
              ))),
          Positioned(left: cs[5], top: rs[11], width: cs[8] - cs[5], height: rs[12] - rs[11], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('e.g. Anodize, Chrome plating, Powder coat, None', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[12], width: cs[1] - cs[0], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Dimensions'),
                    TextSpan(text: '\n'),
                    TextSpan(text: '(mm)'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[12], width: cs[2] - cs[1], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('W:', sz: 10.6, color: Color(0xFF1E293B), ff: 'Arial'))),
          Positioned(left: cs[2], top: rs[12], width: cs[3] - cs[2], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('H:', sz: 10.6, color: Color(0xFF1E293B), ff: 'Arial'))),
          Positioned(left: cs[3], top: rs[12], width: cs[5] - cs[3], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('D / Dia.:', sz: 10.6, color: Color(0xFF1E293B), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[5], top: rs[12], width: cs[6] - cs[5], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Weight (g/kg)', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[6], top: rs[12], width: cs[8] - cs[6], height: rs[13] - rs[12], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[13], width: cs[1] - cs[0], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Color /'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Appearance'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[13], width: cs[4] - cs[1], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('e.g. Natural, Black, Custom color code', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[4], top: rs[13], width: cs[5] - cs[4], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Drawing'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Revision'),
                  ],
                ),
              ))),
          Positioned(left: cs[5], top: rs[13], width: cs[8] - cs[5], height: rs[14] - rs[13], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Rev. ___ / Date: ___', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[14], width: cs[1] - cs[0], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Key', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Dimensional', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Tolerances', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[14], width: cs[8] - cs[1], height: rs[15] - rs[14], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('List critical dimensions and tolerances from drawing (e.g. Ø10.00 ±0.02 mm)', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[15], width: cs[1] - cs[0], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Special', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Process', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Requirements', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[15], width: cs[8] - cs[1], height: rs[16] - rs[15], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('e.g. Heat treatment, Press fitting, Welding process, Specific torque value', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[16], width: cs[8] - cs[0], height: rs[17] - rs[16], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('3. QUANTITY & SCHEDULE', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[17], width: cs[1] - cs[0], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Qty Required', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[17], width: cs[2] - cs[1], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[17], width: cs[3] - cs[2], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Unit', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[3], top: rs[17], width: cs[4] - cs[3], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('pc / set / lot', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[4], top: rs[17], width: cs[5] - cs[4], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Additional Spare'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Qty'),
                  ],
                ),
              ))),
          Positioned(left: cs[5], top: rs[17], width: cs[6] - cs[5], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[17], width: cs[7] - cs[6], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Total Qty to'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Produce'),
                  ],
                ),
              ))),
          Positioned(left: cs[7], top: rs[17], width: cs[8] - cs[7], height: rs[18] - rs[17], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('undefined', sz: 10.6, bold: true, color: Color(0xFF1E293B), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[18], width: cs[1] - cs[0], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Production'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Start Date'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[18], width: cs[4] - cs[1], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[4], top: rs[18], width: cs[5] - cs[4], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Prototype Due'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Date'),
                  ],
                ),
              ))),
          Positioned(left: cs[5], top: rs[18], width: cs[8] - cs[5], height: rs[19] - rs[18], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[19], width: cs[1] - cs[0], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Delivery'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Location'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[19], width: cs[8] - cs[1], height: rs[20] - rs[19], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('e.g. R&D Lab Room 3 / Quality Lab / Customer site', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[20], width: cs[8] - cs[0], height: rs[21] - rs[20], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('4. MATERIALS / COMPONENTS PROVIDED BY R&D', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[21], width: cs[1] - cs[0], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('#', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[21], width: cs[2] - cs[1], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Material / Component Name', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[2], top: rs[21], width: cs[3] - cs[2], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Specification / Grade', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[3], top: rs[21], width: cs[4] - cs[3], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Qty', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[4], top: rs[21], width: cs[5] - cs[4], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Unit', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[5], top: rs[21], width: cs[6] - cs[5], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Lot No. / Batch', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[6], top: rs[21], width: cs[7] - cs[6], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Provided by', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[7], top: rs[21], width: cs[8] - cs[7], height: rs[22] - rs[21], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Remarks', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[22], width: cs[1] - cs[0], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('1', sz: 10.6, bold: true, color: Color(0xFF64748B), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[22], width: cs[2] - cs[1], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[22], width: cs[3] - cs[2], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[22], width: cs[4] - cs[3], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[22], width: cs[5] - cs[4], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('pc/kg/L', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[5], top: rs[22], width: cs[6] - cs[5], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[22], width: cs[7] - cs[6], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, color: Color(0xFF64748B)),
                  children: [
                    TextSpan(text: '□ R&D □ Mfg. □'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Purchasing'),
                  ],
                ),
              ))),
          Positioned(left: cs[7], top: rs[22], width: cs[8] - cs[7], height: rs[23] - rs[22], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[23], width: cs[1] - cs[0], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('2', sz: 10.6, bold: true, color: Color(0xFF64748B), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[23], width: cs[2] - cs[1], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[23], width: cs[3] - cs[2], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[23], width: cs[4] - cs[3], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[23], width: cs[5] - cs[4], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('pc/kg/L', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[5], top: rs[23], width: cs[6] - cs[5], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[23], width: cs[7] - cs[6], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, color: Color(0xFF64748B)),
                  children: [
                    TextSpan(text: '□ R&D □ Mfg. □'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Purchasing'),
                  ],
                ),
              ))),
          Positioned(left: cs[7], top: rs[23], width: cs[8] - cs[7], height: rs[24] - rs[23], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[24], width: cs[1] - cs[0], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('3', sz: 10.6, bold: true, color: Color(0xFF64748B), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[24], width: cs[2] - cs[1], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[24], width: cs[3] - cs[2], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[24], width: cs[4] - cs[3], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[24], width: cs[5] - cs[4], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('pc/kg/L', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[5], top: rs[24], width: cs[6] - cs[5], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[24], width: cs[7] - cs[6], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, color: Color(0xFF64748B)),
                  children: [
                    TextSpan(text: '□ R&D □ Mfg. □'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Purchasing'),
                  ],
                ),
              ))),
          Positioned(left: cs[7], top: rs[24], width: cs[8] - cs[7], height: rs[25] - rs[24], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[25], width: cs[1] - cs[0], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('4', sz: 10.6, bold: true, color: Color(0xFF64748B), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[25], width: cs[2] - cs[1], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[25], width: cs[3] - cs[2], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[25], width: cs[4] - cs[3], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[25], width: cs[5] - cs[4], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('pc/kg/L', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[5], top: rs[25], width: cs[6] - cs[5], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[25], width: cs[7] - cs[6], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, color: Color(0xFF64748B)),
                  children: [
                    TextSpan(text: '□ R&D □ Mfg. □'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Purchasing'),
                  ],
                ),
              ))),
          Positioned(left: cs[7], top: rs[25], width: cs[8] - cs[7], height: rs[26] - rs[25], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[26], width: cs[1] - cs[0], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('5', sz: 10.6, bold: true, color: Color(0xFF64748B), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[26], width: cs[2] - cs[1], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[26], width: cs[3] - cs[2], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[26], width: cs[4] - cs[3], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[26], width: cs[5] - cs[4], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('pc/kg/L', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[5], top: rs[26], width: cs[6] - cs[5], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[26], width: cs[7] - cs[6], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, color: Color(0xFF64748B)),
                  children: [
                    TextSpan(text: '□ R&D □ Mfg. □'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Purchasing'),
                  ],
                ),
              ))),
          Positioned(left: cs[7], top: rs[26], width: cs[8] - cs[7], height: rs[27] - rs[26], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[27], width: cs[1] - cs[0], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('6', sz: 10.6, bold: true, color: Color(0xFF64748B), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[1], top: rs[27], width: cs[2] - cs[1], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[27], width: cs[3] - cs[2], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[27], width: cs[4] - cs[3], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[27], width: cs[5] - cs[4], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('pc/kg/L', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[5], top: rs[27], width: cs[6] - cs[5], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[27], width: cs[7] - cs[6], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, color: Color(0xFF64748B)),
                  children: [
                    TextSpan(text: '□ R&D □ Mfg. □'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Purchasing'),
                  ],
                ),
              ))),
          Positioned(left: cs[7], top: rs[27], width: cs[8] - cs[7], height: rs[28] - rs[27], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFFFFFF), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[28], width: cs[8] - cs[0], height: rs[29] - rs[28], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('5. INSPECTION & ACCEPTANCE CRITERIA', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[29], width: cs[1] - cs[0], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Inspection'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Type'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[29], width: cs[8] - cs[1], height: rs[30] - rs[29], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('□ Dimensional □ Visual □ Functional □ Material Analysis □ Full Inspection', sz: 10.6, color: Color(0xFF1E293B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[30], width: cs[1] - cs[0], height: rs[31] - rs[30], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Acceptance'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Standard'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[30], width: cs[8] - cs[1], height: rs[31] - rs[30], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('e.g. Per drawing Rev.X / JISB0401 tolerance class IT7', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[31], width: cs[1] - cs[0], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Who Performs', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Inspection', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[31], width: cs[8] - cs[1], height: rs[32] - rs[31], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('□ R&D Engineer □ QA/QC □ Manufacturing □ Third Party', sz: 10.6, color: Color(0xFF1E293B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[32], width: cs[1] - cs[0], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Report'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Required'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[32], width: cs[8] - cs[1], height: rs[33] - rs[32], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('□ Dimensional Report □ Prototype Test Report □ PPAP □ Sample Approval Form □ None', sz: 10.6, color: Color(0xFF1E293B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[33], width: cs[8] - cs[0], height: rs[34] - rs[33], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('6. ADDITIONAL NOTES & REFERENCE DOCUMENTS', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[34], width: cs[1] - cs[0], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Reference'),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Documents'),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[34], width: cs[8] - cs[1], height: rs[35] - rs[34], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('□ Drawing attached □ Prototype Report attached □ 3D CAD file attached □ Spec sheet attached', sz: 10.6, color: Color(0xFF1E293B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[35], width: cs[1] - cs[0], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Color(0xFF0F2044), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: RichText(
                softWrap: true,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Arial', fontSize: 10.6, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  children: [
                    TextSpan(text: 'Special', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                    TextSpan(text: '\n'),
                    TextSpan(text: 'Instructions', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                    TextSpan(text: '\n'),
                    TextSpan(text: '/ Notes', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF), fontSize: 10.6, fontFamily: 'Arial')),
                  ],
                ),
              ))),
          Positioned(left: cs[1], top: rs[35], width: cs[8] - cs[1], height: rs[36] - rs[35], child: Container(
              decoration: BoxDecoration(color: Color(0xFFFEF9C3), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[36], width: cs[8] - cs[0], height: rs[37] - rs[36], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('7. APPROVAL', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[37], width: cs[2] - cs[0], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('R&D Engineer', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[2], top: rs[37], width: cs[4] - cs[2], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('R&D Section Chief', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[4], top: rs[37], width: cs[6] - cs[4], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('Manufacturing Mgr.', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[6], top: rs[37], width: cs[8] - cs[6], height: rs[38] - rs[37], child: Container(
              decoration: BoxDecoration(color: Color(0xFF002060), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.center, child: _t('QA / QC', sz: 10.6, bold: true, color: Color(0xFFFFFFFF), ff: 'Arial', align: TextAlign.center))),
          Positioned(left: cs[0], top: rs[38], width: cs[2] - cs[0], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1), border: Border(right: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1), bottom: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1), left: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'signature-field-A70', label: 'signature R&D Engineer', onSigned: (v) => setState(() => _signatureFieldA70Bytes = v)))),
          Positioned(left: cs[2], top: rs[38], width: cs[4] - cs[2], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1), border: Border(right: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1), bottom: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'signature-field-C70', label: 'R&D Section Chief', onSigned: (v) => setState(() => _signatureFieldC70Bytes = v)))),
          Positioned(left: cs[4], top: rs[38], width: cs[6] - cs[4], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1), border: Border(right: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1), bottom: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'signature-field-E70', label: 'R&D Manager / Director', onSigned: (v) => setState(() => _signatureFieldE70Bytes = v)))),
          Positioned(left: cs[6], top: rs[38], width: cs[8] - cs[6], height: rs[39] - rs[38], child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1), border: Border(right: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1), bottom: BorderSide(color: Color.fromRGBO(153, 153, 153, 1), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: FormSignature(name: 'signature-field-G70', label: 'QA / QC', onSigned: (v) => setState(() => _signatureFieldG70Bytes = v)))),
          Positioned(left: cs[0], top: rs[39], width: cs[2] - cs[0], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1), left: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Date: YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[2], top: rs[39], width: cs[4] - cs[2], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Date: YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[4], top: rs[39], width: cs[6] - cs[4], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Date: YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[6], top: rs[39], width: cs[8] - cs[6], height: rs[40] - rs[39], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFF999999), width: 1), bottom: BorderSide(color: Color(0xFF999999), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('Date: YYYY-MM-DD', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned(left: cs[0], top: rs[40], width: cs[1] - cs[0], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[1], top: rs[40], width: cs[2] - cs[1], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[2], top: rs[40], width: cs[3] - cs[2], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[3], top: rs[40], width: cs[4] - cs[3], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[4], top: rs[40], width: cs[5] - cs[4], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[5], top: rs[40], width: cs[6] - cs[5], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[6], top: rs[40], width: cs[7] - cs[6], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[7], top: rs[40], width: cs[8] - cs[7], height: rs[41] - rs[40], child: Container(
              decoration: BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: const SizedBox.shrink())),
          Positioned(left: cs[0], top: rs[41], width: cs[8] - cs[0], height: rs[42] - rs[41], child: Container(
              decoration: BoxDecoration(color: Color(0xFFF1F5F9), border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 1), bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1), left: BorderSide(color: Color(0xFFCCCCCC), width: 1))),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0), alignment: Alignment.centerLeft, child: _t('※ Attach drawing (latest revision) + Prototype Report before submission. PTR is invalid without referenced Prototype Report No.', sz: 10.6, italic: true, color: Color(0xFF64748B), ff: 'Arial'))),
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(
              painter: _TableGridPainter(
                colStarts: cs,
                rowStarts: rs,
                borderColor: Colors.black,
                borderWidth: 0.0,
                matrixData: matrixData,
                numRows: 42,
                numCols: 8,
              ),
            )),
          ),
        ],
      ),
    );
  },
),
));
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