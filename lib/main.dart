import 'package:e_learning_application/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_learning_application/screens/auth/auth_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_learning_application/styling/themeData.dart';
import 'package:e_learning_application/widgets/notes_taking/notes_taking_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  // This method allows access to MyApp's state from other parts of the app
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  // Public getter to access _themeMode
  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load the theme preference from SharedPreferences
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Save the theme preference
  Future<void> _saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Method to toggle the theme
  void toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
    _saveTheme(isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Learning App',
      theme: dentalAppTheme, // Use your custom light theme
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF2E8BC0),
        ),
      ), // Fallback to the default dark theme
      themeMode: _themeMode, // Choose theme mode based on user preference
      debugShowCheckedModeBanner: false,
      home: BaseScaffold(),
    );
  }
}

class BaseScaffold extends StatefulWidget {
  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();

  // Add this method to access BaseScaffold's state
  static _BaseScaffoldState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BaseScaffoldState>();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  bool _isStudent = false; // Default value for user role
  Widget _currentContent = SplashScreen(); // Initial content is the splash screen

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            _isStudent = doc.data()?['role'] == 1;
          });
        }
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  void navigateToHome() {
    setState(() {
      _currentContent = AuthWrapper(); // Replace with AuthWrapper after splash
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentContent, // Dynamically updated content
        ],
      ),
      floatingActionButton: _isStudent
          ? MovableNotesButton(contextTag: "App") // Show Notes Button only for students
          : null,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));
    // Access BaseScaffold's state to replace the content
    BaseScaffold.of(context)?.navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/logos/logo1.png'), // Ensure this path is correct
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthPage(); // No need to wrap with another MaterialApp
  }
}
