import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/media_model.dart';
import 'package:flutter_application_1/utils/constants.dart';
import '../../models/media_model.dart';
import '../DrawsScreen/fourth_level_screen.dart';
import '../../services/audio_service.dart';

class FourthLevelPage extends StatefulWidget {
  final int level;
  final VoidCallback onLevelComplete;

  const FourthLevelPage({
    super.key,
    required this.level,
    required this.onLevelComplete,
  });

  @override
  State<FourthLevelPage> createState() => _FourthLevelPageState();
}

class _FourthLevelPageState extends State<FourthLevelPage> {
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _audioService.playAudio(AudioFiles.animal);
    });

    Timer(const Duration(seconds: 10), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FourthLevelScreen(
            level: widget.level,
            correctNumber: SimpleMediaData
                .simpleMediaList[widget.level % SimpleMediaData.simpleMediaList.length]
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
    final mediaIndex = widget.level % SimpleMediaData.simpleMediaList.length;
    final media = SimpleMediaData.simpleMediaList[mediaIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          media.gif,
          fit: BoxFit.fitWidth,
          width: MediaQuery.of(context).size.width * 0.9,
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
