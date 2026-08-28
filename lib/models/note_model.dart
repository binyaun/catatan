import 'package:flutter/material.dart';

import 'todo_item.dart';

enum NotePriority { high, medium, low }

class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  final bool isPinned;
  final int colorIndex;
  final NotePriority priority;
  final List<String> tags;
  final List<TodoItem> todos;
  final bool isArchived;
  final bool isTrashed;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.isPinned = false,
    this.colorIndex = 0,
    this.priority = NotePriority.medium,
    this.tags = const [],
    this.todos = const [],
    this.isArchived = false,
    this.isTrashed = false,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    DateTime? createdAt,
    bool? isPinned,
    int? colorIndex,
    NotePriority? priority,
    List<String>? tags,
    List<TodoItem>? todos,
    bool? isArchived,
    bool? isTrashed,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isPinned: isPinned ?? this.isPinned,
      colorIndex: colorIndex ?? this.colorIndex,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      todos: todos ?? this.todos,
      isArchived: isArchived ?? this.isArchived,
      isTrashed: isTrashed ?? this.isTrashed,
    );
  }

  // Gen Z Vibrant Pastel Palette
  static const List<Color> noteColors = [
    Color(0xFFF3E8FF), // Soft Lavender
    Color(0xFFE0F2FE), // Ice Sky Blue
    Color(0xFFDCFCE7), // Fresh Mint
    Color(0xFFFFEDD5), // Peach Sorbet
    Color(0xFFFEF9C3), // Butter Yellow
    Color(0xFFFFE4E6), // Cotton Pink
  ];

  Color get color => noteColors[colorIndex % noteColors.length];

  int get completedTodosCount => todos.where((t) => t.isDone).length;
  int get totalTodosCount => todos.length;
  double get todoProgressRatio =>
      totalTodosCount == 0 ? 0.0 : completedTodosCount / totalTodosCount;

  String get priorityLabel {
    switch (priority) {
      case NotePriority.high:
        return 'Tinggi';
      case NotePriority.medium:
        return 'Sedang';
      case NotePriority.low:
        return 'Rendah';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case NotePriority.high:
        return const Color(0xFFFF3366); // Neon Rose/Crimson
      case NotePriority.medium:
        return const Color(0xFFFF9F43); // Vivid Tangerine
      case NotePriority.low:
        return const Color(0xFF10B981); // Emerald Green
    }
  }
}
