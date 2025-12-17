// File: lib/screens/pantry_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/pantry_provider.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  String _searchQuery = "";

  void _showAddModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 3));
    String selectedCategory = 'Sayur';
    final categories = ['Sayur', 'Buah', 'Protein', 'Karbo', 'Bumbu', 'Lainnya'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Biar rounded corner kelihatan
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 25, left: 20, right: 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Tambah Stok 🥦", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                    const SizedBox(height: 20),
                    
                    // Input Nama (Validasi No Angka)
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Bahan', 
                        prefixIcon: const Icon(Icons.fastfood_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Wajib diisi";
                        if (val.contains(RegExp(r'[0-9]'))) return "Nama bahan tidak boleh ada angka!";
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Input Jumlah
                    TextFormField(
                      controller: qtyController,
                      decoration: InputDecoration(
                        labelText: 'Jumlah (cth: 5 butir)', 
                        prefixIcon: const Icon(Icons.scale_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) => val!.isEmpty ? "Jumlah wajib diisi" : null,
                    ),
                    const SizedBox(height: 15),

                    // Kategori & Tanggal
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                            onChanged: (val) => setModalState(() => selectedCategory = val!),
                            decoration: InputDecoration(labelText: 'Kategori', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
                              if (picked != null) setModalState(() => selectedDate = picked);
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(labelText: 'Kadaluarsa', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                              child: Text(DateFormat('dd/MM/yy').format(selectedDate)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Provider.of<PantryProvider>(context, listen: false)
                              .addIngredient(nameController.text, qtyController.text, selectedDate, selectedCategory);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("SIMPAN KE KULKAS", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Stok Kulkas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.teal, Colors.tealAccent], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar Mewah
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Cari bahan...",
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          Expanded(
            child: Consumer<PantryProvider>(
              builder: (context, pantry, child) {
                final filtered = pantry.ingredients.where((i) => i.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                
                if (filtered.isEmpty) return const Center(child: Text("Kulkas kosong/tidak ditemukan 🧊", style: TextStyle(color: Colors.grey)));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final daysLeft = item.daysUntilExpiry;
                    // Indikator Warna Modern
                    Color statusColor = daysLeft < 2 ? Colors.redAccent : (daysLeft < 5 ? Colors.orangeAccent : Colors.teal);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: statusColor.withOpacity(0.1), shape: BoxShape.circle),
                          child: Icon(Icons.inventory_2_outlined, color: statusColor),
                        ),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Jumlah: ${item.quantity}", style: const TextStyle(color: Colors.black54)),
                            Text(daysLeft < 0 ? "Kadaluarsa!" : "$daysLeft hari lagi", style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey),
                          onPressed: () => pantry.deleteIngredient(item.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddModal(context),
        label: const Text("Tambah Bahan"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}