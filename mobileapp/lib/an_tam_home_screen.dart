import 'package:flutter/material.dart';
import '../feature_list_widget.dart';

class AnTamHomeScreen extends StatelessWidget {
  const AnTamHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenWidth = constraints.maxWidth;
          // Sử dụng SingleChildScrollView để tránh lỗi tràn màn hình (overflow)
          return SingleChildScrollView(
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, 0.00),
                  end: Alignment(1.00, 1.00),
                  colors: [const Color(0xFFEEF5FE), const Color(0xFFF0FDF4)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 64),
                    _buildHeader(),
                    SizedBox(height: 48),
                    _buildAnTamConCard(context, screenWidth),
                    SizedBox(height: 48),
                    _buildAnTamChaMeCard(context, screenWidth),
                    SizedBox(height: 48),
                    _buildFooter(),
                    SizedBox(height: 64),
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Hệ thống An Tâm',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF155CFB),
            fontSize: 24,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 328,
          child: Text(
            'Kết nối yêu thương giữa con cái và cha mẹ lớn tuổi. Giúp người con an tâm khi ở xa, giúp cha mẹ độc lập và được chăm sóc tốt hơn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF495565),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.50,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, 8),
            spreadRadius: -6,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, 20),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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
              child: Center(child: Icon(Icons.favorite_border, color: const Color(0xFF155CFB))),
            ),
            SizedBox(height: 24),
            Text(
              'An Tâm - Con',
              style: TextStyle(
                color: const Color(0xFF1347E5),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Dành cho người chăm sóc. Lên lịch, theo dõi và nhận cảnh báo về tình trạng cha mẹ.',
              style: TextStyle(
                color: const Color(0xFF495565),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            SizedBox(height: 24),
            FeatureListWidget(
              features: [
                'Tạo lịch uống thuốc & lịch hẹn',
                'Dashboard theo dõi trạng thái',
                'Nhận cảnh báo & thông báo SOS',
                'Chia sẻ ảnh gia đình',
              ],
              checkColor: const Color(0xFF2B7FFF),
            ),
            SizedBox(height: 48),
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
                child: Center(
                  child: Text(
                    'Mở ứng dụng "Con"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnTamChaMeCard(BuildContext context, double screenWidth) {
    final double cardWidth = screenWidth > 600 ? 500 : screenWidth - 32;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, 8),
            spreadRadius: -6,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, 20),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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
              child: Center(child: Icon(Icons.healing, color: const Color(0xFF008235))),
            ),
            SizedBox(height: 24),
            Text(
              'An Tâm - Cha Mẹ',
              style: TextStyle(
                color: const Color(0xFF008235),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Dành cho người cao tuổi. Giao diện cực kỳ đơn giản với các nút bấm lớn, dễ sử dụng.',
              style: TextStyle(
                color: const Color(0xFF495565),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            SizedBox(height: 24),
            FeatureListWidget(
              features: [
                'Nút SOS khẩn cấp',
                'Check-in đơn giản khi uống thuốc',
                'Gọi con khi cần',
                'Xem ảnh gia đình',
              ],
              checkColor: const Color(0xFF00C850),
            ),
            SizedBox(height: 48),
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
                child: Center(
                  child: Text(
                    'Mở ứng dụng "Cha Mẹ"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          '💙 Xây dựng cầu nối yêu thương, mang lại sự an tâm cho gia đình Việt',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF697282),
            fontSize: 16,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ),
    );
  }
}