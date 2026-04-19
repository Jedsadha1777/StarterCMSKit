import 'package:flutter/foundation.dart';
import 'api/api_client.dart';
import 'local_db.dart';
import 'connectivity_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final LocalDb _localDb = LocalDb();
  final ApiClient _client = ApiClient();
  final ConnectivityService _connectivity = ConnectivityService();

  bool _isSyncing = false;

  Future<bool> syncFromServer() async {
    if (_isSyncing) return false;
    if (!_connectivity.isOnline) return false;

    _isSyncing = true;

    try {
      final lastSync = await _localDb.getLastSyncAt();
      return await _fetchPages(lastSync);
    } catch (e) {
      debugPrint('SyncService failed: $e');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  static const int _maxPages = 50;

  Future<bool> _fetchPages(String? since) async {
    String? cursor = since;
    int pageCount = 0;

    while (pageCount < _maxPages) {
      pageCount++;
      // ApiClient.get() handles token refresh + retry automatically
      final syncData = await _client.get<Map<String, dynamic>>(
        '/sync',
        (data) => data['sync'] as Map<String, dynamic>,
        queryParams: cursor != null ? {'since': cursor} : null,
        errorMessage: 'Sync failed',
        timeout: const Duration(seconds: 15),
      );

      final changes = syncData['changes']['articles'] as Map<String, dynamic>;

      final upserted = changes['upserted'] as List;
      final deleted = (changes['deleted'] as List).cast<String>();

      if (upserted.isNotEmpty) {
        await _localDb.upsertArticles(
          upserted.map((a) => a as Map<String, dynamic>).toList(),
        );
      }

      if (deleted.isNotEmpty) {
        await _localDb.deleteArticles(deleted);
      }

      if (syncData['has_more'] == true && syncData['next_cursor'] != null) {
        cursor = syncData['next_cursor'] as String;
      } else {
        await _localDb.setLastSyncAt(syncData['server_time'] as String);
        return true;
      }
    }
    return false;
  }

  Future<void> fullSync() async {
    // Reset cursor แทนที่จะลบข้อมูล → ถ้า sync fail ยังมีข้อมูลเก่าให้อ่าน
    await _localDb.resetSyncCursor();
    _isSyncing = false;
    await syncFromServer();
  }
}
