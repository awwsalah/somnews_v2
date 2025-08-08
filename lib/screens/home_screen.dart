import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';
import '../config/theme_config.dart';
import '../providers/news_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/news_card.dart';
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

  Future<void> _refreshNews(BuildContext context) async {
    final newsProvider = context.read<NewsProvider>();
    await newsProvider.fetchNews(newsProvider.selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('SomNews'),
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
            ],
          ),
          SliverToBoxAdapter(child: _buildCategoryChips(newsProvider)),
          _buildBody(newsProvider),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(NewsProvider newsProvider) {
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
            label: category[0].toUpperCase() + category.substring(1),
            isSelected: newsProvider.selectedCategory == category,
            onTap: () {
              newsProvider.fetchNews(category);
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(NewsProvider newsProvider) {
    if (newsProvider.isLoading && newsProvider.articles.isEmpty) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
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
                  newsProvider.error!,
                  textAlign: TextAlign.center,
                  style: ThemeConfig.bodyStyle.copyWith(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _refreshNews(context),
                  child: const Text('Retry'),
                )
              ],
            ),
          ),
        ),
      );
    }

    if (newsProvider.articles.isEmpty) {
      return const SliverFillRemaining(child: Center(child: Text('No articles found.')));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final article = newsProvider.articles[index];
          return NewsCard(
            article: article,
            onTap: () {
              // TODO: Navigate to ArticleDetailScreen
              print('Tapped on article: ${article.title}');
            },
          );
        },
        childCount: newsProvider.articles.length,
      ),
    );
  }
}
