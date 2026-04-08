import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/article.dart';

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
      version: 1,
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

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('articles');
    await db.delete('sync_meta');
  }
}
