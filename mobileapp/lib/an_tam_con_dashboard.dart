import 'package:flutter/material.dart';
import 'add_appointment_form_dialog.dart';
import 'add_medicine_form_dialog.dart'; // Import mới

class AnTamConDashboard extends StatefulWidget {
  const AnTamConDashboard({super.key});

  @override
  _AnTamConDashboardState createState() => _AnTamConDashboardState();
}

class _AnTamConDashboardState extends State<AnTamConDashboard> {
  // Trạng thái: 0=Tổng quan, 1=Lịch uống thuốc, 2=Lịch hẹn, 3=Ảnh gia đình
  int _selectedIndex = 0;
  final List<String> _tabTitles = ['Tổng quan', 'Lịch uống thuốc', 'Lịch hẹn', 'Ảnh gia đình'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(92.0),
        child: _buildTopBar(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Thanh Tabs (Horizontal Navigation)
          _buildCategoryTabs(context),
          // Nội dung thay đổi dựa trên tab được chọn
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildTabBody(),
            ),
          ),
        ],
      ),
      // Floating Action Button hiển thị khi ở tab Lịch uống thuốc hoặc Lịch hẹn
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  // Widget quyết định FAB nào sẽ xuất hiện
  Widget? _buildFloatingActionButton(BuildContext context) {
    String label = '';
    Function? onPressed;

    if (_selectedIndex == 1) { // Lịch uống thuốc
      label = 'Thêm Thuốc';
      onPressed = () => _showAddMedicineDialog(context);
    } else if (_selectedIndex == 2) { // Lịch hẹn
      label = 'Thêm Lịch Hẹn';
      onPressed = () => _showAddAppointmentDialog(context);
    } else {
      return null;
    }

    return FloatingActionButton.extended(
      onPressed: onPressed as void Function()?,
      label: Text(label, style: TextStyle(color: Colors.white)),
      icon: Icon(Icons.add, color: Colors.white),
      backgroundColor: const Color(0xFF155DFC),
    );
  }

  // Hàm hiển thị Dialog Form Thêm Thuốc
  void _showAddMedicineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMedicineFormDialog();
      },
    );
  }

  // Hàm hiển thị Dialog Form Thêm Lịch Hẹn
  void _showAddAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAppointmentFormDialog();
      },
    );
  }

  // Hàm xử lý hiển thị nội dung theo Tab
  Widget _buildTabBody() {
    switch (_selectedIndex) {
      case 0: // Tổng quan
        return Column(
          children: [
            _buildMedicineStatusCard(context),
            SizedBox(height: 24.0),
            _buildAppointmentsCard(context),
          ],
        );
      case 1: // Lịch uống thuốc
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Icon(Icons.medical_services_outlined, size: 60, color: Colors.grey.withOpacity(0.5)),
              SizedBox(height: 16),
              Text('Đây là trang Quản lý Lịch uống thuốc.', style: TextStyle(fontSize: 18)),
              Text('Sử dụng nút "Thêm Thuốc" để tạo lịch uống thuốc mới.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 40),
            ],
          ),
        );
      case 2: // Lịch hẹn
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Icon(Icons.event_note_outlined, size: 60, color: Colors.grey.withOpacity(0.5)),
              SizedBox(height: 16),
              Text('Đây là trang Quản lý Lịch hẹn.', style: TextStyle(fontSize: 18)),
              Text('Sử dụng nút "Thêm Lịch Hẹn" để thêm lịch hẹn mới.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 40),
            ],
          ),
        );
      case 3: // Ảnh gia đình
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Icon(Icons.photo_library_outlined, size: 60, color: Colors.grey.withOpacity(0.5)),
              SizedBox(height: 16),
              Text('Đây là Album Ảnh Gia đình.', style: TextStyle(fontSize: 18)),
              Text('Ảnh sẽ được hiển thị tại đây để cha mẹ có thể xem.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 40),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  // --- GIỮ NGUYÊN _buildTopBar, _buildCategoryTabs, _buildTab, _buildMedicineStatusCard, _buildAppointmentsCard ---
  // ... (Phần code này giữ nguyên như phản hồi trước) ...

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF155DFC),
        boxShadow: [
          BoxShadow(color: Color(0x19000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4),
          BoxShadow(color: Color(0x19000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                width: 35.97, height: 35.97,
                child: Icon(Icons.person, color: Colors.blue.shade100),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('An Tâm - Con', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400, height: 1.50)),
                  Text('Theo dõi & chăm sóc cha mẹ', style: TextStyle(color: const Color(0xFFDAEAFE), fontSize: 16, fontWeight: FontWeight.w400, height: 1.50)),
                ],
              ),
            ],
          ),
          SizedBox(width: 24, height: 24, child: Icon(Icons.settings, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 66,
      padding: const EdgeInsets.only(bottom: 1.27),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: Border(bottom: BorderSide(width: 1.27, color: Colors.black.withOpacity(0.10))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_tabTitles.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: _buildTab(_tabTitles[index], _selectedIndex == index, context),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected, BuildContext context) {
    final Color textColor = isSelected ? const Color(0xFF155CFB) : const Color(0xFF495565);
    final Color borderColor = isSelected ? const Color(0xFF155CFB) : Colors.black.withOpacity(0);

    double width = 0;
    if (title == 'Tổng quan') {
      width = 132.25;
    } else if (title == 'Lịch uống thuốc') width = 169.77;
    else if (title == 'Lịch hẹn') width = 114.68;
    else if (title == 'Ảnh gia đình') width = 145.99;

    return Container(
      width: width,
      height: 49.23,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.27, color: borderColor),
        ),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Color(0x19000000), blurRadius: 2, offset: Offset(0, 1), spreadRadius: -1),
          BoxShadow(color: Color(0x19000000), blurRadius: 3, offset: Offset(0, 1), spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Trạng thái uống thuốc hôm nay',
            style: TextStyle(
              color: const Color(0xFF101727),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Opacity(
                  opacity: 0.30,
                  child: SizedBox(width: 48, height: 48, child: Icon(Icons.local_hospital_outlined, size: 48, color: Colors.grey)),
                ),
                SizedBox(height: 16),
                Text(
                  'Chưa có lịch uống thuốc nào',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF697282),
                    fontSize: 16,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hãy thêm lịch uống thuốc cho cha mẹ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF697282),
                    fontSize: 14,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAppointmentsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Color(0x19000000), blurRadius: 2, offset: Offset(0, 1), spreadRadius: -1),
          BoxShadow(color: Color(0x19000000), blurRadius: 3, offset: Offset(0, 1), spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lịch hẹn sắp tới',
            style: TextStyle(
              color: const Color(0xFF101727),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Opacity(
                  opacity: 0.30,
                  child: SizedBox(width: 48, height: 48, child: Icon(Icons.calendar_today_outlined, size: 48, color: Colors.grey)),
                ),
                SizedBox(height: 16),
                Text(
                  'Không có lịch hẹn nào sắp tới',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF697282),
                    fontSize: 16,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}