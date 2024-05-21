import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/learning_section.dart';
import 'package:e_learning_application/screens/quiz_section.dart';

class HomePage extends StatelessWidget {
  final User user;

  HomePage({required this.user});


  void signOut(){
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome back, ${user.displayName}',
      style: TextStyle(color: Colors.white),),
        centerTitle: true,
      backgroundColor: Colors.blue[300],
      actions: [
        IconButton(onPressed: signOut, icon: Icon(Icons.logout), color: Colors.white,),

      ],
    leading: Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: Icon(Icons.menu),
        color: Colors.white, // Change this to your desired color
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    }
      ),
    ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child:  Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Image.asset(
                        'assets/logos/logo1.png',
                        width: 75,
                        height: 75,
                        fit: BoxFit.contain,
                      ),
                    Text(
                      'AppName',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),

              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(user: user)),
                );
              }
            ),
            ListTile(
                title: Text('Log Out',
                style: TextStyle(color: Colors.red),),
                onTap: () {
                  signOut();
                }
            ),
          ],
        )
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150),

            // Other UI elements
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LearningSection(user: user)),
                );
              },
              child: Text('Learning Section'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        minimumSize: Size(double.infinity, 60),
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[300],
        ),
        alignment: Alignment.center,
        ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizSection(user: user)),
                );
              },
              child: Text('Quiz Section'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
                minimumSize: Size(double.infinity, 60),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300],
                ),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
