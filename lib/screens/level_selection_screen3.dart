import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/media_model.dart';
import 'third_level_page.dart';

class LevelSelectionScreen3 extends StatefulWidget {
  @override
  _LevelSelectionScreen3State createState() => _LevelSelectionScreen3State();
}

class _LevelSelectionScreen3State extends State<LevelSelectionScreen3> {
  int _currentPage = 20; // 3. bölüm 21. seviyeden başlıyor
  int _unlockedLevels = 21; // 21. seviye açık
  Set<int> _starredLevels = {};
  bool _animatePencil = true;

  @override
  void initState() {
    super.initState();
    _loadLastLevel();
  }

  Future<void> _loadLastLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastLevel = prefs.getInt('lastLevel') ?? 20;
    setState(() {
      _unlockedLevels =
          lastLevel + 1 > _unlockedLevels ? lastLevel + 1 : _unlockedLevels;
      _currentPage = lastLevel >= 20 ? lastLevel : 20;
      if (lastLevel >= 20) {
        _starredLevels =
            Set.from(List.generate(lastLevel - 20 + 1, (index) => index + 20));
      }
    });
  }

  Future<void> _saveLastLevel(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastLevel', index);
  }

  void _selectLevel(int index) {
    if (index < _unlockedLevels) {
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
    setState(() {
      _starredLevels.add(index);
      if (_unlockedLevels == index + 1) _unlockedLevels++;
    });

    await _saveLastLevel(index);

    // Yıldız animasyonu göster
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: AnimatedStar3()),
    );

    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pop(); // Diyalogu kapat

    // Kalem animasyonunu tetikle
    setState(() {
      _animatePencil = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _animatePencil = true;
      });
    });
  }

  Widget _buildLevelDot(int index) {
    bool isUnlocked = index < _unlockedLevels;
    bool hasStar = _starredLevels.contains(index);
    Color bgColor = isUnlocked ? Colors.purple : Colors.grey;

    final mediaIndex = index - 20;
    final media = MediaData.mediaList[mediaIndex];

    Widget icon;
    if (!isUnlocked) {
      icon = const Icon(Icons.lock, color: Colors.white, size: 40);
    } else if (hasStar) {
      icon = const Icon(Icons.star, color: Colors.yellow, size: 70);
    } else if (index == _unlockedLevels - 1 && !hasStar) {
      // aktif seviye (kalem)
      icon = AnimatedAlign(
        alignment: _animatePencil ? Alignment.center : const Alignment(0, -1.5),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: Image.asset(
          media.objectImage,
          width: 50,
          height: 50,
        ),
      );
    } else {
      icon = Image.asset(
        media.objectImage,
        width: 50,
        height: 50,
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
    bool isLevelPassed = _starredLevels.contains(index) || index < _currentPage;

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
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 50),
          itemCount: 10,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int levelIndex = 20 + index; // 21–30
            List<Widget> children = [];
            children.add(_buildLevelDot(levelIndex));
            if (index != 9) children.add(_buildConnector(levelIndex));
            return Column(children: children);
          },
        ),
      ),
    );
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
