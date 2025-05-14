import 'package:flutter/material.dart';
import 'package:dietly/service/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _handleGoogleSignIn(BuildContext context) async {
    final userCredential = await AuthService().signInWithGoogle();

    if (userCredential != null) {
      // Giriş başarılıysa yönlendir
      Navigator.pushReplacementNamed(context, '/profileCreation');
    } else {
      // Giriş başarısızsa kullanıcıya göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _handleGoogleSignIn(context),
          icon: Image.asset(
            'assets/google_logo.png', // Google logosunu eklemeyi unutma
            height: 24,
            width: 24,
          ),
          label: Text("Sign in with Google"),
        ),
      ),
    );
  }
}
