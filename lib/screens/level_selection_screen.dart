import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'first_level_page.dart';
import 'second_level_screen.dart';
import 'level_selection_screen2.dart';
import '../utils/constants.dart';

class LevelSelectionScreen extends StatefulWidget {
  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int _currentPage = 0;
  int _unlockedLevels = 1;
  Set<int> _starredLevels = {};
  bool _animatePencil = false;
  bool _canGoNextChapter = false; // 2.bölüme geçiş izni

  @override
  void initState() {
    super.initState();
    _loadLastLevel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animatePencil = true;
      });
    });
  }

  Future<void> _loadLastLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastLevel = prefs.getInt('lastLevel') ?? 0;
    setState(() {
      _unlockedLevels =
          lastLevel + 1 > _unlockedLevels ? lastLevel + 1 : _unlockedLevels;
      _currentPage = lastLevel;
      if (lastLevel > 0) {
        _starredLevels = Set.from(List.generate(lastLevel, (index) => index));
      }
      _canGoNextChapter = lastLevel >= 9; // ilk 10 seviye tamamlanmışsa
    });
  }

  Future<void> _saveLastLevel(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastLevel', index);
  }

  void _selectLevel(int index) {
    if (index < _unlockedLevels) {
      setState(() {
        _currentPage = index;
      });

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

  void _onLevelComplete(int index) async {
    setState(() {
      _starredLevels.add(index);
      if (_unlockedLevels == index + 1) _unlockedLevels++;
      if (_unlockedLevels > 10)
        _canGoNextChapter = true; // 2.bölüme geçiş aktif
    });

    await _saveLastLevel(index);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: AnimatedStar()),
    );

    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _buildLevelDot(int index) {
    bool isUnlocked = index < _unlockedLevels;
    bool hasStar = _starredLevels.contains(index);

    Color bgColor = index < 10
        ? (isUnlocked ? Colors.orange : Colors.grey)
        : (isUnlocked ? Colors.green : Colors.grey);

    Widget icon;
    if (!isUnlocked) {
      icon = const Icon(Icons.lock, color: Colors.white, size: 40);
    } else if (hasStar) {
      icon = const Icon(Icons.star, color: Colors.yellow, size: 70);
    } else {
      icon = AnimatedAlign(
        alignment: _animatePencil ? Alignment.center : Alignment(0, -1.5),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
              ),
              width: 100,
              height: 100,
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
          color: isLevelPassed
              ? (index < 10 ? Colors.orange : Colors.green)
              : Colors.grey[300],
        ),
      ));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: dots);
  }

  @override
  Widget build(BuildContext context) {
    bool isAfter10 = _unlockedLevels > 10;

    return Scaffold(
      backgroundColor: isAfter10 ? Colors.grey[300] : Colors.white,
      body: Stack(
        children: [
          // Seviye listesi ortalanmış
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
          // Sağ alt köşede sabit ok
          Positioned(
            right: 20,
            bottom: 20,
            child: Opacity(
              opacity: _canGoNextChapter ? 1.0 : 0.8,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, size: 50),
                color: Colors.black, // siyah
                onPressed: _canGoNextChapter
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LevelSelectionScreen2(),
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ),
          // Sol alt köşede anasayfa (home) butonu
       Positioned(
  left: 20,
  bottom: 20,
  child: IconButton(
    onPressed: () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    },
    icon: const Icon(Icons.home, color: Colors.black, size: 45),
    splashColor: Colors.transparent,  // basınca çıkan efektin şeffaf olmasını sağlar
    highlightColor: Colors.transparent, // basılıyken efekt
  ),
)

        ],
      ),
    );
  }
}

class AnimatedStar extends StatefulWidget {
  @override
  _AnimatedStarState createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<AnimatedStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
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
