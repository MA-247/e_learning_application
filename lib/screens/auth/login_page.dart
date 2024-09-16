import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_application/widgets/button.dart';
import 'package:e_learning_application/widgets/text_field.dart';
import 'package:e_learning_application/widgets/password_text_field.dart';
import 'package:loading_btn/loading_btn.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
      if (user != null && !user.emailVerified) {
        displayMessage("Please verify your email before logging in.");
        await FirebaseAuth.instance
            .signOut(); // Sign out the user if email is not verified
        await user
            .sendEmailVerification(); // Optionally resend verification email
        return;
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
      builder: (context) =>
          AlertDialog(
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
    var colorScheme = Theme
        .of(context)
        .colorScheme; // Access current theme's color scheme
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
    // Text fields
    MyTextField(
    controller: emailTextController,
    hintText: 'Email',
    obscureText: false,
    // Use theme colors
    textColor: textColor,
    fillColor: colorScheme.surface,
    ),
    const SizedBox(height: 10),
    PasswordTextField(
    controller: passwordTextController,
    hintText: 'Password',
    textColor: textColor,
    fillColor: colorScheme.surface,
    ),
    const SizedBox(height: 15),
    // Sign in button
          isLoading
              ? CircularProgressIndicator()
              : GestureDetector(
            onTap: signIn,
            child: InkWell(
              onTap: signIn, // Handle tap
              borderRadius: BorderRadius.circular(10.0), // Add some border radius
              splashColor: Colors.teal.withOpacity(0.5), // Change the splash color to match the design
              child: MyButton(
                onTap: signIn,
                text: 'Sign In',
              ),
            ),
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
    style: TextStyle(
    color: Colors.grey[700],
    fontSize: 16,
    ),
    ),
    TextSpan(
    text: "Register Now",
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: colorScheme.primary, // Dynamic primary color
    fontSize: 16,
    decoration: TextDecoration.underline,
    ),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 50),
    Text(
    "Pulpath",
    style: TextStyle(
    color: textColor, // Dynamic text color
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
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
