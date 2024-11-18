import 'package:flutter/material.dart';
import 'package:sample_task/views/dashboard_screen.dart';
import 'package:sample_task/views/last_login_screen.dart';
import 'package:sample_task/views/login_screen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login with Phone App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/last_login': (context) => LastLoginScreen(),
      },
    );
  }
}
