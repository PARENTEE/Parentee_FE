import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class TaskDialog {
  static Future<bool?> showAddTaskDialog({
    required BuildContext context,
    required String childId,
    required DateTime selectedDate,
    required Function(Map<String, dynamic>) onAddTask,
  }) {
    final titleController = TextEditingController();
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    DateTime selectedDay = selectedDate;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Thêm nhiệm vụ mới",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nhập tên nhiệm vụ
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Tên nhiệm vụ",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Chọn ngày
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ngày: ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDay,
                              firstDate: DateTime.now(), // chỉ hôm nay trở đi
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setStateDialog(() => selectedDay = picked);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Giờ bắt đầu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startTime == null
                              ? "Chọn giờ bắt đầu"
                              : "Bắt đầu: ${startTime!.format(context)}",
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.input,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(
                                    context,
                                  ).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setStateDialog(() => startTime = picked);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Giờ kết thúc
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          endTime == null
                              ? "Chọn giờ kết thúc"
                              : "Kết thúc: ${endTime!.format(context)}",
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.input,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(
                                    context,
                                  ).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              }, // 👈 dùng input mode
                            );
                            if (picked != null) {
                              setStateDialog(() => endTime = picked);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary_button,
              ),
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    startTime == null ||
                    endTime == null) {
                  PopUpToastService.showErrorToast(
                    context,
                    "Vui lòng nhập đầy đủ thông tin!",
                  );
                  return;
                }

                final startDateTime = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                  startTime!.hour,
                  startTime!.minute,
                );
                final endDateTime = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                  endTime!.hour,
                  endTime!.minute,
                );

                // Validation: ensure end time > start time
                if (endDateTime.isBefore(startDateTime)) {
                  PopUpToastService.showErrorToast(
                    context,
                    "Giờ kết thúc phải sau giờ bắt đầu!",
                  );
                  return;
                }

                try {
                  // Call API
                  final response = await ChildService.createTask(context, {
                    "title": titleController.text,
                    "startsAt": startDateTime.toIso8601String(),
                    "endsAt": endDateTime.toIso8601String(),
                    "allDay": false,
                    "status": 0,
                    "childId":
                        childId, // replace with actual childId if dynamic
                  });

                  // You can check response.statusCode if needed
                  if (response.success) {
                    final newTask = {
                      'title': titleController.text,
                      'time':
                          "${startTime!.format(context)} - ${endTime!.format(context)}",
                      'done': false,
                      'startsAt': startDateTime,
                      'endsAt': endDateTime,
                    };

                    onAddTask(newTask);
                    Navigator.pop(context, true);
                    PopUpToastService.showSuccessToast(
                      context,
                      "Thêm nhiệm vụ thành công!",
                    );
                  } else {
                    PopUpToastService.showErrorToast(
                      context,
                      "Thêm nhiệm vụ thất bại!",
                    );
                  }
                } catch (e) {
                  PopUpToastService.showErrorToast(
                    context,
                    "Lỗi khi gọi API: $e",
                  );
                }
              },
              child: const Text("Thêm", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
