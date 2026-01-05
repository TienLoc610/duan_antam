import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogin;
  const AuthScreen({super.key, required this.isLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  late bool _isLoginMode;

  @override
  void initState() {
    super.initState();
    _isLoginMode = widget.isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isLoginMode ? 'Đăng nhập' : 'Đăng ký',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF155DFC))),
            const SizedBox(height: 32),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Số điện thoại')),
            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu')),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/child_home'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF155DFC)),
                child: Text(_isLoginMode ? 'Vào ứng dụng' : 'Tạo tài khoản', style: const TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
              child: Text(_isLoginMode ? 'Chưa có tài khoản? Đăng ký' : 'Đã có tài khoản? Đăng nhập'),
            )
          ],
        ),
      ),
    );
  }
}