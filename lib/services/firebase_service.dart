import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/question.dart';
import '../models/quiz.dart';
import '../models/note.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection names
  static const String questionsCollection = 'questions';
  static const String quizzesCollection = 'quizzes';
  static const String notesCollection = 'notes';
  static const String pyqCollection = 'pyq_papers';
  static const String categoriesCollection = 'categories';
  static const String userScoresCollection = 'user_scores';

  // Get questions from Firestore
  static Future<List<Question>> getQuestions({String? category}) async {
    try {
      Query query = _firestore.collection(questionsCollection);
      
      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => Question.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting questions: $e');
      return [];
    }
  }

  // Get notes from Firestore
  static Future<List<Note>> getNotes({String? category}) async {
    try {
      Query query = _firestore.collection(notesCollection);
      
      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting notes: $e');
      return [];
    }
  }

  // Get quiz templates from Firestore
  static Future<List<Quiz>> getQuizzes({String? type}) async {
    try {
      Query query = _firestore.collection(quizzesCollection);
      
      if (type != null && type.isNotEmpty) {
        query = query.where('type', isEqualTo: type);
      }

      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => Quiz.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting quizzes: $e');
      return [];
    }
  }

  // Get PYQ papers metadata
  static Future<List<Map<String, dynamic>>> getPYQPapers() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(pyqCollection)
          .orderBy('year', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>
              })
          .toList();
    } catch (e) {
      print('Error getting PYQ papers: $e');
      return [];
    }
  }

  // Get categories
  static Future<List<Map<String, dynamic>>> getCategories(String type) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(categoriesCollection)
          .where('type', isEqualTo: type)
          .get();
      
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>
              })
          .toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  // Save quiz score
  static Future<void> saveQuizScore({
    required String userId,
    required String quizId,
    required int score,
    required int totalQuestions,
    required int timeTaken,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      await _firestore.collection(userScoresCollection).add({
        'userId': userId,
        'quizId': quizId,
        'score': score,
        'totalQuestions': totalQuestions,
        'percentage': (score / totalQuestions * 100).round(),
        'timeTaken': timeTaken,
        'answers': answers,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving quiz score: $e');
    }
  }

  // Get user's quiz history
  static Future<List<Map<String, dynamic>>> getUserScores(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(userScoresCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>
              })
          .toList();
    } catch (e) {
      print('Error getting user scores: $e');
      return [];
    }
  }

  // Real-time data streams
  static Stream<QuerySnapshot> getQuestionsStream({String? category}) {
    Query query = _firestore.collection(questionsCollection);
    
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    
    return query.snapshots();
  }

  static Stream<QuerySnapshot> getNotesStream({String? category}) {
    Query query = _firestore.collection(notesCollection);
    
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    
    return query.snapshots();
  }
}
