import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';
import '../services/translation_service.dart'; // Import the new service

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  final TranslationService _translationService = TranslationService(); // Add instance

  List<Article> _articles = [];
  List<Article> _searchResults = [];
  String _selectedCategory = 'general';
  bool _isLoading = false;
  String? _error;
  bool _shouldTranslate = false; // Flag to check if translation is needed

  List<Article> get articles => _articles;
  List<Article> get searchResults => _searchResults;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // This will be called from the UI to set the translation state
  void setShouldTranslate(bool value) {
    _shouldTranslate = value;
  }

  Future<void> fetchNews(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await _newsService.getTopHeadlines(category: category);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await _newsService.searchNews(query: query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to be called from ArticleDetailScreen
  Future<Map<String, String>> translateArticle(Article article) async {
    if (!_shouldTranslate) {
      return {'title': article.title ?? '', 'description': article.description ?? ''};
    }
    return await _translationService.translateArticle(article);
  }
}
