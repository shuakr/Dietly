// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../widgets/salomon_bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E7DD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top:24.0, bottom:12),
                  child: Center(
                    child: Center(
                      child: Image.asset(
                          "assets/dietlylogo.png",
                          height:280,
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(initialIndex: 0),
    );
  }
}
