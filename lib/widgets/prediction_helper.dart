import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/LevelsScreen/level_selection_screen3.dart';
import 'package:flutter_application_1/screens/LevelsScreen/level_selection_screen4.dart';
import 'package:flutter_application_1/screens/LevelsScreen/level_selection_screen5.dart';
import 'package:lottie/lottie.dart';
import '../services/audio_service.dart';
import '../services/ml_service.dart';
import '../utils/constants.dart';

class PredictionHelper {
  static final List<String> _successGifPaths = [
    'assets/gif/dogru1.gif',
    'assets/gif/dogru2.gif',
    'assets/gif/dogru3.gif',
    'assets/gif/dogru4.gif',
    'assets/gif/dogru5.gif',
    'assets/gif/dogru6.gif',
  ];

  static final List<String> _wrongGifPaths = [
    'assets/gif/yanlis.gif',
  ];

  static Future<void> predictAndHandleResult({
    required BuildContext context,
    required MLService mlService,
    required AudioService audioService,
    required GlobalKey signatureKey,
    required String correctAnswer,
    required bool mounted,
    required Function(bool isProcessing) setProcessing,
    required Function(Widget animation) setFeedbackAnimation,
    required Function() clearCanvas,
    required VoidCallback onCorrect,
    Uint8List? selectedImage,
    NavigationType navigationType = NavigationType.pop,
  }) async {
    if (!mlService.isModelLoaded) return;

    setProcessing(true);

    try {
      String prediction = await mlService.predictDigit(
        signatureKey,
        selectedImage: selectedImage,
      );

      final random = Random();

      if (prediction == correctAnswer) {
        String selectedGif = _successGifPaths[random.nextInt(_successGifPaths.length)];
        
        setFeedbackAnimation(
          Stack(
            children: [
              _buildFullScreenAnimation('assets/animations/Confetti.json'),
              _buildBottomGif(selectedGif),
            ],
          ),
        );

        await audioService.playAudio(AudioFiles.congratulations);
        await Future.delayed(const Duration(seconds: 2));

        onCorrect();

        await Future.delayed(const Duration(milliseconds: 1200));
        
        if (mounted) {
          setFeedbackAnimation(const SizedBox.shrink());
          
switch (navigationType) {
  case NavigationType.popUntilFirst:
    Navigator.popUntil(context, (route) => route.isFirst);
    break;

  case NavigationType.popWithResult:
    Navigator.pop(context, true);
    break;
case NavigationType.LevelSelectionScreen3:
 Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => LevelSelectionScreen3()),
  (route) => false, 
);
  break;
case NavigationType.LevelSelectionScreen4:
 Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => LevelSelectionScreen4()),
  (route) => false, 
);
  break;
case NavigationType.LevelSelectionScreen5:
 Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => LevelSelectionScreen5()),
  (route) => false, 
);
  break;


  case NavigationType.popWithDelay:
    await Future.delayed(const Duration(milliseconds: 600));
    Navigator.pop(context);
    break;

  case NavigationType.pop:
    Navigator.pop(context);
    break;
}


        }
      } else {
        String wrongGif = _wrongGifPaths.isNotEmpty 
            ? _wrongGifPaths[random.nextInt(_wrongGifPaths.length)]
            : _wrongGifPaths.first;

        setFeedbackAnimation(
          Stack(
            children: [
              _buildFullScreenAnimation('assets/animations/SadFace.json'),
              _buildBottomGif(wrongGif),
            ],
          ),
        );

        await audioService.playAudio(AudioFiles.tryAgain);
        await Future.delayed(const Duration(seconds: 3));

        clearCanvas();

        if (mounted) {
          setFeedbackAnimation(const SizedBox.shrink());
        }
      }
    } finally {
      if (mounted) {
        setProcessing(false);
      }
    }
  }

static Widget _buildFullScreenAnimation(String assetPath) {
  return Positioned.fill(
    child: Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Transform.scale(
          scale: 0.8,
          child: Lottie.asset(
            assetPath,
            fit: BoxFit.contain, 
            repeat: true,
          ),
        ),
      ),
    ),
  );
}


  static Widget _buildBottomGif(String gifPath) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Image.asset(
          gifPath,
          width: 250,
          height: 250,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

enum NavigationType {
  pop,
  popWithResult,
  popUntilFirst, popWithDelay,
    LevelSelectionScreen3,
    LevelSelectionScreen4,
    LevelSelectionScreen5,

}