// file: home.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng LayoutBuilder để tính toán kích thước an toàn
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0FDF4), Color(0xFFEEF5FE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _Header(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _Banner(),
                      const SizedBox(height: 24),
                      _ActionSection(),
                      const SizedBox(height: 24),
                      _Footer(),
                      const SizedBox(height: 24), // Padding dưới cùng
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HEADER =================
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF00A63E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Back để quay lại màn hình chọn vai trò
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'An Tâm - Cha Mẹ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arimo',
            ),
          ),
          const Icon(Icons.settings, color: Colors.white),
        ],
      ),
    );
  }
}

// ================= BANNER =================
class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Giới hạn chiều cao banner để không chiếm hết màn hình
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://placehold.co/600x400', // Đổi tỉ lệ ảnh ngang cho dễ nhìn hơn
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.black.withOpacity(0.5),
              child: const Text(
                'Ảnh gia đình sum họp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Arimo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= ACTION SECTION =================
class _ActionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: const [
          _ActionCard(
            color: Color(0xFFE7000B), // Đỏ
            icon: Icons
                .warning_amber_rounded, // Dùng Icon chuẩn Flutter thay vì Text emoji
            title: 'KHẨN CẤP',
            subtitle: 'Bấm khi gặp nguy hiểm',
          ),
          SizedBox(height: 16),
          _ActionCard(
            color: Color(0xFF00C850), // Xanh lá
            icon: Icons.check_circle_outline,
            title: 'ĐÃ UỐNG THUỐC',
            subtitle: 'Bấm sau khi uống thuốc',
          ),
          SizedBox(height: 16),
          _ActionCard(
            color: Color(0xFF155DFC), // Xanh dương
            icon: Icons.phone_in_talk,
            title: 'GỌI CON',
            subtitle: 'Con sẽ gọi lại khi rảnh',
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActionCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      elevation: 8,
      child: InkWell(
        onTap: () {
          // Xử lý sự kiện bấm nút ở đây
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Đã chọn: $title')));
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Icon(icon, size: 64, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32, // Giảm size chữ một chút để không bị tràn
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arimo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontFamily: 'Arimo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= FOOTER =================
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: const [
          Text(
            '08:04',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101727),
              fontFamily: 'Arimo',
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Thứ Tư, 17 tháng 12',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF495565),
              fontFamily: 'Arimo',
            ),
          ),
        ],
      ),
    );
  }
}
