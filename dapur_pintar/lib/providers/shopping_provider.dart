// File: lib/providers/shopping_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingItem {
  final String name;
  bool isBought;

  ShoppingItem({required this.name, this.isBought = false});
}

class ShoppingProvider extends ChangeNotifier {
  static const String _boxName = 'shoppingBox';
  List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => _items;

  void loadItems() {
    final box = Hive.box(_boxName);
    // Simpan data sederhana sebagai List of String di database biar gampang
    // Format simpan: "NamaBarang|Status" (Contoh: "Telur|0" atau "Kecap|1")
    _items = box.values.map((e) {
      final str = e.toString();
      final parts = str.split('|');
      return ShoppingItem(
        name: parts[0],
        isBought: parts.length > 1 ? parts[1] == '1' : false,
      );
    }).toList();
    notifyListeners();
  }

  Future<void> addItem(String name) async {
    // Cek duplikat biar gak double
    if (_items.any((i) => i.name.toLowerCase() == name.toLowerCase())) return;

    final box = Hive.box(_boxName);
    await box.add("$name|0"); // 0 artinya belum dibeli
    loadItems();
  }

  Future<void> toggleStatus(int index) async {
    final box = Hive.box(_boxName);
    final item = _items[index];
    final newStatus = !item.isBought;
    // Update data di database
    await box.putAt(index, "${item.name}|${newStatus ? '1' : '0'}");
    loadItems();
  }

  Future<void> clearBoughtItems() async {
    final box = Hive.box(_boxName);
    // Hapus manual yang statusnya 1, logic agak tricky di Hive List, 
    // jadi kita clear semua lalu add ulang yang belum dibeli
    final pendingItems = _items.where((i) => !i.isBought).map((i) => "${i.name}|0").toList();
    await box.clear();
    await box.addAll(pendingItems);
    loadItems();
  }
}