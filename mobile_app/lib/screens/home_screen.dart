import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';
import '../services/master_data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SyncService _syncService = SyncService();
  final MasterDataService _masterDataService = MasterDataService();
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _syncAll();
    ConnectivityService().addListener(_onConnectivityChanged);
  }

  @override
  void dispose() {
    ConnectivityService().removeListener(_onConnectivityChanged);
    super.dispose();
  }

  void _onConnectivityChanged() {
    if (ConnectivityService().isOnline) _syncAll();
  }

  Future<void> _syncAll() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    await Future.wait([
      _syncService.syncFromServer(),
      _masterDataService.syncAll(),
    ]);
    if (mounted) setState(() => _isSyncing = false);
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityService>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Home'),
            const SizedBox(width: 8),
            Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              size: 16,
              color: isOnline ? Colors.greenAccent : Colors.grey,
            ),
          ],
        ),
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Resync',
            onPressed: _isSyncing ? null : _syncAll,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Image.asset('assets/logo.png', height: 64),
            const SizedBox(height: 32),
            _menuButton(
              icon: Icons.assessment,
              label: 'Report',
              onPressed: () => Navigator.pushNamed(context, '/model-selection'),
            ),
            const SizedBox(height: 16),
            _menuButton(
              icon: Icons.assignment,
              label: 'Report 2',
              onPressed: () => Navigator.pushNamed(context, '/model-selection', arguments: {'target': '/report2'}),
            ),
            const SizedBox(height: 16),
            _menuButton(
              icon: Icons.edit_document,
              label: 'Report Draft',
              onPressed: () => Navigator.pushNamed(context, '/report-draft'),
            ),
            const SizedBox(height: 16),
            _menuButton(
              icon: Icons.history,
              label: 'Report History',
              onPressed: () => Navigator.pushNamed(context, '/report-history'),
            ),
            const SizedBox(height: 16),
            _menuButton(
              icon: Icons.newspaper,
              label: 'Articles',
              onPressed: () => Navigator.pushNamed(context, '/articles'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
