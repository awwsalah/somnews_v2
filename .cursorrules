# Screen Components Implementation

## 1. Splash Screen
**File: lib/screens/splash_screen.dart**
```dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../config/theme_config.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeConfig.primaryGradient,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.newspaper,
                          size: 80,
                          color: Colors.blue,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'News App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## 2. Home Screen
**File: lib/screens/home_screen.dart**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';
import '../config/theme_config.dart';
import '../localization/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/gradient_container.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchNews('general');
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final newsProvider = context.watch<NewsProvider>();
    final localizations = AppLocalizations(languageProvider.currentLanguage);

    // Update translation setting when language changes
    newsProvider.setShouldTranslate(languageProvider.isSomali);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                localizations.translate('app_title'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: ThemeConfig.primaryGradient,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchScreen(),
                    ),
                  );
                },
              ),
              LanguageDropdown(
                currentLanguage: languageProvider.currentLanguage,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    languageProvider.setLanguage(newValue);
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: ApiConfig.categories.length,
                itemBuilder: (context, index) {
                  final category = ApiConfig.categories[index];
                  return CategoryChip(
                    label: localizations.translate(category),
                    isSelected: newsProvider.selectedCategory == category,
                    onTap: () {
                      newsProvider.fetchNews(category);
                    },
                  );
                },
              ),
            ),
          ),
          if (newsProvider.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (newsProvider.error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.translate('error_loading'),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        newsProvider.fetchNews(newsProvider.selectedCategory);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(localizations.translate('retry')),
                    ),
                  ],
                ),
              ),
            )
          else if (newsProvider.articles.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.translate('no_results'),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final article = newsProvider.articles[index];
                  return NewsCard(
                    article: article,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleDetailScreen(
                            article: article,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: newsProvider.articles.length,
              ),
            ),
        ],
      ),
    );
  }
}
```

## 3. Article Detail Screen
**File: lib/screens/article_detail_screen.dart**
```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme_config.dart';
import '../localization/app_localizations.dart';
import '../models/article_model.dart';
import '../providers/language_provider.dart';
import '../providers/news_provider.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  Map<String, String> translatedContent = {};
  bool isTranslating = false;

  @override
  void initState() {
    super.initState();
    _translateIfNeeded();
  }

  Future<void> _translateIfNeeded() async {
    final languageProvider = context.read<LanguageProvider>();
    final newsProvider = context.read<NewsProvider>();

    if (languageProvider.isSomali) {
      setState(() {
        isTranslating = true;
      });

      translatedContent = await newsProvider.translateArticle(widget.article);

      setState(() {
        isTranslating = false;
      });
    }
  }

  Future<void> _launchURL(String? url) async {
    if (url == null) return;
    
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final localizations = AppLocalizations(languageProvider.currentLanguage);

    final displayTitle = languageProvider.isSomali && translatedContent.containsKey('title')
        ? translatedContent['title']!
        : widget.article.title ?? '';

    final displayDescription = languageProvider.isSomali && translatedContent.containsKey('description')
        ? translatedContent['description']!
        : widget.article.description ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: widget.article.urlToImage != null ? 300 : 100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.article.urlToImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.article.urlToImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              gradient: ThemeConfig.primaryGradient,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              gradient: ThemeConfig.primaryGradient,
                            ),
                            child: const Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                        Container(
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
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: ThemeConfig.primaryGradient,
                      ),
                    ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isTranslating)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else ...[
                    Text(
                      displayTitle,
                      style: ThemeConfig.headlineStyle,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (widget.article.author != null) ...[
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${localizations.translate('by')} ${widget.article.author}',
                              style: ThemeConfig.captionStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if (widget.article.publishedAt != null) ...[
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(widget.article.publishedAt!),
                            style: ThemeConfig.captionStyle,
                          ),
                        ],
                      ],
                    ),
                    if (widget.article.source?.name != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.source, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            widget.article.source!.name!,
                            style: ThemeConfig.captionStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      displayDescription,
                      style: ThemeConfig.bodyStyle.copyWith(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    if (widget.article.content != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        widget.article.content!,
                        style: ThemeConfig.bodyStyle.copyWith(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _launchURL(widget.article.url),
                        icon: const Icon(Icons.open_in_browser),
                        label: Text(localizations.translate('read_more')),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
```

## 4. Search Screen
**File: lib/screens/search_screen.dart**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../config/theme_config.dart';
import '../localization/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
import 'article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<NewsProvider>().searchNews(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final newsProvider = context.watch<NewsProvider>();
    final localizations = AppLocalizations(languageProvider.currentLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: localizations.translate('search'),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<NewsProvider>().searchNews('');
                      },
                    )
                  : const Icon(Icons.search),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: ThemeConfig.primaryGradient,
          ),
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_searchController.text.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.translate('search'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (newsProvider.searchResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.translate('no_results'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: newsProvider.searchResults.length,
            itemBuilder: (context, index) {
              final article = newsProvider.searchResults[index];
              return NewsCard(
                article: article,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailScreen(
                        article: article,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

## 5. Additional Widget Components

### Category Chip Widget
**File: lib/widgets/category_chip.dart**
```dart
import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? ThemeConfig.primaryGradient : null,
            color: isSelected ? null : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
```

### Language Dropdown Widget
**File: lib/widgets/language_dropdown.dart**
```dart
import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final String currentLanguage;
  final Function(String?) onChanged;

  const LanguageDropdown({
    Key? key,
    required this.currentLanguage,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentLanguage,
      icon: const Icon(Icons.language, color: Colors.white),
      dropdownColor: Colors.blue[700],
      underline: Container(),
      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text(
            'EN',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownMenuItem(
          value: 'so',
          child: Text(
            'SO',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
```

### Gradient Container Widget
**File: lib/widgets/gradient_container.dart**
```dart
import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const GradientContainer({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: ThemeConfig.primaryGradient,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
```

## 6. Android Configuration

### Update Android Manifest
**File: android/app/src/main/AndroidManifest.xml**
Add these permissions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### Update App Name
**File: android/app/src/main/AndroidManifest.xml**
```xml
<application
    android:label="News App"
    android:icon="@mipmap/ic_launcher">
```

## 7. Assets Configuration

### Add Logo Placeholder
Create a simple logo or use this command to create a placeholder:
```bash
# Create assets directory
mkdir -p assets/images

# Add this to pubspec.yaml under flutter:
flutter:
  assets:
    - assets/images/
```

## Final Steps to Run the App

1. **Install dependencies:**
```bash
flutter pub get
```

2. **Add your logo:**
Place your logo image in `assets/images/logo.png`

3. **Run the app:**
```bash
flutter run
```

4. **Build APK:**
```bash
flutter build apk --release
```

## Testing Checklist

- [ ] Splash screen shows with logo
- [ ] News loads on home screen
- [ ] Categories filter works
- [ ] Language toggle switches UI text
- [ ] Search functionality works
- [ ] Article detail page opens
- [ ] Translation works for Somali
- [ ] Gradient theme displays correctly
- [ ] Error states show properly
- [ ] Loading indicators appear

## Troubleshooting

### If API limit reached:
- The free tier allows 100 requests/day
- Consider implementing caching
- Show appropriate error message

### If translation fails:
- Check internet connection
- Verify Google Translate package is working
- Falls back to English content

### If images don't load:
- Check internet connection
- Verify image URLs from API
- Placeholder shows on error