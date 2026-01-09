import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Thư viện slideshow
import 'package:cached_network_image/cached_network_image.dart'; // Thư viện ảnh cache
import 'package:url_launcher/url_launcher.dart'; // Để gọi điện thoại

// Đảm bảo đường dẫn import này đúng với cấu trúc thư mục của bạn
import '../../../services/firebase_service.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  
  // Hàm hiển thị thông báo nhỏ
  void _showNotification(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message, 
          textAlign: TextAlign.center, 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arimo')
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Xử lý gửi SOS
  Future<void> _handleSOS() async {
    try {
      await FirebaseService.sendSOS();
      _showNotification('ĐÃ GỬI BÁO ĐỘNG SOS KHẨN CẤP!', Colors.red);
    } catch (e) {
      _showNotification('Lỗi kết nối! Hãy gọi điện trực tiếp.', Colors.grey);
    }
  }

  // Xử lý gọi điện
  Future<void> _handleCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '0909123456'); // Thay số con cái vào đây
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      _showNotification('Không thể thực hiện cuộc gọi', Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nền Gradient dịu mắt
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0FDF4), Color(0xFFEEF5FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(), // Thanh tiêu đề
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSlideshow(), // <--- SLIDESHOW ẢNH GIA ĐÌNH
                    
                    const SizedBox(height: 24),
                    
                    // Nút SOS khẩn cấp
                    _ActionCard(
                      title: 'KHẨN CẤP',
                      subtitle: 'Bấm khi gặp nguy hiểm',
                      iconText: '🚨',
                      color: const Color(0xFFE7000B),
                      onTap: _handleSOS,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Nút xác nhận uống thuốc
                    _ActionCard(
                      title: 'ĐÃ UỐNG THUỐC',
                      subtitle: 'Bấm sau khi uống thuốc',
                      iconText: '💊',
                      color: const Color(0xFF00C850),
                      onTap: () => _showNotification('Đã ghi nhận ông/bà uống thuốc!', Colors.green),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Nút gọi điện nhanh
                    _ActionCard(
                      title: 'GỌI CON',
                      subtitle: 'Con sẽ nghe máy ngay',
                      iconText: '📞',
                      color: const Color(0xFF155DFC),
                      onTap: _handleCall,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Đồng hồ thời gian thực
                    const _RealTimeClock(),
                    
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

  // --- WIDGET HEADER ---
  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF00A63E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút về trang chủ (hoặc thoát)
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const Text(
            'An Tâm - Cha Mẹ',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Arimo'),
          ),
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(Icons.person, color: Color(0xFF00A63E)),
          ),
        ],
      ),
    );
  }

  // --- WIDGET SLIDESHOW (REAL-TIME TỪ FIREBASE) ---
  Widget _buildSlideshow() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getPhotosStream(),
      builder: (context, snapshot) {
        // 1. Trường hợp chưa có ảnh hoặc đang tải
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text("Đang chờ con tải ảnh...", style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Arimo')),
              ],
            ),
          );
        }

        var photos = snapshot.data!.docs;

        // 2. Trường hợp có ảnh -> Hiển thị Carousel
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CarouselSlider.builder(
              itemCount: photos.length,
              itemBuilder: (context, index, realIndex) {
                return CachedNetworkImage(
                  imageUrl: photos[index]['url'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200], 
                    child: const Center(child: CircularProgressIndicator())
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
              options: CarouselOptions(
                height: 220,
                autoPlay: true, // Tự động chạy
                autoPlayInterval: const Duration(seconds: 5), // 5 giây đổi ảnh
                viewportFraction: 1.0, // Full chiều ngang
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- WIDGET NÚT BẤM LỚN (Action Card) ---
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
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            children: [
              // Icon Emoji/Text bên trái
              Container(
                width: 70, height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(iconText, style: const TextStyle(fontSize: 36)),
              ),
              const SizedBox(width: 16),
              // Text bên phải
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arimo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'Arimo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET ĐỒNG HỒ THỜI GIAN THỰC ---
class _RealTimeClock extends StatefulWidget {
  const _RealTimeClock();

  @override
  State<_RealTimeClock> createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<_RealTimeClock> {
  String _timeString = "";
  String _dateString = "";
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
        // Hiển thị Thứ và Ngày tháng (VD: Thứ Hai, 10 Tháng 10)
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
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101727),
            fontFamily: 'Arimo',
            letterSpacing: 2.0,
            height: 1.0,
          ),
        ),
        Text(
          _dateString,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF495565),
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}