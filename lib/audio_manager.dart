import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  static final AudioPlayer _bgPlayer = AudioPlayer();
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  static bool _isMuted = false;
  static double _bgVolume = 0.4;
  static double _sfxVolume = 0.8;

  
  static Future<void> playBackgroundMusic() async {
    if (_isMuted) return;

    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(_bgVolume);
      await _bgPlayer.play(AssetSource('sounds/game.wav'));
    } catch (e) {
      debugPrint("Error playing bg music: $e");
    }
  }

  // stop background music
  static Future<void> stopBackgroundMusic() async {
    try {
      await _bgPlayer.stop();
    } catch (e) {
      debugPrint("Error stopping music: $e");
    }
  }


  // Mutes all 
  static Future<void> mute() async {
    _isMuted = true;
    await _bgPlayer.setVolume(0);
    await _sfxPlayer.setVolume(0);
  }

  // Unmutes audio 
  static Future<void> unmute() async {
    _isMuted = false;
    await _bgPlayer.setVolume(_bgVolume);
    await _sfxPlayer.setVolume(_sfxVolume);
  }

  //toggle mute
  static Future<void> toggleMute() async {
    _isMuted ? await unmute() : await mute();
  }

 
  static bool isMuted() => _isMuted;


}
