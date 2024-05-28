import 'package:e_learning_application/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/login_or_register.dart';
import 'package:e_learning_application/screens/home_page.dart';
import 'package:e_learning_application/screens/login_page.dart';
class AuthPage extends StatelessWidget{
  AuthPage({super.key, this.onTap});
  final Function()? onTap;
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //user logged in
            if (snapshot.hasData) {
              return HomePage(user: snapshot.data!); //HomePage(user: snapshot.data!);
            }
            else {
              return const LoginOrRegister();
            }
          },
        )
    );
  }
}