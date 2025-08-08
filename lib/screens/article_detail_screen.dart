import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme_config.dart';
import '../localization/app_localizations.dart';
import '../models/article_model.dart';
import '../providers/language_provider.dart';
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
    final languageProvider = context.watch<LanguageProvider>();
    final localizations = AppLocalizations(languageProvider.currentLanguage);
    final isSomali = languageProvider.isSomali;

    final displayTitle = isSomali && (article.translatedTitle?.isNotEmpty ?? false)
        ? article.translatedTitle!
        : article.title ?? '';
        
    final displayDescription = isSomali && (article.translatedDescription?.isNotEmpty ?? false)
        ? article.translatedDescription!
        : article.description ?? '';

    final displayContent = isSomali && (article.translatedContent?.isNotEmpty ?? false)
        ? article.translatedContent!
        : article.content ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(displayTitle),
          _buildSliverContent(context, localizations, displayTitle, displayDescription, displayContent),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(String title) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16.0),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        titlePadding: const EdgeInsets.only(left: 50, right: 50, bottom: 16),
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

  Widget _buildSliverContent(BuildContext context, AppLocalizations localizations, String title, String description, String content) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ThemeConfig.headlineStyle),
            const SizedBox(height: 12),
            _buildMetaInfo(localizations),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              description,
              style: ThemeConfig.bodyStyle.copyWith(fontSize: 16, height: 1.5),
            ),
            if (content.isNotEmpty && content != description) ...[
              const SizedBox(height: 16),
              Text(
                content,
                style: ThemeConfig.bodyStyle.copyWith(fontSize: 16, height: 1.5),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _launchURL(article.url),
              icon: const Icon(Icons.open_in_browser),
              label: Text(localizations.translate('read_more')),
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

  Widget _buildMetaInfo(AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(
          child: Text(
            article.source?.name ?? localizations.translate('unknown_source'),
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
