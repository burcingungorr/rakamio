import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../models/media_model.dart';
import '../../utils/constants.dart';
import '../DrawsScreen/first_level_screen.dart';

class FirstLevelPage extends StatefulWidget {
  final int level;
  final VoidCallback onLevelComplete;

  const FirstLevelPage(
      {super.key, required this.level, required this.onLevelComplete});

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

    Future.delayed(const Duration(milliseconds: 500), () {
      _audioService.playAudio(_selectedAudio);
    });  

    Timer(AppConstants.splashDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirstLevelScreen(
            correctNumber: _correctNumber,
            level: widget.level,
            onCorrect: widget.onLevelComplete, 
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
