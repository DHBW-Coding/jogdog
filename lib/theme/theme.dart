import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue, secondaryContainer: Colors.orangeAccent, brightness: Brightness.light),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent, secondaryContainer: Colors.orange, brightness: Brightness.dark),
    useMaterial3: true,
  );
}
