// Dosya: profile_creation_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dietly/service/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dietly/widgets/bottom_shape.dart';
import 'login_screen.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _fullNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _selectedGender;
  IconData? _selectedProfileIcon;

  final List<IconData> _profileIcons = [
    FontAwesomeIcons.user,
    FontAwesomeIcons.heartPulse,
    FontAwesomeIcons.rulerVertical,
    FontAwesomeIcons.weightScale,
    FontAwesomeIcons.mars,
    FontAwesomeIcons.venus,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.personWalking,
  ];

  bool validateInputs(BuildContext context) {
    final fullName = _fullNameController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final heightText = _heightController.text.trim();
    final weightText = _weightController.text.trim();

    if (fullName.isEmpty || birthDate.isEmpty || heightText.isEmpty || weightText.isEmpty || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurunuz.')),
      );
      return false;
    }

    if (double.tryParse(heightText) == null || double.tryParse(weightText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Boy ve kilo geçerli sayılar olmalıdır.')),
      );
      return false;
    }

    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _showIconSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 200,
        child: GridView.builder(
          itemCount: _profileIcons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index) => IconButton(
            icon: Icon(_profileIcons[index], size: 30),
            onPressed: () {
              setState(() {
                _selectedProfileIcon = _profileIcons[index];
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _createProfile(bool isSelfProfile) async {
    if (!validateInputs(context)) return;

    final fullName = _fullNameController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final height = double.parse(_heightController.text.trim());
    final weight = double.parse(_weightController.text.trim());
    final gender = _selectedGender!;

    try {
      await FirestoreService().createUserProfile(
        fullName: fullName,
        birthDate: birthDate,
        height: height,
        weight: weight,
        gender: gender,
        isSelfProfile: isSelfProfile,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profil başarıyla kaydedildi.')),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (kDebugMode) print('❌ Firestore hatası: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Kayıt sırasında hata oluştu: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        title: const Text('Create a Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Align(alignment: Alignment.bottomCenter, child: BottomShape()),
          SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _showIconSelectionBottomSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Icon(
                      _selectedProfileIcon ?? FontAwesomeIcons.user,
                      size: 60,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(controller: _fullNameController, label: 'Full Name', hint: 'Your full name', icon: FontAwesomeIcons.user),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _birthDateController,
                  label: 'Date of Birth (DD/MM/YYYY)',
                  hint: 'DD/MM/YYYY',
                  icon: FontAwesomeIcons.calendar,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  suffixIcon: IconButton(icon: const Icon(Icons.date_range), onPressed: () => _selectDate(context)),
                ),
                const SizedBox(height: 16),
                _buildTextField(controller: _heightController, label: 'Height (cm)', icon: FontAwesomeIcons.rulerVertical, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(controller: _weightController, label: 'Weight (kg)', icon: FontAwesomeIcons.weightScale, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildGenderSelection(),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: _buildCreateButton(label: 'Create (Myself)', onPressed: () => _createProfile(true))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildCreateButton(label: 'Create (Other)', onPressed: () => _createProfile(false))),
                  ],
                ),
                TextButton(
                  onPressed: _logout,
                  child: const Text(
                    'Log Out!',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(FontAwesomeIcons.venusMars),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RadioListTile<String>(
              title: const Text('Erkek'),
              value: 'Erkek',
              groupValue: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              title: const Text('Kadın'),
              value: 'Kadın',
              groupValue: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF800020),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
