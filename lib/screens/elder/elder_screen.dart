import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart'; // Đảm bảo đường dẫn này đúng

class ElderScreen extends StatefulWidget {
  const ElderScreen({super.key});

  @override
  State<ElderScreen> createState() => _ElderScreenState();
}

class _ElderScreenState extends State<ElderScreen> {
  // Hàm gọi điện
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thực hiện cuộc gọi')),
      );
    }
  }

  // Hàm xử lý SOS
  void _handleSOS() {
    FirebaseService.triggerSOS(true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã gửi báo động SOS đến các con!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
    _makePhoneCall('0909123456'); // Gọi ngay cho con
  }

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
            colors: [Color(0xFFF0FDF4), Color(0xFFEEF5FE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _Header(),
              Expanded(
                child: Column( // Bỏ SingleChildScrollView bao ngoài để List thuốc cuộn riêng
                  children: [
                    _Banner(),
                    const SizedBox(height: 16),
                    // Phần 1: Các nút chức năng chính (SOS & Gọi)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              color: const Color(0xFFE7000B),
                              icon: Icons.warning_amber_rounded,
                              label: 'SOS',
                              onTap: _handleSOS,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _ActionButton(
                              color: const Color(0xFF155DFC),
                              icon: Icons.phone_in_talk,
                              label: 'GỌI CON',
                              onTap: () => _makePhoneCall('0909123456'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _RealTimeClock(),
                    
                    // Phần 2: Tiêu đề danh sách
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Row(
                        children: const [
                          Icon(Icons.medication, color: Color(0xFF00A63E)),
                          SizedBox(width: 8),
                          Text(
                            "Lịch uống thuốc hôm nay",
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF101727),
                              fontFamily: 'Arimo',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Phần 3: Danh sách thuốc từ Firebase
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseService.tasksRef.orderBy('time').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          var tasks = snapshot.data!.docs;
                          
                          if (tasks.isEmpty) {
                            return const Center(
                              child: Text(
                                "Hôm nay ông/bà khỏe,\nkhông cần uống thuốc!",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              var task = tasks[index];
                              bool isTaken = task['isTaken'] ?? false;
                              return _MedicineCard(
                                title: task['title'],
                                time: task['time'],
                                isTaken: isTaken,
                                onTap: () {
                                  if (!isTaken) {
                                    FirebaseService.completeTask(task.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Đã uống: ${task['title']}')),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
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

// ================= CÁC WIDGET CON ĐÃ ĐƯỢC LÀM ĐẸP =================

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF00A63E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'An Tâm - Cha Mẹ',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arimo'),
          ),
          // Nút cài đặt giả (để cho đẹp)
          const Icon(Icons.settings, color: Colors.white),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // Giảm chiều cao banner để nhường chỗ cho danh sách
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://placehold.co/600x400',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: const Text(
                'Chúc Ông/Bà một ngày vui vẻ!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Arimo'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Nút bấm lớn cho SOS và Gọi
class _ActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arimo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Card hiển thị từng loại thuốc
class _MedicineCard extends StatelessWidget {
  final String title;
  final String time;
  final bool isTaken;
  final VoidCallback onTap;

  const _MedicineCard({
    required this.title,
    required this.time,
    required this.isTaken,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isTaken ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isTaken ? Border.all(color: Colors.green.withOpacity(0.5)) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isTaken ? null : onTap, // Nếu uống rồi thì không bấm được nữa
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon trạng thái
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isTaken ? Colors.green[100] : const Color(0xFFEEF5FE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isTaken ? Icons.check : Icons.medication_outlined,
                    color: isTaken ? Colors.green : const Color(0xFF155DFC),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                // Thông tin thuốc
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isTaken ? Colors.grey : Colors.black87,
                          decoration: isTaken ? TextDecoration.lineThrough : null,
                          fontFamily: 'Arimo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isTaken ? "Đã uống lúc ${DateFormat('HH:mm').format(DateTime.now())}" : "Giờ uống: $time",
                        style: TextStyle(
                          fontSize: 16,
                          color: isTaken ? Colors.green : const Color(0xFF697282),
                          fontFamily: 'Arimo',
                        ),
                      ),
                    ],
                  ),
                ),
                // Nút hành động
                if (!isTaken)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C850),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      "XÁC NHẬN",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RealTimeClock extends StatefulWidget {
  const _RealTimeClock();
  @override
  State<_RealTimeClock> createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<_RealTimeClock> {
  late String _timeString;
  late String _dateString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = DateFormat('HH:mm').format(now);
        _dateString = DateFormat('EEEE, d MMMM').format(now);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _timeString,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF101727), fontFamily: 'Arimo'),
        ),
        Text(
          _dateString,
          style: const TextStyle(fontSize: 18, color: Color(0xFF495565), fontFamily: 'Arimo'),
        ),
      ],
    );
  }
}