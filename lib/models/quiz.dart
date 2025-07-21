# Quiz Model

```dart
import 'question.dart';

class Quiz {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<Question> questions;
  final int duration; // Duration in seconds
  final QuizType type;
  final DifficultyLevel difficulty;
  final int passingScore; // Percentage needed to pass
  final DateTime createdAt;
  final bool isActive;
  final String? imageUrl;
  final List<String> tags;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
    this.duration = 600, // Default 10 minutes
    this.type = QuizType.practice,
    this.difficulty = DifficultyLevel.medium,
    this.passingScore = 60,
    DateTime? createdAt,
    this.isActive = true,
    this.imageUrl,
    this.tags = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  // Get total number of questions
  int get totalQuestions => questions.length;

  // Get maximum possible score
  int get maxScore => questions.length;

  // Get estimated duration in minutes
  int get durationInMinutes => (duration / 60).round();

  // Check if quiz has enough questions
  bool get hasEnoughQuestions => questions.length >= 5;

  // Get questions by difficulty
  List<Question> getQuestionsByDifficulty(DifficultyLevel level) {
    return questions.where((q) => q.difficultyLevel == level).toList();
  }

  // Get random questions
  List<Question> getRandomQuestions(int count) {
    final shuffled = List<Question>.from(questions)..shuffle();
    return shuffled.take(count).toList();
  }

  // Create Quiz from JSON
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      duration: json['duration'] ?? 600,
      type: QuizType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => QuizType.practice,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (level) => level.name == json['difficulty'],
        orElse: () => DifficultyLevel.medium,
      ),
      passingScore: json['passingScore'] ?? 60,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  // Convert Quiz to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'questions': questions.map((q) => q.toJson()).toList(),
      'duration': duration,
      'type': type.name,
      'difficulty': difficulty.name,
      'passingScore': passingScore,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'imageUrl': imageUrl,
      'tags': tags,
    };
  }

  // Create a copy with modified fields
  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<Question>? questions,
    int? duration,
    QuizType? type,
    DifficultyLevel? difficulty,
    int? passingScore,
    DateTime? createdAt,
    bool? isActive,
    String? imageUrl,
    List<String>? tags,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      questions: questions ?? this.questions,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      passingScore: passingScore ?? this.passingScore,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'Quiz{id: $id, title: $title, category: $category, questions: ${questions.length}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Quiz &&
        other.id == id &&
        other.title == title &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ category.hashCode;
  }
}

// Enum for quiz types
enum QuizType {
  practice,
  mock,
  live,
  daily,
}

// Extension for QuizType
extension QuizTypeExtension on QuizType {
  String get displayName {
    switch (this) {
      case QuizType.practice:
        return 'Practice Quiz';
      case QuizType.mock:
        return 'Mock Test';
      case QuizType.live:
        return 'Live Test';
      case QuizType.daily:
        return 'Daily Quiz';
    }
  }

  String get description {
    switch (this) {
      case QuizType.practice:
        return 'Practice questions without time pressure';
      case QuizType.mock:
        return 'Simulate real exam conditions';
      case QuizType.live:
        return 'Compete with others in real-time';
      case QuizType.daily:
        return 'Daily challenge questions';
    }
  }

  bool get isTimed {
    switch (this) {
      case QuizType.practice:
        return false;
      case QuizType.mock:
      case QuizType.live:
      case QuizType.daily:
        return true;
    }
  }
}

// Class for quiz results
class QuizResult {
  final String quizId;
  final String userId;
  final List<UserAnswer> answers;
  final int score;
  final int totalQuestions;
  final DateTime startTime;
  final DateTime endTime;
  final int timeSpentInSeconds;
  final bool passed;
  final double percentage;
  final Map<String, int> categoryScores;

  const QuizResult({
    required this.quizId,
    required this.userId,
    required this.answers,
    required this.score,
    required this.totalQuestions,
    required this.startTime,
    required this.endTime,
    required this.timeSpentInSeconds,
    required this.passed,
    required this.percentage,
    this.categoryScores = const {},
  });

  // Get correct answers count
  int get correctAnswers => answers.where((a) => a.isCorrect).length;

  // Get incorrect answers count
  int get incorrectAnswers => answers.where((a) => !a.isCorrect).length;

  // Get unanswered questions count
  int get unansweredQuestions => totalQuestions - answers.length;

  // Get average time per question
  double get averageTimePerQuestion {
    if (answers.isEmpty) return 0.0;
    return timeSpentInSeconds / answers.length;
  }

  // Get grade based on percentage
  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'D';
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => UserAnswer.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
      timeSpentInSeconds: json['timeSpentInSeconds'] ?? 0,
      passed: json['passed'] ?? false,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      categoryScores: Map<String, int>.from(json['categoryScores'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'userId': userId,
      'answers': answers.map((a) => a.toJson()).toList(),
      'score': score,
      'totalQuestions': totalQuestions,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'timeSpentInSeconds': timeSpentInSeconds,
      'passed': passed,
      'percentage': percentage,
      'categoryScores': categoryScores,
    };
  }
}

// Class for quiz session (ongoing quiz)
class QuizSession {
  final String id;
  final Quiz quiz;
  final DateTime startTime;
  final List<UserAnswer> answers;
  final int currentQuestionIndex;
  final bool isCompleted;
  final bool isSubmitted;
  final Timer? timer;

  const QuizSession({
    required this.id,
    required this.quiz,
    required this.startTime,
    this.answers = const [],
    this.currentQuestionIndex = 0,
    this.isCompleted = false,
    this.isSubmitted = false,
    this.timer,
  });

  // Get current question
  Question? get currentQuestion {
    if (currentQuestionIndex >= quiz.questions.length) return null;
    return quiz.questions[currentQuestionIndex];
  }

  // Get remaining time in seconds
  int get remainingTimeInSeconds {
    if (!quiz.type.isTimed) return -1; // No time limit
    final elapsed = DateTime.now().difference(startTime).inSeconds;
    return quiz.duration - elapsed;
  }

  // Check if time is up
  bool get isTimeUp => remainingTimeInSeconds <= 0 && quiz.type.isTimed;

  // Get progress percentage
  double get progress {
    if (quiz.totalQuestions == 0) return 0.0;
    return (currentQuestionIndex / quiz.totalQuestions) * 100;
  }

  // Get score so far
  int get currentScore => answers.where((a) => a.isCorrect).length;

  // Check if last question
  bool get isLastQuestion => currentQuestionIndex >= quiz.totalQuestions - 1;

  // Check if first question
  bool get isFirstQuestion => currentQuestionIndex == 0;

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      id: json['id']?.toString() ?? '',
      quiz: Quiz.fromJson(json['quiz'] ?? {}),
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => UserAnswer.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      isSubmitted: json['isSubmitted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz': quiz.toJson(),
      'startTime': startTime.toIso8601String(),
      'answers': answers.map((a) => a.toJson()).toList(),
      'currentQuestionIndex': currentQuestionIndex,
      'isCompleted': isCompleted,
      'isSubmitted': isSubmitted,
    };
  }
}

// Import for Timer class
class Timer {
  // Placeholder for Timer functionality
  // In a real implementation, you'd use dart:async Timer
}
```
