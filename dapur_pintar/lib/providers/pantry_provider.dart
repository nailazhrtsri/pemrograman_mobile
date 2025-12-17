// File: lib/providers/pantry_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/ingredient_model.dart';

class PantryProvider extends ChangeNotifier {
  static const String _boxName = 'pantryBox';
  List<Ingredient> _ingredients = [];
  List<Ingredient> get ingredients => _ingredients;

  void loadIngredients() {
    final box = Hive.box(_boxName);
    _ingredients = box.values.map((e) {
      return Ingredient.fromMap(Map<String, dynamic>.from(e));
    }).toList();
    _ingredients.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    notifyListeners();
  }

  // Update: Tambah parameter quantity
  Future<void> addIngredient(String name, String quantity, DateTime expiry, String category) async {
    final newIngredient = Ingredient.create(
      name: name, 
      quantity: quantity,
      expiryDate: expiry, 
      category: category
    );
    final box = Hive.box(_boxName);
    await box.put(newIngredient.id, newIngredient.toMap());
    loadIngredients();
  }

  Future<void> deleteIngredient(String id) async {
    final box = Hive.box(_boxName);
    await box.delete(id);
    loadIngredients();
  }
}