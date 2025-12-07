import 'package:penuhan/core/utils/asset_manager.dart';

enum DungeonDifficulty { easy, normal, hard }

enum DungeonName { sunkenCitadel, whisperingCrypt, dragonsMaw }

enum Dungeon {
  sunkenCitadel(
    name: DungeonName.sunkenCitadel,
    imageAsset: AssetManager.sunkenCitadel,
    difficulty: DungeonDifficulty.easy,
  ),
  whisperingCrypt(
    name: DungeonName.whisperingCrypt,
    imageAsset: AssetManager.whisperingCrypts,
    difficulty: DungeonDifficulty.normal,
  ),
  dragonsMaw(
    name: DungeonName.dragonsMaw,
    imageAsset: AssetManager.dragonsMaw,
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
