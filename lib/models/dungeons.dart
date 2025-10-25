import 'package:penuhan/models/dungeon.dart';

class Dungeons {
  static const sunkenCitadel = Dungeon(
    id: 'sunken_citadel',
    name: 'The Sunken Citadel',
    imageAsset: 'assets/images/sprite/player.png', // Placeholder
    difficulty: 'Normal',
  );

  static const whisperingCrypt = Dungeon(
    id: 'whispering_crypt',
    name: 'The Whispering Crypt',
    imageAsset: 'assets/images/sprite/player.png', // Placeholder
    difficulty: 'Easy',
  );

  static const dragonsMaw = Dungeon(
    id: 'dragons_maw',
    name: 'The Dragon\'s Maw',
    imageAsset: 'assets/images/sprite/player.png', // Placeholder
    difficulty: 'Hard',
  );

  static const List<Dungeon> all = [
    whisperingCrypt,
    sunkenCitadel,
    dragonsMaw,
  ];
}
