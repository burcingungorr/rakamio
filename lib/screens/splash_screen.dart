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
          // children: [
          // Positioned(
          //   top: 30,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 50),
          //     alignment: Alignment.center,
          //     height: MediaQuery.of(context).size.height * 0.5,
          //     child: Column(
          //       children: [
          //         _buildTitle("Rakam"),
          //         _buildTitle("Çiz"),
          //       ],
          //     ),
          //   ),
          // ),
         /// Positioned(
              child: Image.asset(
                'assets/images/RAKAMİO.gif',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
        //],
     // ),
    );
  }

  // Widget _buildTitle(String text) {
  //   return Text(
  //     text,
  //     style: const TextStyle(
  //       fontSize: AppConstants.titleFontSize,
  //       color: AppConstants.primaryColor,
  //       fontWeight: FontWeight.bold,
  //       fontStyle: FontStyle.italic,
  //       shadows: [
  //         Shadow(
  //           blurRadius: 2.0,
  //           color: Colors.black,
  //           offset: Offset(1.0, 1.0),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
