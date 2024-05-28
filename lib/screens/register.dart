import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/widgets/text_field.dart';
import 'package:e_learning_application/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final cityTextController = TextEditingController();
  final yearOfStudyTextController = TextEditingController();
  final universityTextController = TextEditingController();

  final FirebaseFirestore _db_firestore = FirebaseFirestore.instance;

  //university drop-down menu options
  final List<String> universities = [
    "Aga Khan University (AKU)",
    "Allama Iqbal Medical College (AIMC)",
    "Army Medical College (AMC)",
    "Ayub Medical College",
    "Bahria University Medical and Dental College",
    "Bolan Medical College",
    "Dow Medical College",
    "Fatima Jinnah Medical University",
    "FMH College of Medicine and Dentistry",
    "Khyber Medical College",
    "King Edward Medical University (KEMU)",
    "Liaquat University of Medical and Health Sciences",
    "Nishtar Medical University",
    "Quaid-e-Azam Medical College",
    "Rawalpindi Medical University",
    "Other"
  ];
  String? selectedUniversity;

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
      user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(nameTextController.text);
        await user.reload();
        await _db_firestore.collection('users').doc(user.uid).set({
          'name' : nameTextController.text,
          'email' : emailTextController.text,
          'city' : cityTextController.text,
          'university' : selectedUniversity,
          'yearOfStudy' : yearOfStudyTextController.text,
          'faculty' : false,
        });
        print("User registered with name: ${user.displayName}");

        //storing the additional information on firebase



          displayMessage('Registration Successful!');



      }
    } on FirebaseAuthException catch (e) {
      displayMessage(e.message ?? 'An error occurred during registration.');
      //Navigator.pop(context);
    }
    print('testing1');
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      //logo
                      Image.asset(
                        'assets/logos/logo1.png',
                        height: 100,
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
                      //city selection
                      MyTextField(
                        controller: cityTextController,
                        hintText: 'Your City',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: yearOfStudyTextController,
                        hintText: 'Year of Study',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedUniversity,
                        hint: Text('Select University'),
                        items: universities.map((String university) {
                          return DropdownMenuItem<String>(
                            value: university,
                            child: Text(university),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUniversity = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 10),


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
          ),
        ));
  }
}
