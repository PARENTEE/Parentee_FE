import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BabyCareDashboardPage extends StatefulWidget {
  const BabyCareDashboardPage({super.key});

  @override
  State<BabyCareDashboardPage> createState() => _BabyCareDashboardPageState();
}

class _BabyCareDashboardPageState extends State<BabyCareDashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  final List<BabyTask> allTasks = [
    BabyTask(
      title: "Cho bé bú",
      time: "08:00",
      assignedTo: "Mẹ",
      color: Colors.pink,
      date: DateTime.now(),
      done: true,
    ),
    BabyTask(
      title: "Thay tã",
      time: "09:30",
      assignedTo: "Mẹ",
      color: Colors.orange,
      date: DateTime.now(),
      done: false,
    ),
    BabyTask(
      title: "Massage cho bé",
      time: "11:00",
      assignedTo: "Bố",
      color: Colors.green,
      date: DateTime.now(),
      done: false,
    ),
    BabyTask(
      title: "Chơi với bé",
      time: "15:00",
      assignedTo: "Mẹ",
      color: Colors.blue,
      date: DateTime.now(),
      done: true,
    ),
    BabyTask(
      title: "Tắm cho bé",
      time: "17:00",
      assignedTo: "Bố",
      color: Colors.teal,
      date: DateTime.now(),
      done: false,
    ),
    BabyTask(
      title: "Đỗ bé ngủ",
      time: "20:00",
      assignedTo: "Mẹ",
      color: Colors.purple,
      date: DateTime.now(),
      done: false,
    ),
  ];

  List<BabyTask> get tasksForSelectedDate {
    final d = _selectedDay ?? _focusedDay;
    return allTasks
        .where((t) =>
            t.date.year == d.year &&
            t.date.month == d.month &&
            t.date.day == d.day)
        .toList();
  }

  double get completionPercent {
    final tasks = tasksForSelectedDate;
    if (tasks.isEmpty) return 0;
    final done = tasks.where((t) => t.done).length;
    return done / tasks.length;
  }

  void _toggleDone(BabyTask task) {
    setState(() {
      task.done = !task.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat(
      "EEEE, MMM d, yyyy",
    ).format(_selectedDay ?? _focusedDay);

    final tasks = tasksForSelectedDate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Nhiệm vụ chăm sóc bé",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar weekly
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            availableCalendarFormats: const {CalendarFormat.week: 'Tuần'},
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.pinkAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Date and summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(today,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
                    Text(
                      "Tổng nhiệm vụ hôm nay: ${tasks.length}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: completionPercent,
                        strokeWidth: 6,
                        color: Colors.pink,
                        backgroundColor: Colors.pink.shade100,
                      ),
                      Text("${(completionPercent * 100).round()}%",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text("Không có nhiệm vụ cho ngày này"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: task.color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border(
                              left: BorderSide(color: task.color, width: 4),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: task.assignedTo == "Mẹ"
                                  ? Colors.pink
                                  : Colors.blue,
                              child: Text(
                                task.assignedTo == "Mẹ" ? "M" : "B",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(task.title,
                                style: TextStyle(
                                  color: task.color,
                                  fontWeight: FontWeight.w600,
                                )),
                            subtitle: Text(task.time),
                            trailing: IconButton(
                              icon: Icon(
                                task.done
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: task.done
                                    ? Colors.green
                                    : Colors.grey.shade400,
                              ),
                              onPressed: () => _toggleDone(task),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Just add a sample task
          setState(() {
            allTasks.add(BabyTask(
              title: "Nhiệm vụ mới",
              time: "12:00",
              assignedTo: "Mẹ",
              color: Colors.pink,
              date: _selectedDay ?? DateTime.now(),
              done: false,
            ));
          });
        },
      ),
    );
  }
}

class BabyTask {
  final String title;
  final String time;
  final String assignedTo;
  final Color color;
  final DateTime date;
  bool done;

  BabyTask({
    required this.title,
    required this.time,
    required this.assignedTo,
    required this.color,
    required this.date,
    this.done = false,
  });
}
