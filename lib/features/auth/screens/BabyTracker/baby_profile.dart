import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/DiaperChange/diaper_change_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/Feeding/feeding_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/ParentMission/parent_mission_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/Sleep/add_sleep_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/SolidFood/solid_food_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/Tracker/baby_tracker_timeline_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/edit_baby_profile.dart';
import 'package:parentee_fe/features/auth/models/child.dart';
import 'package:parentee_fe/services/child_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

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
  List<Child> _children = [];
  List<Map<String, dynamic>> activities = [];
  List<Map<String, dynamic>> otherActivities = [];
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _children = widget.children;

    // Load children after the first frame if needed
    if (_children.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadChildren();
      });
    }
  }

  Future<void> _loadChildren() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final response = await ChildService.getChildrenInCurrentFamily(context);

    if (!mounted) return;

    if (response.success) {
      final List<dynamic>? data = response.data;
      final List<Child> children = (data != null && data.isNotEmpty)
          ? data.map((e) => Child.fromJson(e)).toList()
          : [];

      if (children.isEmpty) {
        PopUpToastService.showErrorToast(context, "Hiện không có bé nào cả");
        Navigator.pop(context);
        return;
      } else {
        setState(() {
          _children = children;
          _isLoading = false;
        });
      }
    } else {
      PopUpToastService.showErrorToast(context, "Lấy thông tin các bé không thành công.");
      Navigator.pop(context);
    }
  }

  void _onChildChanged(int newIndex) {
    setState(() {
      _currentChildren = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading if children are being fetched
    if (_isLoading || _children.isEmpty) {
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
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black87),
              tooltip: "Thêm bé",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditBabyProfilePage(childId: "")
                  ),
                );
              },
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    activities = [];

    otherActivities = [
      {"title": "Tổng quan", "subtitle": "", "icon": Icons.report, "navigateToPage": BabyTrackerTimelinePage(
          childId: _children[_currentChildren].id,
          date: _selectedDate
      )}
    ];

    // Nếu là hôm nay → thêm mục "Nhiệm vụ"
    if (_isToday(_selectedDate)) {
      otherActivities.insert(0, {
        "title": "Nhiệm vụ",
        "subtitle": "",
        "icon": Icons.task,
        "navigateToPage": ParentMissionPage(childId: _children[_currentChildren].id)
      });

      activities = [
        {"title": "Cho bú", "subtitle": "1 phút trước", "icon": Icons.add, "navigateToPage": AddFeedingPage(childId: _children[_currentChildren].id)},
        {"title": "Cho ăn", "subtitle": "2 giờ trước", "icon": Icons.restaurant, "navigateToPage": AddSolidFoodPage(childId: _children[_currentChildren].id)},
        {"title": "Ngủ", "subtitle": "1 phút trước", "icon": Icons.bedtime, "navigateToPage": AddSleepPage(childId: _children[_currentChildren].id)},
        {"title": "Thay tã", "subtitle": "Vừa xong", "icon": Icons.baby_changing_station, "navigateToPage": DiaperChangePage(childId: _children[_currentChildren].id)},
      ];
    }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            tooltip: "Thêm bé",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditBabyProfilePage(childId: "")
                ),
              );
            },
          ),
        ],
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
                    itemCount: _children.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                        _currentChildren = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final child = _children[index];
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              ),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBabyProfilePage(childId: _children[_currentChildren].id),
                                  ),
                                );

                                // Reload children if edit was successful
                                if (result == true && mounted) {
                                  await _loadChildren();
                                }
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
                    _children.length,
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

            // Chọn ngày (Date Picker)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isToday(_selectedDate) ? "Today" : "Selected Date",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      _formatDate(_selectedDate),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month, color: Colors.black87),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(), // không cho chọn tương lai
                    );

                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                )
              ],
            ),

            const SizedBox(height: 16),

            if (activities.isNotEmpty) ...[
              const Text(
                "Hoạt động cho bé",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3,
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

            // Danh sách các hoạt động bố mẹ
            // Danh sách các hoạt động bố mẹ
            const Text(
              "Hoạt động cùa cha mẹ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: otherActivities.length == 1 ? 1 : 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: otherActivities.length == 1 ? 5 : 3,
                ),
                itemCount: otherActivities.length,
                itemBuilder: (context, index) {
                  final activity = otherActivities[index];
                  return _ActivityCard(
                    title: activity["title"],
                    subtitle: activity["subtitle"],
                    icon: activity["icon"],
                    centerContent: otherActivities.length == 1, // 👈 truyền cờ căn giữa
                    backGroundColor: Colors.redAccent.shade100,
                    iconColor: Colors.white,
                    textColor: Colors.white,
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
class _ActivityCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  final Color backGroundColor;
  final Color iconColor;
  final Color textColor;
  final bool centerContent; // ✅ thêm flag

  const _ActivityCard({
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.backGroundColor = const Color(0xFFD0F0C0),
    this.iconColor = const Color(0xFF2E7D32),
    this.textColor = Colors.black87,
    this.centerContent = false, // mặc định false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: centerContent
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ căn giữa cả row
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: backGroundColor.withOpacity(0.6),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
