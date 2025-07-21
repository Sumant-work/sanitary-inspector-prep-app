# Data Loader for Flutter App

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';
import '../models/quiz.dart';
import '../models/note.dart';

class DataLoader {
  // Cache for loaded data
  static List<Question>? _cachedQuestions;
  static List<Note>? _cachedNotes;
  static List<Quiz>? _cachedQuizzes;

  // Load questions from JSON
  static Future<List<Question>> loadQuestions() async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    try {
      final String response = await rootBundle.loadString('assets/data/questions-data.json');
      final List<dynamic> data = json.decode(response);
      
      _cachedQuestions = data.map((json) => Question.fromJson(json)).toList();
      return _cachedQuestions!;
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }

  // Load notes from JSON
  static Future<List<Note>> loadNotes() async {
    if (_cachedNotes != null) {
      return _cachedNotes!;
    }

    try {
      final String response = await rootBundle.loadString('assets/data/notes-data.json');
      final List<dynamic> data = json.decode(response);
      
      _cachedNotes = data.map((json) => Note.fromJson(json)).toList();
      return _cachedNotes!;
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  // Generate quizzes from questions
  static Future<List<Quiz>> loadQuizzes() async {
    if (_cachedQuizzes != null) {
      return _cachedQuizzes!;
    }

    try {
      final questions = await loadQuestions();
      final Map<String, List<Question>> categorizedQuestions = {};

      // Group questions by category
      for (var question in questions) {
        if (!categorizedQuestions.containsKey(question.category)) {
          categorizedQuestions[question.category] = [];
        }
        categorizedQuestions[question.category]!.add(question);
      }

      // Create quizzes for each category
      _cachedQuizzes = categorizedQuestions.entries.map((entry) {
        return Quiz(
          id: entry.key.toLowerCase().replaceAll(' ', '_'),
          title: '${entry.key} Quiz',
          description: 'Practice questions for ${entry.key}',
          category: entry.key,
          questions: entry.value.take(10).toList(), // Take first 10 questions
          duration: 600, // 10 minutes
        );
      }).toList();

      return _cachedQuizzes!;
    } catch (e) {
      print('Error generating quizzes: $e');
      return [];
    }
  }

  // Get questions by category
  static Future<List<Question>> getQuestionsByCategory(String category) async {
    final questions = await loadQuestions();
    return questions.where((q) => q.category == category).toList();
  }

  // Get quiz by ID
  static Future<Quiz?> getQuizById(String id) async {
    final quizzes = await loadQuizzes();
    return quizzes.firstWhere((quiz) => quiz.id == id);
  }

  // Get notes by topic
  static Future<List<Note>> getNotesByTopic(String topic) async {
    final notes = await loadNotes();
    return notes.where((note) => note.topic.toLowerCase().contains(topic.toLowerCase())).toList();
  }

  // Clear cache (useful for testing or updates)
  static void clearCache() {
    _cachedQuestions = null;
    _cachedNotes = null;
    _cachedQuizzes = null;
  }

  // Get random questions for practice
  static Future<List<Question>> getRandomQuestions(int count) async {
    final questions = await loadQuestions();
    questions.shuffle();
    return questions.take(count).toList();
  }

  // Get available categories
  static Future<List<String>> getCategories() async {
    final questions = await loadQuestions();
    return questions.map((q) => q.category).toSet().toList();
  }
}
```
