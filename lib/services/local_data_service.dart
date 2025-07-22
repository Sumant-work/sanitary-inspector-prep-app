import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/note.dart';

class LocalDataService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<List<Question>> getQuestions({String? category}) async {
    try {
      final String response = await rootBundle.loadString('assets/data/questions-data.json');
      final Map<String, dynamic> data = json.decode(response);
      List questionsRaw = data['questions'] ?? [];
      List<Question> questions = questionsRaw.map((json) => Question.fromJson(json)).toList();
      if (category != null) {
        questions = questions.where((q) => q.category == category).toList();
      }
      return questions;
    } catch (e) {
      print('Error loading questions: $e');
      return [];
    }
  }

  static Future<List<Note>> getNotes({String? category}) async {
    try {
      final String response = await rootBundle.loadString('assets/data/notes-data.json');
      final Map<String, dynamic> data = json.decode(response);
      List notesRaw = data['notes'] ?? [];
      List<Note> notes = notesRaw.map((json) => Note.fromJson(json)).toList();
      if (category != null) {
        notes = notes.where((n) => n.category == category).toList();
      }
      return notes;
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  // Add similar methods for other data
}
