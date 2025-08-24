class Article {
  final String id;
  final String title;
  final String body; // markdown or plain text
  final DateTime updatedAt;
  bool favorite;

  Article({required this.id, required this.title, required this.body, required this.updatedAt, this.favorite=false});

  factory Article.fromMap(Map<String, dynamic> m) => Article(
    id: m['id'] as String,
    title: m['title'] as String,
    body: m['body'] as String,
    updatedAt: DateTime.parse(m['updatedAt'] as String),
    favorite: (m['favorite'] ?? false) as bool,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'updatedAt': updatedAt.toIso8601String(),
    'favorite': favorite,
  };
}
