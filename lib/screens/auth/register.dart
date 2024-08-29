import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/widgets/text_field.dart';
import 'package:e_learning_application/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(nameTextController.text);
        await user.reload();
        await _db_firestore.collection('users').doc(user.uid).set({
          'name': nameTextController.text,
          'email': emailTextController.text,
          'city': cityTextController.text,
          'university': selectedUniversity,
          'yearOfStudy': yearOfStudyTextController.text,
          'faculty': false,
        });

        displayMessage('Registration Successful!');
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    height: 100,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Let's Create an Account!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // TextFields
                  MyTextField(
                    controller: nameTextController,
                    hintText: 'Your Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: cityTextController,
                    hintText: 'Your City',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: yearOfStudyTextController,
                    hintText: 'Year of Study',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedUniversity,
                    hint: const Text('Select University'),
                    items: universities.map((String university) {
                      return DropdownMenuItem<String>(
                        value: university,
                        child: Text(university),
                      );
                    }).toList(),
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
                  const SizedBox(height: 10),
                  MyButton(onTap: signUp, text: 'Sign Up'),
                  const SizedBox(height: 5),
                  // Registration option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a Member?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
