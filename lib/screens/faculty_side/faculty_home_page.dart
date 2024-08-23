import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/faculty_side/testing_system/test_list_faculty_page.dart';
import 'package:e_learning_application/screens/faculty_side/learning_section/faculty_learning_section.dart';

class FacultyHomePage extends StatelessWidget {
  final User user;

  FacultyHomePage({required this.user});

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> fetchFieldFromDocument() async {
    if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (doc != null && doc!.exists) {
          // Replace "fieldName" with the name of the field you want to retrieve
          String? fieldValue = doc!.get('name');
          print("Field Value: $fieldValue");
          user.updateDisplayName(fieldValue);
        } else {
          print("Document does not exist.");
        }
      } else {
        print("No user is signed in.");
      }
  }


  @override

  Widget build(BuildContext context) {
    if (user.displayName == null)
      fetchFieldFromDocument();
    return Scaffold(
      appBar: AppBar(title: Text('Welcome back, ${user.displayName}',
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        toolbarHeight: 75,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.supervised_user_circle), color: Colors.white,),

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
                        'Pulpath',
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
                          builder: (context) => FacultyHomePage(user: user)),
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

            // Other UI elements

            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1), // Adjust the opacity and color as needed
                  borderRadius: BorderRadius.circular(10.0), // Optional: Add border radius for rounded corners
                ),
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Optional: Adjust margins
                child: ListTile(
                  title: Text('Learning Section'),
                  subtitle: Text('Manage Lectures'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageTopicsPage(user: user))
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1), // Adjust the opacity and color as needed
                  borderRadius: BorderRadius.circular(10.0), // Optional: Add border radius for rounded corners
                ),
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Optional: Adjust margins
                child: ListTile(
                  title: Text('Test Section'),
                  subtitle: Text('Manage Tests'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TestListPage())
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
