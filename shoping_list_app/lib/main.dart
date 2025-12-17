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
      title: 'Shopping List Cantik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Desain Feminim: Warna Pink Pastel & Ungu
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFCE4EC), // Pink sangat muda
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF48FB1), // Pink lembut
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFEC407A),
        ),
        useMaterial3: true,
      ),
      home: const ShoppingListScreen(),
    );
  }
}

// 1. Model Data (Sesuai Modul Hal 1 & 17) [cite: 9, 487]
class ShoppingItem {
  String id;
  String name;
  String category; // Makanan, Minuman, Kosmetik, dll [cite: 490]
  int quantity;    // [cite: 489]
  bool isBought;   // Status [cite: 491]

  ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.isBought = false,
  });

  // Konversi ke Map untuk disimpan (Serialization) [cite: 33]
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'isBought': isBought,
    };
  }

  // Konversi dari Map untuk dibaca (Deserialization) [cite: 24]
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      isBought: json['isBought'],
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _items = [];
  
  // Controller untuk input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  String _selectedCategory = 'Makanan';
  final List<String> _categories = ['Makanan', 'Minuman', 'Kosmetik', 'Elektronik', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _loadItems(); // Load data saat aplikasi dibuka [cite: 195, 436]
  }

  // --- Logic SharedPreferences (Storage) ---

  // Load Data [cite: 162]
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsString = prefs.getString('shopping_list'); // Key penyimpanan
    if (itemsString != null) {
      setState(() {
        final List<dynamic> jsonList = jsonDecode(itemsString);
        _items = jsonList.map((json) => ShoppingItem.fromJson(json)).toList(); // [cite: 170]
      });
    }
  }

  // Save Data [cite: 152]
  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String itemsString = jsonEncode(_items.map((e) => e.toJson()).toList()); // [cite: 159]
    await prefs.setString('shopping_list', itemsString);
  }

  // --- Logic CRUD ---

  void _addItem() {
    if (_nameController.text.isNotEmpty && _qtyController.text.isNotEmpty) {
      setState(() {
        _items.add(ShoppingItem(
          id: DateTime.now().toString(),
          name: _nameController.text,
          category: _selectedCategory,
          quantity: int.parse(_qtyController.text),
        ));
      });
      _saveItems(); // Simpan perubahan [cite: 429]
      _nameController.clear();
      _qtyController.clear();
      Navigator.pop(context); // Tutup dialog
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index); // [cite: 135]
    });
    _saveItems();
  }

  void _toggleStatus(int index) {
    setState(() {
      _items[index].isBought = !_items[index].isBought;
    });
    _saveItems();
  }

  // --- UI Components ---

  // Dialog Form Input
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Tambah Belanjaan 🛍️", style: TextStyle(color: Color(0xFFEC407A))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Barang",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Jumlah",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _addItem,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC407A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hitung total item 
    int boughtCount = _items.where((item) => item.isBought).length;
    int unboughtCount = _items.length - boughtCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Belanjaku 🎀"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Summary (Dashboard Kecil)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem("Belum Dibeli", unboughtCount, Colors.orange),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                _buildSummaryItem("Sudah Dibeli", boughtCount, Colors.green),
              ],
            ),
          ),
          
          // List Item menggunakan ListView.builder [cite: 47, 48]
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text("Belum ada belanjaan nih ✨", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: _items.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (ctx, index) {
                      final item = _items[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: item.isBought ? Colors.green[100] : const Color(0xFFF8BBD0),
                            child: Icon(
                              item.isBought ? Icons.check : Icons.shopping_bag,
                              color: item.isBought ? Colors.green : const Color(0xFFC2185B),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              decoration: item.isBought ? TextDecoration.lineThrough : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("${item.quantity} x • ${item.category}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _deleteItem(index), // Hapus item [cite: 133]
                          ),
                          onTap: () => _toggleStatus(index), // Ubah status [cite: 126]
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSummaryItem(String title, int count, Color color) {
    return Column(
      children: [
        Text(count.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}