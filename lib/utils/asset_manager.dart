import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class AssetManager {
  // Private constructor to prevent instantiation
  AssetManager._();

  static const String _audioPath = 'assets/audio';
  static const String _sfxPath = 'sfx';
  static const String _bgmPath = 'bgm';

  static const String _imagesPath = 'assets/images';
  static const String _enginePath = 'engine';
  static const String _spritePath = 'sprite';

  // SFX files
  static const String sfxClick = '$_audioPath/$_sfxPath/sfx_click.mp3';
  static const String sfxSlash = '$_audioPath/$_sfxPath/sfx_slash.wav';

  // BGM files
  static const String bgmTitle = '$_audioPath/$_bgmPath/bgm_title.mp3';
  static const String bgmDungeonGraveyard =
      '$_audioPath/$_bgmPath/dungeon_graveyard_music.mp3';

  // Engine image files
  static const String splashLogo = '$_imagesPath/$_enginePath/sgdc_logo.png';
  static const String gameLogo = '$_imagesPath/$_enginePath/logo.png';

  // Sprite image files
  static const String playerSprite = '$_imagesPath/$_spritePath/player.png';
  static const String enemySprite = '$_imagesPath/$_spritePath/enemy.png';
}

/// Loads all essential assets for the game into cache.
Future<void> precacheAssets(BuildContext context) async {
  await Future.wait([
    // Load all audio assets
    FlameAudio.audioCache.loadAll([
      AssetManager.bgmTitle,
      AssetManager.sfxClick,
      // Add other sfx or bgm files here
    ]),

    // Load all image assets for the UI
    precacheImage(const AssetImage(AssetManager.splashLogo), context),
    precacheImage(const AssetImage(AssetManager.gameLogo), context),
    precacheImage(const AssetImage(AssetManager.playerSprite), context),
    precacheImage(const AssetImage(AssetManager.enemySprite), context),
  ]);
}
