import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String courseName;

  const DetailPage({super.key, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Materi")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.video_library, size: 80, color: Colors.teal),
            ),
            const SizedBox(height: 24),
            Text(
              courseName,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Di materi ini kamu akan mempelajari konsep dasar hingga implementasi praktis.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("KEMBALI KE MATERI"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}