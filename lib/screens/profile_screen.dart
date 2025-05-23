
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF6B0010);
    const bgColor = Color(0xFFF5E7D0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: mainColor),
                    onPressed: () {
                      if (kDebugMode) {
                        print("Profile edit button pressed.");
                      }
                    },
                  )

                ],
              ),
            ),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              "Name and Surname",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(0.1 as int),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Mesaj Gönder",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(0.1 as int),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Takip Et",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade300,
              child: const Text(
                "Buralara da satır satır kullanıcıdan aldığımız bilgiler girilecek iconlar kullanılabilir şık bir görünüm olur.",
                style: TextStyle(fontSize: 14),
              ),
            ),
            const Spacer(),
            Container(
              height: 90,
              color: mainColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.home, color: Colors.white, size: 32),
                  Icon(Icons.notifications, color: Colors.white, size: 32),
                  Icon(Icons.person, color: Colors.white, size: 32),
                  Icon(Icons.settings, color: Colors.white, size: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
