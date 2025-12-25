import 'package:flutter/material.dart';
import 'an_tam_home_screen.dart';
import 'an_tam_con_dashboard.dart';
import 'an_tam_cha_me_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống An Tâm',
      theme: ThemeData(
        // Thiết lập Font chữ từ code gốc
        fontFamily: 'Arimo',
        primaryColor: const Color(0xFF155DFC),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnTamHomeScreen(),
      routes: {
        '/con-dashboard': (context) => AnTamConDashboard(),
        '/chame-dashboard': (context) => AnTamChaMeDashboard(),
      },
    );
  }
}