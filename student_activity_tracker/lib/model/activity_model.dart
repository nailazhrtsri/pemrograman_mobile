class Activity {
  final String title;
  final String category;
  final double duration; // dalam jam
  final bool isCompleted;
  final String description;

  Activity({
    required this.title,
    required this.category,
    required this.duration,
    required this.isCompleted,
    this.description = '',
  });
}