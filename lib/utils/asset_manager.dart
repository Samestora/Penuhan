import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

/// Manages assets shorthand for convinience, for the game
/// for audio will be using [flame_audio] package
/// for images will be using native [flutter] package
///
/// call the assets in this class like so
/// ```dart
/// AssetManager.<sfxName>
/// AssetManager.<bgmName>
/// AssetManager.<imageName>
/// ```
/// with [sfxName], [bgmName], [imageName]
/// being the name of the file defined in AssetManager
///
/// for prechaching assets you can do them depending on the [Screen]
/// for example :
/// ```dart
/// Future<void> _loadData() async {
///   await Future.wait([
///     precacheMainMenuAssets(context),
///     Future.delayed(const Duration(seconds: 2)),
///   ]);
/// }
/// ```

class AssetManager {
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

  // Shader files
  static const String _shaderPath = 'shaders';
  static const String crtShader = '$_shaderPath/crt_shader.frag';
  static const String vhsShader = '$_shaderPath/vhs_shader.frag';

  // Engine image files
  static const String splashLogo = '$_imagesPath/$_enginePath/sgdc_logo.png';
  static const String gameLogo = '$_imagesPath/$_enginePath/logo.png';

  // Sprite image files
  static const String playerSprite = '$_imagesPath/$_spritePath/player.png';
  static const String enemySprite = '$_imagesPath/$_spritePath/enemy.png';
}

Future<void> precacheMainGameAssets(BuildContext context) async {
  await Future.wait([
    FlameAudio.audioCache.loadAll([
      AssetManager.bgmTitle,
      AssetManager.sfxClick,
    ]),

    precacheImage(const AssetImage(AssetManager.splashLogo), context),
    precacheImage(const AssetImage(AssetManager.gameLogo), context),
    precacheImage(const AssetImage(AssetManager.playerSprite), context),
    precacheImage(const AssetImage(AssetManager.enemySprite), context),
  ]);
}

Future<void> precacheMainMenuAssets(BuildContext context) async {
  await Future.wait([
    FlameAudio.audioCache.loadAll([
      AssetManager.bgmTitle,
      AssetManager.sfxClick,
    ]),

    precacheImage(const AssetImage(AssetManager.splashLogo), context),
    precacheImage(const AssetImage(AssetManager.gameLogo), context),
  ]);
}
