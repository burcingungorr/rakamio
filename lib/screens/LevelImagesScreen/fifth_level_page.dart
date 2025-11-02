import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/audio_service.dart';
import '../../utils/constants.dart';

class FifthLevelPage extends StatefulWidget {
  final int num1;
  final int num2;
  final VoidCallback onIntroComplete;

  const FifthLevelPage({
    super.key,
    required this.num1,
    required this.num2,
    required this.onIntroComplete,
  });

  @override
  State<FifthLevelPage> createState() => _FifthLevelPageState();
}

class _FifthLevelPageState extends State<FifthLevelPage> {
    final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();

        WidgetsBinding.instance.addPostFrameCallback((_) {
      _audioService.playAudio(AudioFiles.sum);
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) widget.onIntroComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 255, 255, 255),
      body: Center(
        child: Text(
          '${widget.num1}  +  ${widget.num2}',
          style: const TextStyle(
            fontSize: 110,
            fontWeight: FontWeight.w900,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
