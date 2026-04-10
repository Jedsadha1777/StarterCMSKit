import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api/articles_api.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';
import '../models/article.dart';
import '../helpers/error_handler.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ArticlesApi _articlesApi = ArticlesApi();
  final SyncService _syncService = SyncService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  List<Article> _articles = [];
  bool _isLoading = false;
  bool _isSyncing = false;
  int _currentPage = 1;
  int _totalPages = 1;
  int _total = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadArticles();
    ConnectivityService().addListener(_onConnectivityChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    ConnectivityService().removeListener(_onConnectivityChanged);
    super.dispose();
  }

  void _onConnectivityChanged() {
    if (ConnectivityService().isOnline) _syncAndReload();
  }

  Future<void> _syncAndReload() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    await _syncService.syncFromServer();
    await _loadArticles();
    if (mounted) setState(() => _isSyncing = false);
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _articlesApi.getArticles(
        page: _currentPage,
        title: _searchController.text.isEmpty ? null : _searchController.text,
      );

      setState(() {
        _articles = List<Article>.from(result['articles']);
        _total = result['total'] as int;
        _currentPage = result['page'] as int;
        _totalPages = result['pages'] as int;
      });
    } catch (e) {
      if (mounted) {
        await handleAuthException(context, e,
            onApiError: (msg) => setState(() => _errorMessage = msg));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() => _currentPage++);
      _loadArticles();
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
      _loadArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
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
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    setState(() => _currentPage = 1);
                    _loadArticles();
                  }
                });
              },
            ),
          ),
          if (_isLoading)
            const Expanded(
                child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(_errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: _loadArticles,
                        child: const Text('Retry')),
                  ],
                ),
              ),
            )
          else if (_articles.isEmpty)
            const Expanded(child: Center(child: Text('No articles found')))
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _syncAndReload,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    final article = _articles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        title: Text(article.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(article.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Text(
                              'By ${article.authorEmail ?? 'Unknown'}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailScreen(
                                  articleId: article.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          if (!_isLoading && _articles.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border:
                    Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentPage > 1 ? _previousPage : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                  Text(
                    'Page $_currentPage of $_totalPages ($_total total)',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        _currentPage < _totalPages ? _nextPage : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
