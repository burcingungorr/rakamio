import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _audioPlayer;

  Future<void> playAudio(String audioFile) async {
    try {
      if (_audioPlayer != null) {
        await _audioPlayer!.stop();
        await _audioPlayer!.dispose();
      }
      
      _audioPlayer = AudioPlayer();
      
      await _audioPlayer!.play(AssetSource(audioFile));
      await _audioPlayer!.onPlayerComplete.first;
      
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
  }
}