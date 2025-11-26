import 'package:flutter/material.dart';
import 'detail_page.dart'; // Pastikan import ini tetap ada

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<String> _courses = [
    "Dasar Flutter & Dart",
    "State Management",
    "API & Networking",
    "Firebase Integration",
    "UI/UX Design Mobile",
  ];

  @override
  Widget build(BuildContext context) {
    // --- HALAMAN TAB 1: LIST MATERI ---
    final Widget courseListTab = ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: Text("${index + 1}"),
            ),
            title: Text(_courses[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(courseName: _courses[index]),
                ),
              );
            },
          ),
        );
      },
    );

    // --- HALAMAN TAB 2: PROFIL (UPDATED) ---
    final Widget profileTab = Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Foto Profil Dummy (Circle Avatar Besar)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal.shade50,
                border: Border.all(color: Colors.teal, width: 3),
              ),
              child: const Icon(Icons.person, size: 80, color: Colors.teal),
            ),
            const SizedBox(height: 24),
            
            // Nama Lengkap Temenmu
            const Text(
              "Naila Zuhrotul Hapsari",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.teal
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            const Text(
              "Mobile Developer Enthusiast",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            
            const SizedBox(height: 32),
            
            // Kartu Informasi Tambahan
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.teal),
                    title: Text("Email"),
                    subtitle: Text("naila.hapsari@student.univ.ac.id"),
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(Icons.school, color: Colors.teal),
                    title: Text("Status"),
                    subtitle: Text("Mahasiswa Aktif"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // List Halaman untuk Bottom Navigation
    final List<Widget> pages = [courseListTab, profileTab];

    return Scaffold(
      appBar: AppBar(
        // Judul AppBar berubah dinamis sesuai tab
        title: Text(_selectedIndex == 0 ? "Daftar Materi" : "Profil Mahasiswa"),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book_outlined), 
            selectedIcon: Icon(Icons.book),
            label: 'Belajar'
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline), 
            selectedIcon: Icon(Icons.person),
            label: 'Profil'
          ),
        ],
      ),
    );
  }
}