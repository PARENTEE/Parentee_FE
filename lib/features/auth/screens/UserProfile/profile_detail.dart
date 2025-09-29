import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  final TextEditingController _nameController = TextEditingController(
    text: "Nguyễn Văn A",
  );
  final TextEditingController _genderController = TextEditingController(
    text: "Male",
  );
  final TextEditingController _birthdayController = TextEditingController(
    text: "05-01-2001",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "(+880) 1759263000",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "nguyenvana@gmail.com",
  );
  final TextEditingController _usernameController = TextEditingController(
    text: "@nguyenvana",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Chỉnh Sửa Tài Khoản"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar + name
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        "assets/images/homepage/family.jpg",
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // Mở picker chọn ảnh
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Nguyễn Văn A",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("@nguyenvana", style: const TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 24),

            // Input fields
            _buildTextField("Họ và Tên", _nameController),
            Row(
              children: [
                Expanded(
                  child: _buildTextField("Giới tính", _genderController),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField("Ngày sinh", _birthdayController),
                ),
              ],
            ),
            _buildTextField("Số điện thoại", _phoneController),
            _buildTextField("Email", _emailController),
            _buildTextField("Tên người dùng", _usernameController),

            const SizedBox(height: 30),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_button,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Lưu thông tin
                },
                child: const Text(
                  "Lưu thông tin",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
