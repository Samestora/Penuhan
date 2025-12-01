class BattleCharacter {
  final String name;
  int currentHp;
  int maxHp;
  int currentXp;
  int maxXp;
  int currentMp;
  int maxMp;
  int attack;
  int skill;
  int defense;

  BattleCharacter({
    required this.name,
    required this.currentHp,
    required this.maxHp,
    required this.currentXp,
    required this.maxXp,
    required this.currentMp,
    required this.maxMp,
    required this.attack,
    required this.skill,
    required this.defense,
  });

  bool get isAlive => currentHp > 0;

  double get hpPercentage => currentHp / maxHp;
  double get xpPercentage => currentXp / maxXp;
  double get mpPercentage => maxMp == 0 ? 0 : currentMp / maxMp;

  // Calculate actual damage after defense reduction
  // Formula: damage = rawDamage * (100 / (100 + defense))
  int calculateDamageReduction(int rawDamage) {
    final damageMultiplier = 100 / (100 + defense);
    final actualDamage = (rawDamage * damageMultiplier).round();
    return actualDamage.clamp(1, rawDamage); // Minimum 1 damage
  }

  void takeDamage(int damage) {
    final actualDamage = calculateDamageReduction(damage);
    currentHp = (currentHp - actualDamage).clamp(0, maxHp);
  }

  void heal(int amount) {
    currentHp = (currentHp + amount).clamp(0, maxHp);
  }

  void restoreMp(int amount) {
    currentMp = (currentMp + amount).clamp(0, maxMp);
  }

  bool spendMp(int cost) {
    if (currentMp < cost) return false;
    currentMp = (currentMp - cost).clamp(0, maxMp);
    return true;
  }

  void gainXp(int amount) {
    currentXp = (currentXp + amount).clamp(0, maxXp);
  }
}
