import 'package:e_learning_application/screens/about.dart';
import 'package:e_learning_application/screens/student_side/student_profile/profile_page.dart';
import 'package:e_learning_application/screens/student_side/testing_system/scores_pages/topics_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/student_side/learning_section/student_topics_list_page.dart';
import 'package:e_learning_application/screens/settings.dart';
import 'package:e_learning_application/screens/student_side/learning_section/module_lecture_selection_page.dart';

class StudentHomePage extends StatelessWidget {
  final User user;

  StudentHomePage({required this.user});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome back, ${user.displayName}',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 10.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(user: user),
                ),
              );
            },
            icon: Icon(
              Icons.account_circle_outlined,
              color: theme.appBarTheme.iconTheme?.color,
            ),
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: theme.appBarTheme.iconTheme?.color,
              ),
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
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(user.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: theme.colorScheme.onPrimary,
                child: Text(
                  user.displayName?.substring(0, 1).toUpperCase() ?? '',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.colorScheme.secondary,
                  ],
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info,
              text: 'About',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.exit_to_app,
              text: 'Log Out',
              color: theme.colorScheme.error,
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LearningModeSelection(),
                ),
              ),
            ),
            _buildSectionTile(
              context: context,
              icon: Icons.assignment,
              title: 'Test Scores',
              subtitle: 'Tap to view your test scores',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ScoresTopicsListPage(userId: user.uid),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String text, required Function() onTap, Color? color}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? theme.iconTheme.color,
      ),
      title: Text(
        text,
        style: theme.textTheme.bodyMedium,
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850] : theme.cardColor;
    final iconColor = theme.primaryColor;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black54
                  : Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, size: 40, color: iconColor),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodyMedium,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
