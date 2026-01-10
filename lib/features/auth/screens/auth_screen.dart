import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'link_family_screen.dart'; 

class AuthScreen extends StatefulWidget {
  final bool isLogin;
  final bool isCarer; 

  const AuthScreen({
    super.key, 
    required this.isLogin,
    this.isCarer = true, 
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  late bool _isLoginMode;
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _isLoginMode = widget.isLogin;
  }

  Future<void> _handleAuth() async {
    final phone = _phoneController.text.trim();
    final pass = _passController.text.trim();

    if (phone.isEmpty || pass.isEmpty) {
      _showError("Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    final email = "$phone@antam.com"; 

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
      }

      if (mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => LinkFamilyScreen(isCarer: widget.isCarer),
          ),
        );
      }

    } on FirebaseAuthException catch (e) {
      String message = "Lỗi: ${e.message}";
      if (e.code == 'user-not-found') message = "Tài khoản không tồn tại.";
      else if (e.code == 'wrong-password') message = "Sai mật khẩu.";
      else if (e.code == 'email-already-in-use') message = "Số điện thoại đã được đăng ký.";
      else if (e.code == 'weak-password') message = "Mật khẩu quá yếu.";
      _showError(message);
    } catch (e) {
      _showError("Lỗi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.isCarer ? const Color(0xFF155DFC) : const Color(0xFF00A63E);
    final String roleText = widget.isCarer ? "Con" : "Cha Mẹ";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isCarer ? Icons.health_and_safety : Icons.family_restroom,
                size: 80,
                color: primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                _isLoginMode ? 'Đăng nhập ($roleText)' : 'Đăng ký ($roleText)',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController, 
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passController, 
                obscureText: true, 
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _isLoginMode ? 'Vào ứng dụng' : 'Tạo tài khoản', 
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                child: Text(
                  _isLoginMode ? 'Chưa có tài khoản? Đăng ký ngay' : 'Đã có tài khoản? Đăng nhập',
                  style: TextStyle(color: primaryColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}