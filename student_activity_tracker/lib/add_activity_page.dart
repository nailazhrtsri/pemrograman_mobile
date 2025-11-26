import 'package:flutter/material.dart';
import 'model/activity_model.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  String? _selectedCategory;
  double _duration = 1.0;
  bool _isCompleted = false;

  final List<String> _categories = [
    'Belajar', 'Ibadah', 'Olahraga', 'Hiburan', 'Lainnya'
  ];

  void _saveActivity() {
    // Validasi Nama Kosong
    if (_titleController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Nama aktivitas tidak boleh kosong!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Validasi Kategori Kosong
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih kategori aktivitas!')),
      );
      return;
    }

    // Membuat Objek Activity
    final newActivity = Activity(
      title: _titleController.text,
      category: _selectedCategory!,
      duration: _duration,
      isCompleted: _isCompleted,
      description: _descController.text,
    );

    // Kirim Data Kembali ke HomePage
    Navigator.pop(context, newActivity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Aktivitas Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Nama
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Nama Aktivitas",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown Kategori
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() => _selectedCategory = newValue);
              },
            ),
            const SizedBox(height: 24),

            // Slider Durasi
            Text("Durasi: ${_duration.toStringAsFixed(1)} Jam", 
              style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _duration,
              min: 1,
              max: 8,
              divisions: 14, // Interval 0.5
              label: "${_duration.toStringAsFixed(1)} Jam",
              onChanged: (value) {
                setState(() => _duration = value);
              },
            ),
            
            // Switch Status
            Card(
              elevation: 0,
              color: Colors.grey[100],
              child: SwitchListTile(
                title: const Text("Status Selesai"),
                subtitle: Text(_isCompleted ? "Sudah Selesai" : "Belum Selesai"),
                value: _isCompleted,
                onChanged: (bool value) {
                  setState(() => _isCompleted = value);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Input Catatan (Multiline)
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Catatan Tambahan (Opsional)",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            ElevatedButton.icon(
              onPressed: _saveActivity,
              icon: const Icon(Icons.save),
              label: const Text("SIMPAN AKTIVITAS"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}