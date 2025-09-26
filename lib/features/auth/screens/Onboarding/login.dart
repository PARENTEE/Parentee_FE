import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/login-successfully.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // lấy kích thước màn hình
    final isSmall = size.height < 700; // điện thoại nhỏ

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmall ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: isSmall ? 40 : 60),

              Text(
                "Đăng Nhập",
                style: TextStyle(
                  fontSize: isSmall ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: isSmall ? 8 : 12),
              Lottie.asset(
                "assets/lottie/stork.json",
                height: isSmall ? 180 : 230,
              ),

              Text(
                "Đăng nhập để sử dụng dịch vụ.",
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              /// Nút login Google
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: isSmall ? 12 : 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(FontAwesomeIcons.google, color: Colors.red),
                  label: Text(
                    "Đăng nhập với Google",
                    style: TextStyle(fontSize: isSmall ? 14 : 16),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("hoặc"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),

              const SizedBox(height: 20),

              /// Email input
              TextField(
                controller: _emailController,
                style: TextStyle(fontSize: isSmall ? 14 : 16),
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "example@email.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isSmall ? 10 : 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Password input
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(fontSize: isSmall ? 14 : 16),
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  hintText: "tối thiểu 8 ký tự",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isSmall ? 10 : 14,
                  ),
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
              ),

              const SizedBox(height: 24),

              /// Nút Đăng nhập
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_button,
                    padding: EdgeInsets.symmetric(vertical: isSmall ? 12 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginSuccessfullyPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Đăng nhập",
                    style: TextStyle(
                      fontSize: isSmall ? 16 : 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Link đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Không có tài khoản? ",
                    style: TextStyle(fontSize: isSmall ? 13 : 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Đăng ký ngay",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: isSmall ? 13 : 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
