# Product Requirement Document - Flutter News App

## Project Overview
A Flutter-based news application that fetches news from NewsAPI.org, displays articles in a beautiful Material Design interface, and provides real-time translation to Somali language.

## Core Features

### 1. News Feed
- Fetch news articles from NewsAPI.org
- Display articles in vertical scrolling cards
- Beautiful gradient cards (purple to blue)
- Categories: Technology, Sports, Business, Entertainment, Health, Science, General
- Multi-category filtering support

### 2. Language Support
- English/Somali UI toggle via AppBar dropdown
- Hardcoded UI translations for Somali
- Real-time news content translation using Google Translate API
- Language preference persistence

### 3. Search
- Search news articles by title
- Real-time search results from API
- Search bar in AppBar

### 4. UI/UX
- Material Design components
- Splash screen with logo placeholder
- Purple to blue gradient theme
- Responsive card layouts
- Clean, simple interface

## Technical Stack
- **Framework**: Flutter (Latest Stable)
- **UI Library**: Material Design
- **State Management**: Provider (simple and beginner-friendly)
- **HTTP Client**: dio
- **Localization**: flutter_localizations
- **Translation**: translator package
- **Image Loading**: cached_network_image
- **Platform**: Android

## API Configuration
```dart
const String apiKey = '6d926d933e40424b83238351c3e69adb';
const String baseUrl = 'https://newsapi.org/v2';
```

## Project Structure
```
news_app/
├── android/
├── assets/
│   └── images/
│       └── logo.png
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── api_config.dart
│   │   └── theme_config.dart
│   ├── models/
│   │   ├── article_model.dart
│   │   └── category_model.dart
│   ├── services/
│   │   ├── news_service.dart
│   │   └── translation_service.dart
│   ├── providers/
│   │   ├── news_provider.dart
│   │   └── language_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── article_detail_screen.dart
│   │   └── search_screen.dart
│   ├── widgets/
│   │   ├── news_card.dart
│   │   ├── category_chip.dart
│   │   ├── language_dropdown.dart
│   │   └── gradient_container.dart
│   └── localization/
│       ├── app_localizations.dart
│       ├── en.dart
│       └── so.dart
├── test/
└── pubspec.yaml
```

## Implementation Order

### Phase 1: Project Setup (Day 1)
1. Create Flutter project
2. Add dependencies
3. Create folder structure
4. Setup API configuration
5. Create theme configuration

### Phase 2: Core Models & Services (Day 2)
1. Create article model
2. Create category model
3. Implement news service
4. Setup translation service

### Phase 3: State Management (Day 3)
1. Setup Provider
2. Create news provider
3. Create language provider
4. Connect providers to main.dart

### Phase 4: UI Components (Day 4-5)
1. Create splash screen
2. Build home screen layout
3. Design news card widget
4. Implement category chips
5. Add language dropdown

### Phase 5: Features (Day 6-7)
1. Implement news fetching
2. Add category filtering
3. Create search functionality
4. Setup article detail view

### Phase 6: Localization (Day 8)
1. Setup localization files
2. Create Somali translations
3. Implement language switching
4. Add translation service integration

### Phase 7: Polish & Testing (Day 9-10)
1. UI refinements
2. Error handling
3. Loading states
4. Manual testing
5. Bug fixes

## Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # Core packages
  dio: ^5.4.0
  provider: ^6.1.1
  
  # UI packages
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Translation
  translator: ^1.0.0
  
  # Utilities
  intl: ^0.19.0
  shared_preferences: ^2.2.2
  url_launcher: ^6.2.2
```

## UI Specifications

### Color Palette
```dart
Primary Gradient: LinearGradient(
  colors: [Color(0xFF9C27B0), Color(0xFF2196F3)], // Purple to Blue
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
Background: Colors.grey[50]
Card Background: Colors.white
Text Primary: Colors.grey[900]
Text Secondary: Colors.grey[600]
```

### Typography
- Headline: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
- Title: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
- Body: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)
- Caption: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)

### Card Design
- Elevation: 4
- Border Radius: 12
- Padding: 16
- Image Height: 200
- Gradient overlay on images

## API Endpoints

### Top Headlines
```
GET /top-headlines
Parameters:
- country: us
- category: [technology|business|entertainment|health|science|sports|general]
- apiKey: {API_KEY}
```

### Search
```
GET /everything
Parameters:
- q: {search_query}
- language: en
- sortBy: publishedAt
- apiKey: {API_KEY}
```

## Localization Keys

### English (en.dart)
```dart
'app_title': 'News App'
'categories': 'Categories'
'search': 'Search news...'
'no_results': 'No articles found'
'error_loading': 'Error loading news'
'retry': 'Retry'
'read_more': 'Read More'
```

### Somali (so.dart)
```dart
'app_title': 'Codsiga Wararka'
'categories': 'Qaybaha'
'search': 'Raadi war...'
'no_results': 'Wax maqaal ah lama helin'
'error_loading': 'Khalad ayaa dhacay'
'retry': 'Isku day mar labaad'
'read_more': 'Akhri wax dheeraad ah'
```

## Error Handling
- Network errors: Show retry button
- Empty states: Display appropriate message
- API limits: Cache last successful response
- Translation failures: Show original content

## Performance Considerations
- Lazy loading for images
- Pagination (20 articles per load)
- Debounced search (500ms delay)
- Image caching
- Minimal rebuilds using Provider

## Success Metrics
- App launches without crashes
- News loads within 3 seconds
- Smooth scrolling performance
- Successful language switching
- Working search functionality

## Future Enhancements (Not in MVP)
- Dark mode support
- Offline caching with SQLite
- Push notifications
- Bookmarks/Favorites
- Share functionality
- Multiple language support beyond Somali

## Development Notes
- Use Cursor AI for code generation
- Follow Material Design guidelines
- Keep code modular and reusable
- Comment complex logic
- Handle edge cases gracefully