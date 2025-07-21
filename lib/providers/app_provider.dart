import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide state management provider
class AppProvider with ChangeNotifier {
  // App state
  bool _isFirstLaunch = true;
  bool _permissionsGranted = false;
  String _userName = '';
  
  // Quiz state
  Map<String, int> _categoryScores = {};
  int _totalQuestionsAnswered = 0;
  int _totalCorrectAnswers = 0;
  
  // Progress tracking
  List<String> _completedPyqs = [];
  List<String> _bookmarkedNotes = [];
  Set<String> _completedQuizzes = {};
  
  // Preferences
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  
  // Getters
  bool get isFirstLaunch => _isFirstLaunch;
  bool get permissionsGranted => _permissionsGranted;
  String get userName => _userName;
  Map<String, int> get categoryScores => _categoryScores;
  int get totalQuestionsAnswered => _totalQuestionsAnswered;
  int get totalCorrectAnswers => _totalCorrectAnswers;
  List<String> get completedPyqs => _completedPyqs;
  List<String> get bookmarkedNotes => _bookmarkedNotes;
  Set<String> get completedQuizzes => _completedQuizzes;
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  
  // Calculated properties
  double get overallAccuracy {
    if (_totalQuestionsAnswered == 0) return 0.0;
    return (_totalCorrectAnswers / _totalQuestionsAnswered) * 100;
  }
  
  int get totalScore => _categoryScores.values.fold(0, (sum, score) => sum + score);

  /// Initialize app data from shared preferences
  Future<void> initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    
    _isFirstLaunch = prefs.getBool('first_launch') ?? true;
    _permissionsGranted = prefs.getBool('permissions_granted') ?? false;
    _userName = prefs.getString('user_name') ?? '';
    _totalQuestionsAnswered = prefs.getInt('total_questions') ?? 0;
    _totalCorrectAnswers = prefs.getInt('total_correct') ?? 0;
    _darkMode = prefs.getBool('dark_mode') ?? false;
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    
    // Load category scores
    _categoryScores = {};
    final scoreKeys = ['general_knowledge', 'health_sanitation', 'environmental'];
    for (String key in scoreKeys) {
      _categoryScores[key] = prefs.getInt('score_$key') ?? 0;
    }
    
    // Load completed items
    _completedPyqs = prefs.getStringList('completed_pyqs') ?? [];
    _bookmarkedNotes = prefs.getStringList('bookmarked_notes') ?? [];
    _completedQuizzes = (prefs.getStringList('completed_quizzes') ?? []).toSet();
    
    notifyListeners();
  }

  /// Set first launch completed
  Future<void> setFirstLaunchCompleted() async {
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    notifyListeners();
  }

  /// Update permissions status
  Future<void> setPermissionsGranted(bool granted) async {
    _permissionsGranted = granted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissions_granted', granted);
    notifyListeners();
  }

  /// Set user name
  Future<void> setUserName(String name) async {
    _userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    notifyListeners();
  }

  /// Update quiz score for a category
  Future<void> updateQuizScore(String category, int score, int totalQuestions) async {
    // Update category score
    _categoryScores[category] = (_categoryScores[category] ?? 0) + score;
    
    // Update overall stats
    _totalQuestionsAnswered += totalQuestions;
    _totalCorrectAnswers += score;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('score_$category', _categoryScores[category]!);
    await prefs.setInt('total_questions', _totalQuestionsAnswered);
    await prefs.setInt('total_correct', _totalCorrectAnswers);
    
    notifyListeners();
  }

  /// Mark PYQ as completed
  Future<void> markPyqCompleted(String pyqId) async {
    if (!_completedPyqs.contains(pyqId)) {
      _completedPyqs.add(pyqId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed_pyqs', _completedPyqs);
      notifyListeners();
    }
  }

  /// Toggle bookmark for a note
  Future<void> toggleNoteBookmark(String noteId) async {
    if (_bookmarkedNotes.contains(noteId)) {
      _bookmarkedNotes.remove(noteId);
    } else {
      _bookmarkedNotes.add(noteId);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarked_notes', _bookmarkedNotes);
    notifyListeners();
  }

  /// Mark quiz as completed
  Future<void> markQuizCompleted(String quizId) async {
    _completedQuizzes.add(quizId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completed_quizzes', _completedQuizzes.toList());
    notifyListeners();
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _darkMode);
    notifyListeners();
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    notifyListeners();
  }

  /// Reset all data (for testing or user request)
  Future<void> resetAllData() async {
    _categoryScores.clear();
    _totalQuestionsAnswered = 0;
    _totalCorrectAnswers = 0;
    _completedPyqs.clear();
    _bookmarkedNotes.clear();
    _completedQuizzes.clear();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }

  /// Get progress for specific category
  double getCategoryProgress(String category) {
    // This would calculate based on completed content for each category
    // For demo, using a simple calculation
    final score = _categoryScores[category] ?? 0;
    return (score / 100).clamp(0.0, 1.0); // Normalize to 0-1
  }

  /// Get study statistics
  Map<String, dynamic> getStudyStatistics() {
    return {
      'totalQuestions': _totalQuestionsAnswered,
      'correctAnswers': _totalCorrectAnswers,
      'accuracy': overallAccuracy,
      'completedPyqs': _completedPyqs.length,
      'bookmarkedNotes': _bookmarkedNotes.length,
      'completedQuizzes': _completedQuizzes.length,
      'totalScore': totalScore,
      'categoryScores': Map.from(_categoryScores),
    };
  }
}
