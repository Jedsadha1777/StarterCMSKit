import '../../models/article.dart';
import '../../exceptions/api_exceptions.dart';
import '../local_db.dart';
import '../sync_service.dart';
import '../connectivity_service.dart';
import 'api_client.dart';

class ArticlesApi {
  final ApiClient _client = ApiClient();
  final LocalDb _localDb = LocalDb();
  final SyncService _syncService = SyncService();
  final ConnectivityService _connectivity = ConnectivityService();

  Future<Map<String, dynamic>> getArticles({
    int page = 1,
    int perPage = 10,
    String? title,
    String? content,
  }) async {
    // Online → sync แล้วอ่านจาก local DB
    if (_connectivity.isOnline) {
      await _syncService.syncFromServer();
    }

    final search = title ?? content;
    final articles = await _localDb.getArticles(
      search: search,
      page: page,
      perPage: perPage,
    );
    final total = await _localDb.getArticleCount(search: search);
    final pages = (total / perPage).ceil().clamp(1, double.infinity).toInt();

    return {
      'articles': articles,
      'total': total,
      'page': page,
      'pages': pages,
      'per_page': perPage,
    };
  }

  Future<Article> getArticle(String id) async {
    // Try local first
    final local = await _localDb.getArticle(id);

    if (_connectivity.isOnline) {
      try {
        final remote = await _client.get(
          '/articles/$id',
          (data) => Article.fromJson(data),
          errorMessage: 'Failed to load article',
          statusMessages: {404: 'Article not found'},
        );
        // Update local cache
        await _localDb.upsertArticles([{
          'id': remote.id,
          'title': remote.title,
          'content': remote.content,
          'author_id': remote.authorId,
          'author_email': remote.authorEmail,
          'status': remote.status,
          'publish_date': remote.publishDate,
          'version': remote.version,
          'created_at': remote.createdAt,
          'updated_at': remote.updatedAt,
        }]);
        return remote;
      } catch (_) {
        if (local != null) return local;
        rethrow;
      }
    }

    if (local != null) return local;
    throw ApiException('Article not found (offline)');
  }
}
