import 'package:flutter/material.dart';
import 'level_selection_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMusicOn = true;

  void _showInfoModal() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Bilgi Ekranı",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Buraya uygulamanızla ilgili bilgiler gelecek.\n"
                  "İstediğin açıklamaları buraya yazabilirsin.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("✖"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              iconSize: 40,
              color: AppConstants.primaryColor,
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.music_note, size: 40),
                  if (!isMusicOn)
                    const Icon(Icons.close, size: 50, color: Colors.red),
                ],
              ),
              onPressed: () {
                setState(() {
                  isMusicOn = !isMusicOn;
                });
              },
            ),
          ),

          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              iconSize: 40,
              color: AppConstants.primaryColor,
              icon: const Icon(Icons.info_outline),
              onPressed: _showInfoModal,
            ),
          ),

          Center(
            child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    backgroundColor: AppConstants.primaryColor,
    padding: const EdgeInsets.all(30),
  ),
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  LevelSelectionScreen()),
    );
  },
  child: const Icon(Icons.play_arrow, size: 50, color: Colors.white),
),

          ),
        ],
      ),
    );
  }
}
