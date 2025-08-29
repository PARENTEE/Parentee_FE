import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/login.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Parentee",
      "subtitle": "Trợ lý cho gia đình nhỏ của bạn",
      "image": "assets/images/parentee_logo.png",
    },
    {
      "title": "Kết nối cả gia đình",
      "subtitle":
          "Tạo không gian riêng tư cho gia đình bạn – nơi mọi người cùng chia sẻ, nhắc nhở, và quan tâm nhau mỗi ngày.",
      "image": "assets/images/onboarding_4.png",
    },
    {
      "title": "Quản lý lịch trình & thói quen",
      "subtitle":
          "Từ lịch của bé đến công việc của ba mẹ – mọi hoạt động đều được theo dõi và nhắc nhở thông minh, giúp cả nhà luôn chủ động.",
      "image": "assets/images/onboarding_2.png",
    },
    {
      "title": "Chăm sóc bằng yêu thương",
      "subtitle":
          "Ghi chú tâm trạng, theo dõi sức khỏe, lưu giữ những khoảnh khắc đáng nhớ – mọi thứ đều vì một gia đình hạnh phúc hơn.",
      "image": "assets/images/onboarding_3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _pages[index]["image"]!,
                  height:
                      _pages[index]["image"] ==
                              "assets/images/parentee_logo.png"
                          ? 120
                          : 250,
                ),

                const SizedBox(height: 30),
                Text(
                  _pages[index]["title"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _pages[index]["subtitle"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet:
          _currentIndex == _pages.length - 1
              ? Container(
                height: 80,
                width: double.infinity,
                color: AppColors.primary_button,
                child: TextButton(
                  child: const Text(
                    "Bắt đầu",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              )
              : Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary_button,
                      ),
                      child: const Text("Bỏ qua"),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.all(4),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentIndex == index
                                    ? AppColors.primary_button
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary_button,
                      ),
                      child: const Text("Tiếp"),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
