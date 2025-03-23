class News {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String imageUrl;
  final String author;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
    required this.author,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      imageUrl: json['imageUrl'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'author': author,
    };
  }
}
