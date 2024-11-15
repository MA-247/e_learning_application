import 'package:e_learning_application/screens/about.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/faculty_side/testing_system/test_list_faculty_page.dart';
import 'package:e_learning_application/screens/faculty_side/learning_section/faculty_learning_section.dart';
import 'package:e_learning_application/screens/settings.dart';

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

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome back, ${user.displayName}',
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color, // Use theme text color for title
          ) ??
              TextStyle(
                color: theme.textTheme.bodyLarge?.color, // Fallback text color
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor ?? (isDarkMode ? Colors.grey[900] : Colors.blue[300]),
        toolbarHeight: 75,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.supervised_user_circle),
            color: theme.iconTheme.color, // Use theme icon color
          ),
        ],
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu),
            color: theme.iconTheme.color, // Use theme icon color for the menu button
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
            UserAccountsDrawerHeader(
              accountName: Text(
                user.displayName ?? 'Student',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(user.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user.displayName?.substring(0, 1).toUpperCase() ?? '',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, Colors.blueGrey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Log Out', style: TextStyle(color: Colors.red)),
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
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor, // Use the card color from the theme
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(Icons.book, color: theme.iconTheme.color),
                  title: Text(
                    'Learning Section',
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                  ),
                  subtitle: Text('Manage Lectures', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
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
                  color: theme.cardColor, // Use the card color from the theme
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(Icons.assignment, color: theme.iconTheme.color),
                  title: Text(
                    'Test Section',
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                  ),
                  subtitle: Text('Manage Tests', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
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
