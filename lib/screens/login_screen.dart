import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E3D3), // Arkaplan rengi (senin tasarımına uygun)
      body: Center(
        child: Text('Login Screen'), // Şimdilik sadece yazı
      ),
    );
  }
}
