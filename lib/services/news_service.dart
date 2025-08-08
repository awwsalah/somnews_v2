import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/article_model.dart';

class NewsService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    queryParameters: {'apiKey': ApiConfig.apiKey},
  ));

  Future<List<Article>> getTopHeadlines({required String category}) async {
    try {
      final response = await _dio.get(
        '/top-headlines',
        queryParameters: {
          'country': 'us',
          'category': category,
        },
      );

      if (response.statusCode == 200) {
        final List articles = response.data['articles'];
        return articles
            .map((articleJson) => Article.fromJson(articleJson))
            .where((article) => article.title != null && article.urlToImage != null)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching headlines: $e');
      throw 'Failed to fetch news. Please check your connection.';
    }
  }

  Future<List<Article>> searchNews({required String query}) async {
    try {
      final response = await _dio.get(
        '/everything',
        queryParameters: {
          'q': query,
          'sortBy': 'publishedAt',
        },
      );

      if (response.statusCode == 200) {
        final List articles = response.data['articles'];
        return articles
            .map((articleJson) => Article.fromJson(articleJson))
            .where((article) => article.title != null && article.urlToImage != null)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error searching news: $e');
      throw 'Failed to perform search. Please try again.';
    }
  }
}
