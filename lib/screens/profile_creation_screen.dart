import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Font Awesome ikonları için
import 'package:dietly/widgets/bottom_shape.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _showIconSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: _profileIcons.length,
            itemBuilder: (context, index) {
              final iconData = _profileIcons[index];
              return IconButton(
                icon: Icon(iconData, size: 30),
                onPressed: () {
                  setState(() {
                    _selectedProfileIcon = iconData;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D6),
      resizeToAvoidBottomInset: true, // Klavye ile taşmayı önlemek için
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        title: const Text(
          'Create a Profile',
          style: TextStyle(color: Colors.white
          ),
        ),
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomShape(),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _showIconSelectionBottomSheet(context),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Icon(
                      _selectedProfileIcon ?? FontAwesomeIcons.user,
                      size: 60,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  hint: 'Your full name',
                  icon: FontAwesomeIcons.user,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  controller: _birthDateController,
                  label: 'Date of Birth (DD/MM/YYYY)',
                  hint: 'DD/MM/YYYY',
                  icon: FontAwesomeIcons.calendar,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  controller: _heightController,
                  label: 'Height (cm)',
                  icon: FontAwesomeIcons.rulerVertical,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  controller: _weightController,
                  label: 'Weight (kg)',
                  icon: FontAwesomeIcons.weightScale,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                _buildGenderSelection(),
                const SizedBox(height: 32.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildCreateButton(
                        label: 'Create(for myself)',
                        onPressed: () {
                          if (kDebugMode) {
                            print('Profile created(for myself).');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCreateButton(
                        label: 'Create(for other person)',
                        onPressed: () {
                          if (kDebugMode) {
                            print('Profile created(for other person).');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context,  '/login'); // veya: Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    'Back to Login',
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RadioListTile<String>(
              title: const Text('Male'),
              value: 'male',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              title: const Text('Female'),
              value: 'female',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
