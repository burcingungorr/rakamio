import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _audioPlayer;

  Future<void> playAudio(String audioFile) async {
      if (_audioPlayer != null) {
        await _audioPlayer!.stop();
        await _audioPlayer!.dispose();
      }
      
      _audioPlayer = AudioPlayer();
      
      await _audioPlayer!.play(AssetSource(audioFile));
      await _audioPlayer!.onPlayerComplete.first;
      
  
  }

  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
  }
}