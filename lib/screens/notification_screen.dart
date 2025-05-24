import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E7D0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B0010),
        elevation: 0,
        title: const Text(
          'Bildirimler',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text('Bildirimler buraya gelecek'),
      ),
    );
  }
}
