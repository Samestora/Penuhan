import 'package:penuhan/features/battle/models/skill.dart';
import 'package:penuhan/core/utils/asset_manager.dart';

class Monster {
  final String id;
  final String name;
  final int maxHp;
  final int attack;
  final int skillStat;
  final int defense;
  final List<Skill> skills;
  final String spritePath;

  const Monster({
    required this.id,
    required this.name,
    required this.maxHp,
    required this.attack,
    required this.skillStat,
    required this.defense,
    required this.skills,
    this.spritePath = AssetManager.enemySprite,
  });
}
