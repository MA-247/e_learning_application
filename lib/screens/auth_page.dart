import 'package:e_learning_application/screens/login_or_register.dart';
import 'package:e_learning_application/screens/student_home_page.dart';
import 'package:e_learning_application/screens/faculty_home_page.dart';
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
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return FutureBuilder<bool?>(
              future: _authService.isFaculty(user.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (roleSnapshot.hasError) {
                  return Center(child: Text('Error: ${roleSnapshot.error}'));
                } else {
                  bool? isFaculty = roleSnapshot.data;
                  if (isFaculty == true) {
                    return FacultyHomePage();
                  } else if (isFaculty == false) {
                    return StudentHomePage(user: user);
                  }
                  else{
                    print("error in role based login");
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
