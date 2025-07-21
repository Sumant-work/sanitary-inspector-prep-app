import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/data_loader.dart';
import '../models/note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> _categories = [];
  List<Note> _notes = [];
  String? _selectedCategoryId;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      var cats = await DataLoader.loadNoteCategories();
      var notes = await DataLoader.loadNotes();
      setState(() {
        _categories = cats;
        _notes = notes;
        _selectedCategoryId = cats.isNotEmpty ? cats[0]['id'] : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load notes.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📝 Notes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    _buildCategoryFilter(),
                    const Divider(height: 1),
                    Expanded(child: _buildNotesList()),
                  ],
                ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.map((cat) {
          final selected = _selectedCategoryId == cat['id'];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ChoiceChip(
              selected: selected,
              label: Text(cat['title']),
              onSelected: (_) {
                setState(() {
                  _selectedCategoryId = cat['id'];
                });
              },
              selectedColor: AppConstants.primaryColor.withOpacity(0.15),
              labelStyle: TextStyle(
                color: selected ? AppConstants.primaryColor : null,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Note> get _filteredNotes =>
      _selectedCategoryId == null
          ? _notes
          : _notes.where((n) => n.category == _selectedCategoryId).toList();

  Widget _buildNotesList() {
    if (_filteredNotes.isEmpty) {
      return const Center(child: Text('No notes available for this category'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredNotes.length,
      separatorBuilder: (c, i) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final note = _filteredNotes[i];
        return ListTile(
          title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(note.content.length > 100
              ? note.content.substring(0, 100).replaceAll('\n', ' ') + '...'
              : note.content.replaceAll('\n', ' ')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteDetailsScreen(note: note)),
          ),
        );
      },
    );
  }
}

class NoteDetailsScreen extends StatelessWidget {
  final Note note;
  const NoteDetailsScreen({required this.note, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(note.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(note.content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
