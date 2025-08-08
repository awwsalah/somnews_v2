import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../config/theme_config.dart';
import '../models/article_model.dart';
import '../providers/language_provider.dart';
import 'package:intl/intl.dart';


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
    // We watch the language provider to know which text to display
    final languageProvider = context.watch<LanguageProvider>();
    final isSomali = languageProvider.isSomali;

    final displayTitle = isSomali && (article.translatedTitle?.isNotEmpty ?? false)
        ? article.translatedTitle!
        : article.title ?? '';
        
    final displayDescription = isSomali && (article.translatedDescription?.isNotEmpty ?? false)
        ? article.translatedDescription!
        : article.description ?? '';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildContent(displayTitle, displayDescription),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: article.urlToImage!,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 200,
            decoration: BoxDecoration(gradient: ThemeConfig.primaryGradient),
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            decoration: BoxDecoration(gradient: ThemeConfig.primaryGradient),
            child: const Icon(Icons.broken_image, color: Colors.white, size: 50),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ThemeConfig.titleStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: ThemeConfig.bodyStyle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  article.source?.name ?? 'Unknown Source',
                  style: ThemeConfig.captionStyle.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _formatDate(article.publishedAt),
                style: ThemeConfig.captionStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return '';
    }
  }
}
