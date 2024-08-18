import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'take_test_page.dart';

class StudentHomePage extends StatelessWidget {
  final User user;

  StudentHomePage({required this.user});

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome back, ${user.displayName}', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.supervised_user_circle),
            color: Colors.white,
          ),
        ],
        leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
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
                decoration: BoxDecoration(color: Colors.white),
                child: Align(
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
                      MaterialPageRoute(builder: (context) => StudentHomePage(user: user)),
                    );
                  }
              ),
              ListTile(
                  title: Text('Log Out', style: TextStyle(color: Colors.red)),
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Available Tests'),
                  subtitle: Text('Tap to view and take tests'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestListPage()),
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

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Tests'),
        backgroundColor: Colors.blue[300],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tests').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              return ListTile(
                title: Text('Test ${index + 1}'),
                subtitle: Text('Tap to take the test'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakeTestPage(testData: test),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
