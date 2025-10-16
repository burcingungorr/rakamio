import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/animated_star.dart';
import 'package:flutter_application_1/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DrawsScreen/second_level_screen.dart';
import 'level_selection_screen3.dart';
import '../../utils/constants.dart';
import '../../services/audio_service.dart';

class LevelSelectionScreen2 extends StatefulWidget {
  @override
  _LevelSelectionScreen2State createState() => _LevelSelectionScreen2State();
}

class _LevelSelectionScreen2State extends State<LevelSelectionScreen2>
    with SingleTickerProviderStateMixin {
  int _currentPage = 10;
  int _unlockedLevels = 11;
  Set<int> _starredLevels = {};
  bool _animatePencil = false;
  bool _canGoNextChapter = false;
  bool _isLoading = true;

  final AudioService _audioService = AudioService();

  late AnimationController _speakerController;
  late Animation<double> _speakerAnimation;

  // bool _showSpeakerWarning = false;
  // Timer? _soundWarningTimer;

  @override
  void initState() {
    super.initState();
    _initializeScreen();

    _speakerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _speakerAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _speakerController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeScreen() async {
    await _loadLastLevel();
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _isLoading = false;
      _animatePencil = true;
    });

     WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAudio();
    });
  }

  @override
  void dispose() {
    _speakerController.dispose();
    _audioService.dispose();
    super.dispose();
  }

    void _playAudio() {
    _audioService.playAudio(AudioFiles.write);
    _speakerController.forward().then((_) => _speakerController.reverse());
  }

  // Future<void> _showSoundWarning() async {
  //   _soundWarningTimer?.cancel();
    
  //   if (!mounted) return;
    
  //   setState(() {
  //     _showSpeakerWarning = true;
  //   });
    
  //   _speakerController.repeat(reverse: true);
    
  //   _soundWarningTimer = Timer(const Duration(seconds: 4), () {
  //     if (mounted) {
  //       _speakerController.stop();
  //       _speakerController.reset();
  //       setState(() {
  //         _showSpeakerWarning = false;
  //       });
  //     }
  //   });
  // }

  Future<void> _loadLastLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastLevel = prefs.getInt('lastLevel') ?? 0;
    setState(() {
      _unlockedLevels =
          lastLevel + 1 > _unlockedLevels ? lastLevel + 1 : _unlockedLevels;
      _currentPage = lastLevel >= 10 ? lastLevel : 10;
      if (lastLevel >= 10) {
        _starredLevels =
            Set.from(List.generate(lastLevel - 10 + 1, (index) => index + 10));
      }
      _canGoNextChapter = lastLevel >= 19;
    });
  }

  Future<void> _saveLastLevel(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastLevel', index);
  }

  void _selectLevel(int index) {
    if (index < _unlockedLevels) {
      setState(() => _currentPage = index);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SecondLevelScreen(
            level: index + 1,
            onLevelComplete: () => _onLevelComplete(index),
          ),
        ),
      );
    }
  }

  void _onLevelComplete(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> completedLevels = prefs.getStringList('completedLevels') ?? [];
    if (!completedLevels.contains(index.toString())) {
      completedLevels.add(index.toString());
      await prefs.setStringList('completedLevels', completedLevels);
    }

    setState(() {
      _starredLevels.add(index);
      if (_unlockedLevels == index + 1) _unlockedLevels++;
      if (_unlockedLevels > 10) _canGoNextChapter = true;
    });

    await _saveLastLevel(index);

    Future.delayed(const Duration(milliseconds: 300), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: AnimatedStar()),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    });
  }

  Widget _buildLevelDot(int index) {
    bool isUnlocked = index < _unlockedLevels;
    bool hasStar = _starredLevels.contains(index);
    Color bgColor = isUnlocked ? Colors.blue : Colors.grey;

    Widget icon;
    if (!isUnlocked) {
      icon = const Icon(Icons.lock, color: Colors.white, size: 40);
    } else if (hasStar) {
      icon = const Icon(Icons.star, color: Colors.yellow, size: 55);
    } else if (index == _unlockedLevels - 1) {
      icon = AnimatedAlign(
        alignment: _animatePencil ? Alignment.center : const Alignment(0, -1.5),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: const Icon(Icons.edit, color: Colors.white, size: 50),
      );
    } else {
      icon = const Icon(Icons.help_outline, color: Colors.white, size: 40);
    }

    return GestureDetector(
      onTap: () {
        if (isUnlocked) _selectLevel(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: 100,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
                Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor.withOpacity(0.9),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              width: 120,
              height: 120,
            ),
            icon,
          ],
        ),
      ),
    );
  }

  Widget _buildConnector(int index) {
    int dotCount = 5;
    List<Widget> dots = [];
    bool isLevelPassed = _starredLevels.contains(index) || index < _currentPage;

    for (int i = 0; i < dotCount; i++) {
      dots.add(Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLevelPassed ? Colors.blue : Colors.grey[300],
        ),
      ));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: dots);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget();
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          Center(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 50),
              itemCount: 10,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                List<Widget> children = [];
                children.add(_buildLevelDot(index + 10));
                if (index != 9) children.add(_buildConnector(index + 10));
                return Column(children: children);
              },
            ),
          ),

          Positioned(
            right: 20,
            bottom: 20,
            child: Opacity(
              opacity: _canGoNextChapter ? 1.0 : 0.8,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, size: 50),
                color: Colors.white,
                onPressed: _canGoNextChapter
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LevelSelectionScreen3()),
                        );
                      }
                    : null,
              ),
            ),
          ),

            Positioned(
              top: 40,
              right: 20,
              child: ScaleTransition(
                scale: _speakerAnimation,
                child:  IconButton(
                  icon: const Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: _playAudio,
              ),
            ),
            ),
        ],
      ),
    );
  }
}