import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/landing_screen.dart'; // Đổi tên file an_tam_home_screen thành landing_screen cho chuẩn
import 'screens/elder/elder_screen.dart'; // Màn hình Cha Mẹ
import 'screens/carer/carer_screen.dart'; // Màn hình Con

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- XỬ LÝ LỖI MÀN HÌNH TRẮNG DO FIREBASE ---
  try {
    await Firebase.initializeApp();
    print("----- KẾT NỐI FIREBASE THÀNH CÔNG -----");
  } catch (e) {
    print("----- LỖI FIREBASE (ĐANG CHẠY CHẾ ĐỘ OFFLINE UI) -----");
    print(e);
  }

  runApp(const AnTamApp());
}

class AnTamApp extends StatelessWidget {
  const AnTamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hệ thống An Tâm',
      theme: ThemeData(
        fontFamily: 'Arimo',
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      // Màn hình đầu tiên là màn hình giới thiệu
      home: AnTamHomeScreen(), 
      
      // Định nghĩa các đường dẫn để chuyển màn hình
      routes: {
        '/landing': (context) => AnTamHomeScreen(),
        '/chame-dashboard': (context) => const ElderScreen(),
        '/con-dashboard': (context) => const CarerDashboardScreen(),
      },
    );
  }
}