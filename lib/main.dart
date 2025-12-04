import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parentee_fe/app/theme/app_colors.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/home_page.dart';
import 'package:parentee_fe/features/auth/screens/Onboarding/onboarding-page.dart';
import 'package:parentee_fe/features/auth/wrapper/auth_wrapper.dart';
import 'package:parentee_fe/services/api_service_dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parentee_fe/services/chat_service.dart';

void main() async {
  // 1. Must be the very first call in main()
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // 2. Initialize the Dio Singleton
  ApiServiceDio.initialize();
  ChatService.init();

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'), // Tiếng Việt
        Locale('en', 'US'), // Tiếng Anh
      ],
      locale: const Locale('vi', 'VN'),

      routes: {"/home": (context) => const HomePage()},
    );
  }
}
