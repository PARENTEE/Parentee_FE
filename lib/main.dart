import 'package:flutter/material.dart';
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
        fontFamily: "Roboto",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Trang khởi động là OnboardingPage
      home: const OnboardingPage(),

      routes: {"/home": (context) => const HomePage()},
    );
  }
}
