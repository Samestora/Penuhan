import 'package:penuhan/features/battle/models/skill.dart';

class Monster {
  final String id;
  final String name;
  final int maxHp;
  final int attack;
  final int skillStat;
  final List<Skill> skills;

  const Monster({
    required this.id,
    required this.name,
    required this.maxHp,
    required this.attack,
    required this.skillStat,
    required this.skills,
  });
}
