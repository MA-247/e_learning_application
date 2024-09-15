import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/widgets/text_field.dart'; // Your custom text field widget
import 'package:e_learning_application/widgets/button.dart'; // Your custom button widget
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
  final universityTextController = TextEditingController(); // Replace with dropdown in UI
  final List<String> universities = [];
  String? selectedUniversity;
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
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Update Firebase Authentication user details
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade800,
                child: Text(
                  widget.user.displayName?.substring(0, 1) ?? '',
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // TextFields
              MyTextField(
                controller: nameTextController,
                hintText: 'Full Name',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: emailTextController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: cityTextController,
                hintText: 'City',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              // Enhanced Dropdown for University
              EnhancedDropdown(
                selectedValue: selectedUniversity,
                items: universities,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUniversity = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Save Button
              _isLoading
                  ? CircularProgressIndicator()
                  : MyButton(
                onTap: _updateProfile,
                text: 'Save Changes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
