import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';
import '../config/theme_config.dart';
import '../localization/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/news_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/news_card.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';
import '../widgets/news_card_shimmer.dart'; // Add this import

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

  Future<void> _refreshNews(BuildContext context) async {
    final newsProvider = context.read<NewsProvider>();
    await newsProvider.fetchNews(newsProvider.selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();
    final languageProvider = context.watch<LanguageProvider>();
    final localizations = AppLocalizations(languageProvider.currentLanguage);

    // Add this line to link the language state to the news provider
    newsProvider.setShouldTranslate(languageProvider.isSomali);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(localizations.translate('app_title')),
            floating: true,
            pinned: true,
            snap: false,
            expandedHeight: 120,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: ThemeConfig.primaryGradient,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
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
          SliverToBoxAdapter(child: _buildCategoryChips(newsProvider, localizations)),
          _buildBody(context, newsProvider, localizations),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(NewsProvider newsProvider, AppLocalizations localizations) {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }

  Widget _buildBody(BuildContext context, NewsProvider newsProvider, AppLocalizations localizations) {
    if (newsProvider.isLoading && newsProvider.articles.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const NewsCardShimmer(),
          childCount: 5, // Show 5 shimmer cards
        ),
      );
    }

    if (newsProvider.error != null) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.translate('error_loading'),
                  textAlign: TextAlign.center,
                  style: ThemeConfig.bodyStyle.copyWith(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _refreshNews(context),
                  child: Text(localizations.translate('retry')),
                )
              ],
            ),
          ),
        ),
      );
    }

    if (newsProvider.articles.isEmpty) {
      return SliverFillRemaining(
          child: Center(child: Text(localizations.translate('no_results'))));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final article = newsProvider.articles[index];
          return NewsCard(
            article: article,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetailScreen(article: article),
                ),
              );
            },
          );
        },
        childCount: newsProvider.articles.length,
      ),
    );
  }
}
