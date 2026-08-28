import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../widgets/note_card.dart';
import '../widgets/note_editor_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Praktikum Pemrograman Perangkat Bergerak',
      content: 'Materi Flutter 3.44 & Dart 3.12: Membuat aplikasi Catatan POLNES dengan arsitektur bersih dan Material 3 design system.',
      category: 'Praktikum',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isPinned: true,
      colorIndex: 0,
    ),
    Note(
      id: '2',
      title: 'Jadwal Perkuliahan POLNES',
      content: 'Senin: Pemrograman Perangkat Bergerak (Lab Komputer 3)\nRabu: Basis Data Lanjut (R. 204)\nJumat: Kewirausahaan (R. 102)',
      category: 'Kuliah',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isPinned: true,
      colorIndex: 1,
    ),
    Note(
      id: '3',
      title: 'Tugas Proyek Akhir',
      content: 'Menyelesaikan implementasi UI & State Management aplikasi mobile untuk praktikum Politeknik Negeri Samarinda.',
      category: 'Tugas',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isPinned: false,
      colorIndex: 2,
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  bool _isGridView = true;

  List<String> get _categories => [
    'Semua',
    'Kuliah',
    'Praktikum',
    'Tugas',
    'Lainnya',
  ];

  List<Note> get _filteredNotes {
    return _notes.where((note) {
      final matchesSearch =
          note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Semua' || note.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList()..sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  void _addOrUpdateNote(Note note) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index >= 0) {
        _notes[index] = note;
      } else {
        _notes.insert(0, note);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _notes.any((n) => n.id == note.id)
              ? 'Catatan berhasil disimpan!'
              : 'Catatan berhasil ditambahkan!',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _togglePin(Note note) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index >= 0) {
        _notes[index] = note.copyWith(isPinned: !note.isPinned);
      }
    });
  }

  void _deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text('Apakah Anda yakin ingin menghapus "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _notes.removeWhere((n) => n.id == note.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan berhasil dihapus'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _openNoteEditor([Note? note]) {
    showDialog(
      context: context,
      builder: (context) =>
          NoteEditorDialog(note: note, onSave: _addOrUpdateNote),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayedNotes = _filteredNotes;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catatan POLNES',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Politeknik Negeri Samarinda',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? 'Tampilan List' : 'Tampilan Grid',
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari catatan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
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

          // Categories Horizontal List
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
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
                    selectedColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Notes List or Grid
          Expanded(
            child: displayedNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 72,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada catatan ditemukan',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tekan tombol + untuk membuat catatan baru',
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
                          childAspectRatio: 0.85,
                        ),
                    itemCount: displayedNotes.length,
                    itemBuilder: (context, index) {
                      final note = displayedNotes[index];
                      return NoteCard(
                        note: note,
                        onTap: () => _openNoteEditor(note),
                        onTogglePin: () => _togglePin(note),
                        onDelete: () => _deleteNote(note),
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
                          onTap: () => _openNoteEditor(note),
                          onTogglePin: () => _togglePin(note),
                          onDelete: () => _deleteNote(note),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Catatan'),
      ),
    );
  }
}
