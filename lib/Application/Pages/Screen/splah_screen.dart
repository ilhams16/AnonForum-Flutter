import 'dart:async';

import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for a few seconds and then navigate to the main screen
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Navigate to your main screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // You can replace this with your own splash screen widget
    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash_image.png',width: 150,height: 150,), // Use your splash screen image
      ),
    );
  }
}