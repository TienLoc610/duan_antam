import 'package:flutter/material.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  // 1. Hàm hiển thị thông báo (SnackBar) ở dưới màn hình
  void _showNotification(BuildContext context, String message, Color bgColor) {
    ScaffoldMessenger.of(context).clearSnackBars(); // Xóa thông báo cũ nếu có
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2), // Hiện trong 2 giây
        behavior: SnackBarBehavior.floating, // Nổi lên trên
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'An Tâm - Cha Mẹ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A63E),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2, // 2 cột
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          // 2. Truyền hành động cụ thể cho từng nút
          _bigButton(
            context,
            icon: Icons.phone_forwarded,
            label: 'SOS',
            color: Colors.red,
            onTap: () => _showNotification(
              context,
              'Đã gửi tín hiệu KHẨN CẤP!',
              Colors.red,
            ),
          ),
          _bigButton(
            context,
            icon: Icons.medication,
            label: 'Uống thuốc',
            color: Colors.blue,
            onTap: () => _showNotification(
              context,
              'Đã xác nhận uống thuốc',
              Colors.green,
            ),
          ),
          _bigButton(
            context,
            icon: Icons.call,
            label: 'Gọi con',
            color: Colors.green,
            onTap: () => _showNotification(
              context,
              'Đang gọi cho con...',
              const Color(0xFF00A63E),
            ),
          ),
          _bigButton(
            context,
            icon: Icons.photo_album,
            label: 'Xem ảnh',
            color: Colors.orange,
            onTap: () => _showNotification(
              context,
              'Đang mở album ảnh...',
              Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Cập nhật Widget nút bấm để nhận sự kiện chạm (InkWell)
  Widget _bigButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap, // Thêm tham số nhận hành động
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      elevation: 5, // Thêm độ nổi cho nút đẹp hơn
      child: InkWell(
        onTap: onTap, // Gắn hành động vào đây
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withOpacity(0.3), // Hiệu ứng gợn sóng khi bấm
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18, // Tăng kích thước chữ cho dễ đọc
              ),
            ),
          ],
        ),
      ),
    );
  }
}
