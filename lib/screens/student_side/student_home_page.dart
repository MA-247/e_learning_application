import 'package:e_learning_application/screens/about.dart';
import 'package:e_learning_application/screens/student_side/student_profile/profile_page.dart';
import 'package:e_learning_application/screens/student_side/testing_system/scores_pages/topics_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/student_side/learning_section/student_topics_list_page.dart';
import 'package:e_learning_application/screens/settings.dart';

class StudentHomePage extends StatelessWidget {
  final User user;

  StudentHomePage({required this.user});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome back, ${user.displayName}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 10.0, // Adding shadow to the AppBar
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage(user: user)),
              );
            },
            icon: Icon(Icons.account_circle_outlined),
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              color: Theme.of(context).appBarTheme.iconTheme?.color,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                user.displayName ?? 'Student',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(user.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user.displayName?.substring(0, 1).toUpperCase() ?? '',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.blueGrey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home,
              text: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.settings,
              text: 'Settings',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info,
              text: 'About',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage())),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.exit_to_app,
              text: 'Log Out',
              color: Colors.red,
              onTap: signOut,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionTile(
              context: context,
              icon: Icons.book,
              title: 'Learning Section',
              subtitle: 'Tap to explore learning materials',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TopicsListPage())),
            ),
            _buildSectionTile(
              context: context,
              icon: Icons.assignment,
              title: 'Test Scores',
              subtitle: 'Tap to view your test scores',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScoresTopicsListPage(userId: user.uid)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String text, required Function() onTap, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSectionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Function() onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final iconColor = Theme.of(context).primaryColor;

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, size: 40, color: iconColor),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          onTap: onTap,
        ),
      ),
    );
  }
}
