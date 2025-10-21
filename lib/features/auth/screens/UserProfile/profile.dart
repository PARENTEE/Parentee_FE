import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/models/family.dart';
import 'package:parentee_fe/features/auth/models/user.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/login-successfully.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/onboarding-page.dart';
import 'package:parentee_fe/features/auth/screens/UserProfile/Family/family_page.dart';
import 'package:parentee_fe/features/auth/screens/UserProfile/Family/family_preview_page.dart';
import 'package:parentee_fe/services/family_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';
import 'package:parentee_fe/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/theme/app_colors.dart';
import 'profile_detail.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final loadedUser = await SharedPreferencesService.getUserFromPrefs().timeout(const Duration(seconds:5));
    // Return to Onboarding page if no token was found
    if(loadedUser == null) {
      await _logout();
      PopUpToastService.showWarningToast(context, "Phiên đăng nhập đã hết hạn!");
      return;
    }

    setState(() {
      user = loadedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Tài khoản"),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Avatar box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                              "assets/images/homepage/family.jpg",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // Full Name
                                  user!.fullName ?? "Không có tên",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user!.email ?? "Không có email",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.primary_button,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfileDetailPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // General section
                    _buildSectionTitle("Chung"),
                    _buildMenuItem(
                      Icons.inventory_2_outlined,
                      "Gia đình",
                      () async {
                        // show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );
                        // Get family info
                        final result = await FamilyService.getFamilyThroughToken();

                        // Remove loading
                        Navigator.pop(context);

                        if (result.success) {
                          final family = Family.fromJson(result.data);

                          // If family exist -> navigate to family page
                          if (family != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FamilyPage(family: family),
                              ),
                            );
                          }
                        }
                        // If family not exist -> navigate to family preview page
                        else if(!result.success){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FamilyPreviewPage(),
                            ),
                          );
                        }
                        else {
                          throw Exception('Không thể lấy thông tin gia đình!');
                        }

                      },
                    ),

                    _buildMenuItem(
                      Icons.inventory_2_outlined,
                      "Lịch sử giao dịch",
                      null,
                    ),
                    _buildMenuItem(Icons.family_restroom, "Đổi mật khẩu", null),

                    const SizedBox(height: 24),

                    // Support section
                    _buildSectionTitle("Hỗ trợ"),
                    _buildMenuItem(
                      Icons.chat_bubble_outline,
                      "Cần trợ giúp? Chat ngay", () => {}
                    ),
                    _buildMenuItem(
                      Icons.privacy_tip_outlined,
                      "Chính sách bảo mật", () => {}
                    ),

                    const SizedBox(height: 24),

                    // Logout
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await _logout();
                          PopUpToastService.showSuccessToast(context, "Đăng xuất thành công!");

                        },
                        child: const Text("Đăng Xuất"),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    Function()? onTapFunction,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black54),
          title: Text(title, style: const TextStyle(fontSize: 15)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTapFunction,
        ),
        const Divider(height: 1),
      ],
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user');


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
          (route) => false,
    );

  }
}
