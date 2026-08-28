import 'package:flutter/material.dart';

import '../models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleArchive;
  final VoidCallback onDeleteOrTrash;
  final Function(String todoId)? onToggleTodo;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onTogglePin,
    required this.onToggleArchive,
    required this.onDeleteOrTrash,
    this.onToggleTodo,
  });

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().substring(2);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: note.isPinned ? 3 : 1,
      color: note.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: note.isPinned
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: Priority Badge & Title & Actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: note.priorityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: note.priorityColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      note.priorityLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: note.priorityColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!note.isTrashed)
                    IconButton(
                      icon: Icon(
                        note.isPinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        size: 18,
                        color: note.isPinned
                            ? theme.colorScheme.primary
                            : Colors.grey[600],
                      ),
                      onPressed: onTogglePin,
                      tooltip: note.isPinned ? 'Lepas Pin' : 'Sematkan',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(2),
                    ),
                ],
              ),
              const SizedBox(height: 6),

              // Content snippet
              Text(
                note.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.75),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Checklist summary if available
              if (note.todos.isNotEmpty) ...[
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_box_outlined,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Sub-task (${note.completedTodosCount}/${note.totalTodosCount})',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: note.todoProgressRatio,
                        minHeight: 4,
                        backgroundColor: Colors.black.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Tags if available
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: note.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 8),

              // Footer: Category, Date, Actions (Archive / Delete)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        note.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDate(note.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                      if (!note.isTrashed) ...[
                        IconButton(
                          icon: Icon(
                            note.isArchived
                                ? Icons.unarchive_outlined
                                : Icons.archive_outlined,
                            size: 16,
                            color: Colors.indigo,
                          ),
                          onPressed: onToggleArchive,
                          tooltip: note.isArchived ? 'Buka Arsip' : 'Arsipkan',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(2),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Colors.redAccent,
                          ),
                          onPressed: onDeleteOrTrash,
                          tooltip: 'Buang ke Sampah',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(2),
                        ),
                      ] else ...[
                        IconButton(
                          icon: const Icon(
                            Icons.restore_from_trash,
                            size: 16,
                            color: Colors.teal,
                          ),
                          onPressed: onToggleArchive, // Used as restore
                          tooltip: 'Pulihkan Catatan',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(2),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            size: 16,
                            color: Colors.red,
                          ),
                          onPressed: onDeleteOrTrash, // Permanent delete
                          tooltip: 'Hapus Permanen',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(2),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
