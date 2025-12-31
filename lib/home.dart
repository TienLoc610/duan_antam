// file: home.dart
import 'dart:async'; // Dùng cho đồng hồ đếm giờ
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Dùng để format ngày giờ
import 'package:url_launcher/url_launcher.dart'; // Dùng để gọi điện

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến trạng thái: Đã uống thuốc chưa?
  bool _hasTakenMedicine = false;

  // Hàm xử lý gọi điện
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchLaunchUrl(launchUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thực hiện cuộc gọi')),
      );
    }
  }

  // Hàm xử lý sự kiện bấm nút
  void _handleButtonPress(String actionType) {
    if (actionType == 'SOS') {
      // Logic khẩn cấp (có thể mở gọi 113 hoặc gửi tin nhắn)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi cảnh báo SOS đến các con!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } else if (actionType == 'MEDICINE') {
      setState(() {
        _hasTakenMedicine = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tuyệt vời! Đã ghi nhận ông/bà đã uống thuốc.')),
      );
    } else if (actionType == 'CALL') {
      // Gọi đến số điện thoại con (ví dụ demo)
      _makePhoneCall('0909123456'); 
    }
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
              _Header(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _Banner(),
                      const SizedBox(height: 24),
                      // Truyền hàm xử lý và trạng thái xuống ActionSection
                      _ActionSection(
                        onPress: _handleButtonPress,
                        isMedicineTaken: _hasTakenMedicine,
                      ),
                      const SizedBox(height: 24),
                      const _RealTimeClock(), // Widget đồng hồ chạy thật
                      const SizedBox(height: 24),
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

// ================= HEADER (Giữ nguyên) =================
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

// ================= BANNER (Giữ nguyên) =================
class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Giảm chiều cao chút cho cân đối
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://placehold.co/600x400',
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

// ================= ACTION SECTION (Cập nhật Logic) =================
class _ActionSection extends StatelessWidget {
  final Function(String) onPress;
  final bool isMedicineTaken;

  const _ActionSection({
    required this.onPress,
    required this.isMedicineTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _ActionCard(
            color: const Color(0xFFE7000B),
            icon: Icons.warning_amber_rounded,
            title: 'KHẨN CẤP',
            subtitle: 'Bấm khi gặp nguy hiểm',
            onTap: () => onPress('SOS'),
          ),
          const SizedBox(height: 16),
          // Logic thay đổi giao diện nút uống thuốc
          _ActionCard(
            color: isMedicineTaken ? Colors.grey : const Color(0xFF00C850),
            icon: isMedicineTaken ? Icons.check : Icons.check_circle_outline,
            title: isMedicineTaken ? 'ĐÃ UỐNG XONG' : 'UỐNG THUỐC',
            subtitle: isMedicineTaken
                ? 'Hôm nay ông/bà đã uống rồi'
                : 'Bấm sau khi uống thuốc',
            onTap: isMedicineTaken ? null : () => onPress('MEDICINE'),
          ),
          const SizedBox(height: 16),
          _ActionCard(
            color: const Color(0xFF155DFC),
            icon: Icons.phone_in_talk,
            title: 'GỌI CON',
            subtitle: 'Bấm để gọi ngay cho con',
            onTap: () => onPress('CALL'),
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
  final VoidCallback? onTap; // Thêm callback

  const _ActionCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      elevation: onTap == null ? 0 : 8, // Bỏ bóng đổ nếu nút bị disable
      child: InkWell(
        onTap: onTap,
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
                  fontSize: 28,
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
                  fontSize: 16,
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

// ================= REAL-TIME CLOCK (Widget Mới) =================
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
    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    
    // Cập nhật đồng hồ mỗi giây
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy timer khi thoát màn hình để tránh lỗi
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);
    final String formattedDate = _formatDate(now);
    
    // Chỉ cập nhật UI nếu thời gian thay đổi (tối ưu hiệu năng)
    if (mounted && (_timeString != formattedTime || _dateString != formattedDate)) {
      setState(() {
        _timeString = formattedTime;
        _dateString = formattedDate;
      });
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time); // Ví dụ: 14:30
  }

  String _formatDate(DateTime time) {
    // Định dạng kiểu: Thứ Tư, 17 tháng 12
    return DateFormat('EEEE, d MMMM', 'vi').format(time); 
    // Lưu ý: Cần setup locale tiếng Việt trong main.dart nếu muốn tiếng Việt chuẩn
    // Tạm thời dùng tiếng Anh hoặc setup GlobalMaterialLocalizations
  }

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
          const SizedBox(height: 4),
          Text(
            _dateString, // Hiện tại sẽ hiển thị tiếng Anh nếu chưa config Locale
            style: const TextStyle(
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

// Lưu ý: Hàm launchLaunchUrl là hàm giả lập do phiên bản url_launcher mới có chút thay đổi.
// Trong thực tế bạn chỉ cần gọi launchUrl(uri).
Future<void> launchLaunchUrl(Uri url) async {
    await launchUrl(url);
}
