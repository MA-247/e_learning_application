import 'package:e_learning_application/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/widgets/text_field.dart';
import 'package:e_learning_application/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/widgets/drop_down_menu.dart';

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
  final otherUniversityController = TextEditingController();
  final FirebaseFirestore _db_firestore = FirebaseFirestore.instance;

  // University drop-down menu options
  List<String> universities = [];
  String? selectedUniversity;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Loading state
  bool _isLoading = false;

  // University selection
  bool isOtherSelected = false;

  // Page controller for PageView
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchUniversities();
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

  // Function to check if fields are empty or invalid
  bool _areFieldsValid() {
    if (nameTextController.text.isEmpty || nameTextController.text.length < 3) {
      displayMessage("Name must be at least 3 characters.");
      return false;
    }
    if (emailTextController.text.isEmpty) {
      displayMessage("Email cannot be empty.");
      return false;
    }
    return true;
  }

  // Password validation based on industry standards
  bool _isPasswordValid() {
    String password = passwordTextController.text;
    if (password.length < 8) {
      displayMessage("Password must be at least 8 characters long.");
      return false;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      displayMessage("Password must contain at least one uppercase letter.");
      return false;
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      displayMessage("Password must contain at least one digit.");
      return false;
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      displayMessage("Password must contain at least one special character.");
      return false;
    }
    if (password != confirmPasswordTextController.text) {
      displayMessage("Passwords don't match.");
      return false;
    }
    return true;
  }

  void signUp() async {
    if (!_isPasswordValid()) return;

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
        Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the login screen

        await user.updateDisplayName(nameTextController.text);

        // Send email verification
        await user.sendEmailVerification();

        // Store user information in Firestore
        await _db_firestore.collection('users').doc(user.uid).set({
          'name': nameTextController.text,
          'email': emailTextController.text,
          'city': cityTextController.text,
          'university': isOtherSelected ? otherUniversityController.text : selectedUniversity,
          'yearOfStudy': yearOfStudyTextController.text,
          'faculty': false,
        });

        // Show success message and navigate to login page
        displayMessage('Registration successful! A verification email has been sent to your email. Please verify your email before logging in.', () {
          Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the login screen
        });
      } else {
        displayMessage("An error occurred with the registration!");
      }
    } on FirebaseAuthException catch (e) {
      displayMessage(e.message ?? 'An error occurred during registration.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void displayMessage(String message, [VoidCallback? onDismiss]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call(); // Call the optional callback if provided
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable swipe navigation
        children: [
          // First page
          _buildFirstPage(colorScheme),
          // Second page
          _buildSecondPage(colorScheme),
          // Third page (password)
          _buildPasswordPage(colorScheme),
        ],
      ),
    );
  }

  Widget _buildFirstPage(ColorScheme colorScheme) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,// AppBar color matching the theme
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onTap, // Back to login screen
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: nameTextController,
                      hintText: 'Full Name',
                      obscureText: false,
                      textColor: colorScheme.onSurface,
                      fillColor: colorScheme.surface,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      obscureText: false,
                      textColor: colorScheme.onSurface,
                      fillColor: colorScheme.surface,
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: () {
                        if (_areFieldsValid()) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      text: 'Next',
                        primaryColor: colorScheme.primary,
                        secondaryColor: colorScheme.primaryContainer,
                        textColor: Colors.white,
                        rippleColor: Colors.teal, // Adjust ripple color
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPage(ColorScheme colorScheme) {
    // Define the list of year options
    final List<String> yearOptions = ['1', '2', '3', '4', '5'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                            child: MyTextField(
                              controller: cityTextController,
                              hintText: 'City',
                              obscureText: false,
                              textColor: colorScheme.onSurface,
                              fillColor: colorScheme.surface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                            child: EnhancedDropdown(
                              hintText: "Year of Study",
                              selectedValue: yearOfStudyTextController.text.isEmpty
                                  ? null
                                  : yearOfStudyTextController.text,
                              items: yearOptions,
                              onChanged: (String? value) {
                                setState(() {
                                  yearOfStudyTextController.text = value ?? '';
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                            child: EnhancedDropdown(
                              hintText: "University",
                              selectedValue: selectedUniversity,
                              items: universities,
                              onChanged: (String? value) {
                                setState(() {
                                  if (value == 'Other') {
                                    isOtherSelected = true;
                                  } else {
                                    isOtherSelected = false;
                                    selectedUniversity = value;
                                  }
                                });
                              },
                            ),
                          ),
                          if (isOtherSelected) // Conditionally render the additional field
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                              child: MyTextField(
                                controller: otherUniversityController,
                                hintText: 'Enter your university',
                                obscureText: false,
                                textColor: colorScheme.onSurface,
                                fillColor: colorScheme.surface,
                              ),
                            ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                            child: MyButton(
                              onTap: () {
                                if (_areFieldsValid()) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              text: 'Next',
                              primaryColor: colorScheme.primary,
                              secondaryColor: colorScheme.primaryContainer,
                              textColor: Colors.white,
                              rippleColor: Colors.teal, // Adjust ripple color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildPasswordPage(ColorScheme colorScheme) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password'),
        backgroundColor: colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    PasswordTextField(
                      controller: passwordTextController,
                      hintText: 'Password',
                      textColor: colorScheme.onSurface,
                      fillColor: colorScheme.surface,
                    ),
                    const SizedBox(height: 10),
                    PasswordTextField(
                      controller: confirmPasswordTextController,
                      hintText: 'Confirm Password',
                      textColor: colorScheme.onSurface,
                      fillColor: colorScheme.surface,
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: signUp,
                      text: 'Register',
                        primaryColor: colorScheme.primary,
                        secondaryColor: colorScheme.primaryContainer,
                        textColor: Colors.white,
                        rippleColor: Colors.teal, // Adjust ripple color
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
