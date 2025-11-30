import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/features/battle/models/monster.dart';
import 'package:penuhan/features/battle/models/skill.dart';

class MonsterRegistry {
  static final goblin = Monster(
    id: 'goblin',
    name: 'Goblin',
    maxHp: 100,
    attack: 8,
    skillStat: 5,
    defense: 3,
    skills: [Skill.quickStrike, Skill.fireball],
  );

  static final skeleton = Monster(
    id: 'skeleton',
    name: 'Skeleton',
    maxHp: 150,
    attack: 12,
    skillStat: 10,
    defense: 5,
    skills: [Skill.quickStrike, Skill.iceSpear],
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

  static Monster forDungeon(Dungeon dungeon) {
    switch (dungeon) {
      case Dungeon.sunkenCitadel:
        return goblin;
      case Dungeon.whisperingCrypt:
        return skeleton;
      case Dungeon.dragonsMaw:
        return dragon;
    }
  }
}
