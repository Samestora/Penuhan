import 'dart:async';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:penuhan/utils/hive_constants.dart';

class AudioManager {
  static final Logger _log = Logger('AudioManager');

  SoLoud? _soloud;
  SoundHandle? _musicHandle;
  Box? _settingsBox;

  // Store the last played BGM to resume it when toggled back on
  String? _lastBgmAsset;
  Duration? _lastLoopingStartAt;
  double? _lastVolume;
  bool? _lastLooping;

  /// Gets the settings box instance.
  /// Assumes the box is already opened in main.dart
  Box get settingsBox {
    _settingsBox ??= Hive.box(settingsBoxName);
    return _settingsBox!;
  }

  /// Returns the current BGM state from Hive.
  bool get isBgmEnabled => settingsBox.get(bgmEnabledKey, defaultValue: true);

  /// Returns the current SFX state from Hive.
  bool get isSfxEnabled => settingsBox.get(sfxEnabledKey, defaultValue: true);

  Future<void> initialize() async {
    _soloud = SoLoud.instance;
    await _soloud!.init();
    _log.info('SoLoud initialized.');

    // When initializing, check if BGM is disabled.
    // This handles the case where the app is started with BGM already off.
    // We update the engine's internal state to match Hive.
    if (!isBgmEnabled && _musicHandle != null) {
      _soloud?.setPause(_musicHandle!, true);
    }
  }

  /// This is useful for preventing delays on the first play.
  Future<void> preload(
    String assetKey, {
    LoadMode mode = LoadMode.memory,
  }) async {
    if (_soloud == null) {
      _log.warning('SoLoud not initialized, cannot preload $assetKey');
      return;
    }
    try {
      // Just loading the asset caches it internally in SoLoud.
      // Use LoadMode.disk for BGM, LoadMode.memory for SFX.
      // soloud can't "load to memory" it only copies to it's own use
      await _soloud!.loadAsset(assetKey, mode: mode);
    } on SoLoudException catch (e) {
      _log.severe("Cannot preload sound '$assetKey'. Ignoring.", e);
    }
  }

  void dispose() {
    _soloud?.deinit();
  }

  /// Plays a sound effect, *only* if SFX are enabled in settings.
  Future<void> playSfx(String assetKey) async {
    if (!isSfxEnabled) {
      _log.finer("SFX disabled, not playing '$assetKey'.");
      return;
    }

    try {
      final source = await _soloud!.loadAsset(assetKey);
      await _soloud!.play(source, volume: 1.0);
    } on SoLoudException catch (e) {
      _log.severe("Cannot play sound '$assetKey'. Ignoring.", e);
    }
  }

  /// Plays background music, *only* if BGM is enabled in settings.
  Future<void> playBgm(
    String assetKey, {
    Duration? loopingStartAt,
    bool? looping,
    double? volume,
  }) async {
    // Store track info regardless of whether it plays now,
    // so we can play it if the user toggles BGM on.
    _lastBgmAsset = assetKey;
    _lastLoopingStartAt = loopingStartAt ?? Duration.zero;
    _lastLooping = looping ?? false;
    _lastVolume = volume ?? 1.0;

    if (!isBgmEnabled) {
      _log.info("BGM disabled, not playing '$assetKey'.");
      return;
    }

    if (_musicHandle != null) {
      if (_soloud!.getIsValidVoiceHandle(_musicHandle!)) {
        _log.info('Music is already playing. Stopping first.');
        await _soloud!.stop(_musicHandle!);
      }
    }
    final musicSource = await _soloud!.loadAsset(assetKey, mode: LoadMode.disk);

    musicSource.allInstancesFinished.first.then((_) {
      if (musicSource.soundHash.hash != 0) {
        _soloud?.disposeSource(musicSource);
      }
      _musicHandle = null;
    });

    _musicHandle = await _soloud!.play(
      musicSource,
      volume: _lastVolume!,
      looping: _lastLooping!,
      loopingStartAt: _lastLoopingStartAt!,
    );
    _log.info("Started BGM: $assetKey");
  }

  /// Stops the background music unconditionally.
  Future<void> stopBgm() async {
    if (_musicHandle != null && _soloud!.getIsValidVoiceHandle(_musicHandle!)) {
      await _soloud!.stop(_musicHandle!);
      _musicHandle = null;
      _log.info('BGM stopped.');
    }
  }

  /// Toggles the BGM state in Hive and applies the change immediately.
  Future<void> toggleBgm() async {
    final bool newBgmState = !isBgmEnabled;
    await settingsBox.put(bgmEnabledKey, newBgmState);
    _log.info('BGM state set to: $newBgmState');

    if (newBgmState == false) {
      // Turning music OFF
      await stopBgm();
    } else {
      // Turning music ON
      // Play the last track if we have one.
      if (_lastBgmAsset != null) {
        await playBgm(
          _lastBgmAsset!,
          looping: _lastLooping,
          loopingStartAt: _lastLoopingStartAt,
          volume: _lastVolume,
        );
      }
    }
  }

  /// Toggles the SFX state in Hive.
  Future<void> toggleSfx() async {
    final bool newSfxState = !isSfxEnabled;
    await settingsBox.put(sfxEnabledKey, newSfxState);
    _log.info('SFX state set to: $newSfxState');
  }

  /// Pauses all playing audio.
  /// Called when the app goes into the background.
  void onAppPaused() {
    _log.info('App paused. Pausing all audio.');
    // _soloud?.pauseAll();
  }

  /// Resumes all paused audio.
  /// Called when the app returns to the foreground.
  void onAppResumed() {
    _log.info('App resumed. Resuming all audio.');
    // _soloud?.resumeAll();

    // After resuming, we must respect the BGM setting.
    // If BGM is disabled, we must manually re-pause the music handle.
    if (!isBgmEnabled &&
        _musicHandle != null &&
        _soloud!.getIsValidVoiceHandle(_musicHandle!)) {
      _soloud!.setPause(_musicHandle!, true);
      _log.info('BGM is disabled, keeping music paused on resume.');
    }
  }

  // WIP
  void fadeOutMusic() {
    if (_musicHandle == null) {
      _log.info('Nothing to fade out');
      return;
    }
    const length = Duration(seconds: 5);
    _soloud!.fadeVolume(_musicHandle!, 0, length);
    _soloud!.scheduleStop(_musicHandle!, length);
  }

  // WIP
  void applyFilter() {
    _soloud!.filters.freeverbFilter.activate();
    _soloud!.filters.freeverbFilter.wet.value = 0.2;
    _soloud!.filters.freeverbFilter.roomSize.value = 0.9;
  }

  // WIP
  void removeFilter() {
    _soloud!.filters.freeverbFilter.deactivate();
  }
}
