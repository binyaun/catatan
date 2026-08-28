import '../models/note_model.dart';
import '../models/todo_item.dart';

enum NoteSortOption { dateNewest, dateOldest, titleAz, priorityHighToLow }

class NoteRepository {
  final List<Note> _notes = [];

  NoteRepository() {
    _initMockNotes();
  }

  void _initMockNotes() {
    _notes.addAll([
      Note(
        id: '1',
        title: 'Praktikum Pemrograman Perangkat Bergerak',
        content: 'Materi Flutter 3.44 & Dart 3.12: Membuat aplikasi Catatan POLNES dengan fitur lengkap checklist, tags, dan statistik.',
        category: 'Praktikum',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isPinned: true,
        colorIndex: 0,
        priority: NotePriority.high,
        tags: ['#D3-TI', '#Flutter', '#Lab3'],
        todos: [
          const TodoItem(id: 't1', title: 'Setup Flutter 3.44', isDone: true),
          const TodoItem(
            id: 't2',
            title: 'Membuat Model & Service',
            isDone: true,
          ),
          const TodoItem(
            id: 't3',
            title: 'Implementasi UI Material 3',
            isDone: true,
          ),
          const TodoItem(
            id: 't4',
            title: 'Pengujian dengan flutter test',
            isDone: false,
          ),
        ],
      ),
      Note(
        id: '2',
        title: 'Jadwal Perkuliahan Sem 4 POLNES',
        content: 'Ruangan & Dosen Pengampu:\n- Pemrograman Bergerak (Pak Budi, Lab 3)\n- Basis Data Lanjut (Bu Ani, R.204)\n- Etika Profesi (Pak Andi, R.101)',
        category: 'Kuliah',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isPinned: true,
        colorIndex: 1,
        priority: NotePriority.medium,
        tags: ['#Jadwal', '#Kuliah'],
        todos: [
          const TodoItem(id: 't5', title: 'Cetak KRS Semester 4', isDone: true),
          const TodoItem(
            id: 't6',
            title: 'Beli Buku Modul Praktikum',
            isDone: false,
          ),
        ],
      ),
      Note(
        id: '3',
        title: 'Tugas Mandiri Basis Data Lanjut',
        content: 'Membuat ERD dan normalisasi tabel 3NF untuk sistem akademik kampus Politeknik Negeri Samarinda.',
        category: 'Tugas',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isPinned: false,
        colorIndex: 2,
        priority: NotePriority.high,
        tags: ['#BasisData', '#Tugas'],
        todos: [
          const TodoItem(id: 't7', title: 'Desain Diagram ERD', isDone: true),
          const TodoItem(id: 't8', title: 'Normalisasi ke 3NF', isDone: false),
          const TodoItem(
            id: 't9',
            title: 'Submit Laporan ke LMS POLNES',
            isDone: false,
          ),
        ],
      ),
      Note(
        id: '4',
        title: 'Persiapan Lomba IT Kampus',
        content: 'Ide aplikasi inovatif untuk efisiensi sistem antrian perpustakaan POLNES.',
        category: 'Lainnya',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isPinned: false,
        colorIndex: 3,
        priority: NotePriority.low,
        tags: ['#Inovasi', '#Lomba'],
        todos: [],
        isArchived: true,
      ),
    ]);
  }

  List<Note> get allNotes => List.unmodifiable(_notes);

  void addNote(Note note) {
    _notes.insert(0, note);
  }

