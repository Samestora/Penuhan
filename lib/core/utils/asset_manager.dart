import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:provider/provider.dart';

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
///     precacheCoreAssets(context),
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
  static const String _dungeonPath = 'dungeon';

  // SFX files
  static const String sfxClick = '$_audioPath/$_sfxPath/sfx_click.mp3';
  static const String sfxSlash = '$_audioPath/$_sfxPath/sfx_slash.wav';

  // BGM files
  static const String bgmTitle = '$_audioPath/$_bgmPath/bgm_title.mp3';
  static const String bgmRest = '$_audioPath/$_bgmPath/serenade.mp3';
  static const String bgmDungeonGraveyard =
      '$_audioPath/$_bgmPath/dungeon_graveyard_music.mp3';

  // Shader files
  static const String _shaderPath = 'shaders';
  static const String crtShader = '$_shaderPath/crt_shader.frag';
  static const String vhsShader = '$_shaderPath/vhs_shader.frag';

  // Engine image files
  static const String splashLogo = '$_imagesPath/$_enginePath/sgdc_logo.png';
  static const String gameLogo = '$_imagesPath/$_enginePath/logo.png';

  // Dungeon image files
  static const String sunkenCitadel =
      '$_imagesPath/$_dungeonPath/sunken_citadel.png';
  static const String whisperingCrypts =
      '$_imagesPath/$_dungeonPath/whispering_crypts.png';
  static const String dragonsMaw = '$_imagesPath/$_dungeonPath/dragons_maw.png';

  // Sprite image files
  static const String playerSprite = '$_imagesPath/$_spritePath/player.png';
  static const String enemySprite = '$_imagesPath/$_spritePath/enemy.png';
}

Future<void> precacheCoreAssets(BuildContext context) async {
  final audioManager = context.read<AudioManager>();

  await Future.wait([
    // Use LoadMode.disk for BGM, just like in your playBgm method
    audioManager.preload(AssetManager.bgmTitle, mode: LoadMode.disk),

    // Use the default LoadMode.memory for SFX
    audioManager.preload(AssetManager.sfxClick),

    // Image pre-caching
    precacheImage(const AssetImage(AssetManager.splashLogo), context),
    precacheImage(const AssetImage(AssetManager.gameLogo), context),
  ]);
}
