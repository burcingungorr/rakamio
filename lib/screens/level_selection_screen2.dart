import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'level_selection_screen3.dart';
import 'second_level_screen.dart';
import '../utils/constants.dart';

class LevelSelectionScreen2 extends StatefulWidget {
  @override
  _LevelSelectionScreen2State createState() => _LevelSelectionScreen2State();
}

class _LevelSelectionScreen2State extends State<LevelSelectionScreen2> {
  int _currentPage = 10; // 2. bölüm 11. seviyeden başlıyor
  int _unlockedLevels = 11; // Sadece 11. seviye açık olarak başlar
  Set<int> _starredLevels = {};
  bool _animatePencil = false;
  bool _canGoNextChapter = false; // 3.bölüme geçiş izni

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
      _currentPage = lastLevel >= 10 ? lastLevel : 10; // 2. bölüm başlangıç
      if (lastLevel >= 10) {
        _starredLevels =
            Set.from(List.generate(lastLevel - 10 + 1, (index) => index + 10));
      }
      _canGoNextChapter =
          lastLevel >= 19; // 2. bölümün 10 seviyesi tamamlanmışsa (10-19)
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

    // Tamamlanan seviyeyi listeye ekle
    List<String> completedLevels = prefs.getStringList('completedLevels') ?? [];
    if (!completedLevels.contains(index.toString())) {
      completedLevels.add(index.toString());
      await prefs.setStringList('completedLevels', completedLevels);
    }

    setState(() {
      _starredLevels.add(index);
      if (_unlockedLevels == index + 1) _unlockedLevels++;
      if (_unlockedLevels > 20) _canGoNextChapter = true;
    });

    await _saveLastLevel(index);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: AnimatedStar2()),
    );

    await Future.delayed(const Duration(seconds: 1));
    // Bu ekranda kalması için Navigator kullanmayın, sadece dialog'u kapatın
    Navigator.of(context).pop(); // Sadece dialog'u kapat
  }

  Widget _buildLevelDot(int index) {
    bool isUnlocked = index < _unlockedLevels;
    bool hasStar = _starredLevels.contains(index);

    // 2. bölüm için mavi renk
    Color bgColor = isUnlocked ? Colors.blue : Colors.grey;

    Widget icon;
    if (!isUnlocked) {
      // 🔒 kilit
      icon = const Icon(Icons.lock, color: Colors.white, size: 40);
    } else if (hasStar) {
      // ⭐ geçmiş seviye
      icon = const Icon(Icons.star, color: Colors.yellow, size: 70);
    } else if (index == _unlockedLevels - 1) {
      // ✏️ şu anki aktif seviye
      icon = AnimatedAlign(
        alignment: _animatePencil ? Alignment.center : const Alignment(0, -1.5),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: const Icon(Icons.edit, color: Colors.white, size: 50),
      );
    } else {
      // güvenlik için (normalde buraya düşmez)
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
          color:
              isLevelPassed ? Colors.blue : Colors.grey[300], // Mavi bağlayıcı
        ),
      ));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: dots);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Açık mavi arka plan

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
                children.add(_buildLevelDot(index + 10)); // 11–20
                if (index != 9) children.add(_buildConnector(index + 10));
                return Column(children: children);
              },
            ),
          ),
          // Sağ alt köşede sabit ok (3. bölüm için)
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
                            builder: (_) => LevelSelectionScreen3(),
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ),
          // Geri dönüş oku (sol üst köşe)
         
        ],
      ),
    );
  }
}

class AnimatedStar2 extends StatefulWidget {
  @override
  _AnimatedStar2State createState() => _AnimatedStar2State();
}

class _AnimatedStar2State extends State<AnimatedStar2>
    with SingleTickerProviderStateMixin {
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
