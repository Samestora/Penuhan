import 'dart:math';

import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/features/battle/models/monster.dart';
import 'package:penuhan/features/battle/models/skill.dart';

class MonsterRegistry {
  static final _random = Random();

  static final goblin = Monster(
    id: 'goblin',
    name: 'Goblin',
    maxHp: 100,
    attack: 8,
    skillStat: 5,
    defense: 3,
    skills: [Skill.quickStrike, Skill.fireball],
    spritePath: AssetManager.goblinSprite,
  );

  static final goblinScout = Monster(
    id: 'goblin_scout',
    name: 'Goblin Scout',
    maxHp: 80,
    attack: 10,
    skillStat: 6,
    defense: 4,
    skills: [Skill.quickStrike],
    spritePath: AssetManager.goblinScoutSprite,
  );

  static final goblinShaman = Monster(
    id: 'goblin_shaman',
    name: 'Goblin Shaman',
    maxHp: 90,
    attack: 6,
    skillStat: 12,
    defense: 3,
    skills: [Skill.fireball, Skill.healingLight],
    spritePath: AssetManager.goblinShamanSprite,
  );

  static final goblinBerserker = Monster(
    id: 'goblin_berserker',
    name: 'Goblin Berserker',
    maxHp: 130,
    attack: 15,
    skillStat: 4,
    defense: 5,
    skills: [Skill.quickStrike],
    spritePath: AssetManager.goblinBerserkerSprite,
  );

  static final goblinSniper = Monster(
    id: 'goblin_sniper',
    name: 'Goblin Sniper',
    maxHp: 85,
    attack: 14,
    skillStat: 7,
    defense: 2,
    skills: [Skill.quickStrike, Skill.iceSpear],
    spritePath: AssetManager.goblinSniperSprite,
  );

  static final tideSerpent = Monster(
    id: 'tide_serpent',
    name: 'Tide Serpent',
    maxHp: 160,
    attack: 12,
    skillStat: 14,
    defense: 8,
    skills: [Skill.iceSpear, Skill.healingLight],
    spritePath: AssetManager.tideSerpentSprite,
  );

  static final coralGolem = Monster(
    id: 'coral_golem',
    name: 'Coral Golem',
    maxHp: 200,
    attack: 18,
    skillStat: 8,
    defense: 15,
    skills: [Skill.quickStrike],
    spritePath: AssetManager.coralGolemSprite,
  );

  static final sirenOracle = Monster(
    id: 'siren_oracle',
    name: 'Siren Oracle',
    maxHp: 140,
    attack: 10,
    skillStat: 20,
    defense: 7,
    skills: [Skill.fireball, Skill.iceSpear],
  );

  static final goblinBoss = Monster(
    id: 'goblin_boss',
    name: 'Goblin Chieftain',
    maxHp: 260,
    attack: 16,
    skillStat: 12,
    defense: 10,
    skills: [Skill.fireball, Skill.thunderStrike],
  );

  static final skeleton = Monster(
    id: 'skeleton',
    name: 'Skeleton',
    maxHp: 150,
    attack: 12,
    skillStat: 10,
    defense: 5,
    skills: [Skill.quickStrike, Skill.iceSpear],
    spritePath: AssetManager.skeletonSprite,
  );

  static final skeletonArcher = Monster(
    id: 'skeleton_archer',
    name: 'Skeleton Archer',
    maxHp: 120,
    attack: 14,
    skillStat: 8,
    defense: 4,
    skills: [Skill.quickStrike, Skill.iceSpear],
    spritePath: AssetManager.skeletonArcherSprite,
  );

  static final skeletonMage = Monster(
    id: 'skeleton_mage',
    name: 'Skeleton Mage',
    maxHp: 110,
    attack: 8,
    skillStat: 14,
    defense: 5,
    skills: [Skill.iceSpear, Skill.thunderStrike],
    spritePath: AssetManager.skeletonMageSprite,
  );

  static final skeletonKnight = Monster(
    id: 'skeleton_knight',
    name: 'Skeleton Knight',
    maxHp: 170,
    attack: 16,
    skillStat: 9,
    defense: 9,
    skills: [Skill.quickStrike],
    spritePath: AssetManager.skeletonKnightSprite,
  );

  static final skeletonWarlock = Monster(
    id: 'skeleton_warlock',
    name: 'Skeleton Warlock',
    maxHp: 140,
    attack: 10,
    skillStat: 18,
    defense: 6,
    skills: [Skill.fireball, Skill.thunderStrike],
    spritePath: AssetManager.skeletonWarlockSprite,
  );

  static final ghoul = Monster(
    id: 'ghoul',
    name: 'Grave Ghoul',
    maxHp: 150,
    attack: 17,
    skillStat: 9,
    defense: 7,
    skills: [Skill.quickStrike],
    spritePath: AssetManager.ghoulSprite,
  );

