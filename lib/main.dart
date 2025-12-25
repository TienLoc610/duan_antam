// file: main.dart
import 'package:flutter/material.dart';
import 'an_tam_home_screen.dart';
import 'home.dart'; // Đây là màn hình Cha Mẹ bản Responsive

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'An Tâm',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Arimo', // Đảm bảo bạn đã khai báo font trong pubspec.yaml
      ),
      // Màn hình khởi động là màn hình chọn vai trò
      initialRoute: '/',
      routes: {
        '/': (context) => AnTamHomeScreen(),
        '/chame-dashboard': (context) => const HomeScreen(), // Dùng bản home.dart responsive
        '/con-dashboard': (context) => const ConDashboardPlaceholder(), // Màn hình tạm cho con
      },
    );
  }
}

// Màn hình tạm thời cho bên Con (để test nút bấm)
class ConDashboardPlaceholder extends StatelessWidget {
  const ConDashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giao diện Con"), backgroundColor: const Color(0xFF155DFC)),
      body: const Center(child: Text("Dashboard dành cho người chăm sóc đang phát triển")),
    );
  }
}