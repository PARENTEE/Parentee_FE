import 'package:flutter/material.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/home_page.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/onboarding-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Onboarding Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary_button,
        ).copyWith(background: Colors.white, surface: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // Trang khởi động là OnboardingPage
      home: const OnboardingPage(),

      routes: {"/home": (context) => const HomePage()},
    );
  }
}
