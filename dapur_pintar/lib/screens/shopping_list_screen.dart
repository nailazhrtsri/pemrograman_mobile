// File: lib/screens/shopping_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Daftar Belanja', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple]))),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            tooltip: "Bersihkan yang sudah dibeli",
            onPressed: () => Provider.of<ShoppingProvider>(context, listen: false).clearBoughtItems(),
          )
        ],
      ),
      body: Consumer<ShoppingProvider>(
        builder: (context, shop, child) {
          if (shop.items.isEmpty) {
            return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
              SizedBox(height: 10),
              Text("Belum ada belanjaan", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ]));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shop.items.length,
            itemBuilder: (context, index) {
              final item = shop.items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)]),
                child: CheckboxListTile(
                  activeColor: Colors.purple,
                  title: Text(item.name, style: TextStyle(
                    fontSize: 16,
                    decoration: item.isBought ? TextDecoration.lineThrough : null,
                    color: item.isBought ? Colors.grey : Colors.black,
                  )),
                  value: item.isBought,
                  onChanged: (val) => shop.toggleStatus(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}