import 'dart:convert';
import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/article.dart';

dynamic _safeDecode(String? json, dynamic fallback) {
  if (json == null) return fallback;
  try { return jsonDecode(json); } catch (_) { return fallback; }
}

class LocalDb {
  static final LocalDb _instance = LocalDb._internal();
  factory LocalDb() => _instance;
  LocalDb._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_cache.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE articles (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            author_id TEXT,
            author_email TEXT,
            status TEXT NOT NULL DEFAULT 'draft',
            publish_date TEXT,
            version INTEGER NOT NULL DEFAULT 1,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE sync_meta (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');

        await _createV2Tables(db);
        await _upgradeToV3(db); // safe — check column exists ก่อน ADD
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createV2Tables(db);
        }
        if (oldVersion < 3) {
          await _upgradeToV3(db);
        }
      },
    );
  }

  // ==================== Articles ====================

  Future<void> upsertArticles(List<Map<String, dynamic>> articles) async {
    final db = await database;
    final batch = db.batch();

    for (final a in articles) {
      batch.insert(
        'articles',
        {
          'id': a['id'],
          'title': a['title'],
          'content': a['content'],
          'author_id': a['author_id'],
          'author_email': a['author_email'],
          'status': a['status'] ?? 'draft',
          'publish_date': a['publish_date'],
          'version': a['version'] ?? 1,
          'created_at': a['created_at'],
          'updated_at': a['updated_at'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteArticles(List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await database;
    final placeholders = ids.map((_) => '?').join(',');
    await db.delete('articles', where: 'id IN ($placeholders)', whereArgs: ids);
  }

  Future<List<Article>> getArticles({String? search, int page = 1, int perPage = 10}) async {
    final db = await database;
    final offset = (page - 1) * perPage;

    String? where;
    List<dynamic>? whereArgs;

    if (search != null && search.isNotEmpty) {
      where = 'title LIKE ? OR content LIKE ?';
      whereArgs = ['%$search%', '%$search%'];
    }

    final rows = await db.query(
      'articles',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'updated_at DESC',
      limit: perPage,
      offset: offset,
    );

    return rows.map((r) => Article.fromJson(r)).toList();
  }

  Future<Article?> getArticle(String id) async {
    final db = await database;
    final rows = await db.query('articles', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Article.fromJson(rows.first);
  }

  Future<int> getArticleCount({String? search}) async {
    final db = await database;
    String sql = 'SELECT COUNT(*) as count FROM articles';
    List<dynamic>? args;

    if (search != null && search.isNotEmpty) {
      sql += ' WHERE title LIKE ? OR content LIKE ?';
      args = ['%$search%', '%$search%'];
    }

    final result = await db.rawQuery(sql, args);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== Sync Meta ====================

  Future<String?> getLastSyncAt() async {
    final db = await database;
    final rows = await db.query('sync_meta', where: "key = 'last_sync_at'");
    if (rows.isEmpty) return null;
    return rows.first['value'] as String;
  }

  Future<void> setLastSyncAt(String timestamp) async {
    final db = await database;
    await db.insert(
      'sync_meta',
      {'key': 'last_sync_at', 'value': timestamp},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> resetSyncCursor() async {
    final db = await database;
    await db.delete('sync_meta', where: "key = 'last_sync_at'");
  }

  // ==================== V2 Table Creation ====================

  static Future<void> _createV2Tables(Database db) async {
    // Cache: machine models (inspection_items stored as JSON string — load whole record, parse in Dart)
    await db.execute('''
      CREATE TABLE cached_machine_models (
        id TEXT PRIMARY KEY,
        model_code TEXT NOT NULL,
        model_name TEXT NOT NULL,
        inspection_items TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cached_customers (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        name TEXT NOT NULL,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE report_drafts (
        draft_id TEXT PRIMARY KEY,
        machine_model_id TEXT,
        report_no TEXT,
        report_public_id TEXT,
        form_data TEXT NOT NULL,
        pdf_data BLOB,
        status TEXT NOT NULL DEFAULT 'draft',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _upgradeToV3(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(report_drafts)');
    final columnNames = columns.map((c) => c['name'] as String).toSet();
    if (!columnNames.contains('pdf_data')) {
      await db.execute('ALTER TABLE report_drafts ADD COLUMN pdf_data BLOB');
    }
    if (!columnNames.contains('report_public_id')) {
      await db.execute('ALTER TABLE report_drafts ADD COLUMN report_public_id TEXT');
    }
  }

  // ==================== Machine Models Cache ====================

  Future<void> replaceAllMachineModels(List<Map<String, dynamic>> models) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('cached_machine_models');
      for (final m in models) {
        await txn.insert('cached_machine_models', {
          'id': m['id'],
          'model_code': m['model_code'],
          'model_name': m['model_name'],
          'inspection_items': jsonEncode(m['inspection_items'] ?? []),
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> getMachineModels() async {
    final db = await database;
    final rows = await db.query('cached_machine_models');
    return rows.map((r) => {
      ...r,
      'inspection_items': _safeDecode(r['inspection_items'] as String?, []),
    }).toList();
  }

  Future<Map<String, dynamic>?> getMachineModelDetail(String id) async {
    final db = await database;
    final rows = await db.query('cached_machine_models', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    final r = rows.first;
    return {
      ...r,
      'inspection_items': _safeDecode(r['inspection_items'] as String?, []),
    };
  }

  // ==================== Customers Cache ====================

  Future<void> replaceAllCustomers(List<Map<String, dynamic>> customers) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('cached_customers');
      for (final c in customers) {
        await txn.insert('cached_customers', {
          'id': c['id'],
          'customer_id': c['customer_id'],
          'name': c['name'],
          'address': c['address'] ?? '',
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final db = await database;
    return await db.query('cached_customers', orderBy: 'name ASC');
  }

  // ==================== Report Drafts ====================

  Future<void> saveDraft({
    required String draftId,
    required String machineModelId,
    required Map<String, dynamic> formData,
  }) async {
    final db = await database;
    final now = DateTime.now().toUtc().toIso8601String();
    await db.insert(
      'report_drafts',
      {
        'draft_id': draftId,
        'machine_model_id': machineModelId,
        'form_data': jsonEncode(formData),
        'status': 'draft',
        'created_at': now,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> loadDraft(String draftId) async {
    final db = await database;
    final rows = await db.query('report_drafts', where: 'draft_id = ?', whereArgs: [draftId]);
    if (rows.isEmpty) return null;
    final r = rows.first;
    return {
      ...r,
      'form_data': _safeDecode(r['form_data'] as String?, {}),
    };
  }

  Future<List<Map<String, dynamic>>> listDrafts() async {
    final db = await database;
    final rows = await db.query('report_drafts', where: "status = 'draft'", orderBy: 'updated_at DESC');
    return rows.map((r) => {
      ...r,
      'form_data': _safeDecode(r['form_data'] as String?, {}),
    }).toList();
  }

  Future<void> deleteDraft(String draftId) async {
    final db = await database;
    await db.delete('report_drafts', where: 'draft_id = ?', whereArgs: [draftId]);
  }

  Future<void> updateDraftStatus(String draftId, String status, {String? reportNo, String? reportPublicId}) async {
    final db = await database;
    final updates = <String, dynamic>{
      'status': status,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
    if (reportNo != null) updates['report_no'] = reportNo;
    if (reportPublicId != null) updates['report_public_id'] = reportPublicId;
    await db.update('report_drafts', updates, where: 'draft_id = ?', whereArgs: [draftId]);
  }

  Future<void> savePdfData(String draftId, Uint8List pdfData) async {
    final db = await database;
    await db.update('report_drafts', {
      'pdf_data': pdfData,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, where: 'draft_id = ?', whereArgs: [draftId]);
  }

  Future<void> clearPdfData(String draftId) async {
    final db = await database;
    await db.update('report_drafts', {
      'pdf_data': null,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, where: 'draft_id = ?', whereArgs: [draftId]);
  }

  Future<Map<String, dynamic>?> getDraftByReportId(String reportPublicId) async {
    final db = await database;
    final rows = await db.query('report_drafts',
      where: 'report_public_id = ?', whereArgs: [reportPublicId]);
    if (rows.isEmpty) return null;
    return rows.first;
  }

  // ==================== Clear All ====================

  Future<void> clearAll() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('articles');
      await txn.delete('sync_meta');
      await txn.delete('cached_machine_models');
      await txn.delete('cached_customers');
      await txn.delete('report_drafts');
    });
  }
}
