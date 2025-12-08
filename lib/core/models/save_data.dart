import 'package:hive/hive.dart';
import 'package:penuhan/core/models/dungeon.dart';
import 'package:penuhan/core/models/game_progress.dart';
import 'package:penuhan/core/models/item.dart';

part 'save_data.g.dart';

@HiveType(typeId: 0)
class SaveData extends HiveObject {
  @HiveField(0)
  final int slotNumber;

  @HiveField(1)
  DateTime savedAt;

  @HiveField(2)
  String dungeonName;

  @HiveField(3)
  int currentFloor;

  @HiveField(4)
  int maxFloor;

  @HiveField(5)
  int playerLevel;

  @HiveField(6)
  int playerHp;

  @HiveField(7)
  int playerMaxHp;

  @HiveField(8)
  int playerXp;

  @HiveField(9)
  int playerMaxXp;

  @HiveField(10)
  int playerMp;

  @HiveField(11)
  int playerMaxMp;

  @HiveField(12)
  int playerAttack;

  @HiveField(13)
  int playerSkill;

  @HiveField(14)
  int playerDefense;

  @HiveField(15)
  int gold;

  @HiveField(16)
  List<SaveInventoryItem> inventory;

  @HiveField(17)
  List<String> purchasedBoostItemIds;

  SaveData({
    required this.slotNumber,
    required this.savedAt,
    required this.dungeonName,
    required this.currentFloor,
    required this.maxFloor,
    required this.playerLevel,
    required this.playerHp,
    required this.playerMaxHp,
    required this.playerXp,
    required this.playerMaxXp,
    required this.playerMp,
    required this.playerMaxMp,
    required this.playerAttack,
    required this.playerSkill,
    required this.playerDefense,
    required this.gold,
    required this.inventory,
    required this.purchasedBoostItemIds,
  });

  factory SaveData.fromGameProgress({
    required int slotNumber,
    required Dungeon dungeon,
    required GameProgress progress,
  }) {
    return SaveData(
      slotNumber: slotNumber,
      savedAt: DateTime.now(),
      dungeonName: dungeon.name.toString(),
      currentFloor: progress.currentFloor,
      maxFloor: progress.maxFloor,
      playerLevel: progress.playerLevel,
      playerHp: progress.playerHp,
      playerMaxHp: progress.playerMaxHp,
      playerXp: progress.playerXp,
      playerMaxXp: progress.playerMaxXp,
      playerMp: progress.playerMp,
      playerMaxMp: progress.playerMaxMp,
      playerAttack: progress.playerAttack,
      playerSkill: progress.playerSkill,
      playerDefense: progress.playerDefense,
      gold: progress.gold,
      inventory: progress.inventory
          .map(
            (item) =>
                SaveInventoryItem(itemId: item.itemId, quantity: item.quantity),
          )
          .toList(),
      purchasedBoostItemIds: progress.purchasedBoostItemIds,
    );
  }

  GameProgress toGameProgress() {
    return GameProgress(
      currentFloor: currentFloor,
      maxFloor: maxFloor,
      playerLevel: playerLevel,
      playerHp: playerHp,
      playerMaxHp: playerMaxHp,
      playerXp: playerXp,
      playerMaxXp: playerMaxXp,
      playerMp: playerMp,
      playerMaxMp: playerMaxMp,
      playerAttack: playerAttack,
      playerSkill: playerSkill,
      playerDefense: playerDefense,
      gold: gold,
      inventory: inventory
          .map(
            (item) =>
                InventoryItem(itemId: item.itemId, quantity: item.quantity),
          )
          .toList(),
      purchasedBoostItemIds: purchasedBoostItemIds,
    );
  }

  Dungeon getDungeon() {
    return Dungeon.values.firstWhere(
      (d) => d.name.toString() == dungeonName,
      orElse: () => Dungeon.sunkenCitadel,
    );
  }

  Map<String, dynamic> toJson() => {
    'slotNumber': slotNumber,
    'savedAt': savedAt.toIso8601String(),
    'dungeonName': dungeonName,
    'currentFloor': currentFloor,
    'maxFloor': maxFloor,
    'playerLevel': playerLevel,
    'playerHp': playerHp,
    'playerMaxHp': playerMaxHp,
    'playerXp': playerXp,
    'playerMaxXp': playerMaxXp,
    'playerMp': playerMp,
    'playerMaxMp': playerMaxMp,
    'playerAttack': playerAttack,
    'playerSkill': playerSkill,
    'playerDefense': playerDefense,
    'gold': gold,
    'inventory': inventory
        .map((item) => {'itemId': item.itemId, 'quantity': item.quantity})
        .toList(),
    'purchasedBoostItemIds': purchasedBoostItemIds,
  };

  factory SaveData.fromJson(Map<String, dynamic> json) => SaveData(
    slotNumber: json['slotNumber'],
    savedAt: DateTime.parse(json['savedAt']),
    dungeonName: json['dungeonName'],
    currentFloor: json['currentFloor'],
    maxFloor: json['maxFloor'],
    playerLevel: json['playerLevel'],
    playerHp: json['playerHp'],
    playerMaxHp: json['playerMaxHp'],
    playerXp: json['playerXp'],
    playerMaxXp: json['playerMaxXp'],
    playerMp: json['playerMp'],
    playerMaxMp: json['playerMaxMp'],
    playerAttack: json['playerAttack'],
    playerSkill: json['playerSkill'],
    playerDefense: json['playerDefense'],
    gold: json['gold'],
    inventory: (json['inventory'] as List)
        .map(
          (item) => SaveInventoryItem(
            itemId: item['itemId'],
            quantity: item['quantity'],
          ),
        )
        .toList(),
    purchasedBoostItemIds: List<String>.from(json['purchasedBoostItemIds']),
  );
}

@HiveType(typeId: 1)
class SaveInventoryItem {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final int quantity;

  SaveInventoryItem({required this.itemId, required this.quantity});
}
