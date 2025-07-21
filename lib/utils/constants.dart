# Constants for Flutter App

```dart
import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Sanitary Inspector Prep';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.sanitaryinspector.prep';
  
  // App Colors
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accentColor = Color(0xFF43A047);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  
  // Font Sizes
  static const double fontSizeXSmall = 12.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  
  // Spacing
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  
  // Animation Durations
  static const int animationDurationFast = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationSlow = 500;
  
  // Quiz Settings
  static const int defaultQuizTimeInSeconds = 600; // 10 minutes
  static const int defaultQuestionsPerQuiz = 10;
  static const int passingScore = 60; // 60% to pass
  
  // Storage Keys
  static const String keyUserProgress = 'user_progress';
  static const String keyQuizScores = 'quiz_scores';
  static const String keyUserPreferences = 'user_preferences';
  static const String keyFirstTime = 'first_time';
  static const String keyDarkMode = 'dark_mode';
  static const String keyNotifications = 'notifications_enabled';
  
  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String pdfsPath = 'assets/pdfs/';
  static const String iconPath = 'assets/icon/';
  static const String dataPath = 'assets/data/';
  
  // Data Files
  static const String questionsDataFile = 'assets/data/questions-data.json';
  static const String notesDataFile = 'assets/data/notes-data.json';
  
  // Categories
  static const List<String> examCategories = [
    'Public Health',
    'Water Quality',
    'Food Safety',
    'Environmental Health',
    'Sanitation',
    'Disease Control',
    'Health Laws',
    'General Science',
  ];
  
  // Difficulty Levels
  static const List<String> difficultyLevels = [
    'Easy',
    'Medium',
    'Hard',
  ];
  
  // Quiz Types
  static const String mockTest = 'Mock Test';
  static const String liveTest = 'Live Test';
  static const String practiceTest = 'Practice Test';
  
  // URLs and Links
  static const String privacyPolicyUrl = 'https://your-website.com/privacy-policy';
  static const String termsOfServiceUrl = 'https://your-website.com/terms';
  static const String supportEmail = 'sumantraj.work@gmail.com';
  static const String githubRepo = 'https://github.com/Sumant-work/sanitary-inspector-prep-app';
  
  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String noDataError = 'No data available';
  static const String permissionError = 'Permission denied. Please grant required permissions.';
  static const String timeUpError = 'Time\'s up! Quiz submitted automatically.';
  
  // Success Messages
  static const String quizCompletedSuccess = 'Quiz completed successfully!';
  static const String progressSavedSuccess = 'Progress saved successfully';
  static const String scoreUpdatedSuccess = 'Score updated successfully';
  
  // Feature Flags
  static const bool enableLiveTest = false; // Coming soon feature
  static const bool enableNotifications = true;
  static const bool enableDarkMode = true;
  static const bool enableAnalytics = false;
  
  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.sanitaryinspectorprep.com';
  static const String questionsEndpoint = '/api/questions';
  static const String scoresEndpoint = '/api/scores';
  static const String updatesEndpoint = '/api/updates';
  
  // Regular Expressions
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxQuestionLength = 500;
  
  // Themes
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingSmall,
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: fontSizeXXLarge,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: fontSizeXLarge,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: fontSizeMedium,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSizeSmall,
        color: textSecondary,
      ),
    ),
  );
  
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
  );
}

// Utility Constants
class AppStrings {
  // Screen Titles
  static const String homeTitle = 'Sanitary Inspector Prep';
  static const String pyqTitle = 'Previous Year Questions';
  static const String notesTitle = 'Study Notes';
  static const String quizTitle = 'Practice Quiz';
  static const String liveTestTitle = 'Live Test';
  static const String resultsTitle = 'Quiz Results';
  static const String progressTitle = 'Your Progress';
  
  // Button Labels
  static const String startQuiz = 'Start Quiz';
  static const String nextQuestion = 'Next Question';
  static const String submitQuiz = 'Submit Quiz';
  static const String retakeQuiz = 'Retake Quiz';
  static const String viewExplanation = 'View Explanation';
  static const String goHome = 'Go to Home';
  static const String continueButton = 'Continue';
  static const String cancelButton = 'Cancel';
  
  // Status Messages
  static const String loading = 'Loading...';
  static const String comingSoon = 'Coming Soon!';
  static const String featureComingSoon = 'This feature is coming soon. Stay tuned!';
  static const String noQuestions = 'No questions available for this category';
  static const String noNotes = 'No notes available for this topic';
  
  // Quiz Messages
  static const String timeRemaining = 'Time Remaining: ';
  static const String questionOf = ' of ';
  static const String correctAnswer = 'Correct Answer: ';
  static const String yourScore = 'Your Score: ';
  static const String outOf = ' out of ';
  static const String percentage = 'Percentage: ';
  static const String passed = 'Passed';
  static const String failed = 'Failed';
}

class AppSizes {
  // Icon Sizes
  static const double iconXSmall = 16.0;
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  
  // Card Sizes
  static const double cardHeight = 120.0;
  static const double listItemHeight = 80.0;
  static const double buttonHeight = 48.0;
  static const double appBarHeight = 56.0;
  
  // Screen Dimensions
  static const double maxContentWidth = 600.0;
  static const double minTouchTarget = 44.0;
}
```
