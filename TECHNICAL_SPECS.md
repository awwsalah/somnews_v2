# Technical Specifications - Flutter News App

## Step-by-Step Implementation Guide

### Step 1: Create Flutter Project
```bash
flutter create news_app
cd news_app
```

### Step 2: Update pubspec.yaml
```yaml
name: news_app
description: A Flutter news application with Somali translation

publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # Core packages
  dio: ^5.4.0
  provider: ^6.1.1
  
  # UI packages
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Translation
  translator: ^1.0.0
  
  # Utilities
  intl: ^0.19.0
  shared_preferences: ^2.2.2
  url_launcher: ^6.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
```

### Step 3: Create Directory Structure
```bash
# Run these commands from project root
mkdir -p lib/config
mkdir -p lib/models
mkdir -p lib/services
mkdir -p lib/providers
mkdir -p lib/screens
mkdir -p lib/widgets
mkdir -p lib/localization
mkdir -p assets/images
```

### Step 4: API Configuration
**File: lib/config/api_config.dart**
```dart
class ApiConfig {
  static const String apiKey = '6d926d933e40424b83238351c3e69adb';
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String topHeadlines = '$baseUrl/top-headlines';
  static const String everything = '$baseUrl/everything';
  
  static const List<String> categories = [
    'general',
    'technology',
    'sports',
    'business',
    'entertainment',
    'health',
    'science',
  ];
}
```

### Step 5: Theme Configuration
**File: lib/config/theme_config.dart**
```dart
import 'package:flutter/material.dart';

class ThemeConfig {
  static ThemeData getTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF9C27B0), Color(0xFF2196F3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
```

### Step 6: Article Model
**File: lib/models/article_model.dart**
```dart
class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? author;
  final String? content;
  final Source? source;

  Article({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.author,
    this.content,
    this.source,
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
```

### Step 7: News Service
**File: lib/services/news_service.dart**
```dart
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/article_model.dart';

class NewsService {
  final Dio _dio = Dio();

  Future<List<Article>> getTopHeadlines({
    String category = 'general',
    String country = 'us',
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.topHeadlines,
        queryParameters: {
          'apiKey': ApiConfig.apiKey,
          'country': country,
          'category': category,
        },
      );

      if (response.statusCode == 200) {
        final List articles = response.data['articles'];
        return articles.map((e) => Article.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching headlines: $e');
      return [];
    }
  }

  Future<List<Article>> searchNews(String query) async {
    try {
      final response = await _dio.get(
        ApiConfig.everything,
        queryParameters: {
          'apiKey': ApiConfig.apiKey,
          'q': query,
          'sortBy': 'publishedAt',
        },
      );

      if (response.statusCode == 200) {
        final List articles = response.data['articles'];
        return articles.map((e) => Article.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching news: $e');
      return [];
    }
  }
}
```

### Step 8: Translation Service
**File: lib/services/translation_service.dart**
```dart
import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateToSomali(String text) async {
    try {
      if (text.isEmpty) return text;
      
      final translation = await _translator.translate(
        text,
        from: 'en',
        to: 'so',
      );
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text if translation fails
    }
  }

  Future<Map<String, String>> translateArticle({
    required String? title,
    required String? description,
  }) async {
    final translatedTitle = title != null 
        ? await translateToSomali(title) 
        : '';
    
    final translatedDescription = description != null 
        ? await translateToSomali(description) 
        : '';

    return {
      'title': translatedTitle,
      'description': translatedDescription,
    };
  }
}
```

### Step 9: Localization Files
**File: lib/localization/en.dart**
```dart
const Map<String, String> enTranslations = {
  'app_title': 'News App',
  'categories': 'Categories',
  'all': 'All',
  'general': 'General',
  'technology': 'Technology',
  'sports': 'Sports',
  'business': 'Business',
  'entertainment': 'Entertainment',
  'health': 'Health',
  'science': 'Science',
  'search': 'Search news...',
  'no_results': 'No articles found',
  'error_loading': 'Error loading news',
  'retry': 'Retry',
  'read_more': 'Read More',
  'published': 'Published',
  'by': 'By',
  'loading': 'Loading...',
  'language': 'Language',
};
```

**File: lib/localization/so.dart**
```dart
const Map<String, String> soTranslations = {
  'app_title': 'Codsiga Wararka',
  'categories': 'Qaybaha',
  'all': 'Dhammaan',
  'general': 'Guud',
  'technology': 'Tignoolajiyada',
  'sports': 'Ciyaaraha',
  'business': 'Ganacsiga',
  'entertainment': 'Madadaalada',
  'health': 'Caafimaadka',
  'science': 'Sayniska',
  'search': 'Raadi war...',
  'no_results': 'Wax maqaal ah lama helin',
  'error_loading': 'Khalad ayaa dhacay',
  'retry': 'Isku day mar labaad',
  'read_more': 'Akhri wax dheeraad ah',
  'published': 'La daabacay',
  'by': 'Qoray',
  'loading': 'Waa la soo rarayaa...',
  'language': 'Luqadda',
};
```

