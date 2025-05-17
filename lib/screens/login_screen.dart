import 'package:dietly/screens/profile_creation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:dietly/widgets/bottom_shape.dart';
import 'package:dietly/screens/register_screen.dart';
import 'package:dietly/service/google_auth_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  // E-posta ve şifre alanları için controller'lar
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // E-posta/şifre ile giriş yapma işlemi
  Future<void> _signInWithEmailAndPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Firebase ile giriş yapma
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Giriş başarılı → profil oluşturma ekranına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileCreationScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Giriş başarısızsa hataya göre kullanıcıya mesaj göster
      String errorMessage = 'Bir hata oluştu.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Bu e-posta ile kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Şifre hatalı.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  // Google ile giriş işlemi
  Future<void> _handleGoogleSignIn() async {
    final googleAuthService = GoogleAuthService();
    final userCredential = await googleAuthService.signInWithGoogle();

    if (userCredential != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileCreationScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google ile giriş başarısız")),
      );
    }
  }
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileCreationScreen()),
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

void _handleGoogleSignIn(BuildContext context) async {
  final googleAuthService = GoogleAuthService();
  final userCredential = await googleAuthService.signInWithGoogle();

  if (userCredential != null) {
    // Giriş başarılı, profil oluşturma ekranına yönlendir
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfileCreationScreen()),
    );
  } else {
    // Giriş başarısız, kullanıcıya mesaj göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google ile giriş başarısız")),
    );
  }
}


