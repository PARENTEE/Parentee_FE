import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/DiaperChange/diaper_change_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/Feeding/feeding_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/ParentMission/ParentMissionPage.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/Sleep/add_sleep_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/SolidFood/solid_food_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/edit_baby_profile.dart';
import 'package:parentee_fe/features/auth/models/child.dart';

class BabyProfilePage extends StatefulWidget {
  final List<Child> children;

  const BabyProfilePage({super.key, required this.children});

  @override
  State<BabyProfilePage> createState() => _BabyProfilePageState();
}

class _BabyProfilePageState extends State<BabyProfilePage> {
  late PageController _pageController;
  int _currentIndex = 0;
  int _currentChildren = 0;

  static List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    activities = [
      {"title": "Cho bú", "subtitle": "1 phút trước", "icon": Icons.add, "navigateToPage": AddFeedingPage(childId: widget.children[_currentChildren].id)},
      {"title": "Cho ăn", "subtitle": "2 giờ trước", "icon": Icons.restaurant, "navigateToPage": const AddSolidFoodPage()},
      {"title": "Ngủ", "subtitle": "1 phút trước", "icon": Icons.bedtime, "navigateToPage": AddSleepPage(childId: widget.children[_currentChildren].id)},
      {"title": "Thay tã", "subtitle": "Vừa xong", "icon": Icons.baby_changing_station, "navigateToPage": DiaperChangePage(childId: widget.children[_currentChildren].id)},
      // {"title": "Nhiệm vụ cha mẹ", "subtitle": "1 phút trước", "icon": Icons.safety_check, "navigateToPage": const ParentMissionPage()},
    ];
  }

  void _onChildChanged(int newIndex) {
    setState(() {
      _currentChildren = newIndex;
      // activities[0]["navigateToPage"] =
      //     AddFeedingPage(childId: widget.children[_currentChildren].id);
      // activities[3]["navigateToPage"] =
      //     EditBabyProfilePage(child: widget.children[_currentChildren]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.children;

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
              Column(
                children: [
                  // --- Slide bé ---
                  SizedBox(
                    height: 260,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: children.length,
                      onPageChanged: (index) => setState(() => _currentIndex = index),
                      itemBuilder: (context, index) {
                        final child = children[index];
                        final isActive = index == _currentIndex;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: isActive ? 8 : 16, vertical: isActive ? 0 : 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: child.photoImageId != null
                                    ? NetworkImage("https://yourapi.com/api/files/${child.photoImageId}")
                                    : const AssetImage("assets/images/nutrient.png") as ImageProvider,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                child.fullName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // Text(
                              //   "${child.sex} • ${child.birthDate.toString().split('T').first}",
                              //   style: const TextStyle(color: Colors.black54),
                              // ),
                              // const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EditBabyProfilePage(useToCreate: false),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Chỉnh sửa",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Indicator nhỏ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      children.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentIndex == index ? 20 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? Colors.pinkAccent : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
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

            const SizedBox(height: 16),

            // Danh sách hoạt động
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return _ActivityCard(
                    title: activity["title"],
                    subtitle: activity["subtitle"],
                    icon: activity["icon"],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => activity["navigateToPage"]),
                    ),
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
      onTap: onTap,
      child: Container(
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