  static final lichAdept = Monster(
    id: 'lich_adept',
    name: 'Lich Adept',
    maxHp: 130,
    attack: 9,
    skillStat: 22,
    defense: 6,
    skills: [Skill.fireball, Skill.thunderStrike, Skill.healingLight],
  );

  static final wraith = Monster(
    id: 'wraith',
    name: 'Shadow Wraith',
    maxHp: 125,
    attack: 13,
    skillStat: 19,
    defense: 5,
    skills: [Skill.iceSpear, Skill.quickStrike],
    spritePath: AssetManager.wraithSprite,
  );

  static final skeletonBoss = Monster(
    id: 'skeleton_boss',
    name: 'Bone Warden',
    maxHp: 320,
    attack: 20,
    skillStat: 16,
    defense: 12,
    skills: [Skill.iceSpear, Skill.thunderStrike],
  );

  static final dragon = Monster(
    id: 'dragon',
    name: 'Dragon',
    maxHp: 200,
    attack: 18,
    skillStat: 15,
    defense: 8,
    skills: [Skill.fireball, Skill.thunderStrike],
  );

  static final drake = Monster(
    id: 'drake',
    name: 'Lava Drake',
    maxHp: 220,
    attack: 20,
    skillStat: 16,
    defense: 10,
    skills: [Skill.fireball, Skill.quickStrike],
  );

  static final wyvern = Monster(
    id: 'wyvern',
    name: 'Storm Wyvern',
    maxHp: 210,
    attack: 18,
    skillStat: 18,
    defense: 9,
    skills: [Skill.thunderStrike, Skill.iceSpear],
  );

  static final salamander = Monster(
    id: 'salamander',
    name: 'Crimson Salamander',
    maxHp: 230,
    attack: 22,
    skillStat: 14,
    defense: 11,
    skills: [Skill.fireball, Skill.quickStrike],
  );

  static final phoenix = Monster(
    id: 'phoenix',
    name: 'Ashen Phoenix',
    maxHp: 240,
    attack: 19,
    skillStat: 22,
    defense: 8,
    skills: [Skill.fireball, Skill.healingLight],
  );

  static final minotaur = Monster(
    id: 'minotaur',
    name: 'Labyrinth Minotaur',
    maxHp: 260,
    attack: 28,
    skillStat: 10,
    defense: 14,
    skills: [Skill.quickStrike],
  );

  static final infernoKnight = Monster(
    id: 'inferno_knight',
    name: 'Inferno Knight',
    maxHp: 230,
    attack: 24,
    skillStat: 18,
    defense: 13,
    skills: [Skill.fireball, Skill.thunderStrike],
  );

  static final chaosChimera = Monster(
    id: 'chaos_chimera',
    name: 'Chaos Chimera',
    maxHp: 250,
    attack: 22,
    skillStat: 24,
    defense: 12,
    skills: [Skill.fireball, Skill.iceSpear, Skill.thunderStrike],
  );

  static final dragonBoss = Monster(
    id: 'dragon_boss',
    name: 'Ancient Dragon',
    maxHp: 400,
    attack: 26,
    skillStat: 20,
    defense: 16,
    skills: [Skill.fireball, Skill.thunderStrike],
  );

  static Monster forBattle(Dungeon dungeon, {bool isBoss = false}) {
    return isBoss ? _bossForDungeon(dungeon) : _regularForDungeon(dungeon);
  }

  static Monster forDungeon(Dungeon dungeon) {
    return forBattle(dungeon);
  }

  static Monster _regularForDungeon(Dungeon dungeon) {
    final pool = _regularPools[dungeon];
    if (pool == null || pool.isEmpty) {
      return goblin;
    }
    return pool[_random.nextInt(pool.length)];
  }

  static Monster _bossForDungeon(Dungeon dungeon) {
    switch (dungeon) {
      case Dungeon.sunkenCitadel:
        return goblinBoss;
      case Dungeon.whisperingCrypt:
        return skeletonBoss;
      case Dungeon.dragonsMaw:
        return dragonBoss;
    }
  }

  static final Map<Dungeon, List<Monster>> _regularPools = {
    Dungeon.sunkenCitadel: [
      goblin,
      goblinScout,
      goblinShaman,
      goblinBerserker,
      goblinSniper,
      tideSerpent,
      coralGolem,
    ],
    Dungeon.whisperingCrypt: [
      skeleton,
      skeletonArcher,
      skeletonMage,
      skeletonKnight,
      skeletonWarlock,
      ghoul,
      lichAdept,
      wraith,
    ],
    Dungeon.dragonsMaw: [
      dragon,
      drake,
      wyvern,
      salamander,
      phoenix,
      minotaur,
      infernoKnight,
      chaosChimera,
    ],
  };
}
