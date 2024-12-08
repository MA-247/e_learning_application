import 'package:flutter/material.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load saved theme preference
  void _loadTheme() {
    setState(() {
      isDarkMode = MyApp.of(context)?.themeMode == ThemeMode.dark;
    });
  }

  // Toggle theme and notify the app to update
  void _toggleTheme(bool value) {
    MyApp.of(context)?.toggleTheme(value);
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: isDarkMode,
              onChanged: _toggleTheme,
              activeColor: Theme.of(context).colorScheme.primary, // Color for the active switch
              activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5), // Color for the active track
              inactiveThumbColor: Theme.of(context).colorScheme.onSurface, // Color for the inactive switch
              inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3), // Color for the inactive track
            ),
          ],
        ),
      ),
    );
  }
}
