import 'package:flutter/material.dart';
import 'elder/elder_screen.dart';
import 'elder/carer/carer_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF5FE), Color(0xFFF0FDF4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.family_restroom, size: 80, color: Color(0xFF155CFB)),
              const SizedBox(height: 20),
              const Text('Bạn là ai?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              _buildButton(context, 'Cha Mẹ (Người cao tuổi)', const ElderScreen(), Colors.green),
              const SizedBox(height: 20),
              _buildButton(context, 'Con (Người chăm sóc)', const CarerDashboardScreen(), Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget screen, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}