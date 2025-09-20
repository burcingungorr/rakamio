import 'dart:async';
import 'package:flutter/material.dart';
import '../models/media_model.dart';
import 'third_level_screen.dart';

class ThirdLevelPage extends StatefulWidget {
  final int level;
  final VoidCallback onLevelComplete;

  const ThirdLevelPage({
    Key? key,
    required this.level,
    required this.onLevelComplete,
  }) : super(key: key);

  @override
  _ThirdLevelPageState createState() => _ThirdLevelPageState();
}

class _ThirdLevelPageState extends State<ThirdLevelPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ThirdLevelScreen(
            level: widget.level,
            correctNumber: MediaData
                .mediaList[widget.level % MediaData.mediaList.length]
                .number, // doğru rakam
            onCorrect: widget.onLevelComplete, // callback doğru geçiyor
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fix: Use modulo to map level to correct index
    final mediaIndex = widget.level % MediaData.mediaList.length;
    final media = MediaData.mediaList[mediaIndex];

    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${media.number} Elma",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              media.objectImage,
              width: 250,
              height: 250,
            ),
          ],
        ),
      ),
    );
  }
}
