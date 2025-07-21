# Note Model

```dart
class Note {
  final String id;
  final String title;
  final String content;
  final String topic;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String author;
  final int readingTimeMinutes;
  final NotePriority priority;
  final bool isFavorite;
  final String? imageUrl;
  final List<String> relatedTopics;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.topic,
    required this.category,
    this.tags = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.author = 'Sanitary Inspector Prep Team',
    this.readingTimeMinutes = 5,
    this.priority = NotePriority.normal,
    this.isFavorite = false,
    this.imageUrl,
    this.relatedTopics = const [],
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Get word count
  int get wordCount => content.split(' ').length;

  // Get character count
  int get characterCount => content.length;

  // Get estimated reading time based on content
  int get estimatedReadingTime {
    // Average reading speed is 200-250 words per minute
    const averageWordsPerMinute = 225;
    return (wordCount / averageWordsPerMinute).ceil().clamp(1, 60);
  }

  // Check if note is recently updated (within last 7 days)
  bool get isRecentlyUpdated {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return updatedAt.isAfter(weekAgo);
  }

  // Get content preview (first 150 characters)
  String get contentPreview {
    if (content.length <= 150) return content;
    return '${content.substring(0, 147)}...';
  }

  // Get formatted content with basic markdown support
  String get formattedContent {
    return content
        .replaceAll('\n\n', '\n')  // Remove extra line breaks
        .replaceAll('**', '')       // Remove bold markers for now
        .replaceAll('*', '')        // Remove italic markers for now
        .trim();
  }

  // Create Note from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      topic: json['topic']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      author: json['author']?.toString() ?? 'Sanitary Inspector Prep Team',
      readingTimeMinutes: json['readingTimeMinutes'] ?? 5,
      priority: NotePriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => NotePriority.normal,
      ),
      isFavorite: json['isFavorite'] ?? false,
      imageUrl: json['imageUrl'],
      relatedTopics: List<String>.from(json['relatedTopics'] ?? []),
    );
  }

  // Convert Note to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'topic': topic,
      'category': category,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'author': author,
      'readingTimeMinutes': readingTimeMinutes,
      'priority': priority.name,
      'isFavorite': isFavorite,
      'imageUrl': imageUrl,
      'relatedTopics': relatedTopics,
    };
  }

  // Create a copy with modified fields
  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? topic,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? author,
    int? readingTimeMinutes,
    NotePriority? priority,
    bool? isFavorite,
    String? imageUrl,
    List<String>? relatedTopics,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      topic: topic ?? this.topic,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      priority: priority ?? this.priority,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      relatedTopics: relatedTopics ?? this.relatedTopics,
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, topic: $topic, category: $category}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ content.hashCode;
  }
}

// Enum for note priority
enum NotePriority {
  low,
  normal,
  high,
  critical,
}

// Extension for NotePriority
extension NotePriorityExtension on NotePriority {
  String get displayName {
    switch (this) {
      case NotePriority.low:
        return 'Low';
      case NotePriority.normal:
        return 'Normal';
      case NotePriority.high:
        return 'High';
      case NotePriority.critical:
        return 'Critical';
    }
  }

  int get value {
    switch (this) {
      case NotePriority.low:
        return 1;
      case NotePriority.normal:
        return 2;
      case NotePriority.high:
        return 3;
      case NotePriority.critical:
        return 4;
    }
  }
}

// Class for note sections/chapters
class NoteSection {
  final String id;
  final String title;
  final String content;
  final int order;
  final List<String> keyPoints;
  final List<String> examples;
  final List<String> relatedQuestions;

  const NoteSection({
    required this.id,
    required this.title,
    required this.content,
    this.order = 0,
    this.keyPoints = const [],
    this.examples = const [],
    this.relatedQuestions = const [],
  });

  factory NoteSection.fromJson(Map<String, dynamic> json) {
    return NoteSection(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      order: json['order'] ?? 0,
      keyPoints: List<String>.from(json['keyPoints'] ?? []),
      examples: List<String>.from(json['examples'] ?? []),
      relatedQuestions: List<String>.from(json['relatedQuestions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'order': order,
      'keyPoints': keyPoints,
      'examples': examples,
      'relatedQuestions': relatedQuestions,
    };
  }
}

// Class for user's note reading progress
class NoteProgress {
  final String noteId;
  final String userId;
  final bool isRead;
  final bool isBookmarked;
  final int readingProgress; // Percentage (0-100)
  final DateTime? lastReadAt;
  final int timeSpentSeconds;
  final Map<String, bool> sectionProgress; // Section ID -> completed

  const NoteProgress({
    required this.noteId,
    required this.userId,
    this.isRead = false,
    this.isBookmarked = false,
    this.readingProgress = 0,
    this.lastReadAt,
    this.timeSpentSeconds = 0,
    this.sectionProgress = const {},
  });

  // Check if note is completed
  bool get isCompleted => readingProgress >= 100;

  // Get completed sections count
  int get completedSections => sectionProgress.values.where((v) => v).length;

  factory NoteProgress.fromJson(Map<String, dynamic> json) {
    return NoteProgress(
      noteId: json['noteId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      isRead: json['isRead'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
      readingProgress: json['readingProgress'] ?? 0,
      lastReadAt: json['lastReadAt'] != null
          ? DateTime.parse(json['lastReadAt'])
          : null,
      timeSpentSeconds: json['timeSpentSeconds'] ?? 0,
      sectionProgress: Map<String, bool>.from(json['sectionProgress'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'userId': userId,
      'isRead': isRead,
      'isBookmarked': isBookmarked,
      'readingProgress': readingProgress,
      'lastReadAt': lastReadAt?.toIso8601String(),
      'timeSpentSeconds': timeSpentSeconds,
      'sectionProgress': sectionProgress,
    };
  }
}

// Class for note categories
class NoteCategory {
  final String id;
  final String name;
  final String description;
  final String? iconName;
  final int noteCount;
  final bool isActive;

  const NoteCategory({
    required this.id,
    required this.name,
    required this.description,
    this.iconName,
    this.noteCount = 0,
    this.isActive = true,
  });

  factory NoteCategory.fromJson(Map<String, dynamic> json) {
    return NoteCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      iconName: json['iconName']?.toString(),
      noteCount: json['noteCount'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'noteCount': noteCount,
      'isActive': isActive,
    };
  }
}

// Class for study session (reading notes)
class StudySession {
  final String id;
  final String userId;
  final List<String> noteIds;
  final DateTime startTime;
  final DateTime? endTime;
  final int totalTimeSpent; // in seconds
  final Map<String, int> noteTimeSpent; // noteId -> seconds
  final bool isCompleted;

  const StudySession({
    required this.id,
    required this.userId,
    required this.noteIds,
    required this.startTime,
    this.endTime,
    this.totalTimeSpent = 0,
    this.noteTimeSpent = const {},
    this.isCompleted = false,
  });

  // Get session duration
  Duration get sessionDuration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  // Get notes read count
  int get notesReadCount => noteTimeSpent.keys.length;

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      noteIds: List<String>.from(json['noteIds'] ?? []),
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      totalTimeSpent: json['totalTimeSpent'] ?? 0,
      noteTimeSpent: Map<String, int>.from(json['noteTimeSpent'] ?? {}),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'noteIds': noteIds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalTimeSpent': totalTimeSpent,
      'noteTimeSpent': noteTimeSpent,
      'isCompleted': isCompleted,
    };
  }
}
```
