import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  // Tên Collection
  static const String colUsers = 'users';
  static const String colTasks = 'tasks';
  static const String colAlerts = 'alerts';
  static const String colPhotos = 'photos';

  // ==========================================
  // 1. QUẢN LÝ GIA ĐÌNH & SINH DỮ LIỆU MẪU
  // ==========================================

  // Hàm tạo gia đình mới (Dành cho CON)
  static Future<String> createFamilyGroup(String role, String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Chưa đăng nhập Firebase Auth");

    // 1. Sinh mã gia đình ngẫu nhiên (VD: AT-5678)
    String familyId = "AT-${Random().nextInt(9000) + 1000}";

    // 2. Lưu thông tin User vào Firestore
    await FirebaseFirestore.instance.collection(colUsers).doc(user.uid).set({
      'uid': user.uid,
      'fullName': name,
      'phoneNumber': user.email?.split('@')[0] ?? '', // Lấy sđt từ email giả
      'role': role,
      'familyId': familyId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 3. SINH DỮ LIỆU MẪU (Để app không bị trống)
    await _generateSampleData(familyId);

    return familyId;
  }

  // Hàm tham gia gia đình (Dành cho CHA MẸ)
  static Future<void> joinFamilyGroup(String familyCode, String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Chưa đăng nhập");

    // Chuẩn hóa mã (chữ hoa, bỏ khoảng trắng)
    String cleanCode = familyCode.toUpperCase().trim();

    // (Tùy chọn) Kiểm tra mã có tồn tại không trước khi join
    // Ở đây ta cho phép join thẳng để đơn giản hóa
    
    await FirebaseFirestore.instance.collection(colUsers).doc(user.uid).set({
      'uid': user.uid,
      'fullName': name,
      'phoneNumber': user.email?.split('@')[0] ?? '',
      'role': 'elder',
      'familyId': cleanCode, // Lưu mã con cung cấp
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Hàm nội bộ: Sinh dữ liệu mẫu
  static Future<void> _generateSampleData(String familyId) async {
    final batch = FirebaseFirestore.instance.batch();
    final collection = FirebaseFirestore.instance.collection(colTasks);

    // Mẫu 1: Thuốc huyết áp
    batch.set(collection.doc(), {
      'familyId': familyId,
      'title': 'Thuốc Huyết áp',
      'info': '1 viên (Màu đỏ) - Sau ăn sáng',
      'time': '08:00',
      'type': 'medication',
      'isCompleted': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Mẫu 2: Vitamin
    batch.set(collection.doc(), {
      'familyId': familyId,
      'title': 'Vitamin tổng hợp',
      'info': '1 viên sủi - Uống nhiều nước',
      'time': '12:30',
      'type': 'medication',
      'isCompleted': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Mẫu 3: Lịch hẹn
    batch.set(collection.doc(), {
      'familyId': familyId,
      'title': 'Đo huyết áp chiều',
      'info': 'Nghỉ ngơi 15p trước khi đo',
      'time': '16:00',
      'type': 'appointment',
      'isCompleted': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit(); // Thực hiện lưu tất cả cùng lúc
  }

  // Lấy Mã Gia Đình hiện tại
  static Future<String?> getCurrentFamilyId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    // Cache nhẹ hoặc lấy từ Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection(colUsers).doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      return (doc.data() as Map<String, dynamic>)['familyId'] as String?;
    }
    return null;
  }

  // ==========================================
  // 2. QUẢN LÝ TÁC VỤ (CÓ LỌC THEO GIA ĐÌNH)
  // ==========================================

  static Stream<QuerySnapshot> getTasksStream() async* {
    String? familyId = await getCurrentFamilyId();
    if (familyId != null) {
      yield* FirebaseFirestore.instance
          .collection(colTasks)
          .where('familyId', isEqualTo: familyId)
          .orderBy('time', descending: false)
          .snapshots();
    }
  }

  static Future<void> addTask(Map<String, dynamic> taskData) async {
    String? familyId = await getCurrentFamilyId();
    if (familyId == null) throw Exception("Lỗi: Chưa có mã gia đình");

    await FirebaseFirestore.instance.collection(colTasks).add({
      ...taskData,
      'familyId': familyId,
      'isCompleted': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await FirebaseFirestore.instance.collection(colTasks).doc(id).update({'isCompleted': isCompleted});
  }

  static Future<void> updateTask(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(colTasks).doc(id).update(data);
  }

  static Future<void> deleteTask(String id) async {
    await FirebaseFirestore.instance.collection(colTasks).doc(id).delete();
  }

  // ==========================================
  // 3. QUẢN LÝ SOS & ẢNH (CÓ LỌC THEO GIA ĐÌNH)
  // ==========================================

  static Stream<QuerySnapshot> getAlertsStream() async* {
    String? familyId = await getCurrentFamilyId();
    if (familyId != null) {
      yield* FirebaseFirestore.instance
          .collection(colAlerts)
          .where('familyId', isEqualTo: familyId)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots();
    }
  }

  static Future<void> sendSOS() async {
    String? familyId = await getCurrentFamilyId();
    if (familyId == null) return; // Không làm gì nếu chưa có gia đình

    await FirebaseFirestore.instance.collection(colAlerts).add({
      'type': 'sos',
      'familyId': familyId,
      'title': 'CẢNH BÁO SOS KHẨN CẤP',
      'message': 'Cha mẹ cần hỗ trợ ngay lập tức!',
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  static Future<void> uploadFamilyPhoto(Uint8List data) async {
    try {
      String? familyId = await getCurrentFamilyId();
      if (familyId == null) throw Exception("Chưa có mã gia đình");

      String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child('family_photos/$fileName');
      
      await ref.putData(data, SettableMetadata(contentType: 'image/jpeg'));
      String downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection(colPhotos).add({
        'url': downloadUrl,
        'familyId': familyId,
        'uploadedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Lỗi upload ảnh: $e');
    }
  }

  static Stream<QuerySnapshot> getPhotosStream() async* {
    String? familyId = await getCurrentFamilyId();
    if (familyId != null) {
      yield* FirebaseFirestore.instance
          .collection(colPhotos)
          .where('familyId', isEqualTo: familyId)
          .orderBy('uploadedAt', descending: true)
          .snapshots();
    }
  }
}