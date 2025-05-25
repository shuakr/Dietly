import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/salomon_bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _userProfile;
  bool _isEditing = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      if (kDebugMode) print('User not logged in.');
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('profiles')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _userProfile = querySnapshot.docs.first.data();
          _fullNameController.text = _userProfile?['fullName'] ?? '';
          _birthDateController.text = _userProfile?['birthDate'] ?? '';
          _heightController.text = _userProfile?['height']?.toString() ?? '';
          _weightController.text = _userProfile?['weight']?.toString() ?? '';
          _selectedGender = _userProfile?['gender'];
        });
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching user profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil yüklenirken hata oluştu: $e')),
        );
      }
    }
  }

  Future<void> _updateUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      if (kDebugMode) print('User not logged in.');
      return;
    }

    if (_fullNameController.text.isEmpty ||
        _birthDateController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurunuz.')),
      );
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('profiles')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final profileDocId = querySnapshot.docs.first.id;
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('profiles')
            .doc(profileDocId)
            .update({
          'fullName': _fullNameController.text.trim(),
          'birthDate': _birthDateController.text.trim(),
          'height': double.tryParse(_heightController.text.trim()) ?? 0.0,
          'weight': double.tryParse(_weightController.text.trim()) ?? 0.0,
          'gender': _selectedGender,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isEditing = false;
          _fetchUserProfile();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil başarıyla güncellendi!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Güncellenecek profil bulunamadı.')),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error updating user profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil güncellenirken hata oluştu: $e')),
        );
      }
    }
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

  Widget _buildProfileInfoRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Padding arttırıldı
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28), // Icon boyutu arttırıldı
              const SizedBox(width: 20), // Boşluk arttırıldı
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16, // Etiket font boyutu arttırıldı
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6), // Boşluk arttırıldı
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 18, // Değer font boyutu arttırıldı
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B0010),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0), // Çizginin üstüne boşluk eklendi
            child: Divider(
              color: Color(0xFFD4B499), // Uyumlu bir renk seçildi
              thickness: 1.5, // Çizgi kalınlığı arttırıldı
              indent: 0, // Sol boşluk
              endIndent: 0, // Sağ boşluk
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(fontSize: 16), // Editable alan font boyutu arttırıldı
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
          prefixIcon: Icon(icon, color: const Color(0xFF6B0010), size: 24), // Icon boyutu arttırıldı
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding arttırıldı
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF6B0010);
    const bgColor = Color(0xFFF1E7DD);

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: const CustomBottomNavBar(initialIndex: 2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF6B0010).withAlpha((255 * 0.75).round()),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(51, 0, 0, 0),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 50,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(_isEditing ? Icons.save : Icons.edit,
                          color: mainColor),
                      onPressed: () {
                        setState(() {
                          if (_isEditing) {
                            _updateUserProfile();
                          }
                          _isEditing = !_isEditing;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/dietlylogo.png'),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                _userProfile?['fullName'] ?? 'İsim Yükleniyor...',
                style: const TextStyle(
                    fontSize: 24, // İsim font boyutu arttırıldı
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
              const SizedBox(height: 24),
              _isEditing
                  ? Column(
                children: [
                  _buildEditableField(
                      controller: _fullNameController,
                      label: 'Tam Ad',
                      icon: FontAwesomeIcons.user),
                  _buildEditableField(
                    controller: _birthDateController,
                    label: 'Doğum Tarihi (GG/AA/YYYY)',
                    icon: FontAwesomeIcons.calendar,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.date_range, color: mainColor),
                        onPressed: () => _selectDate(context)),
                  ),
                  _buildEditableField(
                      controller: _heightController,
                      label: 'Boy (cm)',
                      icon: FontAwesomeIcons.rulerVertical,
                      keyboardType: TextInputType.number),
                  _buildEditableField(
                      controller: _weightController,
                      label: 'Kilo (kg)',
                      icon: FontAwesomeIcons.weightScale,
                      keyboardType: TextInputType.number),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Cinsiyet',
                        labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        prefixIcon: const Icon(FontAwesomeIcons.venusMars, color: mainColor, size: 24),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Erkek', style: TextStyle(color: mainColor, fontSize: 16)),
                              value: 'Erkek',
                              groupValue: _selectedGender,
                              onChanged: (value) =>
                                  setState(() => _selectedGender = value),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Kadın', style: TextStyle(color: mainColor, fontSize: 16)),
                              value: 'Kadın',
                              groupValue: _selectedGender,
                              onChanged: (value) =>
                                  setState(() => _selectedGender = value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  _buildProfileInfoRow(
                      'Doğum Tarihi',
                      _userProfile?['birthDate'] ?? 'N/A',
                      FontAwesomeIcons.calendar,
                      mainColor),
                  _buildProfileInfoRow(
                      'Boy',
                      (_userProfile?['height']?.toString() ?? 'N/A') + ' cm',
                      FontAwesomeIcons.rulerVertical,
                      mainColor),
                  _buildProfileInfoRow(
                      'Kilo',
                      (_userProfile?['weight']?.toString() ?? 'N/A') + ' kg',
                      FontAwesomeIcons.weightScale,
                      mainColor),
                  _buildProfileInfoRow(
                      'Cinsiyet',
                      _userProfile?['gender'] ?? 'N/A',
                      FontAwesomeIcons.venusMars,
                      mainColor),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}