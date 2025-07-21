import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_service.dart';
import '../models/question.dart';
import '../models/note.dart';
import '../models/quiz.dart';

class AppProvider with ChangeNotifier {
  // State variables
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _isLoading = false;
  String? _currentUserId;
  
  // Data from Firebase
  List<Question> _questions = [];
  List<Note> _notes = [];
  List<Quiz> _quizzes = [];
  List<Map<String, dynamic>> _pyqPapers = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _quizHistory = [];

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoading => _isLoading;
  String? get currentUserId => _currentUserId;
  
  List<Question> get questions => _questions;
  List<Note> get notes => _notes;
  List<Quiz> get quizzes => _quizzes;
  List<Map<String, dynamic>> get pyqPapers => _pyqPapers;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get quizHistory => _quizHistory;

  AppProvider() {
    _initializeApp();
  }

  // Initialize app with Firebase data
  Future<void> _initializeApp() async {
    await _loadPreferences();
    await _generateGuestUserId();
    await _loadAllFirebaseData();
  }

  // Load user preferences
  Future<void> _loadPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      notifyListeners();
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  // Generate guest user ID
  Future<void> _generateGuestUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString('guestUserId') ?? 
        'guest_${DateTime.now().millisecondsSinceEpoch}';
    await prefs.setString('guestUserId', _currentUserId!);
  }

  // Load all data from Firebase
  Future<void> _loadAllFirebaseData() async {
    setLoading(true);
    
    try {
      await Future.wait([
        loadQuestions(),
        loadNotes(),
        loadQuizzes(),
        loadPYQPapers(),
        loadCategories(),
        if (_currentUserId != null) loadQuizHistory(),
      ]);
    } catch (e) {
      print('Error loading Firebase data: $e');
    } finally {
      setLoading(false);
    }
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Load questions from Firebase
  Future<void> loadQuestions({String? category}) async {
    try {
      _questions = await FirebaseService.getQuestions(category: category);
      notifyListeners();
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  // Load notes from Firebase
  Future<void> loadNotes({String? category}) async {
    try {
      _notes = await FirebaseService.getNotes(category: category);
      notifyListeners();
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  // Load quizzes from Firebase
  Future<void> loadQuizzes({String? type}) async {
    try {
      _quizzes = await FirebaseService.getQuizzes(type: type);
      notifyListeners();
    } catch (e) {
      print('Error loading quizzes: $e');
    }
  }

  // Load PYQ papers from Firebase
  Future<void> loadPYQPapers() async {
    try {
      _pyqPapers = await FirebaseService.getPYQPapers();
      notifyListeners();
    } catch (e) {
      print('Error loading PYQ papers: $e');
    }
  }

  // Load categories from Firebase
  Future<void> loadCategories() async {
    try {
      _categories = await FirebaseService.getCategories('all');
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Load quiz history from Firebase
  Future<void> loadQuizHistory() async {
    if (_currentUserId == null) return;
    
    try {
      _quizHistory = await FirebaseService.getUserScores(_currentUserId!);
      notifyListeners();
    } catch (e) {
      print('Error loading quiz history: $e');
    }
  }

  // Save quiz score to Firebase
  Future<void> saveQuizScore({
    required String quizId,
    required int score,
    required int totalQuestions,
    required int timeTaken,
    required List<Map<String, dynamic>> answers,
  }) async {
    if (_currentUserId == null) return;

    try {
      await FirebaseService.saveQuizScore(
        userId: _currentUserId!,
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

  // Refresh all data from Firebase
  Future<void> refreshAllData() async {
    await _loadAllFirebaseData();
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
