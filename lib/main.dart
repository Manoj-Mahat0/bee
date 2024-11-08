import 'package:bee/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gymify',
      theme: ThemeData(
        brightness: Brightness.dark, // Set the brightness to dark
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF1C1F1B), // Dark background color for scaffold
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1C1F1B), // Dark background color for AppBar
          iconTheme: IconThemeData(color: Colors.white), // Icon color in AppBar
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Title text style
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Default text color
          bodyMedium: TextStyle(color: Colors.white), // Default text color for body
        ),
      ),
      home: SplashScreen(),
    );
  }
}
