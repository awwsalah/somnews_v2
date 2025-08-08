import 'en.dart';
import 'so.dart';

class AppLocalizations {
  final String locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale) {
    _localizedStrings = locale == 'so' ? soTranslations : enTranslations;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
