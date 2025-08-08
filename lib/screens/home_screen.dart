import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme_config.dart';
import '../providers/news_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely access context after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // We listen: false here because we're in initState
      context.read<NewsProvider>().fetchNews('general');
    });
  }

  @override
  Widget build(BuildContext context) {
    // We use context.watch here so the UI rebuilds when the provider notifies listeners
    final newsProvider = context.watch<NewsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SomNews'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: ThemeConfig.primaryGradient,
          ),
        ),
      ),
      body: _buildBody(newsProvider),
    );
  }

  Widget _buildBody(NewsProvider newsProvider) {
    if (newsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (newsProvider.error != null) {
      return Center(
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
                onPressed: () {
                  newsProvider.fetchNews(newsProvider.selectedCategory);
                },
                child: const Text('Retry'),
              )
            ],
          ),
        ),
      );
    }

    if (newsProvider.articles.isEmpty) {
      return const Center(child: Text('No articles found.'));
    }

    // This is a basic ListView for now. We will replace this with our NewsCard widget next.
    return ListView.builder(
      itemCount: newsProvider.articles.length,
      itemBuilder: (context, index) {
        final article = newsProvider.articles[index];
        return ListTile(
          title: Text(article.title ?? 'No Title'),
          subtitle: Text(article.source?.name ?? 'No Source'),
        );
      },
    );
  }
}
