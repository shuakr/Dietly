import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'screens/login_screen.dart'; // Giriş ekranını import ediyoruz
import 'screens/register_screen.dart'; // Kayıt ekranını import ediyoruz
import 'screens/profile_creation_screen.dart'; // Profil oluşturma ekranını import ediyoruz
import 'screens/splash_screen.dart'; // Yükleme ekran animasyon dosyasını import ediyoruz.
=======
import 'screens/login_screen.dart'; // Ekranımızı import ediyoruz
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
>>>>>>> develop


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
      title: 'Dietly',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
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