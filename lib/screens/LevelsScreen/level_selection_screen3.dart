import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/LevelsScreen/level_selection_screen2.dart';
import 'package:flutter_application_1/screens/LevelsScreen/level_selection_screen4.dart';
import 'package:flutter_application_1/widgets/animated_star.dart';
import 'package:flutter_application_1/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LevelImagesScreen/third_level_page.dart';
import '../../services/audio_service.dart';

class LevelSelectionScreen3 extends StatefulWidget {
  @override
  _LevelSelectionScreen3State createState() => _LevelSelectionScreen3State();
}

class _LevelSelectionScreen3State extends State<LevelSelectionScreen3> {
  int _unlockedLevels = 30;
  final Set<int> _starredLevels = {};
  bool _animatePencil = true;
  bool _isLoading = true;
  bool _canGoNextChapter = false;

  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadProgress();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastLevel = prefs.getInt('lastLevel3') ?? 29;

    setState(() {
      _unlockedLevels = lastLevel + 1;
      if (lastLevel >= 30) {
      for (int i = 30; i <= lastLevel; i++) {
        _starredLevels.add(i);
      }
      _canGoNextChapter = true; 
    }
    });
  }

  Future<void> _saveLastLevel(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastLevel3', index);
  }

  void _selectLevel(int index) {
    if (index <= _unlockedLevels) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ThirdLevelPage(
            level: index,
            onLevelComplete: () => _onLevelComplete(index),
          ),
        ),
      );
    }
  }

  void _onLevelComplete(int index) async {
    await _saveLastLevel(index);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          Future.delayed(const Duration(seconds: 1), () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          });

          return WillPopScope(
            onWillPop: () async => false,
            child: const Center(child: AnimatedStar()),
          );
        },
      ).then((_) {
        if (mounted) {
          setState(() {
            _starredLevels.add(index);
            _unlockedLevels = index + 1;
            _animatePencil = false;
          });

          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() {
                _animatePencil = true;
              });
            }
          });
        }
      });
    }
  }

  Widget _buildLevelDot(int index) {
    bool isUnlocked = index <= _unlockedLevels;
    bool hasStar = _starredLevels.contains(index);
    Color bgColor = isUnlocked ? Colors.pinkAccent : Colors.grey[400]!;

    Widget icon;
    if (!isUnlocked) {
      icon = const Icon(Icons.lock, color: Colors.white, size: 40);
    } else if (hasStar) {
      icon = const Icon(Icons.star, color: Colors.yellow, size: 55);
    } else {
      icon = AnimatedAlign(
        alignment: _animatePencil ? Alignment.center : const Alignment(0, -1.5),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: const Icon(Icons.edit, color: Colors.white, size: 50),
      );
    }

    return GestureDetector(
      onTap: () {
        if (isUnlocked) _selectLevel(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: 120,
        height: 120,
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
    bool isLevelPassed = _starredLevels.contains(index);

    for (int i = 0; i < dotCount; i++) {
      dots.add(Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLevelPassed ? Colors.pinkAccent : Colors.grey[300],
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
                int levelIndex = 30 + index;
                List<Widget> children = [];
                children.add(_buildLevelDot(levelIndex));
                if (index != 9) children.add(_buildConnector(levelIndex));
                return Column(children: children);
              },
            ),
          ),
           Positioned(
            left: 20,
            bottom: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 50),
                color: Colors.white, 
                onPressed:  () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LevelSelectionScreen2(),
                          ),
                        );
                      }
              ),
            ),

             Positioned(
            right: 20,
            bottom: 20,
            child: Opacity(
              opacity: _canGoNextChapter? 1.0 : 0.8,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, size: 50),
                color: Colors.white,
                onPressed: _canGoNextChapter
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LevelSelectionScreen4()),
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

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
