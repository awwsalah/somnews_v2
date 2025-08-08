class ApiConfig {
  static const String apiKey = '6d926d933e40424b83238351c3e69adb';
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String topHeadlines = '$baseUrl/top-headlines';
  static const String everything = '$baseUrl/everything';
  
  static const List<String> categories = [
    'general',
    'technology',
    'sports',
    'business',
    'entertainment',
    'health',
    'science',
  ];
}



