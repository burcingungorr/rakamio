import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'third_level_page.dart';
import '../services/audio_service.dart';

class LevelSelectionScreen3 extends StatefulWidget {
  @override
  _LevelSelectionScreen3State createState() => _LevelSelectionScreen3State();
}

class _LevelSelectionScreen3State extends State<LevelSelectionScreen3> {
  int _currentPage = 30;
  int _unlockedLevels = 30;
  Set<int> _starredLevels = {};
  bool _animatePencil = true;

  final AudioService _audioService = AudioService(); 

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastLevel = prefs.getInt('lastLevel3') ?? 29;

    setState(() {
      _unlockedLevels = lastLevel + 1;
      _currentPage = lastLevel + 1;

      if (lastLevel >= 30) {
        for (int i = 30; i <= lastLevel; i++) {
          _starredLevels.add(i);
        }
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
      ).then((result) {

      });
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
            child: Center(child: AnimatedStar3()),
          );
        },
      ).then((_) {
        if (mounted) {
          setState(() {
            _starredLevels.add(index);
            _unlockedLevels = index + 1;
            _currentPage = index + 1;
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
    Color bgColor = isUnlocked ? Colors.purple : Colors.grey;

    Widget icon;
    if (!isUnlocked) {
      icon = const Icon(Icons.lock, color: Colors.white, size: 40);
    } else if (hasStar) {
      icon = const Icon(Icons.star, color: Colors.yellow, size: 70);
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
                color: bgColor,
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
          color: isLevelPassed ? Colors.purple : Colors.grey[300],
        ),
      ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: dots);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
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

class AnimatedStar3 extends StatefulWidget {
  @override
  _AnimatedStar3State createState() => _AnimatedStar3State();
}

class _AnimatedStar3State extends State<AnimatedStar3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
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
      child: const Icon(Icons.star, color: Colors.yellow, size: 120),
    );
  }
}
