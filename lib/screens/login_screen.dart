import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:dietly/widgets/bottom_shape.dart';
import 'package:dietly/screens/register_screen.dart';
import 'package:dietly/service/google_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _checkAndNavigateUser(User? user) async {
    if (user == null) {
      return;
    }

    try {
      final profileSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profiles')
          .limit(1)
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        if (mounted) {
          Navigator.pushNamed(context, '/home');
        }
      } else {
        if (mounted) {
          Navigator.pushNamed(context, '/profileCreation');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Profil kontrol edilirken hata oluştu: $e");
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil bilgileri kontrol edilirken hata oluştu.')),
        );
      }
    }
  }


  Future<void> _signInWithEmailAndPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _checkAndNavigateUser(userCredential.user);

    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Firebase Auth Hatası: ${e.code}");
      }

      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Bu e-posta ile kullanıcı bulunamadı.';
          break;
        case 'wrong-password':
          errorMessage = 'Şifre hatalı.';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi.';
          break;
        case 'invalid-credential':
          errorMessage = 'Kimlik bilgileri geçersiz. Lütfen e-posta ve şifrenizi kontrol edin.';
          break;
        default:
          errorMessage = 'Bir hata oluştu: ${e.code}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  // Sign in with Google
  Future<void> _handleGoogleSignIn() async {
    final googleAuthService = GoogleAuthService();
    final userCredential = await googleAuthService.signInWithGoogle();

    if (userCredential != null) {
      await _checkAndNavigateUser(userCredential.user);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google ile giriş başarısız")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5E6D6),
        resizeToAvoidBottomInset: false, //This prevents our design from interfering with movement with the keyboard.
        body: Stack(
            children: <Widget> [
              const Align(
                alignment: Alignment.bottomCenter,
                child: BottomShape(),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                          ),
                          Transform.scale(
                              scale: 4.250,
                              child:Image.asset(
                                'assets/dietlylogo.png',
                                height: 100,
                                width: 100,
                              )
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    const Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'you@example.com',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '********',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _signInWithEmailAndPassword();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF800020),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'SIGN IN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF800020),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'REGISTER',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Sign in with:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: const Icon(Bootstrap.google, color: Colors.white),
                      label: const Text(
                        'Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800020),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ]
        )
    );
  }
}