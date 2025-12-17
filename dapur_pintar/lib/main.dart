// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Jika mau font custom (Optional)

import 'providers/pantry_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/shopping_provider.dart';
import 'screens/pantry_screen.dart';
import 'screens/recipe_screen.dart';
import 'screens/shopping_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  await Hive.openBox('pantryBox');
  await Hive.openBox('recipeBox');
  await Hive.openBox('shoppingBox'); // BOX BARU

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PantryProvider()..loadIngredients()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()..loadRecipes()),
        ChangeNotifierProvider(create: (_) => ShoppingProvider()..loadItems()), // PROVIDER BARU
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dapur Pintar',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: GoogleFonts.poppinsTextTheme(), 
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const PantryScreen(),
    const RecipeScreen(),
    const ShoppingListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.kitchen_outlined), selectedIcon: Icon(Icons.kitchen), label: 'Stok'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Resep'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Belanja'),
        ],
      ),
    );
  }
}