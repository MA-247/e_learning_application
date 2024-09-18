import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/widgets/drop_down_menu.dart'; // Your custom dropdown widget

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseFirestore _db_firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final cityTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final List<String> universities = [];
  String? selectedUniversity;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUniversities();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot snapshot = await _db_firestore.collection('users').doc(widget.user.uid).get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          nameTextController.text = data['name'] ?? '';
          emailTextController.text = data['email'] ?? '';
          cityTextController.text = data['city'] ?? '';
          selectedUniversity = data['university'];
        });
      }
    } catch (e) {
      _showMessage('Failed to load user data: ${e.toString()}');
    }
  }

  Future<void> _fetchUniversities() async {
    try {
      QuerySnapshot snapshot = await _db_firestore.collection('universities').get();
      List<String> fetchedUniversities = snapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        universities.addAll(fetchedUniversities);
      });
    } catch (e) {
      _showMessage('Failed to load universities: ${e.toString()}');
    }
  }

  Future<void> _updateProfile() async {
    if (passwordTextController.text != confirmPasswordTextController.text) {
      _showMessage('Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Update Firebase Authentication user details
        if (passwordTextController.text.isNotEmpty) {
          await user.updatePassword(passwordTextController.text);
        }
        await user.updateDisplayName(nameTextController.text);

        // Update Firestore user details
        await _db_firestore.collection('users').doc(user.uid).update({
          'name': nameTextController.text,
          'email': emailTextController.text,
          'city': cityTextController.text,
          'university': selectedUniversity,
        });

        _showMessage('Profile updated successfully!');
      } else {
        _showMessage('No user found.');
      }
    } catch (e) {
      _showMessage('Failed to update profile: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme; // Access current theme's color scheme
    var textColor = colorScheme.onSurface; // Dynamic text color

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.primary,
                child: Text(
                  widget.user.displayName?.substring(0, 1) ?? '',
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // TextFields
              _buildTextField(controller: nameTextController, hintText: 'Full Name', textColor: textColor, colorScheme: colorScheme),
              const SizedBox(height: 10),
              _buildTextField(controller: emailTextController, hintText: 'Email', textColor: textColor, colorScheme: colorScheme),
              const SizedBox(height: 10),
              _buildTextField(controller: cityTextController, hintText: 'City', textColor: textColor, colorScheme: colorScheme),
              const SizedBox(height: 10),
              // Password Fields
              _buildPasswordField(controller: passwordTextController, hintText: 'New Password (leave empty to keep current)', textColor: textColor, colorScheme: colorScheme, isVisible: _isPasswordVisible, onToggle: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
              const SizedBox(height: 10),
              _buildPasswordField(controller: confirmPasswordTextController, hintText: 'Confirm New Password', textColor: textColor, colorScheme: colorScheme, isVisible: _isConfirmPasswordVisible, onToggle: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              }),
              const SizedBox(height: 10),
              // University Dropdown
              EnhancedDropdown(
                items: universities,
                selectedValue: selectedUniversity,
                onChanged: (value) {
                  setState(() {
                    selectedUniversity = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Update Profile'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary,
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Color textColor,
    required ColorScheme colorScheme,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
        fillColor: colorScheme.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: textColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: textColor.withOpacity(0.5)),
        ),
      ),
      style: TextStyle(color: textColor),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required Color textColor,
    required ColorScheme colorScheme,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
        fillColor: colorScheme.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: textColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: textColor.withOpacity(0.5)),
        ),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
      style: TextStyle(color: textColor),
    );
  }
}
