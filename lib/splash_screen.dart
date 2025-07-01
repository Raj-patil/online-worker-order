import 'package:flutter/material.dart';
import 'login.dart'; // Import your login screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the login screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyLogin()), // Correct class name
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/splash_screen.png', // Ensure the correct path
          fit: BoxFit.cover, // Covers the full screen
        ),
      ),
    );
  }
}
