import 'package:flutter/material.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  final bool isPinned;
  final int colorIndex;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    this.isPinned = false,
    this.colorIndex = 0,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    DateTime? createdAt,
    bool? isPinned,
    int? colorIndex,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isPinned: isPinned ?? this.isPinned,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  static const List<Color> noteColors = [
    Color(0xFFE8F5E9), // Light Green
    Color(0xFFE3F2FD), // Light Blue
    Color(0xFFFFF3E0), // Light Orange
    Color(0xFFF3E5F5), // Light Purple
    Color(0xFFFFEBEE), // Light Red
    Color(0xFFE0F2F1), // Light Teal
  ];

  Color get color => noteColors[colorIndex % noteColors.length];
}
