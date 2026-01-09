import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
 // Bắt buộc để dùng Firebase

// --- IMPORT ĐÚNG ĐƯỜNG DẪN (Thêm 'features/' vào trước) ---
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/child_dashboard/screens/an_tam_con_dashboard.dart';
import 'features/parent_home/screens/parent_home_screen.dart';

// Nếu bạn đã chạy "flutterfire configure", hãy bỏ comment dòng dưới:
 import 'firebase_options.dart'; 

void main() async {
  // 1. Đảm bảo Flutter Binding đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Firebase (QUAN TRỌNG ĐỂ TRÁNH LỖI MÀN HÌNH ĐỎ)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Kết nối Firebase thành công!");
  } catch (e) {
    print("❌ Lỗi khởi tạo Firebase: $e");
  }

  // 3. Chạy ứng dụng
  runApp(const AnTamApp());
}

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
        useMaterial3: true, // Giao diện hiện đại hơn
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF155DFC)),
      ),
      
      // Màn hình đầu tiên khi mở App
      initialRoute: '/',
      
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
        '/child_home': (context) => const AnTamConDashboard(),
        '/parent_home': (context) => const ParentHomeScreen(),
      },
    );
  }
}