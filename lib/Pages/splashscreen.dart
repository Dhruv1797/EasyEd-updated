import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the blue background
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          width: 400, // Adjust the width as per your requirement
          height: 400, // Adjust the height as per your requirement
        ),
      ),
    );
  }
}