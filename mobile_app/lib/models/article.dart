class Article {
  final int id;
  final String title;
  final String content;
  final int adminId;
  final String? authorEmail;
  final String createdAt;
  final String updatedAt;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.adminId,
    this.authorEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      adminId: json['admin_id'],
      authorEmail: json['author_email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}