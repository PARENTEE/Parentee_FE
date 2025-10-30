import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';

class ParentMissionPage extends StatefulWidget {
  const ParentMissionPage({super.key});

  @override
  State<ParentMissionPage> createState() => _ParentMissionPageState();
}

class _ParentMissionPageState extends State<ParentMissionPage> {
  int selectedDay = DateTime.now().day;

  final List<Map<String, dynamic>> missions = [
    {"title": "Cho bé bú", "time": "07:30", "done": true},
    {"title": "Thay tã", "time": "10:30", "done": false},
    {"title": "Massage cho bé", "time": "13:00", "done": false},
    {"title": "Chơi với bé", "time": "15:30", "done": false},
    {"title": "Tắm cho bé", "time": "18:00", "done": false},
    {"title": "Dỗ bé ngủ", "time": "21:00", "done": false},
  ];

  @override
  Widget build(BuildContext context) {
    int doneCount = missions.where((m) => m["done"]).length;
    double progress = doneCount / missions.length;

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
            const SizedBox(height: 20),
            _buildAddButton(),
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
          final isSelected = d.day == selectedDay;
          return GestureDetector(
            onTap: () => setState(() => selectedDay = d.day),
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
              onChanged: (val) {
                setState(() => m["done"] = val);
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
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Thêm nhiệm vụ mới",
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
}
