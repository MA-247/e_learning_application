import 'package:e_learning_application/screens/auth/login_or_register.dart';
import 'package:e_learning_application/screens/student_side/student_home_page.dart';
import 'package:e_learning_application/screens/faculty_side/faculty_home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/services/auth_service.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key, this.onTap});
  final Function()? onTap;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User logged in
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return FutureBuilder<int?>(
              future: _authService.getUserRole(user.uid), // Updated method name
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (roleSnapshot.hasError) {
                  return Center(child: Text('Error: ${roleSnapshot.error}'));
                } else {
                  int? userRole = roleSnapshot.data;
                  if (userRole == 2) { // Check for faculty
                    print(user.displayName);
                    return FacultyHomePage(user: user);
                  } else if (userRole == 1) { // Check for student
                    return StudentHomePage(user: user);
                  } else {
                    print("Error in role-based login");
                    return LoginOrRegister();
                  }
                }
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
