import 'package:flutter/material.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/home_page.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/onboarding-page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    await Future.delayed(const Duration(seconds: 1)); // tạo hiệu ứng loading
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final hasToken = snapshot.data!;
        if (hasToken) {
          return const HomePage();
        } else {
          return const OnboardingPage();
        }
      },
    );
  }
}
