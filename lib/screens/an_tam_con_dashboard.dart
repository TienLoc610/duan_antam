import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/add_appointment_form_dialog.dart'; // Sửa import
import '../widgets/add_medicine_form_dialog.dart';    // Sửa import

class AnTamConDashboard extends StatefulWidget {
  const AnTamConDashboard({super.key});

  @override
  _AnTamConDashboardState createState() => _AnTamConDashboardState();
}

class _AnTamConDashboardState extends State<AnTamConDashboard> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _allData = [];
  final List<Map<String, dynamic>> _notifications = [];
  final List<File> _familyPhotos = [];
  final ImagePicker _picker = ImagePicker();

  void _deleteItem(int index) {
    setState(() => _allData.removeAt(index));
  }

  void _openForm({Map<String, dynamic>? currentData, int? index}) async {
    dynamic result;
    if (_selectedIndex == 1 || (currentData != null && currentData['type'] == 'medication')) {
      result = await showDialog(
        context: context,
        builder: (_) => AddMedicineFormDialog(initialData: currentData),
      );
    } else if (_selectedIndex == 2 || (currentData != null && currentData['type'] == 'appointment')) {
      result = await showDialog(
        context: context,
        builder: (_) => AddAppointmentScreen(initialData: currentData),
      );
    }

    if (result != null) {
      setState(() {
        if (index != null) {
          _allData[index] = result;
        } else {
          _allData.add(result);
        }
      });
    }
  }

  void _receiveSOS() {
    setState(() {
      _notifications.insert(0, {
        'type': 'sos',
        'title': 'CẢNH BÁO SOS KHẨN CẤP',
        'time': 'Vừa xong',
        'isRead': false,
      });
    });
    setState(() => _selectedIndex = 3);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _familyPhotos.add(File(image.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(['Tổng quan', 'Lịch thuốc', 'Lịch hẹn', 'Thông báo', 'Ảnh gia đình'][_selectedIndex]),
        backgroundColor: const Color(0xFF155DFC),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.add_alert), onPressed: _receiveSOS),
        ],
      ),
      body: _buildTabContent(),
      floatingActionButton: (_selectedIndex == 1 || _selectedIndex == 2 || _selectedIndex == 4)
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF155DFC),
        child: Icon(_selectedIndex == 4 ? Icons.add_a_photo : Icons.add, color: Colors.white),
        onPressed: () {
          if (_selectedIndex == 4) {
            _pickImage();
          } else {
            _openForm();
          }
        },
      ) : null,
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: 'Ảnh'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0: return _buildOverview();
      case 1: return _buildFilteredList('medication');
      case 2: return _buildFilteredList('appointment');
      case 3: return _buildNotificationList();
      case 4: return _buildPhotoGallery();
      default: return Container();
    }
  }

  Widget _buildOverview() {
    if (_allData.isEmpty && _notifications.isEmpty) return const Center(child: Text("Chưa có hoạt động nào."));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_notifications.any((n) => n['type'] == 'sos'))
          _buildSOSAlert(),
        ..._allData.asMap().entries.map((e) => _buildDataCard(e.value, e.key)).toList(),
      ],
    );
  }

  Widget _buildSOSAlert() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
      child: const Text("CẢNH BÁO SOS: Cha mẹ cần hỗ trợ!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFilteredList(String type) {
    final filteredIndices = [];
    for (int i = 0; i < _allData.length; i++) {
      if (_allData[i]['type'] == type) filteredIndices.add(i);
    }
    return filteredIndices.isEmpty
        ? const Center(child: Text("Danh sách trống"))
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredIndices.length,
      itemBuilder: (context, i) => _buildDataCard(_allData[filteredIndices[i]], filteredIndices[i]),
    );
  }

  Widget _buildDataCard(Map<String, dynamic> item, int index) {
    bool isMed = item['type'] == 'medication';
    return Card(
      child: ListTile(
        leading: Icon(isMed ? Icons.medication : Icons.local_hospital, color: isMed ? Colors.blue : Colors.green),
        title: Text(item['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${item['info']}\n${item['time']}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _openForm(currentData: item, index: index)),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteItem(index)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length,
      itemBuilder: (context, i) => Card(
        color: _notifications[i]['type'] == 'sos' ? Colors.red.shade50 : Colors.white,
        child: ListTile(
          leading: Icon(Icons.notifications, color: _notifications[i]['type'] == 'sos' ? Colors.red : Colors.blue),
          title: Text(_notifications[i]['title']),
          subtitle: Text(_notifications[i]['time']),
        ),
      ),
    );
  }

  Widget _buildPhotoGallery() {
    return _familyPhotos.isEmpty
        ? const Center(child: Text("Nhấn nút + để tải ảnh lên"))
        : GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: _familyPhotos.length,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(_familyPhotos[index], fit: BoxFit.cover),
      ),
    );
  }
}