// File: lib/models/ingredient_model.dart
import 'package:uuid/uuid.dart';

class Ingredient {
  final String id;
  final String name;
  final String quantity; // KOLOM BARU: Jumlah (misal: 1 kg, 5 butir)
  final DateTime expiryDate;
  final String category;

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.expiryDate,
    required this.category,
  });

  factory Ingredient.create({
    required String name,
    required String quantity,
    required DateTime expiryDate,
    required String category,
  }) {
    return Ingredient(
      id: const Uuid().v4(),
      name: name,
      quantity: quantity,
      expiryDate: expiryDate,
      category: category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'expiryDate': expiryDate.toIso8601String(),
      'category': category,
    };
  }

  factory Ingredient.fromMap(Map<dynamic, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'] ?? 'Secukupnya', // Default kalau null
      expiryDate: DateTime.parse(map['expiryDate']),
      category: map['category'],
    );
  }

  int get daysUntilExpiry {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }
}