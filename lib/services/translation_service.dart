import 'package:translator/translator.dart';
import '../models/article_model.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> _translateToSomali(String text) async {
    try {
      if (text.isEmpty) return '';
      // The API requires 'so' for Somali
      final translation = await _translator.translate(text, from: 'en', to: 'so');
      return translation.text;
    } catch (e) {
      print('Translation Error: $e');
      // Return original text if translation fails
      return text;
    }
  }

  Future<Map<String, String>> translateArticle(Article article) async {
    // Translate title and description in parallel for efficiency
    final results = await Future.wait([
      _translateToSomali(article.title ?? ''),
      _translateToSomali(article.description ?? ''),
    ]);

    return {
      'title': results[0],
      'description': results[1],
    };
  }
}
