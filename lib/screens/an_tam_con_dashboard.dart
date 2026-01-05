import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
// Import các dialog cũ của bạn
import '../widgets/add_appointment_form_dialog.dart';
import '../widgets/add_medicine_form_dialog.dart';

class AnTamConDashboard extends StatefulWidget {
  const AnTamConDashboard({super.key});

  @override
  _AnTamConDashboardState createState() => _AnTamConDashboardState();
}

class _AnTamConDashboardState extends State<AnTamConDashboard> {
  int _selectedIndex = 0;

  // Xử lý mở form Thêm/Sửa
  void _openForm({DocumentSnapshot? document}) async {
    Map<String, dynamic>? initialData;
    if (document != null) {
      initialData = document.data() as Map<String, dynamic>;
    }

    dynamic result;
    // Logic chọn form thuốc hay lịch hẹn
    if (_selectedIndex == 1 || (initialData != null && initialData['type'] == 'medication')) {
      result = await showDialog(
        context: context,
        builder: (_) => AddMedicineFormDialog(initialData: initialData),
      );
    } else if (_selectedIndex == 2 || (initialData != null && initialData['type'] == 'appointment')) {
      result = await showDialog(
        context: context,
        builder: (_) => AddAppointmentScreen(initialData: initialData),
      );
    }

    // Xử lý kết quả trả về từ Dialog
    if (result != null) {
      try {
        if (document == null) {
          // Thêm mới
          await FirebaseService.addTask(result);
          _showMessage("Đã thêm thành công!", Colors.green);
        } else {
          // Cập nhật
          await FirebaseService.updateTask(document.id, result);
          _showMessage("Đã cập nhật thành công!", Colors.blue);
        }
      } catch (e) {
        _showMessage(e.toString(), Colors.red);
      }
    }
  }

  // Hàm xóa có xác nhận
  void _deleteItem(String id) async {
    try {
      await FirebaseService.deleteTask(id);
      _showMessage("Đã xóa mục này", Colors.grey);
    } catch (e) {
      _showMessage(e.toString(), Colors.red);
    }
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(['Tổng quan', 'Lịch thuốc', 'Lịch hẹn', 'Cảnh báo SOS'][_selectedIndex]),
        backgroundColor: const Color(0xFF155DFC),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      floatingActionButton: (_selectedIndex == 1 || _selectedIndex == 2)
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF155DFC),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _openForm(),
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
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'SOS'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 3) return _buildSOSList(); // Tab SOS riêng

    // StreamBuilder tự động lắng nghe dữ liệu
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getTasksStream(),
      builder: (context, snapshot) {
        // 1. Trạng thái đang tải
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2. Trạng thái lỗi
        if (snapshot.hasError) {
          return Center(child: Text("Lỗi: ${snapshot.error}"));
        }
        // 3. Không có dữ liệu
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Chưa có dữ liệu nào."));
        }

        var docs = snapshot.data!.docs;

        // Lọc dữ liệu theo Tab (Thuốc hoặc Lịch hẹn)
        if (_selectedIndex == 1) docs = docs.where((d) => d['type'] == 'medication').toList();
        if (_selectedIndex == 2) docs = docs.where((d) => d['type'] == 'appointment').toList();

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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isDone ? Colors.green.shade100 : (isMed ? Colors.blue.shade50 : Colors.orange.shade50),
                  child: Icon(
                    isDone ? Icons.check : (isMed ? Icons.medication : Icons.calendar_month),
                    color: isDone ? Colors.green : (isMed ? Colors.blue : Colors.orange),
                  ),
                ),
                title: Text(
                  data['title'] ?? 'Không tên',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: Text("${data['time']} | ${data['info']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nút check nhanh (Dành cho con xác nhận hộ)
                    Checkbox(
                      value: isDone,
                      onChanged: (val) => FirebaseService.updateTaskStatus(id, val!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                      onPressed: () => _deleteItem(id),
                    ),
                  ],
                ),
                onTap: () => _openForm(document: docs[index]),
              ),
            );
          },
        );
      },
    );
  }

  // Tab riêng hiển thị thông báo SOS
  Widget _buildSOSList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getAlertsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var alerts = snapshot.data!.docs;
        if (alerts.isEmpty) return const Center(child: Text("An toàn, không có cảnh báo SOS."));

        return ListView.builder(
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            var data = alerts[index].data() as Map<String, dynamic>;
            // Format thời gian từ Timestamp
            String timeStr = "Vừa xong";
            if (data['timestamp'] != null) {
              Timestamp t = data['timestamp'];
              timeStr = DateFormat('HH:mm dd/MM').format(t.toDate());
            }

            return Card(
              color: Colors.red.shade50,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
                title: Text(data['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                subtitle: Text("${data['message']}\nThời gian: $timeStr"),
              ),
            );
          },
        );
      },
    );
  }
}