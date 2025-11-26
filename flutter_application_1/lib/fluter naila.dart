import 'package:flutter/material.dart';

void main() {
  // 1. Perbaikan: Tidak ada error di sini, runApp sudah benar memanggil Widget.
  runApp(const BiodataApp());
}

class BiodataApp extends StatelessWidget {
  const BiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiodataApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const BiodataPage(),
    );
  }
}

// 2. Perbaikan: Menggunakan 'StatelessWidget' dengan kapitalisasi yang benar.
class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biodata Saya'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      // Layout yang Rapi dan Warna Latar Belakang
      body: Container(
        // 3. Perbaikan: Menggunakan 'Colors' dengan kapitalisasi yang benar.
        color: Colors.teal.shade50,
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Center(
          // 4. Perbaikan: Menggunakan 'Column' dengan kapitalisasi yang benar.
          child: Column(
            // 5. Perbaikan: Menggunakan 'MainAxisAlignment' dengan ejaan yang benar.
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Agar Card/Row melebar
            children: [
              // Foto Profil (Image)
              const CircleAvatar(
                radius: 70,
                // Pastikan 'assets/profile.jpg' telah didaftarkan di pubspec.yaml
                backgroundImage: AssetImage('assets/IMG_1892.jpg'),
                backgroundColor: Colors.white,
              ),

              // 6. Perbaikan: Menggunakan 'SizedBox' dengan kapitalisasi yang benar.
              const SizedBox(height: 20),

              // Nama (Text)
              // 7. Perbaikan: Menggunakan ejaan 'Hapsari' (sesuai asumsi perbaikan).
              const Text(
                'Naila Zuhrotul Hapsari',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                  fontFamily: 'Arial',
                ),
              ),

              const SizedBox(height: 5),

              // NIM (Text)
              const Text(
                'NIM: 701230041',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),

              const SizedBox(height: 5),

              // Hobi (Text)
              const Text(
                // 8. Perbaikan: Tidak ada error di sini, hanya perlu memastikan tanda titik koma.
                'Hobi: Fotografi & Desain Grafis',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              // Divider untuk pemisah visual
              Divider(
                color: Colors.teal.shade200,
                thickness: 1,
                indent: 50,
                endIndent: 50,
              ),

              const SizedBox(height: 30),

              // Row 1: Informasi Kontak
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.location_pin,
                        color: Colors.teal,
                        size: 24,
                      ),
                      const SizedBox(width: 15.0),
                      const Text(
                        'Jambi, Indonesia',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Row 2: Informasi Email
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.email, color: Colors.teal, size: 24),
                      const SizedBox(width: 15.0),
                      const Text(
                        'naila.hapsari@gmail.com',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Button (Tombol)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi Tombol: menampilkan pesan di Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Anda menekan tombol "Portofolio"'),
                      ),
                    );
                    // Jika di tugas diminta menampilkan di konsol:
                    print('Tombol Portofolio ditekan!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Lihat Portofolio',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
