import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class StorageMigration {
  static const String _flagFile = '.migration_v1_done';

  static Future<void> migrate() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final supportDir = await getApplicationSupportDirectory();
    final flagFile = File('${supportDir.path}/$_flagFile');

    final dbInDocs = File('${docsDir.path}/app_database.db').existsSync();

    if (!dbInDocs && flagFile.existsSync()) {
      return;
    }

    if (!dbInDocs && !flagFile.existsSync()) {
      debugPrint('[Migration] db already moved but flag missing, continue...');
    } else {
      debugPrint('[Migration] db found in Documents, migrating...');
    }

    int moved = 0;

    for (var entity in docsDir.listSync()) {
      if (entity is File) {
        final name = entity.uri.pathSegments.last;
        if (name.endsWith('_report.pdf')) continue;

        final destPath = '${supportDir.path}/$name';
        final dest = File(destPath);

        if (dest.existsSync()) {
          try { await entity.delete(); } catch (_) {}
          moved++;
          continue;
        }

        try {
          await entity.copy(destPath);
          if (dest.existsSync() &&
              dest.lengthSync() == entity.lengthSync()) {
            await entity.delete();
            moved++;
          }
        } catch (e) {
          debugPrint('[Migration] ERROR: $name -> $e');
        }
      }
    }

    await flagFile.create(recursive: true);
    debugPrint('[Migration] Done: moved=$moved, flag set');
  }
}