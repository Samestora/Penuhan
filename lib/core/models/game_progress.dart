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
  final int playerDefense;
  final int gold;
  final List<InventoryItem> inventory;
  final List<String> purchasedBoostItemIds;

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
    required this.playerDefense,
    this.gold = 0,
    this.inventory = const [],
    this.purchasedBoostItemIds = const [],
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
    int? playerDefense,
    int? gold,
    List<InventoryItem>? inventory,
    List<String>? purchasedBoostItemIds,
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
      playerDefense: playerDefense ?? this.playerDefense,
      gold: gold ?? this.gold,
      inventory: inventory ?? this.inventory,
      purchasedBoostItemIds:
          purchasedBoostItemIds ?? this.purchasedBoostItemIds,
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
    if (item.isPassiveBoost && hasPurchasedBoost(item.id)) {
      return this;
    }

    if (gold < price) return this;

    var updatedProgress = copyWith(gold: gold - price);

    // If item is a passive boost (scroll), apply immediately and don't add to inventory
    if (item.isPassiveBoost) {
      var newProgress = updatedProgress;

      if (item.attackBoost != null) {
        newProgress = newProgress.copyWith(
          playerAttack: newProgress.playerAttack + item.attackBoost!,
        );
      }
      if (item.skillBoost != null) {
        newProgress = newProgress.copyWith(
          playerSkill: newProgress.playerSkill + item.skillBoost!,
        );
      }
      if (item.defenseBoost != null) {
        newProgress = newProgress.copyWith(
          playerDefense: newProgress.playerDefense + item.defenseBoost!,
        );
      }

      final newPurchased = List<String>.from(purchasedBoostItemIds)
        ..add(item.id);

      return newProgress.copyWith(purchasedBoostItemIds: newPurchased);
    }

    // Otherwise, add to inventory (potions)
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

    return updatedProgress.copyWith(inventory: newInventory);
  }

  // Helper untuk use item (only for consumable potions)
  GameProgress useItem(String itemId) {
    final itemIndex = inventory.indexWhere((inv) => inv.itemId == itemId);
    if (itemIndex < 0) return this;

    final inventoryItem = inventory[itemIndex];
    final item = Item.allItems.firstWhere((i) => i.id == itemId);

    // Only allow using consumable items (potions)
    if (!item.isConsumable) return this;

    var newProgress = this;

    // Apply consumable effects (HP/MP restore only)
    if (item.hpRestore != null) {
      newProgress = newProgress.restoreHp(item.hpRestore!);
    }
    if (item.mpRestore != null) {
      newProgress = newProgress.restoreMp(item.mpRestore!);
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

  bool hasPurchasedBoost(String itemId) {
    return purchasedBoostItemIds.contains(itemId);
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
