// File: lib/features/auth/screens/link_family_screen.dart
import 'package:flutter/material.dart';
import 'package:duan_antam/features/parent_home/screens/parent_home_screen.dart';
import 'package:duan_antam/services/firebase_service.dart'; // Đảm bảo đường dẫn import đúng
import 'package:duan_antam/features/child_dashboard/screens/an_tam_con_dashboard.dart';

class LinkFamilyScreen extends StatefulWidget {
  final bool isCarer; // True = Con (Người chăm sóc), False = Cha Mẹ
  const LinkFamilyScreen({super.key, required this.isCarer});

  @override
  State<LinkFamilyScreen> createState() => _LinkFamilyScreenState();
}

class _LinkFamilyScreenState extends State<LinkFamilyScreen> {
  final _codeController = TextEditingController();
  String? _generatedCode;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Nếu là Con (Carer), tự động kiểm tra xem có mã chưa
    if (widget.isCarer) {
      _initFamilyLogic();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // --- LOGIC CHO CON: LẤY MÃ CŨ HOẶC TẠO MỚI ---
  Future<void> _initFamilyLogic() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Gọi hàm thông minh getOrCreateFamily 
      String code = await FirebaseService.getOrCreateFamily('carer', 'Con Cái');

      if (mounted) {
        setState(() {
          _generatedCode = code;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = "Lỗi: $e");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- LOGIC CHO CHA MẸ: NHẬP MÃ ĐỂ KẾT NỐI ---
  Future<void> _joinFamily() async {
    if (_codeController.text.trim().isEmpty) {
       setState(() => _errorMessage = "Vui lòng nhập mã kết nối");
       return;
    }

    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Gọi hàm joinFamilyGroup trong Service
      await FirebaseService.joinFamilyGroup(
          _codeController.text.trim(), 'Cha Mẹ');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Kết nối thành công!"),
              backgroundColor: Colors.green),
        );

        // Chuyển sang màn hình Cha Mẹ
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
      appBar: AppBar(
        title: const Text("Kết nối gia đình"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        // Chọn giao diện dựa trên vai trò
        child: widget.isCarer ? _buildCarerView() : _buildElderView(),
      ),
    );
  }

  // --- GIAO DIỆN CON (HIỂN THỊ MÃ) ---
  Widget _buildCarerView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Mã gia đình của bạn",
            style: TextStyle(fontSize: 18, color: Colors.grey)),
        const SizedBox(height: 20),

        // Khung hiển thị mã
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF155DFC).withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF155DFC), width: 1.5),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (_errorMessage != null)
                      Text(_errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center)
                    else
                      SelectableText(
                        _generatedCode ?? "...",
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF155DFC),
                            letterSpacing: 4),
                      ),
                  ],
                ),
        ),

        const SizedBox(height: 20),
        const Text(
          "Hãy nhập mã này vào máy của Cha/Mẹ để kết nối.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        
        const Spacer(),
        
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AnTamConDashboard()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF155DFC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Vào Dashboard",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // --- GIAO DIỆN CHA MẸ (NHẬP MÃ) ---
  Widget _buildElderView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.phonelink_ring_rounded, 
              size: 100, color: Color(0xFF00A63E)),
          const SizedBox(height: 30),
          
          const Text("Nhập mã kết nối",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Mã được hiển thị trên máy của con",
              style: TextStyle(color: Colors.grey, fontSize: 16)),
          
          const SizedBox(height: 40),

          TextField(
            controller: _codeController,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters, // Tự viết hoa
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3),
            decoration: InputDecoration(
              hintText: "AT-XXXXX",
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF00A63E), width: 2)),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(_errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
            ),

          const SizedBox(height: 40),
          
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _joinFamily,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A63E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24, 
                      width: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("KẾT NỐI NGAY",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}