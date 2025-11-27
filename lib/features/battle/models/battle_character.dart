class BattleCharacter {
  final String name;
  int currentHp;
  int maxHp;
  int currentXp;
  int maxXp;
  int attack;
  int skill;

  BattleCharacter({
    required this.name,
    required this.currentHp,
    required this.maxHp,
    required this.currentXp,
    required this.maxXp,
    required this.attack,
    required this.skill,
  });

  bool get isAlive => currentHp > 0;

  double get hpPercentage => currentHp / maxHp;
  double get xpPercentage => currentXp / maxXp;

  void takeDamage(int damage) {
    currentHp = (currentHp - damage).clamp(0, maxHp);
  }

  void heal(int amount) {
    currentHp = (currentHp + amount).clamp(0, maxHp);
  }

  void gainXp(int amount) {
    currentXp = (currentXp + amount).clamp(0, maxXp);
  }
}
