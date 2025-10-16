import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; 
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(AppConstants.splashDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
              child: Image.asset(
                'assets/images/RAKAMİO.gif',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
    );
  }

}
