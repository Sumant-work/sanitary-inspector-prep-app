import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/note.dart';
import '../models/quiz.dart';

class LocalDataService {
  static SharedPreferences? _prefs;
  
  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Load questions from local JSON asset
  static Future<List<Question>> getQuestions({String? category}) async {
    try {
      final String response = await rootBundle.loadString('assets/data/questions-data.json');
      final Map<String, dynamic> data = json.decode(response);
      List questionsRaw = data['questions'] ?? [];
      
      List<Question> questions = questionsRaw.map((json) => Question.fromJson(json)).toList();
      
      if (category != null && category.isNotEmpty) {
        questions = questions.where((q) => q.category == category).toList();
      }
      
      return questions;
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }

  // Load notes from local JSON asset
  static Future<List<Note>> getNotes({String? category}) async {
    try {
      final String response = await rootBundle.loadString('assets/data/notes-data.json');
      final Map<String, dynamic> data = json.decode(response);
      List notesRaw = data['notes'] ?? [];
      
      List<Note> notes = notesRaw.map((json) => Note.fromJson(json)).toList();
      
      if (category != null && category.isNotEmpty) {
        notes = notes.where((n) => n.category == category).toList();
      }
      
      return notes;
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  // Load categories from local JSON asset
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final String response = await rootBundle.loadString('assets/data/categories-data.json');
      final Map<String, dynamic> data = json.decode(response);
      List categories = data['categories'] ?? [];
      return categories.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }

  // Save quiz score to local storage
  static Future<void> saveQuizScore({
    required String userId,
    required String quizId,
    required int score,
    required int totalQuestions,
    required int timeTaken,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      if (_prefs == null) await init();
      
      Map<String, dynamic> scoreData = {
        'userId': userId,
        'quizId': quizId,
        'score': score,
        'totalQuestions': totalQuestions,
        'percentage': (score / totalQuestions * 100).round(),
        'timeTaken': timeTaken,
        'answers': answers,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      List<String> existingScores = _prefs!.getStringList('quiz_scores') ?? [];
      existingScores.add(json.encode(scoreData));
      
      await _prefs!.setStringList('quiz_scores', existingScores);
    } catch (e) {
      print('Error saving quiz score: $e');
    }
  }

  // Get user's quiz history from local storage
  static Future<List<Map<String, dynamic>>> getUserScores(String userId) async {
    try {
      if (_prefs == null) await init();
      
      List<String> scoresRaw = _prefs!.getStringList('quiz_scores') ?? [];
      List<Map<String, dynamic>> scores = [];
      
      for (String scoreString in scoresRaw) {
        Map<String, dynamic> score = json.decode(scoreString);
        if (score['userId'] == userId) {
          scores.add(score);
        }
      }
      
      // Sort by timestamp (most recent first)
      scores.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      
      return scores;
    } catch (e) {
      print('Error getting user scores: $e');
      return [];
    }
  }

  // Save user preferences
  static Future<void> savePreference(String key, dynamic value) async {
    if (_prefs == null) await init();
    
    if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    }
  }

  // Get user preferences
  static Future<T?> getPreference<T>(String key, {T? defaultValue}) async {
    if (_prefs == null) await init();
    
    if (T == String) {
      return _prefs!.getString(key) as T? ?? defaultValue;
    } else if (T == bool) {
      return _prefs!.getBool(key) as T? ?? defaultValue;
    } else if (T == int) {
      return _prefs!.getInt(key) as T? ?? defaultValue;
    } else if (T == double) {
      return _prefs!.getDouble(key) as T? ?? defaultValue;
    }
    
    return defaultValue;
  }

  // Clear all user data (for logout or reset)
  static Future<void> clearAllData() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
  }
}
