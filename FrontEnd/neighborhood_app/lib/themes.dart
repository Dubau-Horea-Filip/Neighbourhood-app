import 'package:flutter/material.dart';

class AppTheme {


  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 8, 133, 52),
    ),
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    primarySwatch: Colors.green,
  );

  static final ThemeData DarkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 5, 81, 32),
    ),
    backgroundColor: Color.fromARGB(255, 19, 24, 20),
  );

  
}
