import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/faculty_side/testing_system/test_list_faculty_page.dart';
import 'package:e_learning_application/screens/faculty_side/learning_section/faculty_learning_section.dart';

class FacultyHomePage extends StatelessWidget {
  final User user;

  FacultyHomePage({required this.user});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> fetchFieldFromDocument() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc != null && doc.exists) {
        String? fieldValue = doc.get('name');
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
    if (user.displayName == null) fetchFieldFromDocument();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome back, ${user.displayName}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        toolbarHeight: 75,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.supervised_user_circle),
            color: Colors.white,
          ),
        ],
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/logos/logo1.png'),
                      radius: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Pulpath',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FacultyHomePage(user: user)),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // Other UI elements
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(Icons.book, color: Colors.blue[300]),
                  title: Text(
                    'Learning Section',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Manage Lectures'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageTopicsPage(user: user)),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(Icons.assignment, color: Colors.blue[300]),
                  title: Text(
                    'Test Section',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Manage Tests'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TestListPage()),
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
