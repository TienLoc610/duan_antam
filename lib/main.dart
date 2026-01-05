import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/an_tam_con_dashboard.dart';
import 'screens/parent_home_screen.dart'; // Đã bỏ comment

void main() => runApp(const AnTamApp());

class AnTamApp extends StatelessWidget {
  const AnTamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'An Tâm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arimo',
        primaryColor: const Color(0xFF155DFC),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
        '/child_home': (context) => const AnTamConDashboard(),
        '/parent_home': (context) => const ParentHomeScreen(), // Đã kích hoạt route này
      },
    );
  }
}