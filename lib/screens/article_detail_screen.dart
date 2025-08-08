import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme_config.dart';
import '../models/article_model.dart';
import 'package:intl/intl.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  Future<void> _launchURL(String? urlString) async {
    if (urlString == null) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildSliverContent(context),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: article.urlToImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(gradient: ThemeConfig.primaryGradient),
                      child: const Icon(Icons.error, color: Colors.white, size: 50),
                    ),
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),
                ],
              )
            : Container(decoration: BoxDecoration(gradient: ThemeConfig.primaryGradient)),
      ),
    );
  }

  Widget _buildSliverContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title ?? 'No Title', style: ThemeConfig.headlineStyle),
            const SizedBox(height: 12),
            _buildMetaInfo(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              article.description ?? 'No description available.',
              style: ThemeConfig.bodyStyle.copyWith(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              article.content ?? '',
              style: ThemeConfig.bodyStyle.copyWith(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _launchURL(article.url),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Read Full Story'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        Expanded(
          child: Text(
            article.source?.name ?? 'Unknown Source',
            style: ThemeConfig.captionStyle.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (article.publishedAt != null) ...[
          const SizedBox(width: 16),
          Text(
            DateFormat('MMM d, yyyy').format(DateTime.parse(article.publishedAt!)),
            style: ThemeConfig.captionStyle,
          ),
        ],
      ],
    );
  }
}
