import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';

class LoginSuccessfullyPage extends StatefulWidget {
  const LoginSuccessfullyPage({super.key});

  @override
  State<LoginSuccessfullyPage> createState() => _LoginSuccessfullyPageState();
}

class _LoginSuccessfullyPageState extends State<LoginSuccessfullyPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Hiển thị Lottie pháo bông chạy loop
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 500,
              width: 500,
              child: Lottie.asset(
                "assets/lottie/success.json",
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController
                    ..duration = composition.duration
                    ..repeat(); // chạy lặp vô hạn
                },
              ),
            ),
          ),

          /// Nội dung chính
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Lottie.asset("assets/lottie/family_2.json", height: 250),
                      const SizedBox(height: 40),
                      const Text(
                        "Thành công!",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Cảm ơn bạn đã tham gia",
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/home");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary_button,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Tiếp tục",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
