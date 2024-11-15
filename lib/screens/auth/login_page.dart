import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_application/widgets/button.dart';
import 'package:e_learning_application/widgets/text_field.dart';
import 'package:e_learning_application/widgets/password_text_field.dart';
import 'package:e_learning_application/services/auth_service.dart';
import 'package:e_learning_application/screens/student_side/student_home_page.dart';
import 'package:e_learning_application/screens/faculty_side/faculty_home_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false; // Track login progress

  void signIn() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // DEBUG: Check if the user is authenticated
        print("User authenticated: ${user.email}");

        // Check if the email is verified
        if (!user.emailVerified) {
          displayMessage("Please verify your email before logging in.");
          await FirebaseAuth.instance.signOut(); // Sign out if not verified
          await user.sendEmailVerification(); // Resend verification email
          return;
        }

        // Get user role
        int? userRole = await _authService.getUserRole(user.uid);
        print(userRole);
        if (userRole != null) {
          print("User role: $userRole");
          if (userRole == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => FacultyHomePage(user: user)),
            );
          } else if (userRole == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => StudentHomePage(user: user)),
            );
          } else {
            displayMessage("User role not recognized.");
            await FirebaseAuth.instance.signOut();
          }
        } else {
          displayMessage("Unable to retrieve user role.");
        }
      }
    } on FirebaseAuthException catch (e) {
      displayMessage(e.message ?? "An error occurred");
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }


  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
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
      backgroundColor: colorScheme.surface, // Dynamic background color
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  Image.asset(
                    'assets/logos/logo1.png',
                    height: 200,
                    width: 300,
                  ),
                  const SizedBox(height: 10),
                  // Email text field
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  // Password text field
                  PasswordTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    textColor: textColor,
                    fillColor: colorScheme.surface,
                  ),
                  const SizedBox(height: 15),
                  // Sign in button with loading state
                  isLoading
                      ? CircularProgressIndicator(
                    color: colorScheme.primary, // Loading spinner color
                  )
                      : MyButton(
                    onTap: signIn,
                    text: 'Sign In',
                  ),
                  const SizedBox(height: 25),
                  // Registration option
                  GestureDetector(
                    onTap: widget.onTap,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Not a member? ",
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                          TextSpan(
                            text: "Register Now",
                            style:Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Footer
                  Text(
                    "Pulpath",
                    style: Theme.of(context).textTheme.bodyLarge,
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
