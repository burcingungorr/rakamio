import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  
  bool _isMusicEnabled = true;
  bool _isBackgroundPlaying = false;
  double _pausedPosition = 0.0;

  // Müzik açık/kapalı kontrolü
  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    } else if (!_isBackgroundPlaying) {
      playBackgroundMusic();
    }
  }

  bool get isMusicEnabled => _isMusicEnabled;

  // Arka plan müziğini başlat
  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled || _isBackgroundPlaying) return;
    
    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.setVolume(0.3); 
      await _backgroundPlayer.play(AssetSource('audios/song.mp3'));
      _isBackgroundPlaying = true;
    } catch (e) {
      print('Arka plan müziği başlatılamadı: $e');
    }
  }

  // Arka plan müziğini duraklat
  Future<void> pauseBackgroundMusic() async {
    if (_isBackgroundPlaying) {
      final position = await _backgroundPlayer.getCurrentPosition();
      _pausedPosition = position?.inMilliseconds.toDouble() ?? 0.0;
      await _backgroundPlayer.pause();
    }
  }

  // Arka plan müziğini devam ettir
  Future<void> resumeBackgroundMusic() async {
    if (_isMusicEnabled && _isBackgroundPlaying) {
      await _backgroundPlayer.resume();
    }
  }

  // Arka plan müziğini durdur
  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
    _isBackgroundPlaying = false;
    _pausedPosition = 0.0;
  }

  // Efekt sesi çal (tebrikler, sayılar vb.)
  Future<void> playEffectAudio(String audioPath) async {
    try {
      // Arka plan müziğini duraklat
      await pauseBackgroundMusic();
      
      // Efekt sesini çal
      await _effectPlayer.stop(); // Önceki efekti durdur
      await _effectPlayer.setVolume(1.0); // Efektler için yüksek ses
      await _effectPlayer.play(AssetSource(audioPath));
      
      // Efekt bitince arka plan müziğini devam ettir
      _effectPlayer.onPlayerComplete.listen((_) {
        resumeBackgroundMusic();
      });
    } catch (e) {
      print('Efekt sesi çalınamadı: $e');
      // Hata durumunda bile arka plan müziğini devam ettir
      resumeBackgroundMusic();
    }
  }

  // Eski metod (geriye uyumluluk için) - artık efekt olarak çalışır
  Future<void> playAudio(String audioPath) async {
    await playEffectAudio(audioPath);
  }

  // Tüm sesleri durdur
  Future<void> stopAll() async {
    await _backgroundPlayer.stop();
    await _effectPlayer.stop();
    _isBackgroundPlaying = false;
  }

  // Kaynakları temizle
  void dispose() {
    _backgroundPlayer.dispose();
    _effectPlayer.dispose();
  }
}