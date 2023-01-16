import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.lightBlue,
      accentColor: Colors.orange
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.lightBlue,
      accentColor: Colors.orange
  );
}
