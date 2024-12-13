import 'package:flutter/material.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/auth_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));// Navigate to login page after logout
    } catch (e) {
      _showMessage('Failed to sign out: ${e.toString()}');
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
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load saved theme preference
  void _loadTheme() {
    setState(() {
      isDarkMode = MyApp.of(context)?.themeMode == ThemeMode.dark;
    });
  }

  // Toggle theme and notify the app to update
  void _toggleTheme(bool value) {
    MyApp.of(context)?.toggleTheme(value);
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Appearance',
              //   style: Theme.of(context).textTheme.titleLarge,
              // ),
              // SwitchListTile(
              //   title: Text('Dark Mode'),
              //   value: isDarkMode,
              //   onChanged: _toggleTheme,
              //   activeColor: Theme.of(context).colorScheme.primary, // Color for the active switch
              //   activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5), // Color for the active track
              //   inactiveThumbColor: Theme.of(context).colorScheme.onSurface, // Color for the inactive switch
              //   inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3), // Color for the inactive track
              // ),
              ElevatedButton(
                onPressed: signOut,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.red.shade600,
                  shadowColor: Colors.red.shade200,
                  elevation: 4,
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
