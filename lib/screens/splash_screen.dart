import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Animasyon için
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 saniye sonra yönlendirme
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animasyonu
            Lottie.asset('assets/animations/splash_screen.json', width: 200),
            const SizedBox(height: 20),
            Text(
              "Dietly",
              style: GoogleFonts.robotoSlab(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF800020),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
