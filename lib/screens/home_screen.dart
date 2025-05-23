// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../widgets/salomon_bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietly Home'),
        centerTitle: true,
      ),
      body: const Center(child: Text('Ana Sayfa')),
      bottomNavigationBar: CustomBottomNavBar(initialIndex: 0),
    );
  }
}
