import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isReady = false;

  SoundService() {
    _init();
  }

  Future<void> _init() async {
    try {
      // Preload the sound file to reduce delay
      await _audioPlayer.setSource(AssetSource('msg_sound.mp3'));
      _isReady = true;
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  Future<void> playMessageSound() async {
    try {
      if (_isReady) {
        // If preloaded, just play
        await _audioPlayer.resume();
      } else {
        // Fallback if not preloaded
        await _audioPlayer.play(AssetSource('msg_sound.mp3'));
      }

      // Reset position for next play
      await _audioPlayer.seek(const Duration(milliseconds: 0));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
