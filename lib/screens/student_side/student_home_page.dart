import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/student_side/learning_section/student_topics_list_page.dart';
import 'package:e_learning_application/screens/student_side/testing_system/scores_pages/topics_list.dart';
import 'package:e_learning_application/screens/student_side/notes_list_page.dart';
import 'package:e_learning_application/screens/student_side/student_profile/profile_page.dart';

class StudentHomePage extends StatefulWidget {
  final User user;

  StudentHomePage({required this.user});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TopicsListPage(), // Learning Section
      NotesListPage(), // Notes Page
      ScoresTopicsListPage(userId: widget.user.uid), // Test Scores
      UserProfilePage(user: widget.user), // Profile
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Scores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
