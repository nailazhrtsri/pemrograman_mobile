import 'package:flutter/material.dart';
import 'add_activity_page.dart';
import 'activity_detail_page.dart';
import 'model/activity_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Activity> _activities = [];

  // Hitung total jam
  double get _totalHours => _activities.fold(0, (sum, item) => sum + item.duration);
  // Hitung total selesai
  int get _completedCount => _activities.where((item) => item.isCompleted).length;

  void _navigateToAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddActivityPage()),
    );

    if (result != null && result is Activity) {
      setState(() {
        _activities.insert(0, result); // Tambah ke paling atas
      });
      _showSnack("Berhasil menambahkan aktivitas!");
    }
  }

  void _navigateToDetail(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityDetailPage(activity: _activities[index]),
      ),
    );

    if (result == true) {
      setState(() => _activities.removeAt(index));
      _showSnack("Aktivitas dihapus.");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // --- CUSTOM HEADER DASHBOARD ---
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Halo, Mahasiswa! 👋", 
                          style: TextStyle(color: Colors.white70, fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Activity Tracker", 
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: 24,
                      child: Icon(Icons.person, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                // Statistik Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(Icons.timer, "${_totalHours.toStringAsFixed(1)} Jam", "Total Fokus"),
                      Container(height: 30, width: 1, color: Colors.white30),
                      _buildStatItem(Icons.check_circle, "$_completedCount", "Selesai"),
                      Container(height: 30, width: 1, color: Colors.white30),
                      _buildStatItem(Icons.list, "${_activities.length}", "Total"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- LIST CONTENT ---
          Expanded(
            child: _activities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    itemCount: _activities.length,
                    itemBuilder: (context, index) {
                      final item = _activities[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item.isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.isCompleted ? Icons.check : Icons.hourglass_empty,
                              color: item.isCompleted ? Colors.green : Colors.orange,
                            ),
                          ),
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(item.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ),
                                const SizedBox(width: 8),
                                Text("•  ${item.duration} Jam", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          onTap: () => _navigateToDetail(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddPage,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Aktivitas Baru"),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rocket_launch_rounded, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text("Siap Produktif Hari Ini?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text("Tekan tombol + untuk mulai mencatat.", style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}