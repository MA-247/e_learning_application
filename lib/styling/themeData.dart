import 'package:flutter/material.dart';

final ThemeData dentalAppTheme = ThemeData(
  primaryColor: const Color(0xFF008080),
  scaffoldBackgroundColor: const Color(0xFFF9F9F9),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF008080),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF2E8BC0),
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF008080),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFF333333), fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Color(0xFF333333), fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFF666666), fontSize: 14),
    bodySmall: TextStyle(color: Color(0xFF666666), fontSize: 12),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF0F0F0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2E8BC0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFF6F61)),
    ),
  ), colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0xFF2E8BC0), // Accent color
    error: const Color(0xFFFF6F61),
  ).copyWith(background: const Color(0xFFFFFFFF)),
);
