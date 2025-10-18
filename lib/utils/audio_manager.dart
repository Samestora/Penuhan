import 'package:flame_audio/flame_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:penuhan/main.dart'; // Import to get the keys
import 'package:penuhan/utils/asset_manager.dart';

/// Manages audio playback for the game using [flame_audio] (maybe using soloud next time?)
/// call this using [AssetManager] class like so
/// ```dart
/// AssetManager.audioManager.playSfx(Assets.<sfxName>);
/// AssetManager.audioManager.playBgm(Assets.<bgmName>);
/// ```
/// with [sfxName] and [bgmName]
/// being the name of the sound file defined in [AssetManager]
///
/// for pausing and resuming you can wrap them inside of lifecycles
/// for example :
/// ```dart
/// @override
/// void didChangeAppLifecycleState(AppLifecycleState state) {
///   super.didChangeAppLifecycleState(state);
///   if (state == AppLifecycleState.paused) {
///     AudioManager.instance.onAppPaused();
///   } else if (state == AppLifecycleState.resumed) {
///     AudioManager.instance.onAppResumed();
///   }
/// }
/// ```

class AudioManager {
  AudioManager._privateConstructor();
  static final AudioManager instance = AudioManager._privateConstructor();

  final Box _settingsBox = Hive.box(settingsBoxName);
  bool _isMusicPlaying = false;
  int _lastSfxTimestamp = 0;

  // Check if BGM is enabled in settings
  bool get isBgmEnabled => _settingsBox.get(bgmEnabledKey, defaultValue: true);
  // Check if SFX is enabled in settings
  bool get isSfxEnabled => _settingsBox.get(sfxEnabledKey, defaultValue: true);

  void playBgm(String bgmFile) {
    if (!isBgmEnabled) return; // Don't play if disabled
    _isMusicPlaying = true;
    FlameAudio.bgm.play(bgmFile, volume: 1);
  }

  void playSfx(String sfxFile) {
    if (!isSfxEnabled) return; // Don't play if disabled

    // Debounce on 1000ms
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastSfxTimestamp < 1000) return;
    _lastSfxTimestamp = now;
    FlameAudio.play(sfxFile);
  }

  void onAppPaused() {
    if (_isMusicPlaying) FlameAudio.bgm.pause();
  }

  void onAppResumed() {
    if (_isMusicPlaying && isBgmEnabled) FlameAudio.bgm.resume();
  }

  void stopBgm() {
    _isMusicPlaying = false;
    FlameAudio.bgm.stop();
  }

  // Methods for the UI to toggle settings
  void toggleBgm() {
    final bool current = isBgmEnabled;
    _settingsBox.put(bgmEnabledKey, !current);
    if (!current) {
      playBgm(AssetManager.bgmTitle); // If it was off, turn it on
    } else {
      stopBgm(); // If it was on, turn it off
    }
  }

  void toggleSfx() {
    final bool current = isSfxEnabled;
    _settingsBox.put(sfxEnabledKey, !current);
  }
}
