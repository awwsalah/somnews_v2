import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';
import '../services/translation_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  final TranslationService _translationService = TranslationService();

  List<Article> _articles = [];
  List<Article> _searchResults = [];
  String _selectedCategory = 'general';
  bool _isLoading = false;
  String? _error;
  bool _shouldTranslate = false;

  List<Article> get articles => _articles;
  List<Article> get searchResults => _searchResults;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setShouldTranslate(bool value) {
    if (_shouldTranslate == value) return; // Avoid unnecessary work
    _shouldTranslate = value;
    // If we switch to Somali, translate the current list.
    // If we switch back to English, we don't need to do anything as the original is preserved.
    if (_shouldTranslate && _articles.isNotEmpty) {
      _translateArticleList(_articles).then((translated) {
        _articles = translated;
        notifyListeners();
      });
    }
  }

  Future<void> fetchNews(String category) async {
    _selectedCategory = category;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<Article> fetchedArticles = await _newsService.getTopHeadlines(category: category);
      if (_shouldTranslate) {
        _articles = await _translateArticleList(fetchedArticles);
      } else {
        _articles = fetchedArticles;
      }
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
      List<Article> searchedArticles = await _newsService.searchNews(query: query);
      if (_shouldTranslate) {
        _searchResults = await _translateArticleList(searchedArticles);
      } else {
        _searchResults = searchedArticles;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper to translate a list of articles
  Future<List<Article>> _translateArticleList(List<Article> articles) async {
    final List<Future<Article>> translationFutures = [];

    for (final article in articles) {
      translationFutures.add(
        _translationService.translateArticle(article).then((translatedMap) {
          return article.copyWith(
            translatedTitle: translatedMap['title'],
            translatedDescription: translatedMap['description'],
            translatedContent: translatedMap['content'],
          );
        }),
      );
    }
    return await Future.wait(translationFutures);
  }
}
