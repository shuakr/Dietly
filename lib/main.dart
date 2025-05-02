import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Giriş ekranını import ediyoruz
import 'screens/register_screen.dart'; // Kayıt ekranını import ediyoruz
import 'screens/profile_creation_screen.dart'; // Profil oluşturma ekranını import ediyoruz

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // When the app starts we see login page
      routes: {
        '/register': (context) => const RegisterPage(), // Route for register page
        '/profileCreation': (context) => const ProfileCreationScreen(), // Route for profile creation page
      },
      theme: ThemeData(
        primarySwatch: Colors.green, // Main theme color
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B4D3E), // Main AppBar color
        ),
      ),
    );
  }
}