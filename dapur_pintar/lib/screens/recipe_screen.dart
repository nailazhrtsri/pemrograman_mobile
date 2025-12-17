// File: lib/screens/recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/shopping_provider.dart'; // Import ini wajib ada!
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String _searchQuery = "";

  // --- LOGIC 1: Cek Bahan Kurang ---
  // Fungsi ini membandingkan bahan resep vs kulkas
  List<String> _getMissingIngredients(Recipe recipe, List<Ingredient> pantryItems) {
    List<String> missing = [];
    List<String> recipeIngredients = recipe.ingredients.toLowerCase().split('\n');
    
    for (String itemNeeded in recipeIngredients) {
      String cleanItem = itemNeeded.trim();
      if (cleanItem.isEmpty) continue;
      
      // Cek apakah ada di kulkas (pakai logika contains sederhana)
      bool found = pantryItems.any((pantryItem) {
        String pantryName = pantryItem.name.toLowerCase();
        return pantryName.contains(cleanItem) || cleanItem.contains(pantryName);
      });
      
      if (!found) missing.add(cleanItem);
    }
    return missing;
  }

  // --- LOGIC 2: Modal Tambah Resep (Tampilan Baru) ---
  void _showAddRecipeModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final ingCtrl = TextEditingController();
    final stepsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.only(
            top: 25, left: 20, right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Tulis Resep Baru 🍳", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: titleCtrl, 
                decoration: InputDecoration(labelText: "Judul Masakan", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: descCtrl, 
                decoration: InputDecoration(labelText: "Deskripsi Singkat", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: ingCtrl,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Bahan (Pisah dengan ENTER)", hintText: "Telur\nBawang\nKecap", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: stepsCtrl,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Cara Masak", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Provider.of<RecipeProvider>(context, listen: false).addRecipe(
                      titleCtrl.text, descCtrl.text, ingCtrl.text, stepsCtrl.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("SIMPAN RESEP", style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- LOGIC 3: Dialog Hapus ---
  void _confirmDelete(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Resep?"),
        content: Text("Yakin ingin menghapus '$title'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Provider.of<RecipeProvider>(context, listen: false).deleteRecipe(id);
              Navigator.pop(ctx);
            }, 
            child: const Text("Hapus", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  // --- LOGIC 4: Detail Resep & Tombol Belanja ---
  void _showRecipeDetail(BuildContext context, Recipe recipe, List<String> missingItems) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(height: 5, width: 50, margin: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(25),
                children: [
                  Text(recipe.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  Text(recipe.description, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 20),
                  
                  // Kotak Status Kelengkapan
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: missingItems.isEmpty ? Colors.green.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: missingItems.isEmpty ? Colors.green.shade200 : Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(missingItems.isEmpty ? Icons.check_circle : Icons.warning_amber_rounded, color: missingItems.isEmpty ? Colors.green : Colors.deepOrange),
                        const SizedBox(width: 15),
                        Expanded(child: Text(missingItems.isEmpty ? "Semua bahan siap!" : "Ada ${missingItems.length} bahan kurang.", style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),

                  // Tombol Belanja (Muncul jika ada bahan kurang)
                  if (missingItems.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text("CATAT KE DAFTAR BELANJA"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white, padding: const EdgeInsets.all(15)),
                        onPressed: () {
                          // Memanggil ShoppingProvider
                          final shopProv = Provider.of<ShoppingProvider>(context, listen: false);
                          for (var item in missingItems) {
                            shopProv.addItem(item);
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${missingItems.length} bahan dicatat!")));
                        },
                      ),
                    ),

                  const Divider(height: 40),
                  const Text("Bahan-bahan:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  ...recipe.ingredients.split('\n').map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(children: [const Icon(Icons.circle, size: 8, color: Colors.deepOrange), const SizedBox(width: 10), Expanded(child: Text(e))]),
                  )),
                  const SizedBox(height: 20),
                  const Text("Cara Masak:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Text(recipe.steps, style: const TextStyle(fontSize: 15, height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Koleksi Resep', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.deepOrange, Colors.orangeAccent]))),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Mau masak apa?",
                prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
          
          Expanded(
            child: Consumer2<RecipeProvider, PantryProvider>(
              builder: (context, recipeProv, pantryProv, child) {
                // Filter Pencarian
                final filtered = recipeProv.recipes.where((r) => r.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                if (filtered.isEmpty) return const Center(child: Text("Resep tidak ditemukan 📖"));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final recipe = filtered[index];
                    
                    // Hitung bahan kurang
                    final missing = _getMissingIngredients(recipe, pantryProv.ingredients);
                    final isComplete = missing.isEmpty;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5))]),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isComplete ? Colors.green.shade50 : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.restaurant_menu, color: isComplete ? Colors.green : Colors.deepOrange, size: 28),
                        ),
                        title: Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            isComplete ? "✅ Bahan Lengkap" : "⚠️ Kurang ${missing.length} bahan",
                            style: TextStyle(color: isComplete ? Colors.green : Colors.deepOrange, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Tombol Hapus ada di sini
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey),
                          onPressed: () => _confirmDelete(context, recipe.id, recipe.title),
                        ),
                        onTap: () => _showRecipeDetail(context, recipe, missing),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRecipeModal(context),
        label: const Text("Tulis Resep"),
        icon: const Icon(Icons.edit),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}