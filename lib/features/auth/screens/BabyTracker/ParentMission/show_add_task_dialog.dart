import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/models/family.dart';
import 'package:parentee_fe/features/auth/models/family_user.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/family_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class TaskDialog {
  static Future<List<FamilyUser>> _loadData(
      BuildContext context) async {
    final result = await FamilyService.getFamilyThroughToken(context);

    if (result.success) {
      final family = Family.fromJson(result.data);
      return family.familyUsers;
    } else {
      PopUpToastService.showErrorToast(context, "Không lấy được người trong gia đình!");
    }
    return [];
  }

  static String getFamilyRoleName(int role) {
    switch (role) {
      case 0:
        return "Bố";
      case 1:
        return "Mẹ";
      default:
        return "Khác";
    }
  }

  static Future<bool?> showAddTaskDialog({
    required BuildContext context,
    required String childId,
    required DateTime selectedDate,
    required Function(Map<String, dynamic>) onAddTask,
  }) async {
    final titleController = TextEditingController();
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    DateTime selectedDay = selectedDate;

    List<FamilyUser> familyMembers = await _loadData(context);
    String? selectedMemberId;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Thêm nhiệm vụ mới",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Tên nhiệm vụ",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Giao cho",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedMemberId,
                      items: familyMembers.map((member) {
                        return DropdownMenuItem<String>(
                          value: member.id,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(member.fullName),
                              const SizedBox(width: 6),
                              Text(
                                "(${getFamilyRoleName(member.gender)})",
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setStateDialog(() => selectedMemberId = value);
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ngày: ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}"),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: dialogContext,
                              initialDate: selectedDay,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setStateDialog(() => selectedDay = picked);
                            }
                          },
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(startTime == null
                            ? "Chọn giờ bắt đầu"
                            : "Bắt đầu: ${startTime!.format(dialogContext)}"),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: dialogContext,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(endTime == null
                            ? "Chọn giờ kết thúc"
                            : "Kết thúc: ${endTime!.format(dialogContext)}"),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: dialogContext,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              },
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
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_button,
                  ),
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        startTime == null ||
                        endTime == null ||
                        selectedMemberId == null) {
                      PopUpToastService.showErrorToast(
                          dialogContext, "Vui lòng nhập đầy đủ thông tin!");
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

                    if (endDateTime.isBefore(startDateTime)) {
                      PopUpToastService.showErrorToast(
                          dialogContext, "Giờ kết thúc phải sau giờ bắt đầu!");
                      return;
                    }

                    final response = await ChildService.createTask(dialogContext, {
                      "title": titleController.text,
                      "startsAt": startDateTime.toIso8601String(),
                      "endsAt": endDateTime.toIso8601String(),
                      "allDay": false,
                      "status": 0,
                      "childId": childId,
                      "assignedTo": selectedMemberId,
                    });

                    if (response.success) {
                      onAddTask({
                        'title': titleController.text,
                        'time':
                        "${startTime!.format(dialogContext)} - ${endTime!.format(dialogContext)}",
                        'done': false,
                        'assignedTo': selectedMemberId,
                      });

                      PopUpToastService.showSuccessToast(
                          dialogContext, "Thêm nhiệm vụ thành công!");

                      Navigator.pop(dialogContext, true);
                    } else {
                      PopUpToastService.showErrorToast(
                          dialogContext, "Thêm nhiệm vụ thất bại!");
                    }
                  },
                  child: const Text("Thêm", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
