import 'package:dietly/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOutAndNavigateToLogin(BuildContext context) async {
    //Firebase log out
    await FirebaseAuth.instance.signOut();

    //Google log out
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
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
    //Redirect to LogIn screen
    Navigator.of(context).pushAndRemoveUntil(
     MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) =>false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietly Home Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => _signOutAndNavigateToLogin(context),
              child: const Text('Logout!'),
            )
          ],
        ),
      ),
    );
  }
}