import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const StudentActivityTrackerApp());
}

class StudentActivityTrackerApp extends StatelessWidget {
  const StudentActivityTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Activity Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Skema warna Modern: Deep Purple & Salmon
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          secondary: const Color(0xFFFF6584),
          surface: const Color(0xFFF9F9F9),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black87, 
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        fontFamily: 'Roboto', // Default font tapi clean
      ),
      home: const HomePage(),
    );
  }
}