import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api/articles_api.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';
import '../models/article.dart';
import '../helpers/error_handler.dart';
import 'article_detail_screen.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final ArticlesApi _articlesApi = ArticlesApi();
  final SyncService _syncService = SyncService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;
  List<Article> _articles = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    ConnectivityService().removeListener(_onConnectivityChanged);
    super.dispose();
  }

  void _onConnectivityChanged() {
    if (ConnectivityService().isOnline) _syncAndReload();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _syncAndReload() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    await _syncService.syncFromServer();
    _currentPage = 1;
    _articles = [];
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

  Future<void> _loadMore() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;

    setState(() => _isLoadingMore = true);

    try {
      final nextPage = _currentPage + 1;
      final result = await _articlesApi.getArticles(
        page: nextPage,
        title: _searchController.text.isEmpty ? null : _searchController.text,
      );

      setState(() {
        _articles.addAll(List<Article>.from(result['articles']));
        _currentPage = nextPage;
        _totalPages = result['pages'] as int;
        _total = result['total'] as int;
      });
    } catch (_) {}
    finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _currentPage = 1;
        _articles = [];
        _loadArticles();
      }
    });
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
              onChanged: _onSearchChanged,
            ),
          ),
          if (_isLoading && _articles.isEmpty)
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
                        onPressed: _syncAndReload,
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
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _articles.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _articles.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
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
          if (_articles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${_articles.length} of $_total articles',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
        ],
      ),
    );
  }
}
