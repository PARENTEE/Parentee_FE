import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/models/family.dart';
import 'package:parentee_fe/features/auth/screens/UserProfile/Family/family_page.dart';
import 'package:parentee_fe/services/family_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';

class FamilyPreviewPage extends StatefulWidget {
  const FamilyPreviewPage({super.key});

  @override
  State<FamilyPreviewPage> createState() => _FamilyPreviewPageState();
}

class _FamilyPreviewPageState extends State<FamilyPreviewPage> {
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
          "Gia Đình",
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
              "Chưa có gia đình nào",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Lottie.asset(
                "assets/lottie/family.json", // Thay file animation nếu cần
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Tạo gia đình mới",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Chạm vào đây để tạo gia đình của bạn!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 40),

            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Nhập để thêm tên gia đình...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Check if nameController is emtpy
                  if (nameController.text.isEmpty) {
                    PopUpToastService.showErrorToast(context, 'Vui lòng nhập tên gia đình');
                    return;
                  }
                  // show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  // Create family
                  final result = await FamilyService.createFamily(nameController.text);

                  // Remove loading
                  Navigator.pop(context);

                  if(result.success) {
                    final family = Family.fromJson(result.data);
                    // Navigate to family page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FamilyPage(family: family)));
                  }
                  else PopUpToastService.showErrorToast(context, result.message.toString());
                 },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Tạo gia đình",
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
