import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', 
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
        )
      ),
      home: const LoginScreen(),
    );
  }
}