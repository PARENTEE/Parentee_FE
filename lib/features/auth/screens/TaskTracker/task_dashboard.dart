import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parentee_fe/features/auth/models/baby_task.dart';
import 'package:parentee_fe/services/TaskService/task_service.dart';
import 'package:parentee_fe/services/api_service_dio.dart';
import 'package:table_calendar/table_calendar.dart';

// import '../dto/get_task_response.dto.dart';
// import '../enums/task_status.dart';
// import '../services/api_service.dart';

class BabyCareDashboardPage extends StatefulWidget {
  const BabyCareDashboardPage({super.key});

  @override
  State<BabyCareDashboardPage> createState() => _BabyCareDashboardPageState();
}

class _BabyCareDashboardPageState extends State<BabyCareDashboardPage> {
  // --- STATE MANAGEMENT ---
  // final ApiServiceDio _apiService = ApiServiceDio();
  final TaskService _taskService = TaskService();
  late Future<List<GetTaskResponseDto>> _tasksFuture;

  // Hardcoded IDs for demonstration. In a real app, you'd get these from user auth.
  static const String _familyId = "b6d6968e-0924-4a2b-8a7c-3e6f8b9d0c1d";
  static const String momId = "c7e7a79f-1a6b-3a5d-7e1a-1c6a4a5d7e1a";
  static const String dadId = "d8f8b8a0-2b7c-4b6e-8f2b-2d7c5b6e8f2b";

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Initial fetch for today's tasks
    _fetchTasks(_selectedDay!);
  }

  void _fetchTasks(DateTime date) {
    setState(() {
      _tasksFuture = _taskService.getTasksByDate(_familyId, date);
    });
  }

  Future<void> _toggleTaskStatus(GetTaskResponseDto task) async {
    final newStatus = task.status == "Completed" ? "Pending" : "Completed";
    try {
      await _taskService.updateTaskStatus(task.id, newStatus);
      // If the update is successful, refetch the tasks to update the UI
      _fetchTasks(_selectedDay!);
    } catch (e) {
      // Show an error message if the update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Calendar - no changes needed here
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _fetchTasks(selectedDay); // Fetch tasks for the new date
              }
            },
            // ... other calendar properties
          ),

          // --- UI UPDATED TO USE FutureBuilder ---
          Expanded(
            child: FutureBuilder<List<GetTaskResponseDto>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                // 1. LOADING STATE
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. ERROR STATE
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // 3. EMPTY or NO DATA STATE
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("Không có nhiệm vụ cho ngày này"));
                }

                // 4. DATA STATE
                final tasks = snapshot.data!;
                final doneCount =
                    tasks.where((t) => t.status == "Completed").length;
                final completionPercent =
                    tasks.isEmpty ? 0.0 : doneCount / tasks.length;

                return Column(
                  children: [
                    // Date and summary
                    _buildSummaryHeader(tasks, completionPercent),

                    // Task list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return _buildTaskListItem(task);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      // ... FloatingActionButton
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSummaryHeader(
      List<GetTaskResponseDto> tasks, double completionPercent) {
    String today = DateFormat("EEEE, MMM d, yyyy").format(_selectedDay!);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(today,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(
                "Tổng nhiệm vụ hôm nay: ${tasks.length}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildTaskListItem(GetTaskResponseDto task) {
    final assignedTo = task.createdBy == momId
        ? "Mẹ"
        : (task.createdBy == dadId ? "Bố" : "??");
    final isDone = task.status == "Completed";
    final color = assignedTo == "Mẹ" ? Colors.pink : Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text(assignedTo.substring(0, 1),
                style: const TextStyle(color: Colors.white)),
          ),
          title: Text(task.title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          subtitle: Text(task.startsAt != null
              ? DateFormat('h:mm a').format(task.startsAt!)
              : "All Day"),
          trailing: IconButton(
            icon: Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? Colors.green : Colors.grey.shade400,
            ),
            onPressed: () => _toggleTaskStatus(task),
          ),
        ),
      ),
    );
  }
}
