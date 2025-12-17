// File: lib/models/recipe_model.dart
import 'package:uuid/uuid.dart';

class Recipe {
  final String id;
  final String title;
  final String description; // Deskripsi singkat
  final String ingredients; // Bahan-bahan (dipisah baris baru)
  final String steps;       // Langkah-langkah (dipisah baris baru)

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.create({
    required String title,
    required String description,
    required String ingredients,
    required String steps,
  }) {
    return Recipe(
      id: const Uuid().v4(),
      title: title,
      description: description,
      ingredients: ingredients,
      steps: steps,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
    };
  }

  factory Recipe.fromMap(Map<dynamic, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      ingredients: map['ingredients'],
      steps: map['steps'],
    );
  }
}