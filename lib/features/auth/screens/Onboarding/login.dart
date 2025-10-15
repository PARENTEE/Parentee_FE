import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/models/api_response.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/login-successfully.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/register.dart';
import 'package:parentee_fe/services/api_service.dart';
import 'package:parentee_fe/services/api_service_dio.dart';
import 'package:parentee_fe/services/auth_service.dart';
import 'package:parentee_fe/services/popup_toast_service.dart';
import 'package:parentee_fe/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 700;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.all(isSmall ? 16 : 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isSmall ? 10 : 10),

                /// Tiêu đề
                Text(
                  "Đăng Nhập",
                  style: TextStyle(
                    fontSize: isSmall ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: isSmall ? 8 : 12),

                /// Hình động Lottie
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
                      padding: EdgeInsets.symmetric(
                        vertical: isSmall ? 12 : 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                    label: Text(
                      "Đăng nhập với Google",
                      style: TextStyle(fontSize: isSmall ? 14 : 16),
                    ),
                    onPressed: () async {
                      await _runLoginProcess(AuthService.signInWithGoogle);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// Divider "hoặc"
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

                Text(
                  "Sử dụng email và mật khẩu để tiếp tục",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),

                const SizedBox(height: 16),

                /// Email input
                TextFormField(
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
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập email";
                    }
                    final emailRegex = RegExp(
                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                    ); // regex email
                    if (!emailRegex.hasMatch(value)) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// Password input
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(fontSize: isSmall ? 14 : 16),
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    hintText: "Tối thiểu 8 ký tự",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isSmall ? 10 : 14,
                    ),
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    if (value.length < 8) {
                      return "Mật khẩu phải từ 8 ký tự";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                /// Nút Đăng nhập
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary_button,
                      padding: EdgeInsets.symmetric(
                        vertical: isSmall ? 12 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        // Run Login process
                        await _runLoginProcess(
                            () => ApiServiceDio.login(email, password));
                      }
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
      ),
    );
  }

  Future<void> _runLoginProcess(
      Future<ApiResponse> Function() apiAction) async {
    // show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await apiAction(); // await the passed function

      if (result.success) {
        final token = result.data;

        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        // Fetch and save user info
        await SharedPreferencesService.fetchAndSaveUser(token);

        Navigator.pop(context); // remove loading

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginSuccessfullyPage()),
        );
      } else {
        PopUpToastService.showErrorToast(context, result.message.toString());
        Navigator.pop(context); // remove loading
      }
    } catch (e) {
      Navigator.pop(context); // ensure dialog is closed
      PopUpToastService.showErrorToast(context, '$e');
    }
  }
}
