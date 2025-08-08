class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? author;
  final String? content;
  final Source? source;
  
  // Fields to hold translated text
  final String? translatedTitle;
  final String? translatedDescription;
  final String? translatedContent;

  Article({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.author,
    this.content,
    this.source,
    this.translatedTitle,
    this.translatedDescription,
    this.translatedContent,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      author: json['author'],
      content: json['content'],
      source: json['source'] != null ? Source.fromJson(json['source']) : null,
    );
  }

  Article copyWith({
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? author,
    String? content,
    Source? source,
    String? translatedTitle,
    String? translatedDescription,
    String? translatedContent,
  }) {
    return Article(
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      author: author ?? this.author,
      content: content ?? this.content,
      source: source ?? this.source,
      translatedTitle: translatedTitle ?? this.translatedTitle,
      translatedDescription: translatedDescription ?? this.translatedDescription,
      translatedContent: translatedContent ?? this.translatedContent,
    );
  }
}

class Source {
  final String? id;
  final String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }
}