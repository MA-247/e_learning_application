import 'package:flutter/material.dart';

final ThemeData dentalAppTheme = ThemeData(
  primaryColor: const Color(0xFF008080),
  scaffoldBackgroundColor: const Color(0xFFF9F9F9),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF008080),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF2E8BC0),
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF008080),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFF333333),
      fontSize: 26,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF333333),
      fontSize: 18,
      fontFamily: 'Roboto',
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF666666),
      fontSize: 16,
      fontFamily: 'Roboto',
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF0F0F0),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF2E8BC0), width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFFF6F61), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.grey.shade200,
    elevation: 4,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF2E8BC0),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: const Color(0xFF008080),
    unselectedItemColor: Colors.grey.shade600,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    showUnselectedLabels: true,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF2E8BC0),
    linearTrackColor: Color(0xFFE0E0E0),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0xFF2E8BC0), // Accent color
    error: const Color(0xFFFF6F61),
    background: const Color(0xFFFFFFFF),
  ),
);

final ThemeData darkDentalAppTheme = ThemeData.dark().copyWith(
  primaryColor: const Color(0xFF005555),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF005555),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF005555),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.white70,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Colors.white60,
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF2E8BC0), width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF444444), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
    selectedItemColor: const Color(0xFF008080),
    unselectedItemColor: Colors.grey.shade500,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    showUnselectedLabels: true,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF2E8BC0),
    linearTrackColor: Color(0xFF444444),
  ),
);
