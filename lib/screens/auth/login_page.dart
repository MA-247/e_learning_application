import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_application/widgets/button.dart';
import 'package:e_learning_application/widgets/text_field.dart';
import 'package:e_learning_application/widgets/password_text_field.dart';
import 'package:e_learning_application/services/auth_service.dart';
import 'package:e_learning_application/screens/student_side/student_home_page.dart';
import 'package:e_learning_application/screens/faculty_side/faculty_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<void> checkFirstTimeLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

    if (isFirstLogin) {
      // Show pop-up dialog for the first-time login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Welcome!"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Text(
                  'Pulpath is an innovative e-learning application designed specifically for undergraduate dental students for the module of Pathogenesis of Pulp and Periapical Pathologies. Our goal is to enhance the learning experience through digital simulations and effective assessment methods. The app integrates modern educational techniques to make studying more engaging and efficient.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Our Vision',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Our mission is to provide accessible, advanced technology-enhanced dental learning experiences with the aim of better learning outcomes. We are committed to continuously enhancing our application based on user feedback.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Fiction Contract',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8.0),
                Text(
                  "During the following virtual simulation, you will interact with characters and situations based on clinical encounters. Virtual simulation fosters an environment for active engagement in a relatively safe environment. As the creators of the virtual simulation, we do all that we can to make the simulation as accurate as possible. We recognize that some aspects could be more realistic. We ask you to engage with the simulation, healthcare team members, and clients as if they were real. Using these simulated experiences this way provides you with an active learning opportunity.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Confidentiality Contract',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8.0),
                Text(
                  "During the virtual simulation, we ask that you be non-judgmental and open to learning from the simulation. It is important to remember that what happens in the simulation stays in the simulation. Maintaining confidentiality related to virtual simulation experiences and others' choices or comments helps create a psychologically safe learning environment.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Psychological Safety and Sensitive Content',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8.0),
                Text(
                  "The following virtual simulation may have potentially disturbing content and is designed for learners. If you have any unsettled feelings during or after the virtual simulation, contact your educator or counseling services at your institution.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          )
          ,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // Mark that the user has logged in before
      await prefs.setBool('isFirstLogin', false);
    }
  }

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
        print("User authenticated: ${user.email}");

        // Check if the email is verified
        if (!user.emailVerified) {
          displayMessage("Please verify your email before logging in.");
          await FirebaseAuth.instance.signOut(); // Sign out if not verified
          await user.sendEmailVerification(); // Resend verification email
          return;
        }

        // Check if it's the user's first login
        await checkFirstTimeLogin();

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
                    fillColor: colorScheme.surface,
                    textColor: textColor,
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
