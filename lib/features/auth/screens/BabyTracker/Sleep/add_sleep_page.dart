import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/SleepTracker/sleep_dashboard_page.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';
import '../../../models/sleep_entry.dart';
import '../../../widgets/sleep_timer.dart';

class AddSleepPage extends StatefulWidget {
  final String childId;

  const AddSleepPage({super.key, required this.childId});

  @override
  State<AddSleepPage> createState() => _AddSleepPageState();
}

class _AddSleepPageState extends State<AddSleepPage> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Duration duration = Duration.zero;

  bool isSleeping = false; // 👈 để kiểm soát trạng thái ngủ

  Future<void> pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime),
    );
    if (time != null) {
      setState(() {
        startTime = DateTime(
          startTime.year,
          startTime.month,
          startTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endTime),
    );
    if (time != null) {
      setState(() {
        endTime = DateTime(
          endTime.year,
          endTime.month,
          endTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void saveEntry() async {
    final entry = SleepEntry(
      startTime: startTime,
      endTime: endTime,
      duration: duration,
    );

    // Send API
    final response = await ChildService.createSleepRecord(context, {
      "childId": widget.childId,
      "startTime": startTime.toUtc().toIso8601String(),
      "endTime": endTime.toUtc().toIso8601String()
    });

    // SUCCESS
    if(response.success){
      PopUpToastService.showSuccessToast(context, "Thêm giấc ngủ thành công");
      Navigator.pop(context);
    }
    // FAILED
    else {
      PopUpToastService.showErrorToast(context, "Thêm giấc ngủ không thành công");
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => SleepDashboardPage(newEntry: entry)),
    // );
  }

  // Gọi khi timer bắt đầu
  void _onSleepStart() {
    setState(() {
      isSleeping = true;
      startTime = DateTime.now();
    });
  }

  // Gọi khi timer dừng
  void _onSleepStop(Duration d) {
    setState(() {
      isSleeping = false;
      endTime = DateTime.now();
      duration = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm giấc ngủ"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nút chọn thời gian
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: pickStartTime,
                    child: Text(
                      "Thời gian bắt đầu: ${TimeOfDay.fromDateTime(startTime).format(context)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: pickEndTime,
                    child: Text(
                      "Thời gian kết thúc: ${TimeOfDay.fromDateTime(endTime).format(context)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Timer bo tròn
            SleepTimer(
              onStart: _onSleepStart, // 👈 gọi khi bấm Start
              onStop: _onSleepStop, // 👈 gọi khi bấm Stop
            ),

            const SizedBox(height: 40),

            // Box hiển thị chi tiết giấc ngủ
            if (isSleeping || duration > Duration.zero)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "💤 Trạng thái: ${isSleeping ? "Đang ngủ" : "Đã thức dậy"}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "🕒 Bắt đầu: ${TimeOfDay.fromDateTime(startTime).format(context)}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "🌤 Thức dậy: ${isSleeping ? "--:--" : TimeOfDay.fromDateTime(endTime).format(context)}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),

            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary_button,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: saveEntry,
              child: const Text(
                "Lưu lại",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
