import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:cached_network_image/cached_network_image.dart'; 
import 'package:intl/intl.dart';

import '../../../services/firebase_service.dart'; 
import '../widgets/add_appointment_form_dialog.dart';
import '../widgets/add_medicine_form_dialog.dart';

class AnTamConDashboard extends StatefulWidget {
  const AnTamConDashboard({super.key});

  @override
  _AnTamConDashboardState createState() => _AnTamConDashboardState();
}

class _AnTamConDashboardState extends State<AnTamConDashboard> {
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();
  
  // Biến quản lý mã gia đình và luồng lắng nghe
  String? _familyId;
  StreamSubscription? _alertSubscription;

  // --- 1. KHỞI TẠO DỮ LIỆU ---
  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _alertSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initData() async {
    // Lấy mã gia đình từ Service
    String? id = await FirebaseService.getCurrentFamilyId();
    
    // [FIX LỖI] Nếu chưa có ID (do login lỗi), dùng tạm 'gd1' để Test không bị lỗi màn hình trắng
    id ??= "gd1"; 

    if (mounted) {
      setState(() => _familyId = id);
      // Sau khi có ID thì mới bắt đầu lắng nghe tin khẩn cấp
      _setupRealtimeListener(id!);
    }
  }

  // --- 2. BỘ LẮNG NGHE (CHỈ DÙNG ĐỂ BẬT POPUP) ---
  void _setupRealtimeListener(String familyId) {
    // Chỉ lắng nghe tin MỚI (isRead == false) để bật Popup cảnh báo
    _alertSubscription = FirebaseFirestore.instance
        .collection('alerts')
        .where('familyId', isEqualTo: familyId)
        .where('isRead', isEqualTo: false) // Chỉ bắt tin chưa đọc
        .snapshots()
        .listen((snapshot) {
      
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data() as Map<String, dynamic>;
          
          if (mounted) {
            _showInstantAlert(
              data['type'] ?? 'info',
              data['message'] ?? 'Có thông báo mới',
              change.doc.id
            );
          }
        }
      }
    });
  }

  // Hàm hiện Popup và đánh dấu đã đọc
  void _showInstantAlert(String type, String message, String docId) {
    // 1. Đánh dấu đã đọc trên Firebase ngay
    FirebaseFirestore.instance.collection('alerts').doc(docId).update({'isRead': true});

    // 2. Cấu hình giao diện Popup
    Color bgColor = type == 'sos' ? Colors.red.shade100 : Colors.blue.shade100;
    IconData icon = type == 'sos' ? Icons.warning_amber_rounded : Icons.phone_in_talk;
    String title = type == 'sos' ? "CẢNH BÁO KHẨN CẤP!" : "Cha Mẹ nhắn gọi lại";

    // 3. Hiện Dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 30),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đã rõ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // --- 3. CÁC HÀM XỬ LÝ KHÁC (ẢNH, THUỐC...) ---
  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tải ảnh lên...')));
      try {
        final bytes = await image.readAsBytes();
        await FirebaseService.uploadFamilyPhoto(bytes);
        _showMessage("Đã chia sẻ ảnh thành công!", Colors.green);
      } catch (e) {
        _showMessage("Lỗi: $e", Colors.red);
      }
    }
  }

  void _openForm({DocumentSnapshot? document}) async {
    Map<String, dynamic>? initialData;
    if (document != null) initialData = document.data() as Map<String, dynamic>;
    
    dynamic result;
    if (_selectedIndex == 1 || (initialData != null && initialData['type'] == 'medication')) {
      result = await showDialog(context: context, builder: (_) => AddMedicineFormDialog(initialData: initialData));
    } else if (_selectedIndex == 2 || (initialData != null && initialData['type'] == 'appointment')) {
      result = await showDialog(context: context, builder: (_) => AddAppointmentScreen(initialData: initialData));
    } else {
      result = await showDialog(context: context, builder: (_) => AddMedicineFormDialog(initialData: initialData));
    }

    if (result != null) {
      try {
        if (document == null) {
          await FirebaseService.addTask(result);
          _showMessage("Đã thêm thành công!", Colors.green);
        } else {
          await FirebaseService.updateTask(document.id, result);
          _showMessage("Đã cập nhật!", Colors.blue);
        }
      } catch (e) { _showMessage(e.toString(), Colors.red); }
    }
  }

  void _deleteItem(String id) async {
    try { await FirebaseService.deleteTask(id); _showMessage("Đã xóa mục này", Colors.grey); } 
    catch (e) { _showMessage(e.toString(), Colors.red); }
  }

  void _showMessage(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  // ==========================================
  // GIAO DIỆN CHÍNH
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['Tổng quan', 'Lịch thuốc', 'Lịch hẹn', 'Lịch sử SOS', 'Ảnh gia đình'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            if (_familyId != null) 
              Text("Mã GD: $_familyId", style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: const Color(0xFF155DFC),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      
      body: _familyId == null 
        ? const Center(child: CircularProgressIndicator()) 
        : _buildBody(), // Chỉ hiện body khi đã có Family ID
      
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 2 || _selectedIndex == 4)
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF155DFC),
              child: Icon(_selectedIndex == 4 ? Icons.add_a_photo : Icons.add, color: Colors.white),
              onPressed: () {
                if (_selectedIndex == 4) _pickAndUploadImage();
                else _openForm();
              },
            )
          : null,
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: const Color(0xFF155DFC),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Tổng quan'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Thuốc'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Lịch hẹn'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active), label: 'SOS'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: 'Ảnh'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 3) return _buildSOSList();
    if (_selectedIndex == 4) return _buildPhotoGallery();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getTasksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
           return const Center(child: Text("Chưa có nhiệm vụ nào.", style: TextStyle(color: Colors.grey)));
        }

        var docs = snapshot.data!.docs;
        if (_selectedIndex == 1) docs = docs.where((d) => d['type'] == 'medication').toList();
        if (_selectedIndex == 2) docs = docs.where((d) => d['type'] == 'appointment').toList();

        if (docs.isEmpty) return const Center(child: Text("Danh sách trống."));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            var id = docs[index].id;
            bool isMed = data['type'] == 'medication';
            bool isDone = data['isCompleted'] ?? false;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: isDone ? Colors.grey.shade100 : Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isDone ? Colors.green.shade100 : (isMed ? Colors.blue.shade50 : Colors.orange.shade50),
                  child: Icon(isDone ? Icons.check : (isMed ? Icons.medication : Icons.calendar_month), 
                    color: isDone ? Colors.green : (isMed ? Colors.blue : Colors.orange)),
                ),
                title: Text(data['title'] ?? 'Không tên', style: TextStyle(fontWeight: FontWeight.bold, decoration: isDone ? TextDecoration.lineThrough : null, color: isDone ? Colors.grey : Colors.black)),
                subtitle: Text("${data['time']} | ${data['info']}"),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Checkbox(value: isDone, onChanged: (val) => FirebaseService.updateTaskStatus(id, val!)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20), onPressed: () => _deleteItem(id)),
                ]),
                onTap: () => _openForm(document: docs[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPhotoGallery() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getPhotosStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var photos = snapshot.data!.docs;
        if (photos.isEmpty) return const Center(child: Text("Chưa có ảnh nào.", style: TextStyle(color: Colors.grey)));

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: photos[index]['url'], fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            );
          },
        );
      },
    );
  }

  // --- [FIX QUAN TRỌNG] LIST SOS KHÔNG ĐƯỢC LỌC TIN ĐÃ ĐỌC ---
  Widget _buildSOSList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('alerts')
          .where('familyId', isEqualTo: _familyId) // Chỉ lọc theo Gia đình
          //.where('isRead', isEqualTo: false) <-- ĐÃ XÓA DÒNG NÀY ĐỂ KHÔNG BỊ MẤT TIN
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var alerts = snapshot.data!.docs;
        
        if (alerts.isEmpty) {
          return const Center(child: Text("An toàn, không có thông báo nào.", style: TextStyle(color: Colors.grey)));
        }

        return ListView.builder(
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            var data = alerts[index].data() as Map<String, dynamic>;
            bool isSos = data['type'] == 'sos';
            bool isRead = data['isRead'] ?? true; // Kiểm tra trạng thái

            String timeStr = "Vừa xong";
            if (data['timestamp'] != null) {
              Timestamp t = data['timestamp'];
              timeStr = DateFormat('HH:mm dd/MM').format(t.toDate());
            }

            return Card(
              // Đã đọc thì màu nhạt, Chưa đọc thì màu đậm
              color: isSos 
                  ? (isRead ? Colors.red.shade50 : Colors.red.shade100)
                  : (isRead ? Colors.blue.shade50 : Colors.blue.shade100),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(
                  isSos ? Icons.warning_amber_rounded : Icons.phone_callback, 
                  color: isSos ? Colors.red : Colors.blue, 
                  size: 32
                ),
                title: Text(
                  data['title'] ?? 'Thông báo', 
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold, // Chưa đọc thì in đậm
                    color: isSos ? Colors.red : Colors.blue[900]
                  )
                ),
                subtitle: Text("${data['message']}\n$timeStr"),
                trailing: isRead 
                    ? const Icon(Icons.check_circle_outline, size: 18, color: Colors.grey)
                    : const Icon(Icons.circle, size: 12, color: Colors.redAccent), // Chấm đỏ
              ),
            );
          },
        );
      },
    );
  }
}