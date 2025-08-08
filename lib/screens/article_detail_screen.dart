import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme_config.dart';
import '../localization/app_localizations.dart';
import '../models/article_model.dart';
import '../providers/language_provider.dart';
import '../providers/news_provider.dart';
import 'package:intl/intl.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  Map<String, String> _translatedContent = {};
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    _translateIfNeeded();
  }

  Future<void> _translateIfNeeded() async {
    final languageProvider = context.read<LanguageProvider>();
    if (languageProvider.isSomali) {
      setState(() => _isTranslating = true);
      final newsProvider = context.read<NewsProvider>();
      final result = await newsProvider.translateArticle(widget.article);
      if (mounted) {
        setState(() {
          _translatedContent = result;
          _isTranslating = false;
        });
      }
    }
  }

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

    final displayTitle = languageProvider.isSomali
        ? _translatedContent['title'] ?? widget.article.title ?? ''
        : widget.article.title ?? '';
        
    final displayDescription = languageProvider.isSomali
        ? _translatedContent['description'] ?? widget.article.description ?? ''
        : widget.article.description ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildSliverContent(context, localizations, displayTitle, displayDescription),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.article.urlToImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.article.urlToImage!,
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

  Widget _buildSliverContent(BuildContext context, AppLocalizations localizations, String title, String description) {
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
            if (_isTranslating)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ))
            else
              Text(
                description,
                style: ThemeConfig.bodyStyle.copyWith(fontSize: 16, height: 1.5),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _launchURL(widget.article.url),
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
            widget.article.source?.name ?? localizations.translate('unknown_source'),
            style: ThemeConfig.captionStyle.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.article.publishedAt != null) ...[
          const SizedBox(width: 16),
          Text(
            DateFormat('MMM d, yyyy').format(DateTime.parse(widget.article.publishedAt!)),
            style: ThemeConfig.captionStyle,
          ),
        ],
      ],
    );
  }
}
