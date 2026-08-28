import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/note_model.dart';
import '../services/note_repository.dart';
import '../widgets/note_card.dart';
import '../widgets/note_editor_dialog.dart';
import '../widgets/stats_dialog.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleDarkMode;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteRepository _repository = NoteRepository();

  String _filterType = 'active'; // 'active', 'pinned', 'archived', 'trash'
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  String _selectedTag = 'Semua';
  NoteSortOption _sortOption = NoteSortOption.dateNewest;
  bool _isGridView = true;

  List<String> get _categories => [
    'Semua',
    'Kuliah',
    'Praktikum',
    'Tugas',
    'Lainnya',
  ];

  void _openNoteEditor([Note? note]) {
    showDialog(
      context: context,
      builder: (context) => NoteEditorDialog(
        note: note,
        onSave: (savedNote) {
          setState(() {
            if (note == null) {
              _repository.addNote(savedNote);
            } else {
              _repository.updateNote(savedNote);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                note == null
                    ? 'Catatan baru berhasil ditambahkan! ✨'
                    : 'Catatan berhasil diperbarui! 🚀',
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _showNoteDetails(Note note) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: note.priorityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Prioritas ${note.priorityLabel}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: note.priorityColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Kategori: ${note.category}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Divider(height: 24),
                Text(
                  note.content,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
                if (note.todos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Checklist Sub-Task:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...note.todos.map(
                    (todo) => CheckboxListTile(
                      dense: true,
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      value: todo.isDone,
                      onChanged: (val) {
                        setState(() {
                          _repository.toggleTodoStatus(note.id, todo.id);
                        });
                        Navigator.pop(context);
                        _showNoteDetails(
                          _repository.allNotes.firstWhere(
                            (n) => n.id == note.id,
                          ),
                        );
                      },
                    ),
                  ),
                ],
                if (note.tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 6,
                    children: note.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filledTonal(
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      tooltip: 'Salin Ringkasan Catatan',
                      onPressed: () {
                        final summaryText = '${note.title}\n\n${note.content}';
                        Clipboard.setData(ClipboardData(text: summaryText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Catatan berhasil disalin! 📋'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _openNoteEditor(note);
                          },
                          child: const Text('Edit'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStats() {
    showDialog(
      context: context,
      builder: (context) => StatsDialog(stats: _repository.getStatistics()),
    );
  }

  String get _currentTabTitle {
    switch (_filterType) {
      case 'pinned':
        return 'Disematkan 📌';
      case 'archived':
        return 'Diarsip 📦';
      case 'trash':
        return 'Kotak Sampah 🗑️';
      default:
        return 'Catatan POLNES ✨';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayedNotes = _repository.getFilteredNotes(
      filterType: _filterType,
      searchQuery: _searchQuery,
      selectedCategory: _selectedCategory,
      selectedTag: _selectedTag,
      sortOption: _sortOption,
    );

    final allTags = ['Semua', ..._repository.getAllTags()];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentTabTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Politeknik Negeri Samarinda',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: widget.isDarkMode ? 'Mode Terang' : 'Mode Gelap',
            onPressed: widget.onToggleDarkMode,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Statistik Catatan',
            onPressed: _showStats,
          ),
          PopupMenuButton<NoteSortOption>(
            icon: const Icon(Icons.swap_vert_rounded),
            tooltip: 'Urutkan Catatan',
            onSelected: (option) {
              setState(() {
                _sortOption = option;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: NoteSortOption.dateNewest,
                child: Text('Tanggal Terbaru'),
              ),
              const PopupMenuItem(
                value: NoteSortOption.dateOldest,
                child: Text('Tanggal Terlama'),
              ),
              const PopupMenuItem(
                value: NoteSortOption.titleAz,
                child: Text('Judul (A-Z)'),
              ),
              const PopupMenuItem(
                value: NoteSortOption.priorityHighToLow,
                child: Text('Prioritas (Tinggi-Rendah)'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_agenda_rounded : Icons.grid_view_rounded,
            ),
            tooltip: _isGridView ? 'Tampilan List' : 'Tampilan Grid',
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 32,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Mahasiswa POLNES 🎓',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'praktikum.mobile@polnes.ac.id',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: const Icon(Icons.note_alt_rounded),
                    title: const Text('Semua Catatan Aktif'),
                    selected: _filterType == 'active',
                    onTap: () {
                      setState(() {
                        _filterType = 'active';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.push_pin_rounded),
                    title: const Text('Disematkan (Pinned)'),
                    selected: _filterType == 'pinned',
                    onTap: () {
                      setState(() {
                        _filterType = 'pinned';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.archive_rounded),
                    title: const Text('Diarsip (Archived)'),
                    selected: _filterType == 'archived',
                    onTap: () {
                      setState(() {
                        _filterType = 'archived';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_rounded),
                    title: const Text('Kotak Sampah (Trash)'),
                    selected: _filterType == 'trash',
                    onTap: () {
                      setState(() {
                        _filterType = 'trash';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.analytics_rounded),
                    title: const Text('Dashboard Statistik'),
                    onTap: () {
                      Navigator.pop(context);
                      _showStats();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari catatan, isi, atau #tag...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Categories & Tags Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ..._categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (allTags.length > 1) ...[
            const SizedBox(height: 4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ...allTags.map((tag) {
                    final isSelected = _selectedTag == tag;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTag = selected ? tag : 'Semua';
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),

          // Notes List or Grid
          Expanded(
            child: displayedNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _filterType == 'trash'
                              ? Icons.delete_sweep_rounded
                              : Icons.note_alt_outlined,
                          size: 72,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _filterType == 'trash'
                              ? 'Kotak sampah kosong'
                              : 'Belum ada catatan nih 📝',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.outline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_filterType != 'trash')
                          Text(
                            'Tekan tombol + di bawah untuk membuat catatan baru!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                      ],
                    ),
                  )
                : _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: displayedNotes.length,
                    itemBuilder: (context, index) {
                      final note = displayedNotes[index];
                      return NoteCard(
                        note: note,
                        onTap: () => _showNoteDetails(note),
                        onTogglePin: () {
                          setState(() {
                            _repository.togglePin(note.id);
                          });
                        },
                        onToggleArchive: () {
                          setState(() {
                            if (note.isTrashed) {
                              _repository.restoreFromTrash(note.id);
                            } else {
                              _repository.toggleArchive(note.id);
                            }
                          });
                        },
                        onDeleteOrTrash: () {
                          setState(() {
                            if (note.isTrashed) {
                              _repository.deletePermanently(note.id);
                            } else {
                              _repository.moveToTrash(note.id);
                            }
                          });
                        },
                        onToggleTodo: (todoId) {
                          setState(() {
                            _repository.toggleTodoStatus(note.id, todoId);
                          });
                        },
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayedNotes.length,
                    itemBuilder: (context, index) {
                      final note = displayedNotes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NoteCard(
                          note: note,
                          onTap: () => _showNoteDetails(note),
                          onTogglePin: () {
                            setState(() {
                              _repository.togglePin(note.id);
                            });
                          },
                          onToggleArchive: () {
                            setState(() {
                              if (note.isTrashed) {
                                _repository.restoreFromTrash(note.id);
                              } else {
                                _repository.toggleArchive(note.id);
                              }
                            });
                          },
                          onDeleteOrTrash: () {
                            setState(() {
                              if (note.isTrashed) {
                                _repository.deletePermanently(note.id);
                              } else {
                                _repository.moveToTrash(note.id);
                              }
                            });
                          },
                          onToggleTodo: (todoId) {
                            setState(() {
                              _repository.toggleTodoStatus(note.id, todoId);
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteEditor(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Catatan'),
      ),
    );
  }
}
