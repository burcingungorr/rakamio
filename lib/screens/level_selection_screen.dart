import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'first_level_page.dart';
import 'second_level_screen.dart';
import 'level_selection_screen2.dart';
import '../utils/constants.dart' as constants;

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int _unlockedLevels = 1; 
  Set<int> _starredLevels = {}; 
  bool _animatePencil = false;
  bool _canGoNextChapter = false; 

  final AudioService _audioService = AudioService();


  @override
  void initState() {
    super.initState();
    _loadLastLevel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _animatePencil = true;
        });
      });
    });
  }

  Future<void> _loadLastLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastLevelIndex = prefs.getInt('lastLevel') ?? -1; 
    
    setState(() {
      _unlockedLevels = lastLevelIndex + 2 > 1 ? lastLevelIndex + 2 : 1; 
      
      if (lastLevelIndex >= 0) {
        _starredLevels = Set.from(List.generate(lastLevelIndex + 1, (index) => index));
      }
      
      _canGoNextChapter = _unlockedLevels > 10;
    });
  }

  Future<void> _saveLastLevel(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastLevel', index);
  }

  void _selectLevel(int index) {
    if (index < _unlockedLevels) {
      if (index < 10) { 
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FirstLevelPage(
              level: index + 1, 
              onLevelComplete: () => _onLevelComplete(index), 
            ),
          ),
        );
      } else {
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
  }
void _playNumberAudio(int number) {
  switch (number) {
    case 0: _audioService.playAudio(constants.AudioFiles.zero); break;
    case 1: _audioService.playAudio(constants.AudioFiles.one); break;
    case 2: _audioService.playAudio(constants.AudioFiles.two); break;
    case 3: _audioService.playAudio(constants.AudioFiles.three); break;
    case 4: _audioService.playAudio(constants.AudioFiles.four); break;
    case 5: _audioService.playAudio(constants.AudioFiles.five); break;
    case 6: _audioService.playAudio(constants.AudioFiles.six); break;
    case 7: _audioService.playAudio(constants.AudioFiles.seven); break;
    case 8: _audioService.playAudio(constants.AudioFiles.eight); break;
    case 9: _audioService.playAudio(constants.AudioFiles.nine); break;
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
      if (_unlockedLevels == index + 1) {
        _unlockedLevels++;
      }
      if (_unlockedLevels > 10) {
        _canGoNextChapter = true; 
      }
    });
    await _saveLastLevel(index);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: AnimatedStar()),
    );
        await Future.delayed(const Duration(seconds: 1));
    
    Navigator.of(context).pop(); 

  }

  Widget _buildLevelDot(int index) {
    bool isUnlocked = index < _unlockedLevels;
    bool hasStar = _starredLevels.contains(index);
    bool isNextLevel = index == _unlockedLevels - 1; 

    Color bgColor = isUnlocked 
        ? (index < 10 ? Colors.orange : Colors.green)
        : Colors.grey;

    Widget icon;
    if (!isUnlocked) {
      icon = const Icon(Icons.lock, color: Colors.white, size: 40);
    } else if (hasStar) {
      icon = const Icon(Icons.star, color: Colors.yellow, size: 70);
    } else {
      icon = AnimatedAlign(
        alignment: _animatePencil && isNextLevel ? Alignment.center : const Alignment(0, -1.5),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: const Icon(Icons.edit, color: Colors.white, size: 50),
      );
    }

    return GestureDetector(
      onTap: () => _selectLevel(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: 100,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
              ),
            ),
            icon,

          ],
        ),
      ),
    );
  }

  Widget _buildConnector(int index) {
    const int dotCount = 5;
    List<Widget> dots = [];
    bool isLevelBeforePassed = _starredLevels.contains(index);

    for (int i = 0; i < dotCount; i++) {
      dots.add(
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLevelBeforePassed ? (index < 10 ? Colors.orange : Colors.green) : Colors.grey[300],
          ),
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, children: dots);
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstChapterCompleted = _unlockedLevels > 10;

    return Scaffold(
      backgroundColor: isFirstChapterCompleted ? Colors.grey[300] : Colors.white,

      body: Stack(
        children: [
          Center(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 50),
              itemCount: 10, 
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                List<Widget> children = [];
                children.add(_buildLevelDot(index));
                if (index != 9) children.add(_buildConnector(index)); 
                return Column(children: children);
              },
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Opacity(
              opacity: _canGoNextChapter ? 1.0 : 0.5,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, size: 50),
                color: Colors.black,
                onPressed: _canGoNextChapter
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LevelSelectionScreen2()),
                        );
                      }
                    : null,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class AnimatedStar extends StatefulWidget {
  const AnimatedStar({super.key});

  @override
  _AnimatedStarState createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<AnimatedStar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 6000));
    _scaleAnimation = Tween<double>(begin: 0, end: 2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: const Icon(Icons.star, color: Colors.yellow, size: 100),
    );
  }
}
