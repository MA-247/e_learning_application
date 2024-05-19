import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/widgets/text_field.dart';
import 'package:e_learning_application/widgets/button.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signUp() async {
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);

      displayMessage("Passwords Don't Match. Try Again.");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(nameTextController.text);
        await user.reload();
        user = _auth.currentUser;
        print("User registered with name: ${user?.displayName}");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    //logo
                    Icon(
                      Icons.lock,
                      size: 100,
                    ),
                    //welcome text
                    const SizedBox(height: 25),

                    Text(
                      "Let's Create an Account!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 5),

                    //textfield
                    MyTextField(
                        controller: nameTextController,
                        hintText: 'Your Name',
                        obscureText: false
                    ),
                    const SizedBox(height: 5,),
                    MyTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),
                    //password textflied

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
                    SizedBox(height: 5),
                    //registration option
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
                          child: Text(
                            "Login In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        ));
  }
}
