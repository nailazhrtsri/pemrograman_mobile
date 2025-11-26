import 'package:flutter/material.dart';
import 'detail_page.dart';

// Model Data Dosen (Sederhana)
class Dosen {
  final String nama;
  final String nidn;
  final String bidang;
  final String email;
  final String fotoUrl;
  final String deskripsi;

  Dosen({
    required this.nama,
    required this.nidn,
    required this.bidang,
    required this.email,
    required this.fotoUrl,
    required this.deskripsi,
  });
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Data Dummy Dosen
  final List<Dosen> listDosen = [
    Dosen(
      nama: "Dr. Budi Santoso, M.Kom",
      nidn: "0012098801",
      bidang: "Artificial Intelligence",
      email: "budi.santoso@univ.ac.id",
      fotoUrl: "https://randomuser.me/api/portraits/men/32.jpg",
      deskripsi: "Beliau adalah pakar AI yang berfokus pada Machine Learning dan Computer Vision. Telah menerbitkan lebih dari 20 jurnal internasional.",
    ),
    Dosen(
      nama: "Prof. Siti Aminah, Ph.D",
      nidn: "0023017502",
      bidang: "Software Engineering",
      email: "siti.aminah@univ.ac.id",
      fotoUrl: "https://randomuser.me/api/portraits/women/44.jpg",
      deskripsi: "Profesor di bidang rekayasa perangkat lunak dengan spesialisasi pada Agile Methodology dan Software Quality Assurance.",
    ),
    Dosen(
      nama: "Rudi Hartono, S.T., M.T.",
      nidn: "0034058203",
      bidang: "Mobile Development",
      email: "rudi.hartono@univ.ac.id",
      fotoUrl: "https://randomuser.me/api/portraits/men/85.jpg",
      deskripsi: "Praktisi dan dosen pengampu mata kuliah Pemrograman Mobile. Sangat ahli dalam pengembangan aplikasi berbasis Flutter dan Kotlin.",
    ),
    Dosen(
      nama: "Dewi Lestari, M.Cs",
      nidn: "0045069004",
      bidang: "Data Science",
      email: "dewi.lestari@univ.ac.id",
      fotoUrl: "https://randomuser.me/api/portraits/women/65.jpg",
      deskripsi: "Peneliti aktif di bidang Big Data dan Data Mining. Sering menjadi pembicara dalam seminar teknologi nasional.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Dosen"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: listDosen.length,
        itemBuilder: (context, index) {
          final dosen = listDosen[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Navigasi ke DetailPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(dosen: dosen),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Hero( // Animasi Hero pasangannya
                      tag: dosen.nidn,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(dosen.fotoUrl),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dosen.nama,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dosen.bidang,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.perm_identity, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(dosen.nidn, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}