import 'package:flutter/material.dart';
import 'LevelsScreen/level_selection_screen.dart';
import '../utils/constants.dart';
import '../services/audio_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isMusicOn = true;
  final AudioService _audioService = AudioService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
     _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); 
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isMusicOn) {
        _audioService.playAudio(AudioFiles.lets);
      }
    });
  }

  // void _showInfoModal() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 "Bilgi Ekranı",
  //                 style: TextStyle(
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 15),
  //               const Text(
  //                 "Buraya uygulamanızla ilgili bilgiler gelecek.\n"
  //                 "İstediğin açıklamaları buraya yazabilirsin.",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //               const SizedBox(height: 20),
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppConstants.primaryColor,
  //                   foregroundColor: Colors.white,
  //                 ),
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: const Text("✖"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/homescreenn.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              iconSize: 40,
              color: AppConstants.primaryColor,
              icon: Icon(
                isMusicOn ? Icons.music_note : Icons.music_off,
                size: 40,
              ),
              onPressed: () {
                setState(() {
                  isMusicOn = !isMusicOn;
                });
              },
            ),
          ),
          // Positioned(
          //   top: 40,
          //   left: 60,
          //   child: IconButton(
          //     iconSize: 40,
          //     color: AppConstants.primaryColor,
          //     icon: const Icon(Icons.info_outline),
          //     onPressed: _showInfoModal,
          //   ),
          // ),
          Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.all(30),
              ),
              onPressed: () {
                _animationController.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LevelSelectionScreen()),
                );
              },
              child:
                  const Icon(Icons.play_arrow, size: 50, color: Colors.white),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
