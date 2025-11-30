import 'item.dart';

class GameProgress {
  final int currentFloor;
  final int maxFloor;
  final int playerLevel;
  final int playerHp;
  final int playerMaxHp;
  final int playerXp;
  final int playerMaxXp;
  final int playerMp;
  final int playerMaxMp;
  final int playerAttack;
  final int playerSkill;
  final int gold;
  final List<InventoryItem> inventory;

  GameProgress({
    required this.currentFloor,
    required this.maxFloor,
    this.playerLevel = 1,
    required this.playerHp,
    required this.playerMaxHp,
    required this.playerXp,
    required this.playerMaxXp,
    this.playerMp = 50,
    this.playerMaxMp = 50,
    required this.playerAttack,
    required this.playerSkill,
    this.gold = 0,
    this.inventory = const [],
  });

  GameProgress copyWith({
    int? currentFloor,
    int? maxFloor,
    int? playerLevel,
    int? playerHp,
    int? playerMaxHp,
    int? playerXp,
    int? playerMaxXp,
    int? playerMp,
    int? playerMaxMp,
    int? playerAttack,
    int? playerSkill,
    int? gold,
    List<InventoryItem>? inventory,
  }) {
    return GameProgress(
      currentFloor: currentFloor ?? this.currentFloor,
      maxFloor: maxFloor ?? this.maxFloor,
      playerLevel: playerLevel ?? this.playerLevel,
      playerHp: playerHp ?? this.playerHp,
      playerMaxHp: playerMaxHp ?? this.playerMaxHp,
      playerXp: playerXp ?? this.playerXp,
      playerMaxXp: playerMaxXp ?? this.playerMaxXp,
      playerMp: playerMp ?? this.playerMp,
      playerMaxMp: playerMaxMp ?? this.playerMaxMp,
      playerAttack: playerAttack ?? this.playerAttack,
      playerSkill: playerSkill ?? this.playerSkill,
      gold: gold ?? this.gold,
      inventory: inventory ?? this.inventory,
    );
  }

  // Helper untuk restore HP
  GameProgress restoreHp(int amount) {
    final newHp = (playerHp + amount).clamp(0, playerMaxHp);
    return copyWith(playerHp: newHp);
  }

  // Helper untuk restore MP
  GameProgress restoreMp(int amount) {
    final newMp = (playerMp + amount).clamp(0, playerMaxMp);
    return copyWith(playerMp: newMp);
  }

  // Helper untuk next floor
  GameProgress nextFloor() {
    return copyWith(currentFloor: currentFloor + 1);
  }

  // Tambah XP dan cek apakah level up (return jumlah level yang naik)
  GameProgressWithLevelUp addXp(int amount) {
    int newXp = playerXp + amount;
    int newLevel = playerLevel;
    int newMaxXp = playerMaxXp;
    int levelsGained = 0;

    while (newXp >= newMaxXp) {
      newXp -= newMaxXp;
      newLevel += 1;
      levelsGained += 1;
      // Naikkan kebutuhan XP berikutnya (kurva sederhana)
      newMaxXp = (newMaxXp * 1.25).round();
    }

    final updatedProgress = copyWith(
      playerXp: newXp,
      playerLevel: newLevel,
      playerMaxXp: newMaxXp,
    );

    return GameProgressWithLevelUp(
      progress: updatedProgress,
      levelsGained: levelsGained,
    );
  }

  // Helper untuk buy item
  GameProgress buyItem(Item item, int price) {
    if (gold < price) return this;

    final newInventory = List<InventoryItem>.from(inventory);
    final existingIndex = newInventory.indexWhere(
      (inv) => inv.itemId == item.id,
    );

    if (existingIndex >= 0) {
      newInventory[existingIndex] = newInventory[existingIndex].copyWith(
        quantity: newInventory[existingIndex].quantity + 1,
      );
    } else {
      newInventory.add(InventoryItem(itemId: item.id));
    }

    return copyWith(gold: gold - price, inventory: newInventory);
  }

  // Helper untuk use item
  GameProgress useItem(String itemId) {
    final itemIndex = inventory.indexWhere((inv) => inv.itemId == itemId);
    if (itemIndex < 0) return this;

    final inventoryItem = inventory[itemIndex];
    final item = Item.allItems.firstWhere((i) => i.id == itemId);

    var newProgress = this;

    // Apply item effects
    if (item.hpRestore != null) {
      newProgress = newProgress.restoreHp(item.hpRestore!);
    }
    if (item.mpRestore != null) {
      newProgress = newProgress.restoreMp(item.mpRestore!);
    }
    if (item.attackBoost != null) {
      newProgress = newProgress.copyWith(
        playerAttack: playerAttack + item.attackBoost!,
      );
    }
    if (item.skillBoost != null) {
      newProgress = newProgress.copyWith(
        playerSkill: playerSkill + item.skillBoost!,
      );
    }

    // Update inventory
    final newInventory = List<InventoryItem>.from(inventory);
    if (inventoryItem.quantity > 1) {
      newInventory[itemIndex] = inventoryItem.copyWith(
        quantity: inventoryItem.quantity - 1,
      );
    } else {
      newInventory.removeAt(itemIndex);
    }

    return newProgress.copyWith(inventory: newInventory);
  }

  // Helper untuk cek apakah punya item
  bool hasItem(String itemId) {
    return inventory.any((inv) => inv.itemId == itemId);
  }

  // Helper untuk get item quantity
  int getItemQuantity(String itemId) {
    final item = inventory.firstWhere(
      (inv) => inv.itemId == itemId,
      orElse: () => InventoryItem(itemId: 'none', quantity: 0),
    );
    return item.quantity;
  }
}

// Helper class untuk return hasil addXp dengan info level up
class GameProgressWithLevelUp {
  final GameProgress progress;
  final int levelsGained;

  GameProgressWithLevelUp({required this.progress, required this.levelsGained});
}
