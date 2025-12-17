import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa Cantik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFCE4EC), // Pink Muda Background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF06292), // Pink agak gelap
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE91E63),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// --- 1. MODEL DATA (Sesuai Tugas: Ada Tanggal & Kategori) ---
class Note {
  String id;
  String title;
  String content;
  String category; // Kuliah, Organisasi, Pribadi, Lain-lain
  DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
  });

  // Konversi ke Map (untuk Simpan ke SharedPrefs)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Konversi dari Map (untuk Load dari SharedPrefs)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

// --- 2. HOME PAGE (Read, Delete, Filter) ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _allNotes = []; // Semua data
  List<Note> _displayedNotes = []; // Data yang tampil (kena filter)
  String _selectedFilter = 'Semua'; // Filter aktif

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load Data dari SharedPreferences
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('student_notes');
    if (notesString != null) {
      final List<dynamic> jsonList = jsonDecode(notesString);
      setState(() {
        _allNotes = jsonList.map((json) => Note.fromMap(json)).toList();
        _applyFilter(); // Update tampilan sesuai filter
      });
    }
  }

  // Simpan Data
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String notesString = jsonEncode(_allNotes.map((e) => e.toMap()).toList());
    await prefs.setString('student_notes', notesString);
  }

  // Logic Filter Kategori
  void _applyFilter() {
    setState(() {
      if (_selectedFilter == 'Semua') {
        _displayedNotes = List.from(_allNotes);
      } else {
        _displayedNotes = _allNotes.where((note) => note.category == _selectedFilter).toList();
      }
      // Urutkan dari yang terbaru
      _displayedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  // Fungsi Tambah Note
  Future<void> _addNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteFormPage()),
    );

    if (result != null && result is Note) {
      setState(() {
        _allNotes.add(result);
        _applyFilter();
      });
      _saveNotes();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil ditambah ✨')));
    }
  }

  // Fungsi Edit Note
  Future<void> _editNote(int index, Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteFormPage(existingNote: note)),
    );

    if (result != null && result is Note) {
      // Cari index asli di _allNotes berdasarkan ID (karena index di tampilan beda kalau difilter)
      final originalIndex = _allNotes.indexWhere((element) => element.id == note.id);
      
      if (originalIndex != -1) {
        setState(() {
          _allNotes[originalIndex] = result;
          _applyFilter();
        });
        _saveNotes();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catatan diperbarui 🎀')));
      }
    }
  }

  // Fungsi Hapus Note
  void _deleteNote(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Catatan?", style: TextStyle(color: Colors.pink)),
        content: const Text("Yakin mau hapus kenangan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() {
                _allNotes.removeWhere((note) => note.id == id);
                _applyFilter();
              });
              _saveNotes();
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Helper: Get Icon berdasarkan Kategori 
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Kuliah': return Icons.school;
      case 'Organisasi': return Icons.groups;
      case 'Pribadi': return Icons.favorite;
      default: return Icons.sticky_note_2;
    }
  }

  // Helper: Get Color berdasarkan Kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Kuliah': return Colors.blueAccent;
      case 'Organisasi': return Colors.orangeAccent;
      case 'Pribadi': return Colors.pinkAccent;
      default: return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes 🌸'),
        actions: [
          // DROPDOWN FILTER DI APPBAR 
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFFF8BBD0),
              value: _selectedFilter,
              icon: const Icon(Icons.filter_list, color: Colors.white),
              underline: Container(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              items: ['Semua', 'Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.black87)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                  _applyFilter();
                });
              },
            ),
          ),
        ],
      ),
      body: _displayedNotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add_outlined, size: 80, color: Colors.pink[200]),
                  const SizedBox(height: 10),
                  Text(
                    _allNotes.isEmpty 
                      ? 'Belum ada catatan nih\nYuk tambah baru! ✨'
                      : 'Kategori ini kosong',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.pink[300], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _displayedNotes.length,
              itemBuilder: (context, index) {
                final note = _displayedNotes[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(note.category).withOpacity(0.2),
                      child: Icon(_getCategoryIcon(note.category), color: _getCategoryColor(note.category)),
                    ),
                    title: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(note.category).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                note.category,
                                style: TextStyle(fontSize: 10, color: _getCategoryColor(note.category), fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}",
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _editNote(index, note), // Edit saat diklik
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _deleteNote(note.id), // Hapus
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// --- 3. FORM PAGE (Create & Update) ---
class NoteFormPage extends StatefulWidget {
  final Note? existingNote;
  const NoteFormPage({super.key, this.existingNote});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Kuliah'; // Default kategori
  final List<String> _categories = ['Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      _titleController.text = widget.existingNote!.title;
      _contentController.text = widget.existingNote!.content;
      _selectedCategory = widget.existingNote!.category;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      // Buat Object Note Baru
      final note = Note(
        id: widget.existingNote?.id ?? DateTime.now().toString(), // ID baru atau lama
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
        createdAt: widget.existingNote?.createdAt ?? DateTime.now(), // Tanggal baru atau lama
      );

      Navigator.pop(context, note); // Kirim data balik ke Home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingNote == null ? 'Buat Catatan Baru' : 'Edit Catatan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Judul
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Catatan',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.title, color: Colors.pink),
                ),
                validator: (val) => val!.isEmpty ? 'Judul gak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              
              // Input Kategori (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.category, color: Colors.pink),
                ),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              // Input Isi
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Isi Catatan...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  alignLabelWithHint: true,
                ),
                validator: (val) => val!.isEmpty ? 'Isinya jangan kosong dong' : null,
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Simpan Catatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}