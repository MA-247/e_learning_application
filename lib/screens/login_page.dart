import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_application/widgets/button.dart';
import 'package:e_learning_application/widgets/text_field.dart';

class LoginPage extends StatefulWidget{
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});
  @override

  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage>{
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void signIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
    } on FirebaseAuthException catch (e){
      displayMessage(e.code);
    }
  }

  void displayMessage(String message)
  {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title : Text(message),
        )
    );
  }

  @override

  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height : 50),
                    //logo
                    Image.asset(
                      'assets/logos/logo1.png',
                      height: 100,
                    ),
                    //welcome text
                    const SizedBox(height : 25),

                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,

                      ),
                    ),
                    SizedBox(height: 5,),

                    //textfield

                    MyTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      obscureText: false,),

                    const SizedBox(height: 10),
                    //password textfield

                    MyTextField(
                      controller: passwordTextController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                        onTap: signIn,
                        text: 'Sign In'
                    ),
                    SizedBox(height: 5,),
                    //registration option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not A Member?",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,

                            ),
                          ),
                        )
                      ],
                    )
                  ]



              ),
            ),
          ),
        )
    );
  }
}