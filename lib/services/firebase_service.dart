import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Tên collection trong Firebase
  static const String colTasks = 'tasks'; // Chứa thuốc & lịch hẹn
  static const String colAlerts = 'alerts'; // Chứa thông báo SOS

  // 1. Lấy luồng dữ liệu (Real-time Stream)
  // Hàm này trả về Stream để màn hình tự động cập nhật khi DB thay đổi
  static Stream<QuerySnapshot> getTasksStream() {
    return FirebaseFirestore.instance
        .collection(colTasks)
        .orderBy('time', descending: false) // Sắp xếp theo giờ
        .snapshots();
  }

  static Stream<QuerySnapshot> getAlertsStream() {
    return FirebaseFirestore.instance
        .collection(colAlerts)
        .orderBy('timestamp', descending: true) // Mới nhất lên đầu
        .limit(10)
        .snapshots();
  }

  // 2. Thêm dữ liệu (Create)
  static Future<void> addTask(Map<String, dynamic> taskData) async {
    try {
      await FirebaseFirestore.instance.collection(colTasks).add({
        ...taskData,
        'isCompleted': false, // Mặc định chưa làm
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Lỗi khi thêm tác vụ: $e');
    }
  }

  static Future<void> sendSOS() async {
    try {
      await FirebaseFirestore.instance.collection(colAlerts).add({
        'type': 'sos',
        'title': 'CẢNH BÁO SOS KHẨN CẤP',
        'message': 'Cha mẹ cần hỗ trợ ngay lập tức!',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      throw Exception('Không thể gửi SOS: $e');
    }
  }

  // 3. Cập nhật dữ liệu (Update)
  static Future<void> updateTaskStatus(String id, bool isCompleted) async {
    try {
      await FirebaseFirestore.instance.collection(colTasks).doc(id).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      throw Exception('Lỗi cập nhật trạng thái: $e');
    }
  }

  static Future<void> updateTask(String id, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance.collection(colTasks).doc(id).update(newData);
    } catch (e) {
      throw Exception('Lỗi sửa dữ liệu: $e');
    }
  }

  // 4. Xóa dữ liệu (Delete)
  static Future<void> deleteTask(String id) async {
    try {
      await FirebaseFirestore.instance.collection(colTasks).doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi xóa dữ liệu: $e');
    }
  }
}