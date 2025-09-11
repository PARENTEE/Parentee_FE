import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/Notification/notification.dart';
import 'package:parentee_fe/features/auth/widgets/bottom_nav.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/Weather/weather.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Danh mục
  static final List<Map<String, dynamic>> categories = [
    {
      "icon": "assets/images/order-tracking.png",
      "label": "Bộ theo dõi",
      "page": null,
    },
    {
      "icon": "assets/images/weather.png",
      "label": "Thời tiết",
      "page": const WeatherPage(),
    },
    {"icon": "assets/images/drugs.png", "label": "Thuốc", "page": null},
    {"icon": "assets/images/nutrient.png", "label": "Dinh dưỡng", "page": null},
  ];

  // Banner (carousel)
  static final List<String> banners = [
    "assets/images/homepage/family.jpg",
    "assets/images/homepage/bond.jpg",
    "assets/images/homepage/connections.jpg",
  ];

  // Chuyên mục
  static final List<Map<String, String>> articles = [
    {
      "image": "assets/images/homepage/family.jpg",
      "title": "Giữ lửa hạnh phúc trong gia đình",
    },
    {
      "image": "assets/images/homepage/bond.jpg",
      "title": "Bí quyết nuôi dạy con khỏe mạnh",
    },
    {
      "image": "assets/images/homepage/connections.jpg",
      "title": "Thời gian chất lượng cùng gia đình",
    },
  ];

  // Khóa học
  static final List<Map<String, String>> courses = [
    {
      "image": "assets/images/homepage/co_parenting.jpg",
      "title": "Kỹ năng làm cha mẹ hiện đại",
    },
    {
      "image": "assets/images/homepage/happiness.jpg",
      "title": "Nuôi dạy con thông minh cảm xúc (EQ)",
    },
    {
      "image": "assets/images/homepage/healthy_parenting.jpg",
      "title": "Khóa học xây dựng gia đình hạnh phúc",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNav(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Trợ lý AI chưa có trang")),
            );
          },
          child: Image.asset("assets/images/chatbot_1.png"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(
                        "assets/images/homepage/family.jpg",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Chào mừng! Admin",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Miễn phí",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    // Icon notification + badge đỏ
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications_none, size: 30),
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Banner Carousel
                CarouselSlider(
                  options: CarouselOptions(
                    height: 170,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                  items:
                      banners.map((banner) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            banner,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                // Danh mục
                const Text(
                  "Danh mục",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      categories.map((cat) {
                        return _buildCategory(
                          context,
                          cat["icon"],
                          cat["label"],
                          cat["page"],
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                // Chuyên mục
                const Text(
                  "Chuyên mục",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        articles
                            .map(
                              (art) => _buildCard(art["image"]!, art["title"]!),
                            )
                            .toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Khóa học
                const Text(
                  "Khóa học",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        courses
                            .map((c) => _buildCard(c["image"]!, c["title"]!))
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget danh mục
  static Widget _buildCategory(
    BuildContext context,
    String image,
    String label, [
    Widget? page,
  ]) {
    return InkWell(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$label chưa có trang")));
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 56,
            width: 56,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Widget thẻ chuyên mục / khóa học
  static Widget _buildCard(String image, String title) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
