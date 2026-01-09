import 'package:duan_antam/features/parent_home/screens/parent_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../services/firebase_service.dart';

// [QUAN TRỌNG] Import màn hình chính của Con và Cha Mẹ vào đây
import '../../child_dashboard/screens/an_tam_con_dashboard.dart';
// import '../../parent_dashboard/screens/an_tam_cha_me_dashboard.dart'; // Bỏ comment dòng này khi bạn đã tạo màn hình Cha Mẹ

class LinkFamilyScreen extends StatefulWidget {
  final bool isCarer; // True = Con, False = Cha Mẹ
  const LinkFamilyScreen({super.key, required this.isCarer});

  @override
  State<LinkFamilyScreen> createState() => _LinkFamilyScreenState();
}

class _LinkFamilyScreenState extends State<LinkFamilyScreen> {
  final _codeController = TextEditingController();
  String? _generatedCode;
  bool _isLoading = false;
  String? _errorMessage; // Biến lưu lỗi để hiển thị lên màn hình

  @override
  void initState() {
    super.initState();
    if (widget.isCarer) {
      _createFamily();
    }
  }

  // --- LOGIC TẠO MÃ CHO CON ---
  Future<void> _createFamily() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      String code = await FirebaseService.createFamilyGroup('carer', 'Con Cái');
      if (mounted) setState(() => _generatedCode = code);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = "Lỗi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- LOGIC NHẬP MÃ CHO CHA MẸ ---
  Future<void> _joinFamily() async {
    if (_codeController.text.isEmpty) return;
    
    // Ẩn bàn phím
    FocusScope.of(context).unfocus();
    
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      await FirebaseService.joinFamilyGroup(_codeController.text, 'Cha Mẹ');
      
      if (mounted) {
        // [SỬA LỖI] Chuyển trang trực tiếp, không dùng Named Route để tránh lỗi
        // Tạm thời hiển thị thông báo thành công nếu chưa có màn hình Cha Mẹ
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Kết nối thành công! Đang vào màn hình chính..."), backgroundColor: Colors.green)
        );
        
        // KHI CÓ MÀN HÌNH CHA MẸ, HÃY MỞ DÒNG NÀY RA:
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ParentHomeScreen()),
        );
        
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = "Lỗi kết nối: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kết nối gia đình"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: widget.isCarer ? _buildCarerView() : _buildElderView(),
      ),
    );
  }

  Widget _buildCarerView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Mã gia đình của bạn", style: TextStyle(fontSize: 18, color: Colors.grey)),
        const SizedBox(height: 20),
        
        // Hiển thị Mã hoặc Lỗi hoặc Loading
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF155DFC).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF155DFC)),
          ),
          child: _isLoading 
              ? const CircularProgressIndicator()
              : (_errorMessage != null 
                  ? Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center)
                  : SelectableText(
                      _generatedCode ?? "...",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF155DFC), letterSpacing: 2),
                    )),
        ),
        
        const SizedBox(height: 20),
        const Text("Hãy nhập mã này vào máy của Cha/Mẹ để kết nối.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            // [SỬA LỖI] Chuyển trang trực tiếp
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AnTamConDashboard()),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF155DFC)),
            child: const Text("Vào Dashboard", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildElderView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.link, size: 80, color: Color(0xFF00A63E)),
        const SizedBox(height: 20),
        const Text("Nhập mã từ máy của Con", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        
        TextField(
          controller: _codeController,
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: "VD: AT-1234",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        
        // Hiển thị lỗi ngay dưới ô nhập nếu có
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
          ),

        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _joinFamily,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A63E)),
            child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white) 
              : const Text("KẾT NỐI NGAY", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}