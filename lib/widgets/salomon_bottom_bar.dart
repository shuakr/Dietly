// lib/widgets/salomon_bottom_bar.dart

import 'package:dietly/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../screens/home_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavBar({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _navigateWithAnimation(Widget page) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) async {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        _navigateWithAnimation(const HomeScreen());
        break;
      case 1:
        debugPrint("🔔 Notifications button pressed");
        break;
      case 2:
        _navigateWithAnimation(const ProfilePage());
        break;
      case 3:
        await FirebaseAuth.instance.signOut();
        if (FirebaseAuth.instance.currentUser == null && context.mounted) {
          debugPrint('✅ Logout successful');
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          debugPrint('❌ Logout failed');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: _onItemTapped,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: const Color(0xFF6B0010),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.notifications),
          title: const Text("Notifications"),
          selectedColor: const Color(0xFF6B0010),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Profile"),
          selectedColor: const Color(0xFF6B0010),
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.logout),
          title: const Text("Logout"),
          selectedColor: const Color(0xFF6B0010),
        ),
      ],
    );
  }
}
