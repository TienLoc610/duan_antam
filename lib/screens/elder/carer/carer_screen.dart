import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '/services/firebase_service.dart';

class CarerDashboardScreen extends StatelessWidget {
  const CarerDashboardScreen({super.key});

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm lịch uống thuốc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Tên thuốc')),
            TextField(controller: timeController, decoration: const InputDecoration(labelText: 'Giờ (VD: 08:00)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                FirebaseService.addTask(titleController.text, timeController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Theo Dõi'),
        backgroundColor: const Color(0xFF155DFC),
        actions: [
          IconButton(
            onPressed: () => _showAddTaskDialog(context),
            icon: const Icon(Icons.add_circle_outline, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          // Widget cảnh báo SOS
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseService.statusRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                var data = snapshot.data!.data() as Map<String, dynamic>;
                if (data['sosActive'] == true) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.redAccent,
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.white),
                        const SizedBox(width: 10),
                        const Expanded(child: Text("CẢNH BÁO: Bố mẹ gọi SOS!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        TextButton(
                          onPressed: () => FirebaseService.triggerSOS(false),
                          style: TextButton.styleFrom(backgroundColor: Colors.white),
                          child: const Text('Đã xử lý', style: TextStyle(color: Colors.red)),
                        )
                      ],
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          // Danh sách công việc
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseService.tasksRef.orderBy('time').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var tasks = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    bool isTaken = task['isTaken'];
                    return ListTile(
                      leading: Icon(isTaken ? Icons.check_circle : Icons.schedule, color: isTaken ? Colors.green : Colors.grey),
                      title: Text(task['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${task['time']} - ${isTaken ? "Đã uống" : "Chưa uống"}'),
                      trailing: isTaken
                          ? Text(
                              DateFormat('HH:mm').format((task['takenAt'] as Timestamp).toDate()),
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            )
                          : const Text('Đang chờ...', style: TextStyle(color: Colors.red)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}