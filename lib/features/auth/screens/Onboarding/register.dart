import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;

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

              Text(
                "Đăng ký tài khoản",
                style: TextStyle(
                  fontSize: isSmall ? 20 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isSmall ? 8 : 12),

              Lottie.asset(
                "assets/lottie/register.json",
                height: isSmall ? 180 : 240,
              ),

              SizedBox(height: isSmall ? 8 : 12),
              Text(
                "Tạo tài khoản để sử dụng dịch vụ.",
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: isSmall ? 16 : 24),

              // Email
              _buildTextField("Email", "example@email.com", isSmall: isSmall),
              SizedBox(height: isSmall ? 12 : 16),

              // Username
              _buildTextField("Tên đăng nhập", "example", isSmall: isSmall),
              SizedBox(height: isSmall ? 12 : 16),

              // Phone
              _buildTextField(
                "Số điện thoại",
                "0123456789",
                isSmall: isSmall,
                keyboard: TextInputType.phone,
              ),
              SizedBox(height: isSmall ? 12 : 16),

              // Password
              TextField(
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
                  onPressed: () {
                    // TODO: xử lý logic đăng ký
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
  }) {
    return TextField(
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
