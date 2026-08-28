class TodoItem {
  final String id;
  final String title;
  final bool isDone;

  const TodoItem({required this.id, required this.title, this.isDone = false});

  TodoItem copyWith({String? id, String? title, bool? isDone}) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
