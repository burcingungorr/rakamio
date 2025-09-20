import 'dart:async';
import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../models/media_model.dart';
import '../utils/constants.dart';
import 'first_level_screen.dart';

class FirstLevelPage extends StatefulWidget {
  final int level;
  final VoidCallback onLevelComplete; // ← Yeni

  const FirstLevelPage(
      {Key? key, required this.level, required this.onLevelComplete})
      : super(key: key);

  @override
  _FirstLevelPageState createState() => _FirstLevelPageState();
}

class _FirstLevelPageState extends State<FirstLevelPage> {
  final AudioService _audioService = AudioService();
  late String _selectedImage;
  late String _correctNumber;
  late String _selectedAudio;

  @override
  void initState() {
    super.initState();
    _startLevel();
  }

  void _startLevel() {
    int levelIndex = widget.level - 1;

    final selectedMedia = MediaData.mediaList[levelIndex];

    _selectedImage = selectedMedia.image;
    _correctNumber = selectedMedia.number;
    _selectedAudio = selectedMedia.audio!;

    // Görseli gösterdikten 0.5 saniye sonra rakam sesi çal
    Future.delayed(const Duration(milliseconds: 500), () {
      _audioService.playAudio(_selectedAudio);
    });

    // Splash ekran süresi tamamlanınca FirstLevelScreen'e geç
    Timer(AppConstants.splashDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirstLevelScreen(
            correctNumber: _correctNumber,
            level: widget.level,
            onCorrect: widget.onLevelComplete, // callback
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          _selectedImage,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}
