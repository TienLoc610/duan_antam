import 'dart:async'; // Thư viện xử lý bất đồng bộ (Timer, Future)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện định dạng ngày giờ (DateFormat)
import 'package:intl/date_symbol_data_local.dart'; // Thư viện dữ liệu ngôn ngữ (để hiển thị tiếng Việt)
import 'package:cloud_firestore/cloud_firestore.dart'; // Kết nối cơ sở dữ liệu Firestore
import 'package:carousel_slider/carousel_slider.dart'; // Widget chạy ảnh slide
import 'package:cached_network_image/cached_network_image.dart'; // Widget tải ảnh và lưu cache (đỡ tốn 4G)
import 'package:url_launcher/url_launcher.dart'; // Thư viện thực hiện cuộc gọi điện thoại

// Import file service chứa các hàm tương tác Firebase
import '../../../services/firebase_service.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  // Số điện thoại của con (Hiện tại đang gắn cứng, sau này có thể lấy từ User Profile)
  final String _childPhoneNumber = "0388802767"; 

  // --- 1. CÁC HÀM TIỆN ÍCH HIỂN THỊ (UI HELPERS) ---
  
  // Hàm hiển thị thông báo nhỏ (SnackBar) dưới đáy màn hình
  void _showNotification(String message, Color color) {
    if (!mounted) return; // Kiểm tra xem màn hình còn tồn tại không trước khi hiện
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message, 
          textAlign: TextAlign.center, 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arimo')
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating, // Kiểu nổi lên trên
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 3), // Tự tắt sau 3 giây
      ),
    );
  }

  // --- 2. XỬ LÝ LOGIC CHÍNH (BUSINESS LOGIC) ---

  // [FR2.2] Xử lý nút SOS: Vừa gọi điện thoại, vừa gửi cảnh báo lên Server
  Future<void> _handleSOS() async {
    // Bước 1: Gửi tín hiệu lên Firebase (Chạy ngầm, không cần chờ xong mới gọi)
    FirebaseService.sendSOS().catchError((e) => print("Lỗi gửi SOS: $e"));

    // Bước 2: Thực hiện cuộc gọi ngay lập tức (Ưu tiên cao nhất)
    final Uri launchUri = Uri(scheme: 'tel', path: _childPhoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri); // Mở trình gọi điện của máy
      } else {
        _showNotification('Thiết bị không hỗ trợ gọi điện', Colors.red);
      }
    } catch (e) {
      _showNotification('Lỗi khi thực hiện cuộc gọi', Colors.red);
    }
  }

  // [FR2.4] Xử lý nút "Nhắn con gọi lại"
  Future<void> _handleCallRequest() async {
    _showNotification('Đang gửi tin nhắn cho con...', Colors.blue);
    try {
      // Gọi hàm trong Service để đẩy thông báo lên collection 'alerts'
      await FirebaseService.sendCallRequest();
      _showNotification('Đã nhắn! Con sẽ gọi lại khi rảnh.', Colors.green);
    } catch (e) {
      _showNotification('Lỗi kết nối: $e', Colors.red);
    }
  }

  // Hàm gọi điện thông thường (Không gửi báo động)
  Future<void> _handleNormalCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: _childPhoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // [FR2.3] Xử lý khi bấm nút "Đã xong" trên việc cần làm
  void _confirmTask(String taskId, String taskTitle) {
    // Cập nhật trạng thái task thành true (đã xong) trên Firebase
    FirebaseService.updateTaskStatus(taskId, true);
    
    // Hiển thị hộp thoại chúc mừng
    showDialog(
      context: context,
      barrierDismissible: false, // Bắt buộc người dùng bấm nút Đóng
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.verified, color: Colors.green, size: 60),
        content: Text(
          "Đã xác nhận: $taskTitle\nCon cái sẽ nhận được thông báo ngay!",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontFamily: 'Arimo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // --- 3. GIAO DIỆN (BUILD METHOD) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tạo nền Gradient màu xanh nhẹ dịu mắt cho người già
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
              _buildHeader(), // Phần Thanh tiêu đề phía trên
              
              // Phần nội dung cuộn được
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 1. SLIDESHOW ẢNH GIA ĐÌNH
                    _buildSlideshow(), 
                    
                    const SizedBox(height: 24),

                    // 2. KHU VỰC NHẮC VIỆC (Quan trọng nhất)
                    // Tự động hiện nút Check-in nếu có việc
                    _buildUrgentTaskArea(),
                    
                    const SizedBox(height: 24),
                    
                    // 3. NÚT SOS (Màu đỏ - Khẩn cấp)
                    _ActionCard(
                      title: 'KHẨN CẤP (GỌI NGAY)',
                      subtitle: 'Bấm khi gặp nguy hiểm',
                      iconText: '🚨',
                      color: const Color(0xFFE7000B),
                      onTap: _handleSOS,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 4. NÚT YÊU CẦU GỌI LẠI (Màu xanh dương)
                    _ActionCard(
                      title: 'NHẮN CON GỌI LẠI',
                      subtitle: 'Con sẽ gọi lại khi rảnh',
                      iconText: '🤙',
                      color: const Color(0xFF155DFC),
                      onTap: _handleCallRequest,
                    ),

                    const SizedBox(height: 20),

                    // 5. NÚT GỌI THƯỜNG (Màu xanh lá)
                    _ActionCard(
                      title: 'GỌI ĐIỆN THOẠI',
                      subtitle: 'Gọi số của con',
                      iconText: '📞',
                      color: const Color(0xFF00A63E),
                      onTap: _handleNormalCall,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 6. ĐỒNG HỒ SỐ (Cập nhật Realtime)
                    const _RealTimeClock(),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- CÁC WIDGET CON (Được tách ra cho code gọn) ---

  // Widget Header (Thanh tiêu đề)
  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF00A63E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Back
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
          // Tên Ứng dụng
          const Text(
            'An Tâm - Cha Mẹ',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Arimo'),
          ),
          // Avatar
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(Icons.person, color: Color(0xFF00A63E)),
          ),
        ],
      ),
    );
  }

  // [FR2.3] Widget Xử lý logic hiển thị việc cần làm
  Widget _buildUrgentTaskArea() {
    // Lắng nghe luồng dữ liệu Task từ Firebase (Real-time)
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getTasksStream(),
      builder: (context, snapshot) {
        // Trường hợp 1: Đang tải hoặc lỗi -> Ẩn đi
        if (!snapshot.hasData) return const SizedBox.shrink();

        final tasks = snapshot.data!.docs;
        
        // Lọc ra các việc CHƯA LÀM (isCompleted == false)
        final pendingTasks = tasks.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['isCompleted'] == false;
        }).toList();

        // Trường hợp 2: Đã làm hết việc -> Hiện thông báo chúc mừng
        if (pendingTasks.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text("Tuyệt vời! Cha/Mẹ đã hoàn thành hết việc hôm nay.", 
                    style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Arimo')),
                ),
              ],
            ),
          );
        }

        // Trường hợp 3: Có việc -> Lấy việc đầu tiên để hiển thị thành Nút to
        final urgentTask = pendingTasks.first;
        final data = urgentTask.data() as Map<String, dynamic>;
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4E5), // Nền màu cam nhạt gây chú ý
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.orange, width: 2), // Viền đậm
            boxShadow: [
              BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))
            ],
          ),
          child: Column(
            children: [
              Text(
                "🔔 ĐẾN GIỜ: ${data['time']}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: 'Arimo'),
              ),
              const SizedBox(height: 8),
              Text(
                data['title'] ?? "Công việc",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Arimo'),
                textAlign: TextAlign.center,
              ),
              if (data['info'] != null)
                Text(
                  data['info'],
                  style: const TextStyle(fontSize: 18, color: Colors.black54, fontFamily: 'Arimo', fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              
              // Nút bấm xác nhận RẤT TO
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmTask(urgentTask.id, data['title']),
                  icon: const Icon(Icons.touch_app, size: 32, color: Colors.white),
                  label: const Text(
                    "BẤM VÀO ĐÂY ĐỂ BÁO XONG",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Arimo'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C850),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget Slideshow chạy ảnh
  Widget _buildSlideshow() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getPhotosStream(),
      builder: (context, snapshot) {
        // Trường hợp chưa có ảnh hoặc đang tải
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.grey[300],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text("Chưa có ảnh gia đình...", style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Arimo')),
              ],
            ),
          );
        }

        // Trường hợp có ảnh -> Hiển thị Carousel
        var photos = snapshot.data!.docs;
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
                  placeholder: (context, url) => Container(color: Colors.grey[200], child: const Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
              options: CarouselOptions(
                height: 220,
                autoPlay: true, // Tự động chạy
                autoPlayInterval: const Duration(seconds: 5),
                viewportFraction: 1.0,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget Nút bấm to (Action Card) - Được tái sử dụng nhiều lần
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
      elevation: 6,
      shadowColor: color.withOpacity(0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 65, height: 65,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Text(iconText, style: const TextStyle(fontSize: 32)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
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

// --- WIDGET ĐỒNG HỒ (ĐÃ SỬA LỖI LOCALE) ---
class _RealTimeClock extends StatefulWidget {
  const _RealTimeClock();

  @override
  State<_RealTimeClock> createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<_RealTimeClock> {
  String _timeString = "";
  String _dateString = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // [Quan Trọng] Khởi tạo Locale tiếng Việt trước khi chạy đồng hồ để tránh lỗi màn hình đỏ
    initializeDateFormatting('vi', null).then((_) {
      if (mounted) {
        _updateTime(); // Cập nhật lần đầu
        // Thiết lập bộ đếm: chạy lại hàm _updateTime mỗi giây
        _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
      }
    });
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = DateFormat('HH:mm').format(now); // Giờ:Phút
        // Dùng 'vi' (tiếng Việt) để hiển thị Thứ, Ngày, Tháng
        _dateString = DateFormat('EEEE, d MMMM', 'vi').format(now);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy bộ đếm khi thoát màn hình để tránh rò rỉ bộ nhớ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _timeString.isEmpty ? "--:--" : _timeString,
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