import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() {
  runApp(const MaterialApp(home: TestNav()));
}

class TestNav extends StatefulWidget {
  const TestNav({super.key});

  @override
  State<TestNav> createState() => _TestNavState();
}

class _TestNavState extends State<TestNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Test Nav")),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
