import 'package:flutter/material.dart';
import 'package:dietly/widgets/salomon_bottom_bar.dart'; //Import bottom shape

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
        onTap: (index) {
          if (index == 3) {
            // TODO: Firebase çıkış işlemi buraya eklenecek
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}
