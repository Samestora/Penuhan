enum DungeonDifficulty {
  easy,
  normal,
  hard,
}

enum DungeonName {
  sunkenCitadel,
  whisperingCrypt,
  dragonsMaw,
}

enum Dungeon {
  sunkenCitadel(
    name: DungeonName.sunkenCitadel,
    imageAsset: 'assets/images/sprite/player.png', // Placeholder
    difficulty: DungeonDifficulty.easy,
  ),
  whisperingCrypt (
    name: DungeonName.whisperingCrypt,
    imageAsset: 'assets/images/sprite/player.png', // Placeholder
    difficulty: DungeonDifficulty.normal,
  ),
  dragonsMaw(
    name: DungeonName.dragonsMaw,
    imageAsset: 'assets/images/sprite/player.png', // Placeholder
    difficulty: DungeonDifficulty.hard,
  );

  final DungeonName name;
  final String imageAsset;
  final DungeonDifficulty difficulty;

  const Dungeon({
    required this.name,
    required this.imageAsset,
    required this.difficulty,
  });

  static const List<Dungeon> all = values;
}