**File: lib/localization/app_localizations.dart**
```dart
import 'en.dart';
import 'so.dart';

class AppLocalizations {
  final String locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale) {
    _localizedStrings = locale == 'so' ? soTranslations : enTranslations;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
```

### Step 10: Providers
**File: lib/providers/language_provider.dart**
```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  
  String get currentLanguage => _currentLanguage;
  bool get isSomali => _currentLanguage == 'so';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'en';
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _currentLanguage = _currentLanguage == 'en' ? 'so' : 'en';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _currentLanguage);
    notifyListeners();
  }

  void setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    notifyListeners();
  }
}
```

**File: lib/providers/news_provider.dart**
```dart
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
    _shouldTranslate = value;
    if (value && _articles.isNotEmpty) {
      fetchNews(_selectedCategory);
    }
  }

  Future<void> fetchNews(String category) async {
    _isLoading = true;
    _error = null;
    _selectedCategory = category;
    notifyListeners();

    try {
      _articles = await _newsService.getTopHeadlines(category: category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load news';
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
    notifyListeners();

    try {
      _searchResults = await _newsService.searchNews(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Search failed';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, String>> translateArticle(Article article) async {
    if (!_shouldTranslate) {
      return {
        'title': article.title ?? '',
        'description': article.description ?? '',
      };
    }

    return await _translationService.translateArticle(
      title: article.title,
      description: article.description,
    );
  }
}
```

### Step 11: Main App File
**File: lib/main.dart**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme_config.dart';
import 'providers/language_provider.dart';
import 'providers/news_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: ThemeConfig.getTheme(),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

## Widget Templates

### News Card Widget
**File: lib/widgets/news_card.dart**
```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme_config.dart';
import '../models/article_model.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const NewsCard({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: article.urlToImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: ThemeConfig.primaryGradient,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: ThemeConfig.primaryGradient,
                        ),
                        child: const Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    style: ThemeConfig.titleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description ?? '',
                    style: ThemeConfig.bodyStyle.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.source?.name ?? '',
                        style: ThemeConfig.captionStyle,
                      ),
                      if (article.publishedAt != null)
                        Text(
                          _formatDate(article.publishedAt!),
                          style: ThemeConfig.captionStyle,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}
```

## Cursor AI Instructions (.cursorrules)
**File: .cursorrules**
```
# Flutter News App Development Rules

## Project Context
- Flutter app using Material Design
- News data from NewsAPI.org
- Bilingual support (English/Somali)
- Real-time translation for news content
- Simple implementation prioritized

## Code Style
- Use latest Flutter conventions
- Follow Material Design guidelines
- Keep widgets modular and reusable
- Use Provider for state management
- Implement proper error handling

## File Structure
- Models in lib/models/
- Services in lib/services/
- Providers in lib/providers/
- Screens in lib/screens/
- Widgets in lib/widgets/
- Config in lib/config/

## Implementation Guidelines
1. Always use null safety
2. Handle API errors gracefully
3. Show loading states
4. Implement proper image caching
5. Use const constructors where possible
6. Follow DRY principle
7. Comment complex logic

## UI Requirements
- Purple to blue gradient theme
- Card-based layout
- Vertical scrolling
- Clean, simple interface
- Responsive design

## When generating code:
- Include proper imports
- Handle edge cases
- Add error handling
- Use async/await properly
- Follow Flutter best practices
```

## Testing Commands

### Run the app
```bash
flutter run
```

### Build APK
```bash
flutter build apk --release
```

### Clean and get packages
```bash
flutter clean
flutter pub get
```

## Common Issues & Solutions

### API Rate Limiting
- NewsAPI free tier: 100 requests/day
- Implement caching if needed
- Show cached data when limit reached

### Translation API Limits
- Google Translate has character limits
- Batch translations if needed
- Cache translated content

### Image Loading Issues
- Use placeholder images
- Handle network errors
- Implement retry logic

### Performance Optimization
- Use const widgets
- Implement pagination
- Lazy load images
- Minimize rebuilds

## Next Steps After Implementation

1. Add logo to assets/images/logo.png
2. Test on physical device
3. Optimize performance
4. Add analytics (optional)
5. Prepare for Play Store release