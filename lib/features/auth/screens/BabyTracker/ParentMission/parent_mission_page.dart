import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/ParentMission/show_add_task_dialog.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class ParentMissionPage extends StatefulWidget {
  final String childId;
  const ParentMissionPage({super.key, required this.childId});

  @override
  State<ParentMissionPage> createState() => _ParentMissionPageState();
}

class _ParentMissionPageState extends State<ParentMissionPage> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> missions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final response = await ChildService.getTaskByChildIdAndDate(context, widget.childId, selectedDate);

    if(response.success && response.data != null) {
      final List<dynamic> data = response.data;

      setState(() {
        missions.clear();
        missions.addAll(data.map((task) {
          final startsAt = DateTime.parse(task['startsAt']);
          final endsAt = DateTime.parse(task['endsAt']);
          final timeFormat = DateFormat('HH:mm');

          return {
            'id': task['id'],
            'title': task['title'],
            'time': '${timeFormat.format(startsAt)} - ${timeFormat.format(endsAt)}',
            'done': task['status'] == 1, // or adjust if you have another meaning
          };
        }).toList());
      });
    }
    else {
      PopUpToastService.showErrorToast(context, response.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    int doneCount = missions.where((m) => m["done"]).length;
    double progress = 0;
    if (missions.length > 0) {
      progress = doneCount / missions.length;
    }

    return Scaffold(
      // backgroundColor: const Color(0xFFFFF6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Nhiệm vụ chăm sóc bé",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendarBar(),
            const SizedBox(height: 16),
            _buildMissionList(),
            const SizedBox(height: 16),
            _buildProgressBar(progress, doneCount),
            const SizedBox(height: 16),
            _buildAddButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarBar() {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.add(Duration(days: i - 3)));

    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final d = days[index];
          final isSelected = d.day == selectedDate.day &&
                             d.month == selectedDate.month &&
                             d.year == selectedDate.year;
          return GestureDetector(
            onTap: () async {
              setState(() => selectedDate = d);
              await _loadData();
            },
            child: Container(
              width: 55,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.sub_color : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary_button : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat.E().format(d),
                      style: TextStyle(
                        color: isSelected ? AppColors.primary_button : Colors.grey,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    d.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary_button : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMissionList() {
    return Column(
      children: missions.map((m) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.transparent,
            // border: Border(
            //   bottom: BorderSide(
            //     color: m["done"] ? Colors.green : AppColors.primary_button, // ✅ Màu viền dưới
            //     width: 1.5,
            //   ),
            // ),
            // borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              m["done"] ? Icons.check_circle : Icons.access_time,
              color: m["done"] ? Colors.green : AppColors.primary_button,
            ),
            title: Text(m["title"],
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("🕒 ${m["time"]}"),

            trailing: Switch(
              activeThumbColor: Colors.green,
              activeTrackColor: Colors.green.shade200,
              inactiveThumbColor: AppColors.primary_button,
              inactiveTrackColor: AppColors.sub_color,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              value: m["done"],
              onChanged: (val) async {
                final response = await ChildService.updateTaskStatus(context, m["id"], m["done"] ? 1 : 0);

                if(response.success){
                  PopUpToastService.showSuccessToast(context, "Cập nhật thành công");
                  setState(() => m["done"] = val);
                }
                else {
                  PopUpToastService.showErrorToast(context, "Cập nhật thất bại");
                }

              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgressBar(double progress, int doneCount) {

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: AppColors.primary_button,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tổng nhiệm vụ hôm nay: $doneCount/${missions.length}"),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            color: AppColors.primary_button,
            backgroundColor: AppColors.sub_color,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await TaskDialog.showAddTaskDialog(
            context: context,
            childId: widget.childId,
            selectedDate: selectedDate,
            onAddTask: (newTask) {
              setState(() {
                missions.add(newTask);
              });
            },
          );

          if (result == true) {
            await _loadData();
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Thêm nhiệm vụ",
          style: TextStyle(color: Colors.white)
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary_button,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }


  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {        },
        icon: const Icon(Icons.save, color: AppColors.primary_button),
        label: const Text(
            "Lưu thay đổi",
            style: TextStyle(color: AppColors.primary_button)
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: AppColors.primary_button, // màu viền
              width: 2, // độ dày viền
            ),
          ),
          elevation: 0, // bỏ đổ bóng nếu muốn kiểu phẳng
        ),
      ),
    );
  }
}
