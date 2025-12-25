import 'package:flutter/material.dart';

class AnTamChaMeDashboard extends StatelessWidget {
  const AnTamChaMeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'An Tâm - Cha Mẹ',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A63E), // Màu xanh lá cây
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Đây là giao diện đơn giản dành cho người cao tuổi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: const Color(0xFF495565)),
              ),
              SizedBox(height: 20),
              // Mô phỏng nút SOS khẩn cấp
              ElevatedButton.icon(
                onPressed: () {
                  // Logic gọi khẩn cấp (Placeholder)
                },
                icon: Icon(Icons.warning, color: Colors.white, size: 30),
                label: Text('Nút SOS Khẩn Cấp', style: TextStyle(fontSize: 20, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Giao diện với các nút bấm lớn, dễ sử dụng.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}