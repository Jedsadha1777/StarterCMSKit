class Article {
  final String id;
  final String title;
  final String content;
  final String? authorId;
  final String? authorEmail;
  final String status;
  final String? publishDate;
  final int version;
  final String createdAt;
  final String updatedAt;

  Article({
    required this.id,
    required this.title,
    required this.content,
    this.authorId,
    this.authorEmail,
    this.status = 'draft',
    this.publishDate,
    this.version = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorId: json['author_id'],
      authorEmail: json['author_email'],
      status: json['status'] ?? 'draft',
      publishDate: json['publish_date'],
      version: json['version'] ?? 1,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}