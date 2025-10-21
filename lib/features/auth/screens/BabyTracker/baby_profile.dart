import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/DiaperChange/AddDiaperChangePage.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/Feeding/AddFeedingPage.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/SolidFood/AddSolidFoodPage.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/edit_baby_profile.dart';
import 'package:parentee_fe/features/auth/screens/NutrientPage/add_food.dart';

class BabyProfilePage extends StatelessWidget {
  const BabyProfilePage({super.key});

  static final List<Map<String, dynamic>> activities = [
    {"title": "Cho con bú", "subtitle": "1 phút trước", "icon": Icons.add, "navigateToPage": const AddFeedingPage() },
    {"title": "Cho ăn", "subtitle": "2 giờ trước", "icon": Icons.restaurant, "navigateToPage": const AddSolidFoodPage() },
    {"title": "Ngủ", "subtitle": "1 phút trước", "icon": Icons.bedtime},
    {"title": "Đồ ăn", "subtitle": "1 phút trước", "icon": Icons.fastfood},
    {
      "title": "Thay tã",
      "subtitle": "Vừa xong",
      "icon": Icons.baby_changing_station,
      "navigateToPage": const DiaperChangePage()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Bé yêu",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar + tên + nút chỉnh sửa
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/nutrient.png"),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bata Bean",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditBabyProfilePage(),
                  ),
                );
              },
              child: const Text(
                "Chỉnh sửa",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 24),

            // Ngày hôm nay
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _formatDate(DateTime.now()),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Danh sách hoạt động
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return _ActivityCard(
                    title: activity["title"],
                    subtitle: activity["subtitle"],
                    icon: activity["icon"],
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => activity["navigateToPage"],
                        ),
                      )
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  static String _monthName(int m) {
    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[m];
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap, // 👈 handle taps here
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Icon(icon, color: Colors.green.shade600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
