import 'package:flutter/material.dart';
import 'model/activity_model.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final colorTheme = activity.isCompleted ? Colors.green : const Color(0xFFFF6584);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Aktivitas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteConfirm(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // HEADER ICON BESAR
            Center(
              child: Hero(
                tag: 'icon_${activity.title}', // Bonus animasi Hero
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: colorTheme.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: colorTheme.withOpacity(0.3), width: 2),
                  ),
                  child: Icon(
                    activity.isCompleted ? Icons.task_alt : Icons.timer_outlined,
                    size: 60,
                    color: colorTheme,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // JUDUL & STATUS
            Text(
              activity.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: colorTheme,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                activity.isCompleted ? "SELESAI" : "SEDANG BERJALAN",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),

            const SizedBox(height: 40),

            // CARD INFORMASI DETAIL
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _rowDetail(Icons.category, "Kategori", activity.category),
                  const Divider(height: 30),
                  _rowDetail(Icons.access_time_filled, "Durasi", "${activity.duration} Jam"),
                  const Divider(height: 30),
                  _rowDetail(Icons.notes, "Catatan", activity.description.isEmpty ? "-" : activity.description, isMultiLine: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black87,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("KEMBALI KE HOME", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _rowDetail(IconData icon, String label, String value, {bool isMultiLine = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey, size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                value, 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                maxLines: isMultiLine ? 5 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus?"),
        content: const Text("Data ini tidak bisa dikembalikan."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}