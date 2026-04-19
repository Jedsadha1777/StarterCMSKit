import 'package:flutter/foundation.dart';
import 'api/api_client.dart';
import 'local_db.dart';
import 'connectivity_service.dart';

class MasterDataService {
  static final MasterDataService _instance = MasterDataService._internal();
  factory MasterDataService() => _instance;
  MasterDataService._internal();

  final ApiClient _api = ApiClient();
  final LocalDb _db = LocalDb();
  final ConnectivityService _connectivity = ConnectivityService();

  bool _syncing = false;

  Future<bool> syncAll() async {
    if (_syncing) return false;
    if (!_connectivity.isOnline) return false;

    _syncing = true;
    try {
      final data = await _api.get<Map<String, dynamic>>(
        '/master-data',
        (json) => json,
      );

      final machineModels = (data['machine_models'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [];
      final customers = (data['customers'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [];

      await _db.replaceAllMachineModels(machineModels);
      await _db.replaceAllCustomers(customers);

      return true;
    } catch (e) {
      debugPrint('MasterData sync failed: $e');
      return false;
    } finally {
      _syncing = false;
    }
  }
}
