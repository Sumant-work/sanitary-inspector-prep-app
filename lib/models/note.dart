import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;
  final String? pdfUrl;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final bool isBookmarked;
  final int readingProgress;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    this.pdfUrl,
    this.priority = 1,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.isBookmarked = false,
    this.readingProgress = 0,
  });

  // Create from Firestore document
  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'],
      pdfUrl: data['pdfUrl'],
      priority: data['priority'] ?? 1,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tags: List<String>.from(data['tags'] ?? []),
      isBookmarked: data['isBookmarked'] ?? false,
      readingProgress: data['readingProgress'] ?? 0,
    );
  }

  // Create from JSON (backward compatibility)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'],
      pdfUrl: json['pdfUrl'],
      priority: json['priority'] ?? 1,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      tags: List<String>.from(json['tags'] ?? []),
      isBookmarked: json['isBookmarked'] ?? false,
      readingProgress: json['readingProgress'] ?? 0,
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'imageUrl': imageUrl,
      'pdfUrl': pdfUrl,
      'priority': priority,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'tags': tags,
      'isBookmarked': isBookmarked,
      'readingProgress': readingProgress,
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? imageUrl,
    String? pdfUrl,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    bool? isBookmarked,
    int? readingProgress,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      readingProgress: readingProgress ?? this.readingProgress,
    );
  }
}
