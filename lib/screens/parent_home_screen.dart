import 'dart:async'; // Dùng cho đồng hồ
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Cần thêm intl vào pubspec.yaml để format ngày

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  // Hàm hiển thị thông báo
  void _showNotification(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildBanner(),
                    const SizedBox(height: 24),
                    // Nút SOS màu Đỏ
                    _ActionCard(
                      title: 'KHẨN CẤP',
                      subtitle: 'Bấm khi gặp nguy hiểm',
                      iconText: '🚨',
                      color: const Color(0xFFE7000B),
                      onTap: () => _showNotification('Đã gửi báo động SOS!', Colors.red),
                    ),
                    const SizedBox(height: 24),
                    // Nút Uống Thuốc màu Xanh Lá
                    _ActionCard(
                      title: 'ĐÃ UỐNG THUỐC',
                      subtitle: 'Bấm sau khi uống thuốc',
                      iconText: '✓',
                      color: const Color(0xFF00C850),
                      onTap: () => _showNotification('Đã ghi nhận uống thuốc!', Colors.green),
                    ),
                    const SizedBox(height: 24),
                    // Nút Gọi Con màu Xanh Dương
                    _ActionCard(
                      title: 'GỌI CON',
                      subtitle: 'Con sẽ gọi lại khi rảnh',
                      iconText: '📞',
                      color: const Color(0xFF155DFC),
                      onTap: () => _showNotification('Đang gọi cho con...', Colors.blue),
                    ),
                    const SizedBox(height: 40),
                    const _RealTimeClock(), // Đồng hồ ở cuối
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF00A63E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon Menu giả lập
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.grid_view, color: Colors.white),
          ),
          const Text(
            'An Tâm - Cha Mẹ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arimo',
            ),
          ),
          // Avatar giả lập
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(Icons.person, color: Color(0xFF00A63E)),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://placehold.co/600x400'), // Thay bằng link ảnh thật
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Bà và cháu',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '2 / 3',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Card Nút Bấm Lớn (Tái sử dụng)
class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconText;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.iconText,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      elevation: 8,
      shadowColor: color.withOpacity(0.5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                iconText,
                style: const TextStyle(fontSize: 64, height: 1), // Icon dạng Text/Emoji
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arimo',
                ),
              ),
              const SizedBox(height: 8),
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

// Widget Đồng Hồ Thời Gian Thực
class _RealTimeClock extends StatefulWidget {
  const _RealTimeClock();

  @override
  State<_RealTimeClock> createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<_RealTimeClock> {
  late String _timeString;
  late String _dateString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = DateFormat('HH:mm').format(now);
        // Định dạng ngày tháng tiếng Việt (Cần cấu hình locale hoặc dùng tạm tiếng Anh/chuỗi cứng)
        _dateString = DateFormat('EEEE, d MMMM').format(now); 
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _timeString,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101727),
            fontFamily: 'Arimo',
          ),
        ),
        Text(
          _dateString,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF495565),
            fontFamily: 'Arimo',
          ),
        ),
      ],
    );
  }
}