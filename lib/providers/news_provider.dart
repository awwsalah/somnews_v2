import 'package:flutter/material.dart';
import '../models/article_model.dart';
// We will create and import services later

class NewsProvider extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _searchResults = [];
  String _selectedCategory = 'general';
  bool _isLoading = false;
  String? _error;

  List<Article> get articles => _articles;
  List<Article> get searchResults => _searchResults;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // We will implement this logic in the upcoming steps
  Future<void> fetchNews(String category) async {}
  Future<void> searchNews(String query) async {}
}
