import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // ID gia đình demo (sau này có thể thay bằng ID người dùng thật khi login)
  static const String FAMILY_ID = 'family_demo_1';

  static final CollectionReference tasksRef =
      FirebaseFirestore.instance.collection('families').doc(FAMILY_ID).collection('tasks');

  static final DocumentReference statusRef =
      FirebaseFirestore.instance.collection('families').doc(FAMILY_ID);

  // Thêm lịch uống thuốc mới
  static Future<void> addTask(String title, String time) async {
    await tasksRef.add({
      'title': title,
      'time': time,
      'isTaken': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Đánh dấu đã uống thuốc
  static Future<void> completeTask(String taskId) async {
    await tasksRef.doc(taskId).update({
      'isTaken': true,
      'takenAt': FieldValue.serverTimestamp(),
    });
  }

  // Bật/Tắt trạng thái SOS
  static Future<void> triggerSOS(bool isActive) async {
    await statusRef.set({
      'sosActive': isActive,
      'lastUpdate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}