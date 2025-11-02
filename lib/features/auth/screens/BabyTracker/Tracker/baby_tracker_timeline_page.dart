import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class BabyTrackerTimelinePage extends StatefulWidget {
  final String childId;
  final DateTime date;
  const BabyTrackerTimelinePage({
    super.key,
    required this.childId,
    required this.date,
  });

  @override
  State<BabyTrackerTimelinePage> createState() =>
      _BabyTrackerTimelinePageState();
}

class _BabyTrackerTimelinePageState extends State<BabyTrackerTimelinePage> {
  final List<IconData> _icon = [
    Icons.add,
    Icons.restaurant,
    Icons.baby_changing_station,
    Icons.bedtime,
  ];

  final List<String> _time = [
    "0:00",
    "2:00",
    "4:00",
    "6:00",
    "8:00",
    "10:00",
    "12:00",
    "14:00",
    "16:00",
    "18:00",
    "20:00",
    "22:00",
    "23:59",
  ];

  // Timeline activities for each day - 7 columns
  final Map<String, List<Map<String, dynamic>>> _activityTimeBlock = {
    "feeding": [],
    "solidFood": [],
    "diaperChanges": [],
    "sleep": [],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTimelineData(); // ✅ Gọi sau khi build lần đầu hoàn tất
    });
  }

  void _fetchTimelineData() async {
    final response = await ChildService.getChildReport(
      context,
      widget.childId,
      widget.date,
    );

    if (response.success) {
      final data = response.data;
      parseResponse(data);
      setState(() {});
    } else {
      PopUpToastService.showErrorToast(context, "Lấy report không thành công");
    }
  }

  void parseResponse(Map<String, dynamic> data) {
    setState(() {
      _activityTimeBlock["feeding"] =
          (data["feedings"] as List).map((item) {
            final startDate = DateTime.parse(item["startTime"]);
            final endDate = DateTime.parse(item["endTime"]);

            return {
              "color": AppColors.primary_button,
              "message": item["message"], // ✅ Thêm dòng này
              "icon": Icons.restaurant,   // ✅ Thêm để hiện logo dễ hơn
              "startTime": TimeOfDay(
                hour: startDate.hour,
                minute: startDate.minute,
              ),
              "endTime": TimeOfDay(hour: endDate.hour, minute: endDate.minute),
            };
          }).toList();

      _activityTimeBlock["solidFood"] =
          (data["solidFood"] as List).map((item) {
            final startDate = DateTime.parse(item["startTime"]);
            final endDate = DateTime.parse(item["endTime"]);

            return {
              "color": Colors.orangeAccent,
              "message": item["message"],
              "icon": Icons.restaurant_menu,
              "startTime": TimeOfDay(
                hour: startDate.hour,
                minute: startDate.minute,
              ),
              "endTime": TimeOfDay(hour: endDate.hour, minute: endDate.minute),
            };
          }).toList();

      _activityTimeBlock["diaperChanges"] =
          (data["diaperChanges"] as List).map((item) {
            final startDate = DateTime.parse(item["startTime"]);
            final endDate = DateTime.parse(item["endTime"]);

            return {
              "color": Colors.lightBlueAccent,
              "message": item["message"],
              "icon": Icons.baby_changing_station,
              "startTime": TimeOfDay(
                hour: startDate.hour,
                minute: startDate.minute,
              ),
              "endTime": TimeOfDay(hour: endDate.hour, minute: endDate.minute),
            };
          }).toList();

      _activityTimeBlock["sleep"] =
          (data["sleep"] as List).map((item) {
            final startDate = DateTime.parse(item["startTime"]);
            final endDate = DateTime.parse(item["endTime"]);

            return {
              "color": Colors.purpleAccent,
              "message": item["message"],
              "icon": Icons.bedtime,
              "startTime": TimeOfDay(
                hour: startDate.hour,
                minute: startDate.minute,
              ),
              "endTime": TimeOfDay(hour: endDate.hour, minute: endDate.minute),
            };
          }).toList();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Theo dõi bé",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // icon header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(_icon.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 50,
                          ), // 👈 chỉnh khoảng cách ở đây
                          child: Icon(
                            _icon[index],
                            color: AppColors.primary_button,
                            size: 34,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Timeline and Activity list
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Timeline chart with 7 columns
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time labels
                        Column(
                          children:
                              _time.map((time) {
                                return SizedBox(
                                  height: 50,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(width: 8),
                        // Timeline bars
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ), // <== thêm dòng này
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  _activityTimeBlock.entries.map((entry) {
                                    final activities = entry.value;
                                    return Expanded(
                                      child: generateTimeBlock(activities),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding generateTimeBlock(List<Map<String, dynamic>> activities) {
    // Sắp xếp hoạt động theo thời gian bắt đầu
    activities.sort((a, b) {
      final startA = a['startTime'] as TimeOfDay;
      final startB = b['startTime'] as TimeOfDay;
      return startA.hour.compareTo(startB.hour) != 0
          ? startA.hour.compareTo(startB.hour)
          : startA.minute.compareTo(startB.minute);
    });

    List<Widget> blocks = [];
    TimeOfDay previousEnd = const TimeOfDay(hour: 0, minute: 0);

    for (var activity in activities) {
      final start = activity['startTime'] as TimeOfDay;
      final end = activity['endTime'] as TimeOfDay;
      final color = activity['color'] as Color;

      // Nếu có khoảng trống giữa 2 hoạt động → block transparent
      if (_minutesBetween(previousEnd, start) > 0) {
        blocks.add(
          Container(
            height: _calculateHeight(previousEnd, start),
            color: Colors.transparent,
          ),
        );
      }

      // Xử lý nếu hoạt động qua đêm
      if (_isOvernight(start, end)) {
        final endOfDay = const TimeOfDay(hour: 23, minute: 59);
        blocks.add(
          GestureDetector(
            onTap: () => _showActivityInfo(context, activity),
            child: Container(
              height: _calculateHeight(start, endOfDay),
              margin: const EdgeInsets.symmetric(vertical: 0.5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      } else {
        // Block hoạt động bình thường
        blocks.add(
          GestureDetector(
            onTap: () => _showActivityInfo(context, activity),
            child: Container(
              height: _calculateHeight(start, end),
              margin: const EdgeInsets.symmetric(vertical: 0.5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      }

      previousEnd = end;
    }

    // Nếu còn trống đến 23:59 → thêm block transparent cuối
    const endOfDay = TimeOfDay(hour: 23, minute: 59);
    if (_minutesBetween(previousEnd, endOfDay) > 0) {
      blocks.add(
        Container(
          height: _calculateHeight(previousEnd, endOfDay),
          color: Colors.transparent,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(children: blocks),
    );
  }


  /// Tính khoảng cách phút giữa 2 TimeOfDay
  int _minutesBetween(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes - startMinutes;
  }

  /// Tính chiều cao block (mỗi 2 giờ = 50px)
  double _calculateHeight(TimeOfDay start, TimeOfDay end) {
    final diffMinutes = _minutesBetween(start, end);
    final diffHours = diffMinutes / 60;
    final height = (diffHours / 2) * 50;
    return height < 8 ? 8 : height; // 👈 ít nhất 8px để nhìn thấy
  }

  bool _isOvernight(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return endMinutes < startMinutes;
  }

  void _showActivityInfo(BuildContext context, Map<String, dynamic> activity) {
    final message = activity["message"] ?? "Không có thông tin";
    final icon = activity["icon"] as IconData?;
    final color = activity["color"] as Color?;
    final startTime = activity["startTime"] as TimeOfDay?;
    final endTime = activity["endTime"] as TimeOfDay?;

    String formatTime(TimeOfDay? t) {
      if (t == null) return "--:--";
      final hour = t.hour.toString().padLeft(2, '0');
      final minute = t.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              if (icon != null)
                CircleAvatar(
                  backgroundColor: color?.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
              const SizedBox(width: 12),
              const Text("Chi tiết hoạt động"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    "Bắt đầu: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(formatTime(startTime)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time_filled, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    "Kết thúc: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(formatTime(endTime)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

}
