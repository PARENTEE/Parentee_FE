import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_medicine.dart';

class MedicineDashboardPage extends StatefulWidget {
  const MedicineDashboardPage({super.key});

  @override
  State<MedicineDashboardPage> createState() => _MedicineDashboardPageState();
}

class _MedicineDashboardPageState extends State<MedicineDashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week; // chỉ hiện tuần

  final List<Task> tasks = [
    Task(
      time: "08:00 AM",
      title: "Uống Vitamin C",
      description: "1 viên Vitamin C sau bữa sáng",
      start: "08:00",
      end: "08:30",
      color: Colors.green,
    ),
    Task(
      time: "09:00 AM",
      title: "Sữa cho bé",
      description: "200ml sữa",
      start: "09:00",
      end: "09:15",
      color: Colors.orange,
    ),
    Task(
      time: "10:00 AM",
      title: "Thuốc kháng sinh",
      description: "1 viên sau bữa tối",
      start: "10:00",
      end: "10:20",
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    String today = DateFormat(
      "EEEE, MMM d, yyyy",
    ).format(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Thuốc"),
      ),
      body: Column(
        children: [
          // Calendar tuần
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat, // chỉ hiện tuần
            availableCalendarFormats: const {CalendarFormat.week: 'Tuần'},
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),

          // Ngày hôm nay + số task
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  today,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),

          // Danh sách task
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          task.time,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: task.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border(
                              left: BorderSide(color: task.color, width: 4),
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: task.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${task.start} - ${task.end}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMedicinePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

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
