// lib/widgets/salomon_bottom_bar.dart
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Ana Sayfa"),
          selectedColor: Color(0xFF800020),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.notifications),
          title: const Text("Bildirimler"),
          selectedColor: Color(0xFF800020),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Profil"),
          selectedColor: Color(0xFF800020),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.logout),
          title: const Text("Çıkış"),
          selectedColor: Color(0xFF800020),
        ),
      ],
    );
  }
}
