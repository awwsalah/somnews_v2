import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../config/theme_config.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
// TODO: Import ArticleDetailScreen when it's created
// import 'article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Clear previous search results when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().searchNews('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) { // Check if the widget is still in the tree
        context.read<NewsProvider>().searchNews(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          onChanged: _onSearchChanged,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: ThemeConfig.primaryGradient,
          ),
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (_searchController.text.isEmpty) {
            return const Center(
              child: Text('Start typing to search for articles.'),
            );
          }
          if (newsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (newsProvider.error != null) {
            return Center(child: Text('Error: ${newsProvider.error}'));
          }
          if (newsProvider.searchResults.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return ListView.builder(
            itemCount: newsProvider.searchResults.length,
            itemBuilder: (context, index) {
              final article = newsProvider.searchResults[index];
              return NewsCard(
                article: article,
                onTap: () {
                  // TODO: Navigate to ArticleDetailScreen
                  print('Tapped on article: ${article.title}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
