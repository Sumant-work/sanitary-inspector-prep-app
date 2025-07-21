import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart';
import '../models/quiz.dart';
import '../models/note.dart';

class DataLoader {
  static List<Question>? _questionsCache;
  static List<Note>? _notesCache;

  // Loads all notes from JSON and caches them
  static Future<List<Note>> loadNotes() async {
    if (_notesCache != null) return _notesCache!;
    try {
      final String response = await rootBundle.loadString('assets/data/notes-data.json');
      final Map<String, dynamic> data = json.decode(response);
      List notesRaw = data['notes'] ?? [];
      _notesCache = notesRaw.map((json) => Note.fromJson(json)).toList();
      return _notesCache!;
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  // Loads all questions from JSON and caches them
  static Future<List<Question>> loadQuestions() async {
    if (_questionsCache != null) return _questionsCache!;
    try {
      final String response = await rootBundle.loadString('assets/data/questions-data.json');
      final Map<String, dynamic> data = json.decode(response);
      List questionsRaw = data['questions'] ?? [];
      _questionsCache = questionsRaw.map((json) => Question.fromJson(json)).toList();
      return _questionsCache!;
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }

  // Loads all categories for notes
  static Future<List<Map<String, dynamic>>> loadNoteCategories() async {
    try {
      final String response = await rootBundle.loadString('assets/data/notes-data.json');
      final Map<String, dynamic> data = json.decode(response);
      List cats = data['categories'] ?? [];
      return cats.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading note categories: $e');
      return [];
    }
  }
}
