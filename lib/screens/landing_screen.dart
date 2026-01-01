import 'package:flutter/material.dart';
import '../widgets/feature_list_widget.dart'; // Import đúng đường dẫn widget

class AnTamHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenWidth = constraints.maxWidth;
          return SingleChildScrollView(
            child: Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, 0.00),
                  end: Alignment(1.00, 1.00),
                  colors: [Color(0xFFEEF5FE), Color(0xFFF0FDF4)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 64),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildAnTamConCard(context, screenWidth),
                    const SizedBox(height: 48),
                    _buildAnTamChaMeCard(context, screenWidth),
                    const SizedBox(height: 48),
                    _buildFooter(),
                    const SizedBox(height: 64),
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
        Text(
          'Hệ thống An Tâm',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF155CFB),
            fontSize: 24,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 328,
          child: Text(
            'Kết nối yêu thương giữa con cái và cha mẹ lớn tuổi. Giúp người con an tâm khi ở xa, giúp cha mẹ độc lập và được chăm sóc tốt hơn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF495565),
              fontSize: 16,
              fontFamily: 'Arimo',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnTamConCard(BuildContext context, double screenWidth) {
    final double cardWidth = screenWidth > 600 ? 500 : screenWidth - 32;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Icon(Icons.favorite_border, color: Color(0xFF155CFB))),
          ),
          const SizedBox(height: 24),
          const Text(
            'An Tâm - Con',
            style: TextStyle(
              color: Color(0xFF1347E5),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arimo',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dành cho người chăm sóc. Lên lịch, theo dõi và nhận cảnh báo về tình trạng cha mẹ.',
            style: TextStyle(color: Color(0xFF495565), fontSize: 16, fontFamily: 'Arimo'),
          ),
          const SizedBox(height: 24),
          const FeatureListWidget(
            features: [
              'Tạo lịch uống thuốc & lịch hẹn',
              'Dashboard theo dõi trạng thái',
              'Nhận cảnh báo & thông báo SOS',
              'Chia sẻ ảnh gia đình',
            ],
            checkColor: Color(0xFF2B7FFF),
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/con-dashboard');
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF155DFC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Mở ứng dụng "Con"',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnTamChaMeCard(BuildContext context, double screenWidth) {
    final double cardWidth = screenWidth > 600 ? 500 : screenWidth - 32;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Icon(Icons.healing, color: Color(0xFF008235))),
          ),
          const SizedBox(height: 24),
          const Text(
            'An Tâm - Cha Mẹ',
            style: TextStyle(
              color: Color(0xFF008235),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arimo',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dành cho người cao tuổi. Giao diện cực kỳ đơn giản với các nút bấm lớn.',
            style: TextStyle(color: Color(0xFF495565), fontSize: 16, fontFamily: 'Arimo'),
          ),
          const SizedBox(height: 24),
          const FeatureListWidget(
            features: [
              'Nút SOS khẩn cấp',
              'Check-in đơn giản khi uống thuốc',
              'Gọi con khi cần',
              'Xem ảnh gia đình',
            ],
            checkColor: Color(0xFF00C850),
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/chame-dashboard');
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF00A63E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Mở ứng dụng "Cha Mẹ"',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          '💙 Xây dựng cầu nối yêu thương, mang lại sự an tâm cho gia đình Việt',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF697282), fontSize: 16, fontFamily: 'Arimo'),
        ),
      ),
    );
  }
}