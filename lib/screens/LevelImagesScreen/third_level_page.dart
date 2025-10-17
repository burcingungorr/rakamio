import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/media_model.dart';
import '../DrawsScreen/third_level_screen.dart';
import '../../services/audio_service.dart';
import '../../utils/constants.dart';

class ThirdLevelPage extends StatefulWidget {
  final int level;
  final VoidCallback onLevelComplete;

  const ThirdLevelPage({
    super.key,
    required this.level,
    required this.onLevelComplete,
  });

  @override
  _ThirdLevelPageState createState() => _ThirdLevelPageState();
}

class _ThirdLevelPageState extends State<ThirdLevelPage> {
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _audioService.playAudio(AudioFiles.how);
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ThirdLevelScreen(
            level: widget.level,
            correctNumber: MediaData
                .mediaList[widget.level % MediaData.mediaList.length]
                .number,
            onCorrect: () {
              widget.onLevelComplete();
              Navigator.pop(context, true);
            },
          ),
        ),
      ).then((result) {
        if (result == false) {
          _audioService.playAudio(AudioFiles.tryAgain);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaIndex = widget.level % MediaData.mediaList.length;
    final media = MediaData.mediaList[mediaIndex];

    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SizedBox.expand(
        child: Image.asset(
          media.gif,
          fit: BoxFit.cover, // 👈 GIF tüm ekranı kaplar
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
