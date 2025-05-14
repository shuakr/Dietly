import 'package:dietly/screens/profile_creation_screen.dart';
import 'package:dietly/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Ekranımızı import ediyoruz
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:dietly/screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Splash artık ilk açılıyor
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profileCreation': (context) => const ProfileCreationScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF800020),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5E6D6),
        ),
      ),
    );
  }
}
