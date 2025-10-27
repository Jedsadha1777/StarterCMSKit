import '../../models/article.dart';
import 'api_client.dart';
import '../../exceptions/api_exceptions.dart';

class ArticlesApi {
  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getArticles({
    int page = 1,
    int perPage = 10,
    String? title,
    String? content,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'per_page': perPage.toString(),
      if (title != null && title.isNotEmpty) 'title': title,
      if (content != null && content.isNotEmpty) 'content': content,
    };

    return await _client.get(
      '/articles',
      (data) {
        if (data['articles'] == null) {
          throw ApiException('Invalid response: missing articles');
        }
        
        return {
          'articles': (data['articles'] as List)
              .map((json) => Article.fromJson(json))
              .toList(),
          'total': _client.safeParseInt(data['total']),
          'page': _client.safeParseInt(data['page'], defaultValue: 1),
          'pages': _client.safeParseInt(data['pages'], defaultValue: 1),
          'per_page': _client.safeParseInt(data['per_page'], defaultValue: 10),
        };
      },
      queryParams: queryParams,
      errorMessage: 'Failed to load articles',
      timeout: const Duration(seconds: 15),
    );
  }

  Future<Article> getArticle(int id) async {
    return await _client.get(
      '/articles/$id',
      (data) => Article.fromJson(data),
      errorMessage: 'Failed to load article',
      statusMessages: {
        404: 'Article not found',
      },
    );
  }

  // Future<Article> createArticle(String title, String content) async {
  //   return await _client.post(
  //     '/articles',
  //     (data) => Article.fromJson(data),
  //     body: {'title': title, 'content': content},
  //     errorMessage: 'Failed to create article',
  //   );
  // }

  // Future<Article> updateArticle(int id, String title, String content) async {
  //   return await _client.put(
  //     '/articles/$id',
  //     (data) => Article.fromJson(data),
  //     body: {'title': title, 'content': content},
  //     errorMessage: 'Failed to update article',
  //     statusMessages: {
  //       404: 'Article not found',
  //     },
  //   );
  // }

  // Future<void> deleteArticle(int id) async {
  //   await _client.requestVoid(
  //     '/articles/$id',
  //     'DELETE',
  //     errorMessage: 'Failed to delete article',
  //     statusMessages: {
  //       404: 'Article not found',
  //     },
  //   );
  // }
}