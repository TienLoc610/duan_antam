import 'package:flutter/material.dart';
import '../widgets/feature_list_widget.dart'; // Đảm bảo đường dẫn này đúng với project của bạn

class AnTamHomeScreen extends StatelessWidget {
  const AnTamHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenWidth = constraints.maxWidth;
          
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0FDF4), Color(0xFFEEF5FE)],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildAnTamConCard(context, screenWidth),
                    const SizedBox(height: 30), // Giảm khoảng cách giữa 2 card
                    _buildAnTamChaMeCard(context, screenWidth),
                    const SizedBox(height: 50),
                    _buildFooter(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: const <Widget>[
        // Thêm Icon đại diện cho Logo
        Icon(Icons.family_restroom, size: 80, color: Color(0xFF155CFB)),
        SizedBox(height: 16),
        Text(
          'Hệ thống An Tâm',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF155CFB),
            fontSize: 28, // Tăng kích thước chữ
            fontFamily: 'Arimo',
            fontWeight: FontWeight.bold, // Chữ đậm hơn
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: 350,
          child: Text(
            'Kết nối yêu thương - An tâm phụng dưỡng',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF495565),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnTamConCard(BuildContext context, double screenWidth) {
    // Tự động điều chỉnh độ rộng card, tối đa 500
    final double cardWidth = screenWidth > 600 ? 500 : double.infinity;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // Bo tròn nhiều hơn
        border: Border.all(color: const Color(0xFFDBEAFE), width: 1), // Viền nhẹ
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF155CFB).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 35,
            backgroundColor: Color(0xFFDBEAFE),
            child: Icon(Icons.favorite, color: Color(0xFF155CFB), size: 35),
          ),
          const SizedBox(height: 16),
          const Text(
            'An Tâm - Con',
            style: TextStyle(
              color: Color(0xFF1347E5),
              fontSize: 22,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dành cho người chăm sóc',
            style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Arimo'),
          ),
          const Divider(height: 30, thickness: 1, color: Color(0xFFF1F5F9)),
          const FeatureListWidget(
            features: [
              'Tạo lịch uống thuốc & lịch hẹn',
              'Nhận cảnh báo & thông báo SOS',
              'Chia sẻ ảnh gia đình',
            ],
            checkColor: Color(0xFF2B7FFF),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            context,
            label: 'Mở ứng dụng "Con"',
            color: const Color(0xFF155DFC),
            route: '/con-dashboard',
          ),
        ],
      ),
    );
  }

  Widget _buildAnTamChaMeCard(BuildContext context, double screenWidth) {
    final double cardWidth = screenWidth > 600 ? 500 : double.infinity;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFDCFCE7), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A63E).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 35,
            backgroundColor: Color(0xFFDCFCE7),
            child: Icon(Icons.healing, color: Color(0xFF008235), size: 35),
          ),
          const SizedBox(height: 16),
          const Text(
            'An Tâm - Cha Mẹ',
            style: TextStyle(
              color: Color(0xFF008235),
              fontSize: 22,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dành cho người cao tuổi',
            style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Arimo'),
          ),
          const Divider(height: 30, thickness: 1, color: Color(0xFFF1F5F9)),
          const FeatureListWidget(
            features: [
              'Nút SOS khẩn cấp to rõ',
              'Check-in uống thuốc đơn giản',
              'Xem ảnh con cháu',
            ],
            checkColor: Color(0xFF00C850),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            context,
            label: 'Mở ứng dụng "Cha Mẹ"',
            color: const Color(0xFF00A63E),
            route: '/chame-dashboard', // Route phải khớp với main.dart
          ),
        ],
      ),
    );
  }

  // Widget nút bấm dùng chung để code gọn hơn
  Widget _buildActionButton(BuildContext context, {required String label, required Color color, required String route}) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed(route),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: color.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          '💙 Xây dựng cầu nối yêu thương cho gia đình Việt',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}