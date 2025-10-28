import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/edit_baby_profile.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class BabyPreviewPage extends StatefulWidget {
  const BabyPreviewPage({super.key});

  @override
  State<BabyPreviewPage> createState() => _BabyPreviewPageState();
}

class _BabyPreviewPageState extends State<BabyPreviewPage> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Em Bé",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Chưa có em bé nào",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: Lottie.asset(
                "assets/lottie/baby.json", // 🍼 file animation Lottie
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Tạo hồ sơ em bé mới",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Chạm vào đây để thêm thông tin về em bé của bạn!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditBabyProfilePage(useToCreate: true,)
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Tạo hồ sơ em bé",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
