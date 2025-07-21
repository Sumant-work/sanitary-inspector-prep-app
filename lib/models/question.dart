# Question Model

```dart
class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String category;
  final String difficulty;
  final int year;
  final List<String> tags;

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.category,
    required this.difficulty,
    required this.year,
    this.tags = const [],
  });

  // Get the correct answer text
  String get correctAnswer => options[correctAnswerIndex];

  // Check if given answer index is correct
  bool isCorrectAnswer(int answerIndex) {
    return answerIndex == correctAnswerIndex;
  }

  // Get difficulty level as enum
  DifficultyLevel get difficultyLevel {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return DifficultyLevel.easy;
      case 'medium':
        return DifficultyLevel.medium;
      case 'hard':
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.medium;
    }
  }

  // Create Question from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      difficulty: json['difficulty']?.toString() ?? 'Medium',
      year: json['year'] ?? DateTime.now().year,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  // Convert Question to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
      'year': year,
      'tags': tags,
    };
  }

  // Create a copy with modified fields
  Question copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    String? category,
    String? difficulty,
    int? year,
    List<String>? tags,
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
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'Question{id: $id, question: $question, category: $category, difficulty: $difficulty}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Question &&
        other.id == id &&
        other.question == question &&
        other.correctAnswerIndex == correctAnswerIndex &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        correctAnswerIndex.hashCode ^
        category.hashCode;
  }
}

// Enum for difficulty levels
enum DifficultyLevel {
  easy,
  medium,
  hard,
}

// Extension for DifficultyLevel
extension DifficultyLevelExtension on DifficultyLevel {
  String get displayName {
    switch (this) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }

  int get points {
    switch (this) {
      case DifficultyLevel.easy:
        return 1;
      case DifficultyLevel.medium:
        return 2;
      case DifficultyLevel.hard:
        return 3;
    }
  }
}

// Class for user's answer to a question
class UserAnswer {
  final String questionId;
  final int selectedAnswerIndex;
  final bool isCorrect;
  final DateTime answeredAt;
  final int timeSpentInSeconds;

  const UserAnswer({
    required this.questionId,
    required this.selectedAnswerIndex,
    required this.isCorrect,
    required this.answeredAt,
    this.timeSpentInSeconds = 0,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['questionId']?.toString() ?? '',
      selectedAnswerIndex: json['selectedAnswerIndex'] ?? -1,
      isCorrect: json['isCorrect'] ?? false,
      answeredAt: DateTime.parse(json['answeredAt'] ?? DateTime.now().toIso8601String()),
      timeSpentInSeconds: json['timeSpentInSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedAnswerIndex': selectedAnswerIndex,
      'isCorrect': isCorrect,
      'answeredAt': answeredAt.toIso8601String(),
      'timeSpentInSeconds': timeSpentInSeconds,
    };
  }
}

// Question statistics for analytics
class QuestionStats {
  final String questionId;
  final int totalAttempts;
  final int correctAttempts;
  final double averageTimeSpent;
  final DateTime lastAttempted;

  const QuestionStats({
    required this.questionId,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
    this.averageTimeSpent = 0.0,
    required this.lastAttempted,
  });

  double get accuracyRate {
    if (totalAttempts == 0) return 0.0;
    return (correctAttempts / totalAttempts) * 100;
  }

  factory QuestionStats.fromJson(Map<String, dynamic> json) {
    return QuestionStats(
      questionId: json['questionId']?.toString() ?? '',
      totalAttempts: json['totalAttempts'] ?? 0,
      correctAttempts: json['correctAttempts'] ?? 0,
      averageTimeSpent: (json['averageTimeSpent'] ?? 0.0).toDouble(),
      lastAttempted: DateTime.parse(json['lastAttempted'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'totalAttempts': totalAttempts,
      'correctAttempts': correctAttempts,
      'averageTimeSpent': averageTimeSpent,
      'lastAttempted': lastAttempted.toIso8601String(),
    };
  }
}
```
