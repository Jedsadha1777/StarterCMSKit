import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'local_db.dart';

class AppSettings extends ChangeNotifier {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  String _dateFormat = 'YYYY-MM-DD';
  String get dateFormat => _dateFormat;

  Future<void> load() async {
    final db = await LocalDb().database;
    final rows = await db.query('sync_meta', where: "key = 'date_format'");
    if (rows.isNotEmpty) {
      _dateFormat = rows.first['value'] as String;
      notifyListeners();
    }
  }

  Future<void> setDateFormat(String fmt) async {
    if (_dateFormat == fmt) return;
    _dateFormat = fmt;
    final db = await LocalDb().database;
    await db.insert(
      'sync_meta',
      {'key': 'date_format', 'value': fmt},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  /// Format ISO date (YYYY-MM-DD) → display string ตาม dateFormat
  String formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final parts = iso.split('-');
    if (parts.length != 3) return iso;
    final y = parts[0], m = parts[1], d = parts[2];
    return _dateFormat.replaceAll('YYYY', y).replaceAll('MM', m).replaceAll('DD', d);
  }

  /// Parse UTC ISO timestamp → Bangkok time (+7) → format ตาม dateFormat + HH:mm
  String formatDateTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      var s = iso;
      if (!s.endsWith('Z') && !s.contains('+') && !s.contains('-', 10)) {
        s = '${s}Z';
      }
      final utc = DateTime.parse(s);
      final bkk = utc.toUtc().add(const Duration(hours: 7));
      final y = bkk.year.toString();
      final m = bkk.month.toString().padLeft(2, '0');
      final d = bkk.day.toString().padLeft(2, '0');
      final hh = bkk.hour.toString().padLeft(2, '0');
      final mm = bkk.minute.toString().padLeft(2, '0');
      final dateStr = _dateFormat.replaceAll('YYYY', y).replaceAll('MM', m).replaceAll('DD', d);
      return '$dateStr $hh:$mm';
    } catch (_) {
      return iso;
    }
  }
}
