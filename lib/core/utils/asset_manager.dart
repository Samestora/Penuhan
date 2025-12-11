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
  static const String _animPath = 'assets/anim';

  // Animation files
  static const String animAttackEffect = '$_animPath/attack_effect.gif';
  static const String animBiteEffect = '$_animPath/bite_effect.gif';
  static const String animFireballEffect = '$_animPath/fireball_effect.gif';
  static const String animFlameBurstEffect =
      '$_animPath/flame_burst_effect.gif';
  static const String animHealEffect = '$_animPath/heal_effect.gif';
  static const String animIceEffect = '$_animPath/ice.gif';
  static const String animSlashEffect = '$_animPath/slash_effect.gif';
  static const String animThrustEffect = '$_animPath/thrust_effect.gif';
  static const String animThunderEffect = '$_animPath/thunder.gif';

  // SFX files
  static const String sfxClick = '$_audioPath/$_sfxPath/sfx_click.mp3';
  static const String sfxSlash = '$_audioPath/$_sfxPath/sfx_slash.wav';
  static const String sfxBasicAttack =
      '$_audioPath/$_sfxPath/sfx_basic_attack.wav';
  static const String sfxBuying = '$_audioPath/$_sfxPath/sfx_buying.wav';
  static const String sfxDecline = '$_audioPath/$_sfxPath/sfx_decline.wav';
  static const String sfxDefence = '$_audioPath/$_sfxPath/sfx_defence.wav';
  static const String sfxPlayButton =
      '$_audioPath/$_sfxPath/sfx_play_button.wav';

  // Skill SFX
  static const String sfxSkillBite = '$_audioPath/$_sfxPath/sfx_skill_bite.wav';
  static const String sfxSkillFireball =
      '$_audioPath/$_sfxPath/sfx_skill_fireball.wav';
  static const String sfxSkillFlameBurst =
      '$_audioPath/$_sfxPath/sfx_skill_flame_burst.wav';
  static const String sfxSkillHeal = '$_audioPath/$_sfxPath/sfx_skill_heal.wav';
  static const String sfxSkillIce = '$_audioPath/$_sfxPath/sfx_skill_ice.wav';
  static const String sfxSkillSlash =
      '$_audioPath/$_sfxPath/sfx_skill_slash.wav';
  static const String sfxSkillThrust =
      '$_audioPath/$_sfxPath/sfx_skill_thrust.wav';
  static const String sfxSkillThunder =
      '$_audioPath/$_sfxPath/sfx_skill_thunder.wav';

  // BGM files
  static const String bgmTitle = '$_audioPath/$_bgmPath/bgm_title.mp3';
  static const String bgmRest = '$_audioPath/$_bgmPath/serenade.mp3';
  static const String bgmBattle = '$_audioPath/$_bgmPath/battle.ogg';
  static const String bgmBoss = '$_audioPath/$_bgmPath/boss.ogg';
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

  // Monster sprites
  static const String goblinSprite = '$_imagesPath/$_spritePath/goblin.png';
  static const String goblinScoutSprite =
      '$_imagesPath/$_spritePath/goblin_scout.png';
  static const String goblinBerserkerSprite =
      '$_imagesPath/$_spritePath/goblin_berserker.png';
  static const String goblinShamanSprite =
      '$_imagesPath/$_spritePath/goblin_shaman.png';
  static const String goblinSniperSprite =
      '$_imagesPath/$_spritePath/goblin_sniper.png';
  static const String tideSerpentSprite =
      '$_imagesPath/$_spritePath/tide_serpent.png';
  static const String coralGolemSprite =
      '$_imagesPath/$_spritePath/coral_golem.png';
  static const String skeletonSprite = '$_imagesPath/$_spritePath/skeleton.png';
  static const String skeletonArcherSprite =
      '$_imagesPath/$_spritePath/skeleton_archer.png';
  static const String skeletonKnightSprite =
      '$_imagesPath/$_spritePath/skeleton_knight.png';
  static const String skeletonMageSprite =
      '$_imagesPath/$_spritePath/skeleton_mage.png';
  static const String skeletonWarlockSprite =
      '$_imagesPath/$_spritePath/skeleton_warlock.png';
  static const String ghoulSprite = '$_imagesPath/$_spritePath/ghoul.png';
  static const String wraithSprite = '$_imagesPath/$_spritePath/wraith.png';
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
