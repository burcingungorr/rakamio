import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/audio_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Uygulama başladığında arka plan müziğini başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _audioService.playBackgroundMusic();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Uygulama arka plana atıldığında müziği duraklat
    if (state == AppLifecycleState.paused) {
      _audioService.pauseBackgroundMusic();
    } 
    // Uygulama tekrar açıldığında müziği devam ettir
    else if (state == AppLifecycleState.resumed) {
      _audioService.resumeBackgroundMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rakam Çiz',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(),
    );
  }
}