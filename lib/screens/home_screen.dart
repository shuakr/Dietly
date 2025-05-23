import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dietly/widgets/salomon_bottom_bar.dart'; //Import bottom shape
import 'package:firebase_auth/firebase_auth.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Ana Sayfa')),
    const Center(child: Text('Bildirimler')),
    const Center(child: Text('Profil')),
    const Center(child: Text('Çıkış')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietly Home'),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index == 3) {
            await FirebaseAuth.instance.signOut();

            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }

          } else {
            setState(() {
              _currentIndex = index;
            });
          }
          if (FirebaseAuth.instance.currentUser == null) {
            if (kDebugMode) {
              print('✅ Çıkış başarılı: currentUser == null');
            }
          } else {
            if (kDebugMode) {
              print('❌ Çıkış başarısız: currentUser != null');
            }
          }

        },
      ),
    );
  }
}
