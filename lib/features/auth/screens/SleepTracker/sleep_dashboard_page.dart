import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/sleep_entry.dart';

class SleepDashboardPage extends StatelessWidget {
  final SleepEntry? newEntry;
  const SleepDashboardPage({super.key, this.newEntry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (newEntry != null)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.green.shade100,
                child: ListTile(
                  leading: const Icon(
                    Icons.nightlight_round,
                    color: Colors.green,
                  ),
                  title: Text(
                    "${DateFormat('HH:mm').format(newEntry!.startTime)} - ${DateFormat('HH:mm').format(newEntry!.endTime)}",
                  ),
                  subtitle: Text(
                    "Thời gian ngủ: ${newEntry!.duration.inHours}h ${newEntry!.duration.inMinutes.remainder(60)}m",
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: Text(
                  "Thống kê giấc ngủ tại đây",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
