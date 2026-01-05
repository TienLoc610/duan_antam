import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEEF5FE), Color(0xFFF0FDF4)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hệ thống An Tâm', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF155CFB))),
            const SizedBox(height: 48),
            _buildCard(context, 'An Tâm - Con', 'Quản lý sức khỏe cha mẹ', const Color(0xFF1347E5), '/login'),
            const SizedBox(height: 20),
            _buildCard(context, 'An Tâm - Cha Mẹ', 'Dễ sử dụng cho người già', const Color(0xFF008235), '/parent_home'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String desc, Color color, String route) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(desc, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, route);
            },
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: const Text('Mở ứng dụng', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}