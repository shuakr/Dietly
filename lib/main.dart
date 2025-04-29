import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Ekranımızı import ediyoruz

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // İşte burada LoginScreen'i açıyoruz
    );
  }
}
