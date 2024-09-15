import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/widgets/text_field.dart';
import 'package:e_learning_application/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/widgets/drop_down_menu.dart'; // Import the updated dropdown widget

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final cityTextController = TextEditingController();
  final yearOfStudyTextController = TextEditingController();
  final FirebaseFirestore _db_firestore = FirebaseFirestore.instance;

  // University drop-down menu options
  List<String> universities = [];
  String? selectedUniversity;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUniversities(); // Fetch universities from Firebase
  }

  Future<void> _fetchUniversities() async {
    try {
      QuerySnapshot snapshot = await _db_firestore.collection('universities').get();
      List<String> fetchedUniversities = snapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        universities = fetchedUniversities;
      });
    } catch (e) {
      displayMessage('Failed to load universities: ${e.toString()}');
    }
  }

  void signUp() async {
    if (passwordTextController.text != confirmPasswordTextController.text) {
      displayMessage("Passwords Don't Match. Try Again.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Register the user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(nameTextController.text);

        // Send email verification
        await user.sendEmailVerification();

        // Store user information in Firestore
        await _db_firestore.collection('users').doc(user.uid).set({
          'name': nameTextController.text,
          'email': emailTextController.text,
          'city': cityTextController.text,
          'university': selectedUniversity,
          'yearOfStudy': yearOfStudyTextController.text,
          'faculty': false,
        });

        displayMessage(
            'Registration successful! A verification email has been sent to your email. Please verify your email before logging in.');
      }
      else{
        displayMessage("An error occured with the registration!");
      }
    } on FirebaseAuthException catch (e) {
      displayMessage(e.message ?? 'An error occurred during registration.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void displayMessage(String message) {
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
      backgroundColor: Colors.grey.shade100, // Light grey background for a soft look
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: _isLoading
                  ? const CircularProgressIndicator() // Display loading indicator
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  Image.asset(
                    'assets/logos/logo1.png',
                    height: 120,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                      fontSize: 28,
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
                  MyTextField(
                    controller: yearOfStudyTextController,
                    hintText: 'Year of Study',
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
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  MyButton(onTap: signUp, text: 'Sign Up'),
                  const SizedBox(height: 20),
                  // Login option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                "Already a Member?",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: widget.onTap,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue.shade300),
                      color: Colors.blue.shade50,
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
