import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/home_page.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/onboarding-page.dart';
import 'package:parentee_fe/features/auth/wrapper/auth_wrapper.dart';
import 'package:parentee_fe/services/api_service_dio.dart';

void main() async {
  // 1. Must be the very first call in main()
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize the Dio Singleton
  ApiServiceDio.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parentee',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary_button,
        ).copyWith(background: Colors.white, surface: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
        // textTheme: GoogleFonts.nunitoSansTextTheme(),
      ),
      // Trang khởi động là OnboardingPage
      home: const AuthWrapper(),

      routes: {"/home": (context) => const HomePage()},
    );
  }
}
