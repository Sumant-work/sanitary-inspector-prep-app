import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String category;
  final String difficulty;
  final String? year;
  final String? imageUrl;
  final int? userAnswer;
  final bool isAnswered;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.category,
    required this.difficulty,
    this.year,
    this.imageUrl,
    this.userAnswer,
    this.isAnswered = false,
  });

  // Create from Firestore document
  factory Question.fromFirestore(Map<String, dynamic> data, String id) {
    return Question(
      id: id,
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
      explanation: data['explanation'] ?? '',
      category: data['category'] ?? '',
      difficulty: data['difficulty'] ?? 'Medium',
      year: data['year'],
      imageUrl: data['imageUrl'],
      userAnswer: data['userAnswer'],
      isAnswered: data['isAnswered'] ?? false,
    );
  }

  // Create from JSON (backward compatibility)
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      year: json['year'],
      imageUrl: json['imageUrl'],
      userAnswer: json['userAnswer'],
      isAnswered: json['isAnswered'] ?? false,
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
      'year': year,
      'imageUrl': imageUrl,
      'userAnswer': userAnswer,
      'isAnswered': isAnswered,
    };
  }

  Question copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    String? category,
    String? difficulty,
    String? year,
    String? imageUrl,
    int? userAnswer,
    bool? isAnswered,
  }) {
    return Question(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      year: year ?? this.year,
      imageUrl: imageUrl ?? this.imageUrl,
      userAnswer: userAnswer ?? this.userAnswer,
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }

  bool get isCorrect => userAnswer == correctAnswerIndex;
}
