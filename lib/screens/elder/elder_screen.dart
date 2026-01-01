import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/firebase_service.dart';
import '../../widgets/big_button.dart';

class ElderScreen extends StatelessWidget {
  const ElderScreen({super.key});

  void _callCarer() async {
    final Uri url = Uri.parse('tel:0909123456');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('An Tâm - Cha Mẹ'),
        backgroundColor: const Color(0xFF00A63E),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Khu vực nút bấm lớn
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: BigButton(
                    label: 'KHẨN CẤP (SOS)',
                    icon: Icons.warning_amber_rounded,
                    color: Colors.red,
                    onTap: () {
                      FirebaseService.triggerSOS(true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã gửi báo động SOS!')),
                      );
                      _callCarer();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BigButton(
                    label: 'GỌI CON',
                    icon: Icons.phone,
                    color: Colors.blue,
                    onTap: _callCarer,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Lịch Hôm Nay',
              style: TextStyle(fontSize: 24, color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
          // Danh sách công việc
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseService.tasksRef.orderBy('time').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var tasks = snapshot.data!.docs;
                if (tasks.isEmpty) return const Center(child: Text("Hôm nay không có lịch."));

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    bool isTaken = task['isTaken'] ?? false;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: isTaken ? Colors.green[50] : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(
                          isTaken ? Icons.check_circle : Icons.medication,
                          size: 48,
                          color: isTaken ? Colors.green : Colors.orange,
                        ),
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: isTaken ? TextDecoration.lineThrough : null,
                            color: isTaken ? Colors.grey : Colors.black,
                          ),
                        ),
                        subtitle: Text('Giờ uống: ${task['time']}', style: const TextStyle(fontSize: 18)),
                        trailing: isTaken
                            ? const Icon(Icons.check, color: Colors.green, size: 40)
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C850)),
                                onPressed: () => FirebaseService.completeTask(task.id),
                                child: const Text('XÁC NHẬN'),
                              ),
                      ),
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