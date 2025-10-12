import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/services/api_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';
import 'package:toasty_box/toast_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;

  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 700;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmall ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: isSmall ? 20 : 40),

              // Email
              _buildTextField(
                "Email",
                "example@email.com",
                controller: _emailController,
                isSmall: isSmall,
                keyboard: TextInputType.emailAddress,
              ),
              SizedBox(height: isSmall ? 12 : 16),

              // Full name
              _buildTextField(
                "Họ và Tên",
                "Nguyễn Văn A",
                controller: _nameController,
                isSmall: isSmall,
              ),
              SizedBox(height: isSmall ? 12 : 16),

              // Phone
              _buildTextField(
                "Số điện thoại",
                "0123456789",
                controller: _phoneController,
                isSmall: isSmall,
                keyboard: TextInputType.phone,
              ),
              SizedBox(height: isSmall ? 12 : 16),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(fontSize: isSmall ? 14 : 16),
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isSmall ? 10 : 14,
                  ),
                ),
              ),
              SizedBox(height: isSmall ? 20 : 24),

              // Button Đăng ký
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_button,
                    padding: EdgeInsets.symmetric(vertical: isSmall ? 12 : 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final fullName = _nameController.text.trim();
                    final phone = _phoneController.text.trim();
                    final password = _passwordController.text.trim();

                    // show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (_) =>
                              const Center(child: CircularProgressIndicator()),
                    );

                    final result = await ApiService.register(
                      email,
                      fullName,
                      phone,
                      password,
                    );

                    // remove loading
                    Navigator.pop(context);

                    if (result.success) {
                      PopUpToastService.showSuccessToast(
                        context,
                        'Đăng ký thành công!',
                      );
                      Navigator.pop(context); // Quay lại màn hình đăng nhập
                    } else {
                      PopUpToastService.showErrorToast(
                        context,
                        result.message ?? 'Đăng ký thất bại!',
                      );
                    }
                  },
                  child: Text(
                    "Đăng ký",
                    style: TextStyle(
                      fontSize: isSmall ? 15 : 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmall ? 12 : 16),

              // Đã có tài khoản
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Đã có tài khoản? ",
                    style: TextStyle(fontSize: isSmall ? 13 : 15),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: isSmall ? 13 : 15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmall ? 16 : 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool isSmall = false,
    TextInputType? keyboard,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(fontSize: isSmall ? 14 : 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isSmall ? 10 : 14,
        ),
      ),
    );
  }
}
