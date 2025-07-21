import 'package:flutter/material.dart';
import '../services/local_data_service.dart';
import '../models/question.dart';
import '../models/note.dart';

class AppProvider with ChangeNotifier {
  // State variables
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _isLoading = false;
  String _currentUserId = 'guest_user';
  
  // Data from local storage
  List<Question> _questions = [];
  List<Note> _notes = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _quizHistory = [];

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoading => _isLoading;
  String get currentUserId => _currentUserId;
  
  List<Question> get questions => _questions;
  List<Note> get notes => _notes;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get quizHistory => _quizHistory;

  AppProvider() {
    _initializeApp();
  }

  // Initialize app with local data
  Future<void> _initializeApp() async {
    await LocalDataService.init();
    await _loadPreferences();
    await _generateGuestUserId();
    await _loadAllLocalData();
  }

  // Load user preferences
  Future<void> _loadPreferences() async {
    try {
      _isDarkMode = await LocalDataService.getPreference<bool>('darkMode', defaultValue: false) ?? false;
      _notificationsEnabled = await LocalDataService.getPreference<bool>('notifications', defaultValue: true) ?? true;
      notifyListeners();
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  // Generate guest user ID
  Future<void> _generateGuestUserId() async {
    String? existingUserId = await LocalDataService.getPreference<String>('guestUserId');
    if (existingUserId == null) {
      _currentUserId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      await LocalDataService.savePreference('guestUserId', _currentUserId);
    } else {
      _currentUserId = existingUserId;
    }
  }

  // Load all data from local assets
  Future<void> _loadAllLocalData() async {
    setLoading(true);
    
    try {
      await Future.wait([
        loadQuestions(),
        loadNotes(),
        loadCategories(),
        loadQuizHistory(),
      ]);
    } catch (e) {
      print('Error loading local data: $e');
    } finally {
      setLoading(false);
    }
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await LocalDataService.savePreference('darkMode', _isDarkMode);
    notifyListeners();
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await LocalDataService.savePreference('notifications', _notificationsEnabled);
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Load questions from local data
  Future<void> loadQuestions({String? category}) async {
    try {
      _questions = await LocalDataService.getQuestions(category: category);
      notifyListeners();
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  // Load notes from local data
  Future<void> loadNotes({String? category}) async {
    try {
      _notes = await LocalDataService.getNotes(category: category);
      notifyListeners();
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  // Load categories from local data
  Future<void> loadCategories() async {
    try {
      _categories = await LocalDataService.getCategories();
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Load quiz history from local storage
  Future<void> loadQuizHistory() async {
    try {
      _quizHistory = await LocalDataService.getUserScores(_currentUserId);
      notifyListeners();
    } catch (e) {
      print('Error loading quiz history: $e');
    }
  }

  // Save quiz score to local storage
  Future<void> saveQuizScore({
    required String quizId,
    required int score,
    required int totalQuestions,
    required int timeTaken,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      await LocalDataService.saveQuizScore(
        userId: _currentUserId,
        quizId: quizId,
        score: score,
        totalQuestions: totalQuestions,
        timeTaken: timeTaken,
        answers: answers,
      );
      
      // Reload quiz history
      await loadQuizHistory();
    } catch (e) {
      print('Error saving quiz score: $e');
    }
  }

  // Get questions by category
  List<Question> getQuestionsByCategory(String category) {
    return _questions.where((q) => q.category == category).toList();
  }

  // Get notes by category
  List<Note> getNotesByCategory(String category) {
    return _notes.where((n) => n.category == category).toList();
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await _loadAllLocalData();
  }

  // Get user statistics
  Map<String, int> getUserStats() {
    int totalQuizzes = _quizHistory.length;
    int totalScore = _quizHistory.fold(0, (sum, quiz) => sum + (quiz['score'] as int));
    int averageScore = totalQuizzes > 0 ? (totalScore / totalQuizzes).round() : 0;
    
    return {
      'totalQuizzes': totalQuizzes,
      'averageScore': averageScore,
      'totalScore': totalScore,
    };
  }
}
