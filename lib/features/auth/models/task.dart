import 'dart:ui';

class Task {
  final String time;
  final String title;
  final String description;
  final String start;
  final String end;
  final Color color;

  Task({
    required this.time,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.color,
  });
}