  void updateNote(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      _notes[index] = note;
    }
  }

  void togglePin(String id) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index >= 0) {
      _notes[index] = _notes[index].copyWith(isPinned: !_notes[index].isPinned);
    }
  }

  void toggleArchive(String id) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index >= 0) {
      final current = _notes[index];
      _notes[index] = current.copyWith(
        isArchived: !current.isArchived,
        isPinned: false,
      );
    }
  }

  void moveToTrash(String id) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index >= 0) {
      _notes[index] = _notes[index].copyWith(isTrashed: true, isPinned: false);
    }
  }

  void restoreFromTrash(String id) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index >= 0) {
      _notes[index] = _notes[index].copyWith(isTrashed: false);
    }
  }

  void deletePermanently(String id) {
    _notes.removeWhere((n) => n.id == id);
  }

  void toggleTodoStatus(String noteId, String todoId) {
    final noteIndex = _notes.indexWhere((n) => n.id == noteId);
    if (noteIndex >= 0) {
      final note = _notes[noteIndex];
      final updatedTodos = note.todos.map((todo) {
        if (todo.id == todoId) {
          return todo.copyWith(isDone: !todo.isDone);
        }
        return todo;
      }).toList();
      _notes[noteIndex] = note.copyWith(todos: updatedTodos);
    }
  }

  List<String> getAllTags() {
    final tagsSet = <String>{};
    for (final note in _notes) {
      if (!note.isTrashed) {
        tagsSet.addAll(note.tags);
      }
    }
    return tagsSet.toList()..sort();
  }

  List<Note> getFilteredNotes({
    required String filterType, // 'active', 'pinned', 'archived', 'trash'
    String searchQuery = '',
    String selectedCategory = 'Semua',
    String selectedTag = 'Semua',
    NoteSortOption sortOption = NoteSortOption.dateNewest,
  }) {
    return _notes.where((note) {
      // Filter tab status
      if (filterType == 'active' && (note.isArchived || note.isTrashed)) {
        return false;
      }
      if (filterType == 'pinned' &&
          (!note.isPinned || note.isArchived || note.isTrashed)) {
        return false;
      }
      if (filterType == 'archived' && (!note.isArchived || note.isTrashed)) {
        return false;
      }
      if (filterType == 'trash' && !note.isTrashed) {
        return false;
      }

      // Filter search query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchesTitle = note.title.toLowerCase().contains(query);
        final matchesContent = note.content.toLowerCase().contains(query);
        final matchesTag = note.tags.any(
          (t) => t.toLowerCase().contains(query),
        );
        if (!matchesTitle && !matchesContent && !matchesTag) return false;
      }

      // Filter category
      if (selectedCategory != 'Semua' && note.category != selectedCategory) {
        return false;
      }

      // Filter tag
      if (selectedTag != 'Semua' && !note.tags.contains(selectedTag)) {
        return false;
      }

      return true;
    }).toList()..sort((a, b) {
      if (filterType == 'active') {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
      }

      switch (sortOption) {
        case NoteSortOption.dateNewest:
          return b.createdAt.compareTo(a.createdAt);
        case NoteSortOption.dateOldest:
          return a.createdAt.compareTo(b.createdAt);
        case NoteSortOption.titleAz:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case NoteSortOption.priorityHighToLow:
          return a.priority.index.compareTo(b.priority.index);
      }
    });
  }

  Map<String, dynamic> getStatistics() {
    final activeNotes = _notes.where((n) => !n.isTrashed).toList();
    final totalNotes = activeNotes.length;
    final totalPinned = activeNotes.where((n) => n.isPinned).length;
    final totalArchived = activeNotes.where((n) => n.isArchived).length;

    int totalTodos = 0;
    int completedTodos = 0;

    final categoryCounts = <String, int>{};
    for (final note in activeNotes) {
      categoryCounts[note.category] = (categoryCounts[note.category] ?? 0) + 1;
      totalTodos += note.totalTodosCount;
      completedTodos += note.completedTodosCount;
    }

    final todoCompletionRate = totalTodos == 0
        ? 0.0
        : (completedTodos / totalTodos) * 100;

    return {
      'totalNotes': totalNotes,
      'totalPinned': totalPinned,
      'totalArchived': totalArchived,
      'categoryCounts': categoryCounts,
      'totalTodos': totalTodos,
      'completedTodos': completedTodos,
      'todoCompletionRate': todoCompletionRate,
    };
  }
}
