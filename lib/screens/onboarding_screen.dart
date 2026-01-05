import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
            colors: [Color(0xFFEEF5FE), Color(0xFFF0FDF4)], // Màu nền gradient gốc
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 40),
                
                // Card An Tâm - Con (Màu Xanh Dương)
                _buildRoleCard(
                  context,
                  title: 'An Tâm - Con',
                  subtitle: 'Dành cho người chăm sóc. Lên lịch, theo dõi và nhận cảnh báo.',
                  iconData: Icons.favorite_border,
                  themeColor: const Color(0xFF155DFC), // Xanh dương
                  features: [
                    'Tạo lịch uống thuốc & lịch hẹn',
                    'Dashboard theo dõi trạng thái',
                    'Nhận cảnh báo & thông báo SOS',
                    'Chia sẻ ảnh gia đình',
                  ],
                  buttonLabel: 'Mở ứng dụng "Con"',
                  onTap: () => Navigator.pushNamed(context, '/login'),
                ),

                const SizedBox(height: 30),

                // Card An Tâm - Cha Mẹ (Màu Xanh Lá)
                _buildRoleCard(
                  context,
                  title: 'An Tâm - Cha Mẹ',
                  subtitle: 'Dành cho người cao tuổi. Giao diện đơn giản, nút bấm lớn.',
                  iconData: Icons.volunteer_activism, // Icon trái tim trên tay (giống healing)
                  themeColor: const Color(0xFF00A63E), // Xanh lá
                  features: [
                    'Nút SOS khẩn cấp',
                    'Check-in đơn giản khi uống thuốc',
                    'Gọi con khi cần',
                    'Xem ảnh gia đình',
                  ],
                  buttonLabel: 'Mở ứng dụng "Cha Mẹ"',
                  onTap: () => Navigator.pushNamed(context, '/parent_home'),
                ),

                const SizedBox(height: 40),
                _buildFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Header: Logo và Tiêu đề ---
  Widget _buildHeader() {
    return Column(
      children: const [
        // Logo giả lập (Icon trong khung bo tròn)
        CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFF00A63E),
          child: Icon(Icons.security, color: Colors.white, size: 30),
        ),
        SizedBox(height: 16),
        Text(
          'Hệ thống An Tâm',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF155CFB),
            fontFamily: 'Arimo',
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Kết nối yêu thương giữa con cái và cha mẹ lớn tuổi.\nGiúp người con an tâm, giúp cha mẹ được quan tâm.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF495565),
            fontFamily: 'Arimo',
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // --- Widget Card Vai Trò (Dùng chung cho cả Con và Cha Mẹ) ---
  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData iconData,
    required Color themeColor,
    required List<String> features,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Icon đại diện
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(iconData, color: themeColor, size: 32),
          ),
          const SizedBox(height: 16),
          // Tiêu đề
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: themeColor,
              fontFamily: 'Arimo',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF495565),
              fontFamily: 'Arimo',
            ),
          ),
          const SizedBox(height: 20),
          // Danh sách tính năng
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 20, color: themeColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF354152),
                          fontFamily: 'Arimo',
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),
          // Nút bấm
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Arimo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Footer ---
  Widget _buildFooter() {
    return const Text(
      '💙 Xây dựng cầu nối yêu thương, mang lại sự an tâm cho gia đình Việt',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: Color(0xFF697282),
        fontFamily: 'Arimo',
        fontStyle: FontStyle.italic,
      ),
    );
  }
}